-- =================================================================
-- DATOS DE PRUEBA PARA EL DASHBOARD
-- =================================================================
-- Este archivo contiene datos de prueba para que el dashboard muestre valores reales
-- en lugar de ceros o undefined.

-- =================================================================
-- 1. INSERTAR CLIENTES DE PRUEBA
-- =================================================================

-- Cliente Natural 1 (cliente nuevo - primera compra en el período)
INSERT INTO Cliente_Natural (ci_cliente, rif_cliente, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, lugar_id_lugar, direccion)
SELECT 12345678, 123456789, 'Juan', 'Carlos', 'Pérez', 'García', 1, 'Av. Principal #123'
WHERE NOT EXISTS (SELECT 1 FROM Cliente_Natural WHERE ci_cliente = 12345678);

-- Cliente Natural 2 (cliente recurrente - primera compra antes del período)
INSERT INTO Cliente_Natural (ci_cliente, rif_cliente, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, lugar_id_lugar, direccion)
SELECT 87654321, 987654321, 'María', 'Isabel', 'Rodríguez', 'López', 1, 'Calle Secundaria #456'
WHERE NOT EXISTS (SELECT 1 FROM Cliente_Natural WHERE ci_cliente = 87654321);

-- Cliente Jurídico 1 (cliente nuevo)
INSERT INTO Cliente_Juridico (rif_cliente, razon_social, denominacion_comercial, capital_disponible, direccion_fiscal, direccion_fisica, pagina_web, lugar_id_lugar, lugar_id_lugar2)
SELECT 123456789, 'Empresa ABC C.A.', 'ABC Corp', 50000.00, 'Av. Comercial #789', 'Centro Comercial #101', 'www.abccorp.com', 1, 1
WHERE NOT EXISTS (SELECT 1 FROM Cliente_Juridico WHERE rif_cliente = 123456789);

-- =================================================================
-- 2. INSERTAR USUARIOS PARA LOS CLIENTES
-- =================================================================

INSERT INTO Usuario (id_cliente_natural, fecha_creacion, contraseña)
SELECT id_cliente, '2024-01-15', 'password123'
FROM Cliente_Natural 
WHERE ci_cliente = 12345678
AND NOT EXISTS (SELECT 1 FROM Usuario WHERE id_cliente_natural = Cliente_Natural.id_cliente);

INSERT INTO Usuario (id_cliente_natural, fecha_creacion, contraseña)
SELECT id_cliente, '2023-06-20', 'password456'
FROM Cliente_Natural 
WHERE ci_cliente = 87654321
AND NOT EXISTS (SELECT 1 FROM Usuario WHERE id_cliente_natural = Cliente_Natural.id_cliente);

INSERT INTO Usuario (id_cliente_juridico, fecha_creacion, contraseña)
SELECT id_cliente, '2024-02-10', 'password789'
FROM Cliente_Juridico 
WHERE rif_cliente = 123456789
AND NOT EXISTS (SELECT 1 FROM Usuario WHERE id_cliente_juridico = Cliente_Juridico.id_cliente);

-- =================================================================
-- 3. INSERTAR CORREOS PARA LOS CLIENTES
-- =================================================================

INSERT INTO Correo (nombre, extension_pag, id_cliente_natural)
SELECT 'juan.perez', 'gmail.com', id_cliente
FROM Cliente_Natural 
WHERE ci_cliente = 12345678
AND NOT EXISTS (SELECT 1 FROM Correo WHERE id_cliente_natural = Cliente_Natural.id_cliente AND nombre = 'juan.perez');

INSERT INTO Correo (nombre, extension_pag, id_cliente_natural)
SELECT 'maria.rodriguez', 'hotmail.com', id_cliente
FROM Cliente_Natural 
WHERE ci_cliente = 87654321
AND NOT EXISTS (SELECT 1 FROM Correo WHERE id_cliente_natural = Cliente_Natural.id_cliente AND nombre = 'maria.rodriguez');

INSERT INTO Correo (nombre, extension_pag, id_cliente_juridico)
SELECT 'ventas', 'abccorp.com', id_cliente
FROM Cliente_Juridico 
WHERE rif_cliente = 123456789
AND NOT EXISTS (SELECT 1 FROM Correo WHERE id_cliente_juridico = Cliente_Juridico.id_cliente AND nombre = 'ventas');

