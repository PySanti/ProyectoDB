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