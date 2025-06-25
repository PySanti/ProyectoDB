const express = require('express');
const router = express.Router();
const reportesController = require('../controllers/reportesController.js');

// Definir rutas para reportes
router.get('/ranking-puntos', reportesController.getRankingPuntos);
router.get('/vacaciones-empleados', reportesController.getVacacionesEmpleados);
router.get('/cervezas-proveedores', reportesController.getCervezasProveedores);
router.get('/ingresos-por-tipo', reportesController.getIngresosPorTipo);
router.get('/comparativa-estilos', reportesController.getComparativaEstilos);

module.exports = router; 