-- =================================================================
-- 4. INSERTAR COMPRAS DE PRUEBA (USANDO IDs ALTOS PARA EVITAR CONFLICTOS)
-- =================================================================

-- Compra 1: Cliente nuevo en el período actual
INSERT INTO Compra (monto_total, tienda_fisica_id_tienda, id_cliente_natural)
SELECT 150.00, 1, id_cliente
FROM Cliente_Natural 
WHERE ci_cliente = 12345678
AND NOT EXISTS (SELECT 1 FROM Compra WHERE id_cliente_natural = Cliente_Natural.id_cliente AND monto_total = 150.00);

-- Compra 2: Cliente recurrente en el período actual
INSERT INTO Compra (monto_total, tienda_fisica_id_tienda, id_cliente_natural)
SELECT 200.00, 1, id_cliente
FROM Cliente_Natural 
WHERE ci_cliente = 87654321
AND NOT EXISTS (SELECT 1 FROM Compra WHERE id_cliente_natural = Cliente_Natural.id_cliente AND monto_total = 200.00);

-- Compra 3: Cliente recurrente en el período actual (segunda compra)
INSERT INTO Compra (monto_total, tienda_web_id_tienda, id_cliente_natural)
SELECT 180.00, 1, id_cliente
FROM Cliente_Natural 
WHERE ci_cliente = 87654321
AND NOT EXISTS (SELECT 1 FROM Compra WHERE id_cliente_natural = Cliente_Natural.id_cliente AND monto_total = 180.00);

-- Compra 4: Cliente jurídico nuevo
INSERT INTO Compra (monto_total, tienda_fisica_id_tienda, id_cliente_juridico)
SELECT 350.00, 1, id_cliente
FROM Cliente_Juridico 
WHERE rif_cliente = 123456789
AND NOT EXISTS (SELECT 1 FROM Compra WHERE id_cliente_juridico = Cliente_Juridico.id_cliente AND monto_total = 350.00);

-- Compra 5: Cliente recurrente (tercera compra)
INSERT INTO Compra (monto_total, tienda_web_id_tienda, id_cliente_natural)
SELECT 120.00, 1, id_cliente
FROM Cliente_Natural 
WHERE ci_cliente = 87654321
AND NOT EXISTS (SELECT 1 FROM Compra WHERE id_cliente_natural = Cliente_Natural.id_cliente AND monto_total = 120.00);

-- =================================================================
-- 4.5. INSERTAR MÉTODOS DE PAGO (USANDO IDs ALTOS)
-- =================================================================

-- Métodos de pago para las compras (usando IDs altos para evitar conflictos)
INSERT INTO Metodo_Pago (id_metodo, id_cliente_natural)
SELECT 1000, id_cliente
FROM Cliente_Natural 
WHERE ci_cliente = 12345678
AND NOT EXISTS (SELECT 1 FROM Metodo_Pago WHERE id_metodo = 1000);

INSERT INTO Metodo_Pago (id_metodo, id_cliente_natural)
SELECT 1001, id_cliente
FROM Cliente_Natural 
WHERE ci_cliente = 87654321
AND NOT EXISTS (SELECT 1 FROM Metodo_Pago WHERE id_metodo = 1001);

INSERT INTO Metodo_Pago (id_metodo, id_cliente_natural)
SELECT 1002, id_cliente
FROM Cliente_Natural 
WHERE ci_cliente = 87654321
AND NOT EXISTS (SELECT 1 FROM Metodo_Pago WHERE id_metodo = 1002);

INSERT INTO Metodo_Pago (id_metodo, id_cliente_juridico)
SELECT 1003, id_cliente
FROM Cliente_Juridico 
WHERE rif_cliente = 123456789
AND NOT EXISTS (SELECT 1 FROM Metodo_Pago WHERE id_metodo = 1003);

INSERT INTO Metodo_Pago (id_metodo, id_cliente_natural)
SELECT 1004, id_cliente
FROM Cliente_Natural 
WHERE ci_cliente = 87654321
AND NOT EXISTS (SELECT 1 FROM Metodo_Pago WHERE id_metodo = 1004);

