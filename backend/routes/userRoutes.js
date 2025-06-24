const express = require('express');
const router = express.Router();
const { loginController } = require('../controllers/loginController.js');
const { getUsuarios } = require('../controllers/userController.js');
const userController = require('../controllers/userController.js');

// Definir rutas
router.post('/login', loginController);
router.post('/signup', require('../controllers/signupController').signupUser);
router.get('/usuarios', getUsuarios);
router.post('/empleados', userController.createEmpleado);

// Nuevas rutas para validación de cliente
router.post('/validate-cedula', userController.validateCedula);
router.post('/register', userController.registerClienteNatural);

// Nuevas rutas para lugares
router.get('/estados', userController.getEstados);
router.get('/municipios', userController.getMunicipios);
router.get('/parroquias', userController.getParroquias);

module.exports = router;
