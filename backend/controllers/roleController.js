const db = require('../db_connection/index.js');

exports.getRoles = async (req, res) => {
  try {
    const { rows } = await db.pool.query('SELECT * FROM get_roles()');
    res.json({ roles: rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener los roles' });
  }
};

exports.createRole = async (req, res) => {
  const { nombre, permisos } = req.body;
  const { crear, eliminar, actualizar, leer } = permisos;

  try {
    await db.pool.query('SELECT create_role($1, $2, $3, $4, $5)', [nombre, !!crear, !!eliminar, !!actualizar, !!leer]);
    res.status(201).json({ message: 'Rol creado exitosamente' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al crear el rol' });
  }
};

exports.updateRole = async (req, res) => {
  const { id } = req.params;
  const { nombre, permisos } = req.body;
  const { crear, eliminar, actualizar, leer } = permisos;

  try {
    await db.pool.query('SELECT update_role_privileges($1, $2, $3, $4, $5, $6)', [
      parseInt(id), nombre, !!crear, !!eliminar, !!actualizar, !!leer
    ]);
    res.json({ message: 'Rol actualizado exitosamente' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al actualizar el rol' });
  }
}; 