INSERT INTO Metodo_Pago (id_metodo, id_cliente_natural)
SELECT 1005, id_cliente
FROM Cliente_Natural 
WHERE ci_cliente = 87654321
AND NOT EXISTS (SELECT 1 FROM Metodo_Pago WHERE id_metodo = 1005);

-- =================================================================
-- 5. INSERTAR PAGOS DE COMPRA (USANDO IDs REALES DE LAS COMPRAS INSERTADAS)
-- =================================================================

-- Obtener los IDs reales de las compras insertadas y crear los pagos
INSERT INTO Pago_Compra (compra_id, monto, fecha_hora, metodo_id, referencia)
SELECT c.id_compra, 150.00, '2024-01-15 14:35:00', 1000, 'PAGO-001'
FROM Compra c
JOIN Cliente_Natural cn ON c.id_cliente_natural = cn.id_cliente
WHERE cn.ci_cliente = 12345678 AND c.monto_total = 150.00
AND NOT EXISTS (SELECT 1 FROM Pago_Compra WHERE compra_id = c.id_compra AND referencia = 'PAGO-001');

INSERT INTO Pago_Compra (compra_id, monto, fecha_hora, metodo_id, referencia)
SELECT c.id_compra, 200.00, '2024-01-20 16:50:00', 1001, 'PAGO-002'
FROM Compra c
JOIN Cliente_Natural cn ON c.id_cliente_natural = cn.id_cliente
WHERE cn.ci_cliente = 87654321 AND c.monto_total = 200.00
AND NOT EXISTS (SELECT 1 FROM Pago_Compra WHERE compra_id = c.id_compra AND referencia = 'PAGO-002');

INSERT INTO Pago_Compra (compra_id, monto, fecha_hora, metodo_id, referencia)
SELECT c.id_compra, 180.00, '2024-01-25 10:20:00', 1002, 'PAGO-003'
FROM Compra c
JOIN Cliente_Natural cn ON c.id_cliente_natural = cn.id_cliente
WHERE cn.ci_cliente = 87654321 AND c.monto_total = 180.00
AND NOT EXISTS (SELECT 1 FROM Pago_Compra WHERE compra_id = c.id_compra AND referencia = 'PAGO-003');

INSERT INTO Pago_Compra (compra_id, monto, fecha_hora, metodo_id, referencia)
SELECT c.id_compra, 350.00, '2024-02-10 12:05:00', 1003, 'PAGO-004'
FROM Compra c
JOIN Cliente_Juridico cj ON c.id_cliente_juridico = cj.id_cliente
WHERE cj.rif_cliente = 123456789 AND c.monto_total = 350.00
AND NOT EXISTS (SELECT 1 FROM Pago_Compra WHERE compra_id = c.id_compra AND referencia = 'PAGO-004');

INSERT INTO Pago_Compra (compra_id, monto, fecha_hora, metodo_id, referencia)
SELECT c.id_compra, 120.00, '2024-01-30 18:25:00', 1004, 'PAGO-005'
FROM Compra c
JOIN Cliente_Natural cn ON c.id_cliente_natural = cn.id_cliente
WHERE cn.ci_cliente = 87654321 AND c.monto_total = 120.00
AND NOT EXISTS (SELECT 1 FROM Pago_Compra WHERE compra_id = c.id_compra AND referencia = 'PAGO-005');

-- =================================================================
-- 6. INSERTAR DETALLES DE COMPRA CON DIFERENTES PRESENTACIONES
-- =================================================================

-- Detalle para Compra 1 (Botella 330ml)
INSERT INTO Detalle_Compra (id_compra, id_inventario, cantidad, precio_unitario, id_empleado)
SELECT c.id_compra, 1, 5, 30.00, 1
FROM Compra c
JOIN Cliente_Natural cn ON c.id_cliente_natural = cn.id_cliente
WHERE cn.ci_cliente = 12345678 AND c.monto_total = 150.00
AND NOT EXISTS (SELECT 1 FROM Detalle_Compra WHERE id_compra = c.id_compra AND id_inventario = 1);

