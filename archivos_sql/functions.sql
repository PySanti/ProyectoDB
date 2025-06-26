-- Login function

CREATE OR REPLACE FUNCTION verificar_credenciales(
    p_correo VARCHAR,
    p_contrasena VARCHAR
)
RETURNS TABLE (
    id_usuario INTEGER,
    id_cliente_juridico INTEGER,
    id_cliente_natural INTEGER,
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

  INSERT INTO Usuario (id_cliente_juridico, fecha_creacion, contraseña)
  VALUES (new_cliente_id,  CURRENT_DATE, p_contrasena)
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

  INSERT INTO Usuario (id_cliente_natural, fecha_creacion, contraseña)
  VALUES (new_cliente_id,  CURRENT_DATE, p_contrasena)
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

  INSERT INTO Usuario (id_proveedor, fecha_creacion, contraseña)
  VALUES (new_proveedor_id,  CURRENT_DATE, p_contrasena)
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
    municipio VARCHAR(100),
    parroquia VARCHAR(100),
    direccion_especifica TEXT,
    activo CHAR(1),
    rol VARCHAR(50)
) AS $$
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

-- Function to get all roles with their associated privileges and tables
CREATE OR REPLACE FUNCTION get_roles()
RETURNS TABLE (
    id_rol INTEGER,
    nombre_rol VARCHAR(50),
    privilegios JSON
) AS $$
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
$$ LANGUAGE plpgsql;

-- Function to create a new role and assign privileges by table
CREATE OR REPLACE FUNCTION create_role(
    p_nombre_rol VARCHAR,
    p_privilegios JSON
) RETURNS VOID AS $$
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
$$ LANGUAGE plpgsql;

-- Function to update role privileges by table
CREATE OR REPLACE FUNCTION update_role_privileges(
    p_id_rol INTEGER,
    p_nombre_rol VARCHAR,
    p_privilegios JSON
) RETURNS VOID AS $$
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
)
RETURNS TABLE (
    usuario_id INTEGER,
    email VARCHAR(100),
    nombre_completo VARCHAR(100),
    cedula VARCHAR(20),
    estado VARCHAR(100),
    municipio VARCHAR(100),
    parroquia VARCHAR(100),
    direccion_especifica TEXT,
    activo CHAR(1),
    rol VARCHAR(50)
) AS $$
DECLARE
    new_empleado_id INTEGER;
    new_usuario_id INTEGER;
    rol_empleado_id INTEGER;
BEGIN
    SELECT id_rol INTO rol_empleado_id FROM Rol WHERE LOWER(nombre) = 'empleado nuevo';
    IF rol_empleado_id IS NULL THEN
        RAISE EXCEPTION 'No se encontró el rol Empleado Nuevo en la tabla Rol';
    END IF;

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

    -- Retornar los datos completos del empleado recién creado, incluyendo el nombre del rol
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

CREATE OR REPLACE FUNCTION get_ordenes_anaquel()
RETURNS TABLE (
    id_orden_reposicion INTEGER,
    fecha_hora_generacion TIMESTAMP,
    estatus_actual VARCHAR,
    id_estatus_actual INTEGER,
    ubicacion_completa TEXT
) AS $$
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
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_estatus_orden_anaquel(
    p_id_orden_reposicion INTEGER,
    p_id_estatus INTEGER
) RETURNS VOID AS $$
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
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_full_location_path(p_location_id INTEGER)
RETURNS TEXT AS $$
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
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_detalle_orden_anaquel(p_id_orden_reposicion INTEGER)
RETURNS TABLE (
    presentacion VARCHAR,
    cerveza VARCHAR,
    cantidad INTEGER
) AS $$
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
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_detalle_orden_proveedor(p_id_orden_reposicion INTEGER)
RETURNS TABLE (
    presentacion VARCHAR,
    cerveza VARCHAR,
    cantidad INTEGER
) AS $$
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
$$ LANGUAGE plpgsql;



-- Funciones para validación de clientes por cédula adaptadas a la estructura real

-- Función para obtener cliente natural por cédula
CREATE OR REPLACE FUNCTION get_cliente_natural_by_cedula(p_cedula INTEGER)
RETURNS TABLE (
    id_cliente INTEGER,
    ci_cliente INTEGER,
    primer_nombre VARCHAR(30),
    segundo_nombre VARCHAR(30),
    primer_apellido VARCHAR(30),
    segundo_apellido VARCHAR(30),
    direccion TEXT,
    lugar_id_lugar INTEGER,
    correo_nombre VARCHAR(50),
    correo_extension VARCHAR(20),
    telefono VARCHAR(20)
) AS $$
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
$$ LANGUAGE plpgsql;

-- Función para obtener cliente jurídico por RIF
CREATE OR REPLACE FUNCTION get_cliente_juridico_by_rif(p_rif INTEGER)
RETURNS TABLE (
    id_cliente INTEGER,
    rif_cliente INTEGER,
    razon_social VARCHAR(50),
    denominacion_comercial VARCHAR(50),
    direccion_fiscal TEXT,
    direccion_fisica TEXT,
    lugar_id_lugar INTEGER,
    correo_nombre VARCHAR(50),
    correo_extension VARCHAR(20),
    telefono VARCHAR(20)
) AS $$
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
$$ LANGUAGE plpgsql;

-- Función para crear cliente natural y su correo/telefono
CREATE OR REPLACE FUNCTION create_cliente_natural_fisica(
    p_ci_cliente INTEGER,
    p_rif_cliente INTEGER,
    p_primer_nombre VARCHAR(30),
    p_segundo_nombre VARCHAR(30),
    p_primer_apellido VARCHAR(30),
    p_segundo_apellido VARCHAR(30),
    p_direccion TEXT,
    p_lugar_id_lugar INTEGER,
    p_correo_nombre VARCHAR(50),
    p_correo_extension VARCHAR(20),
    p_codigo_area VARCHAR(4),
    p_telefono VARCHAR(20)
)
RETURNS INTEGER AS $$
DECLARE
    v_id_cliente INTEGER;
BEGIN
    -- Verificar si el cliente ya existe
    IF EXISTS (SELECT 1 FROM Cliente_Natural WHERE ci_cliente = p_ci_cliente) THEN
        RAISE EXCEPTION 'Ya existe un cliente natural con la cédula %', p_ci_cliente;
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
    
    -- Insertar teléfono
    INSERT INTO Telefono (codigo_area, numero, id_cliente_natural)
    VALUES (p_codigo_area, p_telefono, v_id_cliente);
    
    RETURN v_id_cliente;
END;
$$ LANGUAGE plpgsql;

-- Función para verificar si existe un cliente (natural o jurídico) por documento
CREATE OR REPLACE FUNCTION check_cliente_exists(p_documento INTEGER)
RETURNS BOOLEAN AS $$
BEGIN
    -- Verificar en clientes naturales
    IF EXISTS (SELECT 1 FROM Cliente_Natural WHERE ci_cliente = p_documento) THEN
        RETURN TRUE;
    END IF;
    
    -- Verificar en clientes jurídicos
    IF EXISTS (SELECT 1 FROM Cliente_Juridico WHERE rif_cliente = p_documento) THEN
        RETURN TRUE;
    END IF;
    
    RETURN FALSE;
END;
$$ LANGUAGE plpgsql; 



-- ==============================================================================
-- FUNCIONES PARA EL CATÁLOGO DE PRODUCTOS
-- ==============================================================================

