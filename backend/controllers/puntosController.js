const db = require('../db_connection');

// Obtener saldo de puntos de un cliente
const obtenerSaldoPuntos = async (req, res) => {
    try {
        const { id_cliente_natural } = req.params;
        
        const result = await db.query(
            'SELECT obtener_saldo_puntos_cliente($1) as saldo',
            [id_cliente_natural]
        );
        
        const saldo = result.rows[0].saldo;
        
        res.json({
            success: true,
            saldo: saldo,
            message: `Saldo actual: ${saldo} puntos`
        });
    } catch (error) {
        console.error('Error al obtener saldo de puntos:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener saldo de puntos',
            error: error.message
        });
    }
};

// Obtener información completa de puntos de un cliente
const obtenerInfoPuntos = async (req, res) => {
    try {
        const { id_cliente_natural } = req.params;
        
        const result = await db.query(
            'SELECT * FROM obtener_info_puntos_cliente($1)',
            [id_cliente_natural]
        );
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Cliente no encontrado o sin información de puntos'
            });
        }
        
        const info = result.rows[0];
        
        res.json({
            success: true,
            data: {
                saldo_actual: parseInt(info.saldo_actual),
                puntos_ganados: parseInt(info.puntos_ganados),
                puntos_gastados: parseInt(info.puntos_gastados),
                valor_punto: parseFloat(info.valor_punto),
                minimo_canje: parseInt(info.minimo_canje),
                tasa_actual: parseFloat(info.tasa_actual)
            }
        });
    } catch (error) {
        console.error('Error al obtener información de puntos:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener información de puntos',
            error: error.message
        });
    }
};

// Obtener historial de movimientos de puntos
const obtenerHistorialPuntos = async (req, res) => {
    try {
        const { id_cliente_natural } = req.params;
        const { limite = 50 } = req.query;
        
        const result = await db.query(
            'SELECT * FROM obtener_historial_puntos_cliente($1, $2)',
            [id_cliente_natural, limite]
        );
        
        res.json({
            success: true,
            data: result.rows.map(row => ({
                fecha: row.fecha,
                tipo_movimiento: row.tipo_movimiento,
                cantidad_mov: parseInt(row.cantidad_mov),
                saldo_acumulado: parseInt(row.saldo_acumulado),
                referencia: row.referencia
            }))
        });
    } catch (error) {
        console.error('Error al obtener historial de puntos:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener historial de puntos',
            error: error.message
        });
    }
};

// Validar si un cliente puede usar puntos
const validarUsoPuntos = async (req, res) => {
    try {
        const { id_cliente_natural, puntos_a_usar } = req.body;
        
        if (!id_cliente_natural || !puntos_a_usar) {
            return res.status(400).json({
                success: false,
                message: 'Se requiere id_cliente_natural y puntos_a_usar'
            });
        }
        
        const result = await db.query(
            'SELECT validar_uso_puntos($1, $2) as puede_usar',
            [id_cliente_natural, puntos_a_usar]
        );
        
        const puedeUsar = result.rows[0].puede_usar;
        
        res.json({
            success: true,
            puede_usar: puedeUsar,
            message: puedeUsar ? 
                'Puntos válidos para uso' : 
                'No puede usar los puntos especificados'
        });
    } catch (error) {
        console.error('Error al validar uso de puntos:', error);
        res.status(500).json({
            success: false,
            message: 'Error al validar uso de puntos',
            error: error.message
        });
    }
};

// Usar puntos como método de pago
const usarPuntosComoPago = async (req, res) => {
    try {
        const { id_cliente_natural, puntos_a_usar, id_compra } = req.body;
        
        if (!id_cliente_natural || !puntos_a_usar || !id_compra) {
            return res.status(400).json({
                success: false,
                message: 'Se requiere id_cliente_natural, puntos_a_usar e id_compra'
            });
        }
        
        const result = await db.query(
            'SELECT usar_puntos_como_pago($1, $2, $3) as puntos_usados',
            [id_cliente_natural, puntos_a_usar, id_compra]
        );
        
        const puntosUsados = result.rows[0].puntos_usados;
        
        res.json({
            success: true,
            puntos_usados: puntosUsados,
            message: `Se usaron ${puntosUsados} puntos como método de pago`
        });
    } catch (error) {
        console.error('Error al usar puntos como pago:', error);
        res.status(500).json({
            success: false,
            message: 'Error al usar puntos como pago',
            error: error.message
        });
    }
};

