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

exports.getComparativaEstilos = async (req, res) => {
  try {
    const query = `
      WITH RECURSIVE tipo_jerarquia AS (
        SELECT
          c.id_cerveza,
          c.nombre_cerveza,
          tc.id_tipo_cerveza,
          tc.nombre AS tipo_nombre,
          tc.tipo_padre_id,
          0 AS nivel
        FROM Cerveza c
        JOIN Tipo_Cerveza tc ON c.id_tipo_cerveza = tc.id_tipo_cerveza

        UNION ALL

        SELECT
          tj.id_cerveza,
          tj.nombre_cerveza,
          tc.id_tipo_cerveza,
          tc.nombre AS tipo_nombre,
          tc.tipo_padre_id,
          tj.nivel + 1
        FROM tipo_jerarquia tj
        JOIN Tipo_Cerveza tc ON tj.tipo_padre_id = tc.id_tipo_cerveza
      )
      SELECT
        tj.id_cerveza,
        tj.nombre_cerveza,
        STRING_AGG(DISTINCT CASE WHEN car.tipo_caracteristica = 'Color' THEN ce.valor END, ', ') AS color,
        STRING_AGG(DISTINCT CASE WHEN car.tipo_caracteristica = 'Graduación alcohólica' AND RIGHT(TRIM(ce.valor), 1) = '%' THEN ce.valor END, '-') AS graduacion_alcoholica,
        STRING_AGG(DISTINCT CASE WHEN car.tipo_caracteristica = 'Amargor' AND ce.valor IN ('Bajo', 'Medio', 'Alto', 'Muy alto') THEN ce.valor END, ', ') AS amargor
      FROM tipo_jerarquia tj
      JOIN Caracteristica_Especifica ce ON tj.id_tipo_cerveza = ce.id_tipo_cerveza
      JOIN Caracteristica car ON ce.id_caracteristica = car.id_caracteristica
      WHERE car.tipo_caracteristica IN ('Color', 'Graduación alcohólica', 'Amargor')
      GROUP BY tj.id_cerveza, tj.nombre_cerveza
      ORDER BY tj.id_cerveza;
    `;

    const result = await db.query(query);
    res.json({
      success: true,
      data: result.rows,
      message: 'Comparativa de estilos obtenida exitosamente'
    });
  } catch (err) {
    console.error('Error al obtener comparativa de estilos:', err);
    res.status(500).json({
      success: false,
      error: 'Error al obtener la comparativa de estilos'
    });
  }
};

// =================================================================
// INDICADORES DE VENTAS
// =================================================================

// Obtener indicadores de ventas por período
exports.getIndicadoresVentas = async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        
        if (!fecha_inicio || !fecha_fin) {
            return res.status(400).json({ 
                success: false, 
                message: 'fecha_inicio y fecha_fin son requeridos' 
            });
        }

        const result = await db.query(
            'SELECT * FROM get_indicadores_ventas($1, $2)',
            [fecha_inicio, fecha_fin]
        );

        if (result.rows.length > 0) {
            res.json({
                success: true,
                data: result.rows[0]
            });
        } else {
            res.json({
                success: true,
                data: {
                    ventas_totales_fisica: 0,
                    ventas_totales_web: 0,
                    ventas_totales_general: 0,
                    crecimiento_ventas: 0,
                    crecimiento_porcentual: 0,
                    ticket_promedio: 0,
                    volumen_unidades: 0,
                    estilo_mas_vendido: 'N/A',
                    unidades_estilo_mas_vendido: 0
                }
            });
        }
    } catch (error) {
        console.error('Error al obtener indicadores de ventas:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
};

// Obtener ventas por estilo de cerveza
exports.getVentasPorEstilo = async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        
        if (!fecha_inicio || !fecha_fin) {
            return res.status(400).json({ 
                success: false, 
                message: 'fecha_inicio y fecha_fin son requeridos' 
            });
        }

        const result = await db.query(
            'SELECT * FROM get_ventas_por_estilo($1, $2)',
            [fecha_inicio, fecha_fin]
        );

        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error al obtener ventas por estilo:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
};