-- Función para obtener productos del catálogo con paginación y ordenamiento
CREATE OR REPLACE FUNCTION obtener_productos_catalogo(
    p_sort_by VARCHAR DEFAULT 'relevance',
    p_page INTEGER DEFAULT 1,
    p_limit INTEGER DEFAULT 9
) RETURNS TABLE (
    id_cerveza INTEGER,
    nombre_cerveza VARCHAR,
    tipo_cerveza VARCHAR,
    min_price DECIMAL(10,2),
    presentaciones JSON
) AS $$
BEGIN
    RETURN QUERY
    WITH UnicoInventario AS (
        SELECT DISTINCT ON (i.id_cerveza, i.id_presentacion)
            i.id_inventario, i.cantidad, i.id_presentacion, i.id_cerveza
        FROM Inventario i
        -- Priorizamos la tienda física si hay múltiples entradas
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
    -- Unimos con nuestro inventario único para evitar duplicados
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
$$ LANGUAGE plpgsql;

-- Función para contar total de productos en el catálogo
CREATE OR REPLACE FUNCTION contar_productos_catalogo() 
RETURNS INTEGER AS $$
DECLARE
    total INTEGER;
BEGIN
    SELECT COUNT(DISTINCT c.id_cerveza) INTO total
    FROM Cerveza c
    JOIN presentacion_cerveza pc ON c.id_cerveza = pc.id_cerveza
    JOIN Inventario i ON c.id_cerveza = i.id_cerveza AND pc.id_presentacion = i.id_presentacion;
    
    RETURN total;
END;
$$ LANGUAGE plpgsql; 


-- =====================================================
-- SISTEMA DE CARRITO DE COMPRAS - REFACTORIZADO
-- =====================================================
-- Este sistema usa Stored Procedures para acciones (CUD)
-- y Funciones para consultas (R).

-- =====================================================
-- INSERTAR ESTATUS NECESARIO PARA EL CARRITO
-- =====================================================

-- Agregar estatus "Pendiente" para carritos (si no existe)


-- =====================================================
-- FUNCIÓN AUXILIAR PARA DETERMINAR TIPO DE COMPRA Y OBTENER CARRITO
-- =====================================================
CREATE OR REPLACE FUNCTION obtener_carrito_por_tipo(
    p_id_usuario INTEGER DEFAULT NULL,
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
    v_id_compra INTEGER;
BEGIN
    -- Determinar el tipo de compra basándose en los parámetros
    IF p_id_cliente_natural IS NOT NULL OR p_id_cliente_juridico IS NOT NULL THEN
        -- Compra en tienda física: usar cliente, NO usuario
        v_id_compra := obtener_o_crear_carrito_usuario(NULL, p_id_cliente_natural, p_id_cliente_juridico);
    ELSE
        -- Compra web: usar usuario, NO cliente
        v_id_compra := obtener_o_crear_carrito_usuario(p_id_usuario, NULL, NULL);
    END IF;
    
    RETURN v_id_compra;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- FUNCIÓN AUXILIAR PARA OBTENER O CREAR CARRITO
-- (Se mantiene como función porque retorna un valor directo)
-- =====================================================

CREATE OR REPLACE FUNCTION obtener_o_crear_carrito_usuario(
    p_id_usuario INTEGER,
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
    v_id_compra INTEGER;
    v_estatus_pendiente INTEGER := 2; -- ID del estatus "En proceso"
BEGIN
    -- Buscar si el usuario ya tiene un carrito pendiente
    -- Si es compra en tienda física (con cliente), buscar por cliente
    IF p_id_cliente_natural IS NOT NULL OR p_id_cliente_juridico IS NOT NULL THEN
        SELECT c.id_compra INTO v_id_compra
        FROM Compra c
        JOIN Compra_Estatus ce ON c.id_compra = ce.compra_id_compra
        WHERE (c.id_cliente_natural = p_id_cliente_natural OR c.id_cliente_juridico = p_id_cliente_juridico)
        AND ce.estatus_id_estatus = v_estatus_pendiente
        AND ce.fecha_hora_fin > CURRENT_TIMESTAMP;
    ELSE
        -- Si es compra web (con usuario), buscar por usuario
        SELECT c.id_compra INTO v_id_compra
        FROM Compra c
        JOIN Compra_Estatus ce ON c.id_compra = ce.compra_id_compra
        WHERE c.usuario_id_usuario = p_id_usuario 
        AND ce.estatus_id_estatus = v_estatus_pendiente
        AND ce.fecha_hora_fin > CURRENT_TIMESTAMP;
    END IF;
    
    -- Si no existe carrito pendiente, crear uno nuevo
    IF v_id_compra IS NULL THEN
        -- Se asume que la tienda física tiene el ID 1.
        IF p_id_cliente_natural IS NOT NULL OR p_id_cliente_juridico IS NOT NULL THEN
            -- Compra en tienda física: solo cliente, sin usuario
            INSERT INTO Compra (monto_total, tienda_fisica_id_tienda, id_cliente_natural, id_cliente_juridico)
            VALUES (0, 1, p_id_cliente_natural, p_id_cliente_juridico)
            RETURNING id_compra INTO v_id_compra;
        ELSE
            -- Compra web: solo usuario, sin cliente
            INSERT INTO Compra (usuario_id_usuario, monto_total, tienda_fisica_id_tienda)
            VALUES (p_id_usuario, 0, 1)
            RETURNING id_compra INTO v_id_compra;
        END IF;
        
        -- Asignar estatus "En proceso" al carrito
        INSERT INTO Compra_Estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion, fecha_hora_fin)
        VALUES (v_id_compra, v_estatus_pendiente, CURRENT_TIMESTAMP, '9999-12-31 23:59:59');
    END IF;
    
    RETURN v_id_compra;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- FUNCIÓN MODIFICADA PARA AGREGAR AL CARRITO POR NOMBRE Y PRESENTACIÓN
-- =====================================================

CREATE OR REPLACE FUNCTION agregar_al_carrito_por_producto(
    p_id_usuario INTEGER,
    p_nombre_cerveza VARCHAR(50),
    p_nombre_presentacion VARCHAR(50),
    p_cantidad INTEGER,
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
)
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
    v_id_inventario INTEGER;
BEGIN
    -- Buscar el inventario correcto por nombre y presentación
    v_id_inventario := buscar_inventario_por_producto(p_nombre_cerveza, p_nombre_presentacion);
    
    IF v_id_inventario IS NULL THEN
        RAISE EXCEPTION 'Producto no encontrado o sin stock disponible';
    END IF;
    
    -- Llamar a la función original con el id_inventario correcto
    PERFORM agregar_al_carrito(p_id_usuario, v_id_inventario, p_cantidad, p_id_cliente_natural, p_id_cliente_juridico);
END;
$$;

-- =====================================================
-- FUNCIÓN PARA BUSCAR INVENTARIO POR NOMBRE Y PRESENTACIÓN
-- =====================================================

CREATE OR REPLACE FUNCTION buscar_inventario_por_producto(
    p_nombre_cerveza VARCHAR(50),
    p_nombre_presentacion VARCHAR(50)
)
RETURNS INTEGER AS $$
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
$$ LANGUAGE plpgsql;

-- =====================================================
-- FUNCIÓN (antes Procedimiento) PARA AGREGAR PRODUCTO AL CARRITO
-- =====================================================

CREATE OR REPLACE FUNCTION agregar_al_carrito(
    p_id_usuario INTEGER,
    p_id_inventario INTEGER,
    p_cantidad INTEGER,
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
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
    v_es_compra_web BOOLEAN;
BEGIN
    -- Determinar si es compra web o tienda física
    v_es_compra_web := (p_id_cliente_natural IS NULL AND p_id_cliente_juridico IS NULL);
    
    -- Verificar que el usuario existe (solo para compra web)
    IF v_es_compra_web THEN
        SELECT EXISTS(SELECT 1 FROM Usuario WHERE id_usuario = p_id_usuario) INTO v_usuario_existe;
        IF NOT v_usuario_existe THEN
            RAISE EXCEPTION 'Usuario no encontrado';
        END IF;
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

    -- Obtener o crear carrito usando la función auxiliar
    v_id_compra := obtener_carrito_por_tipo(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);

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

CREATE OR REPLACE FUNCTION obtener_carrito_usuario(
    p_id_usuario INTEGER,
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
)
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
$$ LANGUAGE plpgsql;

-- =====================================================
-- FUNCIÓN (antes Procedimiento) PARA ACTUALIZAR CANTIDAD
-- =====================================================

CREATE OR REPLACE FUNCTION actualizar_cantidad_carrito(
    p_id_usuario INTEGER,
    p_id_inventario INTEGER,
    p_nueva_cantidad INTEGER,
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
)
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
    v_stock_disponible INTEGER;
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_carrito_por_tipo(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);
    
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


CREATE OR REPLACE FUNCTION eliminar_del_carrito(
    p_id_usuario INTEGER,
    p_id_inventario INTEGER,
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
)
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_carrito_por_tipo(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);
    
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


CREATE OR REPLACE FUNCTION limpiar_carrito_usuario(
    p_id_usuario INTEGER,
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
)
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
    v_id_compra INTEGER;
BEGIN
    v_id_compra := obtener_carrito_por_tipo(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);
    
    IF v_id_compra IS NULL THEN
        RAISE EXCEPTION 'No se encontró carrito';
    END IF;

    DELETE FROM Detalle_Compra WHERE id_compra = v_id_compra;
END;
$$;


-- =====================================================
-- FUNCIÓN (CONSULTA) PARA OBTENER RESUMEN
-- =====================================================
DROP FUNCTION IF EXISTS obtener_resumen_carrito(integer, integer, integer);
CREATE OR REPLACE FUNCTION obtener_resumen_carrito(
    p_id_usuario INTEGER,
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
)
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
$$ LANGUAGE plpgsql;

-- =====================================================
-- FUNCIÓN (CONSULTA) PARA VERIFICAR STOCK
-- =====================================================

CREATE OR REPLACE FUNCTION verificar_stock_carrito(
    p_id_usuario INTEGER,
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
)
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
$$ LANGUAGE plpgsql;


-- =====================================================
-- FUNCIÓN PARA ACTUALIZAR MONTO DE COMPRA AL PROCEDER AL PAGO
-- =====================================================

CREATE OR REPLACE FUNCTION actualizar_monto_compra(
    p_id_usuario INTEGER,
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
)
RETURNS DECIMAL AS $$
DECLARE
    v_id_compra INTEGER;
    v_monto_total DECIMAL;
BEGIN
    -- Obtener el carrito usando la función auxiliar
    v_id_compra := obtener_carrito_por_tipo(p_id_usuario, p_id_cliente_natural, p_id_cliente_juridico);
    
    IF v_id_compra IS NULL THEN
        RAISE EXCEPTION 'No se encontró carrito para el usuario';
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
$$ LANGUAGE plpgsql;

-- =====================================================
-- FUNCIONES PARA MÉTODOS DE PAGO (SUPERTIPO-SUBTIPO)
-- =====================================================

-- Función para crear método de pago con Cheque
DROP FUNCTION IF EXISTS crear_metodo_pago_cheque(integer, integer, varchar, integer, integer);
  -- O la firma que corresponda
CREATE OR REPLACE FUNCTION crear_metodo_pago_cheque(
    p_num_cheque VARCHAR(20),
    p_num_cuenta VARCHAR(20),
    p_banco VARCHAR(30),
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
) RETURNS INTEGER AS $$
DECLARE
    v_id_metodo INTEGER;
BEGIN
    -- Validar que al menos un cliente esté especificado
    IF p_id_cliente_natural IS NULL AND p_id_cliente_juridico IS NULL THEN
        RAISE EXCEPTION 'Debe especificar al menos un cliente (natural o jurídico)';
    END IF;
    
    -- 1. Crear registro en el supertipo usando la función automática
    SELECT insertar_metodo_pago_automatico(p_id_cliente_natural, p_id_cliente_juridico) INTO v_id_metodo;
    
    -- 2. Crear registro en el subtipo
    INSERT INTO Cheque (id_metodo, num_cheque, num_cuenta, banco)
    VALUES (v_id_metodo, p_num_cheque, p_num_cuenta, p_banco);
    
    RETURN v_id_metodo;
END;
$$ LANGUAGE plpgsql;

-- Función para crear método de pago con Efectivo
CREATE OR REPLACE FUNCTION crear_metodo_pago_efectivo(
    p_denominacion INTEGER,
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
) RETURNS INTEGER AS $$
DECLARE
    v_id_metodo INTEGER;
BEGIN
    -- Validar que al menos un cliente esté especificado
    IF p_id_cliente_natural IS NULL AND p_id_cliente_juridico IS NULL THEN
        RAISE EXCEPTION 'Debe especificar al menos un cliente (natural o jurídico)';
    END IF;
    
    -- 1. Crear registro en el supertipo usando la función automática
    SELECT insertar_metodo_pago_automatico(p_id_cliente_natural, p_id_cliente_juridico) INTO v_id_metodo;
    
    -- 2. Crear registro en el subtipo
    INSERT INTO Efectivo (id_metodo, denominacion)
    VALUES (v_id_metodo, p_denominacion);
    
    RETURN v_id_metodo;
END;
$$ LANGUAGE plpgsql;

-- Función para crear método de pago con Tarjeta de Crédito
CREATE OR REPLACE FUNCTION crear_metodo_pago_tarjeta_credito(
    p_tipo VARCHAR(20),
    p_numero VARCHAR(20),
    p_banco VARCHAR(30),
    p_fecha_vencimiento DATE,
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
) RETURNS INTEGER AS $$
DECLARE
    v_id_metodo INTEGER;
BEGIN
    -- Validar que al menos un cliente esté especificado
    IF p_id_cliente_natural IS NULL AND p_id_cliente_juridico IS NULL THEN
        RAISE EXCEPTION 'Debe especificar al menos un cliente (natural o jurídico)';
    END IF;
    
    -- 1. Crear registro en el supertipo usando la función automática
    SELECT insertar_metodo_pago_automatico(p_id_cliente_natural, p_id_cliente_juridico) INTO v_id_metodo;
    
    -- 2. Crear registro en el subtipo
    INSERT INTO Tarjeta_Credito (id_metodo, tipo, numero, banco, fecha_vencimiento)
    VALUES (v_id_metodo, p_tipo, p_numero, p_banco, p_fecha_vencimiento);
    
    RETURN v_id_metodo;
END;
$$ LANGUAGE plpgsql;

-- Función para crear método de pago con Tarjeta de Débito
CREATE OR REPLACE FUNCTION crear_metodo_pago_tarjeta_debito(
    p_numero VARCHAR(20),
    p_banco VARCHAR(30),
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
) RETURNS INTEGER AS $$
DECLARE
    v_id_metodo INTEGER;
BEGIN
    -- Validar que al menos un cliente esté especificado
    IF p_id_cliente_natural IS NULL AND p_id_cliente_juridico IS NULL THEN
        RAISE EXCEPTION 'Debe especificar al menos un cliente (natural o jurídico)';
    END IF;
    
    -- 1. Crear registro en el supertipo usando la función automática
    SELECT insertar_metodo_pago_automatico(p_id_cliente_natural, p_id_cliente_juridico) INTO v_id_metodo;
    
    -- 2. Crear registro en el subtipo
    INSERT INTO Tarjeta_Debito (id_metodo, numero, banco)
    VALUES (v_id_metodo, p_numero, p_banco);
    
    RETURN v_id_metodo;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener información completa de un método de pago
CREATE OR REPLACE FUNCTION obtener_metodo_pago_completo(
    p_id_metodo INTEGER
) RETURNS TABLE(
    id_metodo INTEGER,
    tipo_metodo VARCHAR(20),
    id_cliente_natural INTEGER,
    id_cliente_juridico INTEGER,
    datos_especificos JSON
) AS $$
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
$$ LANGUAGE plpgsql;

-- Función para eliminar un método de pago (elimina supertipo y subtipo)
CREATE OR REPLACE FUNCTION eliminar_metodo_pago(
    p_id_metodo INTEGER
) RETURNS BOOLEAN AS $$
DECLARE
    v_tipo_metodo VARCHAR(20);
BEGIN
    -- Determinar el tipo de método
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
$$ LANGUAGE plpgsql;

-- =====================================================
-- FUNCIÓN PARA REGISTRAR PAGOS Y DESCONTAR INVENTARIO (ACTUALIZADA)
-- =====================================================
CREATE OR REPLACE FUNCTION registrar_pagos_y_descuento_inventario(
    p_compra_id INTEGER,
    p_pagos JSON
) RETURNS BOOLEAN AS $$
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
BEGIN
    -- Obtener información del cliente de la compra
    SELECT id_cliente_natural, id_cliente_juridico 
    INTO v_id_cliente_natural, v_id_cliente_juridico
    FROM Compra 
    WHERE id_compra = p_compra_id;
    
    -- Insertar cada pago
    FOR v_pago IN SELECT * FROM json_array_elements(p_pagos) LOOP
        v_tipo_metodo := v_pago->>'tipo';
        v_monto := (v_pago->>'monto')::NUMERIC;
        v_tasa_id := NULLIF((v_pago->>'tasa_id')::INTEGER, 0);
        
        -- Crear método de pago según el tipo con datos específicos
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
                -- Para pagos con puntos, usar la función específica
                v_puntos_acumulados := usar_puntos_como_pago(
                    v_id_cliente_natural,
                    (v_pago->>'puntos_usados')::INTEGER,
                    v_id_cliente_natural,
                    v_id_cliente_juridico
                );
                -- Continuar al siguiente pago ya que usar_puntos_como_pago ya registra el pago
                CONTINUE;
            ELSE
                RAISE EXCEPTION 'Tipo de método de pago no válido: %', v_tipo_metodo;
        END CASE;
        
        -- Asignar tasa por defecto según el tipo de método
        IF v_tasa_id IS NULL THEN
            -- Efectivo y Cheque no tienen tasa
            IF v_tipo_metodo IN ('efectivo', 'cheque') THEN
                v_tasa_id := NULL;
            -- Tarjetas de crédito y débito usan tasa por defecto
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
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Comentarios de documentación
COMMENT ON FUNCTION crear_metodo_pago_cheque IS 'Función: Crea un método de pago tipo cheque con patrón supertipo-subtipo';
COMMENT ON FUNCTION crear_metodo_pago_efectivo IS 'Función: Crea un método de pago tipo efectivo con patrón supertipo-subtipo';
COMMENT ON FUNCTION crear_metodo_pago_tarjeta_credito IS 'Función: Crea un método de pago tipo tarjeta de crédito con patrón supertipo-subtipo';
COMMENT ON FUNCTION crear_metodo_pago_tarjeta_debito IS 'Función: Crea un método de pago tipo tarjeta de débito con patrón supertipo-subtipo';
COMMENT ON FUNCTION obtener_metodo_pago_completo IS 'Función: Obtiene información completa de un método de pago incluyendo datos específicos';
COMMENT ON FUNCTION eliminar_metodo_pago IS 'Función: Elimina un método de pago completo (supertipo y subtipo)';
COMMENT ON FUNCTION registrar_pagos_y_descuento_inventario IS 'Función: Registra pagos y descuenta inventario';

-- =====================================================
-- FUNCIÓN PARA OBTENER EL SIGUIENTE ID DE MÉTODO DE PAGO
-- =====================================================

CREATE OR REPLACE FUNCTION obtener_siguiente_id_metodo_pago()
RETURNS INTEGER AS $$
DECLARE
    siguiente_id INTEGER;
    max_id INTEGER;
BEGIN
    -- Obtener el máximo ID existente
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
$$ LANGUAGE plpgsql;

-- =====================================================
-- FUNCIÓN MEJORADA PARA INSERTAR MÉTODO DE PAGO CON ID AUTOMÁTICO
-- =====================================================

CREATE OR REPLACE FUNCTION insertar_metodo_pago_automatico(
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
    nuevo_id INTEGER;
BEGIN
    -- Obtener el siguiente ID disponible
    SELECT obtener_siguiente_id_metodo_pago() INTO nuevo_id;
    
    -- Insertar el método de pago con el ID calculado
    INSERT INTO Metodo_Pago (id_metodo, id_cliente_natural, id_cliente_juridico)
    VALUES (nuevo_id, p_id_cliente_natural, p_id_cliente_juridico);
    
    RETURN nuevo_id;
END;
$$ LANGUAGE plpgsql; 

-- =====================================================
-- AJUSTE AUTOMÁTICO DE SECUENCIA AL CARGAR FUNCIONES
-- =====================================================

-- Ajustar la secuencia de Metodo_Pago de forma segura
-- Solo ajustar si hay datos existentes
DO $$
DECLARE
    max_id INTEGER;
BEGIN
    -- Obtener el máximo ID existente
    SELECT COALESCE(MAX(id_metodo), 0) INTO max_id
    FROM Metodo_Pago;
    
    -- Solo ajustar la secuencia si hay datos existentes
    IF max_id > 0 THEN
        -- Ajustar al máximo existente
        PERFORM setval('metodo_pago_id_metodo_seq', max_id, true);
        RAISE NOTICE 'Secuencia ajustada al ID máximo existente: %', max_id;
    ELSE
        RAISE NOTICE 'No hay datos existentes. La secuencia mantendrá su valor por defecto.';
    END IF;
END $$;

-- =====================================================
-- FUNCIONES ROBUSTAS DE CARRITO CON ESTATUS (TIENDA FÍSICA, CLIENTE)
-- =====================================================

DROP FUNCTION IF EXISTS obtener_o_crear_carrito_cliente_en_proceso(INTEGER, INTEGER);
CREATE OR REPLACE FUNCTION obtener_o_crear_carrito_cliente_en_proceso(
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
) RETURNS INTEGER AS $$
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
        1 -- Asume tienda física con id 1, ajusta si es necesario
    ) RETURNING id_compra INTO v_id_compra;

    -- Asociar la compra con estatus 'en proceso' en Compra_Estatus
    INSERT INTO Compra_Estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion, fecha_hora_fin)
    VALUES (v_id_compra, v_id_estatus_en_proceso, v_now, '9999-12-31 23:59:59');

    RETURN v_id_compra;
END;
$$ LANGUAGE plpgsql;

-- FIN FUNCIONES ROBUSTAS DE CARRITO CON ESTATUS

-- =================================================================
-- FUNCIONES PARA OPERACIONES POR COMPRA_ID
-- =================================================================

-- Obtener carrito por compra_id
DROP FUNCTION IF EXISTS obtener_carrito_por_id(integer);
CREATE OR REPLACE FUNCTION obtener_carrito_por_id(p_id_compra INTEGER)
RETURNS TABLE (
    id_inventario INTEGER,
    nombre_cerveza VARCHAR(50),
    nombre_presentacion VARCHAR(50),
    cantidad INTEGER,
    precio_unitario DECIMAL,
    subtotal DECIMAL,
    stock_disponible INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        dc.id_inventario,
        c.nombre_cerveza,
        p.nombre as nombre_presentacion,
        dc.cantidad,
        dc.precio_unitario,
        (dc.cantidad * dc.precio_unitario) as subtotal,
        i.stock_disponible
    FROM Detalle_Compra dc
    JOIN Inventario i ON dc.id_inventario = i.id_inventario
    JOIN Cerveza c ON i.id_cerveza = c.id_cerveza
    JOIN Presentacion p ON i.id_presentacion = p.id_presentacion
    WHERE dc.id_compra = p_id_compra;
END;
$$ LANGUAGE plpgsql;

-- Actualizar cantidad por compra_id
DROP FUNCTION IF EXISTS actualizar_cantidad_carrito_por_id(integer, integer, integer);
CREATE OR REPLACE FUNCTION actualizar_cantidad_carrito_por_id(p_id_compra INTEGER, p_id_inventario INTEGER, p_nueva_cantidad INTEGER)
RETURNS VOID AS $$
BEGIN
    IF p_nueva_cantidad <= 0 THEN
        DELETE FROM Detalle_Compra WHERE id_compra = p_id_compra AND id_inventario = p_id_inventario;
    ELSE
        UPDATE Detalle_Compra 
        SET cantidad = p_nueva_cantidad 
        WHERE id_compra = p_id_compra AND id_inventario = p_id_inventario;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Eliminar producto por compra_id
DROP FUNCTION IF EXISTS eliminar_del_carrito_por_id(integer, integer);
CREATE OR REPLACE FUNCTION eliminar_del_carrito_por_id(p_id_compra INTEGER, p_id_inventario INTEGER)
RETURNS VOID AS $$
BEGIN
    DELETE FROM Detalle_Compra WHERE id_compra = p_id_compra AND id_inventario = p_id_inventario;
END;
$$ LANGUAGE plpgsql;

-- Limpiar carrito por compra_id
DROP FUNCTION IF EXISTS limpiar_carrito_por_id(integer);
CREATE OR REPLACE FUNCTION limpiar_carrito_por_id(p_id_compra INTEGER)
RETURNS VOID AS $$
BEGIN
    DELETE FROM Detalle_Compra WHERE id_compra = p_id_compra;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- ACTUALIZACIÓN DE FUNCIÓN PARA CORREGIR CONTADOR DE CARRITO
-- =====================================================
-- Esta función ahora solo cuenta items cuando la compra está "en proceso"

-- =====================================================
-- SISTEMA DE PUNTOS - FUNCIONES CORREGIDAS
-- =====================================================

-- Función para acumular puntos automáticamente al finalizar una compra física
CREATE OR REPLACE FUNCTION acumular_puntos_compra_fisica(
    p_id_compra INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    v_id_cliente_natural INTEGER;
    v_id_cliente_juridico INTEGER;
    v_monto_total DECIMAL;
    v_puntos_ganados INTEGER;
    v_id_metodo_punto INTEGER;
    v_tasa_actual DECIMAL;
    v_punto_existente INTEGER;
BEGIN
    -- Obtener información de la compra
    SELECT 
        c.id_cliente_natural,
        c.id_cliente_juridico,
        c.monto_total
    INTO v_id_cliente_natural, v_id_cliente_juridico, v_monto_total
    FROM Compra c
    WHERE c.id_compra = p_id_compra;
    
    -- Solo acumular puntos para clientes naturales en compras físicas
    IF v_id_cliente_natural IS NULL OR v_monto_total IS NULL OR v_monto_total <= 0 THEN
        RETURN 0;
    END IF;
    
    -- Calcular puntos ganados (1 punto por compra, no por monto)
    v_puntos_ganados := 1;
    
    -- Buscar si ya existe un método de pago de tipo Punto para este cliente
    SELECT p.id_metodo INTO v_punto_existente
    FROM Punto p
    JOIN Metodo_Pago mp ON p.id_metodo = mp.id_metodo
    WHERE mp.id_cliente_natural = v_id_cliente_natural
    LIMIT 1;
    
    -- Si no existe, crear uno nuevo usando la función específica
    IF v_punto_existente IS NULL THEN
        -- Usar la función específica para crear método de pago de puntos
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
$$ LANGUAGE plpgsql;

-- Función para obtener el saldo de puntos de un cliente natural
CREATE OR REPLACE FUNCTION obtener_saldo_puntos_cliente(
    p_id_cliente_natural INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    v_saldo INTEGER;
BEGIN
    SELECT COALESCE(SUM(pc.cantidad_mov), 0) INTO v_saldo
    FROM Punto_Cliente pc
    WHERE pc.id_cliente_natural = p_id_cliente_natural;
    
    RETURN v_saldo;
END;
$$ LANGUAGE plpgsql;

-- Función para validar si un cliente puede usar puntos como método de pago
CREATE OR REPLACE FUNCTION validar_uso_puntos(
    p_id_cliente_natural INTEGER,
    p_puntos_a_usar INTEGER
)
RETURNS BOOLEAN AS $$
DECLARE
    v_saldo_actual INTEGER;
BEGIN
    -- Obtener saldo actual
    SELECT obtener_saldo_puntos_cliente(p_id_cliente_natural) INTO v_saldo_actual;
    -- Validar solo que tenga suficientes puntos
    RETURN v_saldo_actual >= p_puntos_a_usar;
END;
$$ LANGUAGE plpgsql;

-- Función para usar puntos como método de pago
CREATE OR REPLACE FUNCTION usar_puntos_como_pago(
    p_id_cliente_natural INTEGER,
    p_puntos_a_usar INTEGER,
    p_id_compra INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    v_id_metodo_punto INTEGER;
    v_valor_punto DECIMAL;
    v_monto_equivalente DECIMAL;
    v_id_tasa INTEGER;
BEGIN
    -- Validar que puede usar los puntos
    IF NOT validar_uso_puntos(p_id_cliente_natural, p_puntos_a_usar) THEN
        RAISE EXCEPTION 'No puede usar % puntos. Saldo insuficiente o no cumple mínimo requerido.', p_puntos_a_usar;
    END IF;
    
    -- Obtener el valor actual del punto desde la fila específica
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
    
    -- Obtener el método de pago de tipo Punto del cliente
    SELECT p.id_metodo INTO v_id_metodo_punto
    FROM Punto p
    JOIN Metodo_Pago mp ON p.id_metodo = mp.id_metodo
    WHERE mp.id_cliente_natural = p_id_cliente_natural
    LIMIT 1;
    
    -- Si no existe método de pago de puntos, crear uno usando la función específica
    IF v_id_metodo_punto IS NULL THEN
        -- Usar la función específica para crear método de pago de puntos
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
$$ LANGUAGE plpgsql;

-- Función para obtener el historial de movimientos de puntos de un cliente
CREATE OR REPLACE FUNCTION obtener_historial_puntos_cliente(
    p_id_cliente_natural INTEGER,
    p_limite INTEGER DEFAULT 50
)
RETURNS TABLE (
    fecha DATE,
    tipo_movimiento VARCHAR(20),
    cantidad_mov INTEGER,
    saldo_acumulado INTEGER,
    referencia TEXT
) AS $$
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
            WHEN pc.tipo_movimiento = 'GANADO' THEN 'Compra en tienda física'
            WHEN pc.tipo_movimiento = 'GASTADO' THEN 'Pago con puntos'
            ELSE 'Otro'
        END as referencia
    FROM Punto_Cliente pc
    WHERE pc.id_cliente_natural = p_id_cliente_natural
    ORDER BY pc.fecha DESC, pc.id_punto_cliente DESC
    LIMIT p_limite;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener información completa de puntos de un cliente
CREATE OR REPLACE FUNCTION obtener_info_puntos_cliente(
    p_id_cliente_natural INTEGER
)
RETURNS TABLE (
    saldo_actual INTEGER,
    puntos_ganados INTEGER,
    puntos_gastados INTEGER,
    valor_punto DECIMAL,
    minimo_canje INTEGER,
    tasa_actual DECIMAL
) AS $$
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
    
    -- Obtener configuración de puntos desde la fila específica
    SELECT valor INTO v_valor_punto
    FROM Tasa 
    WHERE nombre = 'Punto' AND punto_id = 51
    LIMIT 1;
    
    SELECT valor INTO v_minimo
    FROM Tasa 
    WHERE punto_id IS NOT NULL AND nombre LIKE '%mínimo%'
    ORDER BY fecha DESC 
    LIMIT 1;
    
    SELECT valor INTO v_tasa
    FROM Tasa 
    WHERE punto_id IS NOT NULL AND nombre LIKE '%tasa%'
    ORDER BY fecha DESC 
    LIMIT 1;
    
    -- Valores por defecto si no hay configuración
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
$$ LANGUAGE plpgsql;

-- =============================================
-- AJUSTE AUTOMÁTICO DE SECUENCIA DE Metodo_Pago
-- =============================================
DO $$
DECLARE
    max_id INTEGER;
BEGIN
    SELECT COALESCE(MAX(id_metodo), 0) INTO max_id FROM Metodo_Pago;
    IF max_id > 0 THEN
        PERFORM setval('metodo_pago_id_metodo_seq', max_id, true);
        RAISE NOTICE 'Secuencia metodo_pago_id_metodo_seq ajustada a %', max_id;
    END IF;
END $$;

-- =====================================================
-- FUNCIÓN PARA CREAR MÉTODO DE PAGO CON PUNTOS
-- =====================================================
CREATE OR REPLACE FUNCTION crear_metodo_pago_puntos(
    p_origen VARCHAR(20),
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
) RETURNS INTEGER AS $$
DECLARE
    v_id_metodo INTEGER;
BEGIN
    -- Validar que al menos un cliente esté especificado
    IF p_id_cliente_natural IS NULL AND p_id_cliente_juridico IS NULL THEN
        RAISE EXCEPTION 'Debe especificar al menos un cliente (natural o jurídico)';
    END IF;
    
    -- 1. Crear registro en el supertipo usando la función automática
    SELECT insertar_metodo_pago_automatico(p_id_cliente_natural, p_id_cliente_juridico) INTO v_id_metodo;
    
    -- 2. Crear registro en el subtipo
    INSERT INTO Punto (id_metodo, origen)
    VALUES (v_id_metodo, p_origen);
    
    RETURN v_id_metodo;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- FUNCIÓN PARA REGISTRAR PAGOS Y DESCONTAR INVENTARIO (ACTUALIZADA CON PUNTOS)
-- =====================================================
CREATE OR REPLACE FUNCTION registrar_pagos_y_descuento_inventario(
    p_compra_id INTEGER,
    p_pagos JSON
) RETURNS BOOLEAN AS $$
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
BEGIN
    -- Obtener información del cliente de la compra
    SELECT id_cliente_natural, id_cliente_juridico 
    INTO v_id_cliente_natural, v_id_cliente_juridico
    FROM Compra 
    WHERE id_compra = p_compra_id;
    
    -- Insertar cada pago
    FOR v_pago IN SELECT * FROM json_array_elements(p_pagos) LOOP
        v_tipo_metodo := v_pago->>'tipo';
        v_monto := (v_pago->>'monto')::NUMERIC;
        v_tasa_id := NULLIF((v_pago->>'tasa_id')::INTEGER, 0);
        
        -- Crear método de pago según el tipo con datos específicos
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
                -- Para pagos con puntos, usar la función específica
                v_puntos_acumulados := usar_puntos_como_pago(
                    v_id_cliente_natural,
                    (v_pago->>'puntos_usados')::INTEGER,
                    p_compra_id
                );
                -- Continuar al siguiente pago ya que usar_puntos_como_pago ya registra el pago
                CONTINUE;
            ELSE
                RAISE EXCEPTION 'Tipo de método de pago no válido: %', v_tipo_metodo;
        END CASE;
        
        -- Asignar tasa por defecto según el tipo de método
        IF v_tasa_id IS NULL THEN
            -- Efectivo y Cheque no tienen tasa
            IF v_tipo_metodo IN ('efectivo', 'cheque') THEN
                v_tasa_id := NULL;
            -- Tarjetas de crédito y débito usan tasa por defecto
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
    
    -- Acumular puntos automáticamente para clientes naturales en compras físicas
    IF v_id_cliente_natural IS NOT NULL THEN
        v_puntos_acumulados := acumular_puntos_compra_fisica(p_compra_id);
        -- Log de puntos acumulados (opcional)
        IF v_puntos_acumulados > 0 THEN
            RAISE NOTICE 'Se acumularon % puntos para el cliente %', v_puntos_acumulados, v_id_cliente_natural;
        END IF;
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Comentarios de documentación
COMMENT ON FUNCTION crear_metodo_pago_cheque IS 'Función: Crea un método de pago tipo cheque con patrón supertipo-subtipo';
COMMENT ON FUNCTION crear_metodo_pago_efectivo IS 'Función: Crea un método de pago tipo efectivo con patrón supertipo-subtipo';
COMMENT ON FUNCTION crear_metodo_pago_tarjeta_credito IS 'Función: Crea un método de pago tipo tarjeta de crédito con patrón supertipo-subtipo';
COMMENT ON FUNCTION crear_metodo_pago_tarjeta_debito IS 'Función: Crea un método de pago tipo tarjeta de débito con patrón supertipo-subtipo';
COMMENT ON FUNCTION crear_metodo_pago_puntos IS 'Función: Crea un método de pago tipo puntos con patrón supertipo-subtipo';
COMMENT ON FUNCTION obtener_metodo_pago_completo IS 'Función: Obtiene información completa de un método de pago incluyendo datos específicos';
COMMENT ON FUNCTION eliminar_metodo_pago IS 'Función: Elimina un método de pago completo (supertipo y subtipo)';
COMMENT ON FUNCTION registrar_pagos_y_descuento_inventario IS 'Función: Registra pagos y descuenta inventario';

-- =====================================================
-- FUNCIÓN PARA OBTENER EL SIGUIENTE ID DE MÉTODO DE PAGO
-- =====================================================

CREATE OR REPLACE FUNCTION obtener_siguiente_id_metodo_pago()
RETURNS INTEGER AS $$
DECLARE
    siguiente_id INTEGER;
    max_id INTEGER;
BEGIN
    -- Obtener el máximo ID existente
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
$$ LANGUAGE plpgsql;

-- =====================================================
-- FUNCIÓN MEJORADA PARA INSERTAR MÉTODO DE PAGO CON ID AUTOMÁTICO
-- =====================================================

CREATE OR REPLACE FUNCTION insertar_metodo_pago_automatico(
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
    nuevo_id INTEGER;
BEGIN
    -- Obtener el siguiente ID disponible
    SELECT obtener_siguiente_id_metodo_pago() INTO nuevo_id;
    
    -- Insertar el método de pago con el ID calculado
    INSERT INTO Metodo_Pago (id_metodo, id_cliente_natural, id_cliente_juridico)
    VALUES (nuevo_id, p_id_cliente_natural, p_id_cliente_juridico);
    
    RETURN nuevo_id;
END;
$$ LANGUAGE plpgsql; 

-- =====================================================
-- AJUSTE AUTOMÁTICO DE SECUENCIA AL CARGAR FUNCIONES
-- =====================================================

-- Ajustar la secuencia de Metodo_Pago de forma segura
-- Solo ajustar si hay datos existentes
DO $$
DECLARE
    max_id INTEGER;
BEGIN
    -- Obtener el máximo ID existente
    SELECT COALESCE(MAX(id_metodo), 0) INTO max_id
    FROM Metodo_Pago;
    
    -- Solo ajustar la secuencia si hay datos existentes
    IF max_id > 0 THEN
        -- Ajustar al máximo existente
        PERFORM setval('metodo_pago_id_metodo_seq', max_id, true);
        RAISE NOTICE 'Secuencia ajustada al ID máximo existente: %', max_id;
    ELSE
        RAISE NOTICE 'No hay datos existentes. La secuencia mantendrá su valor por defecto.';
    END IF;
END $$;

-- =====================================================
-- FUNCIONES ROBUSTAS DE CARRITO CON ESTATUS (TIENDA FÍSICA, CLIENTE)
-- =====================================================

DROP FUNCTION IF EXISTS obtener_o_crear_carrito_cliente_en_proceso(INTEGER, INTEGER);
CREATE OR REPLACE FUNCTION obtener_o_crear_carrito_cliente_en_proceso(
    p_id_cliente_natural INTEGER DEFAULT NULL,
    p_id_cliente_juridico INTEGER DEFAULT NULL
) RETURNS INTEGER AS $$
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
        1 -- Asume tienda física con id 1, ajusta si es necesario
    ) RETURNING id_compra INTO v_id_compra;

    -- Asociar la compra con estatus 'en proceso' en Compra_Estatus
    INSERT INTO Compra_Estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion, fecha_hora_fin)
    VALUES (v_id_compra, v_id_estatus_en_proceso, v_now, '9999-12-31 23:59:59');

    RETURN v_id_compra;
END;
$$ LANGUAGE plpgsql;

-- FIN FUNCIONES ROBUSTAS DE CARRITO CON ESTATUS

-- =================================================================
-- FUNCIONES PARA OPERACIONES POR COMPRA_ID
-- =================================================================


-- Obtener carrito por compra_id
DROP FUNCTION IF EXISTS obtener_carrito_por_id(integer);
CREATE OR REPLACE FUNCTION obtener_carrito_por_id(p_id_compra INTEGER)
RETURNS TABLE (
    id_inventario INTEGER,
    nombre_cerveza VARCHAR(50),
    nombre_presentacion VARCHAR(40),
    cantidad_solicitada INTEGER,
    stock_disponible INTEGER,
    stock_suficiente BOOLEAN
) AS $$
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
$$ LANGUAGE plpgsql;

-- Actualizar cantidad en carrito por compra_id
DROP FUNCTION IF EXISTS actualizar_cantidad_carrito_por_id(integer, integer, integer);
CREATE OR REPLACE FUNCTION actualizar_cantidad_carrito_por_id(p_id_compra INTEGER, p_id_inventario INTEGER, p_nueva_cantidad INTEGER)
RETURNS VOID AS $$
BEGIN
    IF p_nueva_cantidad <= 0 THEN
        DELETE FROM Detalle_Compra WHERE id_compra = p_id_compra AND id_inventario = p_id_inventario;
    ELSE
        UPDATE Detalle_Compra 
        SET cantidad = p_nueva_cantidad 
        WHERE id_compra = p_id_compra AND id_inventario = p_id_inventario;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Eliminar del carrito por compra_id
DROP FUNCTION IF EXISTS eliminar_del_carrito_por_id(integer, integer);
CREATE OR REPLACE FUNCTION eliminar_del_carrito_por_id(p_id_compra INTEGER, p_id_inventario INTEGER)
RETURNS VOID AS $$
BEGIN
    DELETE FROM Detalle_Compra WHERE id_compra = p_id_compra AND id_inventario = p_id_inventario;
END;
$$ LANGUAGE plpgsql;

-- Limpiar carrito por compra_id
DROP FUNCTION IF EXISTS limpiar_carrito_por_id(integer);
CREATE OR REPLACE FUNCTION limpiar_carrito_por_id(p_id_compra INTEGER)
RETURNS VOID AS $$
BEGIN
    DELETE FROM Detalle_Compra WHERE id_compra = p_id_compra;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- ACTUALIZACIÓN DE FUNCIÓN PARA CORREGIR CONTADOR DE CARRITO
-- =====================================================
-- Esta función ahora solo cuenta items cuando la compra está "en proceso"

-- Obtener resumen por compra_id (CORREGIDA)
DROP FUNCTION IF EXISTS obtener_resumen_carrito_por_id(integer);
CREATE OR REPLACE FUNCTION obtener_resumen_carrito_por_id(p_id_compra INTEGER)
RETURNS TABLE (
    id_compra INTEGER,
    total_productos INTEGER,
    total_items INTEGER,
    monto_total DECIMAL,
    items_carrito JSON,
    estatus_id INTEGER,
    estatus_nombre VARCHAR(50)
) AS $$
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

    -- Si la compra NO está en proceso, devolver 0 items
    IF v_estatus_id IS NULL OR v_estatus_id != v_estatus_en_proceso_id THEN
        RETURN QUERY
        SELECT p_id_compra, 0::INTEGER, 0::INTEGER, 0::DECIMAL, '[]'::json, v_estatus_id, v_estatus_nombre;
        RETURN;
    END IF;

    -- Solo obtener items si la compra está en proceso
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
$$ LANGUAGE plpgsql;

-- =====================================================
-- SISTEMA DE PUNTOS - FUNCIONES CORREGIDAS
-- =====================================================

-- Función para acumular puntos automáticamente al finalizar una compra física
CREATE OR REPLACE FUNCTION acumular_puntos_compra_fisica(
    p_id_compra INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    v_id_cliente_natural INTEGER;
    v_id_cliente_juridico INTEGER;
    v_monto_total DECIMAL;
    v_puntos_ganados INTEGER;
    v_id_metodo_punto INTEGER;
    v_tasa_actual DECIMAL;
    v_punto_existente INTEGER;
BEGIN
    -- Obtener información de la compra
    SELECT 
        c.id_cliente_natural,
        c.id_cliente_juridico,
        c.monto_total
    INTO v_id_cliente_natural, v_id_cliente_juridico, v_monto_total
    FROM Compra c
    WHERE c.id_compra = p_id_compra;
    
    -- Solo acumular puntos para clientes naturales en compras físicas
    IF v_id_cliente_natural IS NULL OR v_monto_total IS NULL OR v_monto_total <= 0 THEN
        RETURN 0;
    END IF;
    
    -- Calcular puntos ganados (1 punto por compra, no por monto)
    v_puntos_ganados := 1;
    
    -- Buscar si ya existe un método de pago de tipo Punto para este cliente
    SELECT p.id_metodo INTO v_punto_existente
    FROM Punto p
    JOIN Metodo_Pago mp ON p.id_metodo = mp.id_metodo
    WHERE mp.id_cliente_natural = v_id_cliente_natural
    LIMIT 1;
    
    -- Si no existe, crear uno nuevo usando la función específica
    IF v_punto_existente IS NULL THEN
        -- Usar la función específica para crear método de pago de puntos
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
$$ LANGUAGE plpgsql;

-- Función para obtener el saldo de puntos de un cliente natural
CREATE OR REPLACE FUNCTION obtener_saldo_puntos_cliente(
    p_id_cliente_natural INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    v_saldo INTEGER;
BEGIN
    SELECT COALESCE(SUM(pc.cantidad_mov), 0) INTO v_saldo
    FROM Punto_Cliente pc
    WHERE pc.id_cliente_natural = p_id_cliente_natural;
    
    RETURN v_saldo;
END;
$$ LANGUAGE plpgsql;

-- Función para validar si un cliente puede usar puntos como método de pago
CREATE OR REPLACE FUNCTION validar_uso_puntos(
    p_id_cliente_natural INTEGER,
    p_puntos_a_usar INTEGER
)
RETURNS BOOLEAN AS $$
DECLARE
    v_saldo_actual INTEGER;
BEGIN
    -- Obtener saldo actual
    SELECT obtener_saldo_puntos_cliente(p_id_cliente_natural) INTO v_saldo_actual;
    -- Validar solo que tenga suficientes puntos
    RETURN v_saldo_actual >= p_puntos_a_usar;
END;
$$ LANGUAGE plpgsql;

-- Función para usar puntos como método de pago
CREATE OR REPLACE FUNCTION usar_puntos_como_pago(
    p_id_cliente_natural INTEGER,
    p_puntos_a_usar INTEGER,
    p_id_compra INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    v_id_metodo_punto INTEGER;
    v_valor_punto DECIMAL;
    v_monto_equivalente DECIMAL;
    v_id_tasa INTEGER;
BEGIN
    -- Validar que puede usar los puntos
    IF NOT validar_uso_puntos(p_id_cliente_natural, p_puntos_a_usar) THEN
        RAISE EXCEPTION 'No puede usar % puntos. Saldo insuficiente o no cumple mínimo requerido.', p_puntos_a_usar;
    END IF;
    
    -- Obtener el valor actual del punto desde la fila específica
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
    
    -- Obtener el método de pago de tipo Punto del cliente
    SELECT p.id_metodo INTO v_id_metodo_punto
    FROM Punto p
    JOIN Metodo_Pago mp ON p.id_metodo = mp.id_metodo
    WHERE mp.id_cliente_natural = p_id_cliente_natural
    LIMIT 1;
    
    -- Si no existe método de pago de puntos, crear uno usando la función específica
    IF v_id_metodo_punto IS NULL THEN
        -- Usar la función específica para crear método de pago de puntos
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
$$ LANGUAGE plpgsql;

-- Función para obtener el historial de movimientos de puntos de un cliente
CREATE OR REPLACE FUNCTION obtener_historial_puntos_cliente(
    p_id_cliente_natural INTEGER,
    p_limite INTEGER DEFAULT 50
)
RETURNS TABLE (
    fecha DATE,
    tipo_movimiento VARCHAR(20),
    cantidad_mov INTEGER,
    saldo_acumulado INTEGER,
    referencia TEXT
) AS $$
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
            WHEN pc.tipo_movimiento = 'GANADO' THEN 'Compra en tienda física'
            WHEN pc.tipo_movimiento = 'GASTADO' THEN 'Pago con puntos'
            ELSE 'Otro'
        END as referencia
    FROM Punto_Cliente pc
    WHERE pc.id_cliente_natural = p_id_cliente_natural
    ORDER BY pc.fecha DESC, pc.id_punto_cliente DESC
    LIMIT p_limite;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener información completa de puntos de un cliente
CREATE OR REPLACE FUNCTION obtener_info_puntos_cliente(
    p_id_cliente_natural INTEGER
)
RETURNS TABLE (
    saldo_actual INTEGER,
    puntos_ganados INTEGER,
    puntos_gastados INTEGER,
    valor_punto DECIMAL,
    minimo_canje INTEGER,
    tasa_actual DECIMAL
) AS $$
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
    
    -- Obtener configuración de puntos desde la fila específica
    SELECT valor INTO v_valor_punto
    FROM Tasa 
    WHERE nombre = 'Punto' AND punto_id = 51
    LIMIT 1;
    
    SELECT valor INTO v_minimo
    FROM Tasa 
    WHERE punto_id IS NOT NULL AND nombre LIKE '%mínimo%'
    ORDER BY fecha DESC 
    LIMIT 1;
    
    SELECT valor INTO v_tasa
    FROM Tasa 
    WHERE punto_id IS NOT NULL AND nombre LIKE '%tasa%'
    ORDER BY fecha DESC 
    LIMIT 1;
    
    -- Valores por defecto si no hay configuración
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
$$ LANGUAGE plpgsql;

-- =============================================
-- AJUSTE AUTOMÁTICO DE SECUENCIA DE Metodo_Pago
-- =============================================
DO $$
DECLARE
    max_id INTEGER;
BEGIN
    SELECT COALESCE(MAX(id_metodo), 0) INTO max_id FROM Metodo_Pago;
    IF max_id > 0 THEN
        PERFORM setval('metodo_pago_id_metodo_seq', max_id, true);
        RAISE NOTICE 'Secuencia metodo_pago_id_metodo_seq ajustada a %', max_id;
    END IF;
END $$;

-- =============================================
-- FUNCIÓN DE DIAGNÓSTICO PARA PUNTOS
-- =============================================
CREATE OR REPLACE FUNCTION diagnosticar_puntos_cliente(
    p_id_cliente_natural INTEGER
)
RETURNS TABLE (
    id_punto_cliente INTEGER,
    fecha DATE,
    tipo_movimiento VARCHAR(20),
    cantidad_mov INTEGER,
    saldo_acumulado INTEGER,
    referencia TEXT
) AS $$
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
            WHEN pc.tipo_movimiento = 'GANADO' THEN 'Compra en tienda física'
            WHEN pc.tipo_movimiento = 'GASTADO' THEN 'Pago con puntos'
            ELSE 'Otro'
        END as referencia
    FROM Punto_Cliente pc
    WHERE pc.id_cliente_natural = p_id_cliente_natural
    ORDER BY pc.fecha ASC, pc.id_punto_cliente ASC;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- AJUSTE AUTOMÁTICO DE SECUENCIA DE Metodo_Pago
-- =============================================

-- =============================================
-- FUNCIÓN PARA LIMPIAR PUNTOS DE UN CLIENTE
-- =============================================
CREATE OR REPLACE FUNCTION limpiar_puntos_cliente(
    p_id_cliente_natural INTEGER
)
RETURNS INTEGER AS $$
DECLARE
    v_registros_eliminados INTEGER;
BEGIN
    DELETE FROM Punto_Cliente 
    WHERE id_cliente_natural = p_id_cliente_natural;
    
    GET DIAGNOSTICS v_registros_eliminados = ROW_COUNT;
    
    RETURN v_registros_eliminados;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- FUNCIÓN DE DIAGNÓSTICO PARA PUNTOS
-- =============================================

-- =============================================
-- INSERT DE TASA DE VALOR DE PUNTO POR DEFECTO (id_metodo NULL)
-- =============================================


-- =============================================
-- FUNCIÓN DE DIAGNÓSTICO PARA VERIFICAR TASAS DE PUNTOS
-- =============================================
CREATE OR REPLACE FUNCTION diagnosticar_tasas_puntos()
RETURNS TABLE (
    id_tasa INTEGER,
    nombre VARCHAR(50),
    valor DECIMAL,
    fecha DATE,
    punto_id INTEGER,
    id_metodo INTEGER
) AS $$
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
$$ LANGUAGE plpgsql;

-- =============================================
-- INSERT DE TASA DE VALOR DE PUNTO POR DEFECTO (id_metodo NULL)
-- =============================================

-- =============================================
-- LIMPIEZA Y REINSERCIÓN DE TASA DE PUNTOS CORRECTA
-- =============================================
DO $$
BEGIN

    
    -- Insertar la tasa correcta con valor 1.0
    INSERT INTO Tasa (nombre, valor, punto_id, fecha, id_metodo)
    VALUES ('Punto', 1.0, 51, '2025-06-15', NULL);
    
    RAISE NOTICE 'Tasa de puntos limpiada y reinsertada con valor 1.0';
END $$;

-- =============================================
-- INSERT DE TASA DE VALOR DE PUNTO POR DEFECTO (id_metodo NULL)
-- =============================================
