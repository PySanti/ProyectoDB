// eventosRoutes.js
const express = require('express');
const router = express.Router();
const eventosController = require('../controllers/eventosController');

// GET Obtener todos los eventos
router.get('/', eventosController.getAllEventos);

// GET Obtener inventario de un evento específico
router.get('/:id_evento/inventario', eventosController.getInventarioEvento);

// POST Agregar producto al carrito de un evento
router.post('/:id_evento/agregar-producto', eventosController.agregarProductoEvento);

// GET  Obtener resumen del carrito de un evento
router.get('/:id_evento/carrito/:id_cliente_natural', eventosController.obtenerResumenCarritoEvento);

// GET Obtener items del carrito de un evento
router.get('/:id_evento/carrito/:id_cliente_natural/items', eventosController.obtenerItemsCarritoEvento);

// PUT Actualizar cantidad de un producto en el carrito de eventos
router.put('/:id_evento/actualizar-cantidad', eventosController.actualizarCantidadEvento);

// DELETE Eliminar un producto del carrito de eventos
router.delete('/:id_evento/eliminar-producto', eventosController.eliminarProductoEvento);

// DELETE Limpiar todo el carrito de un evento
router.delete('/:id_evento/limpiar-carrito/:id_cliente_natural', eventosController.limpiarCarritoEvento);

// PUT Actualizar evento (entradas vendidas y precio)
router.put('/:id_evento/actualizar', eventosController.actualizarEvento);

// POST Procesar pago de un evento
router.post('/:id_evento/procesar-pago', eventosController.procesarPagoEvento);

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