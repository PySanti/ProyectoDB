const express = require('express');
const router = express.Router();
const { getTasaActual, actualizarTasa } = require('../controllers/tasaController');

// Obtener la tasa actual
router.get('/actual', getTasaActual);

// Actualizar la tasa
router.post('/actualizar', actualizarTasa);

module.exports = router; 