-- Detalle para Compra 2 (Botella 500ml)
INSERT INTO Detalle_Compra (id_compra, id_inventario, cantidad, precio_unitario, id_empleado)
SELECT c.id_compra, 2, 4, 40.00, 2
FROM Compra c
JOIN Cliente_Natural cn ON c.id_cliente_natural = cn.id_cliente
WHERE cn.ci_cliente = 87654321 AND c.monto_total = 200.00
AND NOT EXISTS (SELECT 1 FROM Detalle_Compra WHERE id_compra = c.id_compra AND id_inventario = 2);

-- Detalle para Compra 3 (Lata 330ml)
INSERT INTO Detalle_Compra (id_compra, id_inventario, cantidad, precio_unitario, id_empleado)
SELECT c.id_compra, 3, 6, 30.00, 3
FROM Compra c
JOIN Cliente_Natural cn ON c.id_cliente_natural = cn.id_cliente
WHERE cn.ci_cliente = 87654321 AND c.monto_total = 180.00
AND NOT EXISTS (SELECT 1 FROM Detalle_Compra WHERE id_compra = c.id_compra AND id_inventario = 3);

-- Detalle para Compra 4 (Botella 330ml y 500ml)
INSERT INTO Detalle_Compra (id_compra, id_inventario, cantidad, precio_unitario, id_empleado)
SELECT c.id_compra, 1, 8, 30.00, 4
FROM Compra c
JOIN Cliente_Juridico cj ON c.id_cliente_juridico = cj.id_cliente
WHERE cj.rif_cliente = 123456789 AND c.monto_total = 350.00
AND NOT EXISTS (SELECT 1 FROM Detalle_Compra WHERE id_compra = c.id_compra AND id_inventario = 1);

INSERT INTO Detalle_Compra (id_compra, id_inventario, cantidad, precio_unitario, id_empleado)
SELECT c.id_compra, 2, 3, 40.00, 4
FROM Compra c
JOIN Cliente_Juridico cj ON c.id_cliente_juridico = cj.id_cliente
WHERE cj.rif_cliente = 123456789 AND c.monto_total = 350.00
AND NOT EXISTS (SELECT 1 FROM Detalle_Compra WHERE id_compra = c.id_compra AND id_inventario = 2);

-- Detalle para Compra 5 (Lata 330ml)
INSERT INTO Detalle_Compra (id_compra, id_inventario, cantidad, precio_unitario, id_empleado)
SELECT c.id_compra, 3, 4, 30.00, 5
FROM Compra c
JOIN Cliente_Natural cn ON c.id_cliente_natural = cn.id_cliente
WHERE cn.ci_cliente = 87654321 AND c.monto_total = 120.00
AND NOT EXISTS (SELECT 1 FROM Detalle_Compra WHERE id_compra = c.id_compra AND id_inventario = 3);

-- =================================================================
-- 7. INSERTAR COMPRAS DEL PERÍODO ANTERIOR PARA CÁLCULO DE CRECIMIENTO
-- =================================================================

-- Compra del período anterior (para calcular crecimiento)
INSERT INTO Compra (monto_total, tienda_fisica_id_tienda, id_cliente_natural)
SELECT 100.00, 1, id_cliente
FROM Cliente_Natural 
WHERE ci_cliente = 87654321
AND NOT EXISTS (SELECT 1 FROM Compra WHERE id_cliente_natural = Cliente_Natural.id_cliente AND monto_total = 100.00);

INSERT INTO Pago_Compra (compra_id, monto, fecha_hora, metodo_id, referencia)
SELECT c.id_compra, 100.00, '2023-12-15 15:35:00', 1005, 'PAGO-006'
FROM Compra c
JOIN Cliente_Natural cn ON c.id_cliente_natural = cn.id_cliente
WHERE cn.ci_cliente = 87654321 AND c.monto_total = 100.00
AND NOT EXISTS (SELECT 1 FROM Pago_Compra WHERE compra_id = c.id_compra AND referencia = 'PAGO-006');

INSERT INTO Detalle_Compra (id_compra, id_inventario, cantidad, precio_unitario, id_empleado)
SELECT c.id_compra, 1, 3, 30.00, 6
FROM Compra c
JOIN Cliente_Natural cn ON c.id_cliente_natural = cn.id_cliente
WHERE cn.ci_cliente = 87654321 AND c.monto_total = 100.00
AND NOT EXISTS (SELECT 1 FROM Detalle_Compra WHERE id_compra = c.id_compra AND id_inventario = 1);

