const express = require('express');
const router = express.Router();
const puntosController = require('../controllers/puntosController');

// Obtener saldo de puntos de un cliente
router.get('/saldo/:id_cliente_natural', puntosController.obtenerSaldoPuntos);

// Obtener información completa de puntos de un cliente
router.get('/info/:id_cliente_natural', puntosController.obtenerInfoPuntos);

// Obtener historial de movimientos de puntos
router.get('/historial/:id_cliente_natural', puntosController.obtenerHistorialPuntos);

// Validar si un cliente puede usar puntos
router.post('/validar', puntosController.validarUsoPuntos);

// Usar puntos como método de pago
router.post('/usar', puntosController.usarPuntosComoPago);

// Obtener configuración del sistema de puntos
router.get('/configuracion', puntosController.obtenerConfiguracionPuntos);

// Diagnosticar puntos de un cliente (para debugging)
router.get('/diagnostico/:id_cliente_natural', puntosController.diagnosticarPuntosCliente);

// Limpiar puntos de un cliente (para resetear)
router.delete('/limpiar/:id_cliente_natural', puntosController.limpiarPuntosCliente);

// Diagnosticar tasas de puntos (para debugging)
router.get('/diagnostico-tasas', puntosController.diagnosticarTasasPuntos);

module.exports = router; 