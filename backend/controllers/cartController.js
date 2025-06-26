const db = require('../db_connection');

// =================================================================
// OBTENER CARRITO DE USUARIO (CONSULTA)
// =================================================================
async function getCart(req, res) {
    const { id_usuario } = req.params;
    const { id_cliente_natural, id_cliente_juridico } = req.query;
    try {
        const result = await db.query(
            'SELECT * FROM obtener_carrito_usuario($1, $2, $3)', 
            [parseInt(id_usuario), id_cliente_natural || null, id_cliente_juridico || null]
        );
        res.json(result.rows);
    } catch (error) {
        console.error('Error al obtener el carrito:', error);
        res.status(500).json({ success: false, message: 'Error interno del servidor' });
    }
}

// =================================================================
// AGREGAR PRODUCTO AL CARRITO (FUNCIÓN)
// =================================================================
async function addToCart(req, res) {
    const { id_usuario, id_inventario, cantidad, id_cliente_natural, id_cliente_juridico } = req.body;
    try {
        await db.query(
            'SELECT agregar_al_carrito($1, $2, $3, $4, $5)', 
            [id_usuario, id_inventario, cantidad, id_cliente_natural || null, id_cliente_juridico || null]
        );
        res.json({ success: true, message: 'Producto agregado al carrito' });
    } catch (error) {
        console.error('Error al agregar al carrito:', error);
        res.status(500).json({ success: false, message: error.message });
    }
}

// =================================================================
// AGREGAR PRODUCTO AL CARRITO POR NOMBRE Y PRESENTACIÓN (FUNCIÓN)
// =================================================================
async function addToCartByProduct(req, res) {
    const { compra_id, nombre_cerveza, nombre_presentacion, cantidad } = req.body;
    if (!compra_id || !nombre_cerveza || !nombre_presentacion || !cantidad) {
        return res.status(400).json({ success: false, message: 'Datos incompletos para agregar al carrito.' });
    }
    try {
        // Buscar el id_inventario correspondiente
        const invResult = await db.query(
            `SELECT i.id_inventario FROM Inventario i
             JOIN Cerveza c ON i.id_cerveza = c.id_cerveza
             JOIN Presentacion p ON i.id_presentacion = p.id_presentacion
             WHERE c.nombre_cerveza = $1 AND p.nombre = $2 LIMIT 1`,
            [nombre_cerveza, nombre_presentacion]
        );
        if (invResult.rows.length === 0) {
            return res.status(404).json({ success: false, message: 'Inventario no encontrado para ese producto/presentación.' });
        }
        const id_inventario = invResult.rows[0].id_inventario;
        // Insertar el producto en el carrito usando el id_compra
        await db.query(
            'INSERT INTO Detalle_Compra (id_compra, id_inventario, cantidad, precio_unitario) SELECT $1, $2, $3, pc.precio FROM presentacion_cerveza pc JOIN Inventario i ON pc.id_cerveza = i.id_cerveza AND pc.id_presentacion = i.id_presentacion WHERE i.id_inventario = $2',
            [compra_id, id_inventario, cantidad]
        );
        res.json({ success: true, message: 'Producto agregado al carrito' });
    } catch (error) {
        console.error('Error al agregar al carrito:', error);
        res.status(500).json({ success: false, message: error.message });
    }
}

// =================================================================
// ACTUALIZAR CANTIDAD EN CARRITO (FUNCIÓN)
// =================================================================
async function updateCart(req, res) {
    const { id_usuario, id_inventario, nueva_cantidad, id_cliente_natural, id_cliente_juridico } = req.body;
    try {
        await db.query(
            'SELECT actualizar_cantidad_carrito($1, $2, $3, $4, $5)', 
            [id_usuario, id_inventario, nueva_cantidad, id_cliente_natural || null, id_cliente_juridico || null]
        );
        res.json({ success: true, message: 'Cantidad actualizada' });
    } catch (error) {
        console.error('Error al actualizar el carrito:', error);
        res.status(500).json({ success: false, message: error.message });
    }
}

