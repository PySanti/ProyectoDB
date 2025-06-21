const express = require('express');
const router = express.Router();
const { loginController } = require('../controllers/loginController.js');

// Definir rutas
router.post('/login', loginController);
router.post('/signup', require('../controllers/signupController').signupUser);

module.exports = router;
