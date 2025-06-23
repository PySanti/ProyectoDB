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

module.exports = router;
