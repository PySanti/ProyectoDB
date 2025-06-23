-- =====================================================
-- SISTEMA DE CARRITO DE COMPRAS - REFACTORIZADO
-- =====================================================
-- Este sistema usa Stored Procedures para acciones (CUD)
-- y Funciones para consultas (R).

-- =====================================================
-- INSERTAR ESTATUS NECESARIO PARA EL CARRITO
-- =====================================================

-- Agregar estatus "Pendiente" para carritos (si no existe)
INSERT INTO Estatus (id_estatus, nombre) VALUES 
(13, 'Pendiente')
ON CONFLICT (id_estatus) DO NOTHING;

-- =====================================================
-- FUNCIÓN AUXILIAR PARA OBTENER O CREAR CARRITO
-- (Se mantiene como función porque retorna un valor directo)
-- =====================================================

CREATE OR REPLACE FUNCTION obtener_o_crear_carrito_usuario(p_id_usuario INTEGER)
RETURNS INTEGER AS $$
DECLARE
    v_id_compra INTEGER;
    v_estatus_pendiente INTEGER := 13; -- ID del estatus "Pendiente"
BEGIN
    -- Buscar si el usuario ya tiene un carrito pendiente
    SELECT c.id_compra INTO v_id_compra
    FROM Compra c
    JOIN Compra_Estatus ce ON c.id_compra = ce.compra_id_compra
    WHERE c.usuario_id_usuario = p_id_usuario 
    AND ce.estatus_id_estatus = v_estatus_pendiente
    AND ce.fecha_hora_fin > CURRENT_TIMESTAMP;
    
    -- Si no existe carrito pendiente, crear uno nuevo
    IF v_id_compra IS NULL THEN
        -- Se asume que la tienda física tiene el ID 1.
        INSERT INTO Compra (usuario_id_usuario, monto_total, tienda_fisica_id_tienda)
        VALUES (p_id_usuario, 0, 1)
        RETURNING id_compra INTO v_id_compra;
        
        -- Asignar estatus "Pendiente" al carrito
        INSERT INTO Compra_Estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion, fecha_hora_fin)
        VALUES (v_id_compra, v_estatus_pendiente, CURRENT_TIMESTAMP, '9999-12-31 23:59:59');
    END IF;
    
    RETURN v_id_compra;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- FUNCIÓN (antes Procedimiento) PARA AGREGAR PRODUCTO AL CARRITO
-- =====================================================

DROP FUNCTION IF EXISTS agregar_al_carrito(INTEGER, INTEGER, INTEGER);
CREATE OR REPLACE FUNCTION agregar_al_carrito(
    p_id_usuario INTEGER,
    p_id_inventario INTEGER,
    p_cantidad INTEGER
)
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
    v_stock_disponible INTEGER;
    v_producto_existe BOOLEAN;
    v_usuario_existe BOOLEAN;
    v_id_compra INTEGER;
    v_precio_unitario DECIMAL;
    v_producto_ya_en_carrito BOOLEAN;
    v_cantidad_actual INTEGER;
BEGIN
    -- Verificar que el usuario existe
    SELECT EXISTS(SELECT 1 FROM Usuario WHERE id_usuario = p_id_usuario) INTO v_usuario_existe;
    IF NOT v_usuario_existe THEN
        RAISE EXCEPTION 'Usuario no encontrado';
    END IF;

    -- Verificar que el producto existe en inventario
    SELECT EXISTS(SELECT 1 FROM Inventario WHERE id_inventario = p_id_inventario) INTO v_producto_existe;
    IF NOT v_producto_existe THEN
        RAISE EXCEPTION 'Producto no encontrado';
    END IF;

    -- Verificar stock disponible
    SELECT cantidad INTO v_stock_disponible 
    FROM Inventario 
    WHERE id_inventario = p_id_inventario;
    
    IF v_stock_disponible < p_cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente. Disponible: %', v_stock_disponible;
    END IF;

    -- Obtener o crear carrito del usuario
    v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario);

    -- Verificar si el producto ya está en el carrito
    SELECT EXISTS(SELECT 1 FROM Detalle_Compra WHERE id_compra = v_id_compra AND id_inventario = p_id_inventario) 
    INTO v_producto_ya_en_carrito;

    -- Obtener precio unitario
    SELECT precio INTO v_precio_unitario
    FROM presentacion_cerveza
    WHERE id_cerveza = (SELECT i.id_cerveza FROM inventario i WHERE i.id_inventario = p_id_inventario)
      AND id_presentacion = (SELECT i.id_presentacion FROM inventario i WHERE i.id_inventario = p_id_inventario);

    -- Si no se encuentra el precio, usar 0 como valor por defecto
    IF v_precio_unitario IS NULL THEN
        v_precio_unitario := 0;
    END IF;

    -- Insertar o actualizar detalle de compra
    IF v_producto_ya_en_carrito THEN
        UPDATE Detalle_Compra 
        SET cantidad = cantidad + p_cantidad
        WHERE id_compra = v_id_compra AND id_inventario = p_id_inventario
        RETURNING cantidad INTO v_cantidad_actual;
    ELSE
        INSERT INTO Detalle_Compra (precio_unitario, cantidad, id_inventario, id_compra)
        VALUES (v_precio_unitario, p_cantidad, p_id_inventario, v_id_compra);
    END IF;
