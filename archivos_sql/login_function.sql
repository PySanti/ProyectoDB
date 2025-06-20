CREATE OR REPLACE FUNCTION verificar_credenciales(
    p_correo VARCHAR,
    p_contrasena VARCHAR
)
RETURNS TABLE (
    id_usuario INTEGER,
    id_cliente_juridico INTEGER,
    id_cliente_natural INTEGER,
    id_rol INTEGER,
    fecha_creacion DATE,
    id_proveedor INTEGER,
    empleado_id INTEGER,
    contraseña VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.id_usuario,
        u.id_cliente_juridico,
        u.id_cliente_natural,
        u.id_rol,
        u.fecha_creacion,
        u.id_proveedor,
        u.empleado_id,
        u.contraseña
    FROM
        Usuario u
    JOIN
        Correo c ON u.id_usuario = COALESCE(c.id_proveedor, c.id_cliente_natural, c.id_cliente_juridico) -- Esta lógica puede necesitar ajuste según la estructura de FK en Correo
    WHERE
        c.nombre = SPLIT_PART(p_correo, '@', 1) AND c.extension_pag = SPLIT_PART(p_correo, '@', 2)
        AND u.contraseña = p_contrasena;
END;
$$ LANGUAGE plpgsql; 