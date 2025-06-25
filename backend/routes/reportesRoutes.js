const express = require('express');
const router = express.Router();
const reportesController = require('../controllers/reportesController.js');

// Definir rutas para reportes
router.get('/ranking-puntos', reportesController.getRankingPuntos);
router.get('/vacaciones-empleados', reportesController.getVacacionesEmpleados);
router.get('/cervezas-proveedores', reportesController.getCervezasProveedores);

module.exports = router; 