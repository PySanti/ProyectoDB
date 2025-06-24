const express = require('express');
const router = express.Router();
const reportesController = require('../controllers/reportesController.js');

// Definir rutas para reportes
router.get('/ranking-puntos', reportesController.getRankingPuntos);

module.exports = router; 