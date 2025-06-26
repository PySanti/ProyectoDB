const db = require('../db_connection/index.js');

// Obtener la tasa actual del dólar
const getTasaActual = async (req, res) => {
    try {
        const query = `SELECT * FROM obtener_tasa_actual_dolar()`;
        
        const result = await db.query(query);
        
        if (result.rows.length === 0) {
            return res.status(404).json({ 
                error: 'No se encontró una tasa configurada' 
            });
        }
        
        res.json(result.rows[0]);
    } catch (error) {
        console.error('Error al obtener la tasa actual:', error);
        res.status(500).json({ 
            error: 'Error interno del servidor al obtener la tasa actual' 
        });
    }
};

// Actualizar la tasa del dólar
const actualizarTasa = async (req, res) => {
    try {
        const { valor } = req.body;
        
        if (!valor || valor <= 0) {
            return res.status(400).json({ 
                error: 'El valor de la tasa debe ser mayor a 0' 
            });
        }
        
        // Insertar nueva tasa usando la función SQL
        const insertQuery = `SELECT * FROM insertar_nueva_tasa('Dólar Estadounidense', $1)`;
        
        const result = await db.query(insertQuery, [valor]);
        
        res.json({
            message: 'Tasa actualizada exitosamente',
            tasa: result.rows[0]
        });
        
    } catch (error) {
        console.error('Error al actualizar la tasa:', error);
        res.status(500).json({ 
            error: 'Error interno del servidor al actualizar la tasa' 
        });
    }
};

module.exports = {
    getTasaActual,
    actualizarTasa
}; 