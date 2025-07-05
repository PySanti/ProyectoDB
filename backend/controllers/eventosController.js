const db = require('../db_connection');

// Obtener tipos de evento
exports.getTiposEvento = async (req, res) => {
    try {
        const result = await db.query('SELECT id_tipo_evento, nombre, descripcion FROM TipoEvento ORDER BY nombre');
        res.json(result.rows);
    } catch (error) {
        console.error('Error al obtener tipos de evento:', error);
        res.status(500).json({ error: 'Error al obtener tipos de evento' });
    }
};

// Obtener lugares (estados, municipios, parroquias)
exports.getLugares = async (req, res) => {
    try {
        // Estados
        const estados = await db.query("SELECT id_lugar, nombre FROM Lugar WHERE tipo = 'Estado' ORDER BY nombre");
        // Municipios
        const municipios = await db.query("SELECT id_lugar, nombre, lugar_relacion_id as estado_id FROM Lugar WHERE tipo = 'Municipio' ORDER BY nombre");
        // Parroquias
        const parroquias = await db.query("SELECT id_lugar, nombre, lugar_relacion_id as municipio_id FROM Lugar WHERE tipo = 'Parroquia' ORDER BY nombre");
        res.json({
            estados: estados.rows,
            municipios: municipios.rows,
            parroquias: parroquias.rows
        });
    } catch (error) {
        console.error('Error al obtener lugares:', error);
        res.status(500).json({ error: 'Error al obtener lugares' });
    }
};

// Obtener invitados y tipos de invitado
exports.getInvitados = async (req, res) => {
    try {
        const invitados = await db.query('SELECT id_invitado, nombre FROM Invitado ORDER BY nombre');
        const tipos = await db.query('SELECT id_tipo_invitado, nombre FROM Tipo_Invitado ORDER BY nombre');
        res.json({
            invitados: invitados.rows,
            tipos: tipos.rows
        });
    } catch (error) {
        console.error('Error al obtener invitados y tipos:', error);
        res.status(500).json({ error: 'Error al obtener invitados y tipos' });
    }
};

// Obtener proveedores
exports.getProveedores = async (req, res) => {
    try {
        const proveedores = await db.query('SELECT id_proveedor, razon_social FROM Proveedor ORDER BY razon_social');
        res.json(proveedores.rows);
    } catch (error) {
        console.error('Error al obtener proveedores:', error);
        res.status(500).json({ error: 'Error al obtener proveedores' });
    }
};

// Obtener cervezas
exports.getCervezas = async (req, res) => {
    try {
        const cervezas = await db.query('SELECT id_cerveza, nombre_cerveza FROM Cerveza ORDER BY nombre_cerveza');
        res.json(cervezas.rows);
    } catch (error) {
        console.error('Error al obtener cervezas:', error);
        res.status(500).json({ error: 'Error al obtener cervezas' });
    }
};

// Obtener presentaciones
exports.getPresentaciones = async (req, res) => {
    try {
        const presentaciones = await db.query('SELECT id_presentacion, nombre FROM Presentacion ORDER BY nombre');
        res.json(presentaciones.rows);
    } catch (error) {
        console.error('Error al obtener presentaciones:', error);
        res.status(500).json({ error: 'Error al obtener presentaciones' });
    }
};

// Obtener tipos de actividad
exports.getTiposActividad = async (req, res) => {
    try {
        const tipos = await db.query('SELECT id_tipo_actividad, nombre FROM Tipo_Actividad ORDER BY nombre');
        res.json(tipos.rows);
    } catch (error) {
        console.error('Error al obtener tipos de actividad:', error);
        res.status(500).json({ error: 'Error al obtener tipos de actividad' });
    }
};

// Obtener presentaciones por cerveza
exports.getPresentacionesPorCerveza = async (req, res) => {
    try {
        const { id_cerveza } = req.params;
        const presentaciones = await db.query(`
            SELECT pc.id_presentacion, p.nombre 
            FROM Presentacion_Cerveza pc
            JOIN Presentacion p ON pc.id_presentacion = p.id_presentacion
            WHERE pc.id_cerveza = $1
            ORDER BY p.nombre
        `, [id_cerveza]);
        res.json(presentaciones.rows);
    } catch (error) {
        console.error('Error al obtener presentaciones por cerveza:', error);
        res.status(500).json({ error: 'Error al obtener presentaciones por cerveza' });
    }
};