-- =================================================================
-- 8. INSERTAR COMPRA_ESTATUS PARA MARCAR COMO PAGADAS (EVITANDO DUPLICADOS)
-- =================================================================

-- Marcar todas las compras como pagadas (estatus_id = 3)
INSERT INTO Compra_Estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion)
SELECT c.id_compra, 3, '2024-01-15 14:35:00'
FROM Compra c
JOIN Cliente_Natural cn ON c.id_cliente_natural = cn.id_cliente
WHERE cn.ci_cliente = 12345678 AND c.monto_total = 150.00
AND NOT EXISTS (SELECT 1 FROM Compra_Estatus WHERE compra_id_compra = c.id_compra AND estatus_id_estatus = 3);

INSERT INTO Compra_Estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion)
SELECT c.id_compra, 3, '2024-01-20 16:50:00'
FROM Compra c
JOIN Cliente_Natural cn ON c.id_cliente_natural = cn.id_cliente
WHERE cn.ci_cliente = 87654321 AND c.monto_total = 200.00
AND NOT EXISTS (SELECT 1 FROM Compra_Estatus WHERE compra_id_compra = c.id_compra AND estatus_id_estatus = 3);

INSERT INTO Compra_Estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion)
SELECT c.id_compra, 3, '2024-01-25 10:20:00'
FROM Compra c
JOIN Cliente_Natural cn ON c.id_cliente_natural = cn.id_cliente
WHERE cn.ci_cliente = 87654321 AND c.monto_total = 180.00
AND NOT EXISTS (SELECT 1 FROM Compra_Estatus WHERE compra_id_compra = c.id_compra AND estatus_id_estatus = 3);

INSERT INTO Compra_Estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion)
SELECT c.id_compra, 3, '2024-02-10 12:05:00'
FROM Compra c
JOIN Cliente_Juridico cj ON c.id_cliente_juridico = cj.id_cliente
WHERE cj.rif_cliente = 123456789 AND c.monto_total = 350.00
AND NOT EXISTS (SELECT 1 FROM Compra_Estatus WHERE compra_id_compra = c.id_compra AND estatus_id_estatus = 3);

INSERT INTO Compra_Estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion)
SELECT c.id_compra, 3, '2024-01-30 18:25:00'
FROM Compra c
JOIN Cliente_Natural cn ON c.id_cliente_natural = cn.id_cliente
WHERE cn.ci_cliente = 87654321 AND c.monto_total = 120.00
AND NOT EXISTS (SELECT 1 FROM Compra_Estatus WHERE compra_id_compra = c.id_compra AND estatus_id_estatus = 3);

INSERT INTO Compra_Estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion)
SELECT c.id_compra, 3, '2023-12-15 15:35:00'
FROM Compra c
JOIN Cliente_Natural cn ON c.id_cliente_natural = cn.id_cliente
WHERE cn.ci_cliente = 87654321 AND c.monto_total = 100.00
AND NOT EXISTS (SELECT 1 FROM Compra_Estatus WHERE compra_id_compra = c.id_compra AND estatus_id_estatus = 3);

-- =================================================================
-- 9. VERIFICAR QUE LOS DATOS SE INSERTARON CORRECTAMENTE
-- =================================================================

-- Mostrar resumen de datos insertados
SELECT 'Clientes Naturales' as tipo, COUNT(*) as cantidad FROM Cliente_Natural WHERE ci_cliente IN (12345678, 87654321)
UNION ALL
SELECT 'Clientes Jurídicos' as tipo, COUNT(*) as cantidad FROM Cliente_Juridico WHERE rif_cliente = 123456789
UNION ALL
SELECT 'Compras' as tipo, COUNT(*) as cantidad FROM Compra WHERE monto_total IN (150.00, 200.00, 180.00, 350.00, 120.00, 100.00)
UNION ALL
SELECT 'Pagos' as tipo, COUNT(*) as cantidad FROM Pago_Compra WHERE referencia LIKE 'PAGO-%'
UNION ALL
SELECT 'Compra_Estatus' as tipo, COUNT(*) as cantidad FROM Compra_Estatus WHERE estatus_id_estatus = 3;

-- =================================================================
-- FIN DE DATOS DE PRUEBA
-- ================================================================= 