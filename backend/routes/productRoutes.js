const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');

// GET /api/productos - Obtener todos los productos para el catálogo
router.get('/', productController.getProducts);

module.exports = router; 