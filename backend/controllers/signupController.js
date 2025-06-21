const db = require('../db_connection/index.js');

exports.signupUser = async (req, res) => {
  const { tipo_usuario, email, password } = req.body;
  console.log(req.body)
  try {
    if (tipo_usuario === 'proveedor') {
      const { razon_social, denominacion, rif, url_web, id_lugar, id_lugar2, direccion_fisica, direccion_fiscal } = req.body;
      await db.pool.query('SELECT create_proveedor($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)', [razon_social, denominacion, rif, url_web, email, password, id_lugar, direccion_fisica, id_lugar2, direccion_fiscal]);
    } else if (tipo_usuario === 'cliente_juridico') {
      const { razon_social, rif, denominacion_comercial, capital_disponible, pagina_web, id_lugar, id_lugar2, direccion_fisica, direccion_fiscal } = req.body;
      await db.pool.query('SELECT create_cliente_juridico($1,$2,$3,$4,$5,$6,$7,$8,$9,$10, $11)', [rif, razon_social, denominacion_comercial, capital_disponible, direccion_fiscal, direccion_fisica, pagina_web, id_lugar, id_lugar2, email, password]);
    } else if (tipo_usuario === 'cliente_natural') {
      const { cedula, rif, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, id_lugar, direccion_fisica } = req.body;
      await db.pool.query('SELECT create_cliente_natural($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)', [cedula, rif, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, email, password, id_lugar, direccion_fisica]);
    } else {
      return res.status(400).json({ error: 'Tipo de usuario no válido' });
    }
    res.json({ message: 'Registro exitoso' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error en el registro' });
  }
}; 