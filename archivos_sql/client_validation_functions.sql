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