--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: actualizar_cantidad_carrito(integer, integer, integer, json); Type: PROCEDURE; Schema: public; Owner: daniel_bd
--

CREATE PROCEDURE public.actualizar_cantidad_carrito(IN p_id_usuario integer, IN p_id_inventario integer, IN p_nueva_cantidad integer, INOUT p_resultado json)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_stock_disponible INTEGER;
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario);
    
    IF v_id_compra IS NULL THEN
        p_resultado := json_build_object('success', false, 'message', 'No se encontr├│ carrito');
        RETURN;
    END IF;

    SELECT cantidad INTO v_stock_disponible 
    FROM Inventario 
    WHERE id_inventario = p_id_inventario;
    
    IF v_stock_disponible < p_nueva_cantidad THEN
        p_resultado := json_build_object('success', false, 'message', 'Stock insuficiente');
        RETURN;
    END IF;

    UPDATE Detalle_Compra 
    SET cantidad = p_nueva_cantidad
    WHERE id_compra = v_id_compra AND id_inventario = p_id_inventario;
    
    p_resultado := json_build_object('success', true, 'message', 'Cantidad actualizada');
END;
$$;


ALTER PROCEDURE public.actualizar_cantidad_carrito(IN p_id_usuario integer, IN p_id_inventario integer, IN p_nueva_cantidad integer, INOUT p_resultado json) OWNER TO daniel_bd;

--
-- Name: PROCEDURE actualizar_cantidad_carrito(IN p_id_usuario integer, IN p_id_inventario integer, IN p_nueva_cantidad integer, INOUT p_resultado json); Type: COMMENT; Schema: public; Owner: daniel_bd
--

COMMENT ON PROCEDURE public.actualizar_cantidad_carrito(IN p_id_usuario integer, IN p_id_inventario integer, IN p_nueva_cantidad integer, INOUT p_resultado json) IS 'Procedimiento: Actualiza la cantidad de un producto.';


--
-- Name: actualizar_cantidad_carrito(integer, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.actualizar_cantidad_carrito(p_id_usuario integer, p_id_inventario integer, p_nueva_cantidad integer, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_stock_disponible INTEGER;
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_carrito_por_tipo(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);
    
    IF v_id_compra IS NULL THEN
        RAISE EXCEPTION 'No se encontr├│ carrito';
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
    
    -- Actualizar el monto total de la compra
    PERFORM actualizar_monto_compra(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);
END;
$$;


ALTER FUNCTION public.actualizar_cantidad_carrito(p_id_usuario integer, p_id_inventario integer, p_nueva_cantidad integer, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: actualizar_cantidad_carrito_por_id(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.actualizar_cantidad_carrito_por_id(p_id_compra integer, p_id_inventario integer, p_nueva_cantidad integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF p_nueva_cantidad <= 0 THEN
        DELETE FROM Detalle_Compra WHERE id_compra = p_id_compra AND id_inventario = p_id_inventario;
    ELSE
        UPDATE Detalle_Compra 
        SET cantidad = p_nueva_cantidad 
        WHERE id_compra = p_id_compra AND id_inventario = p_id_inventario;
    END IF;
    
    -- Actualizar el monto total de la compra
    PERFORM actualizar_monto_compra_por_id(p_id_compra);
END;
$$;


ALTER FUNCTION public.actualizar_cantidad_carrito_por_id(p_id_compra integer, p_id_inventario integer, p_nueva_cantidad integer) OWNER TO daniel_bd;

--
-- Name: actualizar_monto_compra(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.actualizar_monto_compra(p_id_usuario integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INTEGER;
    v_monto_total DECIMAL;
BEGIN
    -- Obtener el carrito del usuario (compra web)
    v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario, NULL, NULL);
    
    IF v_id_compra IS NULL THEN
        RAISE EXCEPTION 'No se encontr├│ carrito para el usuario';
    END IF;
    
    -- Calcular el monto total de los detalles
    SELECT COALESCE(SUM(dc.cantidad * dc.precio_unitario), 0) INTO v_monto_total
    FROM Detalle_Compra dc
    WHERE dc.id_compra = v_id_compra;
    
    -- Actualizar el monto total en la tabla Compra
    UPDATE Compra 
    SET monto_total = v_monto_total
    WHERE id_compra = v_id_compra;
    
    RETURN v_monto_total;
END;
$$;


ALTER FUNCTION public.actualizar_monto_compra(p_id_usuario integer) OWNER TO daniel_bd;

--
-- Name: actualizar_monto_compra(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.actualizar_monto_compra(p_id_usuario integer, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INTEGER;
    v_monto_total DECIMAL;
BEGIN
    -- Obtener el carrito usando la funci├│n auxiliar
    v_id_compra := obtener_carrito_por_tipo(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);
    
    IF v_id_compra IS NULL THEN
        RAISE EXCEPTION 'No se encontr├│ carrito para el usuario';
    END IF;
    
    -- Calcular el monto total de los detalles
    SELECT COALESCE(SUM(dc.cantidad * dc.precio_unitario), 0) INTO v_monto_total
    FROM Detalle_Compra dc
    WHERE dc.id_compra = v_id_compra;
    
    -- Actualizar el monto total en la tabla Compra
    UPDATE Compra 
    SET monto_total = v_monto_total
    WHERE id_compra = v_id_compra;
    
    RETURN v_monto_total;
END;
$$;


ALTER FUNCTION public.actualizar_monto_compra(p_id_usuario integer, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: actualizar_monto_compra_por_id(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.actualizar_monto_compra_por_id(p_id_compra integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_monto_total DECIMAL;
BEGIN
    -- Calcular el monto total de los detalles
    SELECT COALESCE(SUM(dc.cantidad * dc.precio_unitario), 0) INTO v_monto_total
    FROM Detalle_Compra dc
    WHERE dc.id_compra = p_id_compra;
    
    -- Actualizar el monto total en la tabla Compra
    UPDATE Compra 
    SET monto_total = v_monto_total
    WHERE id_compra = p_id_compra;
    
    RETURN v_monto_total;
END;
$$;


ALTER FUNCTION public.actualizar_monto_compra_por_id(p_id_compra integer) OWNER TO daniel_bd;

--
-- Name: acumular_puntos_compra_fisica(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.acumular_puntos_compra_fisica(p_id_compra integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_cliente_natural INTEGER;
    v_id_cliente_juridico INTEGER;
    v_monto_total DECIMAL;
    v_puntos_ganados INTEGER;
    v_id_metodo_punto INTEGER;
    v_tasa_actual DECIMAL;
    v_punto_existente INTEGER;
BEGIN
    -- Obtener informaci├│n de la compra
    SELECT 
        c.id_cliente_natural,
        c.id_cliente_juridico,
        c.monto_total
    INTO v_id_cliente_natural, v_id_cliente_juridico, v_monto_total
    FROM Compra c
    WHERE c.id_compra = p_id_compra;
    
    -- Solo acumular puntos para clientes naturales en compras f├¡sicas
    IF v_id_cliente_natural IS NULL OR v_monto_total IS NULL OR v_monto_total <= 0 THEN
        RETURN 0;
    END IF;
    
    -- Calcular puntos ganados (1 punto por compra, no por monto)
    v_puntos_ganados := 1;
    
    -- Buscar si ya existe un m├⌐todo de pago de tipo Punto para este cliente
    SELECT p.id_metodo INTO v_punto_existente
    FROM Punto p
    JOIN Metodo_Pago mp ON p.id_metodo = mp.id_metodo
    WHERE mp.id_cliente_natural = v_id_cliente_natural
    LIMIT 1;
    
    -- Si no existe, crear uno nuevo usando la funci├│n espec├¡fica
    IF v_punto_existente IS NULL THEN
        -- Usar la funci├│n espec├¡fica para crear m├⌐todo de pago de puntos
        v_id_metodo_punto := crear_metodo_pago_puntos('Tienda Fisica', v_id_cliente_natural, NULL);
    ELSE
        v_id_metodo_punto := v_punto_existente;
    END IF;
    
    -- Registrar el movimiento de puntos ganados
    INSERT INTO Punto_Cliente (
        id_cliente_natural, 
        id_metodo, 
        cantidad_mov, 
        fecha, 
        tipo_movimiento
    ) VALUES (
        v_id_cliente_natural,
        v_id_metodo_punto,
        v_puntos_ganados,
        CURRENT_DATE,
        'GANADO'
    );
    
    RETURN v_puntos_ganados;
END;
$$;


ALTER FUNCTION public.acumular_puntos_compra_fisica(p_id_compra integer) OWNER TO daniel_bd;

--
-- Name: agregar_al_carrito(integer, integer, integer, json); Type: PROCEDURE; Schema: public; Owner: daniel_bd
--

CREATE PROCEDURE public.agregar_al_carrito(IN p_id_usuario integer, IN p_id_inventario integer, IN p_cantidad integer, INOUT p_resultado json)
    LANGUAGE plpgsql
    AS $$
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
        p_resultado := json_build_object('success', false, 'message', 'Usuario no encontrado');
        RETURN;
    END IF;

    -- Verificar que el producto existe en inventario
    SELECT EXISTS(SELECT 1 FROM Inventario WHERE id_inventario = p_id_inventario) INTO v_producto_existe;
    IF NOT v_producto_existe THEN
        p_resultado := json_build_object('success', false, 'message', 'Producto no encontrado');
        RETURN;
    END IF;

    -- Verificar stock disponible
    SELECT cantidad INTO v_stock_disponible 
    FROM Inventario 
    WHERE id_inventario = p_id_inventario;
    
    IF v_stock_disponible < p_cantidad THEN
        p_resultado := json_build_object('success', false, 'message', 'Stock insuficiente. Disponible: ' || v_stock_disponible);
        RETURN;
    END IF;

    -- Obtener o crear carrito del usuario
    v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario);

    -- Verificar si el producto ya est├í en el carrito
    SELECT EXISTS(SELECT 1 FROM Detalle_Compra WHERE id_compra = v_id_compra AND id_inventario = p_id_inventario) 
    INTO v_producto_ya_en_carrito;

    -- Obtener precio unitario
    SELECT COALESCE(pc.cantidad, 0) INTO v_precio_unitario
    FROM Inventario i
    LEFT JOIN Presentacion_Cerveza pc ON (i.id_presentacion = pc.id_presentacion AND i.id_cerveza = pc.id_cerveza)
    WHERE i.id_inventario = p_id_inventario;

    -- Insertar o actualizar detalle de compra
    IF v_producto_ya_en_carrito THEN
        UPDATE Detalle_Compra 
        SET cantidad = cantidad + p_cantidad
        WHERE id_compra = v_id_compra AND id_inventario = p_id_inventario
        RETURNING cantidad INTO v_cantidad_actual;
        
        p_resultado := json_build_object('success', true, 'message', 'Cantidad actualizada', 'cantidad_total', v_cantidad_actual);
    ELSE
        INSERT INTO Detalle_Compra (precio_unitario, cantidad, id_inventario, id_compra)
        VALUES (v_precio_unitario, p_cantidad, p_id_inventario, v_id_compra);
        
        p_resultado := json_build_object('success', true, 'message', 'Producto agregado al carrito');
    END IF;
END;
$$;


ALTER PROCEDURE public.agregar_al_carrito(IN p_id_usuario integer, IN p_id_inventario integer, IN p_cantidad integer, INOUT p_resultado json) OWNER TO daniel_bd;

--
-- Name: PROCEDURE agregar_al_carrito(IN p_id_usuario integer, IN p_id_inventario integer, IN p_cantidad integer, INOUT p_resultado json); Type: COMMENT; Schema: public; Owner: daniel_bd
--

COMMENT ON PROCEDURE public.agregar_al_carrito(IN p_id_usuario integer, IN p_id_inventario integer, IN p_cantidad integer, INOUT p_resultado json) IS 'Procedimiento: Agrega un producto al carrito.';


--
-- Name: agregar_al_carrito(integer, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.agregar_al_carrito(p_id_usuario integer, p_id_inventario integer, p_cantidad integer, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_stock_disponible INTEGER;
    v_producto_existe BOOLEAN;
    v_usuario_existe BOOLEAN;
    v_id_compra INTEGER;
    v_precio_unitario DECIMAL;
    v_producto_ya_en_carrito BOOLEAN;
    v_cantidad_actual INTEGER;
    v_es_compra_web BOOLEAN;
    v_id_empleado INTEGER;
BEGIN
    -- Determinar si es compra web o tienda f├¡sica
    v_es_compra_web := (p_id_cliente_natural IS NULL AND p_id_cliente_juridico IS NULL);
    
    -- Verificar que el usuario existe (solo para compra web)
    IF v_es_compra_web THEN
        SELECT EXISTS(SELECT 1 FROM Usuario WHERE id_usuario = p_id_usuario) INTO v_usuario_existe;
        IF NOT v_usuario_existe THEN
            RAISE EXCEPTION 'Usuario no encontrado';
        END IF;
    END IF;

    -- Obtener el empleado asociado al usuario (solo para compras f├¡sicas)
    IF NOT v_es_compra_web THEN
        SELECT empleado_id INTO v_id_empleado
        FROM Usuario 
        WHERE id_usuario = p_id_usuario;
        
        -- Si no hay empleado asociado, usar NULL (venta sin empleado)
        IF v_id_empleado IS NULL THEN
            v_id_empleado := NULL;
        END IF;
    ELSE
        -- Para compras web, no hay empleado asociado
        v_id_empleado := NULL;
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

    -- Obtener o crear carrito usando la funci├│n auxiliar
    v_id_compra := obtener_carrito_por_tipo(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);

    -- Verificar si el producto ya est├í en el carrito
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
        INSERT INTO Detalle_Compra (precio_unitario, cantidad, id_inventario, id_compra, id_empleado)
        VALUES (v_precio_unitario, p_cantidad, p_id_inventario, v_id_compra, v_id_empleado);
    END IF;
    
    -- Actualizar el monto total de la compra
    PERFORM actualizar_monto_compra(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);
END;
$$;


ALTER FUNCTION public.agregar_al_carrito(p_id_usuario integer, p_id_inventario integer, p_cantidad integer, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: agregar_al_carrito_por_producto(integer, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.agregar_al_carrito_por_producto(p_id_usuario integer, p_nombre_cerveza character varying, p_nombre_presentacion character varying, p_cantidad integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_inventario INTEGER;
BEGIN
    -- Buscar el inventario correcto por nombre y presentaci├│n
    v_id_inventario := buscar_inventario_por_producto(p_nombre_cerveza, p_nombre_presentacion);
    
    IF v_id_inventario IS NULL THEN
        RAISE EXCEPTION 'Producto no encontrado o sin stock disponible';
    END IF;
    
    -- Llamar a la funci├│n original con el id_inventario correcto
    PERFORM agregar_al_carrito(p_id_usuario, v_id_inventario, p_cantidad);
END;
$$;


ALTER FUNCTION public.agregar_al_carrito_por_producto(p_id_usuario integer, p_nombre_cerveza character varying, p_nombre_presentacion character varying, p_cantidad integer) OWNER TO daniel_bd;

--
-- Name: agregar_al_carrito_por_producto(integer, character varying, character varying, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.agregar_al_carrito_por_producto(p_id_usuario integer, p_nombre_cerveza character varying, p_nombre_presentacion character varying, p_cantidad integer, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_inventario INTEGER;
BEGIN
    -- Buscar el inventario correcto por nombre y presentaci├│n
    v_id_inventario := buscar_inventario_por_producto(p_nombre_cerveza, p_nombre_presentacion);
    
    IF v_id_inventario IS NULL THEN
        RAISE EXCEPTION 'Producto no encontrado o sin stock disponible';
    END IF;
    
    -- Llamar a la funci├│n original con el id_inventario correcto
    PERFORM agregar_al_carrito(p_id_usuario, v_id_inventario, p_cantidad, p_id_cliente_natural, p_id_cliente_juridico);
END;
$$;


ALTER FUNCTION public.agregar_al_carrito_por_producto(p_id_usuario integer, p_nombre_cerveza character varying, p_nombre_presentacion character varying, p_cantidad integer, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: agregar_al_carrito_por_producto(integer, character varying, character varying, integer, character varying, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.agregar_al_carrito_por_producto(p_id_usuario integer, p_nombre_cerveza character varying, p_nombre_presentacion character varying, p_cantidad integer, p_tipo_venta character varying, p_id_ubicacion integer DEFAULT NULL::integer, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_cerveza INTEGER;
    v_id_presentacion INTEGER;
    v_id_inventario INTEGER;
BEGIN
    -- Buscar IDs de cerveza y presentaci├│n
    SELECT id_cerveza INTO v_id_cerveza FROM Cerveza WHERE nombre_cerveza = p_nombre_cerveza;
    IF v_id_cerveza IS NULL THEN
        RAISE EXCEPTION 'Cerveza no encontrada: %', p_nombre_cerveza;
    END IF;
    SELECT id_presentacion INTO v_id_presentacion FROM Presentacion WHERE nombre = p_nombre_presentacion;
    IF v_id_presentacion IS NULL THEN
        RAISE EXCEPTION 'Presentaci├│n no encontrada: %', p_nombre_presentacion;
    END IF;
    -- Buscar el inventario correcto seg├║n el tipo de venta
    v_id_inventario := buscar_id_inventario_para_venta(v_id_cerveza, v_id_presentacion, p_tipo_venta, p_id_ubicacion);
    -- Llamar a la funci├│n original con el id_inventario correcto
    PERFORM agregar_al_carrito(p_id_usuario, v_id_inventario, p_cantidad, p_id_cliente_natural, p_id_cliente_juridico);
END;
$$;


ALTER FUNCTION public.agregar_al_carrito_por_producto(p_id_usuario integer, p_nombre_cerveza character varying, p_nombre_presentacion character varying, p_cantidad integer, p_tipo_venta character varying, p_id_ubicacion integer, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: aplicar(); Type: PROCEDURE; Schema: public; Owner: daniel_bd
--

CREATE PROCEDURE public.aplicar()
    LANGUAGE plpgsql
    AS $$
begin

	
end;
$$;


ALTER PROCEDURE public.aplicar() OWNER TO daniel_bd;

--
-- Name: aplicar(character varying); Type: PROCEDURE; Schema: public; Owner: daniel_bd
--

CREATE PROCEDURE public.aplicar(IN nom_cerveza character varying)
    LANGUAGE plpgsql
    AS $$
begin

	

	
end;
$$;


ALTER PROCEDURE public.aplicar(IN nom_cerveza character varying) OWNER TO daniel_bd;

--
-- Name: aplicar(integer, integer); Type: PROCEDURE; Schema: public; Owner: daniel_bd
--

CREATE PROCEDURE public.aplicar(IN id_presentacion integer, IN id_cerveza integer)
    LANGUAGE plpgsql
    AS $$
begin

	INSERT INTO Descuento(porcentaje, id_presentacion, id_cerveza,id_promocion)
	VALUES(10, id_presentacion, id_cerveza, id_promocion);

	
end;
$$;


ALTER PROCEDURE public.aplicar(IN id_presentacion integer, IN id_cerveza integer) OWNER TO daniel_bd;

--
-- Name: buscar_id_inventario_para_venta(integer, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.buscar_id_inventario_para_venta(p_id_cerveza integer, p_id_presentacion integer, p_tipo_venta character varying, p_id_ubicacion integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_inventario INTEGER;
BEGIN
    IF p_tipo_venta = 'web' THEN
        -- Buscar inventario de tienda web (id_tienda_web = 1, id_ubicacion IS NULL)
        SELECT i.id_inventario INTO v_id_inventario
        FROM Inventario i
        WHERE i.id_cerveza = p_id_cerveza
          AND i.id_presentacion = p_id_presentacion
          AND i.id_tienda_web = 1
          AND i.id_ubicacion IS NULL
        LIMIT 1;
    ELSIF p_tipo_venta = 'fisica' THEN
        -- Si no se pasa id_ubicacion, tomar cualquier anaquel disponible
        IF p_id_ubicacion IS NULL THEN
            SELECT i.id_inventario INTO v_id_inventario
            FROM Inventario i
            WHERE i.id_cerveza = p_id_cerveza
              AND i.id_presentacion = p_id_presentacion
              AND i.id_ubicacion IS NOT NULL
            LIMIT 1;
        ELSE
            SELECT i.id_inventario INTO v_id_inventario
            FROM Inventario i
            WHERE i.id_cerveza = p_id_cerveza
              AND i.id_presentacion = p_id_presentacion
              AND i.id_ubicacion = p_id_ubicacion
            LIMIT 1;
        END IF;
    ELSE
        RAISE EXCEPTION 'Tipo de venta no v├ílido: %', p_tipo_venta;
    END IF;
    
    IF v_id_inventario IS NULL THEN
        RAISE EXCEPTION 'No se encontr├│ inventario para los par├ímetros dados';
    END IF;
    RETURN v_id_inventario;
END;
$$;


ALTER FUNCTION public.buscar_id_inventario_para_venta(p_id_cerveza integer, p_id_presentacion integer, p_tipo_venta character varying, p_id_ubicacion integer) OWNER TO daniel_bd;

--
-- Name: buscar_inventario_por_producto(character varying, character varying); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.buscar_inventario_por_producto(p_nombre_cerveza character varying, p_nombre_presentacion character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_inventario INTEGER;
BEGIN
    SELECT i.id_inventario INTO v_id_inventario
    FROM Inventario i
    JOIN Cerveza c ON i.id_cerveza = c.id_cerveza
    JOIN Presentacion p ON i.id_presentacion = p.id_presentacion
    WHERE c.nombre_cerveza = p_nombre_cerveza 
      AND p.nombre = p_nombre_presentacion
      AND i.cantidad > 0
    LIMIT 1;
    
    RETURN v_id_inventario;
END;
$$;


ALTER FUNCTION public.buscar_inventario_por_producto(p_nombre_cerveza character varying, p_nombre_presentacion character varying) OWNER TO daniel_bd;

--
-- Name: cantidadunidades(integer); Type: PROCEDURE; Schema: public; Owner: daniel_bd
--

CREATE PROCEDURE public.cantidadunidades(IN id_presentacion integer)
    LANGUAGE plpgsql
    AS $$
  BEGIN 
	select SUM(cantidad)
	from detalle_compra
	where id_inventario = id_presentacion;
  END
  $$;


ALTER PROCEDURE public.cantidadunidades(IN id_presentacion integer) OWNER TO daniel_bd;

--
-- Name: cerrar_carrito_pendiente(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.cerrar_carrito_pendiente(p_compra_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_now TIMESTAMP := NOW();
BEGIN
    UPDATE Compra_Estatus
    SET fecha_hora_fin = v_now
    WHERE compra_id_compra = p_compra_id
      AND fecha_hora_fin = '9999-12-31 23:59:59';
END;
$$;


ALTER FUNCTION public.cerrar_carrito_pendiente(p_compra_id integer) OWNER TO daniel_bd;

--
-- Name: cerrar_estatus_anterior_y_crear_pagado(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.cerrar_estatus_anterior_y_crear_pagado() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Solo actuar si el nuevo estatus es "pagado"
    IF (SELECT LOWER(nombre) FROM Estatus WHERE id_estatus = NEW.estatus_id_estatus) = 'pagado' THEN
        -- Cerrar TODOS los estatus abiertos (fecha_hora_fin = '9999-12-31 23:59:59') para esa compra, incluyendo el propio si ya exist├¡a
        UPDATE Compra_Estatus
        SET fecha_hora_fin = NEW.fecha_hora_asignacion
        WHERE compra_id_compra = NEW.compra_id_compra
          AND fecha_hora_fin = '9999-12-31 23:59:59';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.cerrar_estatus_anterior_y_crear_pagado() OWNER TO daniel_bd;

--
-- Name: check_cliente_exists(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.check_cliente_exists(p_documento integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verificar en clientes naturales
    IF EXISTS (SELECT 1 FROM Cliente_Natural WHERE ci_cliente = p_documento) THEN
        RETURN TRUE;
    END IF;
    
    -- Verificar en clientes jur├¡dicos
    IF EXISTS (SELECT 1 FROM Cliente_Juridico WHERE rif_cliente = p_documento) THEN
        RETURN TRUE;
    END IF;
    
    RETURN FALSE;
END;
$$;


ALTER FUNCTION public.check_cliente_exists(p_documento integer) OWNER TO daniel_bd;

--
-- Name: check_cliente_exists(character varying); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.check_cliente_exists(p_documento character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verificar en clientes naturales
    IF EXISTS (SELECT 1 FROM cliente_natural WHERE cedula = p_documento) THEN
        RETURN TRUE;
    END IF;
    
    -- Verificar en clientes jur├¡dicos
    IF EXISTS (SELECT 1 FROM cliente_juridico WHERE rif = p_documento) THEN
        RETURN TRUE;
    END IF;
    
    RETURN FALSE;
END;
$$;


ALTER FUNCTION public.check_cliente_exists(p_documento character varying) OWNER TO daniel_bd;

--
-- Name: contar_productos_catalogo(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.contar_productos_catalogo() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    total INTEGER;
BEGIN
    SELECT COUNT(DISTINCT c.id_cerveza) INTO total
    FROM Cerveza c
    JOIN presentacion_cerveza pc ON c.id_cerveza = pc.id_cerveza
    JOIN Inventario i ON c.id_cerveza = i.id_cerveza AND pc.id_presentacion = i.id_presentacion;
    
    RETURN total;
END;
$$;


ALTER FUNCTION public.contar_productos_catalogo() OWNER TO daniel_bd;

--
-- Name: crear_metodo_pago_cheque(character varying, character varying, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.crear_metodo_pago_cheque(p_num_cheque character varying, p_num_cuenta character varying, p_banco character varying, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_metodo INTEGER;
BEGIN
    -- 1. Crear registro en el supertipo usando la funci├│n autom├ítica
    SELECT insertar_metodo_pago_automatico(p_id_cliente_natural, p_id_cliente_juridico) INTO v_id_metodo;
    
    -- 2. Crear registro en el subtipo
    INSERT INTO Cheque (id_metodo, num_cheque, num_cuenta, banco)
    VALUES (v_id_metodo, p_num_cheque, p_num_cuenta, p_banco);
    
    RETURN v_id_metodo;
END;
$$;


ALTER FUNCTION public.crear_metodo_pago_cheque(p_num_cheque character varying, p_num_cuenta character varying, p_banco character varying, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: FUNCTION crear_metodo_pago_cheque(p_num_cheque character varying, p_num_cuenta character varying, p_banco character varying, p_id_cliente_natural integer, p_id_cliente_juridico integer); Type: COMMENT; Schema: public; Owner: daniel_bd
--

COMMENT ON FUNCTION public.crear_metodo_pago_cheque(p_num_cheque character varying, p_num_cuenta character varying, p_banco character varying, p_id_cliente_natural integer, p_id_cliente_juridico integer) IS 'Funci├│n: Crea un m├⌐todo de pago tipo cheque con patr├│n supertipo-subtipo';


--
-- Name: crear_metodo_pago_efectivo(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.crear_metodo_pago_efectivo(p_denominacion integer, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_metodo INTEGER;
BEGIN
    -- 1. Crear registro en el supertipo usando la funci├│n autom├ítica
    SELECT insertar_metodo_pago_automatico(p_id_cliente_natural, p_id_cliente_juridico) INTO v_id_metodo;
    
    -- 2. Crear registro en el subtipo
    INSERT INTO Efectivo (id_metodo, denominacion)
    VALUES (v_id_metodo, p_denominacion);
    
    RETURN v_id_metodo;
END;
$$;


ALTER FUNCTION public.crear_metodo_pago_efectivo(p_denominacion integer, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: FUNCTION crear_metodo_pago_efectivo(p_denominacion integer, p_id_cliente_natural integer, p_id_cliente_juridico integer); Type: COMMENT; Schema: public; Owner: daniel_bd
--

COMMENT ON FUNCTION public.crear_metodo_pago_efectivo(p_denominacion integer, p_id_cliente_natural integer, p_id_cliente_juridico integer) IS 'Funci├│n: Crea un m├⌐todo de pago tipo efectivo con patr├│n supertipo-subtipo';


--
-- Name: crear_metodo_pago_puntos(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.crear_metodo_pago_puntos(p_origen character varying, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_metodo INTEGER;
BEGIN
    -- Validar que al menos un cliente est├⌐ especificado
    IF p_id_cliente_natural IS NULL AND p_id_cliente_juridico IS NULL THEN
        RAISE EXCEPTION 'Debe especificar al menos un cliente (natural o jur├¡dico)';
    END IF;
    
    -- 1. Crear registro en el supertipo usando la funci├│n autom├ítica
    SELECT insertar_metodo_pago_automatico(p_id_cliente_natural, p_id_cliente_juridico) INTO v_id_metodo;
    
    -- 2. Crear registro en el subtipo
    INSERT INTO Punto (id_metodo, origen)
    VALUES (v_id_metodo, p_origen);
    
    RETURN v_id_metodo;
END;
$$;


ALTER FUNCTION public.crear_metodo_pago_puntos(p_origen character varying, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: FUNCTION crear_metodo_pago_puntos(p_origen character varying, p_id_cliente_natural integer, p_id_cliente_juridico integer); Type: COMMENT; Schema: public; Owner: daniel_bd
--

COMMENT ON FUNCTION public.crear_metodo_pago_puntos(p_origen character varying, p_id_cliente_natural integer, p_id_cliente_juridico integer) IS 'Funci├│n: Crea un m├⌐todo de pago tipo puntos con patr├│n supertipo-subtipo';


--
-- Name: crear_metodo_pago_tarjeta_credito(character varying, character varying, character varying, date, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.crear_metodo_pago_tarjeta_credito(p_tipo character varying, p_numero character varying, p_banco character varying, p_fecha_vencimiento date, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_metodo INTEGER;
BEGIN
    -- 1. Crear registro en el supertipo usando la funci├│n autom├ítica
    SELECT insertar_metodo_pago_automatico(p_id_cliente_natural, p_id_cliente_juridico) INTO v_id_metodo;
    
    -- 2. Crear registro en el subtipo
    INSERT INTO Tarjeta_Credito (id_metodo, tipo, numero, banco, fecha_vencimiento)
    VALUES (v_id_metodo, p_tipo, p_numero, p_banco, p_fecha_vencimiento);
    
    RETURN v_id_metodo;
END;
$$;


ALTER FUNCTION public.crear_metodo_pago_tarjeta_credito(p_tipo character varying, p_numero character varying, p_banco character varying, p_fecha_vencimiento date, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: FUNCTION crear_metodo_pago_tarjeta_credito(p_tipo character varying, p_numero character varying, p_banco character varying, p_fecha_vencimiento date, p_id_cliente_natural integer, p_id_cliente_juridico integer); Type: COMMENT; Schema: public; Owner: daniel_bd
--

COMMENT ON FUNCTION public.crear_metodo_pago_tarjeta_credito(p_tipo character varying, p_numero character varying, p_banco character varying, p_fecha_vencimiento date, p_id_cliente_natural integer, p_id_cliente_juridico integer) IS 'Funci├│n: Crea un m├⌐todo de pago tipo tarjeta de cr├⌐dito con patr├│n supertipo-subtipo';


--
-- Name: crear_metodo_pago_tarjeta_debito(character varying, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.crear_metodo_pago_tarjeta_debito(p_numero character varying, p_banco character varying, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_metodo INTEGER;
BEGIN
    -- 1. Crear registro en el supertipo usando la funci├│n autom├ítica
    SELECT insertar_metodo_pago_automatico(p_id_cliente_natural, p_id_cliente_juridico) INTO v_id_metodo;
    
    -- 2. Crear registro en el subtipo
    INSERT INTO Tarjeta_Debito (id_metodo, numero, banco)
    VALUES (v_id_metodo, p_numero, p_banco);
    
    RETURN v_id_metodo;
END;
$$;


ALTER FUNCTION public.crear_metodo_pago_tarjeta_debito(p_numero character varying, p_banco character varying, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: FUNCTION crear_metodo_pago_tarjeta_debito(p_numero character varying, p_banco character varying, p_id_cliente_natural integer, p_id_cliente_juridico integer); Type: COMMENT; Schema: public; Owner: daniel_bd
--

COMMENT ON FUNCTION public.crear_metodo_pago_tarjeta_debito(p_numero character varying, p_banco character varying, p_id_cliente_natural integer, p_id_cliente_juridico integer) IS 'Funci├│n: Crea un m├⌐todo de pago tipo tarjeta de d├⌐bito con patr├│n supertipo-subtipo';


--
-- Name: create_cliente_juridico(integer, character varying, character varying, numeric, text, text, character varying, integer, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.create_cliente_juridico(p_rif_cliente integer, p_razon_social character varying, p_denominacion_comercial character varying, p_capital_disponible numeric, p_direccion_fiscal text, p_direccion_fisica text, p_pagina_web character varying, p_lugar_id_lugar integer, p_lugar_id_lugar2 integer, p_correo character varying, p_contrasena character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  new_cliente_id INTEGER;
  new_usuario_id INTEGER;
BEGIN
  INSERT INTO Cliente_Juridico (
    rif_cliente, razon_social, denominacion_comercial, capital_disponible, direccion_fiscal, direccion_fisica, pagina_web, lugar_id_lugar, lugar_id_lugar2
  ) VALUES (
    p_rif_cliente, p_razon_social, p_denominacion_comercial, p_capital_disponible, p_direccion_fiscal, p_direccion_fisica, p_pagina_web, p_lugar_id_lugar, p_lugar_id_lugar2
  ) RETURNING id_cliente INTO new_cliente_id;

  INSERT INTO Usuario (id_cliente_juridico, fecha_creacion, contrase├▒a)
  VALUES (new_cliente_id,  CURRENT_DATE, p_contrasena)
  RETURNING id_usuario INTO new_usuario_id;

  INSERT INTO Correo (nombre, extension_pag, id_cliente_juridico)
  VALUES (split_part(p_correo, '@', 1), split_part(p_correo, '@', 2), new_cliente_id);
END;
$$;


ALTER FUNCTION public.create_cliente_juridico(p_rif_cliente integer, p_razon_social character varying, p_denominacion_comercial character varying, p_capital_disponible numeric, p_direccion_fiscal text, p_direccion_fisica text, p_pagina_web character varying, p_lugar_id_lugar integer, p_lugar_id_lugar2 integer, p_correo character varying, p_contrasena character varying) OWNER TO daniel_bd;

--
-- Name: create_cliente_natural(integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, text); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.create_cliente_natural(p_cedula integer, p_rif integer, p_primer_nombre character varying, p_segundo_nombre character varying, p_primer_apellido character varying, p_segundo_apellido character varying, p_correo character varying, p_contrasena character varying, p_id_lugar integer, p_direccion_fisica text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  new_cliente_id INTEGER;
  new_usuario_id INTEGER;
BEGIN
  INSERT INTO Cliente_Natural (ci_cliente, rif_cliente , primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, lugar_id_lugar, direccion)
  VALUES (p_cedula, p_rif, p_primer_nombre, p_segundo_nombre, p_primer_apellido, p_segundo_apellido, p_id_lugar, p_direccion_fisica)
  RETURNING id_cliente INTO new_cliente_id;

  INSERT INTO Usuario (id_cliente_natural, fecha_creacion, contrase├▒a)
  VALUES (new_cliente_id,  CURRENT_DATE, p_contrasena)
  RETURNING id_usuario INTO new_usuario_id;

  INSERT INTO Correo (nombre, extension_pag, id_cliente_natural)
  VALUES (split_part(p_correo, '@', 1), split_part(p_correo, '@', 2), new_cliente_id);
END;
$$;


ALTER FUNCTION public.create_cliente_natural(p_cedula integer, p_rif integer, p_primer_nombre character varying, p_segundo_nombre character varying, p_primer_apellido character varying, p_segundo_apellido character varying, p_correo character varying, p_contrasena character varying, p_id_lugar integer, p_direccion_fisica text) OWNER TO daniel_bd;

--
-- Name: create_cliente_natural_fisica(integer, character varying, character varying, character varying, character varying, text, integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.create_cliente_natural_fisica(p_ci_cliente integer, p_primer_nombre character varying, p_segundo_nombre character varying, p_primer_apellido character varying, p_segundo_apellido character varying, p_direccion text, p_lugar_id_lugar integer, p_correo_nombre character varying, p_correo_extension character varying, p_telefono character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_cliente INTEGER;
BEGIN
    -- Verificar si el cliente ya existe
    IF EXISTS (SELECT 1 FROM Cliente_Natural WHERE ci_cliente = p_ci_cliente) THEN
        RAISE EXCEPTION 'Ya existe un cliente natural con la c├⌐dula %', p_ci_cliente;
    END IF;
    
    -- Crear el cliente natural
    INSERT INTO Cliente_Natural (
        ci_cliente, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, direccion, lugar_id_lugar
    ) VALUES (
        p_ci_cliente, p_primer_nombre, p_segundo_nombre, p_primer_apellido, p_segundo_apellido, p_direccion, p_lugar_id_lugar
    ) RETURNING id_cliente INTO v_id_cliente;
    
    -- Insertar correo
    INSERT INTO Correo (nombre, extension_pag, id_cliente_natural)
    VALUES (p_correo_nombre, p_correo_extension, v_id_cliente);
    
    -- Insertar tel├⌐fono
    INSERT INTO Telefono (numero, id_cliente_natural)
    VALUES (p_telefono, v_id_cliente);
    
    RETURN v_id_cliente;
END;
$$;


ALTER FUNCTION public.create_cliente_natural_fisica(p_ci_cliente integer, p_primer_nombre character varying, p_segundo_nombre character varying, p_primer_apellido character varying, p_segundo_apellido character varying, p_direccion text, p_lugar_id_lugar integer, p_correo_nombre character varying, p_correo_extension character varying, p_telefono character varying) OWNER TO daniel_bd;

--
-- Name: create_cliente_natural_fisica(integer, integer, character varying, character varying, character varying, character varying, text, integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.create_cliente_natural_fisica(p_ci_cliente integer, p_rif_cliente integer, p_primer_nombre character varying, p_segundo_nombre character varying, p_primer_apellido character varying, p_segundo_apellido character varying, p_direccion text, p_lugar_id_lugar integer, p_correo_nombre character varying, p_correo_extension character varying, p_telefono character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_cliente INTEGER;
BEGIN
    -- Verificar si el cliente ya existe
    IF EXISTS (SELECT 1 FROM Cliente_Natural WHERE ci_cliente = p_ci_cliente) THEN
        RAISE EXCEPTION 'Ya existe un cliente natural con la c├⌐dula %', p_ci_cliente;
    END IF;
    
    -- Crear el cliente natural
    INSERT INTO Cliente_Natural (
        ci_cliente, rif_cliente, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, direccion, lugar_id_lugar
    ) VALUES (
        p_ci_cliente, p_rif_cliente, p_primer_nombre, p_segundo_nombre, p_primer_apellido, p_segundo_apellido, p_direccion, p_lugar_id_lugar
    ) RETURNING id_cliente INTO v_id_cliente;
    
    -- Insertar correo
    INSERT INTO Correo (nombre, extension_pag, id_cliente_natural)
    VALUES (p_correo_nombre, p_correo_extension, v_id_cliente);
    
    -- Insertar tel├⌐fono
    INSERT INTO Telefono (numero, id_cliente_natural)
    VALUES (p_telefono, v_id_cliente);
    
    RETURN v_id_cliente;
END;
$$;


ALTER FUNCTION public.create_cliente_natural_fisica(p_ci_cliente integer, p_rif_cliente integer, p_primer_nombre character varying, p_segundo_nombre character varying, p_primer_apellido character varying, p_segundo_apellido character varying, p_direccion text, p_lugar_id_lugar integer, p_correo_nombre character varying, p_correo_extension character varying, p_telefono character varying) OWNER TO daniel_bd;

--
-- Name: create_cliente_natural_fisica(integer, integer, character varying, character varying, character varying, character varying, text, integer, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.create_cliente_natural_fisica(p_ci_cliente integer, p_rif_cliente integer, p_primer_nombre character varying, p_segundo_nombre character varying, p_primer_apellido character varying, p_segundo_apellido character varying, p_direccion text, p_lugar_id_lugar integer, p_correo_nombre character varying, p_correo_extension character varying, p_codigo_area character varying, p_telefono character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_cliente INTEGER;
BEGIN
    -- Verificar si el cliente ya existe
    IF EXISTS (SELECT 1 FROM Cliente_Natural WHERE ci_cliente = p_ci_cliente) THEN
        RAISE EXCEPTION 'Ya existe un cliente natural con la c├⌐dula %', p_ci_cliente;
    END IF;
    
    -- Crear el cliente natural
    INSERT INTO Cliente_Natural (
        ci_cliente, rif_cliente, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, direccion, lugar_id_lugar
    ) VALUES (
        p_ci_cliente, p_rif_cliente, p_primer_nombre, p_segundo_nombre, p_primer_apellido, p_segundo_apellido, p_direccion, p_lugar_id_lugar
    ) RETURNING id_cliente INTO v_id_cliente;
    
    -- Insertar correo
    INSERT INTO Correo (nombre, extension_pag, id_cliente_natural)
    VALUES (p_correo_nombre, p_correo_extension, v_id_cliente);
    
    -- Insertar tel├⌐fono
    INSERT INTO Telefono (codigo_area, numero, id_cliente_natural)
    VALUES (p_codigo_area, p_telefono, v_id_cliente);
    
    RETURN v_id_cliente;
END;
$$;


ALTER FUNCTION public.create_cliente_natural_fisica(p_ci_cliente integer, p_rif_cliente integer, p_primer_nombre character varying, p_segundo_nombre character varying, p_primer_apellido character varying, p_segundo_apellido character varying, p_direccion text, p_lugar_id_lugar integer, p_correo_nombre character varying, p_correo_extension character varying, p_codigo_area character varying, p_telefono character varying) OWNER TO daniel_bd;

--
-- Name: create_empleado(character varying, character varying, character varying, character varying, character varying, text, integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.create_empleado(p_cedula character varying, p_primer_nombre character varying, p_segundo_nombre character varying, p_primer_apellido character varying, p_segundo_apellido character varying, p_direccion text, p_lugar_id_lugar integer, p_correo_nombre character varying, p_correo_extension character varying, p_contrasena character varying) RETURNS TABLE(usuario_id integer, email character varying, nombre_completo character varying, cedula character varying, estado character varying, municipio character varying, parroquia character varying, direccion_especifica text, activo character, rol character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_empleado_id INTEGER;
    new_usuario_id INTEGER;
    rol_empleado_id INTEGER;
BEGIN
    SELECT id_rol INTO rol_empleado_id FROM Rol WHERE LOWER(nombre) = 'empleado nuevo';
    IF rol_empleado_id IS NULL THEN
        RAISE EXCEPTION 'No se encontr├│ el rol Empleado Nuevo en la tabla Rol';
    END IF;

    -- Insertar en Empleado
    INSERT INTO Empleado (
        cedula, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, direccion, activo, lugar_id_lugar
    ) VALUES (
        p_cedula, p_primer_nombre, p_segundo_nombre, p_primer_apellido, p_segundo_apellido, p_direccion, 'S', p_lugar_id_lugar
    ) RETURNING id_empleado INTO new_empleado_id;

    -- Insertar en Usuario
    INSERT INTO Usuario (
        empleado_id, id_rol, fecha_creacion, contrase├▒a
    ) VALUES (
        new_empleado_id, rol_empleado_id, CURRENT_DATE, p_contrasena
    ) RETURNING id_usuario INTO new_usuario_id;

    -- Insertar en Correo
    INSERT INTO Correo (
        nombre, extension_pag, id_empleado
    ) VALUES (
        p_correo_nombre, p_correo_extension, new_empleado_id
    );

    -- Retornar los datos completos del empleado reci├⌐n creado, incluyendo el nombre del rol
    RETURN QUERY
    SELECT
        u.id_usuario,
        CONCAT(cor.nombre, '@', cor.extension_pag)::VARCHAR(100) AS email,
        CONCAT(e.primer_nombre, ' ', e.segundo_nombre, ' ', e.primer_apellido, ' ', e.segundo_apellido)::VARCHAR(100) AS nombre_completo,
        e.cedula::VARCHAR(20) AS cedula,
        l_estado.nombre::VARCHAR(100) AS estado,
        l_municipio.nombre::VARCHAR(100) AS municipio,
        l_parroquia.nombre::VARCHAR(100) AS parroquia,
        e.direccion AS direccion_especifica,
        e.activo,
        r.nombre AS rol
    FROM Usuario u
    JOIN Empleado e ON u.empleado_id = e.id_empleado
    LEFT JOIN Correo cor ON cor.id_empleado = e.id_empleado
    LEFT JOIN Lugar l_parroquia ON e.lugar_id_lugar = l_parroquia.id_lugar
    LEFT JOIN Lugar l_municipio ON l_parroquia.lugar_relacion_id = l_municipio.id_lugar AND l_municipio.tipo = 'Municipio'
    LEFT JOIN Lugar l_estado ON l_municipio.lugar_relacion_id = l_estado.id_lugar AND l_estado.tipo = 'Estado'
    JOIN Rol r ON u.id_rol = r.id_rol
    WHERE e.id_empleado = new_empleado_id;
END;
$$;


ALTER FUNCTION public.create_empleado(p_cedula character varying, p_primer_nombre character varying, p_segundo_nombre character varying, p_primer_apellido character varying, p_segundo_apellido character varying, p_direccion text, p_lugar_id_lugar integer, p_correo_nombre character varying, p_correo_extension character varying, p_contrasena character varying) OWNER TO daniel_bd;

--
-- Name: create_proveedor(character varying, character varying, integer, character varying, character varying, character varying, integer, text, integer, text); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.create_proveedor(p_razon_social character varying, p_denominacion character varying, p_rif integer, p_url_web character varying, p_correo character varying, p_contrasena character varying, p_id_lugar integer, p_direccion_fisica text, p_id_lugar2 integer, p_direccion_fiscal text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  new_proveedor_id INTEGER;
  new_usuario_id INTEGER;
BEGIN
  INSERT INTO Proveedor (razon_social, denominacion, rif, url_web, id_lugar, direccion_fisica, lugar_id2, direccion_fiscal)
  VALUES (p_razon_social, p_denominacion, p_rif, p_url_web, p_id_lugar, p_direccion_fisica, p_id_lugar2, p_direccion_fiscal)
  RETURNING id_proveedor INTO new_proveedor_id;

  INSERT INTO Usuario (id_proveedor, fecha_creacion, contrase├▒a)
  VALUES (new_proveedor_id,  CURRENT_DATE, p_contrasena)
  RETURNING id_usuario INTO new_usuario_id;

  INSERT INTO Correo (nombre, extension_pag, id_proveedor_proveedor)
  VALUES (split_part(p_correo, '@', 1), split_part(p_correo, '@', 2), new_proveedor_id);
END;
$$;


ALTER FUNCTION public.create_proveedor(p_razon_social character varying, p_denominacion character varying, p_rif integer, p_url_web character varying, p_correo character varying, p_contrasena character varying, p_id_lugar integer, p_direccion_fisica text, p_id_lugar2 integer, p_direccion_fiscal text) OWNER TO daniel_bd;

--
-- Name: create_role(character varying, json); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.create_role(p_nombre_rol character varying, p_privilegios json) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_rol_id INTEGER;
    priv_id INTEGER;
    p JSON;
BEGIN
    -- Insert the new role and get its ID
    INSERT INTO Rol (nombre) VALUES (p_nombre_rol) RETURNING id_rol INTO new_rol_id;

    -- Insert privileges for each (privilegio, tabla)
    FOR p IN SELECT * FROM json_array_elements(p_privilegios)
    LOOP
        SELECT id_privilegio INTO priv_id FROM Privilegio WHERE nombre = p->>'privilegio';
        IF priv_id IS NULL THEN
            RAISE EXCEPTION 'Privilegio % no existe', p->>'privilegio';
        END IF;
        INSERT INTO Rol_Privilegio (id_rol, id_privilegio, nom_tabla_ojetivo, fecha_asignacion)
        VALUES (new_rol_id, priv_id, p->>'tabla', CURRENT_DATE);
    END LOOP;
END;
$$;


ALTER FUNCTION public.create_role(p_nombre_rol character varying, p_privilegios json) OWNER TO daniel_bd;

--
-- Name: diagnosticar_puntos_cliente(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.diagnosticar_puntos_cliente(p_id_cliente_natural integer) RETURNS TABLE(id_punto_cliente integer, fecha date, tipo_movimiento character varying, cantidad_mov integer, saldo_acumulado integer, referencia text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pc.id_punto_cliente,
        pc.fecha,
        pc.tipo_movimiento,
        pc.cantidad_mov,
        SUM(pc.cantidad_mov) OVER (
            ORDER BY pc.fecha, pc.id_punto_cliente
            ROWS UNBOUNDED PRECEDING
        )::INTEGER as saldo_acumulado,
        CASE 
            WHEN pc.tipo_movimiento = 'GANADO' THEN 'Compra en tienda f├¡sica'
            WHEN pc.tipo_movimiento = 'GASTADO' THEN 'Pago con puntos'
            ELSE 'Otro'
        END as referencia
    FROM Punto_Cliente pc
    WHERE pc.id_cliente_natural = p_id_cliente_natural
    ORDER BY pc.fecha ASC, pc.id_punto_cliente ASC;
END;
$$;


ALTER FUNCTION public.diagnosticar_puntos_cliente(p_id_cliente_natural integer) OWNER TO daniel_bd;

--
-- Name: diagnosticar_tasas_puntos(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.diagnosticar_tasas_puntos() RETURNS TABLE(id_tasa integer, nombre character varying, valor numeric, fecha date, punto_id integer, id_metodo integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id_tasa,
        t.nombre,
        t.valor,
        t.fecha,
        t.punto_id,
        t.id_metodo
    FROM Tasa t
    WHERE t.punto_id IS NOT NULL
    ORDER BY t.fecha DESC, t.id_tasa DESC;
END;
$$;


ALTER FUNCTION public.diagnosticar_tasas_puntos() OWNER TO daniel_bd;

--
-- Name: eliminar_del_carrito(integer, integer, json); Type: PROCEDURE; Schema: public; Owner: daniel_bd
--

CREATE PROCEDURE public.eliminar_del_carrito(IN p_id_usuario integer, IN p_id_inventario integer, INOUT p_resultado json)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario);
    
    IF v_id_compra IS NULL THEN
        p_resultado := json_build_object('success', false, 'message', 'No se encontr├│ carrito');
        RETURN;
    END IF;

    DELETE FROM Detalle_Compra 
    WHERE id_compra = v_id_compra AND id_inventario = p_id_inventario;
    
    IF FOUND THEN
        p_resultado := json_build_object('success', true, 'message', 'Producto eliminado');
    ELSE
        p_resultado := json_build_object('success', false, 'message', 'Producto no encontrado en el carrito');
    END IF;
END;
$$;


ALTER PROCEDURE public.eliminar_del_carrito(IN p_id_usuario integer, IN p_id_inventario integer, INOUT p_resultado json) OWNER TO daniel_bd;

--
-- Name: PROCEDURE eliminar_del_carrito(IN p_id_usuario integer, IN p_id_inventario integer, INOUT p_resultado json); Type: COMMENT; Schema: public; Owner: daniel_bd
--

COMMENT ON PROCEDURE public.eliminar_del_carrito(IN p_id_usuario integer, IN p_id_inventario integer, INOUT p_resultado json) IS 'Procedimiento: Elimina un producto del carrito.';


--
-- Name: eliminar_del_carrito(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.eliminar_del_carrito(p_id_usuario integer, p_id_inventario integer, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_carrito_por_tipo(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);
    
    IF v_id_compra IS NULL THEN
        RAISE EXCEPTION 'No se encontr├│ carrito';
    END IF;

    DELETE FROM Detalle_Compra 
    WHERE id_compra = v_id_compra AND id_inventario = p_id_inventario;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Producto no encontrado en el carrito';
    END IF;
    
    -- Actualizar el monto total de la compra
    PERFORM actualizar_monto_compra(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);
END;
$$;


ALTER FUNCTION public.eliminar_del_carrito(p_id_usuario integer, p_id_inventario integer, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: eliminar_del_carrito_por_id(integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.eliminar_del_carrito_por_id(p_id_compra integer, p_id_inventario integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM Detalle_Compra WHERE id_compra = p_id_compra AND id_inventario = p_id_inventario;
    
    -- Actualizar el monto total de la compra
    PERFORM actualizar_monto_compra_por_id(p_id_compra);
END;
$$;


ALTER FUNCTION public.eliminar_del_carrito_por_id(p_id_compra integer, p_id_inventario integer) OWNER TO daniel_bd;

--
-- Name: eliminar_metodo_pago(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.eliminar_metodo_pago(p_id_metodo integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_tipo_metodo VARCHAR(20);
BEGIN
    -- Determinar el tipo de m├⌐todo
    SELECT 
        CASE 
            WHEN c.id_metodo IS NOT NULL THEN 'cheque'
            WHEN e.id_metodo IS NOT NULL THEN 'efectivo'
            WHEN tc.id_metodo IS NOT NULL THEN 'tarjeta_credito'
            WHEN td.id_metodo IS NOT NULL THEN 'tarjeta_debito'
            ELSE 'desconocido'
        END INTO v_tipo_metodo
    FROM Metodo_Pago mp
    LEFT JOIN Cheque c ON mp.id_metodo = c.id_metodo
    LEFT JOIN Efectivo e ON mp.id_metodo = e.id_metodo
    LEFT JOIN Tarjeta_Credito tc ON mp.id_metodo = tc.id_metodo
    LEFT JOIN Tarjeta_Debito td ON mp.id_metodo = td.id_metodo
    WHERE mp.id_metodo = p_id_metodo;
    
    IF v_tipo_metodo = 'desconocido' THEN
        RETURN FALSE;
    END IF;
    
    -- Eliminar subtipo primero (por las foreign keys)
    CASE v_tipo_metodo
        WHEN 'cheque' THEN DELETE FROM Cheque WHERE id_metodo = p_id_metodo;
        WHEN 'efectivo' THEN DELETE FROM Efectivo WHERE id_metodo = p_id_metodo;
        WHEN 'tarjeta_credito' THEN DELETE FROM Tarjeta_Credito WHERE id_metodo = p_id_metodo;
        WHEN 'tarjeta_debito' THEN DELETE FROM Tarjeta_Debito WHERE id_metodo = p_id_metodo;
    END CASE;
    
    -- Eliminar supertipo
    DELETE FROM Metodo_Pago WHERE id_metodo = p_id_metodo;
    
    RETURN TRUE;
END;
$$;


ALTER FUNCTION public.eliminar_metodo_pago(p_id_metodo integer) OWNER TO daniel_bd;

--
-- Name: FUNCTION eliminar_metodo_pago(p_id_metodo integer); Type: COMMENT; Schema: public; Owner: daniel_bd
--

COMMENT ON FUNCTION public.eliminar_metodo_pago(p_id_metodo integer) IS 'Funci├│n: Elimina un m├⌐todo de pago completo (supertipo y subtipo)';


--
-- Name: evitar_estatus_abierto_duplicado(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.evitar_estatus_abierto_duplicado() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Compra_Estatus
    WHERE compra_id_compra = NEW.compra_id_compra
      AND fecha_hora_fin = '9999-12-31 23:59:59';
    IF v_count > 0 THEN
        RAISE EXCEPTION 'No puede haber m├ís de un estatus abierto por compra.';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.evitar_estatus_abierto_duplicado() OWNER TO daniel_bd;

--
-- Name: get_cliente_juridico_by_rif(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_cliente_juridico_by_rif(p_rif integer) RETURNS TABLE(id_cliente integer, rif_cliente integer, razon_social character varying, denominacion_comercial character varying, direccion_fiscal text, direccion_fisica text, lugar_id_lugar integer, correo_nombre character varying, correo_extension character varying, telefono character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        cj.id_cliente,
        cj.rif_cliente,
        cj.razon_social,
        cj.denominacion_comercial,
        cj.direccion_fiscal,
        cj.direccion_fisica,
        cj.lugar_id_lugar,
        c.nombre AS correo_nombre,
        c.extension_pag AS correo_extension,
        t.numero AS telefono
    FROM Cliente_Juridico cj
    LEFT JOIN Correo c ON c.id_cliente_juridico = cj.id_cliente
    LEFT JOIN Telefono t ON t.id_cliente_juridico = cj.id_cliente
    WHERE cj.rif_cliente = p_rif
    LIMIT 1;
END;
$$;


ALTER FUNCTION public.get_cliente_juridico_by_rif(p_rif integer) OWNER TO daniel_bd;

--
-- Name: get_cliente_natural_by_cedula(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_cliente_natural_by_cedula(p_cedula integer) RETURNS TABLE(id_cliente integer, ci_cliente integer, primer_nombre character varying, segundo_nombre character varying, primer_apellido character varying, segundo_apellido character varying, direccion text, lugar_id_lugar integer, correo_nombre character varying, correo_extension character varying, telefono character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        cn.id_cliente,
        cn.ci_cliente,
        cn.primer_nombre,
        cn.segundo_nombre,
        cn.primer_apellido,
        cn.segundo_apellido,
        cn.direccion,
        cn.lugar_id_lugar,
        c.nombre AS correo_nombre,
        c.extension_pag AS correo_extension,
        t.numero AS telefono
    FROM Cliente_Natural cn
    LEFT JOIN Correo c ON c.id_cliente_natural = cn.id_cliente
    LEFT JOIN Telefono t ON t.id_cliente_natural = cn.id_cliente
    WHERE cn.ci_cliente = p_cedula
    LIMIT 1;
END;
$$;


ALTER FUNCTION public.get_cliente_natural_by_cedula(p_cedula integer) OWNER TO daniel_bd;

--
-- Name: get_detalle_orden_anaquel(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_detalle_orden_anaquel(p_id_orden_reposicion integer) RETURNS TABLE(presentacion character varying, cerveza character varying, cantidad integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.nombre AS presentacion,
        c.nombre_cerveza AS cerveza,
        dora.cantidad
    FROM Detalle_Orden_Reposicion_Anaquel dora
    JOIN Inventario i ON dora.id_inventario = i.id_inventario
    JOIN Presentacion p ON i.id_presentacion = p.id_presentacion
    JOIN Cerveza c ON i.id_cerveza = c.id_cerveza
    WHERE dora.id_orden_reposicion = p_id_orden_reposicion;
END;
$$;


ALTER FUNCTION public.get_detalle_orden_anaquel(p_id_orden_reposicion integer) OWNER TO daniel_bd;

--
-- Name: get_detalle_orden_proveedor(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_detalle_orden_proveedor(p_id_orden_reposicion integer) RETURNS TABLE(presentacion character varying, cerveza character varying, cantidad integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.nombre AS presentacion,
        c.nombre_cerveza AS cerveza,
        dor.cantidad
    FROM Detalle_Orden_Reposicion dor
    JOIN Presentacion p ON dor.id_presentacion = p.id_presentacion
    JOIN Cerveza c ON dor.id_cerveza = c.id_cerveza
    WHERE dor.id_orden_reposicion = p_id_orden_reposicion;
END;
$$;


ALTER FUNCTION public.get_detalle_orden_proveedor(p_id_orden_reposicion integer) OWNER TO daniel_bd;

--
-- Name: get_full_location_path(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_full_location_path(p_location_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    full_path TEXT;
BEGIN
    WITH RECURSIVE location_path AS (
        SELECT 
            id_ubicacion, 
            tipo,
            nombre, 
            ubicacion_tienda_relacion_id,
            1 AS level
        FROM Ubicacion_Tienda
        WHERE id_ubicacion = p_location_id

        UNION ALL

        SELECT 
            ut.id_ubicacion, 
            ut.tipo,
            ut.nombre, 
            ut.ubicacion_tienda_relacion_id,
            lp.level + 1
        FROM Ubicacion_Tienda ut
        JOIN location_path lp ON ut.id_ubicacion = lp.ubicacion_tienda_relacion_id
    )
    SELECT string_agg(tipo || ': ' || nombre, ' / ' ORDER BY level DESC)
    INTO full_path
    FROM location_path;

    RETURN full_path;
END;
$$;


ALTER FUNCTION public.get_full_location_path(p_location_id integer) OWNER TO daniel_bd;

--
-- Name: get_indicadores_clientes(date, date); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_indicadores_clientes(p_fecha_inicio date, p_fecha_fin date) RETURNS TABLE(clientes_nuevos bigint, clientes_recurrentes bigint, tasa_retencion numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH 
    -- =================================================================
    -- CTE 1: COMPRAS CON IDENTIFICACI├ôN DE CLIENTE
    -- =================================================================
    -- Unifica clientes naturales y jur├¡dicos en un solo identificador
    -- Usa COALESCE para manejar los dos tipos de cliente (natural/jur├¡dico)
    compras_con_cliente AS (
        SELECT
            COALESCE(CAST(id_cliente_juridico AS TEXT), CAST(id_cliente_natural AS TEXT)) AS id_cliente,
            id_compra
        FROM Compra
        WHERE id_cliente_juridico IS NOT NULL OR id_cliente_natural IS NOT NULL
    ),
    -- =================================================================
    -- CTE 2: PRIMERAS COMPRAS POR CLIENTE
    -- =================================================================
    -- Encuentra la fecha de la primera compra de cada cliente
    -- Esto es crucial para determinar si un cliente es nuevo o recurrente
    primeras_compras AS (
        SELECT cc.id_cliente, MIN(pc.fecha_hora) AS primera_compra
        FROM compras_con_cliente cc
        JOIN Pago_Compra pc ON cc.id_compra = pc.compra_id
        GROUP BY cc.id_cliente
    ),
    -- =================================================================
    -- CTE 3: COMPRAS EN EL PER├ìODO ANALIZADO
    -- =================================================================
    -- Identifica qu├⌐ clientes realizaron compras en el per├¡odo espec├¡fico
    -- y cu├íntas compras hicieron cada uno
    compras_periodo AS (
        SELECT cc.id_cliente, COUNT(*) AS compras
        FROM compras_con_cliente cc
        JOIN Pago_Compra pc ON cc.id_compra = pc.compra_id
        WHERE pc.fecha_hora BETWEEN p_fecha_inicio AND p_fecha_fin
        GROUP BY cc.id_cliente
    )
    -- =================================================================
    -- SELECT FINAL: C├üLCULO DE KPIs
    -- =================================================================
    SELECT
        -- CLIENTES NUEVOS: Aquellos cuya primera compra fue en el per├¡odo analizado
        (SELECT COUNT(*) FROM primeras_compras WHERE primera_compra BETWEEN p_fecha_inicio AND p_fecha_fin) AS clientes_nuevos,
        
        -- CLIENTES RECURRENTES: Aquellos que ya hab├¡an comprado antes del per├¡odo pero volvieron a comprar
        (SELECT COUNT(*) FROM compras_periodo cp
            JOIN primeras_compras pc ON cp.id_cliente = pc.id_cliente
            WHERE pc.primera_compra < p_fecha_inicio) AS clientes_recurrentes,
        
        -- TASA DE RETENCI├ôN: Porcentaje de clientes recurrentes vs total de clientes activos
        CASE WHEN (SELECT COUNT(*) FROM compras_periodo) > 0 THEN
            (SELECT COUNT(*) FROM compras_periodo cp
                JOIN primeras_compras pc ON cp.id_cliente = pc.id_cliente
                WHERE pc.primera_compra < p_fecha_inicio)::DECIMAL
            /
            (SELECT COUNT(*) FROM compras_periodo)::DECIMAL * 100
        ELSE 0 END AS tasa_retencion;
END;
$$;


ALTER FUNCTION public.get_indicadores_clientes(p_fecha_inicio date, p_fecha_fin date) OWNER TO daniel_bd;

--
-- Name: get_indicadores_ventas(date, date); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_indicadores_ventas(p_fecha_inicio date, p_fecha_fin date) RETURNS TABLE(ventas_totales_fisica numeric, ventas_totales_web numeric, ventas_totales_general numeric, crecimiento_ventas numeric, crecimiento_porcentual numeric, ticket_promedio numeric, volumen_unidades integer, estilo_mas_vendido character varying, unidades_estilo_mas_vendido integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Variables para calcular el per├â┬¡odo anterior autom├â┬íticamente
    v_periodo_anterior_inicio DATE;
    v_periodo_anterior_fin DATE;
    v_ventas_periodo_actual DECIMAL;    -- Ventas del per├â┬¡odo solicitado
    v_ventas_periodo_anterior DECIMAL;  -- Ventas del per├â┬¡odo anterior (para comparaci├â┬│n)
    v_duracion_dias INTEGER;            -- Duraci├â┬│n en d├â┬¡as del per├â┬¡odo
BEGIN
    -- =================================================================
    -- C├â┬üLCULO DEL PER├â┬ìODO ANTERIOR AUTOM├â┬üTICO
    -- =================================================================
    -- Calcula autom├â┬íticamente el per├â┬¡odo anterior con la misma duraci├â┬│n
    -- Ejemplo: Si analizas del 1 al 31 de enero, compara con el 1 al 31 de diciembre
    v_duracion_dias := p_fecha_fin - p_fecha_inicio;
    v_periodo_anterior_fin := p_fecha_inicio - INTERVAL '1 day';
    v_periodo_anterior_inicio := v_periodo_anterior_fin - (v_duracion_dias * INTERVAL '1 day');
    -- =================================================================
    -- OBTENCI├âΓÇ£N DE VENTAS DEL PER├â┬ìODO ACTUAL
    -- =================================================================
    -- Suma todas las ventas pagadas en el perio┬¡odo solicitado
    -- COALESCE: Si no hay ventas, retorna 0 en lugar de NULL
    SELECT COALESCE(SUM(pc.monto), 0) INTO v_ventas_periodo_actual
    FROM Pago_Compra pc
    JOIN Compra c ON pc.compra_id = c.id_compra
    WHERE pc.fecha_hora BETWEEN p_fecha_inicio AND p_fecha_fin;
    -- =================================================================
    -- OBTENCIon DE VENTAS DEL PERiODO ANTERIOR (PARA COMPARACIoN)
    -- =================================================================
    -- Suma todas las ventas pagadas en el periodo anterior calculado
    SELECT COALESCE(SUM(pc.monto), 0) INTO v_ventas_periodo_anterior
    FROM Pago_Compra pc
    JOIN Compra c ON pc.compra_id = c.id_compra
    WHERE pc.fecha_hora BETWEEN v_periodo_anterior_inicio AND v_periodo_anterior_fin;
    -- =================================================================
    -- CONSULTA PRINCIPAL CON CTEs (Common Table Expressions)
    -- =================================================================
    RETURN QUERY
    WITH 
    -- =================================================================
    -- CTE 1: VENTAS POR TIPO DE TIENDA
    -- =================================================================
    -- Clasifica las ventas entre tienda f├â┬¡sica y tienda web
    -- Agrupa y suma las ventas por cada tipo de tienda
    ventas_por_tienda AS (
        SELECT 
            CASE 
                WHEN c.tienda_fisica_id_tienda IS NOT NULL THEN 'fisica'
                WHEN c.tienda_web_id_tienda IS NOT NULL THEN 'web'
            END as tipo_tienda,
            SUM(pc.monto) as total_ventas
        FROM Pago_Compra pc
        JOIN Compra c ON pc.compra_id = c.id_compra
        WHERE pc.fecha_hora BETWEEN p_fecha_inicio AND p_fecha_fin
        GROUP BY tipo_tienda
    ),
    -- =================================================================
    -- CTE 2: ESTILO DE CERVEZA M├â┬üS VENDIDO
    -- =================================================================
    -- Encuentra el estilo de cerveza que m├â┬ís unidades vendi├â┬│
    -- JOINs necesarios para llegar desde Detalle_Compra hasta Tipo_Cerveza
    ventas_por_estilo AS (
        SELECT 
            tc.nombre as estilo_cerveza,
            SUM(dc.cantidad) as unidades_vendidas
        FROM Detalle_Compra dc
        JOIN Compra c ON dc.id_compra = c.id_compra
        JOIN Pago_Compra pc ON c.id_compra = pc.compra_id
        JOIN Inventario i ON dc.id_inventario = i.id_inventario
        JOIN Cerveza ce ON i.id_cerveza = ce.id_cerveza
        JOIN Tipo_Cerveza tc ON ce.id_tipo_cerveza = tc.id_tipo_cerveza
        WHERE pc.fecha_hora BETWEEN p_fecha_inicio AND p_fecha_fin
        GROUP BY tc.id_tipo_cerveza, tc.nombre
        ORDER BY unidades_vendidas DESC
        LIMIT 1  -- Solo el estilo m├â┬ís vendido
    ),
    -- =================================================================
    -- CTE 3: MeTRICAS GENERALES
    -- =================================================================
    -- Calcula el n├â┬║mero total de compras y unidades vendidas
    -- Necesario para calcular el ticket promedio
    metricas_generales AS (
        SELECT 
            COUNT(DISTINCT c.id_compra) as total_compras,
            SUM(dc.cantidad) as total_unidades
        FROM Compra c
        JOIN Pago_Compra pc ON c.id_compra = pc.compra_id
        JOIN Detalle_Compra dc ON c.id_compra = dc.id_compra
        WHERE pc.fecha_hora BETWEEN p_fecha_inicio AND p_fecha_fin
    )
        -- =================================================================
    -- SELECT FINAL: COMBINA TODOS LOS RESULTADOS
    -- =================================================================
    SELECT 
        -- Ventas por tipo de tienda (usando subconsultas)
        COALESCE((SELECT total_ventas FROM ventas_por_tienda WHERE tipo_tienda = 'fisica'), 0) as ventas_totales_fisica,
        COALESCE((SELECT total_ventas FROM ventas_por_tienda WHERE tipo_tienda = 'web'), 0) as ventas_totales_web,
        -- Ventas totales generales
        v_ventas_periodo_actual as ventas_totales_general,
        -- Crecimiento absoluto (diferencia con per├â┬¡odo anterior)
        (v_ventas_periodo_actual - v_ventas_periodo_anterior) as crecimiento_ventas,
        -- Crecimiento porcentual (evita divisi├â┬│n por cero)
        CASE 
            WHEN v_ventas_periodo_anterior > 0 THEN 
                ((v_ventas_periodo_actual - v_ventas_periodo_anterior) / v_ventas_periodo_anterior) * 100
            ELSE 0
        END as crecimiento_porcentual,
        -- Ticket promedio (ventas totales / n├â┬║mero de compras)
        CASE 
            WHEN (SELECT total_compras FROM metricas_generales) > 0 THEN 
                v_ventas_periodo_actual / (SELECT total_compras FROM metricas_generales)
            ELSE 0
        END as ticket_promedio,
        -- Volumen total de unidades vendidas (convertir bigint a integer)
        COALESCE((SELECT total_unidades FROM metricas_generales), 0)::INTEGER as volumen_unidades,
        -- Estilo m├â┬ís vendido y sus unidades (convertir bigint a integer)
        COALESCE((SELECT estilo_cerveza FROM ventas_por_estilo), 'N/A') as estilo_mas_vendido,
        COALESCE((SELECT unidades_vendidas FROM ventas_por_estilo), 0)::INTEGER as unidades_estilo_mas_vendido;
END;
$$;


ALTER FUNCTION public.get_indicadores_ventas(p_fecha_inicio date, p_fecha_fin date) OWNER TO daniel_bd;

--
-- Name: get_ordenes_anaquel(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_ordenes_anaquel() RETURNS TABLE(id_orden_reposicion integer, fecha_hora_generacion timestamp without time zone, estatus_actual character varying, id_estatus_actual integer, ubicacion_completa text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.id_orden_reposicion,
        o.fecha_hora_generacion,
        e2.nombre AS estatus_actual,
        eo.id_estatus AS id_estatus_actual,
        get_full_location_path(o.id_ubicacion) AS ubicacion_completa
    FROM Orden_Reposicion_Anaquel o
    LEFT JOIN LATERAL (
        SELECT eo2.id_estatus, es.nombre
        FROM Estatus_Orden_Anaquel eo2
        JOIN Estatus es ON eo2.id_estatus = es.id_estatus
        WHERE eo2.id_orden_reposicion = o.id_orden_reposicion
        ORDER BY eo2.fecha_hora_asignacion DESC
        LIMIT 1
    ) eo ON TRUE
    LEFT JOIN Estatus e2 ON eo.id_estatus = e2.id_estatus
    ORDER BY o.id_orden_reposicion DESC;
END;
$$;


ALTER FUNCTION public.get_ordenes_anaquel() OWNER TO daniel_bd;

--
-- Name: get_ordenes_reposicion_proveedores(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_ordenes_reposicion_proveedores() RETURNS TABLE(id_orden_reposicion integer, nombre_departamento character varying, razon_social_proveedor character varying, fecha_emision date, fecha_fin date, estatus_actual character varying, id_estatus_actual integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        o.id_orden_reposicion,
        d.nombre AS nombre_departamento,
        p.razon_social AS razon_social_proveedor,
        o.fecha_emision,
        o.fecha_fin,
        e2.nombre AS estatus_actual,
        oe.id_estatus AS id_estatus_actual
    FROM Orden_Reposicion o
    JOIN Departamento d ON o.id_departamento = d.id_departamento
    JOIN Proveedor p ON o.id_proveedor = p.id_proveedor
    LEFT JOIN LATERAL (
        SELECT oe2.id_estatus, es.nombre
        FROM Orden_Reposicion_Estatus oe2
        JOIN Estatus es ON oe2.id_estatus = es.id_estatus
        WHERE oe2.id_orden_reposicion = o.id_orden_reposicion
        ORDER BY oe2.fecha_asignacion DESC
        LIMIT 1
    ) oe ON TRUE
    LEFT JOIN Estatus e2 ON oe.id_estatus = e2.id_estatus
    ORDER BY o.id_orden_reposicion DESC;
END;
$$;


ALTER FUNCTION public.get_ordenes_reposicion_proveedores() OWNER TO daniel_bd;

--
-- Name: get_roles(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_roles() RETURNS TABLE(id_rol integer, nombre_rol character varying, privilegios json)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.id_rol,
        r.nombre AS nombre_rol,
        COALESCE(
            json_agg(
                CASE WHEN p.nombre IS NOT NULL AND rp.nom_tabla_ojetivo IS NOT NULL THEN
                    json_build_object('privilegio', p.nombre, 'tabla', rp.nom_tabla_ojetivo)
                END
            ) FILTER (WHERE p.nombre IS NOT NULL AND rp.nom_tabla_ojetivo IS NOT NULL),
            '[]'::json
        ) AS privilegios
    FROM
        Rol r
    LEFT JOIN
        Rol_Privilegio rp ON r.id_rol = rp.id_rol
    LEFT JOIN
        Privilegio p ON rp.id_privilegio = p.id_privilegio
    GROUP BY
        r.id_rol, r.nombre
    ORDER BY
        r.id_rol;
END;
$$;


ALTER FUNCTION public.get_roles() OWNER TO daniel_bd;

--
-- Name: get_rotacion_inventario(date, date); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_rotacion_inventario(p_fecha_inicio date, p_fecha_fin date) RETURNS TABLE(rotacion_inventario numeric, valor_promedio_inventario numeric, costo_productos_vendidos numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH 
    -- =================================================================
    -- CTE 1: VALOR PROMEDIO DEL INVENTARIO EN EL PER├ìODO
    -- =================================================================
    -- Calcula el valor promedio del inventario durante el per├¡odo analizado
    -- Considera el inventario inicial + final / 2
    valor_inventario AS (
        SELECT 
            COALESCE(AVG(i.cantidad * dc.precio_unitario), 0) as valor_promedio
        FROM Inventario i
        LEFT JOIN Detalle_Compra dc ON i.id_inventario = dc.id_inventario
        LEFT JOIN Compra c ON dc.id_compra = c.id_compra
        LEFT JOIN Pago_Compra pc ON c.id_compra = pc.compra_id
        WHERE (pc.fecha_hora BETWEEN p_fecha_inicio AND p_fecha_fin) 
           OR (pc.fecha_hora IS NULL AND i.cantidad > 0)
    ),
    -- =================================================================
    -- CTE 2: COSTO DE PRODUCTOS VENDIDOS
    -- =================================================================
    -- Calcula el costo total de los productos vendidos en el per├¡odo
    -- Usa el precio unitario * cantidad vendida
    costo_vendido AS (
        SELECT 
            COALESCE(SUM(dc.cantidad * dc.precio_unitario), 0) as costo_total
        FROM Detalle_Compra dc
        JOIN Compra c ON dc.id_compra = c.id_compra
        JOIN Pago_Compra pc ON c.id_compra = pc.compra_id
        WHERE pc.fecha_hora BETWEEN p_fecha_inicio AND p_fecha_fin
    )
    -- =================================================================
    -- SELECT FINAL: C├üLCULO DE ROTACI├ôN
    -- =================================================================
    SELECT
        CASE 
            WHEN vi.valor_promedio > 0 THEN cv.costo_total / vi.valor_promedio
            ELSE 0 
        END as rotacion_inventario,
        vi.valor_promedio as valor_promedio_inventario,
        cv.costo_total as costo_productos_vendidos
    FROM valor_inventario vi
    CROSS JOIN costo_vendido cv;
END;
$$;


ALTER FUNCTION public.get_rotacion_inventario(p_fecha_inicio date, p_fecha_fin date) OWNER TO daniel_bd;

--
-- Name: get_stock_actual(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_stock_actual() RETURNS TABLE(producto character varying, presentacion character varying, stock_disponible bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        ce.nombre_cerveza AS producto,
        p.nombre AS presentacion,
        SUM(i.cantidad) AS stock_disponible
    FROM Inventario i
    JOIN Cerveza ce ON i.id_cerveza = ce.id_cerveza
    JOIN Presentacion p ON i.id_presentacion = p.id_presentacion
    GROUP BY ce.nombre_cerveza, p.nombre
    ORDER BY producto, presentacion;
END;
$$;


ALTER FUNCTION public.get_stock_actual() OWNER TO daniel_bd;

--
-- Name: get_tasa_ruptura_stock(date, date); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_tasa_ruptura_stock(p_fecha_inicio date, p_fecha_fin date) RETURNS TABLE(tasa_ruptura_stock numeric, productos_sin_stock bigint, total_productos bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH 
    -- =================================================================
    -- CTE 1: PRODUCTOS SIN STOCK
    -- =================================================================
    -- Identifica productos que se quedaron sin stock durante el per├¡odo
    -- Un producto est├í sin stock si su cantidad lleg├│ a 0
    productos_agotados AS (
        SELECT 
            i.id_inventario,
            i.id_cerveza,
            i.id_presentacion,
            MIN(i.cantidad) as stock_minimo
        FROM Inventario i
        LEFT JOIN Detalle_Compra dc ON i.id_inventario = dc.id_inventario
        LEFT JOIN Compra c ON dc.id_compra = c.id_compra
        LEFT JOIN Pago_Compra pc ON c.id_compra = pc.compra_id
        WHERE (pc.fecha_hora BETWEEN p_fecha_inicio AND p_fecha_fin) 
           OR (i.cantidad = 0)
        GROUP BY i.id_inventario, i.id_cerveza, i.id_presentacion
        HAVING MIN(i.cantidad) = 0
    ),
    -- =================================================================
    -- CTE 2: TOTAL DE PRODUCTOS EN INVENTARIO
    -- =================================================================
    -- Cuenta el total de productos ├║nicos en inventario
    total_productos_inv AS (
        SELECT COUNT(DISTINCT CONCAT(id_cerveza, '-', id_presentacion)) as total
        FROM Inventario
        WHERE cantidad > 0
    )
    -- =================================================================
    -- SELECT FINAL: C├üLCULO DE TASA DE RUPTURA
    -- =================================================================
    SELECT
        CASE 
            WHEN tpi.total > 0 THEN (pa.count_agotados::DECIMAL / tpi.total::DECIMAL) * 100
            ELSE 0 
        END as tasa_ruptura_stock,
        pa.count_agotados as productos_sin_stock,
        tpi.total as total_productos
    FROM (
        SELECT COUNT(*) as count_agotados
        FROM productos_agotados
    ) pa
    CROSS JOIN total_productos_inv tpi;
END;
$$;


ALTER FUNCTION public.get_tasa_ruptura_stock(p_fecha_inicio date, p_fecha_fin date) OWNER TO daniel_bd;

--
-- Name: get_tendencia_ventas(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_tendencia_ventas() RETURNS TABLE(periodo character varying, total_ventas integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        TO_CHAR(pc.fecha_hora, 'YYYY-MM')::VARCHAR AS periodo,
        COUNT(DISTINCT pc.compra_id)::INTEGER AS total_ventas
    FROM Pago_Compra pc
    GROUP BY periodo
    ORDER BY periodo;
END;
$$;


ALTER FUNCTION public.get_tendencia_ventas() OWNER TO daniel_bd;

--
-- Name: get_top_productos_vendidos(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_top_productos_vendidos() RETURNS TABLE(producto character varying, unidades_vendidas bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        ce.nombre_cerveza AS producto,
        SUM(dc.cantidad) AS unidades_vendidas
    FROM Detalle_Compra dc
    JOIN Inventario i ON dc.id_inventario = i.id_inventario
    JOIN Cerveza ce ON i.id_cerveza = ce.id_cerveza
    GROUP BY ce.nombre_cerveza
    ORDER BY unidades_vendidas DESC
    LIMIT 10;
END;
$$;


ALTER FUNCTION public.get_top_productos_vendidos() OWNER TO daniel_bd;

--
-- Name: get_usuarios_clientes_juridicos(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_usuarios_clientes_juridicos() RETURNS TABLE(id_usuario integer, email character varying, pagina_web character varying, rif character varying, razon_social character varying, denominacion_comercial character varying, capital_disponible numeric, estado_fiscal character varying, municipio_fiscal character varying, parroquia_fiscal character varying, direccion_fiscal_especifica text, estado_fisica character varying, municipio_fisica character varying, parroquia_fisica character varying, direccion_fisica_especifica text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.id_usuario,
        CONCAT(cor.nombre, '@', cor.extension_pag)::VARCHAR(100) AS email,
        cj.pagina_web::VARCHAR(100),
        cj.rif_cliente::VARCHAR(20) AS rif,
        cj.razon_social::VARCHAR(100),
        cj.denominacion_comercial::VARCHAR(100),
        cj.capital_disponible,
        l_estado_fiscal.nombre::VARCHAR(100) AS estado_fiscal,
        l_municipio_fiscal.nombre::VARCHAR(100) AS municipio_fiscal,
        l_parroquia_fiscal.nombre::VARCHAR(100) AS parroquia_fiscal,
        cj.direccion_fiscal AS direccion_fiscal_especifica,
        l_estado_fisica.nombre::VARCHAR(100) AS estado_fisica,
        l_municipio_fisica.nombre::VARCHAR(100) AS municipio_fisica,
        l_parroquia_fisica.nombre::VARCHAR(100) AS parroquia_fisica,
        cj.direccion_fisica AS direccion_fisica_especifica
    FROM Usuario u
    JOIN Cliente_Juridico cj ON u.id_cliente_juridico = cj.id_cliente
    LEFT JOIN Correo cor ON cor.id_cliente_juridico = cj.id_cliente
    -- Fiscal
    LEFT JOIN Lugar l_parroquia_fiscal ON cj.lugar_id_lugar2 = l_parroquia_fiscal.id_lugar
    LEFT JOIN Lugar l_municipio_fiscal ON l_parroquia_fiscal.lugar_relacion_id = l_municipio_fiscal.id_lugar AND l_municipio_fiscal.tipo = 'Municipio'
    LEFT JOIN Lugar l_estado_fiscal ON l_municipio_fiscal.lugar_relacion_id = l_estado_fiscal.id_lugar AND l_estado_fiscal.tipo = 'Estado'
    -- F├¡sica
    LEFT JOIN Lugar l_parroquia_fisica ON cj.lugar_id_lugar = l_parroquia_fisica.id_lugar
    LEFT JOIN Lugar l_municipio_fisica ON l_parroquia_fisica.lugar_relacion_id = l_municipio_fisica.id_lugar AND l_municipio_fisica.tipo = 'Municipio'
    LEFT JOIN Lugar l_estado_fisica ON l_municipio_fisica.lugar_relacion_id = l_estado_fisica.id_lugar AND l_estado_fisica.tipo = 'Estado'
    WHERE u.id_cliente_juridico IS NOT NULL;
END;
$$;


ALTER FUNCTION public.get_usuarios_clientes_juridicos() OWNER TO daniel_bd;

--
-- Name: get_usuarios_clientes_naturales(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_usuarios_clientes_naturales() RETURNS TABLE(id_usuario integer, email character varying, rif character varying, cedula character varying, nombre_completo character varying, estado character varying, municipio character varying, parroquia character varying, direccion_especifica text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.id_usuario,
        CONCAT(cor.nombre, '@', cor.extension_pag)::VARCHAR(100) AS email,
        cn.rif_cliente::VARCHAR(20) AS rif,
        cn.ci_cliente::VARCHAR(20) AS cedula,
        CONCAT(cn.primer_nombre, ' ', cn.segundo_nombre, ' ', cn.primer_apellido, ' ', cn.segundo_apellido)::VARCHAR(100) AS nombre_completo,
        l_estado.nombre::VARCHAR(100) AS estado,
        l_municipio.nombre::VARCHAR(100) AS municipio,
        l_parroquia.nombre::VARCHAR(100) AS parroquia,
        cn.direccion AS direccion_especifica
    FROM Usuario u
    JOIN Cliente_Natural cn ON u.id_cliente_natural = cn.id_cliente
    LEFT JOIN Correo cor ON cor.id_cliente_natural = cn.id_cliente
    LEFT JOIN Lugar l_parroquia ON cn.lugar_id_lugar = l_parroquia.id_lugar
    LEFT JOIN Lugar l_municipio ON l_parroquia.lugar_relacion_id = l_municipio.id_lugar AND l_municipio.tipo = 'Municipio'
    LEFT JOIN Lugar l_estado ON l_municipio.lugar_relacion_id = l_estado.id_lugar AND l_estado.tipo = 'Estado'
    WHERE u.id_cliente_natural IS NOT NULL;
END;
$$;


ALTER FUNCTION public.get_usuarios_clientes_naturales() OWNER TO daniel_bd;

--
-- Name: get_usuarios_empleados(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_usuarios_empleados() RETURNS TABLE(id_usuario integer, email character varying, nombre_completo character varying, cedula character varying, estado character varying, municipio character varying, parroquia character varying, direccion_especifica text, activo character, rol character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.id_usuario,
        CONCAT(cor.nombre, '@', cor.extension_pag)::VARCHAR(100) AS email,
        CONCAT(e.primer_nombre, ' ', e.segundo_nombre, ' ', e.primer_apellido, ' ', e.segundo_apellido)::VARCHAR(100) AS nombre_completo,
        e.cedula::VARCHAR(20) AS cedula,
        l_estado.nombre::VARCHAR(100) AS estado,
        l_municipio.nombre::VARCHAR(100) AS municipio,
        l_parroquia.nombre::VARCHAR(100) AS parroquia,
        e.direccion AS direccion_especifica,
        e.activo,
        r.nombre AS rol
    FROM Usuario u
    JOIN Empleado e ON u.empleado_id = e.id_empleado
    LEFT JOIN Correo cor ON cor.id_empleado = e.id_empleado
    LEFT JOIN Lugar l_parroquia ON e.lugar_id_lugar = l_parroquia.id_lugar
    LEFT JOIN Lugar l_municipio ON l_parroquia.lugar_relacion_id = l_municipio.id_lugar AND l_municipio.tipo = 'Municipio'
    LEFT JOIN Lugar l_estado ON l_municipio.lugar_relacion_id = l_estado.id_lugar AND l_estado.tipo = 'Estado'
    LEFT JOIN Rol r ON u.id_rol = r.id_rol
    WHERE u.empleado_id IS NOT NULL;
END;
$$;


ALTER FUNCTION public.get_usuarios_empleados() OWNER TO daniel_bd;

--
-- Name: get_usuarios_proveedores(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_usuarios_proveedores() RETURNS TABLE(id_usuario integer, email character varying, pagina_web character varying, rif character varying, razon_social character varying, denominacion_comercial character varying, estado_fiscal character varying, municipio_fiscal character varying, parroquia_fiscal character varying, direccion_fiscal_especifica text, estado_fisica character varying, municipio_fisica character varying, parroquia_fisica character varying, direccion_fisica_especifica text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.id_usuario,
        CONCAT(cor.nombre, '@', cor.extension_pag)::VARCHAR(100) AS email,
        p.url_web::VARCHAR(200),
        p.rif::VARCHAR(20) AS rif,
        p.razon_social::VARCHAR(100),
        p.denominacion::VARCHAR(100) AS denominacion_comercial,
        l_estado_fiscal.nombre::VARCHAR(100) AS estado_fiscal,
        l_municipio_fiscal.nombre::VARCHAR(100) AS municipio_fiscal,
        l_parroquia_fiscal.nombre::VARCHAR(100) AS parroquia_fiscal,
        p.direccion_fiscal AS direccion_fiscal_especifica,
        l_estado_fisica.nombre::VARCHAR(100) AS estado_fisica,
        l_municipio_fisica.nombre::VARCHAR(100) AS municipio_fisica,
        l_parroquia_fisica.nombre::VARCHAR(100) AS parroquia_fisica,
        p.direccion_fisica AS direccion_fisica_especifica
    FROM Usuario u
    JOIN Proveedor p ON u.id_proveedor = p.id_proveedor
    LEFT JOIN Correo cor ON cor.id_proveedor_proveedor = p.id_proveedor
    -- Fiscal
    LEFT JOIN Lugar l_parroquia_fiscal ON p.lugar_id2 = l_parroquia_fiscal.id_lugar
    LEFT JOIN Lugar l_municipio_fiscal ON l_parroquia_fiscal.lugar_relacion_id = l_municipio_fiscal.id_lugar AND l_municipio_fiscal.tipo = 'Municipio'
    LEFT JOIN Lugar l_estado_fiscal ON l_municipio_fiscal.lugar_relacion_id = l_estado_fiscal.id_lugar AND l_estado_fiscal.tipo = 'Estado'
    -- F├¡sica
    LEFT JOIN Lugar l_parroquia_fisica ON p.id_lugar = l_parroquia_fisica.id_lugar
    LEFT JOIN Lugar l_municipio_fisica ON l_parroquia_fisica.lugar_relacion_id = l_municipio_fisica.id_lugar AND l_municipio_fisica.tipo = 'Municipio'
    LEFT JOIN Lugar l_estado_fisica ON l_municipio_fisica.lugar_relacion_id = l_estado_fisica.id_lugar AND l_estado_fisica.tipo = 'Estado'
    WHERE u.id_proveedor IS NOT NULL;
END;
$$;


ALTER FUNCTION public.get_usuarios_proveedores() OWNER TO daniel_bd;

--
-- Name: get_ventas_por_canal(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_ventas_por_canal() RETURNS TABLE(canal character varying, total_ventas integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        CASE
            WHEN c.tienda_fisica_id_tienda IS NOT NULL THEN 'Tienda F├¡sica'
            WHEN c.tienda_web_id_tienda IS NOT NULL THEN 'Tienda Web'
            ELSE 'Otro'
        END::VARCHAR AS canal,
        COUNT(DISTINCT c.id_compra)::INTEGER AS total_ventas
    FROM Compra c
    JOIN Pago_Compra pc ON c.id_compra = pc.compra_id
    GROUP BY canal
    ORDER BY canal;
END;
$$;


ALTER FUNCTION public.get_ventas_por_canal() OWNER TO daniel_bd;

--
-- Name: get_ventas_por_empleado(date, date); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_ventas_por_empleado(p_fecha_inicio date, p_fecha_fin date) RETURNS TABLE(id_empleado integer, nombre_empleado character varying, cantidad_ventas integer, monto_total_ventas numeric, promedio_por_venta numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    -- Ventas por empleado
    SELECT
        e.id_empleado,
        CONCAT(
            e.primer_nombre, ' ',
            COALESCE(e.segundo_nombre, ''), ' ',
            e.primer_apellido, ' ',
            COALESCE(e.segundo_apellido, '')
        )::VARCHAR as nombre_empleado,
        COUNT(DISTINCT cu.id_compra)::INTEGER as cantidad_ventas,
        COALESCE(SUM(cu.monto), 0) as monto_total_ventas,
        CASE
            WHEN COUNT(DISTINCT cu.id_compra) > 0 THEN
                COALESCE(SUM(cu.monto), 0) / COUNT(DISTINCT cu.id_compra)
            ELSE 0
        END as promedio_por_venta
    FROM Empleado e
    JOIN (
        SELECT DISTINCT dc.id_empleado, c.id_compra, pc.monto
        FROM Detalle_Compra dc
        JOIN Compra c ON dc.id_compra = c.id_compra
        JOIN Pago_Compra pc ON c.id_compra = pc.compra_id
        WHERE pc.fecha_hora BETWEEN p_fecha_inicio AND p_fecha_fin
          AND c.tienda_fisica_id_tienda IS NOT NULL
          AND dc.id_empleado IS NOT NULL
    ) AS cu ON cu.id_empleado = e.id_empleado
    GROUP BY e.id_empleado, e.primer_nombre, e.segundo_nombre, e.primer_apellido, e.segundo_apellido

    UNION ALL

    -- Ventas f├¡sicas sin empleado
    SELECT
        NULL as id_empleado,
        'Ventas sin empleado'::VARCHAR as nombre_empleado,
        COUNT(DISTINCT c.id_compra)::INTEGER as cantidad_ventas,
        COALESCE(SUM(pc.monto), 0) as monto_total_ventas,
        CASE
            WHEN COUNT(DISTINCT c.id_compra) > 0 THEN
                COALESCE(SUM(pc.monto), 0) / COUNT(DISTINCT c.id_compra)
            ELSE 0
        END as promedio_por_venta
    FROM Compra c
    JOIN Pago_Compra pc ON c.id_compra = pc.compra_id
    LEFT JOIN Detalle_Compra dc ON c.id_compra = dc.id_compra
    WHERE pc.fecha_hora BETWEEN p_fecha_inicio AND p_fecha_fin
      AND c.tienda_fisica_id_tienda IS NOT NULL
      AND (dc.id_empleado IS NULL OR dc.id_empleado = 0)
    ;
END;
$$;


ALTER FUNCTION public.get_ventas_por_empleado(p_fecha_inicio date, p_fecha_fin date) OWNER TO daniel_bd;

--
-- Name: get_ventas_por_estilo(date, date); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_ventas_por_estilo(p_fecha_inicio date, p_fecha_fin date) RETURNS TABLE(estilo_cerveza character varying, unidades_vendidas integer, monto_total numeric, porcentaje_ventas numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH 
    -- =================================================================
    -- CTE 1: VENTAS POR ESTILO DE CERVEZA
    -- =================================================================
    -- Agrupa las ventas por estilo de cerveza y calcula:
    -- - Total de unidades vendidas por estilo
    -- - Monto total en dinero por estilo
    -- JOINs necesarios: Detalle_Compra ├óΓÇáΓÇÖ Compra ├óΓÇáΓÇÖ Pago_Compra ├óΓÇáΓÇÖ Inventario ├óΓÇáΓÇÖ Cerveza ├óΓÇáΓÇÖ Tipo_Cerveza
    ventas_estilos AS (
        SELECT 
            tc.nombre as estilo,
            SUM(dc.cantidad) as unidades,
            SUM(dc.cantidad * dc.precio_unitario) as monto
        FROM Detalle_Compra dc
        JOIN Compra c ON dc.id_compra = c.id_compra
        JOIN Pago_Compra pc ON c.id_compra = pc.compra_id
        JOIN Inventario i ON dc.id_inventario = i.id_inventario
        JOIN Cerveza ce ON i.id_cerveza = ce.id_cerveza
        JOIN Tipo_Cerveza tc ON ce.id_tipo_cerveza = tc.id_tipo_cerveza
        WHERE pc.fecha_hora BETWEEN p_fecha_inicio AND p_fecha_fin
        GROUP BY tc.id_tipo_cerveza, tc.nombre
    ),
    -- =================================================================
    -- CTE 2: TOTAL DE VENTAS GENERAL
    -- =================================================================
    -- Calcula el total general de ventas para calcular porcentajes
    total_ventas AS (
        SELECT SUM(monto) as total
        FROM ventas_estilos
    )
    -- =================================================================
    -- SELECT FINAL: COMBINA VENTAS POR ESTILO CON TOTALES
    -- =================================================================
    SELECT 
        ve.estilo,
        ve.unidades::INTEGER,
        ve.monto,
        -- Calcula el porcentaje de participaci├â┬│n (evita divisi├â┬│n por cero)
        CASE 
            WHEN tv.total > 0 THEN (ve.monto / tv.total) * 100
            ELSE 0
        END as porcentaje
    FROM ventas_estilos ve
    CROSS JOIN total_ventas tv
    ORDER BY ve.unidades DESC;  -- Ordena por unidades vendidas (m├â┬ís vendido primero)
END;
$$;


ALTER FUNCTION public.get_ventas_por_estilo(p_fecha_inicio date, p_fecha_fin date) OWNER TO daniel_bd;

--
-- Name: get_ventas_por_periodo(date, date, character varying); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_ventas_por_periodo(p_fecha_inicio date, p_fecha_fin date, p_tipo_periodo character varying DEFAULT 'day'::character varying) RETURNS TABLE(periodo character varying, ventas_totales numeric, unidades_vendidas integer, numero_compras integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        CASE p_tipo_periodo
            WHEN 'day' THEN TO_CHAR(pc.fecha_hora, 'YYYY-MM-DD')
            WHEN 'week' THEN TO_CHAR(pc.fecha_hora, 'YYYY-WW')
            WHEN 'month' THEN TO_CHAR(pc.fecha_hora, 'YYYY-MM')
        END as periodo,
        -- =================================================================
        -- MeTRICAS CALCULADAS POR PER├â┬ìODO
        -- =================================================================
        SUM(pc.monto) as ventas_totales,           -- Suma de todos los pagos
        SUM(dc.cantidad)::INTEGER as unidades_vendidas,     -- Suma de todas las unidades vendidas
        COUNT(DISTINCT c.id_compra)::INTEGER as numero_compras  -- Cuenta compras ├â┬║nicas
    FROM Pago_Compra pc
    JOIN Compra c ON pc.compra_id = c.id_compra
    JOIN Detalle_Compra dc ON c.id_compra = dc.id_compra
    WHERE pc.fecha_hora BETWEEN p_fecha_inicio AND p_fecha_fin
    GROUP BY periodo  -- Agrupa por el per├â┬¡odo calculado
    ORDER BY periodo; -- Ordena cronol├â┬│gicamente
END;
$$;


ALTER FUNCTION public.get_ventas_por_periodo(p_fecha_inicio date, p_fecha_fin date, p_tipo_periodo character varying) OWNER TO daniel_bd;

--
-- Name: get_volumen_por_presentacion(date, date); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.get_volumen_por_presentacion(p_fecha_inicio date, p_fecha_fin date) RETURNS TABLE(presentacion character varying, volumen_total bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.nombre as presentacion,
        COALESCE(SUM(dc.cantidad), 0) as volumen_total
    FROM Presentacion p
    LEFT JOIN Inventario i ON p.id_presentacion = i.id_presentacion
    LEFT JOIN Detalle_Compra dc ON i.id_inventario = dc.id_inventario
    LEFT JOIN Compra c ON dc.id_compra = c.id_compra
    LEFT JOIN Pago_Compra pc ON c.id_compra = pc.compra_id
    WHERE pc.fecha_hora BETWEEN p_fecha_inicio AND p_fecha_fin
    GROUP BY p.id_presentacion, p.nombre
    ORDER BY volumen_total DESC;
END;
$$;


ALTER FUNCTION public.get_volumen_por_presentacion(p_fecha_inicio date, p_fecha_fin date) OWNER TO daniel_bd;

--
-- Name: insertar_metodo_pago_automatico(integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.insertar_metodo_pago_automatico(p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    nuevo_id INTEGER;
BEGIN
    -- Obtener el siguiente ID disponible
    SELECT obtener_siguiente_id_metodo_pago() INTO nuevo_id;
    
    -- Insertar el m├⌐todo de pago con el ID calculado
    INSERT INTO Metodo_Pago (id_metodo, id_cliente_natural, id_cliente_juridico)
    VALUES (nuevo_id, p_id_cliente_natural, p_id_cliente_juridico);
    
    RETURN nuevo_id;
END;
$$;


ALTER FUNCTION public.insertar_metodo_pago_automatico(p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: insertar_nueva_tasa(character varying, numeric); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.insertar_nueva_tasa(p_nombre character varying, p_valor numeric) RETURNS TABLE(id_tasa integer, nombre character varying, valor numeric, fecha date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    INSERT INTO Tasa (nombre, valor, fecha)
    VALUES (p_nombre, p_valor, CURRENT_DATE)
    RETURNING Tasa.id_tasa, Tasa.nombre, Tasa.valor, Tasa.fecha;
END;
$$;


ALTER FUNCTION public.insertar_nueva_tasa(p_nombre character varying, p_valor numeric) OWNER TO daniel_bd;

--
-- Name: limpiar_carrito_por_id(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.limpiar_carrito_por_id(p_id_compra integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM Detalle_Compra WHERE id_compra = p_id_compra;
END;
$$;


ALTER FUNCTION public.limpiar_carrito_por_id(p_id_compra integer) OWNER TO daniel_bd;

--
-- Name: limpiar_carrito_usuario(integer, json); Type: PROCEDURE; Schema: public; Owner: daniel_bd
--

CREATE PROCEDURE public.limpiar_carrito_usuario(IN p_id_usuario integer, INOUT p_resultado json)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INTEGER;
    v_productos_eliminados INTEGER;
BEGIN
    v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario);
    
    IF v_id_compra IS NULL THEN
        p_resultado := json_build_object('success', false, 'message', 'No se encontr├│ carrito');
        RETURN;
    END IF;

    DELETE FROM Detalle_Compra WHERE id_compra = v_id_compra;
    GET DIAGNOSTICS v_productos_eliminados = ROW_COUNT;
    
    p_resultado := json_build_object('success', true, 'message', 'Carrito limpiado', 'productos_eliminados', v_productos_eliminados);
END;
$$;


ALTER PROCEDURE public.limpiar_carrito_usuario(IN p_id_usuario integer, INOUT p_resultado json) OWNER TO daniel_bd;

--
-- Name: PROCEDURE limpiar_carrito_usuario(IN p_id_usuario integer, INOUT p_resultado json); Type: COMMENT; Schema: public; Owner: daniel_bd
--

COMMENT ON PROCEDURE public.limpiar_carrito_usuario(IN p_id_usuario integer, INOUT p_resultado json) IS 'Procedimiento: Vac├¡a el carrito del usuario.';


--
-- Name: limpiar_carrito_usuario(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.limpiar_carrito_usuario(p_id_usuario integer, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_carrito_por_tipo(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);
    
    IF v_id_compra IS NULL THEN
        RAISE EXCEPTION 'No se encontr├│ carrito';
    END IF;

    DELETE FROM Detalle_Compra WHERE id_compra = v_id_compra;
    
    -- Actualizar el monto total de la compra
    PERFORM actualizar_monto_compra(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);
END;
$$;


ALTER FUNCTION public.limpiar_carrito_usuario(p_id_usuario integer, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: limpiar_puntos_cliente(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.limpiar_puntos_cliente(p_id_cliente_natural integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_registros_eliminados INTEGER;
BEGIN
    DELETE FROM Punto_Cliente 
    WHERE id_cliente_natural = p_id_cliente_natural;
    
    GET DIAGNOSTICS v_registros_eliminados = ROW_COUNT;
    
    RETURN v_registros_eliminados;
END;
$$;


ALTER FUNCTION public.limpiar_puntos_cliente(p_id_cliente_natural integer) OWNER TO daniel_bd;

--
-- Name: obtener_carrito_por_id(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_carrito_por_id(p_id_compra integer) RETURNS TABLE(id_inventario integer, nombre_cerveza character varying, nombre_presentacion character varying, cantidad_solicitada integer, stock_disponible integer, stock_suficiente boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
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
    WHERE dc.id_compra = p_id_compra
    ORDER BY stock_suficiente ASC, c.nombre_cerveza;
END;
$$;


ALTER FUNCTION public.obtener_carrito_por_id(p_id_compra integer) OWNER TO daniel_bd;

--
-- Name: obtener_carrito_por_tipo(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_carrito_por_tipo(p_id_usuario integer DEFAULT NULL::integer, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INTEGER;
BEGIN
    -- Determinar el tipo de compra bas├índose en los par├ímetros
    IF p_id_cliente_natural IS NOT NULL OR p_id_cliente_juridico IS NOT NULL THEN
        -- Compra en tienda f├¡sica: usar cliente, NO usuario
        v_id_compra := obtener_o_crear_carrito_usuario(NULL, p_id_cliente_natural, p_id_cliente_juridico);
    ELSE
        -- Compra web: usar usuario, NO cliente
        v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario, NULL, NULL);
    END IF;
    
    RETURN v_id_compra;
END;
$$;


ALTER FUNCTION public.obtener_carrito_por_tipo(p_id_usuario integer, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: obtener_carrito_usuario(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_carrito_usuario(p_id_usuario integer) RETURNS TABLE(id_compra integer, id_inventario integer, id_cerveza integer, nombre_cerveza character varying, id_presentacion integer, nombre_presentacion character varying, cantidad integer, precio_unitario numeric, subtotal numeric, stock_disponible integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario, NULL, NULL);
    
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
$$;


ALTER FUNCTION public.obtener_carrito_usuario(p_id_usuario integer) OWNER TO daniel_bd;

--
-- Name: FUNCTION obtener_carrito_usuario(p_id_usuario integer); Type: COMMENT; Schema: public; Owner: daniel_bd
--

COMMENT ON FUNCTION public.obtener_carrito_usuario(p_id_usuario integer) IS 'Funci├│n: Obtiene los productos del carrito.';


--
-- Name: obtener_carrito_usuario(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_carrito_usuario(p_id_usuario integer, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS TABLE(id_compra integer, id_inventario integer, id_cerveza integer, nombre_cerveza character varying, id_presentacion integer, nombre_presentacion character varying, cantidad integer, precio_unitario numeric, subtotal numeric, stock_disponible integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_carrito_por_tipo(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);
    
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
$$;


ALTER FUNCTION public.obtener_carrito_usuario(p_id_usuario integer, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: obtener_historial_puntos_cliente(integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_historial_puntos_cliente(p_id_cliente_natural integer, p_limite integer DEFAULT 50) RETURNS TABLE(fecha date, tipo_movimiento character varying, cantidad_mov integer, saldo_acumulado integer, referencia text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pc.fecha,
        pc.tipo_movimiento,
        pc.cantidad_mov,
        SUM(pc.cantidad_mov) OVER (
            ORDER BY pc.fecha, pc.id_punto_cliente
            ROWS UNBOUNDED PRECEDING
        )::INTEGER as saldo_acumulado,
        CASE 
            WHEN pc.tipo_movimiento = 'GANADO' THEN 'Compra en tienda f├¡sica'
            WHEN pc.tipo_movimiento = 'GASTADO' THEN 'Pago con puntos'
            ELSE 'Otro'
        END as referencia
    FROM Punto_Cliente pc
    WHERE pc.id_cliente_natural = p_id_cliente_natural
    ORDER BY pc.fecha DESC, pc.id_punto_cliente DESC
    LIMIT p_limite;
END;
$$;


ALTER FUNCTION public.obtener_historial_puntos_cliente(p_id_cliente_natural integer, p_limite integer) OWNER TO daniel_bd;

--
-- Name: obtener_info_puntos_cliente(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_info_puntos_cliente(p_id_cliente_natural integer) RETURNS TABLE(saldo_actual integer, puntos_ganados integer, puntos_gastados integer, valor_punto numeric, minimo_canje integer, tasa_actual numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_saldo INTEGER;
    v_ganados INTEGER;
    v_gastados INTEGER;
    v_valor_punto DECIMAL;
    v_minimo INTEGER;
    v_tasa DECIMAL;
BEGIN
    -- Obtener saldo actual
    SELECT obtener_saldo_puntos_cliente(p_id_cliente_natural) INTO v_saldo;
    
    -- Obtener puntos ganados y gastados
    SELECT 
        COALESCE(SUM(CASE WHEN tipo_movimiento = 'GANADO' THEN cantidad_mov ELSE 0 END), 0),
        COALESCE(SUM(CASE WHEN tipo_movimiento = 'GASTADO' THEN ABS(cantidad_mov) ELSE 0 END), 0)
    INTO v_ganados, v_gastados
    FROM Punto_Cliente pc
    WHERE pc.id_cliente_natural = p_id_cliente_natural;
    
    -- Obtener configuraci├│n de puntos desde la fila espec├¡fica
    SELECT valor INTO v_valor_punto
    FROM Tasa 
    WHERE nombre = 'Punto' AND punto_id = 51
    LIMIT 1;
    
    SELECT valor INTO v_minimo
    FROM Tasa 
    WHERE punto_id IS NOT NULL AND nombre LIKE '%m├¡nimo%'
    ORDER BY fecha DESC 
    LIMIT 1;
    
    SELECT valor INTO v_tasa
    FROM Tasa 
    WHERE punto_id IS NOT NULL AND nombre LIKE '%tasa%'
    ORDER BY fecha DESC 
    LIMIT 1;
    
    -- Valores por defecto si no hay configuraci├│n
    v_valor_punto := COALESCE(v_valor_punto, 1.0);
    v_minimo := COALESCE(v_minimo, 5);
    v_tasa := COALESCE(v_tasa, 1.0);
    
    RETURN QUERY
    SELECT 
        v_saldo,
        v_ganados,
        v_gastados,
        v_valor_punto,
        v_minimo,
        v_tasa;
END;
$$;


ALTER FUNCTION public.obtener_info_puntos_cliente(p_id_cliente_natural integer) OWNER TO daniel_bd;

--
-- Name: obtener_metodo_pago_completo(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_metodo_pago_completo(p_id_metodo integer) RETURNS TABLE(id_metodo integer, tipo_metodo character varying, id_cliente_natural integer, id_cliente_juridico integer, datos_especificos json)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        mp.id_metodo,
        CASE 
            WHEN c.id_metodo IS NOT NULL THEN 'cheque'
            WHEN e.id_metodo IS NOT NULL THEN 'efectivo'
            WHEN tc.id_metodo IS NOT NULL THEN 'tarjeta_credito'
            WHEN td.id_metodo IS NOT NULL THEN 'tarjeta_debito'
            ELSE 'desconocido'
        END AS tipo_metodo,
        mp.id_cliente_natural,
        mp.id_cliente_juridico,
        CASE 
            WHEN c.id_metodo IS NOT NULL THEN 
                json_build_object(
                    'num_cheque', c.num_cheque,
                    'num_cuenta', c.num_cuenta,
                    'banco', c.banco
                )
            WHEN e.id_metodo IS NOT NULL THEN 
                json_build_object('denominacion', e.denominacion)
            WHEN tc.id_metodo IS NOT NULL THEN 
                json_build_object(
                    'tipo', tc.tipo,
                    'numero', tc.numero,
                    'banco', tc.banco,
                    'fecha_vencimiento', tc.fecha_vencimiento
                )
            WHEN td.id_metodo IS NOT NULL THEN 
                json_build_object(
                    'numero', td.numero,
                    'banco', td.banco
                )
            ELSE '{}'::json
        END AS datos_especificos
    FROM Metodo_Pago mp
    LEFT JOIN Cheque c ON mp.id_metodo = c.id_metodo
    LEFT JOIN Efectivo e ON mp.id_metodo = e.id_metodo
    LEFT JOIN Tarjeta_Credito tc ON mp.id_metodo = tc.id_metodo
    LEFT JOIN Tarjeta_Debito td ON mp.id_metodo = td.id_metodo
    WHERE mp.id_metodo = p_id_metodo;
END;
$$;


ALTER FUNCTION public.obtener_metodo_pago_completo(p_id_metodo integer) OWNER TO daniel_bd;

--
-- Name: FUNCTION obtener_metodo_pago_completo(p_id_metodo integer); Type: COMMENT; Schema: public; Owner: daniel_bd
--

COMMENT ON FUNCTION public.obtener_metodo_pago_completo(p_id_metodo integer) IS 'Funci├│n: Obtiene informaci├│n completa de un m├⌐todo de pago incluyendo datos espec├¡ficos';


--
-- Name: obtener_o_crear_carrito_cliente_en_proceso(integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_o_crear_carrito_cliente_en_proceso(p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INTEGER;
    v_id_estatus_en_proceso INTEGER;
    v_now TIMESTAMP := NOW();
BEGIN
    -- Obtener el id_estatus para 'En proceso' (case-insensitive)
    SELECT id_estatus INTO v_id_estatus_en_proceso FROM Estatus WHERE LOWER(nombre) = 'en proceso' LIMIT 1;
    IF v_id_estatus_en_proceso IS NULL THEN
        RAISE EXCEPTION 'No existe el estatus "en proceso" en la tabla Estatus';
    END IF;

    -- Buscar si ya existe una compra abierta "en proceso" para este cliente
    SELECT c.id_compra INTO v_id_compra
    FROM Compra c
    JOIN Compra_Estatus ce ON ce.compra_id_compra = c.id_compra
    WHERE (
        (p_id_cliente_natural IS NOT NULL AND c.id_cliente_natural = p_id_cliente_natural)
        OR (p_id_cliente_juridico IS NOT NULL AND c.id_cliente_juridico = p_id_cliente_juridico)
    )
    AND ce.estatus_id_estatus = v_id_estatus_en_proceso
    AND ce.fecha_hora_fin > v_now
    LIMIT 1;

    -- Si ya existe, retornar el id_compra
    IF v_id_compra IS NOT NULL THEN
        RETURN v_id_compra;
    END IF;

    -- Si no existe, crear una nueva compra respetando los arcos de exclusividad
    INSERT INTO Compra (id_cliente_natural, id_cliente_juridico, monto_total, tienda_fisica_id_tienda)
    VALUES (
        p_id_cliente_natural,
        p_id_cliente_juridico,
        0,
        1 -- Asume tienda f├¡sica con id 1, ajusta si es necesario
    ) RETURNING id_compra INTO v_id_compra;

    -- Asociar la compra con estatus 'en proceso' en Compra_Estatus
    INSERT INTO Compra_Estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion, fecha_hora_fin)
    VALUES (v_id_compra, v_id_estatus_en_proceso, v_now, '9999-12-31 23:59:59');

    RETURN v_id_compra;
END;
$$;


ALTER FUNCTION public.obtener_o_crear_carrito_cliente_en_proceso(p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: obtener_o_crear_carrito_usuario(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_o_crear_carrito_usuario(p_id_usuario integer DEFAULT NULL::integer, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INTEGER;
    v_id_estatus_en_proceso INTEGER;
    v_now TIMESTAMP := NOW();
BEGIN
    -- Obtener el id_estatus para 'En proceso'
    SELECT id_estatus INTO v_id_estatus_en_proceso FROM Estatus WHERE LOWER(nombre) = 'en proceso' LIMIT 1;
    IF v_id_estatus_en_proceso IS NULL THEN
        RAISE EXCEPTION 'No existe el estatus "en proceso" en la tabla Estatus';
    END IF;

    -- Si es compra f├¡sica (cliente), delegar a la funci├│n existente
    IF p_id_cliente_natural IS NOT NULL OR p_id_cliente_juridico IS NOT NULL THEN
        RETURN obtener_o_crear_carrito_cliente_en_proceso(p_id_cliente_natural, p_id_cliente_juridico);
    END IF;

    -- Si es compra web (usuario)
    -- Buscar si ya existe una compra abierta "en proceso" para este usuario
    SELECT c.id_compra INTO v_id_compra
    FROM Compra c
    JOIN Compra_Estatus ce ON ce.compra_id_compra = c.id_compra
    WHERE c.usuario_id_usuario = p_id_usuario
      AND ce.estatus_id_estatus = v_id_estatus_en_proceso
      AND ce.fecha_hora_fin > v_now
    LIMIT 1;

    IF v_id_compra IS NOT NULL THEN
        RETURN v_id_compra;
    END IF;

    -- Si no existe, crear una nueva compra web con tienda_web_id_tienda = 1
    INSERT INTO Compra (usuario_id_usuario, monto_total, tienda_web_id_tienda)
    VALUES (p_id_usuario, 0, 1)
    RETURNING id_compra INTO v_id_compra;

    -- Asociar la compra con estatus 'en proceso' en Compra_Estatus
    INSERT INTO Compra_Estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion, fecha_hora_fin)
    VALUES (v_id_compra, v_id_estatus_en_proceso, v_now, '9999-12-31 23:59:59');

    RETURN v_id_compra;
END;
$$;


ALTER FUNCTION public.obtener_o_crear_carrito_usuario(p_id_usuario integer, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: obtener_productos_catalogo(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_productos_catalogo(p_sort_by character varying DEFAULT 'relevance'::character varying, p_page integer DEFAULT 1, p_limit integer DEFAULT 9) RETURNS TABLE(id_cerveza integer, nombre_cerveza character varying, tipo_cerveza character varying, min_price numeric, presentaciones json)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH UnicoInventario AS (
        SELECT DISTINCT ON (i.id_cerveza, i.id_presentacion)
            i.id_inventario, i.cantidad, i.id_presentacion, i.id_cerveza
        FROM Inventario i
        -- Priorizamos la tienda f├¡sica si hay m├║ltiples entradas
        ORDER BY i.id_cerveza, i.id_presentacion, i.id_tienda_fisica DESC NULLS LAST
    )
    SELECT
        c.id_cerveza, 
        c.nombre_cerveza, 
        tc.nombre AS tipo_cerveza,
        MIN(pc.precio) as min_price, -- Helper para ordenar por precio
        COALESCE(
            json_agg(
                json_build_object(
                    'id_inventario', ui.id_inventario,
                    'id_presentacion', p.id_presentacion, 
                    'nombre_presentacion', p.nombre,
                    'precio_unitario', pc.precio,
                    'stock_disponible', COALESCE(ui.cantidad, 0)
                ) ORDER BY p.id_presentacion
            ) FILTER (WHERE p.id_presentacion IS NOT NULL),
            '[]'::json
        ) AS presentaciones
    FROM Cerveza c
    JOIN Tipo_Cerveza tc ON c.id_tipo_cerveza = tc.id_tipo_cerveza
    LEFT JOIN presentacion_cerveza pc ON c.id_cerveza = pc.id_cerveza
    LEFT JOIN Presentacion p ON pc.id_presentacion = p.id_presentacion
    -- Unimos con nuestro inventario ├║nico para evitar duplicados
    LEFT JOIN UnicoInventario ui ON pc.id_cerveza = ui.id_cerveza AND pc.id_presentacion = ui.id_presentacion
    GROUP BY c.id_cerveza, tc.nombre
    ORDER BY 
        CASE WHEN p_sort_by = 'price-asc' THEN MIN(pc.precio) END ASC NULLS LAST,
        CASE WHEN p_sort_by = 'price-desc' THEN MIN(pc.precio) END DESC NULLS LAST,
        CASE WHEN p_sort_by = 'name-asc' THEN c.nombre_cerveza END ASC,
        CASE WHEN p_sort_by = 'name-desc' THEN c.nombre_cerveza END DESC,
        CASE WHEN p_sort_by = 'relevance' THEN c.id_cerveza END ASC
    LIMIT p_limit OFFSET ((p_page - 1) * p_limit);
END;
$$;


ALTER FUNCTION public.obtener_productos_catalogo(p_sort_by character varying, p_page integer, p_limit integer) OWNER TO daniel_bd;

--
-- Name: obtener_resumen_carrito(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_resumen_carrito(p_id_usuario integer) RETURNS TABLE(id_compra integer, total_productos integer, total_items integer, monto_total numeric, items_carrito json)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INTEGER;
    v_items JSON;
BEGIN
    v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario, NULL, NULL);
    
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
$$;


ALTER FUNCTION public.obtener_resumen_carrito(p_id_usuario integer) OWNER TO daniel_bd;

--
-- Name: FUNCTION obtener_resumen_carrito(p_id_usuario integer); Type: COMMENT; Schema: public; Owner: daniel_bd
--

COMMENT ON FUNCTION public.obtener_resumen_carrito(p_id_usuario integer) IS 'Funci├│n: Obtiene el resumen del carrito.';


--
-- Name: obtener_resumen_carrito(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_resumen_carrito(p_id_usuario integer, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS TABLE(id_compra integer, total_productos integer, total_items integer, monto_total numeric, items_carrito json)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INTEGER;
    v_items JSON;
BEGIN
    v_id_compra := obtener_carrito_por_tipo(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);
    
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
$$;


ALTER FUNCTION public.obtener_resumen_carrito(p_id_usuario integer, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

--
-- Name: obtener_resumen_carrito_por_id(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_resumen_carrito_por_id(p_id_compra integer) RETURNS TABLE(id_compra integer, total_productos integer, total_items integer, monto_total numeric, items_carrito json, estatus_id integer, estatus_nombre character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_items JSON;
    v_estatus_id INTEGER;
    v_estatus_nombre VARCHAR(50);
    v_estatus_en_proceso_id INTEGER;
BEGIN
    -- Obtener el id del estatus "en proceso"
    SELECT id_estatus INTO v_estatus_en_proceso_id 
    FROM Estatus 
    WHERE LOWER(nombre) = 'en proceso' 
    LIMIT 1;

    -- Obtener el estatus actual de la compra (el abierto)
    SELECT ce.estatus_id_estatus, e.nombre INTO v_estatus_id, v_estatus_nombre
    FROM Compra_Estatus ce
    JOIN Estatus e ON ce.estatus_id_estatus = e.id_estatus
    WHERE ce.compra_id_compra = p_id_compra
      AND ce.fecha_hora_fin = '9999-12-31 23:59:59'
    LIMIT 1;

    -- Si la compra NO est├í en proceso, devolver 0 items
    IF v_estatus_id IS NULL OR v_estatus_id != v_estatus_en_proceso_id THEN
        RETURN QUERY
        SELECT p_id_compra, 0::INTEGER, 0::INTEGER, 0::DECIMAL, '[]'::json, v_estatus_id, v_estatus_nombre;
        RETURN;
    END IF;

    -- Solo obtener items si la compra est├í en proceso
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
    WHERE dc.id_compra = p_id_compra;

    -- Si no hay items, devolver valores por defecto
    IF v_items IS NULL THEN
        RETURN QUERY
        SELECT p_id_compra, 0::INTEGER, 0::INTEGER, 0::DECIMAL, '[]'::json, v_estatus_id, v_estatus_nombre;
        RETURN;
    END IF;

    -- Devolver el resumen con los items y el estatus
    RETURN QUERY
    SELECT 
        p_id_compra,
        COUNT(DISTINCT dc.id_inventario)::INTEGER,
        COALESCE(SUM(dc.cantidad), 0)::INTEGER,
        COALESCE(SUM(dc.cantidad * dc.precio_unitario), 0),
        v_items,
        v_estatus_id,
        v_estatus_nombre
    FROM Detalle_Compra dc
    WHERE dc.id_compra = p_id_compra;
END;
$$;


ALTER FUNCTION public.obtener_resumen_carrito_por_id(p_id_compra integer) OWNER TO daniel_bd;

--
-- Name: obtener_saldo_puntos_cliente(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_saldo_puntos_cliente(p_id_cliente_natural integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_saldo INTEGER;
BEGIN
    SELECT COALESCE(SUM(pc.cantidad_mov), 0) INTO v_saldo
    FROM Punto_Cliente pc
    WHERE pc.id_cliente_natural = p_id_cliente_natural;
    
    RETURN v_saldo;
END;
$$;


ALTER FUNCTION public.obtener_saldo_puntos_cliente(p_id_cliente_natural integer) OWNER TO daniel_bd;

--
-- Name: obtener_siguiente_id_metodo_pago(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_siguiente_id_metodo_pago() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    siguiente_id INTEGER;
    max_id INTEGER;
BEGIN
    -- Obtener el m├íximo ID existente
    SELECT COALESCE(MAX(id_metodo), 0) INTO max_id
    FROM Metodo_Pago;
    
    -- Calcular el siguiente ID
    siguiente_id := max_id + 1;
    
    -- Solo ajustar la secuencia si hay registros existentes
    IF max_id > 0 THEN
        PERFORM setval('metodo_pago_id_metodo_seq', max_id, true);
    END IF;
    
    RETURN siguiente_id;
END;
$$;


ALTER FUNCTION public.obtener_siguiente_id_metodo_pago() OWNER TO daniel_bd;

--
-- Name: obtener_tasa_actual_dolar(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.obtener_tasa_actual_dolar() RETURNS TABLE(id_tasa integer, nombre character varying, valor numeric, fecha date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT t.id_tasa, t.nombre, t.valor, t.fecha
    FROM Tasa t
    WHERE t.nombre = 'D├│lar Estadounidense'
    ORDER BY t.fecha DESC, t.id_tasa DESC
    LIMIT 1;
END;
$$;


ALTER FUNCTION public.obtener_tasa_actual_dolar() OWNER TO daniel_bd;

--
-- Name: registrar_pagos_y_descuento_inventario(integer, json); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.registrar_pagos_y_descuento_inventario(p_compra_id integer, p_pagos json) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_pago JSON;
    v_metodo_id INTEGER;
    v_monto NUMERIC;
    v_tasa_id INTEGER;
    v_referencia TEXT;
    v_fecha TIMESTAMP := NOW();
    v_id_inventario INTEGER;
    v_cantidad INTEGER;
    v_stock_actual INTEGER;
    v_tipo_metodo VARCHAR(20);
    v_id_cliente_natural INTEGER;
    v_id_cliente_juridico INTEGER;
    v_puntos_acumulados INTEGER;
    v_id_estatus_atendida INTEGER;
BEGIN
    -- Obtener informaci├│n del cliente de la compra
    SELECT id_cliente_natural, id_cliente_juridico 
    INTO v_id_cliente_natural, v_id_cliente_juridico
    FROM Compra 
    WHERE id_compra = p_compra_id;
    
    -- Insertar cada pago
    FOR v_pago IN SELECT * FROM json_array_elements(p_pagos) LOOP
        v_tipo_metodo := v_pago->>'tipo';
        v_monto := (v_pago->>'monto')::NUMERIC;
        v_tasa_id := NULLIF((v_pago->>'tasa_id')::INTEGER, 0);
        
        -- Crear m├⌐todo de pago seg├║n el tipo con datos espec├¡ficos
        CASE v_tipo_metodo
            WHEN 'cheque' THEN
                v_metodo_id := crear_metodo_pago_cheque(
                    (v_pago->>'num_cheque')::VARCHAR(20),
                    (v_pago->>'num_cuenta')::VARCHAR(20),
                    v_pago->>'banco',
                    v_id_cliente_natural,
                    v_id_cliente_juridico
                );
            WHEN 'efectivo' THEN
                v_metodo_id := crear_metodo_pago_efectivo(
                    (v_pago->>'denominacion')::INTEGER,
                    v_id_cliente_natural,
                    v_id_cliente_juridico
                );
            WHEN 'tarjeta_credito' THEN
                v_metodo_id := crear_metodo_pago_tarjeta_credito(
                    v_pago->>'tipo_tarjeta',
                    v_pago->>'numero',
                    v_pago->>'banco',
                    (v_pago->>'fecha_vencimiento')::DATE,
                    v_id_cliente_natural,
                    v_id_cliente_juridico
                );
            WHEN 'tarjeta_debito' THEN
                v_metodo_id := crear_metodo_pago_tarjeta_debito(
                    v_pago->>'numero',
                    v_pago->>'banco',
                    v_id_cliente_natural,
                    v_id_cliente_juridico
                );
            WHEN 'puntos' THEN
                -- Para pagos con puntos, usar la funci├│n espec├¡fica
                v_puntos_acumulados := usar_puntos_como_pago(
                    v_id_cliente_natural,
                    (v_pago->>'puntos_usados')::INTEGER,
                    p_compra_id
                );
                -- Continuar al siguiente pago ya que usar_puntos_como_pago ya registra el pago
                CONTINUE;
            ELSE
                RAISE EXCEPTION 'Tipo de m├⌐todo de pago no v├ílido: %', v_tipo_metodo;
        END CASE;
        
        -- Asignar tasa por defecto seg├║n el tipo de m├⌐todo
        IF v_tasa_id IS NULL THEN
            -- Efectivo y Cheque no tienen tasa
            IF v_tipo_metodo IN ('efectivo', 'cheque') THEN
                v_tasa_id := NULL;
            -- Tarjetas de cr├⌐dito y d├⌐bito usan tasa por defecto
            ELSE
                v_tasa_id := 1; -- Tasa por defecto
            END IF;
        END IF;
        
        IF v_monto > 0 THEN
            v_referencia := CONCAT('PAGO-', v_metodo_id, '-', EXTRACT(EPOCH FROM v_fecha)::BIGINT, '-', floor(random()*10000)::INT);
            INSERT INTO Pago_Compra (metodo_id, compra_id, monto, fecha_hora, referencia, tasa_id)
            VALUES (v_metodo_id, p_compra_id, v_monto, v_fecha, v_referencia, v_tasa_id);
        END IF;
    END LOOP;
    
    -- Descontar inventario
    FOR v_id_inventario, v_cantidad IN SELECT id_inventario, cantidad FROM Detalle_Compra WHERE id_compra = p_compra_id LOOP
        SELECT cantidad INTO v_stock_actual FROM Inventario WHERE id_inventario = v_id_inventario;
        IF v_stock_actual < v_cantidad THEN
            RAISE EXCEPTION 'Stock insuficiente para inventario %', v_id_inventario;
        END IF;
        UPDATE Inventario SET cantidad = cantidad - v_cantidad WHERE id_inventario = v_id_inventario;
    END LOOP;
    
    -- Acumular puntos autom├íticamente para clientes naturales en compras f├¡sicas
    IF v_id_cliente_natural IS NOT NULL THEN
        v_puntos_acumulados := acumular_puntos_compra_fisica(p_compra_id);
        -- Log de puntos acumulados (opcional)
        IF v_puntos_acumulados > 0 THEN
            RAISE NOTICE 'Se acumularon % puntos para el cliente %', v_puntos_acumulados, v_id_cliente_natural;
        END IF;
    END IF;
    
    -- Cambiar estatus de la compra a 'Atendida' (estatus 3)
    SELECT id_estatus INTO v_id_estatus_atendida FROM Estatus WHERE LOWER(nombre) = 'atendida' LIMIT 1;

    IF v_id_estatus_atendida IS NULL THEN
        RAISE EXCEPTION 'No existe el estatus "Atendida" en la tabla Estatus';
    END IF;

    -- Cerrar el estatus anterior (ponerle fecha_hora_fin = NOW())
    UPDATE Compra_Estatus
    SET fecha_hora_fin = NOW()
    WHERE compra_id_compra = p_compra_id AND fecha_hora_fin = '9999-12-31 23:59:59';

    -- Insertar el nuevo estatus 'Atendida'
    INSERT INTO Compra_Estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion, fecha_hora_fin)
    VALUES (p_compra_id, v_id_estatus_atendida, NOW(), '9999-12-31 23:59:59');

    RETURN TRUE;
END;
$$;


ALTER FUNCTION public.registrar_pagos_y_descuento_inventario(p_compra_id integer, p_pagos json) OWNER TO daniel_bd;

--
-- Name: FUNCTION registrar_pagos_y_descuento_inventario(p_compra_id integer, p_pagos json); Type: COMMENT; Schema: public; Owner: daniel_bd
--

COMMENT ON FUNCTION public.registrar_pagos_y_descuento_inventario(p_compra_id integer, p_pagos json) IS 'Funci├│n: Registra pagos y descuenta inventario';


--
-- Name: set_estatus_orden_anaquel(integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.set_estatus_orden_anaquel(p_id_orden_reposicion integer, p_id_estatus integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_nombre_estatus VARCHAR;
BEGIN
    -- Insertar nuevo estatus
    INSERT INTO Estatus_Orden_Anaquel (
        id_orden_reposicion, id_estatus, fecha_hora_asignacion
    ) VALUES (
        p_id_orden_reposicion, p_id_estatus, NOW()
    );

    -- Si el estatus es 'Atendida', actualizar fecha_fin en la orden si existe ese campo
    SELECT nombre INTO v_nombre_estatus FROM Estatus WHERE id_estatus = p_id_estatus;

END;
$$;


ALTER FUNCTION public.set_estatus_orden_anaquel(p_id_orden_reposicion integer, p_id_estatus integer) OWNER TO daniel_bd;

--
-- Name: set_estatus_orden_reposicion(integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.set_estatus_orden_reposicion(p_id_orden_reposicion integer, p_id_estatus integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_proveedor INTEGER;
    v_id_departamento INTEGER;
    v_nombre_estatus VARCHAR;
BEGIN
    -- Obtener proveedor y departamento
    SELECT id_proveedor, id_departamento
    INTO v_id_proveedor, v_id_departamento
    FROM Orden_Reposicion
    WHERE id_orden_reposicion = p_id_orden_reposicion;

    -- Insertar nuevo estatus
    INSERT INTO Orden_Reposicion_Estatus (
        id_orden_reposicion, id_proveedor, id_departamento, id_estatus, fecha_asignacion
    ) VALUES (
        p_id_orden_reposicion, v_id_proveedor, v_id_departamento, p_id_estatus, NOW()
    );

    -- Si el estatus es 'Atendida', actualizar fecha_fin
    SELECT nombre INTO v_nombre_estatus FROM Estatus WHERE id_estatus = p_id_estatus;
    IF LOWER(v_nombre_estatus) = 'atendida' THEN
        UPDATE Orden_Reposicion SET fecha_fin = NOW() WHERE id_orden_reposicion = p_id_orden_reposicion;
    END IF;
END;
$$;


ALTER FUNCTION public.set_estatus_orden_reposicion(p_id_orden_reposicion integer, p_id_estatus integer) OWNER TO daniel_bd;

--
-- Name: set_rol_usuario(integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.set_rol_usuario(p_id_usuario integer, p_id_rol integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE Usuario SET id_rol = p_id_rol WHERE id_usuario = p_id_usuario;
END;
$$;


ALTER FUNCTION public.set_rol_usuario(p_id_usuario integer, p_id_rol integer) OWNER TO daniel_bd;

--
-- Name: update_role_privileges(integer, character varying, json); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.update_role_privileges(p_id_rol integer, p_nombre_rol character varying, p_privilegios json) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    priv_id INTEGER;
    p JSON;
BEGIN
    -- Update role name if different
    UPDATE Rol SET nombre = p_nombre_rol WHERE id_rol = p_id_rol;

    -- Delete pairs that are not in the new list
    DELETE FROM Rol_Privilegio
    WHERE id_rol = p_id_rol
      AND NOT EXISTS (
        SELECT 1 FROM json_array_elements(p_privilegios) AS j
        JOIN Privilegio pr ON pr.nombre = j->>'privilegio'
        WHERE Rol_Privilegio.id_privilegio = pr.id_privilegio
          AND Rol_Privilegio.nom_tabla_ojetivo = j->>'tabla'
      );

    -- Insert new pairs
    FOR p IN SELECT * FROM json_array_elements(p_privilegios)
    LOOP
        SELECT id_privilegio INTO priv_id FROM Privilegio WHERE nombre = p->>'privilegio';
        IF priv_id IS NULL THEN
            RAISE EXCEPTION 'Privilegio % no existe', p->>'privilegio';
        END IF;
        -- Insert if not exists
        INSERT INTO Rol_Privilegio(id_rol, id_privilegio, nom_tabla_ojetivo)
        SELECT p_id_rol, priv_id, p->>'tabla'
        WHERE NOT EXISTS (
            SELECT 1 FROM Rol_Privilegio
            WHERE id_rol = p_id_rol AND id_privilegio = priv_id AND nom_tabla_ojetivo = p->>'tabla'
        );
    END LOOP;
END;
$$;


ALTER FUNCTION public.update_role_privileges(p_id_rol integer, p_nombre_rol character varying, p_privilegios json) OWNER TO daniel_bd;

--
-- Name: usar_puntos_como_pago(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.usar_puntos_como_pago(p_id_cliente_natural integer, p_puntos_a_usar integer, p_id_compra integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
    v_id_metodo_punto INTEGER;
    v_valor_punto DECIMAL;
    v_monto_equivalente DECIMAL;
    v_id_tasa INTEGER;
BEGIN
    -- Validar que puede usar los puntos
    IF NOT validar_uso_puntos(p_id_cliente_natural, p_puntos_a_usar) THEN
        RAISE EXCEPTION 'No puede usar % puntos. Saldo insuficiente o no cumple m├¡nimo requerido.', p_puntos_a_usar;
    END IF;
    
    -- Obtener el valor actual del punto desde la fila espec├¡fica
    SELECT id_tasa, valor INTO v_id_tasa, v_valor_punto
    FROM Tasa 
    WHERE nombre = 'Punto' AND punto_id = 51
    LIMIT 1;
    
    -- Si no hay tasa configurada, usar valor por defecto (1 punto = $1)
    IF v_valor_punto IS NULL THEN
        v_valor_punto := 1.0;
    END IF;
    
    -- Calcular monto equivalente en dinero
    v_monto_equivalente := p_puntos_a_usar * v_valor_punto;
    
    -- Obtener el m├⌐todo de pago de tipo Punto del cliente
    SELECT p.id_metodo INTO v_id_metodo_punto
    FROM Punto p
    JOIN Metodo_Pago mp ON p.id_metodo = mp.id_metodo
    WHERE mp.id_cliente_natural = p_id_cliente_natural
    LIMIT 1;
    
    -- Si no existe m├⌐todo de pago de puntos, crear uno usando la funci├│n espec├¡fica
    IF v_id_metodo_punto IS NULL THEN
        -- Usar la funci├│n espec├¡fica para crear m├⌐todo de pago de puntos
        v_id_metodo_punto := crear_metodo_pago_puntos('Tienda Fisica', p_id_cliente_natural, NULL);
    END IF;
    
    -- Registrar el pago con puntos
    INSERT INTO Pago_Compra (
        metodo_id, 
        compra_id, 
        monto, 
        fecha_hora, 
        referencia, 
        tasa_id
    ) VALUES (
        v_id_metodo_punto,
        p_id_compra,
        v_monto_equivalente,
        CURRENT_TIMESTAMP,
        'Pago con ' || p_puntos_a_usar || ' puntos',
        v_id_tasa
    );
    
    -- Registrar el movimiento de puntos gastados
    INSERT INTO Punto_Cliente (
        id_cliente_natural, 
        id_metodo, 
        cantidad_mov, 
        fecha, 
        tipo_movimiento
    ) VALUES (
        p_id_cliente_natural,
        v_id_metodo_punto,
        -p_puntos_a_usar, -- Negativo porque es gasto
        CURRENT_DATE,
        'GASTADO'
    );
    
    RETURN p_puntos_a_usar;
END;
$_$;


ALTER FUNCTION public.usar_puntos_como_pago(p_id_cliente_natural integer, p_puntos_a_usar integer, p_id_compra integer) OWNER TO daniel_bd;

--
-- Name: validar_compra_pendiente(); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.validar_compra_pendiente() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_pendiente INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_pendiente
    FROM Compra_Estatus ce
    JOIN Estatus e ON ce.estatus_id_estatus = e.id_estatus
    WHERE ce.compra_id_compra = NEW.id_compra
      AND LOWER(e.nombre) = 'pendiente'
      AND ce.fecha_hora_fin = '9999-12-31 23:59:59';
    IF v_pendiente = 0 THEN
        RAISE EXCEPTION 'No se pueden agregar productos a una compra que no est├í pendiente';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validar_compra_pendiente() OWNER TO daniel_bd;

--
-- Name: validar_uso_puntos(integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.validar_uso_puntos(p_id_cliente_natural integer, p_puntos_a_usar integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_saldo_actual INTEGER;
BEGIN
    -- Obtener saldo actual
    SELECT obtener_saldo_puntos_cliente(p_id_cliente_natural) INTO v_saldo_actual;
    -- Validar solo que tenga suficientes puntos
    RETURN v_saldo_actual >= p_puntos_a_usar;
END;
$$;


ALTER FUNCTION public.validar_uso_puntos(p_id_cliente_natural integer, p_puntos_a_usar integer) OWNER TO daniel_bd;

--
-- Name: verificar_credenciales(character varying, character varying); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.verificar_credenciales(p_correo character varying, p_contrasena character varying) RETURNS TABLE(id_usuario integer, id_cliente_juridico integer, id_cliente_natural integer, fecha_creacion date, id_proveedor integer, empleado_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.id_usuario,
        u.id_cliente_juridico,
        u.id_cliente_natural,
        u.fecha_creacion,
        u.id_proveedor,
        u.empleado_id
    FROM
        Usuario u
    JOIN
        Correo c ON (
            (u.id_cliente_natural IS NOT NULL AND c.id_cliente_natural = u.id_cliente_natural)
            OR (u.id_cliente_juridico IS NOT NULL AND c.id_cliente_juridico = u.id_cliente_juridico)
            OR (u.id_proveedor IS NOT NULL AND c.id_proveedor_proveedor = u.id_proveedor)
            OR (u.empleado_id IS NOT NULL AND c.id_empleado = u.empleado_id)
        )
    WHERE
        c.nombre = SPLIT_PART(p_correo, '@', 1) AND c.extension_pag = SPLIT_PART(p_correo, '@', 2)
        AND u.contrase├▒a = p_contrasena;
END;
$$;


ALTER FUNCTION public.verificar_credenciales(p_correo character varying, p_contrasena character varying) OWNER TO daniel_bd;

--
-- Name: verificar_stock_carrito(integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.verificar_stock_carrito(p_id_usuario integer) RETURNS TABLE(id_inventario integer, nombre_cerveza character varying, nombre_presentacion character varying, cantidad_solicitada integer, stock_disponible integer, stock_suficiente boolean)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario, NULL, NULL);
    
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
$$;


ALTER FUNCTION public.verificar_stock_carrito(p_id_usuario integer) OWNER TO daniel_bd;

--
-- Name: FUNCTION verificar_stock_carrito(p_id_usuario integer); Type: COMMENT; Schema: public; Owner: daniel_bd
--

COMMENT ON FUNCTION public.verificar_stock_carrito(p_id_usuario integer) IS 'Funci├│n: Verifica el stock de los productos en el carrito.';


--
-- Name: verificar_stock_carrito(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: daniel_bd
--

CREATE FUNCTION public.verificar_stock_carrito(p_id_usuario integer, p_id_cliente_natural integer DEFAULT NULL::integer, p_id_cliente_juridico integer DEFAULT NULL::integer) RETURNS TABLE(id_inventario integer, nombre_cerveza character varying, nombre_presentacion character varying, cantidad_solicitada integer, stock_disponible integer, stock_suficiente boolean)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_carrito_por_tipo(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);
    
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
$$;


ALTER FUNCTION public.verificar_stock_carrito(p_id_usuario integer, p_id_cliente_natural integer, p_id_cliente_juridico integer) OWNER TO daniel_bd;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: actividad; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.actividad (
    id_actividad integer NOT NULL,
    tema character varying(50) NOT NULL,
    invitado_evento_invitado_id_invitado integer NOT NULL,
    invitado_evento_evento_id_evento integer NOT NULL,
    tipo_actividad_id_tipo_actividad integer NOT NULL
);


ALTER TABLE public.actividad OWNER TO daniel_bd;

--
-- Name: actividad_id_actividad_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.actividad_id_actividad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.actividad_id_actividad_seq OWNER TO daniel_bd;

--
-- Name: actividad_id_actividad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.actividad_id_actividad_seq OWNED BY public.actividad.id_actividad;


--
-- Name: asistencia; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.asistencia (
    id_asistencia integer NOT NULL,
    fecha_hora_entrada timestamp without time zone NOT NULL,
    fecha_hora_salida timestamp without time zone NOT NULL,
    empleado_id_empleado integer NOT NULL
);


ALTER TABLE public.asistencia OWNER TO daniel_bd;

--
-- Name: asistencia_id_asistencia_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.asistencia_id_asistencia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asistencia_id_asistencia_seq OWNER TO daniel_bd;

--
-- Name: asistencia_id_asistencia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.asistencia_id_asistencia_seq OWNED BY public.asistencia.id_asistencia;


--
-- Name: beneficio; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.beneficio (
    id_beneficio integer NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion text NOT NULL,
    monto numeric NOT NULL,
    activo character(1)
);


ALTER TABLE public.beneficio OWNER TO daniel_bd;

--
-- Name: beneficio_depto_empleado; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.beneficio_depto_empleado (
    pagado character(1),
    id_empleado integer NOT NULL,
    id_departamento integer NOT NULL,
    monto numeric NOT NULL,
    id_beneficio integer NOT NULL
);


ALTER TABLE public.beneficio_depto_empleado OWNER TO daniel_bd;

--
-- Name: beneficio_id_beneficio_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.beneficio_id_beneficio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.beneficio_id_beneficio_seq OWNER TO daniel_bd;

--
-- Name: beneficio_id_beneficio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.beneficio_id_beneficio_seq OWNED BY public.beneficio.id_beneficio;


--
-- Name: caracteristica; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.caracteristica (
    id_caracteristica integer NOT NULL,
    tipo_caracteristica character varying(50) NOT NULL,
    valor_caracteristica character varying(50) NOT NULL
);


ALTER TABLE public.caracteristica OWNER TO daniel_bd;

--
-- Name: caracteristica_especifica; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.caracteristica_especifica (
    id_tipo_cerveza integer NOT NULL,
    id_caracteristica integer NOT NULL,
    valor character varying(50) NOT NULL
);


ALTER TABLE public.caracteristica_especifica OWNER TO daniel_bd;

--
-- Name: caracteristica_id_caracteristica_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.caracteristica_id_caracteristica_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.caracteristica_id_caracteristica_seq OWNER TO daniel_bd;

--
-- Name: caracteristica_id_caracteristica_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.caracteristica_id_caracteristica_seq OWNED BY public.caracteristica.id_caracteristica;


--
-- Name: cargo; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.cargo (
    id_cargo integer NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion text NOT NULL
);


ALTER TABLE public.cargo OWNER TO daniel_bd;

--
-- Name: cargo_id_cargo_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.cargo_id_cargo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cargo_id_cargo_seq OWNER TO daniel_bd;

--
-- Name: cargo_id_cargo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.cargo_id_cargo_seq OWNED BY public.cargo.id_cargo;


--
-- Name: cerveza; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.cerveza (
    id_cerveza integer NOT NULL,
    nombre_cerveza character varying(50) NOT NULL,
    id_tipo_cerveza integer NOT NULL,
    id_proveedor integer NOT NULL
);


ALTER TABLE public.cerveza OWNER TO daniel_bd;

--
-- Name: cerveza_id_cerveza_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.cerveza_id_cerveza_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cerveza_id_cerveza_seq OWNER TO daniel_bd;

--
-- Name: cerveza_id_cerveza_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.cerveza_id_cerveza_seq OWNED BY public.cerveza.id_cerveza;


--
-- Name: cheque; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.cheque (
    id_metodo integer NOT NULL,
    num_cheque integer NOT NULL,
    num_cuenta integer NOT NULL,
    banco character varying(30)
);


ALTER TABLE public.cheque OWNER TO daniel_bd;

--
-- Name: cliente_juridico; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.cliente_juridico (
    id_cliente integer NOT NULL,
    rif_cliente integer NOT NULL,
    razon_social character varying(50) NOT NULL,
    denominacion_comercial character varying(50) NOT NULL,
    capital_disponible numeric NOT NULL,
    direccion_fiscal text NOT NULL,
    direccion_fisica text NOT NULL,
    pagina_web character varying(100) NOT NULL,
    lugar_id_lugar integer NOT NULL,
    lugar_id_lugar2 integer NOT NULL
);


ALTER TABLE public.cliente_juridico OWNER TO daniel_bd;

--
-- Name: cliente_juridico_id_cliente_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.cliente_juridico_id_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cliente_juridico_id_cliente_seq OWNER TO daniel_bd;

--
-- Name: cliente_juridico_id_cliente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.cliente_juridico_id_cliente_seq OWNED BY public.cliente_juridico.id_cliente;


--
-- Name: cliente_natural; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.cliente_natural (
    id_cliente integer NOT NULL,
    rif_cliente integer NOT NULL,
    ci_cliente integer NOT NULL,
    primer_nombre character varying(30) NOT NULL,
    segundo_nombre character varying(30),
    primer_apellido character varying(30) NOT NULL,
    segundo_apellido character varying(30),
    direccion text NOT NULL,
    lugar_id_lugar integer NOT NULL
);


ALTER TABLE public.cliente_natural OWNER TO daniel_bd;

--
-- Name: cliente_natural_id_cliente_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.cliente_natural_id_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cliente_natural_id_cliente_seq OWNER TO daniel_bd;

--
-- Name: cliente_natural_id_cliente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.cliente_natural_id_cliente_seq OWNED BY public.cliente_natural.id_cliente;


--
-- Name: compra; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.compra (
    id_compra integer NOT NULL,
    id_cliente_juridico integer,
    id_cliente_natural integer,
    monto_total numeric,
    usuario_id_usuario integer,
    tienda_web_id_tienda integer,
    tienda_fisica_id_tienda integer,
    CONSTRAINT arc_comprador CHECK ((((id_cliente_juridico IS NOT NULL) AND (usuario_id_usuario IS NULL) AND (id_cliente_natural IS NULL)) OR ((id_cliente_juridico IS NULL) AND (usuario_id_usuario IS NOT NULL) AND (id_cliente_natural IS NULL)) OR ((id_cliente_juridico IS NULL) AND (usuario_id_usuario IS NULL) AND (id_cliente_natural IS NOT NULL)))),
    CONSTRAINT arc_tienda CHECK ((((tienda_web_id_tienda IS NOT NULL) AND (tienda_fisica_id_tienda IS NULL)) OR ((tienda_fisica_id_tienda IS NOT NULL) AND (tienda_web_id_tienda IS NULL))))
);


ALTER TABLE public.compra OWNER TO daniel_bd;

--
-- Name: compra_estatus; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.compra_estatus (
    compra_id_compra integer NOT NULL,
    estatus_id_estatus integer NOT NULL,
    fecha_hora_asignacion timestamp without time zone NOT NULL,
    fecha_hora_fin timestamp without time zone
);


ALTER TABLE public.compra_estatus OWNER TO daniel_bd;

--
-- Name: compra_id_compra_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.compra_id_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.compra_id_compra_seq OWNER TO daniel_bd;

--
-- Name: compra_id_compra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.compra_id_compra_seq OWNED BY public.compra.id_compra;


--
-- Name: correo; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.correo (
    id_correo integer NOT NULL,
    nombre character varying(50) NOT NULL,
    extension_pag character varying(20) NOT NULL,
    id_proveedor_proveedor integer,
    id_cliente_natural integer,
    id_cliente_juridico integer,
    id_empleado integer,
    CONSTRAINT arc_propietario CHECK ((((id_cliente_juridico IS NOT NULL) AND (id_cliente_natural IS NULL) AND (id_proveedor_proveedor IS NULL) AND (id_empleado IS NULL)) OR ((id_cliente_juridico IS NULL) AND (id_cliente_natural IS NOT NULL) AND (id_proveedor_proveedor IS NULL) AND (id_empleado IS NULL)) OR ((id_cliente_juridico IS NULL) AND (id_cliente_natural IS NULL) AND (id_proveedor_proveedor IS NOT NULL) AND (id_empleado IS NULL)) OR ((id_empleado IS NOT NULL) AND (id_cliente_juridico IS NULL) AND (id_cliente_natural IS NULL) AND (id_proveedor_proveedor IS NULL))))
);


ALTER TABLE public.correo OWNER TO daniel_bd;

--
-- Name: correo_id_correo_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.correo_id_correo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.correo_id_correo_seq OWNER TO daniel_bd;

--
-- Name: correo_id_correo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.correo_id_correo_seq OWNED BY public.correo.id_correo;


--
-- Name: cuota_afiliacion; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.cuota_afiliacion (
    id_cuota integer NOT NULL,
    monto numeric(10,2) NOT NULL,
    membresia_id_membresia integer NOT NULL,
    fecha_pago date NOT NULL
);


ALTER TABLE public.cuota_afiliacion OWNER TO daniel_bd;

--
-- Name: cuota_afiliacion_id_cuota_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.cuota_afiliacion_id_cuota_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cuota_afiliacion_id_cuota_seq OWNER TO daniel_bd;

--
-- Name: cuota_afiliacion_id_cuota_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.cuota_afiliacion_id_cuota_seq OWNED BY public.cuota_afiliacion.id_cuota;


--
-- Name: departamento; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.departamento (
    id_departamento integer NOT NULL,
    nombre character varying(50) NOT NULL,
    fecha_creacion date NOT NULL,
    descripcion text NOT NULL,
    activo character(1)
);


ALTER TABLE public.departamento OWNER TO daniel_bd;

--
-- Name: departamento_empleado; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.departamento_empleado (
    fecha_inicio date NOT NULL,
    fecha_final date,
    salario numeric NOT NULL,
    id_empleado integer NOT NULL,
    id_departamento integer NOT NULL,
    id_cargo integer NOT NULL
);


ALTER TABLE public.departamento_empleado OWNER TO daniel_bd;

--
-- Name: departamento_id_departamento_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.departamento_id_departamento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departamento_id_departamento_seq OWNER TO daniel_bd;

--
-- Name: departamento_id_departamento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.departamento_id_departamento_seq OWNED BY public.departamento.id_departamento;


--
-- Name: descuento; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.descuento (
    porcentaje numeric NOT NULL,
    id_promocion integer NOT NULL,
    id_tipo_cerveza integer NOT NULL,
    id_presentacion integer NOT NULL,
    id_cerveza integer NOT NULL
);


ALTER TABLE public.descuento OWNER TO daniel_bd;

--
-- Name: detalle_compra; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.detalle_compra (
    precio_unitario numeric NOT NULL,
    cantidad integer NOT NULL,
    id_inventario integer NOT NULL,
    id_compra integer NOT NULL,
    id_empleado integer
);


ALTER TABLE public.detalle_compra OWNER TO daniel_bd;

--
-- Name: detalle_orden_reposicion; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.detalle_orden_reposicion (
    cantidad integer NOT NULL,
    id_orden_reposicion integer NOT NULL,
    id_proveedor integer NOT NULL,
    id_departamento integer NOT NULL,
    precio numeric NOT NULL,
    id_presentacion integer NOT NULL,
    id_cerveza integer NOT NULL
);


ALTER TABLE public.detalle_orden_reposicion OWNER TO daniel_bd;

--
-- Name: detalle_orden_reposicion_anaquel; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.detalle_orden_reposicion_anaquel (
    id_orden_reposicion integer NOT NULL,
    id_inventario integer NOT NULL,
    cantidad integer NOT NULL
);


ALTER TABLE public.detalle_orden_reposicion_anaquel OWNER TO daniel_bd;

--
-- Name: detalle_venta_evento; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.detalle_venta_evento (
    precio_unitario numeric NOT NULL,
    cantidad integer NOT NULL,
    id_evento integer NOT NULL,
    id_cliente_natural integer NOT NULL,
    id_cerveza integer NOT NULL,
    id_proveedor integer NOT NULL,
    id_proveedor_evento integer NOT NULL,
    id_tipo_cerveza integer NOT NULL,
    id_presentacion integer NOT NULL,
    id_cerveza_inv integer NOT NULL
);


ALTER TABLE public.detalle_venta_evento OWNER TO daniel_bd;

--
-- Name: efectivo; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.efectivo (
    id_metodo integer NOT NULL,
    denominacion integer NOT NULL
);


ALTER TABLE public.efectivo OWNER TO daniel_bd;

--
-- Name: empleado; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.empleado (
    id_empleado integer NOT NULL,
    cedula character varying(20) NOT NULL,
    primer_nombre character varying(30) NOT NULL,
    segundo_nombre character varying(30),
    primer_apellido character varying(30) NOT NULL,
    segundo_apellido character varying(30),
    direccion text NOT NULL,
    activo character(1),
    lugar_id_lugar integer NOT NULL
);


ALTER TABLE public.empleado OWNER TO daniel_bd;

--
-- Name: empleado_id_empleado_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.empleado_id_empleado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.empleado_id_empleado_seq OWNER TO daniel_bd;

--
-- Name: empleado_id_empleado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.empleado_id_empleado_seq OWNED BY public.empleado.id_empleado;


--
-- Name: estatus; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.estatus (
    id_estatus integer NOT NULL,
    nombre character varying(20) NOT NULL
);


ALTER TABLE public.estatus OWNER TO daniel_bd;

--
-- Name: estatus_id_estatus_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.estatus_id_estatus_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.estatus_id_estatus_seq OWNER TO daniel_bd;

--
-- Name: estatus_id_estatus_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.estatus_id_estatus_seq OWNED BY public.estatus.id_estatus;


--
-- Name: estatus_orden_anaquel; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.estatus_orden_anaquel (
    id_orden_reposicion integer NOT NULL,
    id_estatus integer NOT NULL,
    fecha_hora_asignacion timestamp without time zone NOT NULL
);


ALTER TABLE public.estatus_orden_anaquel OWNER TO daniel_bd;

--
-- Name: evento; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.evento (
    id_evento integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text NOT NULL,
    fecha_inicio timestamp without time zone NOT NULL,
    fecha_fin timestamp without time zone NOT NULL,
    lugar_id_lugar integer NOT NULL,
    n_entradas_vendidas integer,
    precio_unitario_entrada numeric NOT NULL,
    tipo_evento_id integer NOT NULL
);


ALTER TABLE public.evento OWNER TO daniel_bd;

--
-- Name: evento_id_evento_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.evento_id_evento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.evento_id_evento_seq OWNER TO daniel_bd;

--
-- Name: evento_id_evento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.evento_id_evento_seq OWNED BY public.evento.id_evento;


--
-- Name: evento_proveedor; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.evento_proveedor (
    id_proveedor integer NOT NULL,
    id_evento integer NOT NULL,
    hora_llegada time without time zone,
    hora_salida time without time zone,
    dia date NOT NULL
);


ALTER TABLE public.evento_proveedor OWNER TO daniel_bd;

--
-- Name: fermentacion; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.fermentacion (
    id_fermentacion integer NOT NULL,
    receta_id_receta integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin_estimada date NOT NULL
);


ALTER TABLE public.fermentacion OWNER TO daniel_bd;

--
-- Name: fermentacion_id_fermentacion_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.fermentacion_id_fermentacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fermentacion_id_fermentacion_seq OWNER TO daniel_bd;

--
-- Name: fermentacion_id_fermentacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.fermentacion_id_fermentacion_seq OWNED BY public.fermentacion.id_fermentacion;


--
-- Name: horario; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.horario (
    id_horario integer NOT NULL,
    dia character varying(15) NOT NULL,
    hora_entrada time without time zone NOT NULL,
    hora_salida time without time zone NOT NULL
);


ALTER TABLE public.horario OWNER TO daniel_bd;

--
-- Name: horario_empleado; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.horario_empleado (
    id_empleado integer NOT NULL,
    id_horario integer NOT NULL
);


ALTER TABLE public.horario_empleado OWNER TO daniel_bd;

--
-- Name: horario_evento; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.horario_evento (
    id_evento integer NOT NULL,
    id_horario integer NOT NULL
);


ALTER TABLE public.horario_evento OWNER TO daniel_bd;

--
-- Name: horario_id_horario_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.horario_id_horario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.horario_id_horario_seq OWNER TO daniel_bd;

--
-- Name: horario_id_horario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.horario_id_horario_seq OWNED BY public.horario.id_horario;


--
-- Name: ingrediente; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.ingrediente (
    id_ingrediente integer NOT NULL,
    tipo character varying(20) NOT NULL,
    valor numeric NOT NULL,
    ingrediente_padre integer,
    nombre character varying(50) NOT NULL
);


ALTER TABLE public.ingrediente OWNER TO daniel_bd;

--
-- Name: ingrediente_id_ingrediente_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.ingrediente_id_ingrediente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ingrediente_id_ingrediente_seq OWNER TO daniel_bd;

--
-- Name: ingrediente_id_ingrediente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.ingrediente_id_ingrediente_seq OWNED BY public.ingrediente.id_ingrediente;


--
-- Name: instruccion; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.instruccion (
    id_instruccion integer NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion text NOT NULL,
    receta_id integer NOT NULL
);


ALTER TABLE public.instruccion OWNER TO daniel_bd;

--
-- Name: instruccion_id_instruccion_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.instruccion_id_instruccion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.instruccion_id_instruccion_seq OWNER TO daniel_bd;

--
-- Name: instruccion_id_instruccion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.instruccion_id_instruccion_seq OWNED BY public.instruccion.id_instruccion;


--
-- Name: inventario; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.inventario (
    id_inventario integer NOT NULL,
    cantidad integer NOT NULL,
    id_tienda_web integer,
    id_tienda_fisica integer,
    id_ubicacion integer,
    id_presentacion integer NOT NULL,
    id_cerveza integer NOT NULL,
    CONSTRAINT arc_ubicacion CHECK ((((id_tienda_web IS NOT NULL) AND (id_tienda_fisica IS NULL) AND (id_ubicacion IS NULL)) OR ((id_tienda_web IS NULL) AND (id_tienda_fisica IS NOT NULL) AND (id_ubicacion IS NULL)) OR ((id_tienda_web IS NULL) AND (id_tienda_fisica IS NULL) AND (id_ubicacion IS NOT NULL))))
);


ALTER TABLE public.inventario OWNER TO daniel_bd;

--
-- Name: inventario_evento_proveedor; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.inventario_evento_proveedor (
    id_proveedor integer NOT NULL,
    id_evento integer NOT NULL,
    cantidad integer NOT NULL,
    id_tipo_cerveza integer NOT NULL,
    id_presentacion integer NOT NULL,
    id_cerveza integer NOT NULL
);


ALTER TABLE public.inventario_evento_proveedor OWNER TO daniel_bd;

--
-- Name: inventario_id_inventario_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.inventario_id_inventario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventario_id_inventario_seq OWNER TO daniel_bd;

--
-- Name: inventario_id_inventario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.inventario_id_inventario_seq OWNED BY public.inventario.id_inventario;


--
-- Name: invitado; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.invitado (
    id_invitado integer NOT NULL,
    nombre character varying(100) NOT NULL,
    lugar_id integer NOT NULL,
    tipo_invitado_id integer NOT NULL,
    rif integer NOT NULL,
    direccion text NOT NULL
);


ALTER TABLE public.invitado OWNER TO daniel_bd;

--
-- Name: invitado_evento; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.invitado_evento (
    id_invitado integer NOT NULL,
    id_evento integer NOT NULL,
    hora_llegada time without time zone,
    hora_salida time without time zone
);


ALTER TABLE public.invitado_evento OWNER TO daniel_bd;

--
-- Name: invitado_id_invitado_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.invitado_id_invitado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invitado_id_invitado_seq OWNER TO daniel_bd;

--
-- Name: invitado_id_invitado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.invitado_id_invitado_seq OWNED BY public.invitado.id_invitado;


--
-- Name: lugar; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.lugar (
    id_lugar integer NOT NULL,
    nombre character varying(100) NOT NULL,
    tipo character varying(50) NOT NULL,
    lugar_relacion_id integer
);


ALTER TABLE public.lugar OWNER TO daniel_bd;

--
-- Name: lugar_id_lugar_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.lugar_id_lugar_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lugar_id_lugar_seq OWNER TO daniel_bd;

--
-- Name: lugar_id_lugar_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.lugar_id_lugar_seq OWNED BY public.lugar.id_lugar;


--
-- Name: membresia; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.membresia (
    id_membresia integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date,
    id_proveedor integer NOT NULL
);


ALTER TABLE public.membresia OWNER TO daniel_bd;

--
-- Name: membresia_id_membresia_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.membresia_id_membresia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.membresia_id_membresia_seq OWNER TO daniel_bd;

--
-- Name: membresia_id_membresia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.membresia_id_membresia_seq OWNED BY public.membresia.id_membresia;


--
-- Name: metodo_pago; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.metodo_pago (
    id_metodo integer NOT NULL,
    id_cliente_natural integer,
    id_cliente_juridico integer
);


ALTER TABLE public.metodo_pago OWNER TO daniel_bd;

--
-- Name: metodo_pago_id_metodo_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.metodo_pago_id_metodo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.metodo_pago_id_metodo_seq OWNER TO daniel_bd;

--
-- Name: metodo_pago_id_metodo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.metodo_pago_id_metodo_seq OWNED BY public.metodo_pago.id_metodo;


--
-- Name: orden_reposicion; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.orden_reposicion (
    id_orden_reposicion integer NOT NULL,
    id_departamento integer NOT NULL,
    id_proveedor integer NOT NULL,
    fecha_emision date NOT NULL,
    id_empleado integer,
    fecha_fin date
);


ALTER TABLE public.orden_reposicion OWNER TO daniel_bd;

--
-- Name: orden_reposicion_anaquel; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.orden_reposicion_anaquel (
    id_orden_reposicion integer NOT NULL,
    id_ubicacion integer NOT NULL,
    fecha_hora_generacion timestamp without time zone NOT NULL
);


ALTER TABLE public.orden_reposicion_anaquel OWNER TO daniel_bd;

--
-- Name: orden_reposicion_anaquel_id_orden_reposicion_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.orden_reposicion_anaquel_id_orden_reposicion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orden_reposicion_anaquel_id_orden_reposicion_seq OWNER TO daniel_bd;

--
-- Name: orden_reposicion_anaquel_id_orden_reposicion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.orden_reposicion_anaquel_id_orden_reposicion_seq OWNED BY public.orden_reposicion_anaquel.id_orden_reposicion;


--
-- Name: orden_reposicion_estatus; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.orden_reposicion_estatus (
    id_orden_reposicion integer NOT NULL,
    id_proveedor integer NOT NULL,
    id_departamento integer NOT NULL,
    id_estatus integer NOT NULL,
    fecha_asignacion timestamp without time zone NOT NULL,
    fecha_fin timestamp without time zone
);


ALTER TABLE public.orden_reposicion_estatus OWNER TO daniel_bd;

--
-- Name: orden_reposicion_id_orden_reposicion_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.orden_reposicion_id_orden_reposicion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orden_reposicion_id_orden_reposicion_seq OWNER TO daniel_bd;

--
-- Name: orden_reposicion_id_orden_reposicion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.orden_reposicion_id_orden_reposicion_seq OWNED BY public.orden_reposicion.id_orden_reposicion;


--
-- Name: pago_compra; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.pago_compra (
    id_pago integer NOT NULL,
    metodo_id integer NOT NULL,
    compra_id integer NOT NULL,
    monto numeric NOT NULL,
    fecha_hora timestamp without time zone NOT NULL,
    referencia character varying(50) NOT NULL,
    tasa_id integer
);


ALTER TABLE public.pago_compra OWNER TO daniel_bd;

--
-- Name: pago_compra_id_pago_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.pago_compra_id_pago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pago_compra_id_pago_seq OWNER TO daniel_bd;

--
-- Name: pago_compra_id_pago_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.pago_compra_id_pago_seq OWNED BY public.pago_compra.id_pago;


--
-- Name: pago_cuota_afiliacion; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.pago_cuota_afiliacion (
    metodo_id integer NOT NULL,
    cuota_id integer NOT NULL,
    monto numeric NOT NULL,
    fecha_pago date NOT NULL,
    tasa_id integer
);


ALTER TABLE public.pago_cuota_afiliacion OWNER TO daniel_bd;

--
-- Name: pago_evento; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.pago_evento (
    metodo_id integer NOT NULL,
    evento_id integer NOT NULL,
    id_cliente_natural integer NOT NULL,
    fecha_hora timestamp without time zone NOT NULL,
    monto numeric NOT NULL,
    tasa_id integer,
    referencia character varying(50) NOT NULL
);


ALTER TABLE public.pago_evento OWNER TO daniel_bd;

--
-- Name: pago_orden_reposicion; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.pago_orden_reposicion (
    id_pago integer NOT NULL,
    id_proveedor integer NOT NULL,
    id_departamento integer NOT NULL,
    id_orden_reposicion integer NOT NULL,
    fecha_ejecucion timestamp without time zone NOT NULL,
    monto numeric NOT NULL
);


ALTER TABLE public.pago_orden_reposicion OWNER TO daniel_bd;

--
-- Name: pago_orden_reposicion_id_pago_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.pago_orden_reposicion_id_pago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pago_orden_reposicion_id_pago_seq OWNER TO daniel_bd;

--
-- Name: pago_orden_reposicion_id_pago_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.pago_orden_reposicion_id_pago_seq OWNED BY public.pago_orden_reposicion.id_pago;


--
-- Name: persona_contacto; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.persona_contacto (
    id_contacto integer NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50) NOT NULL,
    id_proveedor integer,
    id_cliente_juridico integer,
    CONSTRAINT arc_propietario_contacto CHECK ((((id_cliente_juridico IS NOT NULL) AND (id_proveedor IS NULL)) OR ((id_proveedor IS NOT NULL) AND (id_cliente_juridico IS NULL))))
);


ALTER TABLE public.persona_contacto OWNER TO daniel_bd;

--
-- Name: persona_contacto_id_contacto_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.persona_contacto_id_contacto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.persona_contacto_id_contacto_seq OWNER TO daniel_bd;

--
-- Name: persona_contacto_id_contacto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.persona_contacto_id_contacto_seq OWNED BY public.persona_contacto.id_contacto;


--
-- Name: presentacion; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.presentacion (
    id_presentacion integer NOT NULL,
    nombre character varying(40) NOT NULL
);


ALTER TABLE public.presentacion OWNER TO daniel_bd;

--
-- Name: presentacion_cerveza; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.presentacion_cerveza (
    id_presentacion integer NOT NULL,
    id_cerveza integer NOT NULL,
    cantidad integer NOT NULL,
    descripcion text,
    precio numeric NOT NULL
);


ALTER TABLE public.presentacion_cerveza OWNER TO daniel_bd;

--
-- Name: presentacion_id_presentacion_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.presentacion_id_presentacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.presentacion_id_presentacion_seq OWNER TO daniel_bd;

--
-- Name: presentacion_id_presentacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.presentacion_id_presentacion_seq OWNED BY public.presentacion.id_presentacion;


--
-- Name: privilegio; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.privilegio (
    id_privilegio integer NOT NULL,
    nombre character varying(50) NOT NULL
);


ALTER TABLE public.privilegio OWNER TO daniel_bd;

--
-- Name: privilegio_id_privilegio_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.privilegio_id_privilegio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.privilegio_id_privilegio_seq OWNER TO daniel_bd;

--
-- Name: privilegio_id_privilegio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.privilegio_id_privilegio_seq OWNED BY public.privilegio.id_privilegio;


--
-- Name: promocion; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.promocion (
    id_promocion integer NOT NULL,
    descripcion text NOT NULL,
    id_departamento integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    id_usuario integer
);


ALTER TABLE public.promocion OWNER TO daniel_bd;

--
-- Name: promocion_id_promocion_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.promocion_id_promocion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promocion_id_promocion_seq OWNER TO daniel_bd;

--
-- Name: promocion_id_promocion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.promocion_id_promocion_seq OWNED BY public.promocion.id_promocion;


--
-- Name: proveedor; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.proveedor (
    id_proveedor integer NOT NULL,
    razon_social character varying(100) NOT NULL,
    denominacion character varying(100) NOT NULL,
    rif integer NOT NULL,
    direccion_fiscal text NOT NULL,
    direccion_fisica text NOT NULL,
    id_lugar integer NOT NULL,
    lugar_id2 integer NOT NULL,
    url_web character varying(200) NOT NULL
);


ALTER TABLE public.proveedor OWNER TO daniel_bd;

--
-- Name: proveedor_id_proveedor_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.proveedor_id_proveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proveedor_id_proveedor_seq OWNER TO daniel_bd;

--
-- Name: proveedor_id_proveedor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.proveedor_id_proveedor_seq OWNED BY public.proveedor.id_proveedor;


--
-- Name: punto; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.punto (
    id_metodo integer NOT NULL,
    origen character varying(20) NOT NULL
);


ALTER TABLE public.punto OWNER TO daniel_bd;

--
-- Name: punto_cliente; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.punto_cliente (
    id_punto_cliente integer NOT NULL,
    id_cliente_natural integer NOT NULL,
    id_metodo integer NOT NULL,
    cantidad_mov integer NOT NULL,
    fecha date NOT NULL,
    tipo_movimiento character varying(20) NOT NULL
);


ALTER TABLE public.punto_cliente OWNER TO daniel_bd;

--
-- Name: punto_cliente_id_punto_cliente_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.punto_cliente_id_punto_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.punto_cliente_id_punto_cliente_seq OWNER TO daniel_bd;

--
-- Name: punto_cliente_id_punto_cliente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.punto_cliente_id_punto_cliente_seq OWNED BY public.punto_cliente.id_punto_cliente;


--
-- Name: receta; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.receta (
    id_receta integer NOT NULL,
    id_tipo_cerveza integer NOT NULL,
    descripcion text
);


ALTER TABLE public.receta OWNER TO daniel_bd;

--
-- Name: receta_id_receta_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.receta_id_receta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.receta_id_receta_seq OWNER TO daniel_bd;

--
-- Name: receta_id_receta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.receta_id_receta_seq OWNED BY public.receta.id_receta;


--
-- Name: receta_ingrediente; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.receta_ingrediente (
    id_receta integer NOT NULL,
    id_ingrediente integer NOT NULL
);


ALTER TABLE public.receta_ingrediente OWNER TO daniel_bd;

--
-- Name: rol; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.rol (
    id_rol integer NOT NULL,
    nombre character varying(50) NOT NULL
);


ALTER TABLE public.rol OWNER TO daniel_bd;

--
-- Name: rol_id_rol_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.rol_id_rol_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rol_id_rol_seq OWNER TO daniel_bd;

--
-- Name: rol_id_rol_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.rol_id_rol_seq OWNED BY public.rol.id_rol;


--
-- Name: rol_privilegio; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.rol_privilegio (
    id_rol integer NOT NULL,
    id_privilegio integer NOT NULL,
    fecha_asignacion date DEFAULT CURRENT_DATE NOT NULL,
    nom_tabla_ojetivo character varying(25) NOT NULL,
    motivo text
);


ALTER TABLE public.rol_privilegio OWNER TO daniel_bd;

--
-- Name: tarjeta_credito; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.tarjeta_credito (
    id_metodo integer NOT NULL,
    tipo character varying(20) NOT NULL,
    numero character varying(20) NOT NULL,
    banco character varying(30) NOT NULL,
    fecha_vencimiento date NOT NULL
);


ALTER TABLE public.tarjeta_credito OWNER TO daniel_bd;

--
-- Name: tarjeta_debito; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.tarjeta_debito (
    id_metodo integer NOT NULL,
    numero character varying(20) NOT NULL,
    banco character varying(30) NOT NULL
);


ALTER TABLE public.tarjeta_debito OWNER TO daniel_bd;

--
-- Name: tasa; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.tasa (
    id_tasa integer NOT NULL,
    nombre character varying(50) NOT NULL,
    valor numeric NOT NULL,
    fecha date NOT NULL,
    punto_id integer,
    id_metodo integer
);


ALTER TABLE public.tasa OWNER TO daniel_bd;

--
-- Name: tasa_id_tasa_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.tasa_id_tasa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasa_id_tasa_seq OWNER TO daniel_bd;

--
-- Name: tasa_id_tasa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.tasa_id_tasa_seq OWNED BY public.tasa.id_tasa;


--
-- Name: telefono; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.telefono (
    id_telefono integer NOT NULL,
    codigo_area character varying(5) NOT NULL,
    numero character varying(15) NOT NULL,
    id_proveedor integer,
    id_contacto integer,
    id_invitado integer,
    id_cliente_juridico integer,
    id_cliente_natural integer,
    CONSTRAINT arc_propietario_telefono CHECK ((((id_invitado IS NOT NULL) AND (id_proveedor IS NULL) AND (id_contacto IS NULL) AND (id_cliente_natural IS NULL) AND (id_cliente_juridico IS NULL)) OR ((id_proveedor IS NOT NULL) AND (id_invitado IS NULL) AND (id_contacto IS NULL) AND (id_cliente_natural IS NULL) AND (id_cliente_juridico IS NULL)) OR ((id_contacto IS NOT NULL) AND (id_invitado IS NULL) AND (id_proveedor IS NULL) AND (id_cliente_natural IS NULL) AND (id_cliente_juridico IS NULL)) OR ((id_cliente_juridico IS NOT NULL) AND (id_cliente_natural IS NULL) AND (id_invitado IS NULL) AND (id_proveedor IS NULL) AND (id_contacto IS NULL)) OR ((id_cliente_natural IS NOT NULL) AND (id_cliente_juridico IS NULL) AND (id_invitado IS NULL) AND (id_proveedor IS NULL) AND (id_contacto IS NULL))))
);


ALTER TABLE public.telefono OWNER TO daniel_bd;

--
-- Name: telefono_id_telefono_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.telefono_id_telefono_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.telefono_id_telefono_seq OWNER TO daniel_bd;

--
-- Name: telefono_id_telefono_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.telefono_id_telefono_seq OWNED BY public.telefono.id_telefono;


--
-- Name: tienda_fisica; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.tienda_fisica (
    id_tienda_fisica integer NOT NULL,
    id_lugar integer NOT NULL,
    nombre character varying(50) NOT NULL,
    direccion text NOT NULL
);


ALTER TABLE public.tienda_fisica OWNER TO daniel_bd;

--
-- Name: tienda_fisica_id_tienda_fisica_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.tienda_fisica_id_tienda_fisica_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tienda_fisica_id_tienda_fisica_seq OWNER TO daniel_bd;

--
-- Name: tienda_fisica_id_tienda_fisica_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.tienda_fisica_id_tienda_fisica_seq OWNED BY public.tienda_fisica.id_tienda_fisica;


--
-- Name: tienda_web; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.tienda_web (
    id_tienda_web integer NOT NULL,
    nombre character varying(50) NOT NULL,
    url character varying(200) NOT NULL
);


ALTER TABLE public.tienda_web OWNER TO daniel_bd;

--
-- Name: tienda_web_id_tienda_web_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.tienda_web_id_tienda_web_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tienda_web_id_tienda_web_seq OWNER TO daniel_bd;

--
-- Name: tienda_web_id_tienda_web_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.tienda_web_id_tienda_web_seq OWNED BY public.tienda_web.id_tienda_web;


--
-- Name: tipo_actividad; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.tipo_actividad (
    id_tipo_actividad integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE public.tipo_actividad OWNER TO daniel_bd;

--
-- Name: tipo_actividad_id_tipo_actividad_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.tipo_actividad_id_tipo_actividad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_actividad_id_tipo_actividad_seq OWNER TO daniel_bd;

--
-- Name: tipo_actividad_id_tipo_actividad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.tipo_actividad_id_tipo_actividad_seq OWNED BY public.tipo_actividad.id_tipo_actividad;


--
-- Name: tipo_cerveza; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.tipo_cerveza (
    id_tipo_cerveza integer NOT NULL,
    nombre character varying(50) NOT NULL,
    tipo_padre_id integer
);


ALTER TABLE public.tipo_cerveza OWNER TO daniel_bd;

--
-- Name: tipo_cerveza_id_tipo_cerveza_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.tipo_cerveza_id_tipo_cerveza_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_cerveza_id_tipo_cerveza_seq OWNER TO daniel_bd;

--
-- Name: tipo_cerveza_id_tipo_cerveza_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.tipo_cerveza_id_tipo_cerveza_seq OWNED BY public.tipo_cerveza.id_tipo_cerveza;


--
-- Name: tipo_invitado; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.tipo_invitado (
    id_tipo_invitado integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE public.tipo_invitado OWNER TO daniel_bd;

--
-- Name: tipo_invitado_id_tipo_invitado_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.tipo_invitado_id_tipo_invitado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_invitado_id_tipo_invitado_seq OWNER TO daniel_bd;

--
-- Name: tipo_invitado_id_tipo_invitado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.tipo_invitado_id_tipo_invitado_seq OWNED BY public.tipo_invitado.id_tipo_invitado;


--
-- Name: tipoevento; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.tipoevento (
    id_tipo_evento integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text NOT NULL
);


ALTER TABLE public.tipoevento OWNER TO daniel_bd;

--
-- Name: tipoevento_id_tipo_evento_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.tipoevento_id_tipo_evento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipoevento_id_tipo_evento_seq OWNER TO daniel_bd;

--
-- Name: tipoevento_id_tipo_evento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.tipoevento_id_tipo_evento_seq OWNED BY public.tipoevento.id_tipo_evento;


--
-- Name: ubicacion_tienda; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.ubicacion_tienda (
    id_ubicacion integer NOT NULL,
    tipo character varying(20) NOT NULL,
    nombre character varying(50) NOT NULL,
    ubicacion_tienda_relacion_id integer,
    id_tienda_web integer NOT NULL,
    id_tienda_fisica integer NOT NULL
);


ALTER TABLE public.ubicacion_tienda OWNER TO daniel_bd;

--
-- Name: ubicacion_tienda_id_ubicacion_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.ubicacion_tienda_id_ubicacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ubicacion_tienda_id_ubicacion_seq OWNER TO daniel_bd;

--
-- Name: ubicacion_tienda_id_ubicacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.ubicacion_tienda_id_ubicacion_seq OWNED BY public.ubicacion_tienda.id_ubicacion;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.usuario (
    id_usuario integer NOT NULL,
    id_cliente_juridico integer,
    id_cliente_natural integer,
    id_rol integer,
    fecha_creacion date NOT NULL,
    id_proveedor integer,
    empleado_id integer,
    "contrase├▒a" character varying(255) NOT NULL,
    CONSTRAINT arc_tipo_usuario CHECK ((((id_cliente_natural IS NOT NULL) AND (id_cliente_juridico IS NULL) AND (empleado_id IS NULL) AND (id_proveedor IS NULL)) OR ((id_cliente_natural IS NULL) AND (id_cliente_juridico IS NOT NULL) AND (empleado_id IS NULL) AND (id_proveedor IS NULL)) OR ((id_cliente_natural IS NULL) AND (id_cliente_juridico IS NULL) AND (empleado_id IS NOT NULL) AND (id_proveedor IS NULL)) OR ((id_cliente_natural IS NULL) AND (id_cliente_juridico IS NULL) AND (empleado_id IS NULL) AND (id_proveedor IS NOT NULL)))),
    CONSTRAINT rol_para_empleado CHECK ((((empleado_id IS NOT NULL) AND (id_rol IS NOT NULL)) OR ((empleado_id IS NULL) AND (id_rol IS NULL))))
);


ALTER TABLE public.usuario OWNER TO daniel_bd;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_id_usuario_seq OWNER TO daniel_bd;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.usuario_id_usuario_seq OWNED BY public.usuario.id_usuario;


--
-- Name: vacacion; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.vacacion (
    id_vacacion integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    descripcion text NOT NULL,
    empleado_id integer NOT NULL
);


ALTER TABLE public.vacacion OWNER TO daniel_bd;

--
-- Name: vacacion_id_vacacion_seq; Type: SEQUENCE; Schema: public; Owner: daniel_bd
--

CREATE SEQUENCE public.vacacion_id_vacacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vacacion_id_vacacion_seq OWNER TO daniel_bd;

--
-- Name: vacacion_id_vacacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: daniel_bd
--

ALTER SEQUENCE public.vacacion_id_vacacion_seq OWNED BY public.vacacion.id_vacacion;


--
-- Name: venta_evento; Type: TABLE; Schema: public; Owner: daniel_bd
--

CREATE TABLE public.venta_evento (
    evento_id integer NOT NULL,
    id_cliente_natural integer NOT NULL,
    fecha_compra timestamp without time zone NOT NULL,
    total numeric(12,2) NOT NULL
);


ALTER TABLE public.venta_evento OWNER TO daniel_bd;

--
-- Name: actividad id_actividad; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.actividad ALTER COLUMN id_actividad SET DEFAULT nextval('public.actividad_id_actividad_seq'::regclass);


--
-- Name: asistencia id_asistencia; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.asistencia ALTER COLUMN id_asistencia SET DEFAULT nextval('public.asistencia_id_asistencia_seq'::regclass);


--
-- Name: beneficio id_beneficio; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.beneficio ALTER COLUMN id_beneficio SET DEFAULT nextval('public.beneficio_id_beneficio_seq'::regclass);


--
-- Name: caracteristica id_caracteristica; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.caracteristica ALTER COLUMN id_caracteristica SET DEFAULT nextval('public.caracteristica_id_caracteristica_seq'::regclass);


--
-- Name: cargo id_cargo; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cargo ALTER COLUMN id_cargo SET DEFAULT nextval('public.cargo_id_cargo_seq'::regclass);


--
-- Name: cerveza id_cerveza; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cerveza ALTER COLUMN id_cerveza SET DEFAULT nextval('public.cerveza_id_cerveza_seq'::regclass);


--
-- Name: cliente_juridico id_cliente; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cliente_juridico ALTER COLUMN id_cliente SET DEFAULT nextval('public.cliente_juridico_id_cliente_seq'::regclass);


--
-- Name: cliente_natural id_cliente; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cliente_natural ALTER COLUMN id_cliente SET DEFAULT nextval('public.cliente_natural_id_cliente_seq'::regclass);


--
-- Name: compra id_compra; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.compra ALTER COLUMN id_compra SET DEFAULT nextval('public.compra_id_compra_seq'::regclass);


--
-- Name: correo id_correo; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.correo ALTER COLUMN id_correo SET DEFAULT nextval('public.correo_id_correo_seq'::regclass);


--
-- Name: cuota_afiliacion id_cuota; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cuota_afiliacion ALTER COLUMN id_cuota SET DEFAULT nextval('public.cuota_afiliacion_id_cuota_seq'::regclass);


--
-- Name: departamento id_departamento; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.departamento ALTER COLUMN id_departamento SET DEFAULT nextval('public.departamento_id_departamento_seq'::regclass);


--
-- Name: empleado id_empleado; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.empleado ALTER COLUMN id_empleado SET DEFAULT nextval('public.empleado_id_empleado_seq'::regclass);


--
-- Name: estatus id_estatus; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.estatus ALTER COLUMN id_estatus SET DEFAULT nextval('public.estatus_id_estatus_seq'::regclass);


--
-- Name: evento id_evento; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.evento ALTER COLUMN id_evento SET DEFAULT nextval('public.evento_id_evento_seq'::regclass);


--
-- Name: fermentacion id_fermentacion; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.fermentacion ALTER COLUMN id_fermentacion SET DEFAULT nextval('public.fermentacion_id_fermentacion_seq'::regclass);


--
-- Name: horario id_horario; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.horario ALTER COLUMN id_horario SET DEFAULT nextval('public.horario_id_horario_seq'::regclass);


--
-- Name: ingrediente id_ingrediente; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.ingrediente ALTER COLUMN id_ingrediente SET DEFAULT nextval('public.ingrediente_id_ingrediente_seq'::regclass);


--
-- Name: instruccion id_instruccion; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.instruccion ALTER COLUMN id_instruccion SET DEFAULT nextval('public.instruccion_id_instruccion_seq'::regclass);


--
-- Name: inventario id_inventario; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.inventario ALTER COLUMN id_inventario SET DEFAULT nextval('public.inventario_id_inventario_seq'::regclass);


--
-- Name: invitado id_invitado; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.invitado ALTER COLUMN id_invitado SET DEFAULT nextval('public.invitado_id_invitado_seq'::regclass);


--
-- Name: lugar id_lugar; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.lugar ALTER COLUMN id_lugar SET DEFAULT nextval('public.lugar_id_lugar_seq'::regclass);


--
-- Name: membresia id_membresia; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.membresia ALTER COLUMN id_membresia SET DEFAULT nextval('public.membresia_id_membresia_seq'::regclass);


--
-- Name: metodo_pago id_metodo; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.metodo_pago ALTER COLUMN id_metodo SET DEFAULT nextval('public.metodo_pago_id_metodo_seq'::regclass);


--
-- Name: orden_reposicion id_orden_reposicion; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.orden_reposicion ALTER COLUMN id_orden_reposicion SET DEFAULT nextval('public.orden_reposicion_id_orden_reposicion_seq'::regclass);


--
-- Name: orden_reposicion_anaquel id_orden_reposicion; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.orden_reposicion_anaquel ALTER COLUMN id_orden_reposicion SET DEFAULT nextval('public.orden_reposicion_anaquel_id_orden_reposicion_seq'::regclass);


--
-- Name: pago_compra id_pago; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_compra ALTER COLUMN id_pago SET DEFAULT nextval('public.pago_compra_id_pago_seq'::regclass);


--
-- Name: pago_orden_reposicion id_pago; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_orden_reposicion ALTER COLUMN id_pago SET DEFAULT nextval('public.pago_orden_reposicion_id_pago_seq'::regclass);


--
-- Name: persona_contacto id_contacto; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.persona_contacto ALTER COLUMN id_contacto SET DEFAULT nextval('public.persona_contacto_id_contacto_seq'::regclass);


--
-- Name: presentacion id_presentacion; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.presentacion ALTER COLUMN id_presentacion SET DEFAULT nextval('public.presentacion_id_presentacion_seq'::regclass);


--
-- Name: privilegio id_privilegio; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.privilegio ALTER COLUMN id_privilegio SET DEFAULT nextval('public.privilegio_id_privilegio_seq'::regclass);


--
-- Name: promocion id_promocion; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.promocion ALTER COLUMN id_promocion SET DEFAULT nextval('public.promocion_id_promocion_seq'::regclass);


--
-- Name: proveedor id_proveedor; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.proveedor ALTER COLUMN id_proveedor SET DEFAULT nextval('public.proveedor_id_proveedor_seq'::regclass);


--
-- Name: punto_cliente id_punto_cliente; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.punto_cliente ALTER COLUMN id_punto_cliente SET DEFAULT nextval('public.punto_cliente_id_punto_cliente_seq'::regclass);


--
-- Name: receta id_receta; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.receta ALTER COLUMN id_receta SET DEFAULT nextval('public.receta_id_receta_seq'::regclass);


--
-- Name: rol id_rol; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.rol ALTER COLUMN id_rol SET DEFAULT nextval('public.rol_id_rol_seq'::regclass);


--
-- Name: tasa id_tasa; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tasa ALTER COLUMN id_tasa SET DEFAULT nextval('public.tasa_id_tasa_seq'::regclass);


--
-- Name: telefono id_telefono; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.telefono ALTER COLUMN id_telefono SET DEFAULT nextval('public.telefono_id_telefono_seq'::regclass);


--
-- Name: tienda_fisica id_tienda_fisica; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tienda_fisica ALTER COLUMN id_tienda_fisica SET DEFAULT nextval('public.tienda_fisica_id_tienda_fisica_seq'::regclass);


--
-- Name: tienda_web id_tienda_web; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tienda_web ALTER COLUMN id_tienda_web SET DEFAULT nextval('public.tienda_web_id_tienda_web_seq'::regclass);


--
-- Name: tipo_actividad id_tipo_actividad; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tipo_actividad ALTER COLUMN id_tipo_actividad SET DEFAULT nextval('public.tipo_actividad_id_tipo_actividad_seq'::regclass);


--
-- Name: tipo_cerveza id_tipo_cerveza; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tipo_cerveza ALTER COLUMN id_tipo_cerveza SET DEFAULT nextval('public.tipo_cerveza_id_tipo_cerveza_seq'::regclass);


--
-- Name: tipo_invitado id_tipo_invitado; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tipo_invitado ALTER COLUMN id_tipo_invitado SET DEFAULT nextval('public.tipo_invitado_id_tipo_invitado_seq'::regclass);


--
-- Name: tipoevento id_tipo_evento; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tipoevento ALTER COLUMN id_tipo_evento SET DEFAULT nextval('public.tipoevento_id_tipo_evento_seq'::regclass);


--
-- Name: ubicacion_tienda id_ubicacion; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.ubicacion_tienda ALTER COLUMN id_ubicacion SET DEFAULT nextval('public.ubicacion_tienda_id_ubicacion_seq'::regclass);


--
-- Name: usuario id_usuario; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuario_id_usuario_seq'::regclass);


--
-- Name: vacacion id_vacacion; Type: DEFAULT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.vacacion ALTER COLUMN id_vacacion SET DEFAULT nextval('public.vacacion_id_vacacion_seq'::regclass);


--
-- Data for Name: actividad; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.actividad (id_actividad, tema, invitado_evento_invitado_id_invitado, invitado_evento_evento_id_evento, tipo_actividad_id_tipo_actividad) FROM stdin;
1	T├⌐cnicas de Fermentaci├│n	1	1	1
2	Historia de la Cerveza Venezolana	2	2	2
3	Cata Dirigida de Cervezas Tipo Ale	3	3	3
4	 Elaboraci├│n de Cerveza Belga	4	4	4
5	Seminario sobre Producci├│n Cervecera	5	5	5
6	Futuro de la Cerveza Artesanal	6	6	6
7	Demostraci├│n Pr├íctica de Lupulado	7	7	7
8	Competencia de Cata a Ciegas 	8	8	8
9	Oportunidades de Negocio en Cerveza	9	9	9
10	Presentaci├│n de Nuevas Variedades	10	10	10
\.


--
-- Data for Name: asistencia; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.asistencia (id_asistencia, fecha_hora_entrada, fecha_hora_salida, empleado_id_empleado) FROM stdin;
1	2024-12-16 08:15:00	2024-12-16 17:30:00	1
2	2024-12-17 08:00:00	2024-12-17 17:15:00	1
3	2024-12-18 08:30:00	2024-12-18 17:45:00	1
4	2024-12-16 07:45:00	2024-12-16 16:45:00	2
5	2024-12-17 08:10:00	2024-12-17 17:00:00	2
6	2024-12-18 08:05:00	2024-12-18 17:20:00	2
7	2024-12-16 08:20:00	2024-12-16 17:25:00	3
8	2024-12-17 08:15:00	2024-12-17 17:10:00	3
9	2024-12-18 08:00:00	2024-12-18 17:00:00	3
10	2024-12-16 08:00:00	2024-12-16 17:00:00	4
11	2024-12-17 08:25:00	2024-12-17 17:30:00	4
12	2024-12-18 08:10:00	2024-12-18 17:15:00	4
13	2024-12-16 08:35:00	2024-12-16 17:40:00	5
14	2024-12-17 08:05:00	2024-12-17 17:05:00	5
15	2024-12-18 08:20:00	2024-12-18 17:25:00	5
16	2024-12-16 07:55:00	2024-12-16 16:55:00	6
17	2024-12-17 08:15:00	2024-12-17 17:20:00	6
18	2024-12-18 08:30:00	2024-12-18 17:35:00	6
19	2024-12-16 08:10:00	2024-12-16 17:15:00	7
20	2024-12-17 08:00:00	2024-12-17 17:00:00	7
21	2024-12-18 08:25:00	2024-12-18 17:30:00	7
22	2024-12-16 08:05:00	2024-12-16 17:10:00	8
23	2024-12-17 08:20:00	2024-12-17 17:25:00	8
24	2024-12-18 08:15:00	2024-12-18 17:20:00	8
25	2024-12-16 08:30:00	2024-12-16 17:35:00	9
26	2024-12-17 08:10:00	2024-12-17 17:15:00	9
27	2024-12-18 08:00:00	2024-12-18 17:05:00	9
28	2024-12-16 07:50:00	2024-12-16 16:50:00	10
29	2024-12-17 08:15:00	2024-12-17 17:20:00	10
30	2024-12-18 08:25:00	2024-12-18 17:30:00	10
\.


--
-- Data for Name: beneficio; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.beneficio (id_beneficio, nombre, descripcion, monto, activo) FROM stdin;
1	Bono Alimentaci├│n	Bono mensual para alimentaci├│n de empleados	150.00	S
2	Seguro M├⌐dico	Cobertura m├⌐dica integral para empleados y familiares	200.00	S
3	Bono Transporte	Subsidio mensual para transporte p├║blico	80.00	S
4	Prima Vacacional	Bono adicional durante per├¡odo vacacional	300.00	S
5	Bono Productividad	Incentivo por cumplimiento de metas de ventas	250.00	S
6	Capacitaci├│n Cervecera	Cursos y talleres sobre cerveza artesanal	120.00	S
7	Bono Navide├▒o	Aguinaldo navide├▒o para empleados	400.00	S
8	Descuento Productos	Descuento del 30% en productos ACAUCAB	50.00	S
9	Seguro de Vida	P├│liza de seguro de vida para empleados	100.00	S
10	Bono Antig├╝edad	Bono por a├▒os de servicio en la asociaci├│n	180.00	N
\.


--
-- Data for Name: beneficio_depto_empleado; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.beneficio_depto_empleado (pagado, id_empleado, id_departamento, monto, id_beneficio) FROM stdin;
S	1	1	150.00	1
S	1	1	300.00	2
S	2	7	150.00	1
N	2	7	80.00	3
S	3	2	300.00	2
S	4	9	150.00	1
S	5	6	250.00	6
N	6	3	400.00	7
S	8	5	50.00	8
S	10	10	300.00	2
\.


--
-- Data for Name: caracteristica; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.caracteristica (id_caracteristica, tipo_caracteristica, valor_caracteristica) FROM stdin;
1	Sabor	Amargo
2	Sabor	Dulce
3	Sabor	├ücido
4	Color	Dorado
5	Color	├ümbar
6	Color	Oscuro
7	Aroma	Floral
8	Aroma	Frutal
9	Cuerpo	Ligero
10	Cuerpo	Robusto
11	Graduaci├│n alcoh├│lica	4.5%
12	Graduaci├│n alcoh├│lica	5.0%
13	Graduaci├│n alcoh├│lica	6.0%
14	Graduaci├│n alcoh├│lica	6.5%
15	Graduaci├│n alcoh├│lica	7.0%
16	Amargor	Bajo
17	Amargor	Medio
18	Amargor	Alto
19	Amargor	Muy alto
\.


--
-- Data for Name: caracteristica_especifica; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.caracteristica_especifica (id_tipo_cerveza, id_caracteristica, valor) FROM stdin;
1	4	Dorado
1	12	5.0%
1	15	Medio
2	5	├ümbar
2	13	6.0%
2	16	Alto
3	4	Dorado
3	11	4.5%
3	14	Bajo
4	5	├ümbar
4	12	5.0%
4	15	Medio
5	4	Dorado
5	12	5.0%
5	15	Medio
6	6	Oscuro
6	13	6.0%
6	16	Alto
7	5	├ümbar
7	13	6.0%
7	15	Medio
8	6	Oscuro
8	17	6.5%
8	16	Alto
9	4	Dorado
9	12	5.0%
9	14	Bajo
10	4	Dorado
10	11	4.5%
10	14	Bajo
11	5	├ümbar
11	13	6.0%
11	15	Medio
12	5	├ümbar
12	12	5.0%
12	15	Medio
13	4	Dorado
13	17	6.5%
13	19	Muy alto
14	5	├ümbar
14	12	5.0%
14	15	Medio
15	6	Oscuro
15	11	4.5%
15	14	Bajo
16	4	Dorado
16	12	5.0%
16	14	Bajo
17	7	Negro
17	13	6.0%
17	16	Alto
18	7	Negro
18	13	6.0%
18	16	Alto
19	6	Oscuro
19	18	7.0%
19	16	Alto
20	4	Dorado
20	18	7.0%
20	16	Alto
21	5	├ümbar
21	17	6.5%
21	15	Medio
22	4	Dorado
22	12	5.0%
22	14	Bajo
23	4	Dorado
23	11	4.5%
23	14	Bajo
24	6	Oscuro
24	18	7.0%
24	19	Muy alto
25	5	├ümbar
25	12	5.0%
25	15	Medio
26	5	├ümbar
26	12	5.0%
26	15	Medio
27	4	Dorado
27	17	6.5%
27	19	Muy alto
28	4	Dorado
28	18	7.0%
28	19	Muy alto
29	4	Dorado
29	17	6.5%
29	19	Muy alto
30	5	├ümbar
30	12	5.0%
30	15	Medio
31	5	├ümbar
31	12	5.0%
31	15	Medio
32	5	├ümbar
32	12	5.0%
32	15	Medio
33	7	Negro
33	13	6.0%
33	16	Alto
34	7	Negro
34	18	7.0%
34	19	Muy alto
35	7	Negro
35	13	6.0%
35	16	Alto
36	5	├ümbar
36	12	5.0%
36	15	Medio
37	4	Dorado
37	11	4.5%
37	14	Bajo
38	6	Oscuro
38	13	6.0%
38	16	Alto
39	6	Oscuro
39	18	7.0%
39	19	Muy alto
40	4	Dorado
40	17	6.5%
40	19	Muy alto
41	5	├ümbar
41	17	6.5%
41	15	Medio
42	7	Negro
42	17	6.5%
42	16	Alto
43	4	Dorado
43	12	5.0%
43	14	Bajo
44	5	├ümbar
44	12	5.0%
44	15	Medio
45	5	├ümbar
45	13	6.0%
45	16	Alto
46	4	Dorado
46	12	5.0%
46	14	Bajo
47	4	Dorado
47	11	4.5%
47	14	Bajo
48	5	├ümbar
48	12	5.0%
48	15	Medio
49	5	├ümbar
49	13	6.0%
49	16	Alto
\.


--
-- Data for Name: cargo; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.cargo (id_cargo, nombre, descripcion) FROM stdin;
1	Gerente General	Responsable de la direcci├│n estrat├⌐gica y operativa general de ACAUCAB, supervisa todos los departamentos
2	Jefe de Compras	Responsable de aprobar ├│rdenes de reposici├│n de inventario y gestionar compras a proveedores miembros
3	Gerente de Promociones	Encargado de seleccionar productos y descuentos para el DiarioDeUnaCerveza cada 30 d├¡as
4	Jefe de Pasillos	Responsable de la reposici├│n de productos en anaqueles cuando quedan 20 unidades disponibles
5	Responsable de Talento Humano	Encargado del an├ílisis de cumplimiento de horarios y gesti├│n del personal mediante reportes biom├⌐tricos
6	Empleado de Ventas en L├¡nea	Procesa presupuestos y compras v├¡a correo electr├│nico, prepara pedidos para entrega
7	Empleado de Despacho	Procesa pedidos y los tiene listos para entrega en m├íximo 2 horas, cambia estatus a "Listo para entrega"
8	Empleado de Entrega	Busca pedidos en zona de despacho y los entrega a clientes, cambia estatus a "Entregado"
9	Cajero de Tienda	Maneja ventas en tienda f├¡sica, descuento de inventario, control y canjeo de puntos de clientes
10	Especialista en Afiliaciones	Gestiona fichas de afiliaci├│n de miembros proveedores y cobro de cuotas mensuales
\.


--
-- Data for Name: cerveza; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.cerveza (id_cerveza, nombre_cerveza, id_tipo_cerveza, id_proveedor) FROM stdin;
1	Destilo	30	1
2	Valle Dorado	25	1
3	Cerveza del Valle Premium	23	1
4	Dos Leones	21	2
5	Premium Lager	3	2
6	Benitz Pale Ale	25	3
7	Para├¡so IPA	26	3
8	El Para├¡so Stout	28	3
9	Para├¡so Wheat	47	3
10	Candileja de Abad├¡a	19	4
11	├üngel o Demonio	20	5
12	La Pastora IPA	26	5
13	Pastora Lager	3	5
14	Barricas Saison Belga	21	6
15	San Agust├¡n Pale Ale	25	6
16	Aldarra Mantuana	23	7
17	La Vega IPA	26	7
18	Vega Stout	28	7
19	Mantuana Wheat	47	7
20	Tr├╢egs HopBack Amber	30	8
21	Full Sail Amber	30	9
22	San Juan IPA	26	9
23	Juan Pale Ale	25	9
24	Deschutes Cinder Cone	30	10
25	San Pedro Stout	28	10
26	Rogue American Amber	30	11
27	Rosal├¡a IPA	26	11
28	Santa Rosal├¡a Blonde	23	11
29	Rosal├¡a Wheat	47	11
30	La Chouffe	21	12
31	Orval	21	13
32	Sucre IPA	26	13
33	Sucre Pale Ale	25	13
34	Chimay	19	14
35	23 de Enero Lager	3	14
36	Leffe Blonde	23	15
37	Altagracia IPA	26	15
38	Altagracia Stout	28	15
39	Altagracia Wheat	47	15
40	Altagracia Amber	30	15
41	Hoegaarden	47	16
42	Pilsner Urquell	3	17
43	Catedral IPA	26	17
44	Catedral Pale Ale	25	17
45	Samuel Adams	9	18
46	Coche Stout	28	18
47	Junquito IPA	26	19
48	El Junquito Blonde	23	19
49	Junquito Wheat	47	19
50	Junquito Amber	30	19
51	Caricuao IPA	26	20
52	Caricuao Pale Ale	25	20
53	Caricuao Stout	28	20
54	Caricuao Blonde	23	20
55	Caricuao Wheat	47	20
56	Caricuao Amber	30	20
\.


--
-- Data for Name: cheque; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.cheque (id_metodo, num_cheque, num_cuenta, banco) FROM stdin;
11	1001	112345678	Banco de Venezuela
12	1002	213456789	Banesco
13	1003	314567890	Banco Mercantil
14	1004	415678901	BBVA Provincial
15	1005	516789012	Banco Bicentenario
16	1006	617890123	Bancaribe
17	1007	718901234	Banco Exterior
18	1008	819012345	Banco Plaza
19	1009	910123456	Mi Banco
20	1010	101234569	Banco Activo
\.


--
-- Data for Name: cliente_juridico; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.cliente_juridico (id_cliente, rif_cliente, razon_social, denominacion_comercial, capital_disponible, direccion_fiscal, direccion_fisica, pagina_web, lugar_id_lugar, lugar_id_lugar2) FROM stdin;
1	987654321	Distribuidora de Cervezas Artesanales, C.A.	Cervezas Artesanales	500000.00	Avenida Principal de La Candelaria, Edificio Comercial, Piso 4, Local 8	Calle Los Mangos, Zona Industrial La Candelaria, Galp├│n 15	www.cervezasartesanales.com	365	366
2	876543210	Importadora de Cervezas Premium, S.A.	Cervezas Premium	750000.00	Calle El Para├¡so, Edificio Premium, Piso 3, Local 12	Avenida Principal, Zona Industrial El Para├¡so, Galp├│n 8	www.cervezaspremium.com	368	369
3	765432109	Comercializadora de Cervezas Gourmet, C.A.	Cervezas Gourmet	600000.00	Avenida San Bernardino, Edificio Gourmet, Piso 2, Local 6	Calle Los Cedros, Zona Industrial San Bernardino, Galp├│n 10	www.cervezasgourmet.com	376	377
4	654321098	Distribuidora de Cervezas La Pastora, S.A.	Cervezas La Pastora	450000.00	Calle La Pastora, Edificio Comercial, Piso 5, Local 9	Avenida Principal, Zona Industrial La Pastora, Galp├│n 14	www.cervezaslapastora.com	372	373
5	543210987	Importadora de Cervezas San Agust├¡n, C.A.	Cervezas San Agust├¡n	550000.00	Avenida San Agust├¡n, Edificio Premium, Piso 3, Local 15	Calle Los Pinos, Zona Industrial San Agust├¡n, Galp├│n 7	www.cervezassanagustin.com	375	376
6	432109876	Comercializadora de Cervezas La Vega, S.A.	Cervezas La Vega	650000.00	Calle La Vega, Edificio Gourmet, Piso 4, Local 11	Avenida Principal, Zona Industrial La Vega, Galp├│n 9	www.cervezaslavega.com	373	374
7	321098765	Distribuidora de Cervezas San Jos├⌐, C.A.	Cervezas San Jos├⌐	480000.00	Avenida San Jos├⌐, Edificio Comercial, Piso 2, Local 7	Calle Los Cedros, Zona Industrial San Jos├⌐, Galp├│n 13	www.cervezassanjose.com	377	378
8	210987654	Importadora de Cervezas San Juan, S.A.	Cervezas San Juan	520000.00	Calle San Juan, Edificio Premium, Piso 3, Local 10	Avenida Principal, Zona Industrial San Juan, Galp├│n 11	www.cervezassanjuan.com	378	379
9	109876543	Comercializadora de Cervezas San Pedro, C.A.	Cervezas San Pedro	580000.00	Avenida San Pedro, Edificio Gourmet, Piso 5, Local 8	Calle Los Mangos, Zona Industrial San Pedro, Galp├│n 6	www.cervezassanpedro.com	379	380
10	987654320	Distribuidora de Cervezas Santa Rosal├¡a, S.A.	Cervezas Santa Rosal├¡a	620000.00	Calle Santa Rosal├¡a, Edificio Comercial, Piso 4, Local 13	Avenida Principal, Zona Industrial Santa Rosal├¡a, Galp├│n 16	www.cervezassantarosalia.com	380	381
11	876543201	Importadora de Cervezas Santa Teresa, C.A.	Cervezas Santa Teresa	490000.00	Avenida Santa Teresa, Edificio Premium, Piso 3, Local 9	Calle Los Cedros, Zona Industrial Santa Teresa, Galp├│n 8	www.cervezassantateresa.com	381	382
12	765432102	Comercializadora de Cervezas Sucre, S.A.	Cervezas Sucre	530000.00	Calle Sucre, Edificio Gourmet, Piso 2, Local 7	Avenida Principal, Zona Industrial Sucre, Galp├│n 12	www.cervezassucre.com	382	361
13	654321023	Distribuidora de Cervezas 23 de Enero, C.A.	Cervezas 23 de Enero	680000.00	Avenida 23 de Enero, Edificio Comercial, Piso 5, Local 14	Calle Los Pinos, Zona Industrial 23 de Enero, Galp├│n 9	www.cervezas23deenero.com	361	362
14	543210234	Importadora de Cervezas Altagracia, S.A.	Cervezas Altagracia	510000.00	Calle Altagracia, Edificio Premium, Piso 4, Local 11	Avenida Principal, Zona Industrial Altagracia, Galp├│n 15	www.cervezasaltagracia.com	362	363
15	432102345	Comercializadora de Cervezas Ant├¡mano, C.A.	Cervezas Ant├¡mano	590000.00	Avenida Ant├¡mano, Edificio Gourmet, Piso 3, Local 8	Calle Los Cedros, Zona Industrial Ant├¡mano, Galp├│n 10	www.cervezasantimano.com	363	364
16	321023456	Distribuidora de Cervezas Caricuao, S.A.	Cervezas Caricuao	470000.00	Calle Caricuao, Edificio Comercial, Piso 2, Local 12	Avenida Principal, Zona Industrial Caricuao, Galp├│n 7	www.cervezascaricuao.com	364	365
17	210234567	Importadora de Cervezas Catedral, C.A.	Cervezas Catedral	540000.00	Avenida Catedral, Edificio Premium, Piso 5, Local 10	Calle Los Mangos, Zona Industrial Catedral, Galp├│n 14	www.cervezascatedral.com	365	366
18	102345678	Comercializadora de Cervezas Coche, S.A.	Cervezas Coche	610000.00	Calle Coche, Edificio Gourmet, Piso 4, Local 15	Avenida Principal, Zona Industrial Coche, Galp├│n 11	www.cervezascoche.com	366	367
19	123456789	Distribuidora de Cervezas El Junquito, C.A.	Cervezas El Junquito	500000.00	Avenida El Junquito, Edificio Comercial, Piso 3, Local 9	Calle Los Cedros, Zona Industrial El Junquito, Galp├│n 13	www.cervezaseljunquito.com	367	368
20	234567890	Importadora de Cervezas del Valle, S.A.	Cervezas del Valle	570000.00	Calle del Valle, Edificio Premium, Piso 2, Local 7	Avenida Principal, Zona Industrial del Valle, Galp├│n 12	www.cervezasdelvalle.com	370	371
\.


--
-- Data for Name: cliente_natural; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.cliente_natural (id_cliente, rif_cliente, ci_cliente, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, direccion, lugar_id_lugar) FROM stdin;
1	123456789	12345678	Juan	Carlos	Rodr├¡guez	P├⌐rez	Avenida Principal de La Candelaria, Edificio Residencial Los Mangos, Piso 4, Apartamento 8	365
2	234567890	23456789	Mar├¡a	Isabel	Gonz├ílez	Mart├¡nez	Calle El Para├¡so, Residencia Premium, Piso 3, Apartamento 12	368
3	345678901	34567890	Pedro	Jos├⌐	L├│pez	Garc├¡a	Avenida San Bernardino, Edificio Gourmet, Piso 2, Apartamento 6	376
4	456789012	45678901	Ana	Mar├¡a	Hern├índez	S├ínchez	Calle La Pastora, Residencia Comercial, Piso 5, Apartamento 9	372
5	567890123	56789012	Carlos	Alberto	Mart├¡nez	Torres	Avenida San Agust├¡n, Edificio Premium, Piso 3, Apartamento 15	375
6	678901234	67890123	Laura	Patricia	D├¡az	Ram├¡rez	Calle La Vega, Residencia Gourmet, Piso 4, Apartamento 11	373
7	789012345	78901234	Roberto	Antonio	S├ínchez	Morales	Avenida San Jos├⌐, Edificio Comercial, Piso 2, Apartamento 7	377
8	890123456	89012345	Carmen	Elena	Torres	Vargas	Calle San Juan, Residencia Premium, Piso 3, Apartamento 10	378
9	901234567	90123456	Miguel	├üngel	Ram├¡rez	Castro	Avenida San Pedro, Edificio Gourmet, Piso 5, Apartamento 8	379
10	12345678	1234567	Sof├¡a	Beatriz	Morales	Rojas	Calle Santa Rosal├¡a, Residencia Comercial, Piso 4, Apartamento 13	380
11	123456780	12345670	Jos├⌐	Luis	Vargas	Mendoza	Avenida Santa Teresa, Edificio Premium, Piso 3, Apartamento 9	381
12	234567801	23456701	Isabel	Carmen	Castro	Guerrero	Calle Sucre, Residencia Gourmet, Piso 2, Apartamento 7	382
13	345678012	34567801	Antonio	Manuel	Rojas	Flores	Avenida 23 de Enero, Edificio Comercial, Piso 5, Apartamento 14	361
14	456780123	45678012	Patricia	Luc├¡a	Mendoza	Ortiz	Calle Altagracia, Residencia Premium, Piso 4, Apartamento 11	362
15	567801234	56780123	Luis	Fernando	Guerrero	Silva	Avenida Ant├¡mano, Edificio Gourmet, Piso 3, Apartamento 8	363
16	678012345	67801234	Elena	Victoria	Flores	Navarro	Calle Caricuao, Residencia Comercial, Piso 2, Apartamento 12	364
17	780123456	78012345	Francisco	Javier	Ortiz	Medina	Avenida Catedral, Edificio Premium, Piso 5, Apartamento 10	365
18	801234567	80123456	Gabriela	Alejandra	Silva	Reyes	Calle Coche, Residencia Gourmet, Piso 4, Apartamento 15	366
19	12345670	1234560	Daniel	Alberto	Navarro	Acosta	Avenida El Junquito, Edificio Comercial, Piso 3, Apartamento 9	367
20	123456701	12345601	Valentina	Mar├¡a	Medina	Paredes	Calle del Valle, Residencia Premium, Piso 2, Apartamento 7	370
21	987654321	87654321	Mar├¡a	Isabel	Rodr├¡guez	L├│pez	Calle Secundaria #456	1
22	3123424	30714892	Daniel	Perez	Da Silva	Gallardo	M├⌐rida, Libertador, Las Playitas	966
\.


--
-- Data for Name: compra; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.compra (id_compra, id_cliente_juridico, id_cliente_natural, monto_total, usuario_id_usuario, tienda_web_id_tienda, tienda_fisica_id_tienda) FROM stdin;
1	\N	1	150.00	\N	1	\N
2	\N	2	180.00	\N	1	\N
3	\N	3	120.00	\N	\N	1
4	\N	4	200.00	\N	\N	1
5	\N	5	160.00	\N	1	\N
6	\N	6	140.00	\N	1	\N
7	\N	7	190.00	\N	\N	1
8	\N	8	170.00	\N	\N	1
9	\N	9	130.00	\N	1	\N
10	\N	10	210.00	\N	1	\N
11	\N	11	145.00	\N	\N	1
12	\N	12	175.00	\N	\N	1
13	\N	13	155.00	\N	1	\N
14	\N	14	185.00	\N	1	\N
15	\N	15	135.00	\N	\N	1
16	\N	16	195.00	\N	\N	1
17	\N	17	165.00	\N	1	\N
18	\N	18	125.00	\N	1	\N
19	\N	19	205.00	\N	\N	1
20	\N	20	150.00	\N	\N	1
21	\N	1	140.00	\N	1	\N
22	\N	2	190.00	\N	1	\N
23	\N	3	170.00	\N	\N	1
24	\N	4	160.00	\N	\N	1
25	\N	5	180.00	\N	1	\N
26	\N	6	130.00	\N	1	\N
27	\N	7	145.00	\N	\N	1
28	\N	8	200.00	\N	\N	1
29	\N	9	155.00	\N	1	\N
30	\N	10	175.00	\N	1	\N
31	\N	11	120.00	\N	\N	1
32	\N	12	185.00	\N	\N	1
33	\N	13	165.00	\N	1	\N
34	\N	14	140.00	\N	1	\N
35	\N	15	195.00	\N	\N	1
36	\N	16	150.00	\N	\N	1
37	\N	17	170.00	\N	1	\N
38	\N	18	190.00	\N	1	\N
39	\N	19	125.00	\N	\N	1
40	\N	20	180.00	\N	\N	1
41	\N	1	145.00	\N	1	\N
42	\N	2	205.00	\N	1	\N
43	\N	3	160.00	\N	\N	1
44	\N	4	135.00	\N	\N	1
45	\N	5	185.00	\N	1	\N
46	\N	6	155.00	\N	1	\N
47	\N	7	170.00	\N	\N	1
48	\N	8	200.00	\N	\N	1
49	\N	9	140.00	\N	1	\N
50	\N	10	175.00	\N	1	\N
51	\N	11	190.00	\N	\N	1
52	\N	12	150.00	\N	\N	1
53	\N	21	200.00	\N	\N	1
54	\N	21	180.00	\N	1	\N
55	19	\N	350.00	\N	\N	1
56	\N	21	120.00	\N	1	\N
57	\N	21	100.00	\N	\N	1
58	\N	\N	0	61	1	\N
59	\N	22	12.00	\N	\N	1
60	\N	\N	0	1	1	\N
\.


--
-- Data for Name: compra_estatus; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.compra_estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion, fecha_hora_fin) FROM stdin;
1	3	2024-06-05 14:30:00	\N
2	3	2024-06-12 16:45:00	\N
3	3	2024-06-08 09:15:00	\N
4	3	2024-06-15 13:40:00	\N
5	3	2024-07-03 15:10:00	\N
6	3	2024-07-10 12:35:00	\N
7	3	2024-07-06 10:20:00	\N
8	3	2024-07-13 14:55:00	\N
9	3	2024-08-02 11:45:00	\N
10	3	2024-08-09 13:20:00	\N
11	3	2024-08-05 09:30:00	\N
12	3	2024-08-12 17:15:00	\N
13	3	2024-09-01 14:25:00	\N
14	3	2024-09-08 16:40:00	\N
15	3	2024-09-04 11:30:00	\N
16	3	2024-09-11 13:45:00	\N
17	3	2024-10-03 12:15:00	\N
18	3	2024-10-10 15:30:00	\N
19	3	2024-10-06 09:40:00	\N
20	3	2024-10-13 14:25:00	\N
21	3	2024-11-02 11:20:00	\N
22	3	2024-11-09 13:35:00	\N
23	3	2024-11-05 10:15:00	\N
24	3	2024-11-12 12:40:00	\N
25	3	2024-12-01 14:30:00	\N
26	3	2024-12-08 16:45:00	\N
27	3	2024-12-04 09:25:00	\N
28	3	2024-12-11 13:50:00	\N
29	3	2025-01-02 12:40:00	\N
30	3	2025-01-09 15:55:00	\N
31	3	2025-01-05 10:30:00	\N
32	3	2025-01-12 14:45:00	\N
33	3	2025-02-02 11:35:00	\N
34	3	2025-02-09 13:50:00	\N
35	3	2025-02-05 09:40:00	\N
36	3	2025-02-12 14:15:00	\N
37	3	2025-03-01 12:25:00	\N
38	3	2025-03-08 15:40:00	\N
39	3	2025-03-04 10:30:00	\N
40	3	2025-03-11 13:45:00	\N
41	3	2025-04-02 11:35:00	\N
42	3	2025-04-09 13:50:00	\N
43	3	2025-04-05 09:40:00	\N
44	3	2025-04-12 14:15:00	\N
45	3	2025-05-01 12:25:00	\N
46	3	2025-05-08 15:40:00	\N
47	3	2025-05-04 10:30:00	\N
48	3	2025-05-11 13:45:00	\N
49	3	2025-06-02 11:35:00	\N
50	3	2025-06-09 13:50:00	\N
51	3	2025-06-05 09:40:00	\N
52	3	2025-06-12 14:15:00	\N
53	3	2024-01-20 16:50:00	\N
54	3	2024-01-25 10:20:00	\N
55	3	2024-02-10 12:05:00	\N
56	3	2024-01-30 18:25:00	\N
57	3	2023-12-15 15:35:00	\N
58	2	2025-07-06 01:37:36.384018	9999-12-31 23:59:59
59	2	2025-07-06 01:37:38.791235	9999-12-31 23:59:59
60	2	2025-07-07 09:59:50.073958	9999-12-31 23:59:59
\.


--
-- Data for Name: correo; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.correo (id_correo, nombre, extension_pag, id_proveedor_proveedor, id_cliente_natural, id_cliente_juridico, id_empleado) FROM stdin;
1	cervezadelvalle	gmail.com	1	\N	\N	\N
2	ventas.cervezadelvalle	outlook.com	1	\N	\N	\N
3	cervezapremium	hotmail.com	2	\N	\N	\N
4	ventas.cervezapremium	yahoo.com	2	\N	\N	\N
5	cervezaelparaiso	outlook.com	3	\N	\N	\N
6	ventas.cervezaelparaiso	gmail.com	3	\N	\N	\N
7	cervezagourmet	yahoo.com	4	\N	\N	\N
8	ventas.cervezagourmet	hotmail.com	4	\N	\N	\N
9	cervezalapastora	gmail.com	5	\N	\N	\N
10	ventas.cervezalapastora	outlook.com	5	\N	\N	\N
11	cervezasanagustin	hotmail.com	6	\N	\N	\N
12	ventas.cervezasanagustin	yahoo.com	6	\N	\N	\N
13	cervezalavega	outlook.com	7	\N	\N	\N
14	ventas.cervezalavega	gmail.com	7	\N	\N	\N
15	cervezasanjose	yahoo.com	8	\N	\N	\N
16	ventas.cervezasanjose	hotmail.com	8	\N	\N	\N
17	cervezasanjuan	gmail.com	9	\N	\N	\N
18	ventas.cervezasanjuan	outlook.com	9	\N	\N	\N
19	cervezasanpedro	hotmail.com	10	\N	\N	\N
20	ventas.cervezasanpedro	yahoo.com	10	\N	\N	\N
21	cervezasantarosalia	outlook.com	11	\N	\N	\N
22	ventas.cervezasantarosalia	gmail.com	11	\N	\N	\N
23	cervezasantateresa	yahoo.com	12	\N	\N	\N
24	ventas.cervezasantateresa	hotmail.com	12	\N	\N	\N
25	cervezasucre	gmail.com	13	\N	\N	\N
26	ventas.cervezasucre	outlook.com	13	\N	\N	\N
27	cerveza23deenero	hotmail.com	14	\N	\N	\N
28	ventas.cerveza23deenero	yahoo.com	14	\N	\N	\N
29	cervezaaltagracia	outlook.com	15	\N	\N	\N
30	ventas.cervezaaltagracia	gmail.com	15	\N	\N	\N
31	cervezaantimano	yahoo.com	16	\N	\N	\N
32	ventas.cervezaantimano	hotmail.com	16	\N	\N	\N
33	cervezacaricuao	gmail.com	17	\N	\N	\N
34	ventas.cervezacaricuao	outlook.com	17	\N	\N	\N
35	cervezacatedral	hotmail.com	18	\N	\N	\N
36	ventas.cervezacatedral	yahoo.com	18	\N	\N	\N
37	cervezacoche	outlook.com	19	\N	\N	\N
38	ventas.cervezacoche	gmail.com	19	\N	\N	\N
39	cervezaeljunquito	yahoo.com	20	\N	\N	\N
40	ventas.cervezaeljunquito	hotmail.com	20	\N	\N	\N
41	info.cervezasartesanales	gmail.com	\N	\N	1	\N
42	ventas.cervezasartesanales	outlook.com	\N	\N	1	\N
43	info.cervezaspremium	hotmail.com	\N	\N	2	\N
44	ventas.cervezaspremium	yahoo.com	\N	\N	2	\N
45	info.cervezasgourmet	gmail.com	\N	\N	3	\N
46	ventas.cervezasgourmet	outlook.com	\N	\N	3	\N
47	info.cervezaslapastora	hotmail.com	\N	\N	4	\N
48	ventas.cervezaslapastora	yahoo.com	\N	\N	4	\N
49	info.cervezassanagustin	gmail.com	\N	\N	5	\N
50	ventas.cervezassanagustin	outlook.com	\N	\N	5	\N
51	info.cervezaslavega	hotmail.com	\N	\N	6	\N
52	ventas.cervezaslavega	yahoo.com	\N	\N	6	\N
53	info.cervezassanjose	gmail.com	\N	\N	7	\N
54	ventas.cervezassanjose	outlook.com	\N	\N	7	\N
55	info.cervezassanjuan	hotmail.com	\N	\N	8	\N
56	ventas.cervezassanjuan	yahoo.com	\N	\N	8	\N
57	info.cervezassanpedro	gmail.com	\N	\N	9	\N
58	ventas.cervezassanpedro	outlook.com	\N	\N	9	\N
59	info.cervezassantarosalia	hotmail.com	\N	\N	10	\N
60	ventas.cervezassantarosalia	yahoo.com	\N	\N	10	\N
61	info.cervezassantateresa	gmail.com	\N	\N	11	\N
62	ventas.cervezassantateresa	outlook.com	\N	\N	11	\N
63	info.cervezassucre	hotmail.com	\N	\N	12	\N
64	ventas.cervezassucre	yahoo.com	\N	\N	12	\N
65	info.cervezas23deenero	gmail.com	\N	\N	13	\N
66	ventas.cervezas23deenero	outlook.com	\N	\N	13	\N
67	info.cervezasaltagracia	hotmail.com	\N	\N	14	\N
68	ventas.cervezasaltagracia	yahoo.com	\N	\N	14	\N
69	info.cervezasantimano	gmail.com	\N	\N	15	\N
70	ventas.cervezasantimano	outlook.com	\N	\N	15	\N
71	info.cervezascaricuao	hotmail.com	\N	\N	16	\N
72	ventas.cervezascaricuao	yahoo.com	\N	\N	16	\N
73	info.cervezascatedral	gmail.com	\N	\N	17	\N
74	ventas.cervezascatedral	outlook.com	\N	\N	17	\N
75	info.cervezascoche	hotmail.com	\N	\N	18	\N
76	ventas.cervezascoche	yahoo.com	\N	\N	18	\N
77	info.cervezaseljunquito	gmail.com	\N	\N	19	\N
78	ventas.cervezaseljunquito	outlook.com	\N	\N	19	\N
79	info.cervezasdelvalle	hotmail.com	\N	\N	20	\N
80	ventas.cervezasdelvalle	yahoo.com	\N	\N	20	\N
81	juan.rodriguez	gmail.com	\N	1	\N	\N
82	juan.c.rodriguez	outlook.com	\N	1	\N	\N
83	maria.gonzalez	hotmail.com	\N	2	\N	\N
84	maria.i.gonzalez	yahoo.com	\N	2	\N	\N
85	pedro.lopez	gmail.com	\N	3	\N	\N
86	pedro.j.lopez	outlook.com	\N	3	\N	\N
87	ana.hernandez	hotmail.com	\N	4	\N	\N
88	ana.m.hernandez	yahoo.com	\N	4	\N	\N
89	carlos.martinez	gmail.com	\N	5	\N	\N
90	carlos.a.martinez	outlook.com	\N	5	\N	\N
91	laura.diaz	hotmail.com	\N	6	\N	\N
92	laura.p.diaz	yahoo.com	\N	6	\N	\N
93	roberto.sanchez	gmail.com	\N	7	\N	\N
94	roberto.a.sanchez	outlook.com	\N	7	\N	\N
95	carmen.torres	hotmail.com	\N	8	\N	\N
96	carmen.e.torres	yahoo.com	\N	8	\N	\N
97	miguel.ramirez	gmail.com	\N	9	\N	\N
98	miguel.a.ramirez	outlook.com	\N	9	\N	\N
99	sofia.morales	hotmail.com	\N	10	\N	\N
100	sofia.b.morales	yahoo.com	\N	10	\N	\N
101	jose.vargas	gmail.com	\N	11	\N	\N
102	jose.l.vargas	outlook.com	\N	11	\N	\N
103	isabel.castro	hotmail.com	\N	12	\N	\N
104	isabel.c.castro	yahoo.com	\N	12	\N	\N
105	antonio.rojas	gmail.com	\N	13	\N	\N
106	antonio.m.rojas	outlook.com	\N	13	\N	\N
107	patricia.mendoza	hotmail.com	\N	14	\N	\N
108	patricia.l.mendoza	yahoo.com	\N	14	\N	\N
109	luis.guerrero	gmail.com	\N	15	\N	\N
110	luis.f.guerrero	outlook.com	\N	15	\N	\N
111	elena.flores	hotmail.com	\N	16	\N	\N
112	elena.v.flores	yahoo.com	\N	16	\N	\N
113	francisco.ortiz	gmail.com	\N	17	\N	\N
114	francisco.j.ortiz	outlook.com	\N	17	\N	\N
115	gabriela.silva	hotmail.com	\N	18	\N	\N
116	gabriela.a.silva	yahoo.com	\N	18	\N	\N
117	daniel.navarro	gmail.com	\N	19	\N	\N
118	daniel.a.navarro	outlook.com	\N	19	\N	\N
119	valentina.medina	hotmail.com	\N	20	\N	\N
120	valentina.m.medina	yahoo.com	\N	20	\N	\N
121	admin	gmail.com	\N	\N	\N	1
122	prueba12	gmail.com	\N	\N	\N	2
123	prueba	gmail.com	\N	\N	\N	3
124	viscabarca	gmail.com	\N	\N	\N	4
125	pedri	gmail.com	\N	\N	\N	5
126	gavi	gmail.com	\N	\N	\N	6
127	lamine	gmail.com	\N	\N	\N	7
128	nico	gmail.com	\N	\N	\N	8
129	kounde	gmail.com	\N	\N	\N	9
130	nigga	gmail.com	\N	\N	\N	10
131	juan.perez	gmail.com	\N	1	\N	\N
132	maria.rodriguez	hotmail.com	\N	21	\N	\N
133	ventas	abccorp.com	\N	\N	19	\N
134	juansebaszmora	gmail.com	\N	22	\N	\N
\.


--
-- Data for Name: cuota_afiliacion; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.cuota_afiliacion (id_cuota, monto, membresia_id_membresia, fecha_pago) FROM stdin;
1	150.00	1	2024-01-15
2	150.00	2	2024-03-20
3	150.00	3	2024-06-10
4	150.00	4	2024-09-05
5	150.00	5	2024-11-12
6	120.00	6	2023-01-10
7	120.00	7	2023-05-15
8	120.00	8	2023-08-20
9	180.00	9	2024-02-01
10	180.00	10	2024-04-15
\.


--
-- Data for Name: departamento; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.departamento (id_departamento, nombre, fecha_creacion, descripcion, activo) FROM stdin;
1	Gerencia General	2012-10-01	Departamento responsable de la direcci├│n estrat├⌐gica y operativa general de ACAUCAB	S
2	Ventas en L├¡nea	2013-03-15	Departamento encargado de gestionar presupuestos y compras v├¡a correo electr├│nico e internet	S
3	Despacho	2012-11-20	Departamento responsable de procesar pedidos y tenerlos listos para entrega en m├íximo 2 horas	S
4	Entrega	2012-12-01	Departamento encargado de la entrega de pedidos a clientes y cambio de estatus a "Entregado"	S
5	Compras	2013-01-10	Departamento responsable de ├│rdenes de reposici├│n de inventario y aprobaci├│n de compras a proveedores	S
6	Promociones	2013-02-14	Departamento encargado de la creaci├│n del DiarioDeUnaCerveza y gesti├│n de ofertas cada 30 d├¡as	S
7	Talento Humano	2012-10-15	Departamento responsable del control de n├│mina, horarios, vacaciones, salarios y beneficios del personal	S
8	Gesti├│n de Miembros	2012-10-01	Departamento encargado de la gesti├│n de miembros proveedores, afiliaciones y cuotas mensuales	S
9	Gesti├│n de Clientes	2013-01-05	Departamento responsable de la emisi├│n de carnets, gesti├│n de puntos y atenci├│n a clientes	S
10	Sostenibilidad	2020-01-01	Departamento encargado de informes de sostenibilidad, auditor├¡as y cumplimiento de ODS	S
\.


--
-- Data for Name: departamento_empleado; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.departamento_empleado (fecha_inicio, fecha_final, salario, id_empleado, id_departamento, id_cargo) FROM stdin;
2023-01-15	\N	8500.00	1	1	1
2023-02-01	\N	4200.00	2	7	6
2023-01-20	\N	5800.00	3	2	4
2023-03-01	\N	4800.00	4	9	3
2023-02-15	\N	5200.00	5	6	5
2023-01-10	\N	4000.00	6	3	8
2023-04-01	\N	4500.00	7	4	8
2023-03-15	\N	5500.00	8	5	2
2023-02-20	\N	4800.00	9	8	9
2023-05-01	\N	6200.00	10	10	10
\.


--
-- Data for Name: descuento; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.descuento (porcentaje, id_promocion, id_tipo_cerveza, id_presentacion, id_cerveza) FROM stdin;
15.00	1	13	2	2
50.00	2	1	1	1
50.00	2	1	2	2
50.00	2	3	3	4
20.00	3	1	2	5
20.00	3	2	1	1
20.00	3	12	2	2
10.00	4	17	2	5
10.00	4	19	3	4
25.00	5	2	1	6
25.00	5	12	1	7
25.00	5	22	1	6
25.00	5	8	1	9
15.00	6	13	1	6
15.00	6	17	2	5
15.00	6	30	1	10
30.00	7	30	1	10
30.00	7	30	3	3
35.00	8	19	3	4
35.00	8	17	2	5
18.00	9	1	1	6
18.00	9	3	1	7
18.00	9	22	1	6
22.00	10	17	2	5
22.00	10	19	3	4
22.00	10	8	1	9
\.


--
-- Data for Name: detalle_compra; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.detalle_compra (precio_unitario, cantidad, id_inventario, id_compra, id_empleado) FROM stdin;
25.00	2	55	1	1
30.00	2	69	1	1
40.00	1	84	1	1
35.00	2	59	2	2
25.00	3	74	2	2
35.00	1	89	2	2
25.00	3	66	5	3
35.00	2	76	5	3
15.00	1	94	5	3
20.00	4	61	6	4
30.00	1	82	6	4
30.00	1	96	6	4
25.00	2	70	9	5
40.00	1	87	9	5
40.00	1	93	9	5
35.00	3	65	10	6
35.00	2	83	10	6
35.00	1	100	10	6
20.00	3	109	3	7
30.00	1	123	3	7
30.00	1	138	3	7
40.00	2	116	4	8
30.00	3	126	4	8
30.00	1	143	4	8
35.00	2	112	7	9
40.00	2	130	7	9
40.00	1	146	7	9
30.00	3	117	8	10
25.00	2	134	8	10
30.00	1	150	8	10
30.00	2	127	11	1
25.00	2	144	11	1
35.00	1	159	11	1
35.00	2	121	12	2
30.00	2	139	12	2
45.00	1	155	12	2
25.00	2	131	15	3
30.00	2	147	15	3
25.00	1	162	15	3
35.00	3	135	16	4
30.00	2	149	16	4
30.00	1	114	16	4
35.00	3	114	19	5
40.00	2	116	19	5
20.00	1	118	19	5
30.00	2	120	20	6
30.00	2	122	20	6
30.00	1	124	20	6
30.00	5	1	1	1
40.00	4	2	53	2
30.00	6	3	54	3
30.00	8	1	55	4
40.00	3	2	55	4
30.00	4	3	56	5
30.00	3	1	57	6
5.00	1	110	59	\N
5.00	1	113	59	\N
2.00	1	117	59	\N
\.


--
-- Data for Name: detalle_orden_reposicion; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.detalle_orden_reposicion (cantidad, id_orden_reposicion, id_proveedor, id_departamento, precio, id_presentacion, id_cerveza) FROM stdin;
5	1	1	3	5	1	1
5	1	1	3	5	2	2
5	1	1	3	5	3	3
5	1	1	3	5	3	4
5	1	1	3	5	2	5
5	2	2	3	5	1	6
5	2	2	3	5	1	7
5	2	2	3	5	1	8
5	2	2	3	5	1	9
5	2	2	3	5	1	10
5	3	3	3	5	1	1
5	3	3	3	5	2	2
5	3	3	3	5	3	3
5	3	3	3	5	3	4
5	3	3	3	5	2	5
5	4	4	3	5	1	6
5	4	4	3	5	1	7
5	4	4	3	5	1	8
5	4	4	3	5	1	9
5	4	4	3	5	1	10
5	5	5	3	5	1	1
5	5	5	3	5	2	2
5	5	5	3	5	3	3
5	5	5	3	5	3	4
5	5	5	3	5	2	5
5	6	6	3	5	1	6
5	6	6	3	5	1	7
5	6	6	3	5	1	8
5	6	6	3	5	1	9
5	6	6	3	5	1	10
5	7	7	3	5	1	1
5	7	7	3	5	2	2
5	7	7	3	5	3	3
5	7	7	3	5	3	4
5	7	7	3	5	2	5
5	8	8	3	5	1	6
5	8	8	3	5	1	7
5	8	8	3	5	1	8
5	8	8	3	5	1	9
5	8	8	3	5	1	10
5	9	9	3	5	1	1
5	9	9	3	5	2	2
5	9	9	3	5	3	3
5	9	9	3	5	3	4
5	9	9	3	5	2	5
5	10	10	3	5	1	6
5	10	10	3	5	1	7
5	10	10	3	5	1	8
5	10	10	3	5	1	9
5	10	10	3	5	1	10
\.


--
-- Data for Name: detalle_orden_reposicion_anaquel; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.detalle_orden_reposicion_anaquel (id_orden_reposicion, id_inventario, cantidad) FROM stdin;
1	11	50
1	12	30
2	13	75
2	14	25
3	15	40
4	16	60
4	17	45
5	18	35
6	19	80
7	20	20
\.


--
-- Data for Name: detalle_venta_evento; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.detalle_venta_evento (precio_unitario, cantidad, id_evento, id_cliente_natural, id_cerveza, id_proveedor, id_proveedor_evento, id_tipo_cerveza, id_presentacion, id_cerveza_inv) FROM stdin;
15.50	3	1	1	1	1	1	30	1	1
16.00	2	1	3	1	1	1	30	1	1
16.50	2	1	5	1	1	1	30	1	1
17.00	2	1	7	1	1	1	30	1	1
18.00	2	2	2	5	5	2	20	2	5
18.50	2	2	4	5	5	2	20	2	5
19.00	2	3	1	1	1	1	30	1	1
19.50	2	3	6	1	1	1	30	1	1
20.00	2	3	8	1	1	1	30	1	1
\.


--
-- Data for Name: efectivo; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.efectivo (id_metodo, denominacion) FROM stdin;
1	1
2	5
3	10
4	20
5	50
6	100
7	200
8	500
\.


--
-- Data for Name: empleado; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.empleado (id_empleado, cedula, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, direccion, activo, lugar_id_lugar) FROM stdin;
1	V-12345678	Carlos	Alberto	Gonz├ílez	P├⌐rez	Av. Libertador, Edificio Torre Central, Piso 5, Apt 5-A	S	360
2	V-23456789	Mar├¡a	Elena	Rodr├¡guez	Mart├¡nez	Calle Principal de Las Mercedes, Casa #45	S	365
3	V-34567890	Jos├⌐	Luis	Hern├índez	Silva	Urbanizaci├│n El Trigal, Calle 5, Casa 123	S	366
4	V-45678901	Ana	Beatriz	L├│pez	Garc├¡a	Sector La Candelaria, Carrera 15 con Calle 8, Casa 67	S	367
5	V-56789012	Miguel	├üngel	Fern├índez	Morales	Av. Universidad, Residencias Los Rosales, Torre B, Apt 8-C	S	368
6	V-67890123	Carmen	Rosa	Jim├⌐nez	Vargas	Calle Bol├¡var, Centro Comercial Sambil, Local 234	S	369
7	V-78901234	Roberto	Antonio	Mendoza	Castillo	Zona Industrial de Maracaibo, Galp├│n 15	S	370
8	V-89012345	Luisa	Fernanda	Torres	Ramos	Urbanizaci├│n Santa Rosa, Calle Los Mangos, Casa 89	S	375
9	V-90123456	Pedro	Jos├⌐	Moreno	D├¡az	Av. Principal de Puerto La Cruz, Edificio Mar Azul, Piso 3	S	378
10	V-01234567	Gabriela	Isabel	Ruiz	Herrera	Calle Real de Los Teques, Quinta Villa Hermosa	S	380
\.


--
-- Data for Name: estatus; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.estatus (id_estatus, nombre) FROM stdin;
1	Iniciada
2	En proceso
3	Atendida
13	Pendiente
\.


--
-- Data for Name: estatus_orden_anaquel; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.estatus_orden_anaquel (id_orden_reposicion, id_estatus, fecha_hora_asignacion) FROM stdin;
1	1	2025-01-15 08:30:00
2	2	2025-01-15 08:45:00
3	3	2025-01-15 10:30:00
4	1	2025-01-15 14:45:00
5	2	2025-01-15 15:00:00
6	3	2025-01-15 15:15:00
7	1	2025-01-16 09:15:00
8	3	2025-01-16 09:30:00
9	1	2025-01-16 16:20:00
10	2	2025-01-16 16:35:00
\.


--
-- Data for Name: evento; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.evento (id_evento, nombre, descripcion, fecha_inicio, fecha_fin, lugar_id_lugar, n_entradas_vendidas, precio_unitario_entrada, tipo_evento_id) FROM stdin;
1	UBirra 2024	Festival anual de cerveza artesanal con 30 productores venezolanos y degustaci├│n de m├ís de 50 tipos de cerveza	2024-07-19 10:00:00	2024-07-20 22:00:00	52	850	25.00	1
2	Taller de Cata Premium	Sesi├│n especializada de degustaci├│n dirigida por maestros cerveceros con cervezas importadas y nacionales	2024-08-15 18:00:00	2024-08-15 21:00:00	58	45	75.00	2
3	Lanzamiento Cerveza Caraque├▒a	Presentaci├│n oficial de la nueva l├¡nea de cervezas artesanales inspiradas en sabores tradicionales de Caracas	2024-09-10 19:00:00	2024-09-10 23:00:00	56	120	35.00	3
4	Maridaje Andino	Experiencia gastron├│mica combinando cervezas artesanales con platos t├¡picos de la regi├│n andina venezolana	2024-10-05 17:00:00	2024-10-05 22:00:00	61	80	95.00	4
5	Copa ACAUCAB 2024	Competencia nacional de cerveceros artesanales con jurado internacional y premios por categor├¡as	2024-11-12 09:00:00	2024-11-14 18:00:00	66	200	45.00	5
6	Conferencia T├⌐cnica Avanzada	Charlas magistrales sobre innovaci├│n en procesos de fermentaci├│n y nuevas tendencias mundiales	2024-06-22 14:00:00	2024-06-22 18:00:00	64	75	55.00	6
7	Networking Cervecero Valencia	Encuentro de negocios para fortalecer alianzas entre productores, distribuidores y puntos de venta	2024-05-18 16:00:00	2024-05-18 20:00:00	66	95	40.00	7
8	Oktoberfest Venezolano	Celebraci├│n tradicional alemana adaptada con cervezas artesanales venezolanas y m├║sica folkl├│rica	2024-10-19 15:00:00	2024-10-19 23:00:00	77	650	30.00	8
9	Curso B├ísico de Elaboraci├│n	Capacitaci├│n pr├íctica de fin de semana para aprender t├⌐cnicas b├ísicas de producci├│n cervecera artesanal	2024-09-28 08:00:00	2024-09-29 17:00:00	33	25	180.00	9
10	Feria Cervecera del Zulia	Exposici├│n comercial regional con stands de equipos, insumos y productos cerveceros artesanales	2024-12-07 10:00:00	2024-12-08 19:00:00	77	320	20.00	10
\.


--
-- Data for Name: evento_proveedor; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.evento_proveedor (id_proveedor, id_evento, hora_llegada, hora_salida, dia) FROM stdin;
1	1	09:00:00	17:00:00	2025-01-15
2	1	09:30:00	16:30:00	2025-01-15
3	1	10:00:00	18:00:00	2025-01-15
4	2	08:30:00	15:00:00	2025-01-20
5	2	09:15:00	16:45:00	2025-01-20
1	3	11:00:00	19:00:00	2025-01-25
6	3	12:00:00	18:30:00	2025-01-25
7	4	18:00:00	23:00:00	2025-02-01
8	5	07:00:00	12:00:00	2025-02-05
9	6	10:30:00	20:00:00	2025-02-10
\.


--
-- Data for Name: fermentacion; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.fermentacion (id_fermentacion, receta_id_receta, fecha_inicio, fecha_fin_estimada) FROM stdin;
1	1	2025-01-01	2025-03-01
2	2	2025-01-15	2025-04-15
3	3	2025-01-10	2025-01-24
4	4	2025-01-20	2025-02-03
5	5	2025-01-25	2025-02-08
6	7	2025-02-01	2025-02-15
7	8	2025-02-05	2025-04-05
8	10	2025-02-10	2025-05-10
9	1	2025-02-01	2025-04-01
10	5	2025-02-15	2025-03-01
\.


--
-- Data for Name: horario; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.horario (id_horario, dia, hora_entrada, hora_salida) FROM stdin;
1	Lunes	08:00:00	17:00:00
2	Martes	08:00:00	17:00:00
3	Mi├⌐rcoles	08:00:00	17:00:00
4	Jueves	08:00:00	17:00:00
5	Viernes	08:00:00	17:00:00
6	S├íbado	09:00:00	13:00:00
7	Lunes	08:30:00	16:30:00
8	Martes	08:00:00	12:00:00
9	Jueves	09:00:00	18:00:00
10	Viernes	08:00:00	17:00:00
\.


--
-- Data for Name: horario_empleado; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.horario_empleado (id_empleado, id_horario) FROM stdin;
1	1
2	2
3	3
4	4
5	5
6	6
7	7
8	8
9	9
10	10
\.


--
-- Data for Name: horario_evento; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.horario_evento (id_evento, id_horario) FROM stdin;
1	1
2	2
3	3
4	4
5	5
6	6
7	7
8	8
9	9
10	10
\.


--
-- Data for Name: ingrediente; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.ingrediente (id_ingrediente, tipo, valor, ingrediente_padre, nombre) FROM stdin;
1	Malta	2.5	\N	Malta Pilsner
2	Malta	3.2	\N	Malta Munich
3	L├║pulo	5.5	\N	L├║pulo Cascade
4	L├║pulo	7.2	\N	L├║pulo Centennial
5	Levadura	0.5	\N	Levadura Ale
6	Levadura	0.4	\N	Levadura Lager
7	Agua	1.0	\N	Agua Filtrada
8	Mezcla	2.8	1	Mezcla Malta Base
9	Mezcla	6.3	3	Blend L├║pulo Amargo
10	Adjunto	1.8	\N	Adjunto Ma├¡z
\.


--
-- Data for Name: instruccion; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.instruccion (id_instruccion, nombre, descripcion, receta_id) FROM stdin;
1	Fermentaci├│n Fr├¡a	Fermentar con levadura Saccharomyces Carlsbergenesis a temperatura menor a 10┬░C durante 1-3 meses. Mantener temperatura constante en c├ímara frigor├¡fica.	1
2	Preparaci├│n Malta Clara	Usar alta proporci├│n de malta clara con poco o nada de malta tostada. Agregar malta de trigo opcional para mejorar textura.	1
3	Fermentaci├│n Lenta	Utilizar levadura de baja fermentaci├│n manteniendo proceso lento para desarrollar el sabor ligero pero intenso caracter├¡stico del estilo Pilsner.	2
4	Fermentaci├│n Superficial	Fermentar con levadura Saccharomyces Cerevisiae en la superficie del fermentador a 19┬░C durante 5-7 d├¡as para lograr fermentaci├│n alta caracter├¡stica.	3
5	Segunda Fermentaci├│n	Realizar segunda fermentaci├│n durante 3-5 d├¡as adicionales para reducir la turbidez y mejorar la claridad de la cerveza ale.	3
6	Lupulizaci├│n Intensa	Usar abundante l├║pulo americano con car├ícter c├¡trico para lograr el sabor intenso y amargor caracter├¡stico. Aplicar l├║pulos en diferentes momentos del hervor.	4
7	Dry Hopping	Aplicar proceso de dry hopping con l├║pulos americanos para intensificar el aroma floral, frutal, c├¡trico o resinoso caracter├¡stico de las American IPA.	5
8	Control de Amargor	Mantener IBUs entre 40-60 y graduaci├│n alcoh├│lica entre 5-7.5% para cumplir con est├índares del estilo IPA dise├▒ado para largas traves├¡as.	5
9	Preparaci├│n Trigo	Usar malta de trigo total o parcialmente manteniendo color claro y baja graduaci├│n. Fermentar con levadura ale siguiendo tradici├│n alemana del Oktober Fest.	7
10	Tradici├│n Mon├ística	Seguir t├⌐cnicas tradicionales de monasterios usando buenas dosis de l├║pulo con fondo dulce de maltas ├ímbar y cristal. Lograr tonos rojizos y alta graduaci├│n alcoh├│lica (+6-7%).	8
\.


--
-- Data for Name: inventario; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.inventario (id_inventario, cantidad, id_tienda_web, id_tienda_fisica, id_ubicacion, id_presentacion, id_cerveza) FROM stdin;
3	500	\N	1	\N	3	1
4	500	\N	1	\N	1	2
5	500	\N	1	\N	2	2
6	500	\N	1	\N	3	2
7	500	\N	1	\N	1	3
8	500	\N	1	\N	2	3
9	500	\N	1	\N	3	3
10	500	\N	1	\N	1	4
11	500	\N	1	\N	2	4
12	500	\N	1	\N	3	4
13	500	\N	1	\N	1	5
14	500	\N	1	\N	2	5
15	500	\N	1	\N	3	5
16	500	\N	1	\N	1	6
17	500	\N	1	\N	2	6
18	500	\N	1	\N	3	6
19	500	\N	1	\N	1	7
20	500	\N	1	\N	2	7
21	500	\N	1	\N	3	7
22	500	\N	1	\N	1	8
23	500	\N	1	\N	2	8
24	500	\N	1	\N	3	8
25	500	\N	1	\N	1	9
26	500	\N	1	\N	2	9
27	500	\N	1	\N	3	9
28	500	\N	1	\N	1	10
29	500	\N	1	\N	2	10
30	500	\N	1	\N	3	10
31	500	\N	1	\N	1	11
32	500	\N	1	\N	2	11
33	500	\N	1	\N	3	11
34	500	\N	1	\N	1	12
35	500	\N	1	\N	2	12
36	500	\N	1	\N	3	12
37	500	\N	1	\N	1	13
38	500	\N	1	\N	2	13
39	500	\N	1	\N	3	13
40	500	\N	1	\N	1	14
41	500	\N	1	\N	2	14
42	500	\N	1	\N	3	14
43	500	\N	1	\N	1	15
44	500	\N	1	\N	2	15
45	500	\N	1	\N	3	15
46	500	\N	1	\N	1	16
47	500	\N	1	\N	2	16
48	500	\N	1	\N	3	16
49	500	\N	1	\N	1	17
50	500	\N	1	\N	2	17
51	500	\N	1	\N	3	17
52	500	\N	1	\N	1	18
53	500	\N	1	\N	2	18
54	500	\N	1	\N	3	18
55	500	1	\N	\N	1	1
56	500	1	\N	\N	2	1
57	500	1	\N	\N	3	1
58	500	1	\N	\N	1	2
59	500	1	\N	\N	2	2
60	500	1	\N	\N	3	2
61	500	1	\N	\N	1	3
62	500	1	\N	\N	2	3
63	500	1	\N	\N	3	3
64	500	1	\N	\N	1	4
65	500	1	\N	\N	2	4
66	500	1	\N	\N	3	4
67	500	1	\N	\N	1	5
68	500	1	\N	\N	2	5
69	500	1	\N	\N	3	5
70	500	1	\N	\N	1	6
71	500	1	\N	\N	2	6
72	500	1	\N	\N	3	6
73	500	1	\N	\N	1	7
74	500	1	\N	\N	2	7
75	500	1	\N	\N	3	7
76	500	1	\N	\N	1	8
77	500	1	\N	\N	2	8
78	500	1	\N	\N	3	8
79	500	1	\N	\N	1	9
80	500	1	\N	\N	2	9
81	500	1	\N	\N	3	9
82	500	1	\N	\N	1	10
83	500	1	\N	\N	2	10
84	500	1	\N	\N	3	10
85	500	1	\N	\N	1	11
86	500	1	\N	\N	2	11
87	500	1	\N	\N	3	11
88	500	1	\N	\N	1	12
89	500	1	\N	\N	2	12
90	500	1	\N	\N	3	12
91	500	1	\N	\N	1	13
92	500	1	\N	\N	2	13
93	500	1	\N	\N	3	13
94	500	1	\N	\N	1	14
95	500	1	\N	\N	2	14
96	500	1	\N	\N	3	14
97	500	1	\N	\N	1	15
98	500	1	\N	\N	2	15
99	500	1	\N	\N	3	15
100	500	1	\N	\N	1	16
101	500	1	\N	\N	2	16
102	500	1	\N	\N	3	16
103	500	1	\N	\N	1	17
104	500	1	\N	\N	2	17
105	500	1	\N	\N	3	17
106	500	1	\N	\N	1	18
107	500	1	\N	\N	2	18
108	500	1	\N	\N	3	18
109	35	\N	\N	5	1	1
110	35	\N	\N	5	2	1
111	35	\N	\N	5	3	1
112	35	\N	\N	7	1	2
113	35	\N	\N	7	2	2
114	35	\N	\N	7	3	2
115	35	\N	\N	2	1	3
116	35	\N	\N	2	2	3
117	35	\N	\N	2	3	3
118	35	\N	\N	3	1	4
119	35	\N	\N	3	2	4
120	35	\N	\N	3	3	4
121	35	\N	\N	4	1	5
122	35	\N	\N	4	2	5
123	35	\N	\N	4	3	5
124	35	\N	\N	7	1	6
125	35	\N	\N	7	2	6
126	35	\N	\N	7	3	6
127	35	\N	\N	7	1	7
128	35	\N	\N	7	2	7
129	35	\N	\N	7	3	7
130	35	\N	\N	6	1	8
131	35	\N	\N	6	2	8
132	35	\N	\N	6	3	8
133	35	\N	\N	9	1	9
134	35	\N	\N	9	2	9
135	35	\N	\N	9	3	9
136	35	\N	\N	3	1	10
137	35	\N	\N	3	2	10
138	35	\N	\N	3	3	10
139	35	\N	\N	3	1	11
140	35	\N	\N	3	2	11
141	35	\N	\N	3	3	11
142	35	\N	\N	7	1	12
143	35	\N	\N	7	2	12
144	35	\N	\N	7	3	12
145	35	\N	\N	4	1	13
146	35	\N	\N	4	2	13
147	35	\N	\N	4	3	13
148	35	\N	\N	3	1	14
149	35	\N	\N	3	2	14
150	35	\N	\N	3	3	14
151	35	\N	\N	7	1	15
152	35	\N	\N	7	2	15
153	35	\N	\N	7	3	15
154	35	\N	\N	2	1	16
155	35	\N	\N	2	2	16
156	35	\N	\N	2	3	16
157	35	\N	\N	7	1	17
158	35	\N	\N	7	2	17
159	35	\N	\N	7	3	17
160	35	\N	\N	6	1	18
161	35	\N	\N	6	2	18
162	35	\N	\N	6	3	18
2	0	\N	1	\N	2	1
1	-1000	\N	1	\N	1	1
\.


--
-- Data for Name: inventario_evento_proveedor; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.inventario_evento_proveedor (id_proveedor, id_evento, cantidad, id_tipo_cerveza, id_presentacion, id_cerveza) FROM stdin;
1	1	200	30	1	1
1	1	150	30	2	2
1	1	100	30	3	3
2	1	180	21	1	1
2	1	120	21	2	2
2	1	80	21	3	3
3	1	250	25	3	3
3	1	150	25	3	4
4	2	50	19	3	4
5	2	60	20	2	5
5	2	45	20	1	6
1	3	100	30	1	1
1	3	80	30	2	2
6	3	120	21	1	6
7	4	80	23	1	7
8	5	100	30	1	8
9	6	40	30	1	9
\.


--
-- Data for Name: invitado; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.invitado (id_invitado, nombre, lugar_id, tipo_invitado_id, rif, direccion) FROM stdin;
1	Carlos Mendoza - Cervecer├¡a Artesanal El Dorado	52	1	123456789	Av. Francisco de Miranda, Torre Empresarial, Piso 12, Caracas
2	Mar├¡a Fern├índez - Sommelier Certificada	56	2	234567890	Calle Los Rosales, Quinta Villa Hermosa, Las Mercedes, Miranda
3	Jos├⌐ Rodr├¡guez - Distribuidora Cervecera Nacional	66	3	345678901	Zona Industrial Norte, Galp├│n 45, Valencia, Carabobo
4	Ana Guti├⌐rrez - Brewpub La Tradici├│n	77	4	456789012	Av. Bella Vista, Centro Comercial Maracaibo Plaza, Local 234
5	Miguel Torres - Consultor T├⌐cnico Cervecero	58	5	567890123	Urbanizaci├│n El Rosal, Torre Financiera, Oficina 801, Chacao
6	Carmen L├│pez - Revista Cerveza & Gastronom├¡a	52	6	678901234	Av. Urdaneta, Edificio El Universal, Piso 8, Caracas
7	Roberto Silva - @CervezaVenezuela	61	7	789012345	Calle Real de Los Teques, Residencias Los Pinos, Apt 15-B
8	Luisa Morales - Chef Especialista	64	8	890123456	Av. Bol├¡var Norte, Restaurante Tradici├│n, Naguanagua, Carabobo
9	Pedro Ram├¡rez - Equipos Cerveceros Andinos	33	9	901234567	Sector Industrial, Calle Principal, Galp├│n 12, Anaco
10	Gabriela Herrera - Universidad Gastron├│mica	49	10	12345678	Campus Universitario, Facultad de Ciencias, Puerto La Cruz
\.


--
-- Data for Name: invitado_evento; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.invitado_evento (id_invitado, id_evento, hora_llegada, hora_salida) FROM stdin;
1	1	10:30:00	21:30:00
2	2	18:15:00	20:45:00
3	3	19:30:00	22:30:00
4	4	17:30:00	21:30:00
5	5	09:30:00	17:30:00
6	6	14:30:00	17:30:00
7	7	16:30:00	19:30:00
8	8	15:30:00	22:30:00
9	9	08:30:00	16:30:00
10	10	10:30:00	18:30:00
\.


--
-- Data for Name: lugar; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.lugar (id_lugar, nombre, tipo, lugar_relacion_id) FROM stdin;
1	Anzo├ítegui	Estado	\N
2	Amazonas	Estado	\N
3	Apure	Estado	\N
4	Aragua	Estado	\N
5	Barinas	Estado	\N
6	Bol├¡var	Estado	\N
7	Carabobo	Estado	\N
8	Cojedes	Estado	\N
9	Delta Amacuro	Estado	\N
10	Distrito Capital	Estado	\N
11	Falc├│n	Estado	\N
12	Gu├írico	Estado	\N
13	Lara	Estado	\N
14	M├⌐rida	Estado	\N
15	Miranda	Estado	\N
16	Monagas	Estado	\N
17	Nueva Esparta	Estado	\N
18	Portuguesa	Estado	\N
19	Sucre	Estado	\N
20	T├íchira	Estado	\N
21	Trujillo	Estado	\N
22	La Guaira	Estado	\N
23	Yaracuy	Estado	\N
24	Zulia	Estado	\N
25	Alto Orinoco	Municipio	1
26	Atabapo	Municipio	1
27	Atures	Municipio	1
28	Autana	Municipio	1
29	Manapiare	Municipio	1
30	Maroa	Municipio	1
31	R├¡o Negro	Municipio	1
32	Anaco	Municipio	2
33	Aragua	Municipio	2
34	Diego Bautista Urbaneja	Municipio	2
35	Fernando de Pe├▒alver	Municipio	2
36	Francisco del Carmen Carvajal	Municipio	2
37	Francisco de Miranda	Municipio	2
38	Guanta	Municipio	2
39	Independencia	Municipio	2
40	Jos├⌐ Gregorio Monagas	Municipio	2
41	Juan Antonio Sotillo	Municipio	2
42	Juan Manuel Cajigal	Municipio	2
43	Libertad	Municipio	2
44	Manuel Ezequiel Bruzual	Municipio	2
45	Pedro Mar├¡a Freites	Municipio	2
46	P├¡ritu	Municipio	2
47	San Jos├⌐ de Guanipa	Municipio	2
48	San Juan de Capistrano	Municipio	2
49	Santa Ana	Municipio	2
50	Sim├│n Bol├¡var	Municipio	2
51	Sim├│n Rodr├¡guez	Municipio	2
52	Sir Artur McGregor	Municipio	2
53	Achaguas	Municipio	3
54	Biruaca	Municipio	3
55	Mu├▒oz	Municipio	3
56	P├íez	Municipio	3
57	Pedro Camejo	Municipio	3
58	R├│mulo Gallegos	Municipio	3
59	San Fernando	Municipio	3
60	Bol├¡var	Municipio	4
61	Camatagua	Municipio	4
62	Francisco Linares Alc├íntara	Municipio	4
63	Girardot	Municipio	4
64	Jos├⌐ ├üngel Lamas	Municipio	4
65	Jos├⌐ F├⌐lix Ribas	Municipio	4
66	Jos├⌐ Rafael Revenga	Municipio	4
67	Libertador	Municipio	4
68	Mario Brice├▒o Iragorry	Municipio	4
69	Ocumare de la Costa de Oro	Municipio	4
70	San Casimiro	Municipio	4
71	San Sebasti├ín	Municipio	4
72	Santiago Mari├▒o	Municipio	4
73	Santos Michelena	Municipio	4
74	Sucre	Municipio	4
75	Tovar	Municipio	4
76	Urdaneta	Municipio	4
77	Zamora	Municipio	4
78	Alberto Arvelo Torrealba	Municipio	5
79	Andr├⌐s Eloy Blanco	Municipio	5
80	Antonio Jos├⌐ de Sucre	Municipio	5
81	Arismendi	Municipio	5
82	Barinas	Municipio	5
83	Bol├¡var	Municipio	5
84	Cruz Paredes	Municipio	5
85	Ezequiel Zamora	Municipio	5
86	Obispos	Municipio	5
87	Pedraza	Municipio	5
88	Rojas	Municipio	5
89	Sosa	Municipio	5
90	Angostura	Municipio	6
91	Caron├¡	Municipio	6
92	Cede├▒o	Municipio	6
93	El Callao	Municipio	6
94	Gran Sabana	Municipio	6
95	Heres	Municipio	6
96	Padre Pedro Chien	Municipio	6
97	Piar	Municipio	6
98	Roscio	Municipio	6
99	Sifontes	Municipio	6
100	Sucre	Municipio	6
101	Bejuma	Municipio	7
102	Carlos Arvelo	Municipio	7
103	Diego Ibarra	Municipio	7
104	Guacara	Municipio	7
105	Juan Jos├⌐ Mora	Municipio	7
106	Libertador	Municipio	7
107	Los Guayos	Municipio	7
108	Miranda	Municipio	7
109	Montalb├ín	Municipio	7
110	Naguanagua	Municipio	7
111	Puerto Cabello	Municipio	7
112	San Diego	Municipio	7
113	San Joaqu├¡n	Municipio	7
114	Valencia	Municipio	7
115	Anzo├ítegui	Municipio	8
116	Falc├│n	Municipio	8
117	Girardot	Municipio	8
118	Lima Blanco	Municipio	8
119	Pao de San Juan Bautista	Municipio	8
120	Ricaurte	Municipio	8
121	R├│mulo Gallegos	Municipio	8
122	San Carlos	Municipio	8
123	Tinaco	Municipio	8
124	Antonio D├¡az	Municipio	9
125	Casacoima	Municipio	9
126	Pedernales	Municipio	9
127	Tucupita	Municipio	9
128	Libertador	Municipio	10
129	Acosta	Municipio	11
130	Bol├¡var	Municipio	11
131	Buchivacoa	Municipio	11
132	Cacique Manaure	Municipio	11
133	Carirubana	Municipio	11
134	Colina	Municipio	11
135	Dabajuro	Municipio	11
136	Democracia	Municipio	11
137	Falc├│n	Municipio	11
138	Federaci├│n	Municipio	11
139	Jacura	Municipio	11
140	Los Taques	Municipio	11
141	Mauroa	Municipio	11
142	Miranda	Municipio	11
143	Monse├▒or Iturriza	Municipio	11
144	Palmasola	Municipio	11
145	Petit	Municipio	11
146	P├¡ritu	Municipio	11
147	San Francisco	Municipio	11
148	Silva	Municipio	11
149	Sucre	Municipio	11
150	Tocopero	Municipio	11
151	Uni├│n	Municipio	11
152	Urumaco	Municipio	11
153	Zamora	Municipio	11
154	Camagu├ín	Municipio	12
155	Chaguaramas	Municipio	12
156	El Socorro	Municipio	12
157	Francisco de Miranda	Municipio	12
158	Jos├⌐ F├⌐lix Ribas	Municipio	12
159	Jos├⌐ Tadeo Monagas	Municipio	12
160	Juan Germ├ín Roscio	Municipio	12
161	Juli├ín Mellado	Municipio	12
162	Las Mercedes	Municipio	12
163	Leonardo Infante	Municipio	12
164	Ortiz	Municipio	12
165	San Ger├│nimo de Guayabal	Municipio	12
166	San Jos├⌐ de Guaribe	Municipio	12
167	Santa Mar├¡a de Ipire	Municipio	12
168	Zaraza	Municipio	12
169	Andr├⌐s Eloy Blanco	Municipio	13
170	Crespo	Municipio	13
171	Iribarren	Municipio	13
172	Jim├⌐nez	Municipio	13
173	Mor├ín	Municipio	13
174	Palavecino	Municipio	13
175	Sim├│n Planas	Municipio	13
176	Torres	Municipio	13
177	Urdaneta	Municipio	13
178	Alberto Adriani	Municipio	14
179	Andr├⌐s Bello	Municipio	14
180	Antonio Pinto Salinas	Municipio	14
181	Aricagua	Municipio	14
182	Arzobispo Chac├│n	Municipio	14
183	Campo El├¡as	Municipio	14
184	Caracciolo Parra Olmedo	Municipio	14
185	Cardenal Quintero	Municipio	14
186	Guaraque	Municipio	14
187	Julio C├⌐sar Salas	Municipio	14
188	Justo Brice├▒o	Municipio	14
189	Libertador	Municipio	14
190	Miranda	Municipio	14
191	Obispo Ramos de Lora	Municipio	14
192	Padre Noguera	Municipio	14
193	Pueblo Llano	Municipio	14
194	Rangel	Municipio	14
195	Rivas D├ívila	Municipio	14
196	Santos Marquina	Municipio	14
197	Sucre	Municipio	14
198	Tovar	Municipio	14
199	Tulio Febres Cordero	Municipio	14
200	Zea	Municipio	14
201	Acevedo	Municipio	15
202	Andr├⌐s Bello	Municipio	15
203	Baruta	Municipio	15
204	Bri├│n	Municipio	15
205	Buroz	Municipio	15
206	Carrizal	Municipio	15
207	Chacao	Municipio	15
208	Crist├│bal Rojas	Municipio	15
209	El Hatillo	Municipio	15
210	Guaicaipuro	Municipio	15
211	Independencia	Municipio	15
212	Los Salias	Municipio	15
213	P├íez	Municipio	15
214	Paz Castillo	Municipio	15
215	Pedro Gual	Municipio	15
216	Plaza	Municipio	15
217	Sim├│n Bol├¡var	Municipio	15
218	Sucre	Municipio	15
219	Tom├ís Lander	Municipio	15
220	Urdaneta	Municipio	15
221	Zamora	Municipio	15
222	Acosta	Municipio	16
223	Aguasay	Municipio	16
224	Bol├¡var	Municipio	16
225	Caripe	Municipio	16
226	Cede├▒o	Municipio	16
227	Ezequiel Zamora	Municipio	16
228	Libertador	Municipio	16
229	Matur├¡n	Municipio	16
230	Piar	Municipio	16
231	Punceres	Municipio	16
232	Santa B├írbara	Municipio	16
233	Sotillo	Municipio	16
234	Uracoa	Municipio	16
235	Antol├¡n del Campo	Municipio	17
236	Arismendi	Municipio	17
237	D├¡az	Municipio	17
238	Garc├¡a	Municipio	17
239	G├│mez	Municipio	17
240	Macanao	Municipio	17
241	Maneiro	Municipio	17
242	Marcano	Municipio	17
243	Mari├▒o	Municipio	17
244	Pen├¡nsula de Macanao	Municipio	17
245	Tubores	Municipio	17
246	Villalba	Municipio	17
247	Agua Blanca	Municipio	18
248	Araure	Municipio	18
249	Esteller	Municipio	18
250	Guanare	Municipio	18
251	Guanarito	Municipio	18
252	Monse├▒or Jos├⌐ Vicente de Unda	Municipio	18
253	Ospino	Municipio	18
254	P├íez	Municipio	18
255	Papel├│n	Municipio	18
256	San Genaro de Bocono├¡to	Municipio	18
257	San Rafael de Onoto	Municipio	18
258	Santa Rosal├¡a	Municipio	18
259	Sucre	Municipio	18
260	Tur├⌐n	Municipio	18
261	Andr├⌐s Eloy Blanco	Municipio	19
262	Andr├⌐s Mata	Municipio	19
263	Arismendi	Municipio	19
264	Ben├¡tez	Municipio	19
265	Berm├║dez	Municipio	19
266	Bol├¡var	Municipio	19
267	Cajigal	Municipio	19
268	Cruz Salmer├│n Acosta	Municipio	19
269	Libertador	Municipio	19
270	Mari├▒o	Municipio	19
271	Mej├¡a	Municipio	19
272	Montes	Municipio	19
273	Ribero	Municipio	19
274	Sucre	Municipio	19
275	Valdez	Municipio	19
276	Andr├⌐s Bello	Municipio	20
277	Antonio R├│mulo Costa	Municipio	20
278	Ayacucho	Municipio	20
279	Bol├¡var	Municipio	20
280	C├írdenas	Municipio	20
281	C├│rdoba	Municipio	20
282	Fern├índez Feo	Municipio	20
283	Francisco de Miranda	Municipio	20
284	Garc├¡a de Hevia	Municipio	20
285	Gu├ísimos	Municipio	20
286	Independencia	Municipio	20
287	J├íuregui	Municipio	20
288	Jos├⌐ Mar├¡a Vargas	Municipio	20
289	Jun├¡n	Municipio	20
290	Libertad	Municipio	20
291	Libertador	Municipio	20
292	Lobatera	Municipio	20
293	Michelena	Municipio	20
294	Panamericano	Municipio	20
295	Pedro Mar├¡a Ure├▒a	Municipio	20
296	Rafael Urdaneta	Municipio	20
297	Samuel Dar├¡o Maldonado	Municipio	20
298	San Crist├│bal	Municipio	20
299	Seboruco	Municipio	20
300	Sim├│n Rodr├¡guez	Municipio	20
301	Sucre	Municipio	20
302	Torbes	Municipio	20
303	Uribante	Municipio	20
304	Andr├⌐s Bello	Municipio	21
305	Bocon├│	Municipio	21
306	Bol├¡var	Municipio	21
307	Candelaria	Municipio	21
308	Carache	Municipio	21
309	Escuque	Municipio	21
310	Jos├⌐ Felipe M├írquez Ca├▒izales	Municipio	21
311	Juan Vicente Campo El├¡as	Municipio	21
312	La Ceiba	Municipio	21
313	Miranda	Municipio	21
314	Monte Carmelo	Municipio	21
315	Motat├ín	Municipio	21
316	Pamp├ín	Municipio	21
317	Pampanito	Municipio	21
318	Rafael Rangel	Municipio	21
319	San Rafael de Carvajal	Municipio	21
320	Sucre	Municipio	21
321	Trujillo	Municipio	21
322	Urdaneta	Municipio	21
323	Valera	Municipio	21
324	Vargas	Municipio	22
325	Ar├¡stides Bastidas	Municipio	23
326	Bol├¡var	Municipio	23
327	Bruzual	Municipio	23
328	Cocorote	Municipio	23
329	Independencia	Municipio	23
330	Jos├⌐ Antonio P├íez	Municipio	23
331	La Trinidad	Municipio	23
332	Manuel Monge	Municipio	23
333	Nirgua	Municipio	23
334	Pe├▒a	Municipio	23
335	San Felipe	Municipio	23
336	Sucre	Municipio	23
337	Urachiche	Municipio	23
338	Veroes	Municipio	23
339	Almirante Padilla	Municipio	24
340	Baralt	Municipio	24
341	Cabimas	Municipio	24
342	Catatumbo	Municipio	24
343	Col├│n	Municipio	24
344	Francisco Javier Pulgar	Municipio	24
345	Guajira	Municipio	24
346	Jes├║s Enrique Lossada	Municipio	24
347	Jes├║s Mar├¡a Sempr├║n	Municipio	24
348	La Ca├▒ada de Urdaneta	Municipio	24
349	Lagunillas	Municipio	24
350	Machiques de Perij├í	Municipio	24
351	Mara	Municipio	24
352	Maracaibo	Municipio	24
353	Miranda	Municipio	24
354	Rosario de Perij├í	Municipio	24
355	San Francisco	Municipio	24
356	Santa Rita	Municipio	24
357	Sim├│n Bol├¡var	Municipio	24
358	Sucre	Municipio	24
359	Valmore Rodr├¡guez	Municipio	24
360	23 de Enero	Parroquia	128
361	Altagracia	Parroquia	128
362	Ant├¡mano	Parroquia	128
363	Caricuao	Parroquia	128
364	Catedral	Parroquia	128
365	Coche	Parroquia	128
366	El Junquito	Parroquia	128
367	El Para├¡so	Parroquia	128
368	El Recreo	Parroquia	128
369	El Valle	Parroquia	128
370	La Candelaria	Parroquia	128
371	La Pastora	Parroquia	128
372	La Vega	Parroquia	128
373	Macarao	Parroquia	128
374	San Agust├¡n	Parroquia	128
375	San Bernardino	Parroquia	128
376	San Jos├⌐	Parroquia	128
377	San Juan	Parroquia	128
378	San Pedro	Parroquia	128
379	Santa Rosal├¡a	Parroquia	128
380	Santa Teresa	Parroquia	128
381	Sucre (Catia)	Parroquia	128
382	La Esmeralda	Parroquia	25
383	Huachamacare	Parroquia	25
384	Marawaka	Parroquia	25
385	Mavaka	Parroquia	25
386	Sierra Parima	Parroquia	25
387	San Fernando de Atabapo	Parroquia	26
388	Ucata	Parroquia	26
389	Yapacana	Parroquia	26
390	Caname	Parroquia	26
391	Guayapo	Parroquia	26
392	Puerto Ayacucho	Parroquia	27
393	Fernando Gir├│n Tovar	Parroquia	27
394	Luis Alberto G├│mez	Parroquia	27
395	Parhue├▒a	Parroquia	27
396	Platanillal	Parroquia	27
397	Samariapo	Parroquia	27
398	Sipapo	Parroquia	27
399	Tablones	Parroquia	27
400	Coromoto	Parroquia	27
401	Isla Rat├│n	Parroquia	28
402	Sam├ín de Atabapo	Parroquia	28
403	Sipapo	Parroquia	28
404	San Juan de Manapiare	Parroquia	29
405	Alto Ventuari	Parroquia	29
406	Medio Ventuari	Parroquia	29
407	Bajo Ventuari	Parroquia	29
408	Casiquiare	Parroquia	29
409	Maroa	Parroquia	30
410	Victorino	Parroquia	30
411	Comunidad	Parroquia	30
412	San Carlos de R├¡o Negro	Parroquia	31
413	Solano	Parroquia	31
414	Casiquiare	Parroquia	31
415	Anaco	Parroquia	32
416	San Joaqu├¡n	Parroquia	32
417	San Mateo	Parroquia	32
418	Aragua de Barcelona	Parroquia	33
419	Cachipo	Parroquia	33
420	Lecher├¡a	Parroquia	34
421	El Morro	Parroquia	34
422	Puerto P├¡ritu	Parroquia	35
423	San Miguel	Parroquia	35
424	Sucre	Parroquia	35
425	Valle de Guanape	Parroquia	36
426	Uveral	Parroquia	36
427	Pariagu├ín	Parroquia	37
428	Atapirire	Parroquia	37
429	Bocas de Uchire	Parroquia	37
430	El Pao	Parroquia	37
431	San Diego de Cabrutica	Parroquia	37
432	Guanta	Parroquia	38
433	Chorrer├│n	Parroquia	38
434	Soledad	Parroquia	39
435	Mamo	Parroquia	39
436	Carapa	Parroquia	39
437	Mapire	Parroquia	40
438	Piar	Parroquia	40
439	Santa Cruz	Parroquia	40
440	San Diego de Cabrutica	Parroquia	40
441	Puerto La Cruz	Parroquia	41
442	El Morro	Parroquia	41
443	Pozuelos	Parroquia	41
444	Santa Ana	Parroquia	41
445	Onoto	Parroquia	42
446	San Pablo	Parroquia	42
447	San Mateo	Parroquia	43
448	Bergant├¡n	Parroquia	43
449	Santa Rosa	Parroquia	43
450	Clarines	Parroquia	44
451	Guanape	Parroquia	44
452	Sabana de Uchire	Parroquia	44
453	Cantaura	Parroquia	45
454	Libertador	Parroquia	45
455	Santa Rosa	Parroquia	45
456	Sucre	Parroquia	45
457	P├¡ritu	Parroquia	46
458	San Francisco	Parroquia	46
459	San Jos├⌐ de Guanipa	Parroquia	47
460	Boca de Uchire	Parroquia	48
461	Puerto P├¡ritu	Parroquia	48
462	Santa Ana	Parroquia	49
463	El Carmen	Parroquia	50
464	San Crist├│bal	Parroquia	50
465	Bergant├¡n	Parroquia	50
466	Caigua	Parroquia	50
467	Naricual	Parroquia	50
468	El Pilar	Parroquia	50
469	El Tigre	Parroquia	51
470	Guanipa	Parroquia	51
471	Edmundo Barrios	Parroquia	51
472	El Chaparro	Parroquia	52
473	Tom├ís Alfaro	Parroquia	52
474	Achaguas	Parroquia	53
475	Apurito	Parroquia	53
476	El Yagual	Parroquia	53
477	Guachara	Parroquia	53
478	Mucuritas	Parroquia	53
479	Queseras del Medio	Parroquia	53
480	Biruaca	Parroquia	54
481	San Juan de Payara	Parroquia	54
482	Bruzual	Parroquia	55
483	Mantecal	Parroquia	55
484	Quintero	Parroquia	55
485	Rinc├│n Hondo	Parroquia	55
486	San Vicente	Parroquia	55
487	Guasdualito	Parroquia	56
488	Aramare	Parroquia	56
489	Cunaviche	Parroquia	56
490	El Amparo	Parroquia	56
491	Puerto P├íez	Parroquia	56
492	San Camilo	Parroquia	56
493	Urdaneta	Parroquia	56
494	San Juan de Payara	Parroquia	57
495	Codazzi	Parroquia	57
496	Cunaviche	Parroquia	57
497	Elorza	Parroquia	57
498	Elorza	Parroquia	58
499	San Fernando	Parroquia	59
500	El Recreo	Parroquia	59
501	Pe├▒alver	Parroquia	59
502	San Rafael de Atamaica	Parroquia	59
503	Valle Hondo	Parroquia	59
504	San Mateo	Parroquia	60
505	Cagua	Parroquia	60
506	El Consejo	Parroquia	60
507	Las Tejer├¡as	Parroquia	60
508	Santa Cruz	Parroquia	60
509	Camatagua	Parroquia	61
510	Carmen de Cura	Parroquia	61
511	Santa Rita	Parroquia	62
512	Francisco de Miranda	Parroquia	62
513	Monse├▒or Feliciano Gonz├ílez	Parroquia	62
514	Maracay	Parroquia	63
515	Casta├▒o	Parroquia	63
516	Choron├¡	Parroquia	63
517	El Lim├│n	Parroquia	63
518	Las Delicias	Parroquia	63
519	Pedro Jos├⌐ Ovalles	Parroquia	63
520	San Isidro	Parroquia	63
521	Jos├⌐ Casanova Godoy	Parroquia	63
522	Los Tacarigua	Parroquia	63
523	Andr├⌐s Eloy Blanco	Parroquia	63
524	Santa Cruz	Parroquia	64
525	Ar├⌐valo Aponte	Parroquia	64
526	San Mateo	Parroquia	64
527	La Victoria	Parroquia	65
528	Castor Nieves R├¡os	Parroquia	65
529	Las Guacamayas	Parroquia	65
530	Pao de Z├írate	Parroquia	65
531	Zuata	Parroquia	65
532	El Consejo	Parroquia	66
533	Pocache	Parroquia	66
534	Tocor├│n	Parroquia	66
535	Palo Negro	Parroquia	67
536	San Mart├¡n de Porres	Parroquia	67
537	Santa Rita	Parroquia	67
538	El Libertador	Parroquia	67
539	El Lim├│n	Parroquia	68
540	Ca├▒a de Az├║car	Parroquia	68
541	Ocumare de la Costa	Parroquia	69
542	Cata	Parroquia	69
543	Independencia	Parroquia	69
544	San Casimiro	Parroquia	70
545	Guiripa	Parroquia	70
546	Ollas de Caramacate	Parroquia	70
547	Valle Mor├¡n	Parroquia	70
548	San Sebasti├ín	Parroquia	71
549	Turmero	Parroquia	72
550	Aragua	Parroquia	72
551	Alfredo Pacheco Miranda	Parroquia	72
552	Chuao	Parroquia	72
553	Sam├ín de G├╝ere	Parroquia	72
554	Las Tejer├¡as	Parroquia	73
555	Tiara	Parroquia	73
556	Cagua	Parroquia	74
557	Bella Vista	Parroquia	74
558	Colonia Tovar	Parroquia	75
559	Barbacoas	Parroquia	76
560	San Francisco de Cara	Parroquia	76
561	Taguay	Parroquia	76
562	Las Pe├▒itas	Parroquia	76
563	Villa de Cura	Parroquia	77
564	Magdaleno	Parroquia	77
565	San Francisco de As├¡s	Parroquia	77
566	Valles de Tucutunemo	Parroquia	77
567	Augusto Mijares	Parroquia	77
568	Sabaneta	Parroquia	78
569	Juan Antonio Rodr├¡guez Dom├¡nguez	Parroquia	78
570	El Cant├│n	Parroquia	79
571	Santa Cruz de Guacas	Parroquia	79
572	Puerto Vivas	Parroquia	79
573	Ticoporo	Parroquia	80
574	Nicol├ís Pulido	Parroquia	80
575	Andr├⌐s Bello	Parroquia	80
576	Arismendi	Parroquia	81
577	San Antonio	Parroquia	81
578	Gabana	Parroquia	81
579	San Rafael	Parroquia	81
580	Barinas	Parroquia	82
581	Alfredo Arvelo Larriva	Parroquia	82
582	Alto Barinas	Parroquia	82
583	Coraz├│n de Jes├║s	Parroquia	82
584	Don R├│mulo Betancourt	Parroquia	82
585	Manuel Palacio Fajardo	Parroquia	82
586	Ram├│n Ignacio M├⌐ndez	Parroquia	82
587	San Silvestre	Parroquia	82
588	Santa In├⌐s	Parroquia	82
589	Santa Luc├¡a	Parroquia	82
590	Trivino	Parroquia	82
591	El Carmen	Parroquia	82
592	Ciudad Bolivia	Parroquia	82
593	Barinitas	Parroquia	83
594	Altamira	Parroquia	83
595	Calderas	Parroquia	83
596	Barrancas	Parroquia	84
597	El Socorro	Parroquia	84
598	Mazparrito	Parroquia	84
599	Santa B├írbara	Parroquia	85
600	Pedro Brice├▒o	Parroquia	85
601	Ram├│n Ignacio M├⌐ndez	Parroquia	85
602	Arismendi	Parroquia	85
603	Obispos	Parroquia	86
604	El Real	Parroquia	86
605	La Luz	Parroquia	86
606	Los Guasimitos	Parroquia	86
607	Ciudad Bolivia	Parroquia	87
608	Andr├⌐s Bello	Parroquia	87
609	Paez	Parroquia	87
610	Jos├⌐ Ignacio del Pumar	Parroquia	87
611	Libertad	Parroquia	88
612	Dolores	Parroquia	88
613	Palacio Fajardo	Parroquia	88
614	Santa Rosa	Parroquia	88
615	Ciudad de Nutrias	Parroquia	89
616	El Regalo	Parroquia	89
617	Puerto de Nutrias	Parroquia	89
618	Santa Catalina	Parroquia	89
619	Sim├│n Bol├¡var	Parroquia	89
620	Valle de la Trinidad	Parroquia	89
621	Ciudad Bol├¡var	Parroquia	90
622	Agua Salada	Parroquia	90
623	Caicara del Orinoco	Parroquia	90
624	Jos├⌐ Antonio P├íez	Parroquia	90
625	La Sabanita	Parroquia	90
626	Maipure	Parroquia	90
627	Panapana	Parroquia	90
628	Orinoco	Parroquia	90
629	San Jos├⌐ de Tiznados	Parroquia	90
630	Vista Hermosa	Parroquia	90
631	Ciudad Guayana	Parroquia	91
632	Cachamay	Parroquia	91
633	Dalla Costa	Parroquia	91
634	Once de Abril	Parroquia	91
635	Sim├│n Bol├¡var	Parroquia	91
636	Unare	Parroquia	91
637	Universidad	Parroquia	91
638	Vista al Sol	Parroquia	91
639	Pozo Verde	Parroquia	91
640	Yocoima	Parroquia	91
641	5 de Julio	Parroquia	91
642	Caicara del Orinoco	Parroquia	92
643	Altagracia	Parroquia	92
644	Ascensi├│n de Sarare	Parroquia	92
645	Guaniamo	Parroquia	92
646	La Urbana	Parroquia	92
647	Pijiguaos	Parroquia	92
648	El Callao	Parroquia	93
649	Santa Elena de Uair├⌐n	Parroquia	94
650	Ikabar├║	Parroquia	94
651	Upata	Parroquia	97
652	Andr├⌐s Eloy Blanco	Parroquia	97
653	Pedro Cova	Parroquia	97
654	Guasipati	Parroquia	98
655	Salto Grande	Parroquia	98
656	San Jos├⌐ de Anacoco	Parroquia	98
657	Santa Cruz	Parroquia	98
658	Tumeremo	Parroquia	99
659	Dalla Costa	Parroquia	99
660	San Isidro	Parroquia	99
661	Las Claritas	Parroquia	99
662	Maripa	Parroquia	100
663	Guarataro	Parroquia	100
664	Aripao	Parroquia	100
665	Las Majadas	Parroquia	100
666	Moitaco	Parroquia	100
667	Bejuma	Parroquia	101
668	Canoabo	Parroquia	101
669	Sim├│n Bol├¡var	Parroquia	101
670	G├╝ig├╝e	Parroquia	102
671	Boquer├│n	Parroquia	102
672	Tacaburua	Parroquia	102
673	Capit├ín Aldama	Parroquia	102
674	Mariara	Parroquia	103
675	Aguas Calientes	Parroquia	103
676	Guacara	Parroquia	104
677	Ciudad Alianza	Parroquia	104
678	Yagua	Parroquia	104
679	Mor├│n	Parroquia	105
680	Urama	Parroquia	105
681	Tocuyito	Parroquia	106
682	Independencia	Parroquia	106
683	Los Guayos	Parroquia	107
684	Miranda	Parroquia	108
685	Montalb├ín	Parroquia	109
686	Naguanagua	Parroquia	110
687	Puerto Cabello	Parroquia	111
688	Democracia	Parroquia	111
689	Fraternidad	Parroquia	111
690	Goaigoaza	Parroquia	111
691	Independencia	Parroquia	111
692	Juan Jos├⌐ Flores	Parroquia	111
693	Uni├│n	Parroquia	111
694	Borburata	Parroquia	111
695	Pat├ínemo	Parroquia	111
696	San Diego	Parroquia	112
697	San Joaqu├¡n	Parroquia	113
698	Candelaria	Parroquia	114
699	Catedral	Parroquia	114
700	El Socorro	Parroquia	114
701	Miguel Pe├▒a	Parroquia	114
702	Rafael Urdaneta	Parroquia	114
703	San Blas	Parroquia	114
704	San Jos├⌐	Parroquia	114
705	Santa Rosa	Parroquia	114
706	Negro Primero	Parroquia	114
707	Cojedes	Parroquia	115
708	Juan de Mata Su├írez	Parroquia	115
709	Tinaquillo	Parroquia	116
710	El Ba├║l	Parroquia	117
711	Sucre	Parroquia	117
712	Macapo	Parroquia	118
713	La Aguadita	Parroquia	118
714	El Pao	Parroquia	119
715	Libertad	Parroquia	120
716	Manuel Manrique	Parroquia	120
717	Las Vegas	Parroquia	121
718	San Carlos de Austria	Parroquia	122
719	Juan ├üngel Bravo	Parroquia	122
720	Manuel Manrique	Parroquia	122
721	Tinaco	Parroquia	123
722	Curiapo	Parroquia	124
723	San Jos├⌐ de Tucupita	Parroquia	124
724	Canaima	Parroquia	124
725	Padre Barral	Parroquia	124
726	Manuel Renauld	Parroquia	124
727	Capure	Parroquia	124
728	Guayo	Parroquia	124
729	Ibaruma	Parroquia	124
730	Ambrosio	Parroquia	124
731	Acosta	Parroquia	124
732	Sierra Imataca	Parroquia	125
733	Cinco de Julio	Parroquia	125
734	Juan Bautista Arismendi	Parroquia	125
735	Santos de Abelgas	Parroquia	125
736	Imataca	Parroquia	125
737	Pedernales	Parroquia	126
738	Luis Beltr├ín Prieto Figueroa	Parroquia	126
739	Tucupita	Parroquia	127
740	Leonardo Ruiz Pineda	Parroquia	127
741	Mariscal Antonio Jos├⌐ de Sucre	Parroquia	127
742	San Rafael	Parroquia	127
743	Monse├▒or Argimiro Garc├¡a	Parroquia	127
744	Antonio Jos├⌐ de Sucre	Parroquia	127
745	Josefa Camejo	Parroquia	127
746	San Juan de los Cayos	Parroquia	130
747	Capadare	Parroquia	130
748	La Pastora	Parroquia	130
749	Libertador	Parroquia	130
750	San Luis	Parroquia	131
751	Aracua	Parroquia	131
752	La Vela	Parroquia	131
753	San Rafael de las Palmas	Parroquia	131
754	Capat├írida	Parroquia	132
755	Bararida	Parroquia	132
756	Goajiro	Parroquia	132
757	Boroj├│	Parroquia	132
758	Seque	Parroquia	132
759	Zaz├írida	Parroquia	132
760	Yaracal	Parroquia	133
761	Punto Fijo	Parroquia	134
762	Carirubana	Parroquia	134
763	Santa Ana	Parroquia	134
764	La Vela de Coro	Parroquia	135
765	Amuay	Parroquia	135
766	La Esmeralda	Parroquia	135
767	San Luis	Parroquia	135
768	Sabana Grande	Parroquia	135
769	Dabajuro	Parroquia	136
770	Pedregal	Parroquia	137
771	Aguas Buenas	Parroquia	137
772	El Pauj├¡	Parroquia	137
773	Purureche	Parroquia	137
774	San F├⌐lix	Parroquia	137
775	Pueblo Nuevo	Parroquia	138
776	Ad├¡cora	Parroquia	138
777	Baraived	Parroquia	138
778	Buena Vista	Parroquia	138
779	Jadacaquiva	Parroquia	138
780	Moruy	Parroquia	138
781	Paramana	Parroquia	138
782	El V├¡nculo	Parroquia	138
783	Norte	Parroquia	138
784	Churuguara	Parroquia	139
785	Agua Larga	Parroquia	139
786	El Paujicito	Parroquia	139
787	Independencia	Parroquia	139
788	Maparar├¡	Parroquia	139
789	Jacura	Parroquia	140
790	Agua Salada	Parroquia	140
791	Barrialito	Parroquia	140
792	El Charal	Parroquia	140
793	Santa Cruz de Los Taques	Parroquia	141
794	Los Taques	Parroquia	141
795	Mene de Mauroa	Parroquia	142
796	Casigua	Parroquia	142
797	San F├⌐lix	Parroquia	142
798	Santa Ana de Coro	Parroquia	143
799	Guzm├ín Guillermo	Parroquia	143
800	Mitare	Parroquia	143
801	R├¡o Seco	Parroquia	143
802	Sabana Larga	Parroquia	143
803	San Antonio	Parroquia	143
804	San Gabriel	Parroquia	143
805	Chichiriviche	Parroquia	144
806	Boca de Aroa	Parroquia	144
807	San Juan de los Cayos	Parroquia	144
808	Palmasola	Parroquia	145
809	Cabure	Parroquia	146
810	Colina	Parroquia	146
811	El Pauj├¡	Parroquia	146
812	Agua Larga	Parroquia	146
813	P├¡ritu	Parroquia	147
814	San Jos├⌐ de la Costa	Parroquia	147
815	Mirimire	Parroquia	148
816	Agua Salada	Parroquia	148
817	El Pauj├¡	Parroquia	148
818	Tucacas	Parroquia	149
819	Boca de Aroa	Parroquia	149
820	La Cruz de Taratara	Parroquia	150
821	Agua Salada	Parroquia	150
822	Piedra de Amolar	Parroquia	150
823	Tocopero	Parroquia	151
824	Santa Cruz de Bucaral	Parroquia	152
825	El Charal	Parroquia	152
826	Las Vegas	Parroquia	152
827	Urumaco	Parroquia	153
828	Puerto Cumarebo	Parroquia	154
829	La Ci├⌐naga	Parroquia	154
830	La Soledad	Parroquia	154
831	Pueblo Nuevo	Parroquia	154
832	San Rafael de La Vela	Parroquia	154
833	Camagu├ín	Parroquia	155
834	Puerto Miranda	Parroquia	155
835	Uverito	Parroquia	155
836	Chaguaramas	Parroquia	156
837	El Socorro	Parroquia	157
838	Calabozo	Parroquia	158
839	El Calvario	Parroquia	158
840	El Rastro	Parroquia	158
841	Guardatinajas	Parroquia	158
842	Saladillo	Parroquia	158
843	San Rafael de los Cajones	Parroquia	158
844	Tucupido	Parroquia	159
845	San Rafael de Orituco	Parroquia	159
846	Altagracia de Orituco	Parroquia	160
847	Lezama	Parroquia	160
848	Paso Real de Macaira	Parroquia	160
849	San Francisco Javier de Lezama	Parroquia	160
850	Santa Mar├¡a de Ipire	Parroquia	160
851	Valle de la Pascua	Parroquia	160
852	San Juan de los Morros	Parroquia	161
853	Cantagallo	Parroquia	161
854	Parapara	Parroquia	161
855	El Sombrero	Parroquia	162
856	Sosa	Parroquia	162
857	Las Mercedes	Parroquia	163
858	Cabruta	Parroquia	163
859	Santa Rita de Manapire	Parroquia	163
860	Valle de la Pascua	Parroquia	164
861	Espino	Parroquia	164
862	Ortiz	Parroquia	165
863	San Francisco de Tiznados	Parroquia	165
864	San Jos├⌐ de Tiznados	Parroquia	165
865	Guarico	Parroquia	165
866	Guayabal	Parroquia	166
867	Cazorla	Parroquia	166
868	San Jos├⌐ de Guaribe	Parroquia	167
869	Santa Mar├¡a de Ipire	Parroquia	168
870	Altamira	Parroquia	168
871	Zaraza	Parroquia	169
872	San Jos├⌐ de Unare	Parroquia	169
873	Sanare	Parroquia	170
874	P├¡o Tamayo	Parroquia	170
875	Yacamb├║	Parroquia	170
876	Duaca	Parroquia	171
877	Farriar	Parroquia	171
878	Barquisimeto	Parroquia	172
879	Aguedo Felipe Alvarado	Parroquia	172
880	Anselmo Belloso	Parroquia	172
881	Buena Vista	Parroquia	172
882	Catedral	Parroquia	172
883	Concepci├│n	Parroquia	172
884	El Cuj├¡	Parroquia	172
885	Juan de Villegas	Parroquia	172
886	Santa Rosa	Parroquia	172
887	Tamaca	Parroquia	172
888	Uni├│n	Parroquia	172
889	Guerrera Ana Soto	Parroquia	172
890	Qu├¡bor	Parroquia	173
891	Coronel Mariano Peraza	Parroquia	173
892	Diego de Lozada	Parroquia	173
893	Jos├⌐ Bernardo Dorantes	Parroquia	173
894	Juan Bautista Rodr├¡guez	Parroquia	173
895	Para├¡so de San Jos├⌐	Parroquia	173
896	Tintorero	Parroquia	173
897	Cuara	Parroquia	173
898	El Tocuyo	Parroquia	174
899	Anzo├ítegui	Parroquia	174
900	Gu├írico	Parroquia	174
901	Hilario Luna y Luna	Parroquia	174
902	Humocaro Alto	Parroquia	174
903	Humocaro Bajo	Parroquia	174
904	La Candelaria	Parroquia	174
905	Mor├ín	Parroquia	174
906	Cabudare	Parroquia	175
907	Jos├⌐ Gregorio Bastidas	Parroquia	175
908	Agua Viva	Parroquia	175
909	Sarare	Parroquia	176
910	Gustavo Vegas Le├│n	Parroquia	176
911	Manzanita	Parroquia	176
912	Carora	Parroquia	177
913	Altagracia	Parroquia	177
914	Antonio D├¡az	Parroquia	177
915	Camacaro	Parroquia	177
916	Casta├▒eda	Parroquia	177
917	Cecilio Zubillaga	Parroquia	177
918	Chiquinquir├í	Parroquia	177
919	El Blanco	Parroquia	177
920	Espinoza de los Monteros	Parroquia	177
921	Manuel Morillo	Parroquia	177
922	Monta├▒a	Parroquia	177
923	Padre Pedro Mar├¡a Aguilar	Parroquia	177
924	Torres	Parroquia	177
925	Las Mercedes	Parroquia	177
926	Para├¡so de San Jos├⌐	Parroquia	177
927	Siquisique	Parroquia	178
928	Moroturo	Parroquia	178
929	San Miguel	Parroquia	178
930	Xaguas	Parroquia	178
931	El Vig├¡a	Parroquia	179
932	Presidente P├íez	Parroquia	179
933	H├⌐ctor Amable Mora	Parroquia	179
934	Gabriel Pic├│n Gonz├ílez	Parroquia	179
935	Jos├⌐ Nucete Sardi	Parroquia	179
936	Pulido M├⌐ndez	Parroquia	179
937	La Azulita	Parroquia	180
938	Santa Cruz de Mora	Parroquia	181
939	Mesa Bol├¡var	Parroquia	181
940	Mesa de Las Palmas	Parroquia	181
941	Aricagua	Parroquia	182
942	San Antonio	Parroquia	182
943	Canagu├í	Parroquia	183
944	Capur├¡	Parroquia	183
945	Chacant├í	Parroquia	183
946	El Molino	Parroquia	183
947	Guaimaral	Parroquia	183
948	Mucutuy	Parroquia	183
949	Mucuchach├¡	Parroquia	183
950	Ejido	Parroquia	184
951	Fern├índez Pe├▒a	Parroquia	184
952	Montalb├ín	Parroquia	184
953	San Jos├⌐ del Sur	Parroquia	184
954	Tucan├¡	Parroquia	185
955	Florencio Ram├¡rez	Parroquia	185
956	San Rafael de Alc├ízar	Parroquia	185
957	Santa Elena de Arenales	Parroquia	185
958	Santo Domingo	Parroquia	186
959	Las Piedras	Parroquia	186
960	Guaraque	Parroquia	187
961	Mesa de Quintero	Parroquia	187
962	R├¡o Negro	Parroquia	187
963	Arapuey	Parroquia	188
964	Palmira	Parroquia	188
965	Torondoy	Parroquia	189
966	Las Playitas	Parroquia	189
967	Antonio Spinetti Dini	Parroquia	190
968	Arias	Parroquia	190
969	Caracciolo Parra P├⌐rez	Parroquia	190
970	Domingo Pe├▒a	Parroquia	190
971	El Llano	Parroquia	190
972	Gonzalo Pic├│n Febres	Parroquia	190
973	Juan Rodr├¡guez Su├írez	Parroquia	190
974	Lagunillas	Parroquia	190
975	Mariano Pic├│n Salas	Parroquia	190
976	Milla	Parroquia	190
977	Osuna Rodr├¡guez	Parroquia	190
978	Presidente Betancourt	Parroquia	190
979	R├│mulo Gallegos	Parroquia	190
980	Sagrario	Parroquia	190
981	San Juan Bautista	Parroquia	190
982	Santa Catalina	Parroquia	190
983	Santa Luc├¡a	Parroquia	190
984	Santa Rosa	Parroquia	190
985	Spinetti Dini	Parroquia	190
986	El Morro	Parroquia	190
987	Los Nevados	Parroquia	190
988	Timotes	Parroquia	191
989	Andr├⌐s Eloy Blanco	Parroquia	191
990	La Venta	Parroquia	191
991	Santiago de la Punta	Parroquia	191
992	Santa Elena de Arenales	Parroquia	192
993	Eloy Paredes	Parroquia	192
994	San Rafael de Alc├ízar	Parroquia	192
995	Santa Mar├¡a de Caparo	Parroquia	193
996	Pueblo Llano	Parroquia	194
997	Mucuch├¡es	Parroquia	195
998	Cacute	Parroquia	195
999	Gavidia	Parroquia	195
1000	La Toma	Parroquia	195
1001	Mucurub├í	Parroquia	195
1002	Bailadores	Parroquia	196
1003	Ger├│nimo Maldonado	Parroquia	196
1004	Tabay	Parroquia	197
1005	Lagunillas	Parroquia	198
1006	Chiguar├í	Parroquia	198
1007	Est├ínques	Parroquia	198
1008	Pueblo Nuevo del Sur	Parroquia	198
1009	San Juan	Parroquia	198
1010	Tovar	Parroquia	199
1011	El Amparo	Parroquia	199
1012	San Francisco	Parroquia	199
1013	Zea	Parroquia	199
1014	Nueva Bolivia	Parroquia	200
1015	Independencia	Parroquia	200
1016	Santa Apolonia	Parroquia	200
1017	Chaparral	Parroquia	200
1018	Zea	Parroquia	201
1019	Ca├▒o El Tigre	Parroquia	201
1020	Caucagua	Parroquia	202
1021	Arag├╝ita	Parroquia	202
1022	Capaya	Parroquia	202
1023	Marizapa	Parroquia	202
1024	Panaquire	Parroquia	202
1025	Tapipa	Parroquia	202
1026	Ribas	Parroquia	202
1027	San Jos├⌐ de Barlovento	Parroquia	203
1028	Cumbo	Parroquia	203
1029	Nuestra Se├▒ora del Rosario	Parroquia	204
1030	El Cafetal	Parroquia	204
1031	Las Minas	Parroquia	204
1032	Higuerote	Parroquia	205
1033	Curiepe	Parroquia	205
1034	Tacarigua de Mamporal	Parroquia	205
1035	Mamporal	Parroquia	206
1036	Carrizal	Parroquia	207
1037	Chacao	Parroquia	208
1038	Charallave	Parroquia	209
1039	Las Brisas	Parroquia	209
1040	El Hatillo	Parroquia	210
1041	Los Teques	Parroquia	211
1042	Paracotos	Parroquia	211
1043	San Antonio de los Altos	Parroquia	211
1044	San Jos├⌐ de los Altos	Parroquia	211
1045	San Pedro	Parroquia	211
1046	Altagracia de la Monta├▒a	Parroquia	211
1047	Cecilio Acosta	Parroquia	211
1048	Tacoa	Parroquia	211
1049	Santa Teresa del Tuy	Parroquia	212
1050	El Cartanal	Parroquia	212
1051	San Antonio de los Altos	Parroquia	213
1052	R├¡o Chico	Parroquia	214
1053	El Cafeto	Parroquia	214
1054	San Fernando	Parroquia	214
1055	Tacarigua de la Laguna	Parroquia	214
1056	Paparo	Parroquia	214
1057	Santa Luc├¡a	Parroquia	215
1058	C├║pira	Parroquia	216
1059	Machurucuto	Parroquia	216
1060	Guarenas	Parroquia	217
1061	San Francisco de Yare	Parroquia	218
1062	San Antonio de Yare	Parroquia	218
1063	Sim├│n Bol├¡var	Parroquia	218
1064	Petare	Parroquia	219
1065	Caucag├╝ita	Parroquia	219
1066	Fila de Mariches	Parroquia	219
1067	La Dolorita	Parroquia	219
1068	Leoncio Mart├¡nez	Parroquia	219
1069	Ocumare del Tuy	Parroquia	220
1070	La Democracia	Parroquia	220
1071	Santa B├írbara	Parroquia	220
1072	San Francisco de Yare	Parroquia	220
1073	Valle de la Pascua	Parroquia	220
1074	C├║a	Parroquia	221
1075	Nueva C├║a	Parroquia	221
1076	Guatire	Parroquia	222
1077	Araira	Parroquia	222
1078	Bol├¡var	Parroquia	222
1079	San Antonio de Capayacuar	Parroquia	223
1080	San Francisco	Parroquia	223
1081	Aguasay	Parroquia	224
1082	Caripito	Parroquia	225
1083	Sabana Grande	Parroquia	225
1084	Caripe	Parroquia	226
1085	El Gu├ícharo	Parroquia	226
1086	La Guanota	Parroquia	226
1087	San Agust├¡n	Parroquia	226
1088	Teres├⌐n	Parroquia	226
1089	Caicara de Matur├¡n	Parroquia	227
1090	Areo	Parroquia	227
1091	San F├⌐lix	Parroquia	227
1092	Punta de Mata	Parroquia	228
1093	El Tejero	Parroquia	228
1094	Temblador	Parroquia	229
1095	Chaguaramas	Parroquia	229
1096	Las Alhuacas	Parroquia	229
1097	Matur├¡n	Parroquia	230
1098	Alto de Los Godos	Parroquia	230
1099	Boquer├│n	Parroquia	230
1100	Las Cocuizas	Parroquia	230
1101	La Pica	Parroquia	230
1102	San Sim├│n	Parroquia	230
1103	El Corozo	Parroquia	230
1104	El Furrial	Parroquia	230
1105	Jusep├¡n	Parroquia	230
1106	La Cruz	Parroquia	230
1107	San Vicente	Parroquia	230
1108	Aragua de Matur├¡n	Parroquia	231
1109	Aparicio	Parroquia	231
1110	Chaguaramal	Parroquia	231
1111	El Pinto	Parroquia	231
1112	Guaripete	Parroquia	231
1113	La Cruz de la Paloma	Parroquia	231
1114	Taguaya	Parroquia	231
1115	El Zamuro	Parroquia	231
1116	Quiriquire	Parroquia	232
1117	Punceres	Parroquia	232
1118	Santa B├írbara	Parroquia	233
1119	Tabasca	Parroquia	233
1120	Barrancas del Orinoco	Parroquia	234
1121	Chaguaramos	Parroquia	234
1122	Uracoa	Parroquia	235
1123	Paraguach├¡	Parroquia	236
1124	La Rinconada	Parroquia	236
1125	La Asunci├│n	Parroquia	237
1126	San Juan Bautista	Parroquia	238
1127	Concepci├│n	Parroquia	238
1128	El Valle del Esp├¡ritu Santo	Parroquia	239
1129	San Antonio	Parroquia	239
1130	Santa Ana	Parroquia	240
1131	Altagracia	Parroquia	240
1132	Coch├⌐	Parroquia	240
1133	Manzanillo	Parroquia	240
1134	Vicente Fuentes	Parroquia	240
1135	Boca del R├¡o	Parroquia	241
1136	San Francisco	Parroquia	241
1137	Pampatar	Parroquia	242
1138	Jorge Coll	Parroquia	242
1139	Aguas de Moya	Parroquia	242
1140	Juan Griego	Parroquia	243
1141	Adri├ín	Parroquia	243
1142	Francisco Fajardo	Parroquia	243
1143	Porlamar	Parroquia	244
1144	Los Robles	Parroquia	244
1145	Cristo de Aranza	Parroquia	244
1146	Bella Vista	Parroquia	244
1147	Mari├▒o	Parroquia	244
1148	Villa Rosa	Parroquia	244
1149	Boca de Pozo	Parroquia	245
1150	San Francisco	Parroquia	245
1151	Punta de Piedras	Parroquia	246
1152	Los Tubores	Parroquia	246
1153	San Pedro de Coche	Parroquia	247
1154	El Bichar	Parroquia	247
1155	San Agust├¡n	Parroquia	247
1156	Agua Blanca	Parroquia	248
1157	Araure	Parroquia	249
1158	R├¡o Acarigua	Parroquia	249
1159	P├¡ritu	Parroquia	250
1160	Uveral	Parroquia	250
1161	Guanare	Parroquia	251
1162	C├│rdoba	Parroquia	251
1163	Espino	Parroquia	251
1164	Mesa de Cavacas	Parroquia	251
1165	San Juan de Guanaguanare	Parroquia	251
1166	Virgen de Coromoto	Parroquia	251
1167	Guanarito	Parroquia	252
1168	Capital Guanarito	Parroquia	252
1169	Trinidad de la Capilla	Parroquia	252
1170	Uveral	Parroquia	252
1171	Chabasqu├⌐n	Parroquia	253
1172	Pe├▒a Blanca	Parroquia	253
1173	Ospino	Parroquia	254
1174	La Aparici├│n	Parroquia	254
1175	San Rafael de Palo Alzado	Parroquia	254
1176	Acarigua	Parroquia	255
1177	Payara	Parroquia	255
1178	Pimpinela	Parroquia	255
1179	Ram├│n Peraza	Parroquia	255
1180	Papel├│n	Parroquia	256
1181	Ca├▒o Delgadito	Parroquia	256
1182	San Genaro de Bocono├¡to	Parroquia	257
1183	Antol├¡n Tovar	Parroquia	257
1184	Para├¡so de San Genaro	Parroquia	257
1185	San Rafael de Onoto	Parroquia	258
1186	Santa F├⌐	Parroquia	258
1187	San Roque	Parroquia	258
1188	El Play├│n	Parroquia	259
1189	Canelones	Parroquia	259
1190	Biscucuy	Parroquia	260
1191	San Jos├⌐ de Saguaz	Parroquia	260
1192	San Rafael de Palo Alzado	Parroquia	260
1193	Uvencio Antonio Vel├ísquez	Parroquia	260
1194	Villa de la Paz	Parroquia	260
1195	Villa Bruzual	Parroquia	261
1196	Canelones	Parroquia	261
1197	Santa Cruz	Parroquia	261
1198	San Isidro Labrador	Parroquia	261
1199	Casanay	Parroquia	262
1200	Mari├▒o	Parroquia	262
1201	R├¡o Caribe	Parroquia	262
1202	San Juan de Unare	Parroquia	262
1203	San Jos├⌐ de Aerocuar	Parroquia	263
1204	Tunapuy	Parroquia	263
1205	R├¡o Caribe	Parroquia	264
1206	Antonio Jos├⌐ de Sucre	Parroquia	264
1207	El Morro de Puerto Santo	Parroquia	264
1208	Punta de Piedras	Parroquia	264
1209	R├¡o de Agua	Parroquia	264
1210	El Pilar	Parroquia	265
1211	El Rinc├│n	Parroquia	265
1212	Guara├║nos	Parroquia	265
1213	Tunapuicito	Parroquia	265
1214	Uni├│n	Parroquia	265
1215	Car├║pano	Parroquia	266
1216	Macarapana	Parroquia	266
1217	Santa Catalina	Parroquia	266
1218	Santa In├⌐s	Parroquia	266
1219	Santa Rosa	Parroquia	266
1220	Marig├╝itar	Parroquia	267
1221	San Antonio del Golfo	Parroquia	267
1222	Yaguaraparo	Parroquia	268
1223	El Paujil	Parroquia	268
1224	Libertad	Parroquia	268
1225	San Fernando	Parroquia	268
1226	Santa B├írbara	Parroquia	268
1227	Araya	Parroquia	269
1228	Chacopata	Parroquia	269
1229	Manicuare	Parroquia	269
1230	San Juan de las Galdonas	Parroquia	270
1231	El Pilar	Parroquia	270
1232	San Juan	Parroquia	270
1233	San Vicente	Parroquia	270
1234	Irapa	Parroquia	271
1235	Campo El├¡as	Parroquia	271
1236	Marig├╝itar	Parroquia	271
1237	San Antonio de Irapa	Parroquia	271
1238	Soro	Parroquia	271
1239	San Antonio del Golfo	Parroquia	272
1240	Cumanacoa	Parroquia	273
1241	Arenas	Parroquia	273
1242	Aricagua	Parroquia	273
1243	Cocollar	Parroquia	273
1244	San Fernando	Parroquia	273
1245	San Lorenzo	Parroquia	273
1246	Cariaco	Parroquia	274
1247	Catuaro	Parroquia	274
1248	R├¡o Casanay	Parroquia	274
1249	San Agust├¡n	Parroquia	274
1250	Santa Mar├¡a	Parroquia	274
1251	Ayacucho	Parroquia	275
1252	Blanco	Parroquia	275
1253	Cuman├í	Parroquia	275
1254	Valent├¡n Valiente	Parroquia	275
1255	Altagracia	Parroquia	275
1256	Santa In├⌐s	Parroquia	275
1257	San Juan	Parroquia	275
1258	Ra├║l Leoni	Parroquia	275
1259	G├╝iria	Parroquia	276
1260	Bideau	Parroquia	276
1261	Crist├│bal Col├│n	Parroquia	276
1262	Punta de Piedras	Parroquia	276
1263	Puerto Hierro	Parroquia	276
1264	Cordero	Parroquia	277
1265	Las Mesas	Parroquia	278
1266	Col├│n	Parroquia	279
1267	San Pedro del R├¡o	Parroquia	279
1268	San Juan de Col├│n	Parroquia	279
1269	San Antonio del T├íchira	Parroquia	280
1270	Juan Vicente G├│mez	Parroquia	280
1271	Palotal	Parroquia	280
1272	Padre Marcos Figueroa	Parroquia	280
1273	T├íriba	Parroquia	281
1274	Jauregui	Parroquia	281
1275	La Florida	Parroquia	281
1276	Santa Ana	Parroquia	282
1277	San Rafael de Cordero	Parroquia	282
1278	San Rafael del Pi├▒al	Parroquia	283
1279	Santo Domingo	Parroquia	283
1280	Juan Pablo Pe├▒aloza	Parroquia	283
1281	San Jos├⌐ de Bol├¡var	Parroquia	284
1282	La Fr├¡a	Parroquia	285
1283	Panamericano	Parroquia	285
1284	Col├│n	Parroquia	285
1285	Palmira	Parroquia	286
1286	San Juan del Recreo	Parroquia	286
1287	Capacho Nuevo	Parroquia	287
1288	Juan Vicente Bol├¡var	Parroquia	287
1289	Chipare	Parroquia	287
1290	La Grita	Parroquia	288
1291	Emilio Constantino Guerrero	Parroquia	288
1292	Monse├▒or Alejandro Fern├índez Feo	Parroquia	288
1293	El Cobre	Parroquia	289
1294	Rubio	Parroquia	290
1295	Bram├│n	Parroquia	290
1296	Delicias	Parroquia	290
1297	La Petr├│lea	Parroquia	290
1298	Capacho Viejo	Parroquia	291
1299	Cipriano Castro	Parroquia	291
1300	Manuel Felipe Rugeles	Parroquia	291
1301	Abejales	Parroquia	292
1302	Doradas	Parroquia	292
1303	Emilio Constantino Guerrero	Parroquia	292
1304	San Joaqu├¡n de Navay	Parroquia	292
1305	Lobatera	Parroquia	293
1306	Constituci├│n	Parroquia	293
1307	Michelena	Parroquia	294
1308	Col├│n	Parroquia	295
1309	La Palmita	Parroquia	295
1310	San Joaqu├¡n	Parroquia	295
1311	Ure├▒a	Parroquia	296
1312	Pedro Mar├¡a Ure├▒a	Parroquia	296
1313	Tienditas	Parroquia	296
1314	Delicias	Parroquia	297
1315	Monse├▒or Miguel Ignacio Brice├▒o	Parroquia	297
1316	La Tendida	Parroquia	298
1317	Bocon├│	Parroquia	298
1318	Bocon├│ Abajo	Parroquia	298
1319	Hern├índez	Parroquia	298
1320	San Crist├│bal	Parroquia	299
1321	Francisco Romero Lobo	Parroquia	299
1322	La Concordia	Parroquia	299
1323	Pedro Mar├¡a Morantes	Parroquia	299
1324	San Juan Bautista	Parroquia	299
1325	San Sebasti├ín	Parroquia	299
1326	Seboruco	Parroquia	300
1327	San Sim├│n	Parroquia	301
1328	Col├│n	Parroquia	302
1329	La Palmita	Parroquia	302
1330	San Jos├⌐	Parroquia	302
1331	San Pablo	Parroquia	302
1332	San Josecito	Parroquia	303
1333	Pregonero	Parroquia	304
1334	C├írdenas	Parroquia	304
1335	Juan Pablo Pe├▒aloza	Parroquia	304
1336	Potos├¡	Parroquia	304
1337	Santa Isabel	Parroquia	305
1338	Araguaney	Parroquia	305
1339	El Jaguito	Parroquia	305
1340	Bocon├│	Parroquia	306
1341	El Carmen	Parroquia	306
1342	Mosquey	Parroquia	306
1343	Ayacucho	Parroquia	306
1344	Burbusay	Parroquia	306
1345	General Ribas	Parroquia	306
1346	Guaramacal	Parroquia	306
1347	La Vega de Guaramacal	Parroquia	306
1348	San Miguel	Parroquia	306
1349	San Rafael	Parroquia	306
1350	Monse├▒or Carrillo	Parroquia	306
1351	Sabana Grande	Parroquia	307
1352	Granados	Parroquia	307
1353	Chereg├╝├⌐	Parroquia	307
1354	Chejend├⌐	Parroquia	308
1355	Arnoldo Gabald├│n	Parroquia	308
1356	Carrillo	Parroquia	308
1357	Candelaria	Parroquia	308
1358	La Mesa de Esnujaque	Parroquia	308
1359	San Jos├⌐ de la Haticos	Parroquia	308
1360	Santa Elena	Parroquia	308
1361	Carache	Parroquia	309
1362	La Concepci├│n	Parroquia	309
1363	Cuicas	Parroquia	309
1364	Panamericana	Parroquia	309
1365	Santa Cruz	Parroquia	309
1366	Escuque	Parroquia	310
1367	La Uni├│n	Parroquia	310
1368	Sabana Libre	Parroquia	310
1369	Santa Rita	Parroquia	310
1370	El Socorro	Parroquia	311
1371	Los Caprichos	Parroquia	311
1372	Campo El├¡as	Parroquia	312
1373	Arnoldo Gabald├│n	Parroquia	312
1374	Santa Apolonia	Parroquia	313
1375	El Progreso	Parroquia	313
1376	La Ceiba	Parroquia	313
1377	Tres de Febrero	Parroquia	313
1378	El Dividive	Parroquia	314
1379	Agua Santa	Parroquia	314
1380	Agua Caliente	Parroquia	314
1381	Flor de Patria	Parroquia	314
1382	La Paz	Parroquia	314
1383	Monte Carmelo	Parroquia	315
1384	Buena Vista	Parroquia	315
1385	Santa Cruz	Parroquia	315
1386	Motat├ín	Parroquia	316
1387	Jalisco	Parroquia	316
1388	El Ba├▒o	Parroquia	316
1389	Pamp├ín	Parroquia	317
1390	Flor de Patria	Parroquia	317
1391	La Paz	Parroquia	317
1392	Santa Ana	Parroquia	317
1393	Pampanito	Parroquia	318
1394	La Concepci├│n	Parroquia	318
1395	Santa Rosa	Parroquia	318
1396	Betijoque	Parroquia	319
1397	Jos├⌐ Gregorio Hern├índez	Parroquia	319
1398	La Pueblita	Parroquia	319
1399	Los Cedros	Parroquia	319
1400	Carvajal	Parroquia	320
1401	Campo Alegre	Parroquia	320
1402	Antonio Nicol├ís Brice├▒o	Parroquia	320
1403	Jos├⌐ Leonardo Su├írez	Parroquia	320
1404	Sabana de Mendoza	Parroquia	321
1405	Jun├¡n	Parroquia	321
1406	La Esperanza	Parroquia	321
1407	Valmore Rodr├¡guez	Parroquia	321
1408	Trujillo	Parroquia	322
1409	Andr├⌐s Linares	Parroquia	322
1410	Chiquinquir├í	Parroquia	322
1411	Cruz Carrillo	Parroquia	322
1412	Matriz	Parroquia	322
1413	Tres Esquinas	Parroquia	322
1414	San Lorenzo	Parroquia	322
1415	La Quebrada	Parroquia	323
1416	Cabimb├║	Parroquia	323
1417	Jaj├│	Parroquia	323
1418	La Mesa de Esnujaque	Parroquia	323
1419	Santiago	Parroquia	323
1420	Tu├▒ame	Parroquia	323
1421	La Venta	Parroquia	323
1422	Valera	Parroquia	324
1423	La Beatriz	Parroquia	324
1424	La Puerta	Parroquia	324
1425	Mendoza	Parroquia	324
1426	San Luis	Parroquia	324
1427	Carvajal	Parroquia	324
1428	Caraballeda	Parroquia	325
1429	Carayaca	Parroquia	325
1430	Carlos Soublette	Parroquia	325
1431	Caruao	Parroquia	325
1432	Catia La Mar	Parroquia	325
1433	El Junko	Parroquia	325
1434	La Guaira	Parroquia	325
1435	Macuto	Parroquia	325
1436	Maiquet├¡a	Parroquia	325
1437	Naiguat├í	Parroquia	325
1438	Urimare	Parroquia	325
1439	San Pablo	Parroquia	326
1440	Aroa	Parroquia	327
1441	Chivacoa	Parroquia	328
1442	Campo El├¡as	Parroquia	328
1443	Cocorote	Parroquia	329
1444	Independencia	Parroquia	330
1445	Cambural	Parroquia	330
1446	Sabana de Parra	Parroquia	331
1447	La Trinidad	Parroquia	332
1448	Yumare	Parroquia	333
1449	Nirgua	Parroquia	334
1450	Salom	Parroquia	334
1451	Temerla	Parroquia	334
1452	Yaritagua	Parroquia	335
1453	San Andr├⌐s	Parroquia	335
1454	San Felipe	Parroquia	336
1455	Albarico	Parroquia	336
1456	San Javier	Parroquia	336
1457	Mar├¡n	Parroquia	336
1458	Guama	Parroquia	337
1459	Urachiche	Parroquia	338
1460	Farriar	Parroquia	339
1461	El Guayabo	Parroquia	339
1462	Isla de Toas	Parroquia	340
1463	Monagas	Parroquia	340
1464	San Timoteo	Parroquia	341
1465	General Urdaneta	Parroquia	341
1466	Manuel Manrique	Parroquia	341
1467	Rafael Mar├¡a Baralt	Parroquia	341
1468	San Timoteo	Parroquia	341
1469	Tom├ís Oropeza	Parroquia	341
1470	Ambrosio	Parroquia	342
1471	Carmen Herrera	Parroquia	342
1472	La Rosa	Parroquia	342
1473	Jorge Hern├índez	Parroquia	342
1474	Punta Gorda	Parroquia	342
1475	R├│mulo Betancourt	Parroquia	342
1476	San Benito	Parroquia	342
1477	Aristides Calvani	Parroquia	342
1478	Germ├ín R├¡os Linares	Parroquia	342
1479	Manuel Manrique	Parroquia	342
1480	Encontrados	Parroquia	343
1481	Ud├│n P├⌐rez	Parroquia	343
1482	San Carlos del Zulia	Parroquia	344
1483	Santa Cruz del Zulia	Parroquia	344
1484	Santa B├írbara	Parroquia	344
1485	Moralito	Parroquia	344
1486	Carlos Quevedo	Parroquia	344
1487	Pueblo Nuevo	Parroquia	345
1488	Sim├│n Rodr├¡guez	Parroquia	345
1489	Sinamaica	Parroquia	346
1490	Alta Guajira	Parroquia	346
1491	El├¡as S├ínchez Rubio	Parroquia	346
1492	Luis de Vicente	Parroquia	346
1493	San Rafael de Moj├ín	Parroquia	346
1494	Las Parcelas	Parroquia	346
1495	Guajira	Parroquia	346
1496	La Concepci├│n	Parroquia	347
1497	San Jos├⌐	Parroquia	347
1498	Mariano Escobedo	Parroquia	347
1499	Casigua El Cubo	Parroquia	348
1500	Bar├¡	Parroquia	348
1501	Concepci├│n	Parroquia	349
1502	Andr├⌐s Bello	Parroquia	349
1503	Chiquinquir├í	Parroquia	349
1504	El Carmelo	Parroquia	349
1505	Potreritos	Parroquia	349
1506	Ciudad Ojeda	Parroquia	350
1507	Alonso de Ojeda	Parroquia	350
1508	Campo Lara	Parroquia	350
1509	La Victoria	Parroquia	350
1510	Libertad	Parroquia	350
1511	Venezuela	Parroquia	350
1512	Eleazar L├│pez Contreras	Parroquia	350
1513	Machiques	Parroquia	351
1514	Bartolom├⌐ de las Casas	Parroquia	351
1515	Libertad	Parroquia	351
1516	R├¡o Negro	Parroquia	351
1517	San Jos├⌐ de Perij├í	Parroquia	351
1518	San Rafael de Moj├ín	Parroquia	352
1519	La Sierrita	Parroquia	352
1520	Las Parcelas	Parroquia	352
1521	Luis de Vicente	Parroquia	352
1522	Monse├▒or Marcos Sergio Godoy	Parroquia	352
1523	Ricaurte	Parroquia	352
1524	Tamare	Parroquia	352
1525	Antonio Borjas Romero	Parroquia	353
1526	Cacique Mara	Parroquia	353
1527	Caracciolo Parra P├⌐rez	Parroquia	353
1528	Chiquinquir├í	Parroquia	353
1529	Coquivacoa	Parroquia	353
1530	Francisco Eugenio Bustamante	Parroquia	353
1531	Idelfonso V├ísquez	Parroquia	353
1532	Juana de ├üvila	Parroquia	353
1533	Luis Hurtado Higuera	Parroquia	353
1534	Manuel Dagnino	Parroquia	353
1535	Olegario Villalobos	Parroquia	353
1536	Ra├║l Leoni	Parroquia	353
1537	Santa Luc├¡a	Parroquia	353
1538	Venancio Pulgar	Parroquia	353
1539	San Isidro	Parroquia	353
1540	Cristo de Aranza	Parroquia	353
1541	Los Puertos de Altagracia	Parroquia	354
1542	Ana Mar├¡a Campos	Parroquia	354
1543	Farra	Parroquia	354
1544	San Antonio	Parroquia	354
1545	San Jos├⌐	Parroquia	354
1546	El Mene	Parroquia	354
1547	Altagracia	Parroquia	354
1548	La Villa del Rosario	Parroquia	355
1549	El Rosario	Parroquia	355
1550	Sixto Zambrano	Parroquia	355
1551	San Francisco	Parroquia	356
1552	El Bajo	Parroquia	356
1553	Domitila Flores	Parroquia	356
1554	Francisco Ochoa	Parroquia	356
1555	Los Cortijos	Parroquia	356
1556	Marcial Hern├índez	Parroquia	356
1557	Santa Rita	Parroquia	357
1558	El Mene	Parroquia	357
1559	Pedro Lucas Urribarr├¡	Parroquia	357
1560	Jos├⌐ Cenobio Urribarr├¡	Parroquia	357
1561	T├¡a Juana	Parroquia	358
1562	Manuel Manrique	Parroquia	358
1563	San Isidro	Parroquia	358
1564	Bobures	Parroquia	359
1565	Gibraltar	Parroquia	359
1566	H├⌐ctor Manuel Brice├▒o	Parroquia	359
1567	Heriberto Arroyo	Parroquia	359
1568	La Gran Parroquia	Parroquia	359
1569	Monse├▒or Arturo Celestino ├ülvarez	Parroquia	359
1570	R├│mulo Gallegos	Parroquia	359
1571	Bachaquero	Parroquia	360
1572	Eleazar L├│pez Contreras	Parroquia	360
1573	La Victoria	Parroquia	360
\.


--
-- Data for Name: membresia; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.membresia (id_membresia, fecha_inicio, fecha_fin, id_proveedor) FROM stdin;
1	2024-01-15	\N	1
2	2024-03-20	\N	2
3	2024-06-10	\N	3
4	2024-09-05	\N	4
5	2024-11-12	\N	5
6	2023-01-10	2024-01-10	6
7	2023-05-15	2024-05-15	7
8	2023-08-20	2024-08-20	8
9	2024-02-01	2025-02-01	9
10	2024-04-15	2025-04-15	10
\.


--
-- Data for Name: metodo_pago; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.metodo_pago (id_metodo, id_cliente_natural, id_cliente_juridico) FROM stdin;
1	\N	\N
2	\N	\N
3	\N	\N
4	\N	\N
5	\N	\N
6	\N	\N
7	\N	\N
8	\N	\N
9	\N	\N
10	\N	\N
11	\N	\N
12	\N	\N
13	\N	\N
14	\N	\N
15	\N	\N
16	\N	\N
17	\N	\N
18	\N	\N
19	\N	\N
20	\N	\N
21	\N	\N
22	\N	\N
23	\N	\N
24	\N	\N
25	\N	\N
26	\N	\N
27	\N	\N
28	\N	\N
29	\N	\N
30	\N	\N
31	\N	\N
32	\N	\N
33	\N	\N
34	\N	\N
35	\N	\N
36	\N	\N
37	\N	\N
38	\N	\N
39	\N	\N
40	\N	\N
41	\N	\N
42	\N	\N
43	\N	\N
44	\N	\N
45	\N	\N
46	\N	\N
47	\N	\N
48	\N	\N
49	\N	\N
50	\N	\N
1000	1	\N
1001	21	\N
1002	21	\N
1003	\N	19
1004	21	\N
1005	21	\N
\.


--
-- Data for Name: orden_reposicion; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.orden_reposicion (id_orden_reposicion, id_departamento, id_proveedor, fecha_emision, id_empleado, fecha_fin) FROM stdin;
1	3	1	2025-07-06	\N	\N
2	3	2	2025-07-06	\N	\N
3	3	3	2025-07-06	\N	\N
4	3	4	2025-07-06	\N	\N
5	3	5	2025-07-06	\N	\N
6	3	6	2025-07-06	\N	\N
7	3	7	2025-07-06	\N	\N
8	3	8	2025-07-06	\N	\N
9	3	9	2025-07-06	\N	\N
10	3	10	2025-07-06	\N	\N
\.


--
-- Data for Name: orden_reposicion_anaquel; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.orden_reposicion_anaquel (id_orden_reposicion, id_ubicacion, fecha_hora_generacion) FROM stdin;
1	1	2025-01-15 08:30:00
2	2	2025-01-15 14:45:00
3	3	2025-01-16 09:15:00
4	4	2025-01-16 16:20:00
5	5	2025-01-17 10:00:00
6	6	2025-01-17 13:30:00
7	7	2025-01-18 11:45:00
8	8	2025-01-18 17:10:00
9	9	2025-01-19 08:00:00
10	10	2025-01-19 15:25:00
\.


--
-- Data for Name: orden_reposicion_estatus; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.orden_reposicion_estatus (id_orden_reposicion, id_proveedor, id_departamento, id_estatus, fecha_asignacion, fecha_fin) FROM stdin;
1	1	3	1	2025-01-15 14:00:00	2025-01-15 14:01:00
2	2	3	2	2025-01-16 09:00:00	2025-01-16 09:01:00
3	3	3	2	2025-01-17 11:00:00	2025-01-17 11:01:00
4	4	3	2	2025-01-17 11:00:00	2025-01-17 11:01:00
5	5	3	2	2025-01-17 11:00:00	2025-01-17 11:01:00
6	6	3	2	2025-01-17 11:00:00	2025-01-17 11:01:00
7	7	3	1	2025-01-17 11:00:00	2025-01-17 11:01:00
8	8	3	1	2025-01-17 11:00:00	2025-01-17 11:01:00
9	9	3	1	2025-01-17 11:00:00	2025-01-17 11:01:00
10	10	3	2	2025-01-17 11:00:00	2025-01-17 11:01:00
\.


--
-- Data for Name: pago_compra; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.pago_compra (id_pago, metodo_id, compra_id, monto, fecha_hora, referencia, tasa_id) FROM stdin;
1	1	1	150.00	2024-06-05 14:30:00	PAG-2024-001	1
2	2	2	180.00	2024-06-12 16:45:00	PAG-2024-002	1
3	3	3	120.00	2024-06-08 09:15:00	PAG-2024-003	1
4	4	4	200.00	2024-06-15 13:40:00	PAG-2024-004	1
5	5	5	160.00	2024-07-03 15:10:00	PAG-2024-005	1
6	6	6	140.00	2024-07-10 12:35:00	PAG-2024-006	1
7	7	7	190.00	2024-07-06 10:20:00	PAG-2024-007	1
8	8	8	170.00	2024-07-13 14:55:00	PAG-2024-008	1
9	9	9	130.00	2024-08-02 11:45:00	PAG-2024-009	1
10	10	10	210.00	2024-08-09 13:20:00	PAG-2024-010	1
11	11	11	145.00	2024-08-05 09:30:00	PAG-2024-011	1
12	12	12	175.00	2024-08-12 17:15:00	PAG-2024-012	1
13	13	13	155.00	2024-09-01 14:25:00	PAG-2024-013	1
14	14	14	185.00	2024-09-08 16:40:00	PAG-2024-014	1
15	15	15	135.00	2024-09-04 11:30:00	PAG-2024-015	1
16	16	16	195.00	2024-09-11 13:45:00	PAG-2024-016	1
17	17	17	165.00	2024-10-03 12:15:00	PAG-2024-017	1
18	18	18	125.00	2024-10-10 15:30:00	PAG-2024-018	1
19	19	19	205.00	2024-10-06 09:40:00	PAG-2024-019	1
20	20	20	150.00	2024-10-13 14:25:00	PAG-2024-020	1
21	21	21	160.00	2024-11-02 11:20:00	PAG-2024-021	1
22	22	22	175.00	2024-11-09 13:35:00	PAG-2024-022	1
23	23	23	120.00	2024-11-05 10:15:00	PAG-2024-023	1
24	24	24	185.00	2024-11-12 12:40:00	PAG-2024-024	1
25	25	25	140.00	2024-12-01 14:30:00	PAG-2024-025	1
26	26	26	200.00	2024-12-08 16:45:00	PAG-2024-026	1
27	27	27	155.00	2024-12-04 09:25:00	PAG-2024-027	1
28	28	28	175.00	2024-12-11 13:50:00	PAG-2024-028	1
29	29	29	125.00	2025-01-02 12:40:00	PAG-2025-001	1
30	30	30	205.00	2025-01-09 15:55:00	PAG-2025-002	1
31	31	31	160.00	2025-01-05 10:30:00	PAG-2025-003	1
32	32	32	135.00	2025-01-12 14:45:00	PAG-2025-004	1
33	33	33	195.00	2025-02-02 11:35:00	PAG-2025-005	1
34	34	34	170.00	2025-02-09 13:50:00	PAG-2025-006	1
35	35	35	145.00	2025-02-05 09:40:00	PAG-2025-007	1
36	36	36	205.00	2025-02-12 14:15:00	PAG-2025-008	1
37	37	37	160.00	2025-03-01 12:25:00	PAG-2025-009	1
38	38	38	135.00	2025-03-08 15:40:00	PAG-2025-010	1
39	39	39	195.00	2025-03-04 10:30:00	PAG-2025-011	1
40	40	40	170.00	2025-03-11 13:45:00	PAG-2025-012	1
41	41	41	145.00	2025-04-02 11:35:00	PAG-2025-013	1
42	42	42	205.00	2025-04-09 13:50:00	PAG-2025-014	1
43	43	43	160.00	2025-04-05 09:40:00	PAG-2025-015	1
44	44	44	135.00	2025-04-12 14:15:00	PAG-2025-016	1
45	45	45	195.00	2025-05-01 12:25:00	PAG-2025-017	1
46	46	46	170.00	2025-05-08 15:40:00	PAG-2025-018	1
47	47	47	145.00	2025-05-04 10:30:00	PAG-2025-019	1
48	48	48	205.00	2025-05-11 13:45:00	PAG-2025-020	1
49	49	49	160.00	2025-06-02 11:35:00	PAG-2025-021	1
50	50	50	135.00	2025-06-09 13:50:00	PAG-2025-022	1
51	1	51	190.00	2025-06-05 09:40:00	PAG-2025-023	1
52	2	52	150.00	2025-06-12 14:15:00	PAG-2025-024	1
53	1000	1	150.00	2024-01-15 14:35:00	PAGO-001	\N
54	1001	53	200.00	2024-01-20 16:50:00	PAGO-002	\N
55	1002	54	180.00	2024-01-25 10:20:00	PAGO-003	\N
56	1003	55	350.00	2024-02-10 12:05:00	PAGO-004	\N
57	1004	56	120.00	2024-01-30 18:25:00	PAGO-005	\N
58	1005	57	100.00	2023-12-15 15:35:00	PAGO-006	\N
\.


--
-- Data for Name: pago_cuota_afiliacion; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.pago_cuota_afiliacion (metodo_id, cuota_id, monto, fecha_pago, tasa_id) FROM stdin;
21	1	150.00	2024-01-15	\N
12	2	150.00	2024-03-20	\N
32	3	150.00	2024-06-10	\N
6	4	150.00	2024-09-05	\N
22	5	150.00	2024-11-12	\N
11	6	120.00	2023-01-10	\N
4	7	120.00	2023-05-15	\N
34	8	120.00	2023-08-20	\N
23	9	180.00	2024-02-01	1
13	10	180.00	2024-04-15	2
\.


--
-- Data for Name: pago_evento; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.pago_evento (metodo_id, evento_id, id_cliente_natural, fecha_hora, monto, tasa_id, referencia) FROM stdin;
21	1	1	2024-07-19 11:30:00	85.50	1	TXN-20240719-001
22	1	3	2024-07-19 14:20:00	70.75	1	TXN-20240719-002
1	1	3	2024-07-19 14:21:00	50.00	1	EFE-20240719-001
31	1	5	2024-07-20 16:45:00	95.25	2	TXN-20240720-001
23	1	7	2024-07-20 19:10:00	110.00	2	TXN-20240720-002
24	2	2	2024-08-15 19:15:00	100.00	3	TXN-20240815-001
32	2	2	2024-08-15 19:16:00	80.00	3	TXN-20240815-002
25	2	4	2024-08-15 20:30:00	165.50	3	TXN-20240815-003
33	3	1	2024-09-10 20:45:00	75.80	4	TXN-20240910-001
26	3	6	2024-09-10 21:30:00	90.25	4	TXN-20240910-002
2	3	8	2024-09-10 22:15:00	55.60	4	EFE-20240910-001
34	3	8	2024-09-10 22:16:00	50.00	4	TXN-20240910-003
27	4	3	2024-10-05 18:20:00	145.75	5	TXN-20241005-001
35	4	9	2024-10-05 20:45:00	85.90	5	TXN-20241005-002
3	4	9	2024-10-05 20:46:00	50.00	5	EFE-20241005-001
28	5	2	2024-11-12 10:30:00	200.50	6	TXN-20241112-001
36	5	5	2024-11-13 14:15:00	125.25	6	TXN-20241113-001
4	5	5	2024-11-13 14:16:00	50.00	6	EFE-20241113-001
29	5	10	2024-11-14 16:00:00	140.80	6	TXN-20241114-001
5	5	10	2024-11-14 16:01:00	50.00	6	EFE-20241114-001
37	6	4	2024-06-22 15:45:00	125.40	7	TXN-20240622-001
30	7	6	2024-05-18 17:30:00	95.75	8	TXN-20240518-001
38	7	8	2024-05-18 19:20:00	110.50	8	TXN-20240518-002
39	8	1	2024-10-19 16:45:00	105.60	9	TXN-20241019-001
6	8	1	2024-10-19 16:46:00	50.00	9	EFE-20241019-001
40	8	7	2024-10-19 20:30:00	140.25	9	TXN-20241019-002
11	8	9	2024-10-19 22:10:00	125.90	9	CHQ-20241019-001
12	9	3	2024-09-28 09:45:00	170.75	10	CHQ-20240928-001
7	9	3	2024-09-28 09:46:00	50.00	10	EFE-20240928-001
13	9	10	2024-09-29 15:20:00	145.50	10	CHQ-20240929-001
8	9	10	2024-09-29 15:21:00	50.00	10	EFE-20240929-001
14	10	2	2024-12-07 12:30:00	165.80	1	CHQ-20241207-001
15	10	4	2024-12-07 16:45:00	130.25	1	CHQ-20241207-002
1	10	4	2024-12-07 16:46:00	50.00	1	EFE-20241207-001
16	10	6	2024-12-08 14:15:00	95.60	2	CHQ-20241208-001
2	10	6	2024-12-08 14:16:00	50.00	2	EFE-20241208-001
\.


--
-- Data for Name: pago_orden_reposicion; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.pago_orden_reposicion (id_pago, id_proveedor, id_departamento, id_orden_reposicion, fecha_ejecucion, monto) FROM stdin;
1	1	3	1	2025-07-07 01:34:08.76192	2850.00
2	2	3	2	2025-07-07 03:34:08.76192	3200.00
3	3	3	3	2025-07-07 05:34:08.76192	1950.00
4	4	3	4	2025-07-07 07:34:08.76192	4100.00
5	5	3	5	2025-07-08 01:34:08.76192	2750.00
6	6	3	6	2025-07-08 03:34:08.76192	3650.00
7	7	3	7	2025-07-08 05:34:08.76192	2400.00
8	8	3	8	2025-07-08 07:34:08.76192	3850.00
9	9	3	9	2025-07-09 01:34:08.76192	3100.00
10	10	3	10	2025-07-09 03:34:08.76192	3500.00
\.


--
-- Data for Name: persona_contacto; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.persona_contacto (id_contacto, nombre, apellido, id_proveedor, id_cliente_juridico) FROM stdin;
1	Mar├¡a	Gonz├ílez	1	\N
2	Carlos	Rodr├¡guez	2	\N
3	Ana	Mart├¡nez	3	\N
4	Luis	Fern├índez	4	\N
5	Carmen	L├│pez	5	\N
6	Roberto	P├⌐rez	\N	1
7	Elena	S├ínchez	\N	2
8	Diego	Morales	\N	3
9	Patricia	Herrera	\N	4
10	Andr├⌐s	Castillo	\N	5
\.


--
-- Data for Name: presentacion; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.presentacion (id_presentacion, nombre) FROM stdin;
1	Botella 330ml
2	Botella 500ml
3	Lata 330ml
\.


--
-- Data for Name: presentacion_cerveza; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.presentacion_cerveza (id_presentacion, id_cerveza, cantidad, descripcion, precio) FROM stdin;
1	1	1	\N	3.00
2	1	1	\N	5.00
3	1	1	\N	2.00
1	2	1	\N	3.00
2	2	1	\N	5.00
3	2	1	\N	2.00
1	3	1	\N	3.00
2	3	1	\N	5.00
3	3	1	\N	2.00
1	4	1	\N	3.00
2	4	1	\N	5.00
3	4	1	\N	2.00
1	5	1	\N	3.00
2	5	1	\N	5.00
3	5	1	\N	2.00
1	6	1	\N	3.00
2	6	1	\N	5.00
3	6	1	\N	2.00
1	7	1	\N	3.00
2	7	1	\N	5.00
3	7	1	\N	2.00
1	8	1	\N	3.00
2	8	1	\N	5.00
3	8	1	\N	2.00
1	9	1	\N	3.00
2	9	1	\N	5.00
3	9	1	\N	2.00
1	10	1	\N	3.00
2	10	1	\N	5.00
3	10	1	\N	2.00
1	11	1	\N	3.00
2	11	1	\N	5.00
3	11	1	\N	2.00
1	12	1	\N	3.00
2	12	1	\N	5.00
3	12	1	\N	2.00
1	13	1	\N	3.00
2	13	1	\N	5.00
3	13	1	\N	2.00
1	14	1	\N	3.00
2	14	1	\N	5.00
3	14	1	\N	2.00
1	15	1	\N	3.00
2	15	1	\N	5.00
3	15	1	\N	2.00
1	16	1	\N	3.00
2	16	1	\N	5.00
3	16	1	\N	2.00
1	17	1	\N	3.00
2	17	1	\N	5.00
3	17	1	\N	2.00
1	18	1	\N	3.00
2	18	1	\N	5.00
3	18	1	\N	2.00
\.


--
-- Data for Name: privilegio; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.privilegio (id_privilegio, nombre) FROM stdin;
1	Crear
2	Actualizar
3	Eliminar
4	Leer
\.


--
-- Data for Name: promocion; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.promocion (id_promocion, descripcion, id_departamento, fecha_inicio, fecha_fin, id_usuario) FROM stdin;
1	Descuento 15% en Cervezas IPA durante Enero	1	2025-01-01	2025-01-31	1
2	2x1 en Cervezas Lager los Viernes	1	2025-01-15	2025-03-15	2
3	Happy Hour: 20% descuento de 5-7 PM	1	2025-02-01	2025-02-28	\N
4	Promoci├│n San Valent├¡n: Cerveza + Copa	2	2025-02-10	2025-02-16	3
5	Mes de la Cerveza Artesanal - 25% descuento	2	2025-03-01	2025-03-31	4
6	Promoci├│n D├¡a del Padre: Pack Degustaci├│n	2	2025-06-15	2025-06-22	\N
7	Lanzamiento Cerveza Nueva: 30% descuento	1	2025-04-01	2025-04-15	5
8	Promoci├│n Clientes VIP: Descuento Exclusivo	3	2025-01-01	2025-12-31	6
9	Verano Cervecero: Cervezas Refrescantes	1	2025-06-01	2025-08-31	\N
10	Navidad Cervecera: Packs Especiales	2	2025-12-01	2025-12-31	7
\.


--
-- Data for Name: proveedor; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.proveedor (id_proveedor, razon_social, denominacion, rif, direccion_fiscal, direccion_fisica, id_lugar, lugar_id2, url_web) FROM stdin;
1	Cervecer├¡a Artesanal del Valle, C.A.	Cerveza del Valle	123456789	Avenida Principal del Valle, Edificio Cervecero, Piso 3, Local 5	Calle Los Mangos, Zona Industrial del Valle, Galp├│n 12	370	371	www.cervezadelvalle.com
2	Cerveza Premium de La Candelaria, S.A.	Cerveza Premium	234567890	Calle La Candelaria, Edificio Premium, Piso 2, Local 8	Avenida Principal, Zona Industrial La Candelaria, Galp├│n 15	365	366	www.cervezapremium.com
3	Cervecer├¡a Artesanal El Para├¡so, C.A.	Cerveza El Para├¡so	345678901	Avenida El Para├¡so, Edificio Artesanal, Piso 4, Local 12	Calle Los Pinos, Zona Industrial El Para├¡so, Galp├│n 8	368	369	www.cervezaelparaiso.com
4	Cerveza Gourmet de San Bernardino, S.A.	Cerveza Gourmet	456789012	Calle San Bernardino, Edificio Gourmet, Piso 3, Local 6	Avenida Principal, Zona Industrial San Bernardino, Galp├│n 10	376	377	www.cervezagourmet.com
5	Cervecer├¡a Artesanal de La Pastora, C.A.	Cerveza La Pastora	567890123	Avenida La Pastora, Edificio Artesanal, Piso 2, Local 9	Calle Los Cedros, Zona Industrial La Pastora, Galp├│n 14	372	373	www.cervezalapastora.com
6	Cerveza Premium de San Agust├¡n, S.A.	Cerveza San Agust├¡n	678901234	Calle San Agust├¡n, Edificio Premium, Piso 5, Local 15	Avenida Principal, Zona Industrial San Agust├¡n, Galp├│n 7	375	376	www.cervezasanagustin.com
7	Cervecer├¡a Artesanal de La Vega, C.A.	Cerveza La Vega	789012345	Avenida La Vega, Edificio Artesanal, Piso 3, Local 11	Calle Los Mangos, Zona Industrial La Vega, Galp├│n 9	373	374	www.cervezalavega.com
8	Cerveza Gourmet de San Jos├⌐, S.A.	Cerveza San Jos├⌐	890123456	Calle San Jos├⌐, Edificio Gourmet, Piso 4, Local 7	Avenida Principal, Zona Industrial San Jos├⌐, Galp├│n 13	377	378	www.cervezasanjose.com
9	Cervecer├¡a Artesanal de San Juan, C.A.	Cerveza San Juan	901234567	Avenida San Juan, Edificio Artesanal, Piso 2, Local 10	Calle Los Pinos, Zona Industrial San Juan, Galp├│n 11	378	379	www.cervezasanjuan.com
10	Cerveza Premium de San Pedro, S.A.	Cerveza San Pedro	12345678	Calle San Pedro, Edificio Premium, Piso 3, Local 8	Avenida Principal, Zona Industrial San Pedro, Galp├│n 6	379	380	www.cervezasanpedro.com
11	Cervecer├¡a Artesanal de Santa Rosal├¡a, C.A.	Cerveza Santa Rosal├¡a	123456780	Avenida Santa Rosal├¡a, Edificio Artesanal, Piso 4, Local 13	Calle Los Cedros, Zona Industrial Santa Rosal├¡a, Galp├│n 16	380	381	www.cervezasantarosalia.com
12	Cerveza Gourmet de Santa Teresa, S.A.	Cerveza Santa Teresa	234567801	Calle Santa Teresa, Edificio Gourmet, Piso 2, Local 9	Avenida Principal, Zona Industrial Santa Teresa, Galp├│n 8	381	382	www.cervezasantateresa.com
13	Cervecer├¡a Artesanal de Sucre, C.A.	Cerveza Sucre	345678012	Avenida Sucre, Edificio Artesanal, Piso 3, Local 7	Calle Los Mangos, Zona Industrial Sucre, Galp├│n 12	382	361	www.cervezasucre.com
14	Cerveza Premium de 23 de Enero, S.A.	Cerveza 23 de Enero	456780123	Calle 23 de Enero, Edificio Premium, Piso 5, Local 14	Avenida Principal, Zona Industrial 23 de Enero, Galp├│n 9	361	362	www.cerveza23deenero.com
15	Cervecer├¡a Artesanal de Altagracia, C.A.	Cerveza Altagracia	567801234	Avenida Altagracia, Edificio Artesanal, Piso 2, Local 11	Calle Los Pinos, Zona Industrial Altagracia, Galp├│n 15	362	363	www.cervezaaltagracia.com
16	Cerveza Gourmet de Ant├¡mano, S.A.	Cerveza Ant├¡mano	678012345	Calle Ant├¡mano, Edificio Gourmet, Piso 4, Local 8	Avenida Principal, Zona Industrial Ant├¡mano, Galp├│n 10	363	364	www.cervezaantimano.com
17	Cervecer├¡a Artesanal de Caricuao, C.A.	Cerveza Caricuao	780123456	Avenida Caricuao, Edificio Artesanal, Piso 3, Local 12	Calle Los Cedros, Zona Industrial Caricuao, Galp├│n 7	364	365	www.cervezacaricuao.com
18	Cerveza Premium de Catedral, S.A.	Cerveza Catedral	801234567	Calle Catedral, Edificio Premium, Piso 2, Local 10	Avenida Principal, Zona Industrial Catedral, Galp├│n 14	365	366	www.cervezacatedral.com
19	Cervecer├¡a Artesanal de Coche, C.A.	Cerveza Coche	901234568	Avenida Coche, Edificio Artesanal, Piso 5, Local 15	Calle Los Mangos, Zona Industrial Coche, Galp├│n 11	366	367	www.cervezacoche.com
20	Cerveza Gourmet de El Junquito, S.A.	Cerveza El Junquito	12345689	Calle El Junquito, Edificio Gourmet, Piso 3, Local 9	Avenida Principal, Zona Industrial El Junquito, Galp├│n 13	367	368	www.cervezaeljunquito.com
\.


--
-- Data for Name: punto; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.punto (id_metodo, origen) FROM stdin;
1	Tienda Fisica
2	Tienda Fisica
3	Tienda Fisica
4	Tienda Fisica
5	Tienda Fisica
6	Tienda Fisica
7	Tienda Fisica
8	Tienda Fisica
9	Tienda Fisica
10	Tienda Fisica
41	Tienda Fisica
42	Tienda Fisica
43	Tienda Fisica
44	Tienda Fisica
45	Tienda Fisica
46	Tienda Fisica
47	Tienda Fisica
48	Tienda Fisica
49	Tienda Fisica
50	Tienda Fisica
\.


--
-- Data for Name: punto_cliente; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.punto_cliente (id_punto_cliente, id_cliente_natural, id_metodo, cantidad_mov, fecha, tipo_movimiento) FROM stdin;
1	1	41	150	2025-01-10	GANADO
2	1	41	-50	2025-02-15	GASTADO
3	1	41	75	2025-03-20	GANADO
4	1	41	-25	2025-04-10	GASTADO
5	2	42	200	2025-01-12	GANADO
6	2	42	-80	2025-03-10	GASTADO
7	2	42	120	2025-04-05	GANADO
8	2	42	-40	2025-05-15	GASTADO
9	3	41	300	2025-01-08	GANADO
10	3	41	180	2025-02-20	GANADO
11	3	41	220	2025-03-15	GANADO
12	3	41	150	2025-04-25	GANADO
13	4	43	180	2025-01-11	GANADO
14	4	43	-60	2025-02-20	GASTADO
15	4	43	90	2025-03-30	GANADO
16	4	43	-30	2025-05-05	GASTADO
17	6	44	250	2025-01-13	GANADO
18	6	44	-100	2025-05-01	GASTADO
19	6	44	160	2025-05-20	GANADO
20	6	44	-70	2025-06-10	GASTADO
21	7	45	170	2025-01-14	GANADO
22	7	45	140	2025-02-25	GANADO
23	7	45	110	2025-03-18	GANADO
24	7	45	95	2025-04-30	GANADO
25	8	46	220	2025-01-15	GANADO
26	8	46	-90	2025-04-10	GASTADO
27	8	46	130	2025-05-05	GANADO
28	8	46	-50	2025-06-15	GASTADO
29	10	48	210	2025-01-17	GANADO
30	10	48	-60	2025-03-30	GASTADO
31	10	48	180	2025-04-20	GANADO
32	10	48	-90	2025-05-25	GASTADO
33	11	49	280	2025-01-18	GANADO
34	11	49	190	2025-02-22	GANADO
35	11	49	160	2025-03-28	GANADO
36	11	49	140	2025-04-18	GANADO
37	12	50	195	2025-01-19	GANADO
38	12	50	-85	2025-03-12	GASTADO
39	12	50	125	2025-04-08	GANADO
40	12	50	-45	2025-05-20	GASTADO
41	14	42	165	2025-01-21	GANADO
42	14	42	-75	2025-03-05	GASTADO
43	14	42	110	2025-04-12	GANADO
44	14	42	-35	2025-05-28	GASTADO
45	15	43	320	2025-01-22	GANADO
46	15	43	210	2025-02-28	GANADO
47	15	43	180	2025-03-15	GANADO
48	15	43	150	2025-04-25	GANADO
49	16	44	145	2025-01-23	GANADO
50	16	44	-65	2025-03-08	GASTADO
51	16	44	95	2025-04-18	GANADO
52	16	44	-30	2025-05-30	GASTADO
53	18	46	175	2025-01-25	GANADO
54	18	46	-85	2025-03-15	GASTADO
55	18	46	135	2025-04-22	GANADO
56	18	46	-55	2025-05-18	GASTADO
57	19	47	260	2025-01-26	GANADO
58	19	47	185	2025-02-18	GANADO
59	19	47	155	2025-03-30	GANADO
60	19	47	125	2025-04-28	GANADO
61	20	48	185	2025-01-27	GANADO
62	20	48	-95	2025-03-20	GASTADO
63	20	48	145	2025-04-10	GANADO
64	20	48	-50	2025-05-25	GASTADO
\.


--
-- Data for Name: receta; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.receta (id_receta, id_tipo_cerveza, descripcion) FROM stdin;
1	1	RECETA LAGER TRADICIONAL: Fermentaci├│n baja con levadura Saccharomyces Carlsbergenesis. 1) Usar alta proporci├│n de malta clara, poco o nada de malta tostada. 2) Agregar malta de trigo opcional. 3) Fermentar a menos de 10┬░C durante 1-3 meses. 4) Usar poco l├║pulo para mantener color claro. 5) Graduaci├│n entre 3.5-5%. 6) Requiere c├ímara frigor├¡fica o elaboraci├│n en invierno.
2	3	RECETA PILSNER BOHEMIA: Cerveza comercial ligera pero intensa. 1) Fermentar con levadura de baja fermentaci├│n. 2) Contenido alcoh├│lico medio. 3) Sabor ligero pero intenso caracter├¡stico. 4) Proceso de fermentaci├│n lenta a bajas temperaturas. 5) Una de las cervezas m├ís consumidas mundialmente.
3	2	RECETA ALE TRADICIONAL: Fermentaci├│n alta con levadura Saccharomyces Cerevisiae. 1) Fermentar en superficie del fermentador a 19┬░C durante 5-7 d├¡as. 2) Usar bastante l├║pulo para contenido alcoh├│lico elevado. 3) Segunda fermentaci├│n para reducir turbidez. 4) No servir helada como las lager. 5) Popular en Reino Unido, USA y antiguas colonias brit├ínicas.
4	12	RECETA PALE ALE: Cerveza ale de color claro con peque├▒as proporciones de malta tostada. 1) Usar mucho l├║pulo para sabor intenso y amargor. 2) Malta Pale americana de dos hileras como base. 3) L├║pulos americanos con car├ícter c├¡trico. 4) Levadura ale americana. 5) Agua con sulfatos variables pero carbonatos bajos. 6) Maltas especiales para car├ícter a pan y tostado.
5	13	RECETA IPA (INDIAN PALE ALE): Cerveza muy alcoh├│lica y rica en l├║pulo dise├▒ada para largas traves├¡as. 1) American IPA menos maltosa y m├ís lupulizada. 2) L├║pulos americanos con proceso dry hopping. 3) Aroma y sabor claramente a l├║pulo: floral, frutal, c├¡trico o resinoso. 4) Sabor a malta medio-bajo. 5) 40-60 IBUs de amargor. 6) 5-7.5% graduaci├│n alcoh├│lica.
6	17	RECETA STOUT IRLANDESA: Cerveza negra muy oscura. 1) Buena proporci├│n de maltas tostadas y caramelizadas. 2) Buena dosis de l├║pulo. 3) Textura espesa y cremosa. 4) Fuerte aroma a malta y regusto dulce. 5) Fermentaci├│n ale. 6) Variantes: Imperial Stout (alta concentraci├│n malta), Chocolate/Coffee Stout, Milk Stout (endulzada con lactosa).
7	22	RECETA CERVEZA DE TRIGO ALEMANA: Weisse beer del Oktober Fest. 1) Hecha total o parcialmente con malta de trigo. 2) Color claro y baja graduaci├│n. 3) Fermentar con levadura ale. 4) Especialmente importante en Alemania. 5) Variante berlinesa tambi├⌐n disponible.
8	19	RECETA BELGIAN DUBBEL MON├üSTICA: Cerveza de monasterios con sabor intenso. 1) Buenas dosis de l├║pulo con fondo dulce de maltas ├ímbar y cristal. 2) Tonos rojizos caracter├¡sticos. 3) Bastante alcoh├│lica superando 6-7% alcohol. 4) Incluye cerveza de Abad├¡a, Trapense, ├ümbar, Flamenca. 5) Tradici├│n mon├ística medieval.
9	30	RECETA AMERICAN AMBER ALE: Estilo moderno del siglo XX. 1) Malta Pale Ale norteamericana (5kg) + Malta Aromatic (0.5kg) + Malta Caramel Light (0.4kg). 2) L├║pulo Columbus (7gr-60min) + Cascade (7gr-20min) + Columbus (10gr-flameout) + Cascade (30gr-flameout). 3) Levadura Danstar Bry-97. 4) Maceraci├│n 1 hora a 66┬░C. 5) Sparging a 76┬░C. 6) Fermentar 18-20┬░C. 7) Madurar 4 semanas. 8) 5.8% alcohol, 16 IBUs.
10	8	RECETA BOCK TRADICIONAL: Lager muy rica en maltas tostadas. 1) Color muy oscuro con espuma blanca contrastante. 2) M├ís de 7% contenido alcoh├│lico. 3) Eisbock: t├⌐cnica de congelaci├│n parcial para retirar hielo y aumentar graduaci├│n. 4) No muy lupulosa, predomina sabor a malta y dulzor. 5) Diferente a otras cervezas oscuras por menor lupulizaci├│n.
\.


--
-- Data for Name: receta_ingrediente; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.receta_ingrediente (id_receta, id_ingrediente) FROM stdin;
1	1
1	7
2	1
2	6
3	2
3	5
4	1
4	3
5	3
5	4
10	8
\.


--
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.rol (id_rol, nombre) FROM stdin;
1	Supervisor
2	Encargado
3	Administrador
4	Empleado Nuevo
\.


--
-- Data for Name: rol_privilegio; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.rol_privilegio (id_rol, id_privilegio, fecha_asignacion, nom_tabla_ojetivo, motivo) FROM stdin;
3	1	2025-01-15	all	Consultar cat├ílogo de productos disponibles
3	2	2025-01-15	all	Crear ventas y realizar compras
3	3	2025-01-15	all	Consultar eventos disponibles
3	4	2025-01-15	all	Acceso total al sistema como administrador principal
\.


--
-- Data for Name: tarjeta_credito; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.tarjeta_credito (id_metodo, tipo, numero, banco, fecha_vencimiento) FROM stdin;
21	Visa	4111111111111111	Banco de Venezuela	2026-12-31
22	MasterCard	5555555555554444	Banesco	2027-06-30
23	American Express	378282246310005	Banco Mercantil	2025-09-30
24	Visa	4000000000000002	BBVA Provincial	2026-03-31
25	MasterCard	5105105105105100	Banco Bicentenario	2027-11-30
26	Visa	4012888888881881	Bancaribe	2025-08-31
27	MasterCard	5431111111111111	Banco Exterior	2026-07-31
28	Visa	4222222222222	Banco Plaza	2027-02-28
29	American Express	371449635398431	Mi Banco	2025-12-31
30	MasterCard	5555555555554444	Banco Activo	2026-10-31
\.


--
-- Data for Name: tarjeta_debito; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.tarjeta_debito (id_metodo, numero, banco) FROM stdin;
31	4111111111111112	Banco de Venezuela
32	5555555555554445	Banesco
33	4000000000000003	Banco Mercantil
34	4012888888881882	BBVA Provincial
35	5105105105105101	Banco Bicentenario
36	4222222222223	Bancaribe
37	5431111111111112	Banco Exterior
38	4111111111111113	Banco Plaza
39	5555555555554446	Mi Banco
40	4000000000000004	Banco Activo
\.


--
-- Data for Name: tasa; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.tasa (id_tasa, nombre, valor, fecha, punto_id, id_metodo) FROM stdin;
1	D├│lar Estadounidense	103.73	2025-06-19	41	1
2	Euro	119.44	2025-06-19	42	2
3	D├│lar Estadounidense	102.15	2025-06-18	43	3
4	Euro	118.20	2025-06-18	44	4
5	D├│lar Estadounidense	101.85	2025-06-17	45	5
6	Euro	117.95	2025-06-17	46	6
7	D├│lar Estadounidense	100.92	2025-06-16	47	7
8	Euro	116.80	2025-06-16	48	8
9	D├│lar Estadounidense	99.75	2025-06-15	49	9
10	Euro	115.60	2025-06-15	50	10
\.


--
-- Data for Name: telefono; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.telefono (id_telefono, codigo_area, numero, id_proveedor, id_contacto, id_invitado, id_cliente_juridico, id_cliente_natural) FROM stdin;
1	0212	5551234	1	\N	\N	\N	\N
2	0414	7778899	2	\N	\N	\N	\N
3	0212	4445566	\N	1	\N	\N	\N
4	0424	3332211	\N	2	\N	\N	\N
5	0212	6667788	\N	\N	1	\N	\N
6	0416	9998877	\N	\N	2	\N	\N
7	0212	2223344	\N	\N	\N	1	\N
8	0414	8889900	\N	\N	\N	2	\N
9	0212	1112233	\N	\N	\N	\N	1
10	0426	5554433	\N	\N	\N	\N	2
11	0412	2232223	\N	\N	\N	\N	22
\.


--
-- Data for Name: tienda_fisica; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.tienda_fisica (id_tienda_fisica, id_lugar, nombre, direccion) FROM stdin;
1	25	ACAUCAB Cervecer├¡a Artesanal	Av. Francisco de Miranda, Centro Comercial Lido, Nivel PB, Local 12, El Rosal, Caracas
\.


--
-- Data for Name: tienda_web; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.tienda_web (id_tienda_web, nombre, url) FROM stdin;
1	Tienda Web 1	https://www.tiendaweb1.com
\.


--
-- Data for Name: tipo_actividad; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.tipo_actividad (id_tipo_actividad, nombre) FROM stdin;
1	Taller T├⌐cnico
2	Conferencia
3	Degustaci├│n
4	Masterclass
5	Seminario
6	Mesa Redonda
7	Demostraci├│n
8	Competencia
9	Networking
10	Presentaci├│n
\.


--
-- Data for Name: tipo_cerveza; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.tipo_cerveza (id_tipo_cerveza, nombre, tipo_padre_id) FROM stdin;
1	Lager	\N
2	Ale	\N
3	Pilsner	1
4	Spezial	1
5	Dortmunster	1
6	Schwarzbier	1
7	Vienna	1
8	Bock	1
9	Bohemian Pilsener	1
10	Munich Helles	1
11	Oktoberfest-Marzen	1
12	Pale Ale	2
13	IPA	2
14	Amber Ale	2
15	Brown Ale	2
16	Golden Ale	2
17	Stout	2
18	Porter	2
19	Belgian Dubbel	2
20	Belgian Golden Strong	2
21	Belgian Specialty Ale	2
22	Wheat Beer	2
23	Blonde Ale	2
24	Barley Wine	2
25	American Pale Ale	12
26	English Pale Ale	12
27	American IPA	13
28	Imperial IPA	13
29	India Pale Ale	13
30	American Amber Ale	14
31	Irish Red Ale	14
32	Red Ale	14
33	Dry Stout	17
34	Imperial Stout	17
35	Sweet Stout	17
36	Artisanal Amber	21
37	Artisanal Blond	21
38	Artisanal Brown	21
39	Belgian Barleywine	21
40	Belgian IPA	21
41	Belgian Spiced Christmas Beer	21
42	Belgian Stout	21
43	Fruit Lambic	21
44	Spice, Herb o Vegetable	21
45	Flanders Red/Brown	21
46	Weizen-Weissbier	22
47	Witbier	22
48	D├╝sseldorf Altbier	2
49	Extra-Strong Bitter	12
\.


--
-- Data for Name: tipo_invitado; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.tipo_invitado (id_tipo_invitado, nombre) FROM stdin;
1	Maestro Cervecero
2	Sommelier de Cerveza
3	Distribuidor Mayorista
4	Propietario de Brewpub
5	Consultor en Cervecer├¡a
6	Periodista Especializado
7	Influencer Gastron├│mico
8	Chef Especialista en Maridajes
9	Proveedor de Equipos
10	Acad├⌐mico Investigador
\.


--
-- Data for Name: tipoevento; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.tipoevento (id_tipo_evento, nombre, descripcion) FROM stdin;
1	Festival de Cerveza	Evento masivo de degustaci├│n y venta de cervezas artesanales con m├║ltiples proveedores
2	Taller de Cata	Sesi├│n educativa para aprender a degustar y evaluar diferentes tipos de cerveza artesanal
3	Lanzamiento de Producto	Presentaci├│n oficial de nuevas cervezas artesanales de nuestros miembros proveedores
4	Maridaje Gastron├│mico	Evento de combinaci├│n de cervezas artesanales con platos gourmet y comida tradicional
5	Competencia de Cerveceros	Concurso entre cerveceros artesanales para premiar la mejor cerveza por categor├¡a
6	Conferencia T├⌐cnica	Charlas especializadas sobre t├⌐cnicas de elaboraci├│n y tendencias en cerveza artesanal
7	Networking Empresarial	Encuentro de negocios entre proveedores, distribuidores y clientes del sector cervecero
8	Celebraci├│n Tem├ítica	Eventos especiales por fechas importantes como Oktoberfest, D├¡a de la Cerveza, etc.
9	Curso de Elaboraci├│n	Capacitaci├│n pr├íctica para aprender a elaborar cerveza artesanal desde cero
10	Feria Comercial	Exposici├│n comercial de productos, equipos y servicios relacionados con cerveza artesanal
\.


--
-- Data for Name: ubicacion_tienda; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.ubicacion_tienda (id_ubicacion, tipo, nombre, ubicacion_tienda_relacion_id, id_tienda_web, id_tienda_fisica) FROM stdin;
1	Seccion	├ürea de Cervezas Lager	\N	1	1
2	Seccion	├ürea de Cervezas Ale	\N	1	1
3	Seccion	├ürea de Cervezas Especiales	\N	1	1
4	Anaquel	Anaquel Pilsner	1	1	1
5	Anaquel	Anaquel Munich Helles	1	1	1
6	Anaquel	Anaquel IPA	2	1	1
7	Anaquel	Anaquel Pale Ale	2	1	1
8	Anaquel	Anaquel Stout	2	1	1
9	Anaquel	Anaquel Wheat Beer	3	1	1
10	Refrigerador	Nevera Cervezas Fr├¡as	\N	1	1
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.usuario (id_usuario, id_cliente_juridico, id_cliente_natural, id_rol, fecha_creacion, id_proveedor, empleado_id, "contrase├▒a") FROM stdin;
1	\N	\N	\N	2025-07-06	1	\N	proveedor123
2	\N	\N	\N	2025-07-06	2	\N	proveedor456
3	\N	\N	\N	2025-07-06	3	\N	proveedor789
4	\N	\N	\N	2025-07-06	4	\N	proveedor101
5	\N	\N	\N	2025-07-06	5	\N	proveedor202
6	\N	\N	\N	2025-07-06	6	\N	proveedor303
7	\N	\N	\N	2025-07-06	7	\N	proveedor404
8	\N	\N	\N	2025-07-06	8	\N	proveedor505
9	\N	\N	\N	2025-07-06	9	\N	proveedor606
10	\N	\N	\N	2025-07-06	10	\N	proveedor707
11	\N	\N	\N	2025-07-06	11	\N	proveedor808
12	\N	\N	\N	2025-07-06	12	\N	proveedor909
13	\N	\N	\N	2025-07-06	13	\N	proveedor111
14	\N	\N	\N	2025-07-06	14	\N	proveedor222
15	\N	\N	\N	2025-07-06	15	\N	proveedor333
16	\N	\N	\N	2025-07-06	16	\N	proveedor444
17	\N	\N	\N	2025-07-06	17	\N	proveedor555
18	\N	\N	\N	2025-07-06	18	\N	proveedor666
19	\N	\N	\N	2025-07-06	19	\N	proveedor777
20	\N	\N	\N	2025-07-06	20	\N	proveedor888
21	\N	1	\N	2025-07-06	\N	\N	cliente001
22	\N	2	\N	2025-07-06	\N	\N	cliente002
23	\N	3	\N	2025-07-06	\N	\N	cliente003
24	\N	4	\N	2025-07-06	\N	\N	cliente004
25	\N	5	\N	2025-07-06	\N	\N	cliente005
26	\N	6	\N	2025-07-06	\N	\N	cliente006
27	\N	7	\N	2025-07-06	\N	\N	cliente007
28	\N	8	\N	2025-07-06	\N	\N	cliente008
29	\N	9	\N	2025-07-06	\N	\N	cliente009
30	\N	10	\N	2025-07-06	\N	\N	cliente010
31	\N	11	\N	2025-07-06	\N	\N	cliente011
32	\N	12	\N	2025-07-06	\N	\N	cliente012
33	\N	13	\N	2025-07-06	\N	\N	cliente013
34	\N	14	\N	2025-07-06	\N	\N	cliente014
35	\N	15	\N	2025-07-06	\N	\N	cliente015
36	\N	16	\N	2025-07-06	\N	\N	cliente016
37	\N	17	\N	2025-07-06	\N	\N	cliente017
38	\N	18	\N	2025-07-06	\N	\N	cliente018
39	\N	19	\N	2025-07-06	\N	\N	cliente019
40	\N	20	\N	2025-07-06	\N	\N	cliente020
41	1	\N	\N	2025-07-06	\N	\N	empresa001
42	2	\N	\N	2025-07-06	\N	\N	empresa002
43	3	\N	\N	2025-07-06	\N	\N	empresa003
44	4	\N	\N	2025-07-06	\N	\N	empresa004
45	5	\N	\N	2025-07-06	\N	\N	empresa005
46	6	\N	\N	2025-07-06	\N	\N	empresa006
47	7	\N	\N	2025-07-06	\N	\N	empresa007
48	8	\N	\N	2025-07-06	\N	\N	empresa008
49	9	\N	\N	2025-07-06	\N	\N	empresa009
50	10	\N	\N	2025-07-06	\N	\N	empresa010
51	11	\N	\N	2025-07-06	\N	\N	empresa011
52	12	\N	\N	2025-07-06	\N	\N	empresa012
53	13	\N	\N	2025-07-06	\N	\N	empresa013
54	14	\N	\N	2025-07-06	\N	\N	empresa014
55	15	\N	\N	2025-07-06	\N	\N	empresa015
56	16	\N	\N	2025-07-06	\N	\N	empresa016
57	17	\N	\N	2025-07-06	\N	\N	empresa017
58	18	\N	\N	2025-07-06	\N	\N	empresa018
59	19	\N	\N	2025-07-06	\N	\N	empresa019
60	20	\N	\N	2025-07-06	\N	\N	empresa020
61	\N	\N	3	2025-07-06	\N	1	empleado123
62	\N	\N	4	2025-07-06	\N	2	empleado123
63	\N	\N	4	2025-07-06	\N	3	empleado123
64	\N	\N	4	2025-07-06	\N	4	empleado123
65	\N	\N	4	2025-07-06	\N	5	empleado123
66	\N	\N	4	2025-07-06	\N	6	empleado123
67	\N	\N	4	2025-07-06	\N	7	empleado123
68	\N	\N	4	2025-07-06	\N	8	empleado123
69	\N	\N	4	2025-07-06	\N	9	empleado123
70	\N	\N	4	2025-07-06	\N	10	empleado123
71	\N	21	\N	2023-06-20	\N	\N	password456
\.


--
-- Data for Name: vacacion; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.vacacion (id_vacacion, fecha_inicio, fecha_fin, descripcion, empleado_id) FROM stdin;
1	2024-07-15	2024-07-26	Vacaciones anuales de verano - Viaje familiar a Margarita	1
2	2024-12-23	2024-12-30	Vacaciones de fin de a├▒o - Celebraciones navide├▒as	1
3	2024-03-10	2024-03-15	Vacaciones de Semana Santa - Descanso familiar	1
4	2024-03-18	2024-03-22	Vacaciones de Semana Santa - Descanso familiar	2
5	2024-08-05	2024-08-16	Vacaciones anuales - Viaje a Los Roques	2
6	2024-11-20	2024-11-25	Vacaciones personales - Asuntos familiares	2
7	2024-01-15	2024-01-19	Vacaciones de inicio de a├▒o - Descanso post-navide├▒o	2
8	2024-06-10	2024-06-14	Vacaciones personales - Asuntos familiares	3
9	2024-04-22	2024-04-26	Vacaciones de primavera - Descanso personal	4
10	2024-09-16	2024-09-27	Vacaciones anuales - Viaje al exterior	4
11	2024-02-12	2024-02-16	Vacaciones de carnaval - Celebraciones tradicionales	6
12	2024-10-07	2024-10-18	Vacaciones anuales - Visita a familiares en el interior	6
13	2024-12-10	2024-12-14	Vacaciones de fin de a├▒o - Preparativos navide├▒os	6
14	2024-01-08	2024-01-12	Vacaciones de inicio de a├▒o - Descanso post-navide├▒o	7
15	2024-08-19	2024-08-30	Vacaciones anuales - Viaje a M├⌐rida	7
16	2024-05-20	2024-05-24	Vacaciones por motivos de salud - Recuperaci├│n m├⌐dica	7
17	2024-11-05	2024-11-09	Vacaciones personales - Asuntos acad├⌐micos	7
18	2024-06-24	2024-06-28	Vacaciones de San Juan - Celebraciones regionales	8
19	2024-03-25	2024-03-29	Vacaciones de Semana Santa - Retiro espiritual	9
20	2024-07-29	2024-08-02	Vacaciones de verano - Descanso familiar	9
21	2024-05-27	2024-05-31	Vacaciones por maternidad - Cuidado familiar	10
22	2024-09-02	2024-09-06	Vacaciones de regreso a clases - Asuntos familiares	10
23	2024-12-28	2025-01-02	Vacaciones de fin de a├▒o - Celebraciones navide├▒as	10
\.


--
-- Data for Name: venta_evento; Type: TABLE DATA; Schema: public; Owner: daniel_bd
--

COPY public.venta_evento (evento_id, id_cliente_natural, fecha_compra, total) FROM stdin;
1	1	2024-07-19 11:30:00	85.50
1	3	2024-07-19 14:20:00	120.75
1	5	2024-07-20 16:45:00	95.25
1	7	2024-07-20 19:10:00	110.00
2	2	2024-08-15 19:15:00	180.00
2	4	2024-08-15 20:30:00	165.50
3	1	2024-09-10 20:45:00	75.80
3	6	2024-09-10 21:30:00	90.25
3	8	2024-09-10 22:15:00	105.60
4	3	2024-10-05 18:20:00	145.75
4	9	2024-10-05 20:45:00	135.90
5	2	2024-11-12 10:30:00	200.50
5	5	2024-11-13 14:15:00	175.25
5	10	2024-11-14 16:00:00	190.80
6	4	2024-06-22 15:45:00	125.40
7	6	2024-05-18 17:30:00	95.75
7	8	2024-05-18 19:20:00	110.50
8	1	2024-10-19 16:45:00	155.60
8	7	2024-10-19 20:30:00	140.25
8	9	2024-10-19 22:10:00	125.90
9	3	2024-09-28 09:45:00	220.75
9	10	2024-09-29 15:20:00	195.50
10	2	2024-12-07 12:30:00	165.80
10	4	2024-12-07 16:45:00	180.25
10	6	2024-12-08 14:15:00	145.60
\.


--
-- Name: actividad_id_actividad_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.actividad_id_actividad_seq', 10, true);


--
-- Name: asistencia_id_asistencia_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.asistencia_id_asistencia_seq', 30, true);


--
-- Name: beneficio_id_beneficio_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.beneficio_id_beneficio_seq', 10, true);


--
-- Name: caracteristica_id_caracteristica_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.caracteristica_id_caracteristica_seq', 19, true);


--
-- Name: cargo_id_cargo_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.cargo_id_cargo_seq', 10, true);


--
-- Name: cerveza_id_cerveza_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.cerveza_id_cerveza_seq', 56, true);


--
-- Name: cliente_juridico_id_cliente_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.cliente_juridico_id_cliente_seq', 20, true);


--
-- Name: cliente_natural_id_cliente_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.cliente_natural_id_cliente_seq', 22, true);


--
-- Name: compra_id_compra_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.compra_id_compra_seq', 60, true);


--
-- Name: correo_id_correo_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.correo_id_correo_seq', 134, true);


--
-- Name: cuota_afiliacion_id_cuota_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.cuota_afiliacion_id_cuota_seq', 10, true);


--
-- Name: departamento_id_departamento_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.departamento_id_departamento_seq', 10, true);


--
-- Name: empleado_id_empleado_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.empleado_id_empleado_seq', 10, true);


--
-- Name: estatus_id_estatus_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.estatus_id_estatus_seq', 1, false);


--
-- Name: evento_id_evento_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.evento_id_evento_seq', 10, true);


--
-- Name: fermentacion_id_fermentacion_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.fermentacion_id_fermentacion_seq', 10, true);


--
-- Name: horario_id_horario_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.horario_id_horario_seq', 10, true);


--
-- Name: ingrediente_id_ingrediente_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.ingrediente_id_ingrediente_seq', 10, true);


--
-- Name: instruccion_id_instruccion_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.instruccion_id_instruccion_seq', 10, true);


--
-- Name: inventario_id_inventario_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.inventario_id_inventario_seq', 162, true);


--
-- Name: invitado_id_invitado_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.invitado_id_invitado_seq', 10, true);


--
-- Name: lugar_id_lugar_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.lugar_id_lugar_seq', 1573, true);


--
-- Name: membresia_id_membresia_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.membresia_id_membresia_seq', 10, true);


--
-- Name: metodo_pago_id_metodo_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.metodo_pago_id_metodo_seq', 1005, true);


--
-- Name: orden_reposicion_anaquel_id_orden_reposicion_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.orden_reposicion_anaquel_id_orden_reposicion_seq', 10, true);


--
-- Name: orden_reposicion_id_orden_reposicion_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.orden_reposicion_id_orden_reposicion_seq', 10, true);


--
-- Name: pago_compra_id_pago_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.pago_compra_id_pago_seq', 58, true);


--
-- Name: pago_orden_reposicion_id_pago_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.pago_orden_reposicion_id_pago_seq', 10, true);


--
-- Name: persona_contacto_id_contacto_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.persona_contacto_id_contacto_seq', 10, true);


--
-- Name: presentacion_id_presentacion_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.presentacion_id_presentacion_seq', 3, true);


--
-- Name: privilegio_id_privilegio_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.privilegio_id_privilegio_seq', 4, true);


--
-- Name: promocion_id_promocion_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.promocion_id_promocion_seq', 10, true);


--
-- Name: proveedor_id_proveedor_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.proveedor_id_proveedor_seq', 20, true);


--
-- Name: punto_cliente_id_punto_cliente_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.punto_cliente_id_punto_cliente_seq', 64, true);


--
-- Name: receta_id_receta_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.receta_id_receta_seq', 10, true);


--
-- Name: rol_id_rol_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.rol_id_rol_seq', 4, true);


--
-- Name: tasa_id_tasa_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.tasa_id_tasa_seq', 10, true);


--
-- Name: telefono_id_telefono_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.telefono_id_telefono_seq', 11, true);


--
-- Name: tienda_fisica_id_tienda_fisica_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.tienda_fisica_id_tienda_fisica_seq', 1, true);


--
-- Name: tienda_web_id_tienda_web_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.tienda_web_id_tienda_web_seq', 1, false);


--
-- Name: tipo_actividad_id_tipo_actividad_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.tipo_actividad_id_tipo_actividad_seq', 10, true);


--
-- Name: tipo_cerveza_id_tipo_cerveza_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.tipo_cerveza_id_tipo_cerveza_seq', 1, false);


--
-- Name: tipo_invitado_id_tipo_invitado_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.tipo_invitado_id_tipo_invitado_seq', 10, true);


--
-- Name: tipoevento_id_tipo_evento_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.tipoevento_id_tipo_evento_seq', 10, true);


--
-- Name: ubicacion_tienda_id_ubicacion_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.ubicacion_tienda_id_ubicacion_seq', 10, true);


--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 71, true);


--
-- Name: vacacion_id_vacacion_seq; Type: SEQUENCE SET; Schema: public; Owner: daniel_bd
--

SELECT pg_catalog.setval('public.vacacion_id_vacacion_seq', 23, true);


--
-- Name: actividad actividad_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.actividad
    ADD CONSTRAINT actividad_pkey PRIMARY KEY (id_actividad);


--
-- Name: asistencia asistencia_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.asistencia
    ADD CONSTRAINT asistencia_pkey PRIMARY KEY (id_asistencia);


--
-- Name: beneficio_depto_empleado beneficio_depto_empleado_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.beneficio_depto_empleado
    ADD CONSTRAINT beneficio_depto_empleado_pkey PRIMARY KEY (id_empleado, id_departamento, id_beneficio);


--
-- Name: beneficio beneficio_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.beneficio
    ADD CONSTRAINT beneficio_pkey PRIMARY KEY (id_beneficio);


--
-- Name: caracteristica_especifica caracteristica_especifica_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.caracteristica_especifica
    ADD CONSTRAINT caracteristica_especifica_pkey PRIMARY KEY (id_tipo_cerveza, id_caracteristica);


--
-- Name: caracteristica caracteristica_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.caracteristica
    ADD CONSTRAINT caracteristica_pkey PRIMARY KEY (id_caracteristica);


--
-- Name: cargo cargo_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cargo
    ADD CONSTRAINT cargo_pkey PRIMARY KEY (id_cargo);


--
-- Name: cerveza cerveza_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cerveza
    ADD CONSTRAINT cerveza_pkey PRIMARY KEY (id_cerveza);


--
-- Name: cheque cheque_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cheque
    ADD CONSTRAINT cheque_pkey PRIMARY KEY (id_metodo);


--
-- Name: cliente_juridico cliente_juridico_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cliente_juridico
    ADD CONSTRAINT cliente_juridico_pkey PRIMARY KEY (id_cliente);


--
-- Name: cliente_natural cliente_natural_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cliente_natural
    ADD CONSTRAINT cliente_natural_pkey PRIMARY KEY (id_cliente);


--
-- Name: compra_estatus compra_estatus_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.compra_estatus
    ADD CONSTRAINT compra_estatus_pkey PRIMARY KEY (compra_id_compra, estatus_id_estatus);


--
-- Name: compra compra_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_pkey PRIMARY KEY (id_compra);


--
-- Name: correo correo_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.correo
    ADD CONSTRAINT correo_pkey PRIMARY KEY (id_correo);


--
-- Name: cuota_afiliacion cuota_afiliacion_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cuota_afiliacion
    ADD CONSTRAINT cuota_afiliacion_pkey PRIMARY KEY (id_cuota);


--
-- Name: departamento_empleado departamento_empleado_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.departamento_empleado
    ADD CONSTRAINT departamento_empleado_pkey PRIMARY KEY (id_empleado, id_departamento);


--
-- Name: departamento departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT departamento_pkey PRIMARY KEY (id_departamento);


--
-- Name: descuento descuento_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.descuento
    ADD CONSTRAINT descuento_pkey PRIMARY KEY (id_promocion, id_tipo_cerveza, id_presentacion, id_cerveza);


--
-- Name: detalle_compra detalle_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT detalle_compra_pkey PRIMARY KEY (id_inventario, id_compra);


--
-- Name: detalle_orden_reposicion_anaquel detalle_orden_reposicion_anaquel_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.detalle_orden_reposicion_anaquel
    ADD CONSTRAINT detalle_orden_reposicion_anaquel_pkey PRIMARY KEY (id_orden_reposicion, id_inventario);


--
-- Name: detalle_orden_reposicion detalle_orden_reposicion_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.detalle_orden_reposicion
    ADD CONSTRAINT detalle_orden_reposicion_pkey PRIMARY KEY (id_orden_reposicion, id_proveedor, id_departamento, id_presentacion, id_cerveza);


--
-- Name: detalle_venta_evento detalle_venta_evento_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.detalle_venta_evento
    ADD CONSTRAINT detalle_venta_evento_pkey PRIMARY KEY (id_evento, id_cliente_natural, id_cerveza, id_proveedor, id_proveedor_evento, id_tipo_cerveza, id_presentacion, id_cerveza_inv);


--
-- Name: efectivo efectivo_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.efectivo
    ADD CONSTRAINT efectivo_pkey PRIMARY KEY (id_metodo);


--
-- Name: empleado empleado_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (id_empleado);


--
-- Name: estatus_orden_anaquel estatus_orden_anaquel_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.estatus_orden_anaquel
    ADD CONSTRAINT estatus_orden_anaquel_pkey PRIMARY KEY (id_orden_reposicion, id_estatus);


--
-- Name: estatus estatus_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.estatus
    ADD CONSTRAINT estatus_pkey PRIMARY KEY (id_estatus);


--
-- Name: evento evento_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.evento
    ADD CONSTRAINT evento_pkey PRIMARY KEY (id_evento);


--
-- Name: evento_proveedor evento_proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.evento_proveedor
    ADD CONSTRAINT evento_proveedor_pkey PRIMARY KEY (id_proveedor, id_evento);


--
-- Name: fermentacion fermentacion_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.fermentacion
    ADD CONSTRAINT fermentacion_pkey PRIMARY KEY (id_fermentacion);


--
-- Name: horario_empleado horario_empleado_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.horario_empleado
    ADD CONSTRAINT horario_empleado_pkey PRIMARY KEY (id_empleado, id_horario);


--
-- Name: horario_evento horario_evento_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.horario_evento
    ADD CONSTRAINT horario_evento_pkey PRIMARY KEY (id_evento, id_horario);


--
-- Name: horario horario_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.horario
    ADD CONSTRAINT horario_pkey PRIMARY KEY (id_horario);


--
-- Name: ingrediente ingrediente_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.ingrediente
    ADD CONSTRAINT ingrediente_pkey PRIMARY KEY (id_ingrediente);


--
-- Name: instruccion instruccion_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.instruccion
    ADD CONSTRAINT instruccion_pkey PRIMARY KEY (id_instruccion);


--
-- Name: inventario_evento_proveedor inventario_evento_proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.inventario_evento_proveedor
    ADD CONSTRAINT inventario_evento_proveedor_pkey PRIMARY KEY (id_proveedor, id_evento, id_tipo_cerveza, id_presentacion, id_cerveza);


--
-- Name: inventario inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_pkey PRIMARY KEY (id_inventario);


--
-- Name: invitado_evento invitado_evento_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.invitado_evento
    ADD CONSTRAINT invitado_evento_pkey PRIMARY KEY (id_invitado, id_evento);


--
-- Name: invitado invitado_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.invitado
    ADD CONSTRAINT invitado_pkey PRIMARY KEY (id_invitado);


--
-- Name: lugar lugar_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.lugar
    ADD CONSTRAINT lugar_pkey PRIMARY KEY (id_lugar);


--
-- Name: membresia membresia_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.membresia
    ADD CONSTRAINT membresia_pkey PRIMARY KEY (id_membresia);


--
-- Name: metodo_pago metodo_pago_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.metodo_pago
    ADD CONSTRAINT metodo_pago_pkey PRIMARY KEY (id_metodo);


--
-- Name: orden_reposicion_anaquel orden_reposicion_anaquel_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.orden_reposicion_anaquel
    ADD CONSTRAINT orden_reposicion_anaquel_pkey PRIMARY KEY (id_orden_reposicion);


--
-- Name: orden_reposicion_estatus orden_reposicion_estatus_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.orden_reposicion_estatus
    ADD CONSTRAINT orden_reposicion_estatus_pkey PRIMARY KEY (id_orden_reposicion, id_proveedor, id_departamento, id_estatus);


--
-- Name: orden_reposicion orden_reposicion_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.orden_reposicion
    ADD CONSTRAINT orden_reposicion_pkey PRIMARY KEY (id_orden_reposicion);


--
-- Name: orden_reposicion orden_reposicion_unq; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.orden_reposicion
    ADD CONSTRAINT orden_reposicion_unq UNIQUE (id_orden_reposicion, id_proveedor, id_departamento);


--
-- Name: pago_compra pago_compra_metodo_compra_unique; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_compra
    ADD CONSTRAINT pago_compra_metodo_compra_unique UNIQUE (metodo_id, compra_id);


--
-- Name: pago_cuota_afiliacion pago_cuota_afiliacion_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_cuota_afiliacion
    ADD CONSTRAINT pago_cuota_afiliacion_pkey PRIMARY KEY (metodo_id, cuota_id);


--
-- Name: pago_evento pago_evento_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_evento
    ADD CONSTRAINT pago_evento_pkey PRIMARY KEY (metodo_id, evento_id, id_cliente_natural);


--
-- Name: pago_orden_reposicion pago_orden_reposicion_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_orden_reposicion
    ADD CONSTRAINT pago_orden_reposicion_pkey PRIMARY KEY (id_pago);


--
-- Name: persona_contacto persona_contacto_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.persona_contacto
    ADD CONSTRAINT persona_contacto_pkey PRIMARY KEY (id_contacto);


--
-- Name: presentacion_cerveza presentacion_cerveza_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.presentacion_cerveza
    ADD CONSTRAINT presentacion_cerveza_pkey PRIMARY KEY (id_presentacion, id_cerveza);


--
-- Name: presentacion presentacion_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.presentacion
    ADD CONSTRAINT presentacion_pkey PRIMARY KEY (id_presentacion);


--
-- Name: privilegio privilegio_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.privilegio
    ADD CONSTRAINT privilegio_pkey PRIMARY KEY (id_privilegio);


--
-- Name: promocion promocion_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.promocion
    ADD CONSTRAINT promocion_pkey PRIMARY KEY (id_promocion);


--
-- Name: proveedor proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (id_proveedor);


--
-- Name: punto_cliente punto_cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.punto_cliente
    ADD CONSTRAINT punto_cliente_pkey PRIMARY KEY (id_punto_cliente);


--
-- Name: punto punto_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.punto
    ADD CONSTRAINT punto_pkey PRIMARY KEY (id_metodo);


--
-- Name: receta_ingrediente receta_ingrediente_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.receta_ingrediente
    ADD CONSTRAINT receta_ingrediente_pkey PRIMARY KEY (id_receta, id_ingrediente);


--
-- Name: receta receta_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT receta_pkey PRIMARY KEY (id_receta);


--
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id_rol);


--
-- Name: rol_privilegio rol_privilegio_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.rol_privilegio
    ADD CONSTRAINT rol_privilegio_pkey PRIMARY KEY (id_rol, id_privilegio);


--
-- Name: tarjeta_credito tarjeta_credito_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tarjeta_credito
    ADD CONSTRAINT tarjeta_credito_pkey PRIMARY KEY (id_metodo);


--
-- Name: tarjeta_debito tarjeta_debito_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tarjeta_debito
    ADD CONSTRAINT tarjeta_debito_pkey PRIMARY KEY (id_metodo);


--
-- Name: tasa tasa_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tasa
    ADD CONSTRAINT tasa_pkey PRIMARY KEY (id_tasa);


--
-- Name: telefono telefono_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_pkey PRIMARY KEY (id_telefono);


--
-- Name: tienda_fisica tienda_fisica_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tienda_fisica
    ADD CONSTRAINT tienda_fisica_pkey PRIMARY KEY (id_tienda_fisica);


--
-- Name: tienda_web tienda_web_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tienda_web
    ADD CONSTRAINT tienda_web_pkey PRIMARY KEY (id_tienda_web);


--
-- Name: tipo_actividad tipo_actividad_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tipo_actividad
    ADD CONSTRAINT tipo_actividad_pkey PRIMARY KEY (id_tipo_actividad);


--
-- Name: tipo_cerveza tipo_cerveza_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tipo_cerveza
    ADD CONSTRAINT tipo_cerveza_pkey PRIMARY KEY (id_tipo_cerveza);


--
-- Name: tipo_invitado tipo_invitado_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tipo_invitado
    ADD CONSTRAINT tipo_invitado_pkey PRIMARY KEY (id_tipo_invitado);


--
-- Name: tipoevento tipoevento_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tipoevento
    ADD CONSTRAINT tipoevento_pkey PRIMARY KEY (id_tipo_evento);


--
-- Name: ubicacion_tienda ubicacion_tienda_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.ubicacion_tienda
    ADD CONSTRAINT ubicacion_tienda_pkey PRIMARY KEY (id_ubicacion);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- Name: vacacion vacacion_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.vacacion
    ADD CONSTRAINT vacacion_pkey PRIMARY KEY (id_vacacion);


--
-- Name: venta_evento venta_evento_pkey; Type: CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.venta_evento
    ADD CONSTRAINT venta_evento_pkey PRIMARY KEY (evento_id, id_cliente_natural);


--
-- Name: idx_detalle_compra_empleado; Type: INDEX; Schema: public; Owner: daniel_bd
--

CREATE INDEX idx_detalle_compra_empleado ON public.detalle_compra USING btree (id_empleado);


--
-- Name: detalle_orden_reposicion FK para detalle orden_repo; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.detalle_orden_reposicion
    ADD CONSTRAINT "FK para detalle orden_repo" FOREIGN KEY (id_orden_reposicion, id_proveedor, id_departamento) REFERENCES public.orden_reposicion(id_orden_reposicion, id_proveedor, id_departamento);


--
-- Name: actividad actividad_invitado_evento_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.actividad
    ADD CONSTRAINT actividad_invitado_evento_fk FOREIGN KEY (invitado_evento_invitado_id_invitado, invitado_evento_evento_id_evento) REFERENCES public.invitado_evento(id_invitado, id_evento);


--
-- Name: actividad actividad_tipo_actividad_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.actividad
    ADD CONSTRAINT actividad_tipo_actividad_fk FOREIGN KEY (tipo_actividad_id_tipo_actividad) REFERENCES public.tipo_actividad(id_tipo_actividad);


--
-- Name: asistencia asistencia_empleado_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.asistencia
    ADD CONSTRAINT asistencia_empleado_fk FOREIGN KEY (empleado_id_empleado) REFERENCES public.empleado(id_empleado);


--
-- Name: beneficio_depto_empleado beneficio_departamento_empleado_beneficio_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.beneficio_depto_empleado
    ADD CONSTRAINT beneficio_departamento_empleado_beneficio_fk FOREIGN KEY (id_beneficio) REFERENCES public.beneficio(id_beneficio);


--
-- Name: beneficio_depto_empleado beneficio_departamento_empleado_departamento_empleado_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.beneficio_depto_empleado
    ADD CONSTRAINT beneficio_departamento_empleado_departamento_empleado_fk FOREIGN KEY (id_empleado, id_departamento) REFERENCES public.departamento_empleado(id_empleado, id_departamento);


--
-- Name: caracteristica_especifica caracteristica_especifica_caracteristica_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.caracteristica_especifica
    ADD CONSTRAINT caracteristica_especifica_caracteristica_fk FOREIGN KEY (id_caracteristica) REFERENCES public.caracteristica(id_caracteristica);


--
-- Name: caracteristica_especifica caracteristica_especifica_tipo_cerveza_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.caracteristica_especifica
    ADD CONSTRAINT caracteristica_especifica_tipo_cerveza_fk FOREIGN KEY (id_tipo_cerveza) REFERENCES public.tipo_cerveza(id_tipo_cerveza);


--
-- Name: cerveza cerveza_proveedor_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cerveza
    ADD CONSTRAINT cerveza_proveedor_fk FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id_proveedor);


--
-- Name: cerveza cerveza_tipo_cerveza_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cerveza
    ADD CONSTRAINT cerveza_tipo_cerveza_fk FOREIGN KEY (id_tipo_cerveza) REFERENCES public.tipo_cerveza(id_tipo_cerveza);


--
-- Name: cheque cheque_id_metodo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cheque
    ADD CONSTRAINT cheque_id_metodo_fkey FOREIGN KEY (id_metodo) REFERENCES public.metodo_pago(id_metodo);


--
-- Name: cheque cheque_metodo_pago_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cheque
    ADD CONSTRAINT cheque_metodo_pago_fk FOREIGN KEY (id_metodo) REFERENCES public.metodo_pago(id_metodo);


--
-- Name: cliente_juridico cliente_juridico_lugar_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cliente_juridico
    ADD CONSTRAINT cliente_juridico_lugar_fk FOREIGN KEY (lugar_id_lugar) REFERENCES public.lugar(id_lugar);


--
-- Name: cliente_juridico cliente_juridico_lugar_fkv2; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cliente_juridico
    ADD CONSTRAINT cliente_juridico_lugar_fkv2 FOREIGN KEY (lugar_id_lugar2) REFERENCES public.lugar(id_lugar);


--
-- Name: cliente_natural cliente_natural_lugar_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cliente_natural
    ADD CONSTRAINT cliente_natural_lugar_fk FOREIGN KEY (lugar_id_lugar) REFERENCES public.lugar(id_lugar);


--
-- Name: compra compra_cliente_j_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_cliente_j_fk FOREIGN KEY (id_cliente_juridico) REFERENCES public.cliente_juridico(id_cliente);


--
-- Name: compra compra_cliente_n_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_cliente_n_fk FOREIGN KEY (id_cliente_natural) REFERENCES public.cliente_natural(id_cliente);


--
-- Name: compra_estatus compra_estatus_compra_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.compra_estatus
    ADD CONSTRAINT compra_estatus_compra_fk FOREIGN KEY (compra_id_compra) REFERENCES public.compra(id_compra);


--
-- Name: compra_estatus compra_estatus_estatus_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.compra_estatus
    ADD CONSTRAINT compra_estatus_estatus_fk FOREIGN KEY (estatus_id_estatus) REFERENCES public.estatus(id_estatus);


--
-- Name: compra compra_tienda_fisica_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_tienda_fisica_fk FOREIGN KEY (tienda_fisica_id_tienda) REFERENCES public.tienda_fisica(id_tienda_fisica);


--
-- Name: compra compra_tienda_web_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_tienda_web_fk FOREIGN KEY (tienda_web_id_tienda) REFERENCES public.tienda_web(id_tienda_web);


--
-- Name: compra compra_usuario_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_usuario_fk FOREIGN KEY (usuario_id_usuario) REFERENCES public.usuario(id_usuario);


--
-- Name: correo correo_cliente_j_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.correo
    ADD CONSTRAINT correo_cliente_j_fk FOREIGN KEY (id_cliente_juridico) REFERENCES public.cliente_juridico(id_cliente);


--
-- Name: correo correo_cliente_n_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.correo
    ADD CONSTRAINT correo_cliente_n_fk FOREIGN KEY (id_cliente_natural) REFERENCES public.cliente_natural(id_cliente);


--
-- Name: correo correo_empleado_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.correo
    ADD CONSTRAINT correo_empleado_fk FOREIGN KEY (id_empleado) REFERENCES public.empleado(id_empleado);


--
-- Name: correo correo_proveedor_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.correo
    ADD CONSTRAINT correo_proveedor_fk FOREIGN KEY (id_proveedor_proveedor) REFERENCES public.proveedor(id_proveedor);


--
-- Name: cuota_afiliacion cuota_afiliacion_membresia_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.cuota_afiliacion
    ADD CONSTRAINT cuota_afiliacion_membresia_fk FOREIGN KEY (membresia_id_membresia) REFERENCES public.membresia(id_membresia);


--
-- Name: departamento_empleado departamento_empleado_cargo_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.departamento_empleado
    ADD CONSTRAINT departamento_empleado_cargo_fk FOREIGN KEY (id_cargo) REFERENCES public.cargo(id_cargo);


--
-- Name: departamento_empleado departamento_empleado_departamento_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.departamento_empleado
    ADD CONSTRAINT departamento_empleado_departamento_fk FOREIGN KEY (id_departamento) REFERENCES public.departamento(id_departamento);


--
-- Name: departamento_empleado departamento_empleado_empleado_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.departamento_empleado
    ADD CONSTRAINT departamento_empleado_empleado_fk FOREIGN KEY (id_empleado) REFERENCES public.empleado(id_empleado);


--
-- Name: descuento descuento_presentacion_cerveza_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.descuento
    ADD CONSTRAINT descuento_presentacion_cerveza_fk FOREIGN KEY (id_presentacion, id_cerveza) REFERENCES public.presentacion_cerveza(id_presentacion, id_cerveza);


--
-- Name: descuento descuento_promocion_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.descuento
    ADD CONSTRAINT descuento_promocion_fk FOREIGN KEY (id_promocion) REFERENCES public.promocion(id_promocion);


--
-- Name: detalle_compra detalle_compra_compra_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT detalle_compra_compra_fk FOREIGN KEY (id_compra) REFERENCES public.compra(id_compra);


--
-- Name: detalle_compra detalle_compra_empleado_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT detalle_compra_empleado_fk FOREIGN KEY (id_empleado) REFERENCES public.empleado(id_empleado);


--
-- Name: detalle_compra detalle_compra_inventario_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT detalle_compra_inventario_fk FOREIGN KEY (id_inventario) REFERENCES public.inventario(id_inventario);


--
-- Name: detalle_orden_reposicion_anaquel detalle_orden_reposicion_anaquel_inventario_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.detalle_orden_reposicion_anaquel
    ADD CONSTRAINT detalle_orden_reposicion_anaquel_inventario_fk FOREIGN KEY (id_inventario) REFERENCES public.inventario(id_inventario);


--
-- Name: detalle_orden_reposicion_anaquel detalle_orden_reposicion_anaquel_orden_reposicion_anaquel_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.detalle_orden_reposicion_anaquel
    ADD CONSTRAINT detalle_orden_reposicion_anaquel_orden_reposicion_anaquel_fk FOREIGN KEY (id_orden_reposicion) REFERENCES public.orden_reposicion_anaquel(id_orden_reposicion);


--
-- Name: detalle_orden_reposicion detalle_orden_reposicion_presentacion_cerveza_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.detalle_orden_reposicion
    ADD CONSTRAINT detalle_orden_reposicion_presentacion_cerveza_fk FOREIGN KEY (id_presentacion, id_cerveza) REFERENCES public.presentacion_cerveza(id_presentacion, id_cerveza);


--
-- Name: detalle_venta_evento detalle_venta_evento_inventario_evento_proveedor_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.detalle_venta_evento
    ADD CONSTRAINT detalle_venta_evento_inventario_evento_proveedor_fk FOREIGN KEY (id_proveedor, id_evento, id_tipo_cerveza, id_presentacion, id_cerveza) REFERENCES public.inventario_evento_proveedor(id_proveedor, id_evento, id_tipo_cerveza, id_presentacion, id_cerveza);


--
-- Name: detalle_venta_evento detalle_venta_evento_venta_evento_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.detalle_venta_evento
    ADD CONSTRAINT detalle_venta_evento_venta_evento_fk FOREIGN KEY (id_evento, id_cliente_natural) REFERENCES public.venta_evento(evento_id, id_cliente_natural);


--
-- Name: efectivo efectivo_id_metodo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.efectivo
    ADD CONSTRAINT efectivo_id_metodo_fkey FOREIGN KEY (id_metodo) REFERENCES public.metodo_pago(id_metodo);


--
-- Name: efectivo efectivo_metodo_pago_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.efectivo
    ADD CONSTRAINT efectivo_metodo_pago_fk FOREIGN KEY (id_metodo) REFERENCES public.metodo_pago(id_metodo);


--
-- Name: empleado empleado_lugar_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_lugar_fk FOREIGN KEY (lugar_id_lugar) REFERENCES public.lugar(id_lugar);


--
-- Name: estatus_orden_anaquel estatus_orden_reposicion_anaquel_estatus_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.estatus_orden_anaquel
    ADD CONSTRAINT estatus_orden_reposicion_anaquel_estatus_fk FOREIGN KEY (id_estatus) REFERENCES public.estatus(id_estatus);


--
-- Name: estatus_orden_anaquel estatus_orden_reposicion_anaquel_orden_reposicion_anaquel_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.estatus_orden_anaquel
    ADD CONSTRAINT estatus_orden_reposicion_anaquel_orden_reposicion_anaquel_fk FOREIGN KEY (id_orden_reposicion) REFERENCES public.orden_reposicion_anaquel(id_orden_reposicion);


--
-- Name: evento evento_lugar_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.evento
    ADD CONSTRAINT evento_lugar_fk FOREIGN KEY (lugar_id_lugar) REFERENCES public.lugar(id_lugar);


--
-- Name: evento_proveedor evento_proveedor_evento_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.evento_proveedor
    ADD CONSTRAINT evento_proveedor_evento_fk FOREIGN KEY (id_evento) REFERENCES public.evento(id_evento);


--
-- Name: evento_proveedor evento_proveedor_proveedor_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.evento_proveedor
    ADD CONSTRAINT evento_proveedor_proveedor_fk FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id_proveedor);


--
-- Name: evento evento_tipoevento_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.evento
    ADD CONSTRAINT evento_tipoevento_fk FOREIGN KEY (tipo_evento_id) REFERENCES public.tipoevento(id_tipo_evento);


--
-- Name: fermentacion fermentacion_receta_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.fermentacion
    ADD CONSTRAINT fermentacion_receta_fk FOREIGN KEY (receta_id_receta) REFERENCES public.receta(id_receta);


--
-- Name: horario_empleado horario_empleado_empleado_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.horario_empleado
    ADD CONSTRAINT horario_empleado_empleado_fk FOREIGN KEY (id_empleado) REFERENCES public.empleado(id_empleado);


--
-- Name: horario_empleado horario_empleado_horario_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.horario_empleado
    ADD CONSTRAINT horario_empleado_horario_fk FOREIGN KEY (id_horario) REFERENCES public.horario(id_horario);


--
-- Name: horario_evento horario_evento_evento_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.horario_evento
    ADD CONSTRAINT horario_evento_evento_fk FOREIGN KEY (id_evento) REFERENCES public.evento(id_evento);


--
-- Name: horario_evento horario_evento_horario_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.horario_evento
    ADD CONSTRAINT horario_evento_horario_fk FOREIGN KEY (id_horario) REFERENCES public.horario(id_horario);


--
-- Name: ingrediente ingrediente_ingrediente_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.ingrediente
    ADD CONSTRAINT ingrediente_ingrediente_fk FOREIGN KEY (id_ingrediente) REFERENCES public.ingrediente(id_ingrediente);


--
-- Name: instruccion instruccion_receta_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.instruccion
    ADD CONSTRAINT instruccion_receta_fk FOREIGN KEY (receta_id) REFERENCES public.receta(id_receta);


--
-- Name: inventario_evento_proveedor inventario_evento_proveedor_evento_proveedor_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.inventario_evento_proveedor
    ADD CONSTRAINT inventario_evento_proveedor_evento_proveedor_fk FOREIGN KEY (id_proveedor, id_evento) REFERENCES public.evento_proveedor(id_proveedor, id_evento);


--
-- Name: inventario_evento_proveedor inventario_evento_proveedor_presentacion_cerveza_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.inventario_evento_proveedor
    ADD CONSTRAINT inventario_evento_proveedor_presentacion_cerveza_fk FOREIGN KEY (id_presentacion, id_cerveza) REFERENCES public.presentacion_cerveza(id_presentacion, id_cerveza);


--
-- Name: inventario inventario_presentacion_cerveza_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_presentacion_cerveza_fk FOREIGN KEY (id_presentacion, id_cerveza) REFERENCES public.presentacion_cerveza(id_presentacion, id_cerveza);


--
-- Name: inventario inventario_tienda_fisica_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_tienda_fisica_fk FOREIGN KEY (id_tienda_fisica) REFERENCES public.tienda_fisica(id_tienda_fisica);


--
-- Name: inventario inventario_tienda_web_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_tienda_web_fk FOREIGN KEY (id_tienda_web) REFERENCES public.tienda_web(id_tienda_web);


--
-- Name: inventario inventario_ubicacion_tienda_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_ubicacion_tienda_fk FOREIGN KEY (id_ubicacion) REFERENCES public.ubicacion_tienda(id_ubicacion);


--
-- Name: invitado_evento invitado_evento_evento_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.invitado_evento
    ADD CONSTRAINT invitado_evento_evento_fk FOREIGN KEY (id_evento) REFERENCES public.evento(id_evento);


--
-- Name: invitado_evento invitado_evento_invitado_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.invitado_evento
    ADD CONSTRAINT invitado_evento_invitado_fk FOREIGN KEY (id_invitado) REFERENCES public.invitado(id_invitado);


--
-- Name: invitado invitado_lugar_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.invitado
    ADD CONSTRAINT invitado_lugar_fk FOREIGN KEY (lugar_id) REFERENCES public.lugar(id_lugar);


--
-- Name: invitado invitado_tipo_invitado_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.invitado
    ADD CONSTRAINT invitado_tipo_invitado_fk FOREIGN KEY (tipo_invitado_id) REFERENCES public.tipo_invitado(id_tipo_invitado);


--
-- Name: lugar lugar_lugar_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.lugar
    ADD CONSTRAINT lugar_lugar_fk FOREIGN KEY (id_lugar) REFERENCES public.lugar(id_lugar);


--
-- Name: membresia membresia_proveedor_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.membresia
    ADD CONSTRAINT membresia_proveedor_fk FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id_proveedor);


--
-- Name: metodo_pago metodo_pago_id_cliente_juridico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.metodo_pago
    ADD CONSTRAINT metodo_pago_id_cliente_juridico_fkey FOREIGN KEY (id_cliente_juridico) REFERENCES public.cliente_juridico(id_cliente);


--
-- Name: metodo_pago metodo_pago_id_cliente_natural_fkey; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.metodo_pago
    ADD CONSTRAINT metodo_pago_id_cliente_natural_fkey FOREIGN KEY (id_cliente_natural) REFERENCES public.cliente_natural(id_cliente);


--
-- Name: orden_reposicion orden_reposicion_depto_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.orden_reposicion
    ADD CONSTRAINT orden_reposicion_depto_fk FOREIGN KEY (id_departamento) REFERENCES public.departamento(id_departamento);


--
-- Name: orden_reposicion_estatus orden_reposicion_estatus_estatus_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.orden_reposicion_estatus
    ADD CONSTRAINT orden_reposicion_estatus_estatus_fk FOREIGN KEY (id_estatus) REFERENCES public.estatus(id_estatus);


--
-- Name: orden_reposicion_estatus orden_reposicion_estatus_orden_reposicion_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.orden_reposicion_estatus
    ADD CONSTRAINT orden_reposicion_estatus_orden_reposicion_fk FOREIGN KEY (id_orden_reposicion, id_proveedor, id_departamento) REFERENCES public.orden_reposicion(id_orden_reposicion, id_proveedor, id_departamento);


--
-- Name: orden_reposicion orden_reposicion_proveedor_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.orden_reposicion
    ADD CONSTRAINT orden_reposicion_proveedor_fk FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id_proveedor);


--
-- Name: pago_compra pago_compra_compra_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_compra
    ADD CONSTRAINT pago_compra_compra_fk FOREIGN KEY (compra_id) REFERENCES public.compra(id_compra);


--
-- Name: pago_compra pago_compra_compra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_compra
    ADD CONSTRAINT pago_compra_compra_id_fkey FOREIGN KEY (compra_id) REFERENCES public.compra(id_compra);


--
-- Name: pago_compra pago_compra_metodo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_compra
    ADD CONSTRAINT pago_compra_metodo_id_fkey FOREIGN KEY (metodo_id) REFERENCES public.metodo_pago(id_metodo);


--
-- Name: pago_compra pago_compra_metodo_pago_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_compra
    ADD CONSTRAINT pago_compra_metodo_pago_fk FOREIGN KEY (metodo_id) REFERENCES public.metodo_pago(id_metodo);


--
-- Name: pago_compra pago_compra_tasa_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_compra
    ADD CONSTRAINT pago_compra_tasa_fk FOREIGN KEY (tasa_id) REFERENCES public.tasa(id_tasa);


--
-- Name: pago_compra pago_compra_tasa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_compra
    ADD CONSTRAINT pago_compra_tasa_id_fkey FOREIGN KEY (tasa_id) REFERENCES public.tasa(id_tasa);


--
-- Name: pago_cuota_afiliacion pago_cuota_afiliacion_cuota_afiliacion_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_cuota_afiliacion
    ADD CONSTRAINT pago_cuota_afiliacion_cuota_afiliacion_fk FOREIGN KEY (cuota_id) REFERENCES public.cuota_afiliacion(id_cuota);


--
-- Name: pago_cuota_afiliacion pago_cuota_afiliacion_metodo_pago_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_cuota_afiliacion
    ADD CONSTRAINT pago_cuota_afiliacion_metodo_pago_fk FOREIGN KEY (metodo_id) REFERENCES public.metodo_pago(id_metodo);


--
-- Name: pago_cuota_afiliacion pago_cuota_afiliacion_tasa_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_cuota_afiliacion
    ADD CONSTRAINT pago_cuota_afiliacion_tasa_fk FOREIGN KEY (tasa_id) REFERENCES public.tasa(id_tasa);


--
-- Name: pago_evento pago_evento_metodo_pago_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_evento
    ADD CONSTRAINT pago_evento_metodo_pago_fk FOREIGN KEY (metodo_id) REFERENCES public.metodo_pago(id_metodo);


--
-- Name: pago_evento pago_evento_tasa_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_evento
    ADD CONSTRAINT pago_evento_tasa_fk FOREIGN KEY (tasa_id) REFERENCES public.tasa(id_tasa);


--
-- Name: pago_evento pago_evento_venta_evento_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_evento
    ADD CONSTRAINT pago_evento_venta_evento_fk FOREIGN KEY (evento_id, id_cliente_natural) REFERENCES public.venta_evento(evento_id, id_cliente_natural);


--
-- Name: pago_orden_reposicion pago_orden_reposicion_orden_reposicion_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.pago_orden_reposicion
    ADD CONSTRAINT pago_orden_reposicion_orden_reposicion_fk FOREIGN KEY (id_orden_reposicion, id_proveedor, id_departamento) REFERENCES public.orden_reposicion(id_orden_reposicion, id_proveedor, id_departamento);


--
-- Name: persona_contacto persona_contacto_cliente_juridico_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.persona_contacto
    ADD CONSTRAINT persona_contacto_cliente_juridico_fk FOREIGN KEY (id_cliente_juridico) REFERENCES public.cliente_juridico(id_cliente);


--
-- Name: persona_contacto persona_contacto_proveedor_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.persona_contacto
    ADD CONSTRAINT persona_contacto_proveedor_fk FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id_proveedor);


--
-- Name: presentacion_cerveza presentacion_cerveza_cerveza_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.presentacion_cerveza
    ADD CONSTRAINT presentacion_cerveza_cerveza_fk FOREIGN KEY (id_cerveza) REFERENCES public.cerveza(id_cerveza);


--
-- Name: presentacion_cerveza presentacion_cerveza_presentacion_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.presentacion_cerveza
    ADD CONSTRAINT presentacion_cerveza_presentacion_fk FOREIGN KEY (id_presentacion) REFERENCES public.presentacion(id_presentacion);


--
-- Name: promocion promocion_departamento_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.promocion
    ADD CONSTRAINT promocion_departamento_fk FOREIGN KEY (id_departamento) REFERENCES public.departamento(id_departamento);


--
-- Name: promocion promocion_usuario_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.promocion
    ADD CONSTRAINT promocion_usuario_fk FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);


--
-- Name: proveedor proveedor_lugar_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_lugar_fk FOREIGN KEY (id_lugar) REFERENCES public.lugar(id_lugar);


--
-- Name: proveedor proveedor_lugar_fkv2; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_lugar_fkv2 FOREIGN KEY (id_lugar) REFERENCES public.lugar(id_lugar);


--
-- Name: punto_cliente punto_cliente_cliente_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.punto_cliente
    ADD CONSTRAINT punto_cliente_cliente_fk FOREIGN KEY (id_cliente_natural) REFERENCES public.cliente_natural(id_cliente);


--
-- Name: punto_cliente punto_cliente_id_cliente_natural_fkey; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.punto_cliente
    ADD CONSTRAINT punto_cliente_id_cliente_natural_fkey FOREIGN KEY (id_cliente_natural) REFERENCES public.cliente_natural(id_cliente);


--
-- Name: punto_cliente punto_cliente_id_metodo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.punto_cliente
    ADD CONSTRAINT punto_cliente_id_metodo_fkey FOREIGN KEY (id_metodo) REFERENCES public.punto(id_metodo);


--
-- Name: punto_cliente punto_cliente_punto_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.punto_cliente
    ADD CONSTRAINT punto_cliente_punto_fk FOREIGN KEY (id_metodo) REFERENCES public.punto(id_metodo);


--
-- Name: punto punto_id_metodo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.punto
    ADD CONSTRAINT punto_id_metodo_fkey FOREIGN KEY (id_metodo) REFERENCES public.metodo_pago(id_metodo);


--
-- Name: punto punto_metodo_pago_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.punto
    ADD CONSTRAINT punto_metodo_pago_fk FOREIGN KEY (id_metodo) REFERENCES public.metodo_pago(id_metodo);


--
-- Name: receta_ingrediente receta_ingrediente_ingrediente_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.receta_ingrediente
    ADD CONSTRAINT receta_ingrediente_ingrediente_fk FOREIGN KEY (id_ingrediente) REFERENCES public.ingrediente(id_ingrediente);


--
-- Name: receta_ingrediente receta_ingrediente_receta_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.receta_ingrediente
    ADD CONSTRAINT receta_ingrediente_receta_fk FOREIGN KEY (id_receta) REFERENCES public.receta(id_receta);


--
-- Name: receta receta_tipo_cerveza_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.receta
    ADD CONSTRAINT receta_tipo_cerveza_fk FOREIGN KEY (id_tipo_cerveza) REFERENCES public.tipo_cerveza(id_tipo_cerveza);


--
-- Name: rol_privilegio rol_privilegio_rol_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.rol_privilegio
    ADD CONSTRAINT rol_privilegio_rol_fk FOREIGN KEY (id_rol) REFERENCES public.rol(id_rol);


--
-- Name: rol_privilegio rpl_privilegio_privilegio_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.rol_privilegio
    ADD CONSTRAINT rpl_privilegio_privilegio_fk FOREIGN KEY (id_privilegio) REFERENCES public.privilegio(id_privilegio);


--
-- Name: tarjeta_credito tarjeta_credito_id_metodo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tarjeta_credito
    ADD CONSTRAINT tarjeta_credito_id_metodo_fkey FOREIGN KEY (id_metodo) REFERENCES public.metodo_pago(id_metodo);


--
-- Name: tarjeta_credito tarjeta_credito_metodo_pago_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tarjeta_credito
    ADD CONSTRAINT tarjeta_credito_metodo_pago_fk FOREIGN KEY (id_metodo) REFERENCES public.metodo_pago(id_metodo);


--
-- Name: tarjeta_debito tarjeta_debito_id_metodo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tarjeta_debito
    ADD CONSTRAINT tarjeta_debito_id_metodo_fkey FOREIGN KEY (id_metodo) REFERENCES public.metodo_pago(id_metodo);


--
-- Name: tarjeta_debito tarjeta_debito_metodo_pago_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tarjeta_debito
    ADD CONSTRAINT tarjeta_debito_metodo_pago_fk FOREIGN KEY (id_metodo) REFERENCES public.metodo_pago(id_metodo);


--
-- Name: tasa tasa_punto_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tasa
    ADD CONSTRAINT tasa_punto_fk FOREIGN KEY (id_metodo) REFERENCES public.punto(id_metodo);


--
-- Name: telefono telefono_cliente_j_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_cliente_j_fk FOREIGN KEY (id_cliente_juridico) REFERENCES public.cliente_juridico(id_cliente);


--
-- Name: telefono telefono_cliente_n_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_cliente_n_fk FOREIGN KEY (id_cliente_natural) REFERENCES public.cliente_natural(id_cliente);


--
-- Name: telefono telefono_invitado_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_invitado_fk FOREIGN KEY (id_invitado) REFERENCES public.invitado(id_invitado);


--
-- Name: telefono telefono_persona_contacto_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_persona_contacto_fk FOREIGN KEY (id_contacto) REFERENCES public.persona_contacto(id_contacto);


--
-- Name: telefono telefono_proveedor_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT telefono_proveedor_fk FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id_proveedor);


--
-- Name: tienda_fisica tienda_fisica_lugar_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tienda_fisica
    ADD CONSTRAINT tienda_fisica_lugar_fk FOREIGN KEY (id_lugar) REFERENCES public.lugar(id_lugar);


--
-- Name: tipo_cerveza tipo_cerveza_tipo_cerveza_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.tipo_cerveza
    ADD CONSTRAINT tipo_cerveza_tipo_cerveza_fk FOREIGN KEY (id_tipo_cerveza) REFERENCES public.tipo_cerveza(id_tipo_cerveza);


--
-- Name: ubicacion_tienda ubicacion_tienda_tienda_fisica_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.ubicacion_tienda
    ADD CONSTRAINT ubicacion_tienda_tienda_fisica_fk FOREIGN KEY (id_tienda_fisica) REFERENCES public.tienda_fisica(id_tienda_fisica);


--
-- Name: ubicacion_tienda ubicacion_tienda_tienda_web_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.ubicacion_tienda
    ADD CONSTRAINT ubicacion_tienda_tienda_web_fk FOREIGN KEY (id_tienda_web) REFERENCES public.tienda_web(id_tienda_web);


--
-- Name: ubicacion_tienda ubicacion_tienda_ubicacion_tienda_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.ubicacion_tienda
    ADD CONSTRAINT ubicacion_tienda_ubicacion_tienda_fk FOREIGN KEY (ubicacion_tienda_relacion_id) REFERENCES public.ubicacion_tienda(id_ubicacion);


--
-- Name: usuario usuario_cliente_j_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_cliente_j_fk FOREIGN KEY (id_cliente_juridico) REFERENCES public.cliente_juridico(id_cliente);


--
-- Name: usuario usuario_cliente_n_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_cliente_n_fk FOREIGN KEY (id_cliente_natural) REFERENCES public.cliente_natural(id_cliente);


--
-- Name: usuario usuario_empleado_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_empleado_fk FOREIGN KEY (empleado_id) REFERENCES public.empleado(id_empleado);


--
-- Name: usuario usuario_proveedor_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_proveedor_fk FOREIGN KEY (empleado_id) REFERENCES public.proveedor(id_proveedor);


--
-- Name: usuario usuario_rol_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_rol_fk FOREIGN KEY (id_rol) REFERENCES public.rol(id_rol);


--
-- Name: vacacion vacacion_empleado_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.vacacion
    ADD CONSTRAINT vacacion_empleado_fk FOREIGN KEY (empleado_id) REFERENCES public.empleado(id_empleado);


--
-- Name: venta_evento venta_evento_cliente_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.venta_evento
    ADD CONSTRAINT venta_evento_cliente_fk FOREIGN KEY (id_cliente_natural) REFERENCES public.cliente_natural(id_cliente);


--
-- Name: venta_evento venta_evento_evento_fk; Type: FK CONSTRAINT; Schema: public; Owner: daniel_bd
--

ALTER TABLE ONLY public.venta_evento
    ADD CONSTRAINT venta_evento_evento_fk FOREIGN KEY (evento_id) REFERENCES public.evento(id_evento);


--
-- PostgreSQL database dump complete
--

