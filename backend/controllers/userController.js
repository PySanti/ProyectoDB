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
    const result = await db.query(
      'SELECT * FROM create_empleado($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)',
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
    const empleadoCreado = result.rows[0];
    // Normalizar el campo id_usuario si viene como usuario_id
    if (empleadoCreado && empleadoCreado.usuario_id && !empleadoCreado.id_usuario) {
      empleadoCreado.id_usuario = empleadoCreado.usuario_id;
    }
    res.status(201).json({ message: 'Empleado creado exitosamente', empleado: empleadoCreado });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al crear el empleado' });
  }
};

// Nueva función para validar cédula de cliente
exports.validateCedula = async (req, res) => {
  let { cedula } = req.body;

  if (!cedula) {
    return res.status(400).json({ error: 'Cédula es requerida' });
  }

  // Convertir a número
  cedula = parseInt(cedula, 10);
  if (isNaN(cedula)) {
    return res.status(400).json({ error: 'Cédula inválida' });
  }

  try {
    // Buscar en clientes naturales
    const clienteNatural = (await db.query(
      'SELECT * FROM get_cliente_natural_by_cedula($1)',
      [cedula]
    )).rows[0];

    if (clienteNatural) {
      return res.json({
        exists: true,
        client: {
          id: clienteNatural.id_cliente,
          cedula: clienteNatural.ci_cliente,
          nombre: [clienteNatural.primer_nombre, clienteNatural.segundo_nombre, clienteNatural.primer_apellido, clienteNatural.segundo_apellido].filter(Boolean).join(' '),
          email: clienteNatural.correo_nombre && clienteNatural.correo_extension ? (clienteNatural.correo_nombre + '@' + clienteNatural.correo_extension) : '',
          telefono: clienteNatural.telefono || '',
          tipo: 'natural'
        }
      });
    }

    // Buscar en clientes jurídicos
    const clienteJuridico = (await db.query(
      'SELECT * FROM get_cliente_juridico_by_rif($1)',
      [cedula]
    )).rows[0];

    if (clienteJuridico) {
      return res.json({
        exists: true,
        client: {
          id: clienteJuridico.id_cliente,
          cedula: clienteJuridico.rif_cliente,
          nombre: clienteJuridico.razon_social,
          email: clienteJuridico.correo_nombre && clienteJuridico.correo_extension ? (clienteJuridico.correo_nombre + '@' + clienteJuridico.correo_extension) : '',
          telefono: clienteJuridico.telefono || '',
          tipo: 'juridico'
        }
      });
    }

    // Cliente no encontrado
    res.json({
      exists: false,
      message: 'Cliente no encontrado'
    });

  } catch (err) {
    console.error('Error al validar cédula:', err);
    res.status(500).json({ error: 'Error al validar cédula' });
  }
};

