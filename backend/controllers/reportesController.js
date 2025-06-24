const db = require('../db_connection/index.js');

exports.getRankingPuntos = async (req, res) => {
  try {
    const query = `
      SELECT
        c.id_cliente AS id_cliente,
        CONCAT(c.primer_nombre, ' ', c.primer_apellido) AS nombre_cliente,
        COALESCE(SUM(CASE WHEN pc.tipo_movimiento = 'GANADO' THEN pc.cantidad_mov ELSE 0 END), 0) AS puntos_ganados,
        COALESCE(SUM(CASE WHEN pc.tipo_movimiento = 'GASTADO' THEN ABS(pc.cantidad_mov) ELSE 0 END), 0) AS puntos_gastados
      FROM
        Cliente_Natural c
      LEFT JOIN
        Punto_Cliente pc ON c.id_cliente = pc.id_cliente_natural
      GROUP BY
        c.id_cliente, c.primer_nombre, c.primer_apellido
      ORDER BY
        puntos_ganados DESC
    `;

    const result = await db.query(query);
    res.json({ 
      success: true, 
      data: result.rows,
      message: 'Ranking de clientes por puntos obtenido exitosamente'
    });
  } catch (err) {
    console.error('Error al obtener ranking de puntos:', err);
    res.status(500).json({ 
      success: false, 
      error: 'Error al obtener el ranking de clientes por puntos' 
    });
  }
};

exports.getVacacionesEmpleados = async (req, res) => {
  try {
    const query = `
      SELECT
        e.id_empleado,
        CONCAT(e.primer_nombre, ' ', e.segundo_nombre, ' ', e.primer_apellido, ' ', e.segundo_apellido) AS nombre_empleado,
        v.fecha_inicio,
        v.fecha_fin,
        v.descripcion,
        (v.fecha_fin - v.fecha_inicio) + 1 AS dias_periodo
      FROM
        Empleado e
      LEFT JOIN
        Vacacion v ON e.id_empleado = v.empleado_id
      ORDER BY
        nombre_empleado, v.fecha_inicio;
    `;
    const result = await db.query(query);
    res.json({
      success: true,
      data: result.rows,
      message: 'Resumen de días de vacaciones por empleado obtenido exitosamente'
    });
  } catch (err) {
    console.error('Error al obtener resumen de vacaciones:', err);
    res.status(500).json({
      success: false,
      error: 'Error al obtener el resumen de días de vacaciones por empleado'
    });
  }
}; 