// Obtener configuración de puntos del sistema
const obtenerConfiguracionPuntos = async (req, res) => {
    try {
        // Usar la función SQL que ya implementamos correctamente
        const result = await db.query(`
            SELECT 
                valor_punto,
                minimo_canje,
                tasa_actual
            FROM obtener_info_puntos_cliente(1) -- Usar cliente 1 como referencia para obtener configuración global
        `);
        
        if (result.rows.length === 0) {
            return res.json({
                success: true,
                configuracion: {
                    valor_punto: 1.0,
                    minimo_canje: 5,
                    tasa_acumulacion: 1.0
                }
            });
        }
        
        const config = result.rows[0];
        
        res.json({
            success: true,
            configuracion: {
                valor_punto: parseFloat(config.valor_punto),
                minimo_canje: parseInt(config.minimo_canje),
                tasa_acumulacion: parseFloat(config.tasa_actual)
            }
        });
    } catch (error) {
        console.error('Error al obtener configuración de puntos:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener configuración de puntos',
            error: error.message
        });
    }
};

// Diagnosticar puntos de un cliente (para debugging)
const diagnosticarPuntosCliente = async (req, res) => {
    try {
        const { id_cliente_natural } = req.params;
        
        const result = await db.query(
            'SELECT * FROM diagnosticar_puntos_cliente($1)',
            [id_cliente_natural]
        );
        
        res.json({
            success: true,
            data: result.rows.map(row => ({
                id_punto_cliente: row.id_punto_cliente,
                fecha: row.fecha,
                tipo_movimiento: row.tipo_movimiento,
                cantidad_mov: parseInt(row.cantidad_mov),
                saldo_acumulado: parseInt(row.saldo_acumulado),
                referencia: row.referencia
            }))
        });
    } catch (error) {
        console.error('Error al diagnosticar puntos:', error);
        res.status(500).json({
            success: false,
            message: 'Error al diagnosticar puntos',
            error: error.message
        });
    }
};

// Limpiar puntos de un cliente (para resetear)
const limpiarPuntosCliente = async (req, res) => {
    try {
        const { id_cliente_natural } = req.params;
        
        const result = await db.query(
            'SELECT limpiar_puntos_cliente($1) as registros_eliminados',
            [id_cliente_natural]
        );
        
        const registrosEliminados = result.rows[0].registros_eliminados;
        
        res.json({
            success: true,
            registros_eliminados: registrosEliminados,
            message: `Se eliminaron ${registrosEliminados} registros de puntos del cliente`
        });
    } catch (error) {
        console.error('Error al limpiar puntos:', error);
        res.status(500).json({
            success: false,
            message: 'Error al limpiar puntos',
            error: error.message
        });
    }
};

// Diagnosticar tasas de puntos (para debugging)
const diagnosticarTasasPuntos = async (req, res) => {
    try {
        const result = await db.query(
            'SELECT * FROM diagnosticar_tasas_puntos()'
        );
        
        res.json({
            success: true,
            data: result.rows.map(row => ({
                id_tasa: row.id_tasa,
                nombre: row.nombre,
                valor: parseFloat(row.valor),
                fecha: row.fecha,
                punto_id: row.punto_id,
                id_metodo: row.id_metodo
            }))
        });
    } catch (error) {
        console.error('Error al diagnosticar tasas:', error);
        res.status(500).json({
            success: false,
            message: 'Error al diagnosticar tasas',
            error: error.message
        });
    }
};

module.exports = {
    obtenerSaldoPuntos,
    obtenerInfoPuntos,
    obtenerHistorialPuntos,
    validarUsoPuntos,
    usarPuntosComoPago,
    obtenerConfiguracionPuntos,
    diagnosticarPuntosCliente,
    limpiarPuntosCliente,
    diagnosticarTasasPuntos
}; 