// =================================================================
// ELIMINAR PRODUCTO DEL CARRITO (FUNCIÓN)
// =================================================================
async function removeFromCart(req, res) {
    const { id_usuario, id_inventario, id_cliente_natural, id_cliente_juridico } = req.body;
    try {
        await db.query(
            'SELECT eliminar_del_carrito($1, $2, $3, $4)', 
            [id_usuario, id_inventario, id_cliente_natural || null, id_cliente_juridico || null]
        );
        res.json({ success: true, message: 'Producto eliminado' });
    } catch (error) {
        console.error('Error al eliminar del carrito:', error);
        res.status(500).json({ success: false, message: error.message });
    }
}

// =================================================================
// LIMPIAR CARRITO (FUNCIÓN)
// =================================================================
async function clearCart(req, res) {
    const { id_usuario } = req.params;
    const { id_cliente_natural, id_cliente_juridico } = req.query;
    try {
        await db.query(
            'SELECT limpiar_carrito_usuario($1, $2, $3)', 
            [parseInt(id_usuario), id_cliente_natural || null, id_cliente_juridico || null]
        );
        res.json({ success: true, message: 'Carrito limpiado' });
    } catch (error) {
        console.error('Error al limpiar el carrito:', error);
        res.status(500).json({ success: false, message: error.message });
    }
}

// =================================================================
// OBTENER RESUMEN DEL CARRITO (CONSULTA)
// =================================================================
async function getCartSummary(req, res) {
    const { id_usuario } = req.params;
    const { id_cliente_natural, id_cliente_juridico } = req.query;
    try {
        const result = await db.query(
            'SELECT * FROM obtener_resumen_carrito($1, $2, $3)', 
            [parseInt(id_usuario), id_cliente_natural || null, id_cliente_juridico || null]
        );
        
        if (result.rows.length > 0) {
            res.json(result.rows[0]);
        } else {
            res.status(404).json({ success: false, message: 'No se encontró resumen del carrito' });
        }
    } catch (error) {
        console.error('Error al obtener el resumen del carrito:', error);
        res.status(500).json({ success: false, message: 'Error interno del servidor' });
    }
}

// =================================================================
// ACTUALIZAR MONTO DE COMPRA AL PROCEDER AL PAGO (FUNCIÓN)
// =================================================================
async function updatePurchaseAmount(req, res) {
    const { id_usuario, id_cliente_natural, id_cliente_juridico } = req.body;
    try {
        const result = await db.query(
            'SELECT actualizar_monto_compra($1, $2, $3)', 
            [id_usuario, id_cliente_natural || null, id_cliente_juridico || null]
        );
        const montoTotal = result.rows[0].actualizar_monto_compra;
        
        res.json({ 
            success: true, 
            message: 'Monto de compra actualizado correctamente',
            monto_total: montoTotal
        });
    } catch (error) {
        console.error('Error al actualizar monto de compra:', error);
        res.status(500).json({ success: false, message: error.message });
    }
}

// =================================================================
// VERIFICAR STOCK (CONSULTA)
// =================================================================
async function verifyStock(req, res) {
    const { id_usuario } = req.params;
    const { id_cliente_natural, id_cliente_juridico } = req.query;
    try {
        const result = await db.query(
            'SELECT * FROM verificar_stock_carrito($1, $2, $3)', 
            [parseInt(id_usuario), id_cliente_natural || null, id_cliente_juridico || null]
        );
        res.json(result.rows);
    } catch (error) {
        console.error('Error al verificar stock:', error);
        res.status(500).json({ success: false, message: 'Error interno del servidor' });
    }
}