// Crear evento completo con todas sus relaciones
exports.crearEvento = async (req, res) => {
    const client = await db.connect();
    
    try {
        await client.query('BEGIN'); // Iniciar transacción
        
        const {
            nombre,
            descripcion,
            fecha_inicio,
            fecha_fin,
            lugar_id_lugar,
            precio_unitario_entrada,
            tipo_evento_id,
            horarios,
            invitados,
            proveedores,
            actividades,
            inventario
        } = req.body;

        console.log('Datos recibidos:', req.body);

        // 1. INSERTAR EVENTO PRINCIPAL
        const eventoResult = await client.query(`
            INSERT INTO Evento (nombre, descripcion, fecha_inicio, fecha_fin, lugar_id_lugar, precio_unitario_entrada, tipo_evento_id)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
            RETURNING id_evento
        `, [nombre, descripcion, fecha_inicio, fecha_fin, lugar_id_lugar, precio_unitario_entrada, tipo_evento_id]);
        
        const id_evento = eventoResult.rows[0].id_evento;
        console.log('Evento creado con ID:', id_evento);

        // 2. INSERTAR HORARIOS
        if (horarios && horarios.length > 0) {
            for (const horario of horarios) {
                // Insertar horario
                const horarioResult = await client.query(`
                    INSERT INTO Horario (dia, hora_entrada, hora_salida)
                    VALUES ($1, $2, $3)
                    RETURNING id_horario
                `, [horario.dia, horario.hora_inicio, horario.hora_fin]);
                
                const id_horario = horarioResult.rows[0].id_horario;
                
                // Vincular horario con evento
                await client.query(`
                    INSERT INTO Horario_Evento (id_evento, id_horario)
                    VALUES ($1, $2)
                `, [id_evento, id_horario]);
            }
            console.log('Horarios insertados:', horarios.length);
        }

        // 3. INSERTAR INVITADOS
        if (invitados && invitados.length > 0) {
            for (const invitado of invitados) {
                await client.query(`
                    INSERT INTO Invitado_Evento (id_invitado, id_evento, hora_llegada, hora_salida)
                    VALUES ($1, $2, $3, $4)
                `, [invitado.id_invitado, id_evento, invitado.hora_llegada || null, invitado.hora_salida || null]);
            }
            console.log('Invitados insertados:', invitados.length);
        }

        // 4. INSERTAR PROVEEDORES
        if (proveedores && proveedores.length > 0) {
            for (const proveedor of proveedores) {
                await client.query(`
                    INSERT INTO Evento_Proveedor (id_proveedor, id_evento, hora_llegada, hora_salida, dia)
                    VALUES ($1, $2, $3, $4, $5)
                `, [proveedor.id_proveedor, id_evento, proveedor.hora_llegada || null, proveedor.hora_salida || null, fecha_inicio]);
            }
            console.log('Proveedores insertados:', proveedores.length);
        }

        // 5. INSERTAR ACTIVIDADES
        if (actividades && actividades.length > 0) {
            for (const actividad of actividades) {
                await client.query(`
                    INSERT INTO Actividad (tema, invitado_evento_invitado_id_invitado, invitado_evento_evento_id_evento, tipo_actividad_id_tipo_actividad)
                    VALUES ($1, $2, $3, $4)
                `, [actividad.tema, actividad.id_invitado, id_evento, actividad.id_tipo_actividad]);
            }
            console.log('Actividades insertadas:', actividades.length);
        }

        // 6. INSERTAR INVENTARIO
        if (inventario && inventario.length > 0) {
            for (const item of inventario) {
                // Verificar que la combinación cerveza-presentación existe en Presentacion_Cerveza
                const presentacionCervezaResult = await client.query(`
                    SELECT 1 FROM Presentacion_Cerveza 
                    WHERE id_presentacion = $1 AND id_cerveza = $2
                `, [item.id_presentacion, item.id_cerveza]);
                
                if (presentacionCervezaResult.rows.length === 0) {
                    throw new Error(`La cerveza ${item.id_cerveza} no tiene la presentación ${item.id_presentacion} disponible`);
                }
                
                // Obtener el tipo de cerveza desde la tabla Cerveza
                const cervezaResult = await client.query(`
                    SELECT id_tipo_cerveza FROM Cerveza WHERE id_cerveza = $1
                `, [item.id_cerveza]);
                
                if (cervezaResult.rows.length === 0) {
                    throw new Error(`Cerveza con ID ${item.id_cerveza} no encontrada`);
                }
                
                const id_tipo_cerveza = cervezaResult.rows[0].id_tipo_cerveza;
                
                await client.query(`
                    INSERT INTO Inventario_Evento_Proveedor (id_proveedor, id_evento, cantidad, id_tipo_cerveza, id_presentacion, id_cerveza)
                    VALUES ($1, $2, $3, $4, $5, $6)
                `, [item.id_proveedor, id_evento, item.cantidad, id_tipo_cerveza, item.id_presentacion, item.id_cerveza]);
            }
            console.log('Inventario insertado:', inventario.length);
        }

        await client.query('COMMIT'); // Confirmar transacción
        
        res.status(201).json({
            success: true,
            message: 'Evento creado exitosamente',
            id_evento: id_evento
        });

    } catch (error) {
        await client.query('ROLLBACK'); // Revertir transacción en caso de error
        console.error('Error al crear evento:', error);
        res.status(500).json({
            success: false,
            error: 'Error al crear evento',
            details: error.message
        });
    } finally {
        client.release();
    }
}; 