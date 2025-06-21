-- Function to get all roles with their associated privileges
CREATE OR REPLACE FUNCTION get_roles()
RETURNS TABLE (
    id_rol INTEGER,
    nombre_rol VARCHAR(50),
    privilegios TEXT[]
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.id_rol,
        r.nombre AS nombre_rol,
        COALESCE(ARRAY_AGG(p.nombre ORDER BY p.nombre), '{}') AS privilegios
    FROM
        Rol r
    LEFT JOIN
        Permiso perm ON r.id_rol = perm.id_rol
    LEFT JOIN
        Privilegio p ON perm.id_privilegio = p.id_privilegio
    GROUP BY
        r.id_rol, r.nombre
    ORDER BY
        r.id_rol;
END;
$$ LANGUAGE plpgsql;

-- Function to create a new role and assign basic privileges
CREATE OR REPLACE FUNCTION create_role(
    p_nombre_rol VARCHAR,
    p_crear BOOLEAN,
    p_eliminar BOOLEAN,
    p_actualizar BOOLEAN,
    p_insertar BOOLEAN
) RETURNS VOID AS $$
DECLARE
    new_rol_id INTEGER;
    priv_id INTEGER;
BEGIN
    -- Insert the new role and get its ID
    INSERT INTO Rol (nombre) VALUES (p_nombre_rol) RETURNING id_rol INTO new_rol_id;

    -- Assign 'Creacion' privilege if selected
    IF p_crear THEN
        SELECT id_privilegio INTO priv_id FROM Privilegio WHERE nombre = 'Creacion';
        IF FOUND THEN
            INSERT INTO Permiso (id_rol, id_privilegio, fecha_asignacion) VALUES (new_rol_id, priv_id, CURRENT_DATE);
        END IF;
    END IF;

    -- Assign 'Eliminacion' privilege if selected
    IF p_eliminar THEN
        SELECT id_privilegio INTO priv_id FROM Privilegio WHERE nombre = 'Eliminacion';
        IF FOUND THEN
            INSERT INTO Permiso (id_rol, id_privilegio, fecha_asignacion) VALUES (new_rol_id, priv_id, CURRENT_DATE);
        END IF;
    END IF;

    -- Assign 'Actualizacion' privilege if selected
    IF p_actualizar THEN
        SELECT id_privilegio INTO priv_id FROM Privilegio WHERE nombre = 'Actualizacion';
        IF FOUND THEN
            INSERT INTO Permiso (id_rol, id_privilegio, fecha_asignacion) VALUES (new_rol_id, priv_id, CURRENT_DATE);
        END IF;
    END IF;

    -- Assign 'Insercion' privilege if selected
    IF p_insertar THEN
        SELECT id_privilegio INTO priv_id FROM Privilegio WHERE nombre = 'Insercion';
        IF FOUND THEN
            INSERT INTO Permiso (id_rol, id_privilegio, fecha_asignacion) VALUES (new_rol_id, priv_id, CURRENT_DATE);
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql; 