// =================================================================
// REGISTRAR PAGOS DE UNA COMPRA
// =================================================================
async function registrarPagosCompra(req, res) {
    const { compra_id, pagos, cliente } = req.body;
    if (!compra_id || !pagos || !Array.isArray(pagos)) {
        return res.status(400).json({ success: false, message: 'Datos de pago incompletos.' });
    }
    if (!cliente) {
        console.warn('No se recibió cliente en el body del pago.');
    } else {
        console.log('Cliente recibido:', cliente);
    }
    const db = require('../db_connection');
    try {
        // 1. Actualizar el monto_total de la compra antes de registrar el pago
        await db.query(
            `UPDATE Compra SET monto_total = (
                SELECT COALESCE(SUM(dc.cantidad * dc.precio_unitario), 0)
                FROM Detalle_Compra dc
                WHERE dc.id_compra = $1
            ) WHERE id_compra = $1`,
            [compra_id]
        );

        // Llamar función SQL para registrar pagos y descontar inventario
        const result = await db.query(
            'SELECT registrar_pagos_y_descuento_inventario($1, $2::json) AS ok',
            [compra_id, JSON.stringify(pagos)]
        );
        if (result.rows[0].ok) {
            // Cerrar estatus "en proceso" (id 2) para esta compra
            await db.query(
                `UPDATE Compra_Estatus
                 SET fecha_hora_fin = NOW()
                 WHERE compra_id_compra = $1
                   AND estatus_id_estatus = 2
                   AND fecha_hora_fin = '9999-12-31 23:59:59'`,
                [compra_id]
            );
            // Crear estatus "pagado" (id 3) para esta compra
            await db.query(
                `INSERT INTO Compra_Estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion, fecha_hora_fin)
                 VALUES ($1, 3, NOW(), NOW())`,
                [compra_id]
            );
            
            return res.json({ 
                success: true, 
                message: 'Pagos registrados y estatus actualizado exitosamente.'
            });
        } else {
            return res.status(500).json({ success: false, message: 'No se pudo registrar el pago.' });
        }
    } catch (err) {
        console.error(err);
        return res.status(500).json({ success: false, message: err.message || 'Error al registrar pagos.' });
    }
}

// =================================================================
// Ejemplo de endpoint para crear carrito/compra (ajusta según tu flujo real)
// =================================================================
async function createOrGetCart(req, res) {
    const { cliente } = req.body;
    let id_cliente_natural = null;
    let id_cliente_juridico = null;
    if (!cliente) {
        return res.status(400).json({ success: false, message: 'Se requiere un cliente para tienda física.' });
    }
    if (cliente.tipo === 'natural') {
        id_cliente_natural = cliente.id;
    } else if (cliente.tipo === 'juridico') {
        id_cliente_juridico = cliente.id;
    } else {
        return res.status(400).json({ success: false, message: 'Tipo de cliente no válido.' });
    }
    try {
        const result = await db.query(
            'SELECT obtener_o_crear_carrito_cliente_en_proceso($1, $2) AS id_compra',
            [id_cliente_natural, id_cliente_juridico]
        );
        res.json({ success: true, id_compra: result.rows[0].id_compra });
    } catch (error) {
        console.error('Error al crear/obtener carrito:', error);
        res.status(500).json({ success: false, message: 'Error interno del servidor' });
    }
}

// ================= FLUJO ROBUSTO POR COMPRA_ID =================

// Obtener carrito por compra_id
async function getCartByCompraId(req, res) {
    const { compra_id } = req.params;
    try {
        const result = await db.query('SELECT * FROM obtener_carrito_por_id($1)', [compra_id]);
        res.json(result.rows);
    } catch (error) {
        console.error('Error al obtener carrito por id:', error);
        res.status(500).json({ success: false, message: error.message });
    }
}

// Actualizar cantidad por compra_id
async function updateCartByCompraId(req, res) {
    const { compra_id, id_inventario, nueva_cantidad } = req.body;
    try {
        await db.query('SELECT actualizar_cantidad_carrito_por_id($1, $2, $3)', [compra_id, id_inventario, nueva_cantidad]);
        res.json({ success: true, message: 'Cantidad actualizada' });
    } catch (error) {
        console.error('Error al actualizar cantidad por id:', error);
        res.status(500).json({ success: false, message: error.message });
    }
}

