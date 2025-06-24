const db = require('../db_connection/index.js');

exports.getRoles = async (req, res) => {
  try {
    const { rows } = await db.query('SELECT * FROM get_roles()');
    res.json({ roles: rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener los roles' });
  }
};

exports.createRole = async (req, res) => {
  const { nombre, privilegios } = req.body;
  if (!nombre || !Array.isArray(privilegios) || privilegios.length === 0) {
    return res.status(400).json({ error: 'Datos incompletos' });
  }
  try {
    await db.query('SELECT create_role($1, $2::json)', [nombre, JSON.stringify(privilegios)]);
    res.status(201).json({ message: 'Rol creado exitosamente' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al crear el rol' });
  }
};

exports.updateRole = async (req, res) => {
  const { id } = req.params;
  const { nombre, privilegios } = req.body;
  if (!nombre || !Array.isArray(privilegios) || privilegios.length === 0) {
    return res.status(400).json({ error: 'Datos incompletos' });
  }
  try {
    await db.query('SELECT update_role_privileges($1, $2, $3::json)', [parseInt(id), nombre, JSON.stringify(privilegios)]);
    res.json({ message: 'Rol actualizado exitosamente' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al actualizar el rol' });
  }
};

// Cambiar el rol de un usuario
exports.setRolUsuario = async (req, res) => {
  const { id } = req.params; // id_usuario
  const { id_rol } = req.body;
  try {
    await db.query('SELECT set_rol_usuario($1, $2)', [id, id_rol]);
    res.json({ message: 'Rol actualizado correctamente' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al actualizar el rol del usuario' });
  }
}; 