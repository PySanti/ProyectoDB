-- =================================================================
-- SCRIPT SIMPLE PARA ACTUALIZAR CANTIDADES DEL INVENTARIO
-- =================================================================
-- Este script solo actualiza las cantidades existentes sin eliminar registros
-- ni tocar las referencias en otras tablas.

-- 1. ACTUALIZAR TODAS LAS CANTIDADES A 35 UNIDADES
UPDATE Inventario 
SET cantidad = 35;

-- 2. VERIFICACIÓN
-- Mostrar el inventario actualizado
SELECT 
    c.nombre_cerveza,
    p.nombre as presentacion,
    i.cantidad as stock_disponible,
    i.id_inventario
FROM 
    Inventario i
JOIN 
    Cerveza c ON i.id_cerveza = c.id_cerveza
JOIN 
    Presentacion p ON i.id_presentacion = p.id_presentacion
ORDER BY 
    c.nombre_cerveza, p.nombre;

-- 3. CONTAR REGISTROS PARA VERIFICAR QUE NO SE PERDIERON
SELECT 
    COUNT(*) as total_registros_inventario,
    COUNT(DISTINCT id_cerveza) as cervezas_diferentes,
    COUNT(DISTINCT id_presentacion) as presentaciones_diferentes,
    'Registros preservados - solo cantidades actualizadas' as nota
FROM Inventario; 

-- =================================================================
-- SCRIPT PARA COMPLETAR EL INVENTARIO SIN ELIMINAR REGISTROS
-- =================================================================
-- Este script agrega las combinaciones faltantes y actualiza cantidades
-- sin eliminar registros existentes.

-- 1. ACTUALIZAR CANTIDADES EXISTENTES A 35
UPDATE Inventario 
SET cantidad = 35;

-- 2. INSERTAR COMBINACIONES FALTANTES
-- Solo insertar las combinaciones que no existen en el inventario
INSERT INTO Inventario (cantidad, id_tienda_fisica, id_presentacion, id_cerveza)
SELECT 
    35 AS cantidad,
    1 AS id_tienda_fisica,
    pc.id_presentacion,
    pc.id_cerveza
FROM 
    presentacion_cerveza pc
WHERE 
    NOT EXISTS (
        SELECT 1 
        FROM Inventario i 
        WHERE i.id_cerveza = pc.id_cerveza 
        AND i.id_presentacion = pc.id_presentacion
    );

-- 3. VERIFICACIÓN
-- Mostrar el inventario completo
SELECT 
    c.nombre_cerveza,
    p.nombre as presentacion,
    i.cantidad as stock_disponible,
    i.id_inventario
FROM 
    Inventario i
JOIN 
    Cerveza c ON i.id_cerveza = c.id_cerveza
JOIN 
    Presentacion p ON i.id_presentacion = p.id_presentacion
ORDER BY 
    c.nombre_cerveza, p.nombre;

-- 4. CONTAR REGISTROS PARA VERIFICAR
SELECT 
    COUNT(*) as total_registros_inventario,
    COUNT(DISTINCT id_cerveza) as cervezas_diferentes,
    COUNT(DISTINCT id_presentacion) as presentaciones_diferentes,
    'Inventario completo con 35 unidades por presentación' as nota
FROM Inventario;

-- 5. VERIFICAR QUE CADA CERVEZA TENGA LAS 3 PRESENTACIONES
SELECT 
    c.nombre_cerveza,
    COUNT(i.id_inventario) as presentaciones_disponibles
FROM 
    Cerveza c
LEFT JOIN 
    Inventario i ON c.id_cerveza = i.id_cerveza
GROUP BY 
    c.id_cerveza, c.nombre_cerveza
ORDER BY 
    c.nombre_cerveza; 