// Obtener ventas por período (día/semana/mes)
exports.getVentasPorPeriodo = async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin, tipo_periodo = 'day' } = req.query;
        
        if (!fecha_inicio || !fecha_fin) {
            return res.status(400).json({ 
                success: false, 
                message: 'fecha_inicio y fecha_fin son requeridos' 
            });
        }

        const result = await db.query(
            'SELECT * FROM get_ventas_por_periodo($1, $2, $3)',
            [fecha_inicio, fecha_fin, tipo_periodo]
        );

        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error al obtener ventas por período:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
};

// Endpoint para dashboard de datos de ventas
exports.getDashboardVentas = async (req, res) => {
    try {
        const { dias = 30 } = req.query;
        
        // Consultas SQL para obtener los datos del dashboard usando las tablas correctas
        const ventasPorTiendaQuery = `
            SELECT 
                COALESCE(tf.nombre, tw.nombre) as tienda,
                COALESCE(SUM(c.monto_total), 0) as ventas
            FROM Compra c
            LEFT JOIN Tienda_Fisica tf ON c.tienda_fisica_id_tienda = tf.id_tienda
            LEFT JOIN Tienda_Web tw ON c.tienda_web_id_tienda = tw.id_tienda
            WHERE c.monto_total > 0
                AND EXISTS (
                    SELECT 1 FROM Compra_Estatus ce 
                    WHERE ce.compra_id_compra = c.id_compra 
                    AND ce.estatus_id_estatus = 3
                    AND ce.fecha_hora_asignacion >= CURRENT_DATE - INTERVAL '${dias} days'
                )
            GROUP BY COALESCE(tf.nombre, tw.nombre)
            ORDER BY ventas DESC
        `;

        const ticketPromedioQuery = `
            SELECT 
                DATE(ce.fecha_hora_asignacion) as fecha,
                AVG(c.monto_total) as promedio
            FROM Compra c
            INNER JOIN Compra_Estatus ce ON c.id_compra = ce.compra_id_compra
            WHERE ce.estatus_id_estatus = 3
                AND ce.fecha_hora_asignacion >= CURRENT_DATE - INTERVAL '${dias} days'
            GROUP BY DATE(ce.fecha_hora_asignacion)
            ORDER BY fecha
        `;

        const volumenVendidoQuery = `
            SELECT 
                p.nombre as presentacion,
                COALESCE(SUM(dc.cantidad), 0) as volumen
            FROM Presentacion p
            LEFT JOIN Presentacion_Cerveza pc ON p.id_presentacion = pc.presentacion_id_presentacion
            LEFT JOIN Detalle_Compra dc ON pc.cerveza_id_cerveza = dc.id_inventario
            LEFT JOIN Compra c ON dc.id_compra = c.id_compra
            LEFT JOIN Compra_Estatus ce ON c.id_compra = ce.compra_id_compra
            WHERE ce.estatus_id_estatus = 3
                AND ce.fecha_hora_asignacion >= CURRENT_DATE - INTERVAL '${dias} days'
            GROUP BY p.id_presentacion, p.nombre
            ORDER BY volumen DESC
        `;

        const ventasPorEstiloQuery = `
            SELECT 
                tc.nombre as estilo,
                COALESCE(SUM(dc.cantidad * dc.precio_unitario), 0) as ventas
            FROM Tipo_Cerveza tc
            LEFT JOIN Cerveza c ON tc.id_tipo_cerveza = c.id_tipo_cerveza
            LEFT JOIN Presentacion_Cerveza pc ON c.id_cerveza = pc.cerveza_id_cerveza
            LEFT JOIN Detalle_Compra dc ON pc.cerveza_id_cerveza = dc.id_inventario
            LEFT JOIN Compra comp ON dc.id_compra = comp.id_compra
            LEFT JOIN Compra_Estatus ce ON comp.id_compra = ce.compra_id_compra
            WHERE ce.estatus_id_estatus = 3
                AND ce.fecha_hora_asignacion >= CURRENT_DATE - INTERVAL '${dias} days'
            GROUP BY tc.id_tipo_cerveza, tc.nombre
            ORDER BY ventas DESC
        `;

        // Ejecutar consultas
        const [ventasPorTienda, ticketPromedio, volumenVendido, ventasPorEstilo] = await Promise.all([
            db.query(ventasPorTiendaQuery),
            db.query(ticketPromedioQuery),
            db.query(volumenVendidoQuery),
            db.query(ventasPorEstiloQuery)
        ]);

        // Datos de comparación por etapa (últimos dos periodos)
        const comparacionEtapasQuery = `
            SELECT 
                'periodo1' as periodo,
                COALESCE(SUM(c.monto_total), 0) as ventas,
                MIN(ce.fecha_hora_asignacion) as fecha_inicio,
                MAX(ce.fecha_hora_asignacion) as fecha_fin
            FROM Compra c
            INNER JOIN Compra_Estatus ce ON c.id_compra = ce.compra_id_compra
            WHERE ce.estatus_id_estatus = 3
                AND ce.fecha_hora_asignacion >= CURRENT_DATE - INTERVAL '${dias * 2} days' 
                AND ce.fecha_hora_asignacion < CURRENT_DATE - INTERVAL '${dias} days'
            UNION ALL
            SELECT 
                'periodo2' as periodo,
                COALESCE(SUM(c.monto_total), 0) as ventas,
                MIN(ce.fecha_hora_asignacion) as fecha_inicio,
                MAX(ce.fecha_hora_asignacion) as fecha_fin
            FROM Compra c
            INNER JOIN Compra_Estatus ce ON c.id_compra = ce.compra_id_compra
            WHERE ce.estatus_id_estatus = 3
                AND ce.fecha_hora_asignacion >= CURRENT_DATE - INTERVAL '${dias} days'
        `;

        const comparacionResult = await db.query(comparacionEtapasQuery);
        
        const comparacionEtapas = {
            periodo1: comparacionResult.rows.find(r => r.periodo === 'periodo1') || { ventas: 0, fecha_inicio: null, fecha_fin: null },
            periodo2: comparacionResult.rows.find(r => r.periodo === 'periodo2') || { ventas: 0, fecha_inicio: null, fecha_fin: null }
        };

        // Formatear respuesta
        const response = {
            ventasPorTienda: ventasPorTienda.rows.map(row => ({
                tienda: row.tienda,
                ventas: parseFloat(row.ventas)
            })),
            comparacionEtapas: {
                periodo1: {
                    fecha: comparacionEtapas.periodo1.fecha_inicio,
                    ventas: parseFloat(comparacionEtapas.periodo1.ventas)
                },
                periodo2: {
                    fecha: comparacionEtapas.periodo2.fecha_inicio,
                    ventas: parseFloat(comparacionEtapas.periodo2.ventas)
                }
            },
            ticketPromedio: ticketPromedio.rows.map(row => ({
                fecha: row.fecha,
                promedio: parseFloat(row.promedio)
            })),
            volumenVendido: volumenVendido.rows.map(row => ({
                presentacion: row.presentacion,
                volumen: parseInt(row.volumen)
            })),
            ventasPorEstilo: ventasPorEstilo.rows.map(row => ({
                estilo: row.estilo,
                ventas: parseFloat(row.ventas)
            }))
        };

        res.json(response);
    } catch (error) {
        console.error('Error en getDashboardVentas:', error);
        res.status(500).json({ 
            error: 'Error interno del servidor',
            details: error.message 
        });
    }
};

