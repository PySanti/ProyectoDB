const express = require('express');
const router = express.Router();
const ordenesController = require('../controllers/ordenesController.js');

router.get('/reposicion', ordenesController.getOrdenesReposicion);
router.get('/estatus', ordenesController.getEstatus);
router.post('/reposicion/:id/estatus', ordenesController.setEstatusOrdenReposicion);

module.exports = router; 