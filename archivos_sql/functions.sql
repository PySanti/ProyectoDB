WITH RECURSIVE tipo_cerveza_hierarchy AS (
    -- Caso base: tipos que no tienen padre (tipos raíz)
    SELECT 
        id_tipo_cerveza,
        nombre,
        tipo_padre_id,
        CAST(nombre AS VARCHAR(255)) AS ruta_completa,
        1 AS nivel
    FROM Tipo_Cerveza 
    WHERE tipo_padre_id IS NULL
    
    UNION ALL
    
    -- Caso recursivo: tipos que tienen padre
    SELECT 
        tc.id_tipo_cerveza,
        tc.nombre,
        tc.tipo_padre_id,
        CAST(tch.ruta_completa || ', ' || tc.nombre AS VARCHAR(255)) AS ruta_completa,
        tch.nivel + 1
    FROM Tipo_Cerveza tc
    INNER JOIN tipo_cerveza_hierarchy tch ON tc.tipo_padre_id = tch.id_tipo_cerveza
)
SELECT 
    p.razon_social AS proveedor,
    c.nombre_cerveza AS cerveza,
    tch.ruta_completa AS tipos_cerveza
FROM Cerveza c
INNER JOIN Proveedor p ON c.id_proveedor = p.id_proveedor
INNER JOIN tipo_cerveza_hierarchy tch ON c.id_tipo_cerveza = tch.id_tipo_cerveza
ORDER BY p.razon_social, c.nombre_cerveza;