// Obtener volumen vendido por presentación
exports.getVolumenPorPresentacion = async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        if (!fecha_inicio || !fecha_fin) {
            return res.status(400).json({ success: false, message: 'fecha_inicio y fecha_fin son requeridos' });
        }
        const result = await db.query(
            'SELECT * FROM get_volumen_por_presentacion($1, $2)',
            [fecha_inicio, fecha_fin]
        );
        res.json({ success: true, data: result.rows });
    } catch (error) {
        console.error('Error al obtener volumen por presentación:', error);
        res.status(500).json({ success: false, message: 'Error interno del servidor' });
    }
};

// Obtener indicadores de clientes
exports.getIndicadoresClientes = async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        if (!fecha_inicio || !fecha_fin) {
            return res.status(400).json({ success: false, message: 'fecha_inicio y fecha_fin son requeridos' });
        }
        const result = await db.query(
            'SELECT * FROM get_indicadores_clientes($1, $2)',
            [fecha_inicio, fecha_fin]
        );
        if (result.rows.length > 0) {
            res.json({ success: true, data: result.rows[0] });
        } else {
            res.json({ success: true, data: { clientes_nuevos: 0, clientes_recurrentes: 0, tasa_retencion: 0 } });
        }
    } catch (error) {
        console.error('Error al obtener indicadores de clientes:', error);
        res.status(500).json({ success: false, message: 'Error interno del servidor' });
    }
};

