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