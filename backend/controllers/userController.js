const db = require('../db_connection/index.js');

exports.getUsuarios = async (req, res) => {
  try {
    const empleados = (await db.query('SELECT * FROM get_usuarios_empleados()')).rows;
    const proveedores = (await db.query('SELECT * FROM get_usuarios_proveedores()')).rows;
    const clientes_naturales = (await db.query('SELECT * FROM get_usuarios_clientes_naturales()')).rows;
    const clientes_juridicos = (await db.query('SELECT * FROM get_usuarios_clientes_juridicos()')).rows;
    res.json({ empleados, proveedores, clientes_naturales, clientes_juridicos });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener la lista de usuarios' });
  }
};

exports.createEmpleado = async (req, res) => {
  const {
    cedula,
    primer_nombre,
    segundo_nombre,
    primer_apellido,
    segundo_apellido,
    direccion,
    lugar_id_lugar,
    correo_nombre,
    correo_extension,
    contrasena
  } = req.body;

  try {
    await db.query(
      'SELECT create_empleado($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)',
      [
        cedula,
        primer_nombre,
        segundo_nombre,
        primer_apellido,
        segundo_apellido,
        direccion,
        lugar_id_lugar,
        correo_nombre,
        correo_extension,
        contrasena
      ]
    );
    res.status(201).json({ message: 'Empleado creado exitosamente' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al crear el empleado' });
  }
}; 