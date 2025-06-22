-- Login function

CREATE OR REPLACE FUNCTION verificar_credenciales(
    p_correo VARCHAR,
    p_contrasena VARCHAR
)
RETURNS TABLE (
    id_usuario INTEGER,
    id_cliente_juridico INTEGER,
    id_cliente_natural INTEGER,
    rol VARCHAR(50),
    fecha_creacion DATE,
    id_proveedor INTEGER,
    empleado_id INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.id_usuario,
        u.id_cliente_juridico,
        u.id_cliente_natural,
        r.nombre AS rol,
        u.fecha_creacion,
        u.id_proveedor,
        u.empleado_id
    FROM
        Usuario u
    JOIN
        Rol r ON u.id_rol = r.id_rol
    JOIN
        Correo c ON (
            (u.id_cliente_natural IS NOT NULL AND c.id_cliente_natural = u.id_cliente_natural)
            OR (u.id_cliente_juridico IS NOT NULL AND c.id_cliente_juridico = u.id_cliente_juridico)
            OR (u.id_proveedor IS NOT NULL AND c.id_proveedor_proveedor = u.id_proveedor)
            OR (u.empleado_id IS NOT NULL AND c.id_empleado = u.empleado_id)
        )
    WHERE
        c.nombre = SPLIT_PART(p_correo, '@', 1) AND c.extension_pag = SPLIT_PART(p_correo, '@', 2)
        AND u.contraseña = p_contrasena;
END;
$$ LANGUAGE plpgsql; 

-- Create cliente juridico function

CREATE OR REPLACE FUNCTION create_cliente_juridico(
  p_rif_cliente INTEGER,
  p_razon_social VARCHAR,
  p_denominacion_comercial VARCHAR,
  p_capital_disponible DECIMAL,
  p_direccion_fiscal TEXT,
  p_direccion_fisica TEXT,
  p_pagina_web VARCHAR,
  p_lugar_id_lugar INTEGER,
  p_lugar_id_lugar2 INTEGER,
  p_correo VARCHAR,
  p_contrasena VARCHAR
) RETURNS VOID AS $$
DECLARE
  new_cliente_id INTEGER;
  new_usuario_id INTEGER;
BEGIN
  INSERT INTO Cliente_Juridico (
    rif_cliente, razon_social, denominacion_comercial, capital_disponible, direccion_fiscal, direccion_fisica, pagina_web, lugar_id_lugar, lugar_id_lugar2
  ) VALUES (
    p_rif_cliente, p_razon_social, p_denominacion_comercial, p_capital_disponible, p_direccion_fiscal, p_direccion_fisica, p_pagina_web, p_lugar_id_lugar, p_lugar_id_lugar2
  ) RETURNING id_cliente INTO new_cliente_id;

  INSERT INTO Usuario (id_cliente_juridico, id_rol, fecha_creacion, contraseña)
  VALUES (new_cliente_id, 2, CURRENT_DATE, p_contrasena)
  RETURNING id_usuario INTO new_usuario_id;

  INSERT INTO Correo (nombre, extension_pag, id_cliente_juridico)
  VALUES (split_part(p_correo, '@', 1), split_part(p_correo, '@', 2), new_cliente_id);
END;
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE FUNCTION create_cliente_natural(
  p_cedula INTEGER,
  p_rif INTEGER,
  p_primer_nombre VARCHAR,
  p_segundo_nombre VARCHAR,
  p_primer_apellido VARCHAR,
  p_segundo_apellido VARCHAR,
  p_correo VARCHAR,
  p_contrasena VARCHAR,
  p_id_lugar INTEGER,
  p_direccion_fisica TEXT
) RETURNS VOID AS $$
DECLARE
  new_cliente_id INTEGER;
  new_usuario_id INTEGER;
BEGIN
  INSERT INTO Cliente_Natural (ci_cliente, rif_cliente , primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, lugar_id_lugar, direccion)
  VALUES (p_cedula, p_rif, p_primer_nombre, p_segundo_nombre, p_primer_apellido, p_segundo_apellido, p_id_lugar, p_direccion_fisica)
  RETURNING id_cliente INTO new_cliente_id;

  INSERT INTO Usuario (id_cliente_natural, id_rol, fecha_creacion, contraseña)
  VALUES (new_cliente_id, 2, CURRENT_DATE, p_contrasena)
  RETURNING id_usuario INTO new_usuario_id;

  INSERT INTO Correo (nombre, extension_pag, id_cliente_natural)
  VALUES (split_part(p_correo, '@', 1), split_part(p_correo, '@', 2), new_cliente_id);
END;
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE FUNCTION create_proveedor(
  p_razon_social VARCHAR,
  p_denominacion VARCHAR,
  p_rif INTEGER,
  p_url_web VARCHAR,
  p_correo VARCHAR,
  p_contrasena VARCHAR,
  p_id_lugar INTEGER,
  p_direccion_fisica TEXT,
  p_id_lugar2 INTEGER,
  p_direccion_fiscal TEXT
) RETURNS VOID AS $$
DECLARE
  new_proveedor_id INTEGER;
  new_usuario_id INTEGER;
BEGIN
  INSERT INTO Proveedor (razon_social, denominacion, rif, url_web, id_lugar, direccion_fisica, id_lugar2, direccion_fiscal)
  VALUES (p_razon_social, p_denominacion, p_rif, p_url_web, p_id_lugar, p_direccion_fisica, p_id_lugar2, p_direccion_fiscal)
  RETURNING id_proveedor INTO new_proveedor_id;

  INSERT INTO Usuario (id_proveedor, id_rol, fecha_creacion, contraseña)
  VALUES (new_proveedor_id, 1, CURRENT_DATE, p_contrasena)
  RETURNING id_usuario INTO new_usuario_id;

  INSERT INTO Correo (nombre, extension_pag, id_usuario)
  VALUES (split_part(p_correo, '@', 1), split_part(p_correo, '@', 2), new_usuario_id);
END;
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE FUNCTION get_usuarios_clientes_juridicos()
RETURNS TABLE (
    id_usuario INTEGER,
    email VARCHAR(100),
    pagina_web VARCHAR(100),
    rif VARCHAR(20),
    razon_social VARCHAR(100),
    denominacion_comercial VARCHAR(100),
    capital_disponible DECIMAL,
    estado_fiscal VARCHAR(100),
    municipio_fiscal VARCHAR(100),
    parroquia_fiscal VARCHAR(100),
    direccion_fiscal_especifica TEXT,
    estado_fisica VARCHAR(100),
    municipio_fisica VARCHAR(100),
    parroquia_fisica VARCHAR(100),
    direccion_fisica_especifica TEXT
) AS $$
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
    -- Física
    LEFT JOIN Lugar l_parroquia_fisica ON cj.lugar_id_lugar = l_parroquia_fisica.id_lugar
    LEFT JOIN Lugar l_municipio_fisica ON l_parroquia_fisica.lugar_relacion_id = l_municipio_fisica.id_lugar AND l_municipio_fisica.tipo = 'Municipio'
    LEFT JOIN Lugar l_estado_fisica ON l_municipio_fisica.lugar_relacion_id = l_estado_fisica.id_lugar AND l_estado_fisica.tipo = 'Estado'
    WHERE u.id_cliente_juridico IS NOT NULL;
END;
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE FUNCTION get_usuarios_clientes_naturales()
RETURNS TABLE (
    id_usuario INTEGER,
    email VARCHAR(100),
    rif VARCHAR(20),
    cedula VARCHAR(20),
    nombre_completo VARCHAR(100),
    estado VARCHAR(100),
    municipio VARCHAR(100),
    parroquia VARCHAR(100),
    direccion_especifica TEXT
) AS $$
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
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE FUNCTION get_usuarios_empleados()
RETURNS TABLE (
    id_usuario INTEGER,
    email VARCHAR(100),
    nombre_completo VARCHAR(100),
    cedula VARCHAR(20),
    estado VARCHAR(100),
    ciudad VARCHAR(100),
    municipio VARCHAR(100),
    direccion_especifica TEXT,
    activo CHAR(1)
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.id_usuario,
        CONCAT(cor.nombre, '@', cor.extension_pag)::VARCHAR(100) AS email,
        CONCAT(e.primer_nombre, ' ', e.segundo_nombre, ' ', e.primer_apellido, ' ', e.segundo_apellido)::VARCHAR(100) AS nombre_completo,
        e.cedula::VARCHAR(20) AS cedula,
        l_estado.nombre::VARCHAR(100) AS estado,
        l_ciudad.nombre::VARCHAR(100) AS ciudad,
        l_municipio.nombre::VARCHAR(100) AS municipio,
        e.direccion AS direccion_especifica,
        e.activo
    FROM Usuario u
    JOIN Empleado e ON u.empleado_id = e.id_empleado
    LEFT JOIN Correo cor ON cor.id_empleado = e.id_empleado
    LEFT JOIN Lugar l_parroquia ON e.lugar_id_lugar = l_parroquia.id_lugar
    LEFT JOIN Lugar l_municipio ON l_parroquia.lugar_relacion_id = l_municipio.id_lugar AND l_municipio.tipo = 'Municipio'
    LEFT JOIN Lugar l_ciudad ON l_municipio.lugar_relacion_id = l_ciudad.id_lugar AND l_ciudad.tipo = 'Ciudad'
    LEFT JOIN Lugar l_estado ON l_ciudad.lugar_relacion_id = l_estado.id_lugar AND l_estado.tipo = 'Estado'
    WHERE u.empleado_id IS NOT NULL;
END;
$$ LANGUAGE plpgsql; 

CREATE OR REPLACE FUNCTION get_usuarios_proveedores()
RETURNS TABLE (
    id_usuario INTEGER,
    email VARCHAR(100),
    pagina_web VARCHAR(200),
    rif VARCHAR(20),
    razon_social VARCHAR(100),
    denominacion_comercial VARCHAR(100),
    estado_fiscal VARCHAR(100),
    municipio_fiscal VARCHAR(100),
    parroquia_fiscal VARCHAR(100),
    direccion_fiscal_especifica TEXT,
    estado_fisica VARCHAR(100),
    municipio_fisica VARCHAR(100),
    parroquia_fisica VARCHAR(100),
    direccion_fisica_especifica TEXT
) AS $$
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
    -- Física
    LEFT JOIN Lugar l_parroquia_fisica ON p.id_lugar = l_parroquia_fisica.id_lugar
    LEFT JOIN Lugar l_municipio_fisica ON l_parroquia_fisica.lugar_relacion_id = l_municipio_fisica.id_lugar AND l_municipio_fisica.tipo = 'Municipio'
    LEFT JOIN Lugar l_estado_fisica ON l_municipio_fisica.lugar_relacion_id = l_estado_fisica.id_lugar AND l_estado_fisica.tipo = 'Estado'
    WHERE u.id_proveedor IS NOT NULL;
END;
$$ LANGUAGE plpgsql; 

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
        COALESCE(ARRAY_AGG(p.nombre ORDER BY p.nombre), '{}')::TEXT[] AS privilegios
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
$$ LANGUAGE plpgsql;

-- Function to create a new role and assign basic privileges
CREATE OR REPLACE FUNCTION create_role(
    p_nombre_rol VARCHAR,
    p_crear BOOLEAN,
    p_eliminar BOOLEAN,
    p_actualizar BOOLEAN,
    p_leer BOOLEAN
) RETURNS VOID AS $$
DECLARE
    new_rol_id INTEGER;
    priv_id INTEGER;
BEGIN
    -- Insert the new role and get its ID
    INSERT INTO Rol (nombre) VALUES (p_nombre_rol) RETURNING id_rol INTO new_rol_id;

    -- Assign 'crear' privilege if selected
    IF p_crear THEN
        SELECT id_privilegio INTO priv_id FROM Privilegio WHERE nombre = 'crear';
        IF FOUND THEN
            INSERT INTO Rol_Privilegio (id_rol, id_privilegio, fecha_asignacion) VALUES (new_rol_id, priv_id, CURRENT_DATE);
        END IF;
    END IF;

    -- Assign 'eliminar' privilege if selected
    IF p_eliminar THEN
        SELECT id_privilegio INTO priv_id FROM Privilegio WHERE nombre = 'eliminar';
        IF FOUND THEN
            INSERT INTO Rol_Privilegio (id_rol, id_privilegio, fecha_asignacion) VALUES (new_rol_id, priv_id, CURRENT_DATE);
        END IF;
    END IF;

    -- Assign 'actualizar' privilege if selected
    IF p_actualizar THEN
        SELECT id_privilegio INTO priv_id FROM Privilegio WHERE nombre = 'actualizar';
        IF FOUND THEN
            INSERT INTO Rol_Privilegio (id_rol, id_privilegio, fecha_asignacion) VALUES (new_rol_id, priv_id, CURRENT_DATE);
        END IF;
    END IF;

    -- Assign 'leer' privilege if selected
    IF p_leer THEN
        SELECT id_privilegio INTO priv_id FROM Privilegio WHERE nombre = 'leer';
        IF FOUND THEN
            INSERT INTO Rol_Privilegio (id_rol, id_privilegio, fecha_asignacion) VALUES (new_rol_id, priv_id, CURRENT_DATE);
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Function to update role privileges
CREATE OR REPLACE FUNCTION update_role_privileges(
    p_id_rol INTEGER,
    p_nombre_rol VARCHAR,
    p_crear BOOLEAN,
    p_eliminar BOOLEAN,
    p_actualizar BOOLEAN,
    p_leer BOOLEAN
) RETURNS VOID AS $$
DECLARE
    priv_id INTEGER;
BEGIN
    -- Update role name if different
    UPDATE Rol SET nombre = p_nombre_rol WHERE id_rol = p_id_rol;
    
    -- Delete all current privileges for this role
    DELETE FROM Rol_Privilegio WHERE id_rol = p_id_rol;
    
    -- Assign 'crear' privilege if selected
    IF p_crear THEN
        SELECT id_privilegio INTO priv_id FROM Privilegio WHERE nombre = 'crear';
        IF FOUND THEN
            INSERT INTO Rol_Privilegio (id_rol, id_privilegio, fecha_asignacion) VALUES (p_id_rol, priv_id, CURRENT_DATE);
        END IF;
    END IF;

    -- Assign 'eliminar' privilege if selected
    IF p_eliminar THEN
        SELECT id_privilegio INTO priv_id FROM Privilegio WHERE nombre = 'eliminar';
        IF FOUND THEN
            INSERT INTO Rol_Privilegio (id_rol, id_privilegio, fecha_asignacion) VALUES (p_id_rol, priv_id, CURRENT_DATE);
        END IF;
    END IF;

    -- Assign 'actualizar' privilege if selected
    IF p_actualizar THEN
        SELECT id_privilegio INTO priv_id FROM Privilegio WHERE nombre = 'actualizar';
        IF FOUND THEN
            INSERT INTO Rol_Privilegio (id_rol, id_privilegio, fecha_asignacion) VALUES (p_id_rol, priv_id, CURRENT_DATE);
        END IF;
    END IF;

    -- Assign 'leer' privilege if selected
    IF p_leer THEN
        SELECT id_privilegio INTO priv_id FROM Privilegio WHERE nombre = 'leer';
        IF FOUND THEN
            INSERT INTO Rol_Privilegio (id_rol, id_privilegio, fecha_asignacion) VALUES (p_id_rol, priv_id, CURRENT_DATE);
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Cambiar el rol de un usuario
CREATE OR REPLACE FUNCTION set_rol_usuario(p_id_usuario INTEGER, p_id_rol INTEGER)
RETURNS VOID AS $$
BEGIN
    UPDATE Usuario SET id_rol = p_id_rol WHERE id_usuario = p_id_usuario;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_empleado(
    p_cedula VARCHAR,
    p_primer_nombre VARCHAR,
    p_segundo_nombre VARCHAR,
    p_primer_apellido VARCHAR,
    p_segundo_apellido VARCHAR,
    p_direccion TEXT,
    p_lugar_id_lugar INTEGER,
    p_correo_nombre VARCHAR,
    p_correo_extension VARCHAR,
    p_contrasena VARCHAR
) RETURNS VOID AS $$
DECLARE
    new_empleado_id INTEGER;
    new_usuario_id INTEGER;
    rol_empleado_id INTEGER;
BEGIN
    -- Buscar el id_rol correspondiente a 'Empleado'
    SELECT id_rol INTO rol_empleado_id FROM Rol WHERE LOWER(nombre) = 'empleado' LIMIT 1;

    -- Insertar en Empleado
    INSERT INTO Empleado (
        cedula, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, direccion, activo, lugar_id_lugar
    ) VALUES (
        p_cedula, p_primer_nombre, p_segundo_nombre, p_primer_apellido, p_segundo_apellido, p_direccion, 'S', p_lugar_id_lugar
    ) RETURNING id_empleado INTO new_empleado_id;

    -- Insertar en Usuario
    INSERT INTO Usuario (
        empleado_id, id_rol, fecha_creacion, contraseña
    ) VALUES (
        new_empleado_id, rol_empleado_id, CURRENT_DATE, p_contrasena
    ) RETURNING id_usuario INTO new_usuario_id;

    -- Insertar en Correo
    INSERT INTO Correo (
        nombre, extension_pag, id_empleado
    ) VALUES (
        p_correo_nombre, p_correo_extension, new_empleado_id
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_ordenes_reposicion_proveedores()
RETURNS TABLE (
    id_orden_reposicion INTEGER,
    nombre_departamento VARCHAR,
    razon_social_proveedor VARCHAR,
    fecha_emision DATE,
    fecha_fin DATE,
    estatus_actual VARCHAR,
    id_estatus_actual INTEGER
) AS $$
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
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_estatus_orden_reposicion(
    p_id_orden_reposicion INTEGER,
    p_id_estatus INTEGER
) RETURNS VOID AS $$
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
$$ LANGUAGE plpgsql;