// Eliminar producto por compra_id
async function removeFromCartByCompraId(req, res) {
    const { compra_id, id_inventario } = req.body;
    try {
        await db.query('SELECT eliminar_del_carrito_por_id($1, $2)', [compra_id, id_inventario]);
        res.json({ success: true, message: 'Producto eliminado' });
    } catch (error) {
        console.error('Error al eliminar producto por id:', error);
        res.status(500).json({ success: false, message: error.message });
    }
}

// Limpiar carrito por compra_id
async function clearCartByCompraId(req, res) {
    const { compra_id } = req.params;
    try {
        await db.query('SELECT limpiar_carrito_por_id($1)', [compra_id]);
        res.json({ success: true, message: 'Carrito limpiado' });
    } catch (error) {
        console.error('Error al limpiar carrito por id:', error);
        res.status(500).json({ success: false, message: error.message });
    }
}

// Obtener resumen por compra_id
async function getCartSummaryByCompraId(req, res) {
    let { compra_id } = req.params;
    compra_id = parseInt(compra_id, 10);
    if (isNaN(compra_id)) {
        return res.status(400).json({ success: false, message: 'ID de compra inválido' });
    }
    try {
        const result = await db.query('SELECT * FROM obtener_resumen_carrito_por_id($1)', [compra_id]);
        if (result.rows.length > 0) {
            res.json(result.rows[0]);
        } else {
            res.status(404).json({ success: false, message: 'No se encontró resumen del carrito' });
        }
    } catch (error) {
        console.error('Error al obtener resumen por id:', error);
        res.status(500).json({ success: false, message: error.message });
    }
}

// =================================================================
// AGREGAR PRODUCTO AL CARRITO POR COMPRA_ID (FUNCIÓN)
// =================================================================
async function addProductToCart(req, res) {
    const { compra_id, id_inventario, cantidad } = req.body;
    if (!compra_id || !id_inventario || !cantidad) {
        return res.status(400).json({ success: false, message: 'Datos incompletos para agregar al carrito.' });
    }
    try {
        // Verificar que la compra esté en proceso
        const statusResult = await db.query(
            `SELECT e.nombre FROM Compra_Estatus ce
             JOIN Estatus e ON ce.estatus_id_estatus = e.id_estatus
             WHERE ce.compra_id_compra = $1 AND ce.fecha_hora_fin = '9999-12-31 23:59:59'`,
            [compra_id]
        );
        if (statusResult.rows.length === 0 || statusResult.rows[0].nombre.toLowerCase() !== 'en proceso') {
            return res.status(400).json({ success: false, message: 'La compra no está en proceso o ya fue pagada.' });
        }
        // Insertar el producto en el carrito usando el id_compra
        await db.query(
            'INSERT INTO Detalle_Compra (id_compra, id_inventario, cantidad, precio_unitario) SELECT $1, $2, $3, pc.precio FROM presentacion_cerveza pc JOIN Inventario i ON pc.id_cerveza = i.id_cerveza AND pc.id_presentacion = i.id_presentacion WHERE i.id_inventario = $2 ON CONFLICT (id_inventario, id_compra) DO UPDATE SET cantidad = Detalle_Compra.cantidad + EXCLUDED.cantidad',
            [compra_id, id_inventario, cantidad]
        );
        res.json({ success: true, message: 'Producto agregado al carrito' });
    } catch (error) {
        console.error('Error al agregar al carrito:', error);
        res.status(500).json({ success: false, message: error.message });
    }
}

module.exports = {
    getCart,
    addToCart,
    addToCartByProduct,
    updateCart,
    removeFromCart,
    clearCart,
    getCartSummary,
    updatePurchaseAmount,
    verifyStock,
    registrarPagosCompra,
    createOrGetCart,
    // Nuevos robustos por compra_id
    getCartByCompraId,
    updateCartByCompraId,
    removeFromCartByCompraId,
    clearCartByCompraId,
    getCartSummaryByCompraId,
    addProductToCart
}; 