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
    const { id_usuario, nombre_cerveza, nombre_presentacion, cantidad, tipo_venta, id_ubicacion, id_cliente_natural, id_cliente_juridico } = req.body;
    try {
        await db.query(
            'SELECT agregar_al_carrito_por_producto($1, $2, $3, $4, $5, $6, $7, $8)',
            [
                id_usuario,
                nombre_cerveza,
                nombre_presentacion,
                cantidad,
                tipo_venta, // 'web' o 'fisica'
                id_ubicacion || null, // null para web, id del anaquel para física
                id_cliente_natural || null,
                id_cliente_juridico || null
            ]
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
    console.log('Body recibido en registrarPagosCompra:', req.body);
    if (!compra_id || !Array.isArray(pagos) || pagos.length === 0) {
        return res.status(400).json({ success: false, message: 'Datos de pago incompletos.' });
    }
    if (!cliente) {
        console.warn('No se recibió cliente en el body del pago.');
    } else {
        console.log('Cliente recibido:', cliente);
    }
    const db = require('../db_connection');
    try {
        // Llamar función SQL
        const result = await db.query(
            'SELECT registrar_pagos_y_descuento_inventario($1, $2::json) AS ok',
            [compra_id, JSON.stringify(pagos)]
        );
        if (result.rows[0].ok) {
            return res.json({ success: true, message: 'Pagos registrados y stock descontado exitosamente.' });
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
    const { id_usuario, cliente } = req.body;
    console.log('createOrGetCart - id_usuario:', id_usuario, 'cliente:', cliente);
    
    let id_cliente_natural = null;
    let id_cliente_juridico = null;
    let final_id_usuario = null;
    
    if (cliente) {
        // Compra en tienda física - usar cliente, NO usuario
        if (cliente.tipo === 'natural') {
            id_cliente_natural = cliente.id;
            console.log('Cliente natural detectado, ID:', id_cliente_natural);
        } else if (cliente.tipo === 'juridico') {
            id_cliente_juridico = cliente.id;
            console.log('Cliente jurídico detectado, ID:', id_cliente_juridico);
        }
        // Para tienda física, usuario_id_usuario debe ser NULL
        final_id_usuario = null;
    } else {
        // Compra web - usar usuario, NO cliente
        final_id_usuario = id_usuario;
        console.log('Compra web detectada, usuario ID:', final_id_usuario);
    }
    
    try {
        console.log('Llamando a obtener_o_crear_carrito_usuario con:', {
            id_usuario: final_id_usuario,
            id_cliente_natural,
            id_cliente_juridico
        });
        
        const result = await db.query(
            'SELECT obtener_o_crear_carrito_usuario($1, $2, $3) AS id_compra',
            [final_id_usuario, id_cliente_natural, id_cliente_juridico]
        );
        
        console.log('Compra creada/obtenida con ID:', result.rows[0].id_compra);
        res.json({ success: true, id_compra: result.rows[0].id_compra });
    } catch (error) {
        console.error('Error al crear/obtener carrito:', error);
        res.status(500).json({ success: false, message: 'Error interno del servidor' });
    }
}

// =================================================================
// OBTENER ID DE COMPRA EN PROCESO PARA USUARIO/CLIENTE
// =================================================================
async function getCompraId(req, res) {
    const { id_usuario, id_cliente_natural, id_cliente_juridico } = req.query;
    try {
        const result = await db.query(
            'SELECT obtener_carrito_por_tipo($1, $2, $3) AS id_compra',
            [id_usuario, id_cliente_natural || null, id_cliente_juridico || null]
        );
        res.json({ id_compra: result.rows[0].id_compra });
    } catch (error) {
        console.error('Error al obtener id_compra:', error);
        res.status(500).json({ success: false, message: 'Error interno del servidor' });
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
    getCompraId,
    createOrGetCart
}; 