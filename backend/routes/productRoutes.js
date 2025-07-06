const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');

// GET /api/productos - Obtener todos los productos para el catálogo
router.get('/', productController.getProducts);

// GET /api/productos/web - Obtener productos para venta web
router.get('/web', productController.getProductsWeb);

// GET /api/productos/tienda - Obtener productos para venta en tienda física
router.get('/tienda', productController.getProductsTienda);

module.exports = router; 