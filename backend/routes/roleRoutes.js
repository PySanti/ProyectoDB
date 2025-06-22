const express = require('express');
const router = express.Router();
const { getRoles, createRole, updateRole } = require('../controllers/roleController.js');
const roleController = require('../controllers/roleController.js');

router.get('/', getRoles);
router.post('/', createRole);
router.put('/:id', updateRole);
router.post('/usuario/:id/cambiar-rol', roleController.setRolUsuario);

module.exports = router; 