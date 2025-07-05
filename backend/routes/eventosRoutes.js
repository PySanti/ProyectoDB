// eventosRoutes.js
const express = require('express');
const router = express.Router();
const eventosController = require('../controllers/eventosController');

// Rutas para obtener los datos de la base de datos
router.get('/tipos', eventosController.getTiposEvento);
router.get('/lugares', eventosController.getLugares);
router.get('/invitados', eventosController.getInvitados);
router.get('/proveedores', eventosController.getProveedores);
router.get('/cervezas', eventosController.getCervezas);
router.get('/presentaciones', eventosController.getPresentaciones);
router.get('/presentaciones/:id_cerveza', eventosController.getPresentacionesPorCerveza);
router.get('/tipos-actividad', eventosController.getTiposActividad);

// Ruta para crear evento completo
router.post('/crear', eventosController.crearEvento);

module.exports = router; 