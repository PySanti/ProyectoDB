const express = require('express');
const router = express.Router();
const cartController = require('../controllers/cartController');

// Rutas para el carrito de compras

// GET /api/carrito/usuario/:id_usuario - Obtener carrito de un usuario
router.get('/usuario/:id_usuario', cartController.getCart);

// POST /api/carrito/agregar - Agregar producto al carrito
router.post('/agregar', cartController.addToCart);

// POST /api/carrito/agregar-por-producto - Agregar producto al carrito por nombre y presentación
router.post('/agregar-por-producto', cartController.addToCartByProduct);

// PUT /api/carrito/actualizar - Actualizar cantidad de un producto
router.put('/actualizar', cartController.updateCart);

// DELETE /api/carrito/eliminar - Eliminar producto del carrito
router.delete('/eliminar', cartController.removeFromCart);

// DELETE /api/carrito/limpiar/:id_usuario - Limpiar carrito completo
router.delete('/limpiar/:id_usuario', cartController.clearCart);

// GET /api/carrito/resumen/:id_usuario - Obtener resumen del carrito
router.get('/resumen/:id_usuario', cartController.getCartSummary);

// GET /api/carrito/verificar-stock/:id_usuario - Verificar stock del carrito
router.get('/verificar-stock/:id_usuario', cartController.verifyStock);

// PUT /api/carrito/actualizar-monto - Actualizar monto de compra al proceder al pago
router.put('/actualizar-monto', cartController.updatePurchaseAmount);

module.exports = router; 