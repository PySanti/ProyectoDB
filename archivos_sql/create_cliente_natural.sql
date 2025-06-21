CREATE OR REPLACE FUNCTION create_cliente_natural(
  p_cedula VARCHAR,
  p_rif VARCHAR,
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
  INSERT INTO Cliente_Natural (cedula, rif, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, id_lugar, direccion_fisica)
  VALUES (p_cedula, p_rif, p_primer_nombre, p_segundo_nombre, p_primer_apellido, p_segundo_apellido, p_id_lugar, p_direccion_fisica)
  RETURNING id_cliente_natural INTO new_cliente_id;

  INSERT INTO Usuario (id_cliente_natural, id_rol, fecha_creacion, contraseña)
  VALUES (new_cliente_id, 2, CURRENT_DATE, p_contrasena)
  RETURNING id_usuario INTO new_usuario_id;

  INSERT INTO Correo (nombre, extension_pag, id_usuario)
  VALUES (split_part(p_correo, '@', 1), split_part(p_correo, '@', 2), new_usuario_id);
END;
$$ LANGUAGE plpgsql; 