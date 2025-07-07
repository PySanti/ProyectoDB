const express = require('express');
const router = express.Router();
const reportesController = require('../controllers/reportesController.js');

// Definir rutas para reportes
router.get('/ranking-puntos', reportesController.getRankingPuntos);
router.get('/vacaciones-empleados', reportesController.getVacacionesEmpleados);
router.get('/cervezas-proveedores', reportesController.getCervezasProveedores);
router.get('/ingresos-por-tipo', reportesController.getIngresosPorTipo);
router.get('/comparativa-estilos', reportesController.getComparativaEstilos);

// =================================================================
// RUTAS PARA INDICADORES DE VENTAS
// =================================================================
router.get('/indicadores-ventas', reportesController.getIndicadoresVentas);
router.get('/ventas-por-estilo', reportesController.getVentasPorEstilo);
router.get('/ventas-por-periodo', reportesController.getVentasPorPeriodo);

// Ruta para dashboard de datos de ventas
router.get('/dashboard/ventas', reportesController.getDashboardVentas);

// Volumen vendido por presentación
router.get('/volumen-por-presentacion', reportesController.getVolumenPorPresentacion);

// Indicadores de clientes
router.get('/indicadores-clientes', reportesController.getIndicadoresClientes);

// =================================================================
// RUTAS PARA INDICADORES DE INVENTARIO Y OPERACIONES
// =================================================================
router.get('/rotacion-inventario', reportesController.getRotacionInventario);
router.get('/tasa-ruptura-stock', reportesController.getTasaRupturaStock);
router.get('/ventas-por-empleado', reportesController.getVentasPorEmpleado);

// Datos relevantes para dashboard
router.get('/tendencia-ventas', reportesController.getTendenciaVentas);
router.get('/ventas-por-canal', reportesController.getVentasPorCanal);
router.get('/top-productos-vendidos', reportesController.getTopProductosVendidos);
router.get('/stock-actual', reportesController.getStockActual);

module.exports = router; 