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

exports.getCervezasProveedores = async (req, res) => {
  try {
    const query = `
      WITH RECURSIVE tipo_cerveza_hierarchy AS (
        SELECT 
          id_tipo_cerveza,
          nombre,
          tipo_padre_id,
          CAST(nombre AS VARCHAR(255)) AS ruta_completa,
          1 AS nivel
        FROM Tipo_Cerveza 
        WHERE tipo_padre_id IS NULL
        UNION ALL
        SELECT 
          tc.id_tipo_cerveza,
          tc.nombre,
          tc.tipo_padre_id,
          CAST(tch.ruta_completa || ', ' || tc.nombre AS VARCHAR(255)) AS ruta_completa,
          tch.nivel + 1
        FROM Tipo_Cerveza tc
        INNER JOIN tipo_cerveza_hierarchy tch ON tc.tipo_padre_id = tch.id_tipo_cerveza
      )
      SELECT 
        p.razon_social AS proveedor,
        c.nombre_cerveza AS cerveza,
        tch.ruta_completa AS tipos_cerveza
      FROM Cerveza c
      INNER JOIN Proveedor p ON c.id_proveedor = p.id_proveedor
      INNER JOIN tipo_cerveza_hierarchy tch ON c.id_tipo_cerveza = tch.id_tipo_cerveza
      ORDER BY p.razon_social, c.nombre_cerveza;
    `;

    const result = await db.query(query);
    res.json({
      success: true,
      data: result.rows,
      message: 'Listado de cervezas por proveedores obtenido exitosamente'
    });
  } catch (err) {
    console.error('Error al obtener listado de cervezas por proveedores:', err);
    res.status(500).json({
      success: false,
      error: 'Error al obtener el listado de cervezas por proveedores'
    });
  }
};

exports.getIngresosPorTipo = async (req, res) => {
  try {
    const { year } = req.query;
    
    // Query principal para los datos del gráfico
    let query = `
      SELECT 
        EXTRACT(YEAR FROM ce.fecha_hora_asignacion) AS anio,
        EXTRACT(MONTH FROM ce.fecha_hora_asignacion) AS mes,
        TO_CHAR(ce.fecha_hora_asignacion, 'TMMonth YYYY') AS periodo,
        CASE 
          WHEN c.tienda_web_id_tienda IS NOT NULL THEN 'Online'
          WHEN c.tienda_fisica_id_tienda IS NOT NULL THEN 'Física'
          ELSE 'Sin definir'
        END AS tipo_venta,
        SUM(c.monto_total) AS ingresos_totales,
        COUNT(*) AS cantidad_ventas
      FROM Compra c
      INNER JOIN Compra_Estatus ce ON c.id_compra = ce.compra_id_compra
      WHERE 
        c.monto_total > 0
        AND ce.estatus_id_estatus = 3
        AND ce.fecha_hora_asignacion IS NOT NULL
        AND (c.tienda_web_id_tienda IS NOT NULL OR c.tienda_fisica_id_tienda IS NOT NULL)
    `;

    // Agregar filtro de año si se proporciona
    if (year) {
      query += ` AND EXTRACT(YEAR FROM ce.fecha_hora_asignacion) = $1`;
    }

    query += `
      GROUP BY 
        EXTRACT(YEAR FROM ce.fecha_hora_asignacion),
        EXTRACT(MONTH FROM ce.fecha_hora_asignacion),
        TO_CHAR(ce.fecha_hora_asignacion, 'TMMonth YYYY'),
        CASE 
          WHEN c.tienda_web_id_tienda IS NOT NULL THEN 'Online'
          WHEN c.tienda_fisica_id_tienda IS NOT NULL THEN 'Física'
          ELSE 'Sin definir'
        END
      ORDER BY 
        anio DESC,
        mes ASC,
        tipo_venta ASC;
    `;

    // Ejecutar query con o sin parámetro de año
    const result = year 
      ? await db.query(query, [year])
      : await db.query(query);

    res.json({
      success: true,
      data: result.rows,
      message: 'Reporte de ingresos por tipo de venta obtenido exitosamente'
    });
  } catch (err) {
    console.error('Error al obtener reporte de ingresos por tipo:', err);
    res.status(500).json({
      success: false,
      error: 'Error al obtener el reporte de ingresos por tipo de venta'
    });
  }
}; 