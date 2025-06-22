const db = require('../db_connection/index.js');

// Obtener todas las órdenes de reposición a proveedores con estatus actual
exports.getOrdenesReposicion = async (req, res) => {
  try {
    const { rows } = await db.pool.query('SELECT * FROM get_ordenes_reposicion_proveedores()');
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener las órdenes de reposición' });
  }
};

// Obtener todos los estatus posibles
exports.getEstatus = async (req, res) => {
  try {
    const { rows } = await db.pool.query('SELECT id_estatus, nombre FROM Estatus ORDER BY id_estatus');
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener los estatus' });
  }
};

// Cambiar el estatus de una orden de reposición
exports.setEstatusOrdenReposicion = async (req, res) => {
  const { id } = req.params; // id_orden_reposicion
  const { id_estatus } = req.body;
  try {
    await db.pool.query(
      'SELECT set_estatus_orden_reposicion($1, $2)',
      [id, id_estatus]
    );
    res.json({ message: 'Estatus actualizado correctamente' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al actualizar el estatus de la orden' });
  }
}; 