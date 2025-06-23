const db = require('../db_connection');

// =================================================================
// OBTENER CARRITO DE USUARIO (CONSULTA)
// =================================================================
async function getCart(req, res) {
    const { id_usuario } = req.params;
    try {
        const result = await db.query('SELECT * FROM obtener_carrito_usuario($1)', [parseInt(id_usuario)]);
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
    const { id_usuario, id_inventario, cantidad } = req.body;
    try {
        await db.query('SELECT agregar_al_carrito($1, $2, $3)', [id_usuario, id_inventario, cantidad]);
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
    const { id_usuario, id_inventario, nueva_cantidad } = req.body;
    try {
        await db.query('SELECT actualizar_cantidad_carrito($1, $2, $3)', [id_usuario, id_inventario, nueva_cantidad]);
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
    const { id_usuario, id_inventario } = req.body;
    try {
        await db.query('SELECT eliminar_del_carrito($1, $2)', [id_usuario, id_inventario]);
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
    try {
        await db.query('SELECT limpiar_carrito_usuario($1)', [parseInt(id_usuario)]);
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
    try {
        const result = await db.query('SELECT * FROM obtener_resumen_carrito($1)', [parseInt(id_usuario)]);
        
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
// VERIFICAR STOCK (CONSULTA)
// =================================================================
async function verifyStock(req, res) {
    const { id_usuario } = req.params;
    try {
        const result = await db.query('SELECT * FROM verificar_stock_carrito($1)', [parseInt(id_usuario)]);
        res.json(result.rows);
    } catch (error) {
        console.error('Error al verificar stock:', error);
        res.status(500).json({ success: false, message: 'Error interno del servidor' });
    }
}

module.exports = {
    getCart,
    addToCart,
    updateCart,
    removeFromCart,
    clearCart,
    getCartSummary,
    verifyStock,
}; 