// =================================================================
// INDICADORES DE INVENTARIO Y OPERACIONES
// =================================================================

// Obtener rotación de inventario
exports.getRotacionInventario = async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        if (!fecha_inicio || !fecha_fin) {
            return res.status(400).json({ success: false, message: 'fecha_inicio y fecha_fin son requeridos' });
        }
        const result = await db.query(
            'SELECT * FROM get_rotacion_inventario($1, $2)',
            [fecha_inicio, fecha_fin]
        );
        if (result.rows.length > 0) {
            res.json({ success: true, data: result.rows[0] });
        } else {
            res.json({ 
                success: true, 
                data: { 
                    rotacion_inventario: 0, 
                    valor_promedio_inventario: 0, 
                    costo_productos_vendidos: 0 
                } 
            });
        }
    } catch (error) {
        console.error('Error al obtener rotación de inventario:', error);
        res.status(500).json({ success: false, message: 'Error interno del servidor' });
    }
};

// Obtener tasa de ruptura de stock
exports.getTasaRupturaStock = async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        if (!fecha_inicio || !fecha_fin) {
            return res.status(400).json({ success: false, message: 'fecha_inicio y fecha_fin son requeridos' });
        }
        const result = await db.query(
            'SELECT * FROM get_tasa_ruptura_stock($1, $2)',
            [fecha_inicio, fecha_fin]
        );
        if (result.rows.length > 0) {
            res.json({ success: true, data: result.rows[0] });
        } else {
            res.json({ 
                success: true, 
                data: { 
                    tasa_ruptura_stock: 0, 
                    productos_sin_stock: 0, 
                    total_productos: 0 
                } 
            });
        }
    } catch (error) {
        console.error('Error al obtener tasa de ruptura de stock:', error);
        res.status(500).json({ success: false, message: 'Error interno del servidor' });
    }
};

// Obtener ventas por empleado
exports.getVentasPorEmpleado = async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        if (!fecha_inicio || !fecha_fin) {
            return res.status(400).json({ success: false, message: 'fecha_inicio y fecha_fin son requeridos' });
        }
        const result = await db.query(
            'SELECT * FROM get_ventas_por_empleado($1, $2)',
            [fecha_inicio, fecha_fin]
        );
        res.json({ success: true, data: result.rows });
    } catch (error) {
        console.error('Error al obtener ventas por empleado:', error);
        res.status(500).json({ success: false, message: 'Error interno del servidor' });
    }
};

// Obtener ventas por empleado completa (incluye ventas sin empleado)
exports.getVentasPorEmpleadoCompleta = async (req, res) => {
    try {
        const { fecha_inicio, fecha_fin } = req.query;
        if (!fecha_inicio || !fecha_fin) {
            return res.status(400).json({ success: false, message: 'fecha_inicio y fecha_fin son requeridos' });
        }
        const result = await db.query(
            'SELECT * FROM get_ventas_por_empleado_completa($1, $2)',
            [fecha_inicio, fecha_fin]
        );
        res.json({ success: true, data: result.rows });
    } catch (error) {
        console.error('Error al obtener ventas por empleado completa:', error);
        res.status(500).json({ success: false, message: 'Error interno del servidor' });
    }
};

// Obtener tendencia de ventas por mes
exports.getTendenciaVentas = async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM get_tendencia_ventas()');
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('Error al obtener tendencia de ventas:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
};

// Obtener ventas por canal (física vs web)
exports.getVentasPorCanal = async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM get_ventas_por_canal()');
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('Error al obtener ventas por canal:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
};

// Obtener top 10 productos más vendidos
exports.getTopProductosVendidos = async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM get_top_productos_vendidos()');
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('Error al obtener top productos vendidos:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
};

// Obtener stock actual por producto y presentación
exports.getStockActual = async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM get_stock_actual()');
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('Error al obtener stock actual:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
};

// Las funciones ya están exportadas usando exports.functionName
// No necesitamos module.exports adicional 