END;
$$;

-- =====================================================
-- FUNCIÓN (CONSULTA) PARA OBTENER EL CARRITO
-- =====================================================

CREATE OR REPLACE FUNCTION obtener_carrito_usuario(p_id_usuario INTEGER)
RETURNS TABLE (
    id_compra INTEGER,
    id_inventario INTEGER,
    id_cerveza INTEGER,
    nombre_cerveza VARCHAR(50),
    id_presentacion INTEGER,
    nombre_presentacion VARCHAR(50),
    cantidad INTEGER,
    precio_unitario DECIMAL,
    subtotal DECIMAL,
    stock_disponible INTEGER
) AS $$
DECLARE
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario);
    
    IF v_id_compra IS NULL THEN
        RETURN;
    END IF;

    RETURN QUERY
    SELECT 
        dc.id_compra,
        dc.id_inventario,
        i.id_cerveza,
        c.nombre_cerveza,
        i.id_presentacion,
        p.nombre AS nombre_presentacion,
        dc.cantidad,
        dc.precio_unitario,
        (dc.cantidad * dc.precio_unitario) AS subtotal,
        i.cantidad AS stock_disponible
    FROM Detalle_Compra dc
    JOIN Inventario i ON dc.id_inventario = i.id_inventario
    JOIN Cerveza c ON i.id_cerveza = c.id_cerveza
    JOIN Presentacion p ON i.id_presentacion = p.id_presentacion
    WHERE dc.id_compra = v_id_compra
    ORDER BY c.nombre_cerveza;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- FUNCIÓN (antes Procedimiento) PARA ACTUALIZAR CANTIDAD
-- =====================================================

DROP FUNCTION IF EXISTS actualizar_cantidad_carrito(INTEGER, INTEGER, INTEGER);
CREATE OR REPLACE FUNCTION actualizar_cantidad_carrito(
    p_id_usuario INTEGER,
    p_id_inventario INTEGER,
    p_nueva_cantidad INTEGER
)
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
    v_stock_disponible INTEGER;
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario);
    
    IF v_id_compra IS NULL THEN
        RAISE EXCEPTION 'No se encontró carrito';
    END IF;

    SELECT cantidad INTO v_stock_disponible 
    FROM Inventario 
    WHERE id_inventario = p_id_inventario;
    
    IF v_stock_disponible < p_nueva_cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente';
    END IF;

    UPDATE Detalle_Compra 
    SET cantidad = p_nueva_cantidad
    WHERE id_compra = v_id_compra AND id_inventario = p_id_inventario;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Producto no encontrado en el carrito';
    END IF;
END;
$$;

-- =====================================================
-- FUNCIÓN (antes Procedimiento) PARA ELIMINAR PRODUCTO
-- =====================================================

DROP FUNCTION IF EXISTS eliminar_del_carrito(INTEGER, INTEGER);
CREATE OR REPLACE FUNCTION eliminar_del_carrito(
    p_id_usuario INTEGER,
    p_id_inventario INTEGER
)
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario);
    
    IF v_id_compra IS NULL THEN
        RAISE EXCEPTION 'No se encontró carrito';
    END IF;

    DELETE FROM Detalle_Compra 
    WHERE id_compra = v_id_compra AND id_inventario = p_id_inventario;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Producto no encontrado en el carrito';
    END IF;
END;
$$;

-- =====================================================
-- FUNCIÓN (antes Procedimiento) PARA LIMPIAR EL CARRITO
-- =====================================================

DROP FUNCTION IF EXISTS limpiar_carrito_usuario(INTEGER);
CREATE OR REPLACE FUNCTION limpiar_carrito_usuario(
    p_id_usuario INTEGER
)
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario);
    
    IF v_id_compra IS NULL THEN
        RAISE EXCEPTION 'No se encontró carrito';
    END IF;

    DELETE FROM Detalle_Compra WHERE id_compra = v_id_compra;