// Nueva función para registrar cliente natural
exports.registerClienteNatural = async (req, res) => {
  let {
    cedula,
    rif_cliente,
    primer_nombre,
    segundo_nombre,
    primer_apellido,
    segundo_apellido,
    email,
    codigo_area,
    telefono,
    estado,
    municipio,
    parroquia,
    fecha_nacimiento, // No se usa en SQL, pero se puede guardar después
    direccion
  } = req.body;

  if (!cedula || !primer_nombre || !primer_apellido || !email || !telefono || !estado || !municipio || !parroquia) {
    return res.status(400).json({ error: 'Cédula, primer nombre, primer apellido, email, teléfono, estado, municipio y parroquia son requeridos' });
  }

  // Convertir a número
  cedula = parseInt(cedula, 10);
  if (isNaN(cedula)) {
    return res.status(400).json({ error: 'Cédula inválida' });
  }
  rif_cliente = rif_cliente ? parseInt(rif_cliente, 10) : 0;

  // Usar directamente el ID de la parroquia como lugar_id_lugar
  // El frontend envía los IDs correctos, no los nombres
  const lugar_id_lugar = parseInt(parroquia, 10);
  if (isNaN(lugar_id_lugar)) {
    return res.status(400).json({ error: 'ID de parroquia inválido' });
  }

  // Verificar que el lugar existe y obtener los nombres para la dirección
  const lugarInfo = await db.query(`
    SELECT 
      l3.id_lugar,
      l1.nombre as estado_nombre,
      l2.nombre as municipio_nombre,
      l3.nombre as parroquia_nombre
    FROM Lugar l1 
    JOIN Lugar l2 ON l2.lugar_relacion_id = l1.id_lugar 
    JOIN Lugar l3 ON l3.lugar_relacion_id = l2.id_lugar 
    WHERE l3.id_lugar = $1 AND l1.tipo = 'Estado' AND l2.tipo = 'Municipio' AND l3.tipo = 'Parroquia'
  `, [lugar_id_lugar]);

  if (lugarInfo.rows.length === 0) {
    return res.status(400).json({ error: 'La ubicación especificada no existe' });
  }

  const lugar = lugarInfo.rows[0];
  const ubicacion = `${lugar.estado_nombre}, ${lugar.municipio_nombre}, ${lugar.parroquia_nombre}`;
  const direccion_final = ubicacion + (direccion ? (', ' + direccion) : '');

  try {
    // Separar email
    const [correo_nombre, correo_extension] = email.split('@');
    if (!correo_extension) {
      return res.status(400).json({ error: 'Email inválido' });
    }

    // Verificar si la cédula ya existe
    const clienteExistente = (await db.query(
      'SELECT * FROM get_cliente_natural_by_cedula($1)',
      [cedula]
    )).rows[0];

    if (clienteExistente) {
      return res.status(400).json({ error: 'Ya existe un cliente con esta cédula' });
    }

    // Crear cliente natural
    await db.query(
      'SELECT create_cliente_natural_fisica($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)',
      [
        cedula,
        rif_cliente,
        primer_nombre,
        segundo_nombre || '',
        primer_apellido,
        segundo_apellido || '',
        direccion_final,
        lugar_id_lugar,
        correo_nombre,
        correo_extension,
        codigo_area,
        telefono
      ]
    );

    // Obtener el cliente creado
    const clienteCreado = (await db.query(
      'SELECT * FROM get_cliente_natural_by_cedula($1)',
      [cedula]
    )).rows[0];

    res.status(201).json({
      message: 'Cliente registrado exitosamente',
      client: {
        id: clienteCreado.id_cliente,
        cedula: clienteCreado.ci_cliente,
        nombre: [clienteCreado.primer_nombre, clienteCreado.segundo_nombre, clienteCreado.primer_apellido, clienteCreado.segundo_apellido].filter(Boolean).join(' '),
        email: clienteCreado.correo_nombre && clienteCreado.correo_extension ? (clienteCreado.correo_nombre + '@' + clienteCreado.correo_extension) : '',
        telefono: clienteCreado.telefono || '',
        tipo: 'natural',
        direccion: clienteCreado.direccion
      }
    });

  } catch (err) {
    console.error('Error al registrar cliente:', err);
    res.status(500).json({ error: 'Error al registrar cliente' });
  }
};

// ENDPOINTS PARA LUGARES
exports.getEstados = async (req, res) => {
  try {
    const estados = (await db.query("SELECT id_lugar, nombre FROM Lugar WHERE LOWER(tipo) = 'estado' ORDER BY nombre")).rows;
    res.json(estados);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener estados' });
  }
};

exports.getMunicipios = async (req, res) => {
  const { estado_id } = req.query;
  if (!estado_id) return res.status(400).json({ error: 'Estado requerido' });
  
  // Validar que estado_id sea un número válido
  const estadoId = parseInt(estado_id, 10);
  if (isNaN(estadoId)) {
    return res.status(400).json({ error: 'ID de estado inválido' });
  }
  
  try {
    const municipios = (await db.query("SELECT id_lugar, nombre FROM Lugar WHERE LOWER(tipo) = 'municipio' AND lugar_relacion_id = $1 ORDER BY nombre", [estadoId])).rows;
    res.json(municipios);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener municipios' });
  }
};

exports.getParroquias = async (req, res) => {
  const { municipio_id } = req.query;
  if (!municipio_id) return res.status(400).json({ error: 'Municipio requerido' });
  
  // Validar que municipio_id sea un número válido
  const municipioId = parseInt(municipio_id, 10);
  if (isNaN(municipioId)) {
    return res.status(400).json({ error: 'ID de municipio inválido' });
  }
  
  try {
    const parroquias = (await db.query("SELECT id_lugar, nombre FROM Lugar WHERE LOWER(tipo) = 'parroquia' AND lugar_relacion_id = $1 ORDER BY nombre", [municipioId])).rows;
    res.json(parroquias);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener parroquias' });
  }
}; 