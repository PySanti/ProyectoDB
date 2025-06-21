const db = require('../db_connection/index.js');

exports.getUsuarios = async (req, res) => {
  try {
    const empleados = (await db.pool.query('SELECT * FROM get_usuarios_empleados()')).rows;
    const proveedores = (await db.pool.query('SELECT * FROM get_usuarios_proveedores()')).rows;
    const clientes_naturales = (await db.pool.query('SELECT * FROM get_usuarios_clientes_naturales()')).rows;
    const clientes_juridicos = (await db.pool.query('SELECT * FROM get_usuarios_clientes_juridicos()')).rows;
    res.json({ empleados, proveedores, clientes_naturales, clientes_juridicos });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener la lista de usuarios' });
  }
}; 