END;
$$;


-- =====================================================
-- FUNCIÓN (CONSULTA) PARA OBTENER RESUMEN
-- =====================================================

CREATE OR REPLACE FUNCTION obtener_resumen_carrito(p_id_usuario INTEGER)
RETURNS TABLE (
    id_compra INTEGER,
    total_productos INTEGER,
    total_items INTEGER,
    monto_total DECIMAL,
    items_carrito JSON
) AS $$
DECLARE
    v_id_compra INTEGER;
    v_items JSON;
BEGIN
    v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario);
    
    IF v_id_compra IS NULL THEN
        RETURN QUERY
        SELECT NULL::INTEGER, 0::INTEGER, 0::INTEGER, 0::DECIMAL, '[]'::json;
        RETURN;
    END IF;

    -- Obtener los items del carrito
    SELECT json_agg(json_build_object(
            'id_inventario', dc.id_inventario, 
            'nombre_cerveza', c.nombre_cerveza,
            'nombre_presentacion', p.nombre, 
            'cantidad', dc.cantidad,
            'precio_unitario', dc.precio_unitario, 
            'subtotal', (dc.cantidad * dc.precio_unitario)
        )) INTO v_items
    FROM Detalle_Compra dc
    JOIN Inventario i ON dc.id_inventario = i.id_inventario
    JOIN Cerveza c ON i.id_cerveza = c.id_cerveza
    JOIN Presentacion p ON i.id_presentacion = p.id_presentacion
    WHERE dc.id_compra = v_id_compra;

    -- Si no hay items, devolver valores por defecto
    IF v_items IS NULL THEN
        RETURN QUERY
        SELECT v_id_compra, 0::INTEGER, 0::INTEGER, 0::DECIMAL, '[]'::json;
        RETURN;
    END IF;

    -- Devolver el resumen con los items
    RETURN QUERY
    SELECT 
        v_id_compra,
        COUNT(DISTINCT dc.id_inventario)::INTEGER,
        COALESCE(SUM(dc.cantidad), 0)::INTEGER,
        COALESCE(SUM(dc.cantidad * dc.precio_unitario), 0),
        v_items
    FROM Detalle_Compra dc
    WHERE dc.id_compra = v_id_compra;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- FUNCIÓN (CONSULTA) PARA VERIFICAR STOCK
-- =====================================================

CREATE OR REPLACE FUNCTION verificar_stock_carrito(p_id_usuario INTEGER)
RETURNS TABLE (
    id_inventario INTEGER,
    nombre_cerveza VARCHAR(50),
    nombre_presentacion VARCHAR(40),
    cantidad_solicitada INTEGER,
    stock_disponible INTEGER,
    stock_suficiente BOOLEAN
) AS $$
DECLARE
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario);
    
    IF v_id_compra IS NULL THEN
        RETURN;
    END IF;

    RETURN QUERY
    SELECT 
        dc.id_inventario,
        c.nombre_cerveza,
        p.nombre AS nombre_presentacion,
        dc.cantidad AS cantidad_solicitada,
        i.cantidad AS stock_disponible,
        (i.cantidad >= dc.cantidad) AS stock_suficiente
    FROM Detalle_Compra dc
    JOIN Inventario i ON dc.id_inventario = i.id_inventario
    JOIN Cerveza c ON i.id_cerveza = c.id_cerveza
    JOIN Presentacion p ON i.id_presentacion = p.id_presentacion
    WHERE dc.id_compra = v_id_compra
    ORDER BY stock_suficiente ASC, c.nombre_cerveza;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- COMENTARIOS DE DOCUMENTACIÓN (SIMPLIFICADO)
-- =====================================================

COMMENT ON FUNCTION obtener_o_crear_carrito_usuario IS 'Función: Obtiene o crea un carrito para el usuario.';
COMMENT ON FUNCTION agregar_al_carrito IS 'Función: Agrega un producto al carrito.';
COMMENT ON FUNCTION obtener_carrito_usuario IS 'Función: Obtiene los productos del carrito.';
COMMENT ON FUNCTION actualizar_cantidad_carrito IS 'Función: Actualiza la cantidad de un producto.';
COMMENT ON FUNCTION eliminar_del_carrito IS 'Función: Elimina un producto del carrito.';
COMMENT ON FUNCTION limpiar_carrito_usuario IS 'Función: Vacía el carrito del usuario.';
COMMENT ON FUNCTION obtener_resumen_carrito IS 'Función: Obtiene el resumen del carrito.';
COMMENT ON FUNCTION verificar_stock_carrito IS 'Función: Verifica el stock de los productos en el carrito.'; 