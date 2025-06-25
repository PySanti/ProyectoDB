-- Función para crear orden de reposición de anaquel cuando inventario baja a 20 o menos
CREATE OR REPLACE FUNCTION crear_orden_reposicion_anaquel() RETURNS TRIGGER AS $$
DECLARE
    inventario_fuente_id INTEGER;
    nueva_orden_id INTEGER;
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