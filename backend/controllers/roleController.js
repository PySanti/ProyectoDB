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
  const { crear, eliminar, actualizar, insertar } = permisos;

  try {
    await db.pool.query('SELECT create_role($1, $2, $3, $4, $5)', [nombre, !!crear, !!eliminar, !!actualizar, !!insertar]);
    res.status(201).json({ message: 'Rol creado exitosamente' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al crear el rol' });
  }
}; 