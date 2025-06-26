-- Función para crear orden de reposición de anaquel cuando inventario baja a 20 o menos
CREATE OR REPLACE FUNCTION crear_orden_reposicion_anaquel() RETURNS TRIGGER AS $$
DECLARE
    inventario_fuente_id INTEGER;
    nueva_orden_id INTEGER;
    estatus_iniciada_id INTEGER;
BEGIN
    -- Solo si la cantidad baja de >20 a <=20 y la ubicación no es nula
    IF (NEW.id_ubicacion IS NOT NULL AND NEW.cantidad <= 20 AND OLD.cantidad > 20) THEN
        -- Buscar el primer inventario fuente en tienda física con la misma presentación y cerveza
        SELECT id_inventario INTO inventario_fuente_id
        FROM Inventario
        WHERE id_tienda_fisica IS NOT NULL
          AND id_presentacion = NEW.id_presentacion
          AND id_cerveza = NEW.id_cerveza
        LIMIT 1;

        IF inventario_fuente_id IS NULL THEN
            RAISE EXCEPTION 'No hay inventario disponible para reposición de anaquel para presentacion % y cerveza %', NEW.id_presentacion, NEW.id_cerveza;
        END IF;

        -- Crear la orden de reposición de anaquel
        INSERT INTO Orden_Reposicion_Anaquel (id_ubicacion, fecha_hora_generacion)
        VALUES (NEW.id_ubicacion, CURRENT_TIMESTAMP)
        RETURNING id_orden_reposicion INTO nueva_orden_id;

        -- Crear el detalle de la orden
        INSERT INTO Detalle_Orden_Reposicion_Anaquel (id_orden_reposicion, id_inventario, cantidad)
        VALUES (nueva_orden_id, inventario_fuente_id, 80);

        SELECT id_estatus INTO estatus_iniciada_id FROM Estatus WHERE nombre ILIKE 'iniciada' LIMIT 1;
        IF estatus_iniciada_id IS NULL THEN
            RAISE EXCEPTION 'No existe un estatus llamado iniciada';
        END IF;

        INSERT INTO Estatus_Orden_Anaquel (id_orden_reposicion, id_estatus, fecha_hora_asignacion)
        VALUES (nueva_orden_id, estatus_iniciada_id, CURRENT_TIMESTAMP);


        -- Restar 80 unidades al inventario fuente
        UPDATE Inventario
        SET cantidad = cantidad - 80
        WHERE id_inventario = inventario_fuente_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para ejecutar la función en UPDATE sobre Inventario
DROP TRIGGER IF EXISTS trigger_reposicion_anaquel ON Inventario;
CREATE TRIGGER trigger_reposicion_anaquel
AFTER UPDATE ON Inventario
FOR EACH ROW
EXECUTE FUNCTION crear_orden_reposicion_anaquel(); 

-- Función para crear orden de reposición a proveedor cuando inventario baja a 100 o menos
CREATE OR REPLACE FUNCTION crear_orden_reposicion_proveedor() RETURNS TRIGGER AS $$
DECLARE
    depto_compras_id INTEGER;
    proveedor_id INTEGER;
    nueva_orden_id INTEGER;
    estatus_iniciada_id INTEGER;
BEGIN
    -- Solo si la cantidad baja de >100 a <=100 y la tienda física no es nula
    IF (NEW.id_tienda_fisica IS NOT NULL AND NEW.cantidad <= 100 AND OLD.cantidad > 100) THEN
        -- Buscar el id del departamento "compras"
        SELECT id_departamento INTO depto_compras_id FROM Departamento WHERE nombre ILIKE 'compras' LIMIT 1;
        IF depto_compras_id IS NULL THEN
            RAISE EXCEPTION 'No existe un departamento llamado compras';
        END IF;

        -- Buscar el primer proveedor
        SELECT id_proveedor INTO proveedor_id FROM Proveedor LIMIT 1;
        IF proveedor_id IS NULL THEN
            RAISE EXCEPTION 'No existe ningún proveedor registrado';
        END IF;

        -- Crear la orden de reposición
        INSERT INTO Orden_Reposicion (id_departamento, id_proveedor, fecha_emision)
        VALUES (depto_compras_id, proveedor_id, CURRENT_DATE)
        RETURNING id_orden_reposicion INTO nueva_orden_id;

        -- Buscar el id del estatus "iniciada"
        SELECT id_estatus INTO estatus_iniciada_id FROM Estatus WHERE nombre ILIKE 'iniciada' LIMIT 1;
        IF estatus_iniciada_id IS NULL THEN
            RAISE EXCEPTION 'No existe un estatus llamado iniciada';
        END IF;

        -- Crear el registro de estatus de la orden
        INSERT INTO Orden_Reposicion_Estatus (id_orden_reposicion, id_proveedor, id_departamento, id_estatus, fecha_asignacion, fecha_fin)
        VALUES (nueva_orden_id, proveedor_id, depto_compras_id, estatus_iniciada_id, CURRENT_DATE, NULL);

        -- Crear el detalle de la orden
        INSERT INTO Detalle_Orden_Reposicion (cantidad, id_orden_reposicion, id_proveedor, id_departamento, precio, id_presentacion, id_cerveza)
        VALUES (10000, nueva_orden_id, proveedor_id, depto_compras_id, 10, NEW.id_presentacion, NEW.id_cerveza);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para ejecutar la función en UPDATE sobre Inventario
DROP TRIGGER IF EXISTS trigger_reposicion_proveedor ON Inventario;
CREATE TRIGGER trigger_reposicion_proveedor
AFTER UPDATE ON Inventario
FOR EACH ROW
EXECUTE FUNCTION crear_orden_reposicion_proveedor(); 