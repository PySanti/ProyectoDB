const express = require('express');
const router = express.Router();
const ordenesController = require('../controllers/ordenesController.js');

router.get('/reposicion', ordenesController.getOrdenesReposicion);
router.get('/estatus', ordenesController.getEstatus);
router.post('/reposicion/:id/estatus', ordenesController.setEstatusOrdenReposicion);
router.get('/anaquel', ordenesController.getOrdenesAnaquel);
router.post('/anaquel/:id/estatus', ordenesController.setEstatusOrdenAnaquel);
router.get('/anaquel/:id/detalles', ordenesController.getDetalleOrdenAnaquel);
router.get('/reposicion/:id/detalles', ordenesController.getDetalleOrdenProveedor);
// Órdenes de compra
router.get('/compra', ordenesController.getOrdenesCompra);
router.get('/compra/:id/detalles', ordenesController.getDetalleOrdenCompra);
router.get('/compra/estatus', ordenesController.getEstatusOrdenCompra);
router.put('/compra/:id/estatus', ordenesController.setEstatusOrdenCompra);

module.exports = router; 