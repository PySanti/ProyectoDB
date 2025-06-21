const express = require('express');
const router = express.Router();
const { loginController } = require('../controllers/loginController.js');
const { getUsuarios } = require('../controllers/userController.js');

// Definir rutas
router.post('/login', loginController);
router.post('/signup', require('../controllers/signupController').signupUser);
router.get('/usuarios', getUsuarios);

module.exports = router;
