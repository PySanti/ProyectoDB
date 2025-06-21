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