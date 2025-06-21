const express = require('express');
const router = express.Router();
const { loginController } = require('../controllers/loginController.js');

// Definir rutas
router.post('/login', loginController);

module.exports = router;
