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
};

// =================================================================
// OBTENER TODOS LOS EVENTOS
// =================================================================
exports.getAllEventos = async (req, res) => {
    try {
        const result = await db.query(`
            SELECT 
                e.id_evento,
                e.nombre,
                e.fecha_inicio,
                e.fecha_fin,
                e.n_entradas_vendidas,
                e.precio_unitario_entrada
            FROM Evento e
            ORDER BY e.fecha_inicio DESC
        `);
        
        res.json({
            success: true,
            eventos: result.rows
        });
    } catch (error) {
        console.error('Error al obtener eventos:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor al obtener eventos' 
        });
    }
};

// =================================================================
// OBTENER INVENTARIO DE UN EVENTO ESPECÍFICO
// =================================================================
exports.getInventarioEvento = async (req, res) => {
    try {
        const { id_evento } = req.params;
        const { page = 1, limit = 9, sortBy = 'relevance' } = req.query;
        
        const offset = (page - 1) * limit;
        
        // Consulta para obtener el inventario del evento
        const result = await db.query(`
            SELECT 
                c.id_cerveza,
                c.nombre_cerveza,
                tc.nombre as tipo_cerveza,
                p.id_presentacion,
                p.nombre as nombre_presentacion,
                iep.cantidad as stock_disponible,
                pc.precio as precio_unitario,
                pr.razon_social as nombre_proveedor,
                iep.id_proveedor,
                iep.id_evento,
                iep.id_tipo_cerveza,
                iep.id_cerveza as id_cerveza_inv
            FROM Inventario_Evento_Proveedor iep
            JOIN Cerveza c ON iep.id_cerveza = c.id_cerveza
            JOIN Tipo_Cerveza tc ON c.id_tipo_cerveza = tc.id_tipo_cerveza
            JOIN Presentacion p ON iep.id_presentacion = p.id_presentacion
            JOIN Presentacion_Cerveza pc ON p.id_presentacion = pc.id_presentacion AND c.id_cerveza = pc.id_cerveza
            JOIN Proveedor pr ON iep.id_proveedor = pr.id_proveedor
            WHERE iep.id_evento = $1 AND iep.cantidad > 0
            ORDER BY c.nombre_cerveza, p.nombre
            LIMIT $2 OFFSET $3
        `, [id_evento, limit, offset]);
        
        // Consulta para contar el total
        const countResult = await db.query(`
            SELECT COUNT(*) as total
            FROM Inventario_Evento_Proveedor iep
            WHERE iep.id_evento = $1 AND iep.cantidad > 0
        `, [id_evento]);
        
        const total = parseInt(countResult.rows[0].total);
        const totalPages = Math.ceil(total / limit);
        
        // Agrupar por cerveza para el formato esperado por el frontend
        const productosAgrupados = {};
        
        result.rows.forEach(row => {
            const key = `${row.id_cerveza}`;
            if (!productosAgrupados[key]) {
                productosAgrupados[key] = {
                    id_cerveza: row.id_cerveza,
                    nombre_cerveza: row.nombre_cerveza,
                    tipo_cerveza: row.tipo_cerveza,
                    presentaciones: []
                };
            }
            
            productosAgrupados[key].presentaciones.push({
                id_inventario: `${row.id_evento}_${row.id_proveedor}_${row.id_tipo_cerveza}_${row.id_presentacion}_${row.id_cerveza_inv}`,
                id_presentacion: row.id_presentacion,
                nombre_presentacion: row.nombre_presentacion,
                stock_disponible: row.stock_disponible,
                precio_unitario: row.precio_unitario,
                nombre_proveedor: row.nombre_proveedor,
                id_proveedor: row.id_proveedor,
                id_evento: row.id_evento,
                id_tipo_cerveza: row.id_tipo_cerveza,
                id_cerveza: row.id_cerveza_inv
            });
        });
        
        const productos = Object.values(productosAgrupados);
        
        res.json({
            success: true,
            inventario: productos,
            total: total,
            totalPages: totalPages,
            currentPage: parseInt(page),
            itemsPerPage: parseInt(limit)
        });
        
    } catch (error) {
        console.error('Error al obtener inventario del evento:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor al obtener inventario del evento' 
        });
    }
};

// =================================================================
// AGREGAR PRODUCTO AL CARRITO DE EVENTOS
// =================================================================
exports.agregarProductoEvento = async (req, res) => {
    const client = await db.connect();
    
    try {
        await client.query('BEGIN'); // Iniciar transacción
        
        const { id_evento } = req.params;
        const { id_cliente_natural, nombre_cerveza, nombre_presentacion, cantidad } = req.body;
        
        console.log('Agregando producto al evento:', {
            id_evento,
            id_cliente_natural,
            nombre_cerveza,
            nombre_presentacion,
            cantidad
        });
        
        // 1. Verificar que el evento existe
        const eventoResult = await client.query(`
            SELECT id_evento, nombre FROM Evento WHERE id_evento = $1
        `, [id_evento]);
        
        if (eventoResult.rows.length === 0) {
            throw new Error('Evento no encontrado');
        }
        
        // 2. Buscar el inventario específico del evento
        const inventarioResult = await client.query(`
            SELECT 
                iep.id_proveedor,
                iep.id_tipo_cerveza,
                iep.id_presentacion,
                iep.id_cerveza,
                iep.cantidad as stock_disponible,
                pc.precio as precio_unitario
            FROM Inventario_Evento_Proveedor iep
            JOIN Cerveza c ON iep.id_cerveza = c.id_cerveza
            JOIN Presentacion p ON iep.id_presentacion = p.id_presentacion
            JOIN Presentacion_Cerveza pc ON p.id_presentacion = pc.id_presentacion AND c.id_cerveza = pc.id_cerveza
            WHERE iep.id_evento = $1 
            AND c.nombre_cerveza = $2 
            AND p.nombre = $3
            AND iep.cantidad > 0
        `, [id_evento, nombre_cerveza, nombre_presentacion]);
        
        if (inventarioResult.rows.length === 0) {
            throw new Error('Producto no disponible en el inventario del evento');
        }
        
        const inventario = inventarioResult.rows[0];
        
        // 3. Verificar stock disponible
        if (inventario.stock_disponible < cantidad) {
            throw new Error(`Stock insuficiente. Solo hay ${inventario.stock_disponible} unidades disponibles`);
        }
        
        // 4. Crear o obtener Venta_Evento
        let ventaEventoResult = await client.query(`
            SELECT evento_id, id_cliente_natural, total 
            FROM Venta_Evento 
            WHERE evento_id = $1 AND id_cliente_natural = $2
        `, [id_evento, id_cliente_natural]);
        
        let ventaEvento;
        if (ventaEventoResult.rows.length === 0) {
            // Crear nueva venta de evento
            ventaEventoResult = await client.query(`
                INSERT INTO Venta_Evento (evento_id, id_cliente_natural, fecha_compra, total)
                VALUES ($1, $2, NOW(), 0)
                RETURNING evento_id, id_cliente_natural, total
            `, [id_evento, id_cliente_natural]);
            ventaEvento = ventaEventoResult.rows[0];
            console.log('Nueva venta de evento creada');
        } else {
            ventaEvento = ventaEventoResult.rows[0];
            console.log('Venta de evento existente encontrada');
        }
        
        // 5. Verificar si ya existe el detalle
        const detalleExistenteResult = await client.query(`
            SELECT precio_unitario, cantidad 
            FROM Detalle_Venta_Evento 
            WHERE id_evento = $1 
            AND id_cliente_natural = $2 
            AND id_cerveza = $3 
            AND id_proveedor = $4 
            AND id_tipo_cerveza = $5 
            AND id_presentacion = $6
        `, [
            id_evento, 
            id_cliente_natural, 
            inventario.id_cerveza,
            inventario.id_proveedor,
            inventario.id_tipo_cerveza,
            inventario.id_presentacion
        ]);
        
        if (detalleExistenteResult.rows.length > 0) {
            // Actualizar cantidad existente
            const detalleExistente = detalleExistenteResult.rows[0];
            const nuevaCantidad = detalleExistente.cantidad + cantidad;
            
            await client.query(`
                UPDATE Detalle_Venta_Evento 
                SET cantidad = $1 
                WHERE id_evento = $2 
                AND id_cliente_natural = $3 
                AND id_cerveza = $4 
                AND id_proveedor = $5 
                AND id_tipo_cerveza = $6 
                AND id_presentacion = $7
            `, [
                nuevaCantidad,
                id_evento, 
                id_cliente_natural, 
                inventario.id_cerveza,
                inventario.id_proveedor,
                inventario.id_tipo_cerveza,
                inventario.id_presentacion
            ]);
            
            console.log('Cantidad actualizada en detalle existente');
        } else {
            // Crear nuevo detalle
            await client.query(`
                INSERT INTO Detalle_Venta_Evento (
                    precio_unitario, cantidad, id_evento, id_cliente_natural, 
                    id_cerveza, id_proveedor, id_proveedor_evento, id_tipo_cerveza, 
                    id_presentacion, id_cerveza_inv
                ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
            `, [
                inventario.precio_unitario,
                cantidad,
                id_evento,
                id_cliente_natural,
                inventario.id_cerveza,
                inventario.id_proveedor,
                inventario.id_proveedor, // id_proveedor_evento es el mismo
                inventario.id_tipo_cerveza,
                inventario.id_presentacion,
                inventario.id_cerveza
            ]);
            
            console.log('Nuevo detalle de venta creado');
        }
        
        // 6. Actualizar total de la venta
        const totalResult = await client.query(`
            SELECT COALESCE(SUM(precio_unitario * cantidad), 0) as total
            FROM Detalle_Venta_Evento 
            WHERE id_evento = $1 AND id_cliente_natural = $2
        `, [id_evento, id_cliente_natural]);
        
        await client.query(`
            UPDATE Venta_Evento 
            SET total = $1 
            WHERE evento_id = $2 AND id_cliente_natural = $3
        `, [totalResult.rows[0].total, id_evento, id_cliente_natural]);
        
        // 7. Descontar del inventario del evento
        await client.query(`
            UPDATE Inventario_Evento_Proveedor 
            SET cantidad = cantidad - $1 
            WHERE id_evento = $2 
            AND id_proveedor = $3 
            AND id_tipo_cerveza = $4 
            AND id_presentacion = $5 
            AND id_cerveza = $6
        `, [
            cantidad, 
            id_evento, 
            inventario.id_proveedor,
            inventario.id_tipo_cerveza,
            inventario.id_presentacion,
            inventario.id_cerveza
        ]);
        
        await client.query('COMMIT'); // Confirmar transacción
        
        res.json({
            success: true,
            message: `${cantidad} ${nombre_presentacion} de ${nombre_cerveza} agregado al carrito del evento`,
            total: totalResult.rows[0].total
        });
        
    } catch (error) {
        await client.query('ROLLBACK'); // Revertir transacción en caso de error
        console.error('Error al agregar producto al evento:', error);
        res.status(500).json({
            success: false,
            message: error.message || 'Error al agregar producto al evento'
        });
    } finally {
        client.release();
    }
};

// =================================================================
// OBTENER RESUMEN DEL CARRITO DE EVENTOS
// =================================================================
exports.obtenerResumenCarritoEvento = async (req, res) => {
    const client = await db.connect();
    
    try {
        const { id_evento, id_cliente_natural } = req.params;
        
        console.log('Obteniendo resumen del carrito del evento:', { id_evento, id_cliente_natural });
        
        // Obtener el total de ítems y el total monetario en el carrito del evento
        const result = await client.query(`
            SELECT 
                COALESCE(SUM(cantidad), 0) as total_items,
                COALESCE(SUM(precio_unitario * cantidad), 0) as total
            FROM Detalle_Venta_Evento 
            WHERE id_evento = $1 AND id_cliente_natural = $2
        `, [id_evento, id_cliente_natural]);
        
        const totalItems = parseInt(result.rows[0].total_items) || 0;
        const total = parseFloat(result.rows[0].total) || 0;
        
        res.json({
            success: true,
            total_items: totalItems,
            total: total
        });
        
    } catch (error) {
        console.error('Error al obtener resumen del carrito del evento:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener resumen del carrito del evento'
        });
    } finally {
        client.release();
    }
};

// =================================================================
// OBTENER ITEMS DEL CARRITO DE EVENTOS
// =================================================================
exports.obtenerItemsCarritoEvento = async (req, res) => {
    const client = await db.connect();
    
    try {
        const { id_evento, id_cliente_natural } = req.params;
        
        console.log('Obteniendo items del carrito del evento:', { id_evento, id_cliente_natural });
        
        // Obtener los items del carrito del evento con información detallada
        const result = await client.query(`
            SELECT 
                dve.precio_unitario,
                dve.cantidad,
                dve.id_evento,
                dve.id_cliente_natural,
                dve.id_cerveza,
                dve.id_proveedor,
                dve.id_proveedor_evento,
                dve.id_tipo_cerveza,
                dve.id_presentacion,
                dve.id_cerveza_inv,
                c.nombre_cerveza,
                p.nombre as nombre_presentacion
            FROM Detalle_Venta_Evento dve
            JOIN Cerveza c ON dve.id_cerveza = c.id_cerveza
            JOIN Presentacion p ON dve.id_presentacion = p.id_presentacion
            WHERE dve.id_evento = $1 AND dve.id_cliente_natural = $2
            ORDER BY c.nombre_cerveza, p.nombre
        `, [id_evento, id_cliente_natural]);
        
        res.json(result.rows);
        
    } catch (error) {
        console.error('Error al obtener items del carrito del evento:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener items del carrito del evento'
        });
    } finally {
        client.release();
    }
};

// =================================================================
// PROCESAR PAGO DE EVENTO
// =================================================================
exports.procesarPagoEvento = async (req, res) => {
    const client = await db.connect();
    
    try {
        await client.query('BEGIN'); // Iniciar transacción
        
        const { id_evento } = req.params;
        const { id_cliente_natural, pagos, total } = req.body;
        
        console.log('Procesando pago de evento:', {
            id_evento,
            id_cliente_natural,
            pagos,
            total
        });
        
        // 1. Verificar que la venta del evento existe
        const ventaResult = await client.query(`
            SELECT evento_id, id_cliente_natural, total 
            FROM Venta_Evento 
            WHERE evento_id = $1 AND id_cliente_natural = $2
        `, [id_evento, id_cliente_natural]);
        
        if (ventaResult.rows.length === 0) {
            throw new Error('Venta del evento no encontrada');
        }
        
        const venta = ventaResult.rows[0];
        
        // 2. Verificar que el total coincida
        if (Number(venta.total) !== Number(total)) {
            throw new Error('El total no coincide con la venta registrada');
        }
        
        // 3. Procesar cada método de pago
        for (const pago of pagos) {
            console.log('Procesando pago:', pago);
            
            // Crear método de pago (solo con el cliente)
            const metodoPagoResult = await client.query(`
                INSERT INTO Metodo_Pago (id_cliente_natural)
                VALUES ($1)
                RETURNING id_metodo
            `, [id_cliente_natural]);
            
            const idMetodoPago = metodoPagoResult.rows[0].id_metodo;
            
            // Crear pago específico según el tipo
            if (pago.tipo === 'efectivo') {
                await client.query(`
                    INSERT INTO Efectivo (id_metodo, denominacion)
                    VALUES ($1, $2)
                `, [idMetodoPago, pago.denominacion]);
                
            } else if (pago.tipo === 'tarjeta-debito') {
                await client.query(`
                    INSERT INTO Tarjeta_Debito (id_metodo, numero, banco)
                    VALUES ($1, $2, $3)
                `, [idMetodoPago, pago.numero, pago.banco]);
                
            } else if (pago.tipo === 'tarjeta-credito') {
                await client.query(`
                    INSERT INTO Tarjeta_Credito (id_metodo, tipo, numero, banco, fecha_vencimiento)
                    VALUES ($1, $2, $3, $4, $5)
                `, [idMetodoPago, pago.tipo_tarjeta, pago.numero, pago.banco, pago.fecha_vencimiento]);
                
            } else if (pago.tipo === 'cheque') {
                await client.query(`
                    INSERT INTO Cheque (id_metodo, num_cheque, num_cuenta, banco)
                    VALUES ($1, $2, $3, $4)
                `, [idMetodoPago, pago.numero, pago.cuenta, pago.banco]);
            }
            
            // Registrar el pago del evento
            await client.query(`
                INSERT INTO Pago_Evento (metodo_id, evento_id, id_cliente_natural, fecha_hora, monto, referencia)
                VALUES ($1, $2, $3, NOW(), $4, $5)
            `, [idMetodoPago, id_evento, id_cliente_natural, pago.monto, `PAGO_${Date.now()}`]);
        }
        
        await client.query('COMMIT'); // Confirmar transacción
        
        res.json({
            success: true,
            message: 'Pago del evento procesado correctamente',
            total: total
        });
        
    } catch (error) {
        await client.query('ROLLBACK'); // Revertir transacción en caso de error
        console.error('Error al procesar pago del evento:', error);
        res.status(500).json({
            success: false,
            message: error.message || 'Error al procesar el pago del evento'
        });
    } finally {
        client.release();
    }
};

// =================================================================
// ACTUALIZAR CANTIDAD EN CARRITO DE EVENTOS
// =================================================================
exports.actualizarCantidadEvento = async (req, res) => {
    const client = await db.connect();
    
    try {
        await client.query('BEGIN'); // Iniciar transacción
        
        const { id_evento } = req.params;
        const { id_cliente_natural, id_cerveza, id_proveedor, id_tipo_cerveza, id_presentacion, nueva_cantidad } = req.body;
        
        console.log('Actualizando cantidad en evento:', {
            id_evento,
            id_cliente_natural,
            id_cerveza,
            id_proveedor,
            id_tipo_cerveza,
            id_presentacion,
            nueva_cantidad
        });
        
        // 1. Obtener la cantidad actual en el carrito
        const cantidadActualResult = await client.query(`
            SELECT cantidad 
            FROM Detalle_Venta_Evento 
            WHERE id_evento = $1 
            AND id_cliente_natural = $2 
            AND id_cerveza = $3 
            AND id_proveedor = $4 
            AND id_tipo_cerveza = $5 
            AND id_presentacion = $6
        `, [id_evento, id_cliente_natural, id_cerveza, id_proveedor, id_tipo_cerveza, id_presentacion]);
        
        if (cantidadActualResult.rows.length === 0) {
            throw new Error('Producto no encontrado en el carrito del evento');
        }
        
        const cantidadActual = cantidadActualResult.rows[0].cantidad;
        const diferencia = nueva_cantidad - cantidadActual;
        
        // 2. Verificar stock disponible si se está aumentando la cantidad
        if (diferencia > 0) {
            const stockResult = await client.query(`
                SELECT cantidad as stock_disponible
                FROM Inventario_Evento_Proveedor 
                WHERE id_evento = $1 
                AND id_proveedor = $2 
                AND id_tipo_cerveza = $3 
                AND id_presentacion = $4 
                AND id_cerveza = $5
            `, [id_evento, id_proveedor, id_tipo_cerveza, id_presentacion, id_cerveza]);
            
            if (stockResult.rows.length === 0 || stockResult.rows[0].stock_disponible < diferencia) {
                throw new Error(`Stock insuficiente. Solo hay ${stockResult.rows[0]?.stock_disponible || 0} unidades disponibles`);
            }
        }
        
        // 3. Actualizar la cantidad en el carrito
        await client.query(`
            UPDATE Detalle_Venta_Evento 
            SET cantidad = $1 
            WHERE id_evento = $2 
            AND id_cliente_natural = $3 
            AND id_cerveza = $4 
            AND id_proveedor = $5 
            AND id_tipo_cerveza = $6 
            AND id_presentacion = $7
        `, [nueva_cantidad, id_evento, id_cliente_natural, id_cerveza, id_proveedor, id_tipo_cerveza, id_presentacion]);
        
        // 4. Actualizar el inventario del evento
        if (diferencia !== 0) {
            await client.query(`
                UPDATE Inventario_Evento_Proveedor 
                SET cantidad = cantidad - $1 
                WHERE id_evento = $2 
                AND id_proveedor = $3 
                AND id_tipo_cerveza = $4 
                AND id_presentacion = $5 
                AND id_cerveza = $6
            `, [diferencia, id_evento, id_proveedor, id_tipo_cerveza, id_presentacion, id_cerveza]);
        }
        
        // 5. Actualizar el total de la venta
        const totalResult = await client.query(`
            SELECT COALESCE(SUM(precio_unitario * cantidad), 0) as total
            FROM Detalle_Venta_Evento 
            WHERE id_evento = $1 AND id_cliente_natural = $2
        `, [id_evento, id_cliente_natural]);
        
        await client.query(`
            UPDATE Venta_Evento 
            SET total = $1 
            WHERE evento_id = $2 AND id_cliente_natural = $3
        `, [totalResult.rows[0].total, id_evento, id_cliente_natural]);
        
        await client.query('COMMIT'); // Confirmar transacción
        
        res.json({
            success: true,
            message: `Cantidad actualizada a ${nueva_cantidad} unidades`,
            total: totalResult.rows[0].total
        });
        
    } catch (error) {
        await client.query('ROLLBACK'); // Revertir transacción en caso de error
        console.error('Error al actualizar cantidad en evento:', error);
        res.status(500).json({
            success: false,
            message: error.message || 'Error al actualizar la cantidad'
        });
    } finally {
        client.release();
    }
};

// =================================================================
// ELIMINAR PRODUCTO DEL CARRITO DE EVENTOS
// =================================================================
exports.eliminarProductoEvento = async (req, res) => {
    const client = await db.connect();
    
    try {
        await client.query('BEGIN'); // Iniciar transacción
        
        const { id_evento } = req.params;
        const { id_cliente_natural, id_cerveza, id_proveedor, id_tipo_cerveza, id_presentacion } = req.body;
        
        console.log('Eliminando producto del evento:', {
            id_evento,
            id_cliente_natural,
            id_cerveza,
            id_proveedor,
            id_tipo_cerveza,
            id_presentacion
        });
        
        // 1. Obtener la cantidad que estaba en el carrito
        const cantidadResult = await client.query(`
            SELECT cantidad 
            FROM Detalle_Venta_Evento 
            WHERE id_evento = $1 
            AND id_cliente_natural = $2 
            AND id_cerveza = $3 
            AND id_proveedor = $4 
            AND id_tipo_cerveza = $5 
            AND id_presentacion = $6
        `, [id_evento, id_cliente_natural, id_cerveza, id_proveedor, id_tipo_cerveza, id_presentacion]);
        
        if (cantidadResult.rows.length === 0) {
            throw new Error('Producto no encontrado en el carrito del evento');
        }
        
        const cantidad = cantidadResult.rows[0].cantidad;
        
        // 2. Eliminar el producto del carrito
        await client.query(`
            DELETE FROM Detalle_Venta_Evento 
            WHERE id_evento = $1 
            AND id_cliente_natural = $2 
            AND id_cerveza = $3 
            AND id_proveedor = $4 
            AND id_tipo_cerveza = $5 
            AND id_presentacion = $6
        `, [id_evento, id_cliente_natural, id_cerveza, id_proveedor, id_tipo_cerveza, id_presentacion]);
        
        // 3. Restaurar el inventario del evento
        await client.query(`
            UPDATE Inventario_Evento_Proveedor 
            SET cantidad = cantidad + $1 
            WHERE id_evento = $2 
            AND id_proveedor = $3 
            AND id_tipo_cerveza = $4 
            AND id_presentacion = $5 
            AND id_cerveza = $6
        `, [cantidad, id_evento, id_proveedor, id_tipo_cerveza, id_presentacion, id_cerveza]);
        
        // 4. Actualizar el total de la venta
        const totalResult = await client.query(`
            SELECT COALESCE(SUM(precio_unitario * cantidad), 0) as total
            FROM Detalle_Venta_Evento 
            WHERE id_evento = $1 AND id_cliente_natural = $2
        `, [id_evento, id_cliente_natural]);
        
        await client.query(`
            UPDATE Venta_Evento 
            SET total = $1 
            WHERE evento_id = $2 AND id_cliente_natural = $3
        `, [totalResult.rows[0].total, id_evento, id_cliente_natural]);
        
        await client.query('COMMIT'); // Confirmar transacción
        
        res.json({
            success: true,
            message: 'Producto eliminado del carrito del evento',
            total: totalResult.rows[0].total
        });
        
    } catch (error) {
        await client.query('ROLLBACK'); // Revertir transacción en caso de error
        console.error('Error al eliminar producto del evento:', error);
        res.status(500).json({
            success: false,
            message: error.message || 'Error al eliminar el producto'
        });
    } finally {
        client.release();
    }
};

// =================================================================
// LIMPIAR CARRITO DE EVENTOS
// =================================================================
exports.limpiarCarritoEvento = async (req, res) => {
    const client = await db.connect();
    
    try {
        await client.query('BEGIN'); // Iniciar transacción
        
        const { id_evento, id_cliente_natural } = req.params;
        
        console.log('Limpiando carrito del evento:', { id_evento, id_cliente_natural });
        
        // 1. Obtener todos los productos en el carrito con sus cantidades
        const productosResult = await client.query(`
            SELECT id_cerveza, id_proveedor, id_tipo_cerveza, id_presentacion, cantidad
            FROM Detalle_Venta_Evento 
            WHERE id_evento = $1 AND id_cliente_natural = $2
        `, [id_evento, id_cliente_natural]);
        
        // 2. Restaurar el inventario para cada producto
        for (const producto of productosResult.rows) {
            await client.query(`
                UPDATE Inventario_Evento_Proveedor 
                SET cantidad = cantidad + $1 
                WHERE id_evento = $2 
                AND id_proveedor = $3 
                AND id_tipo_cerveza = $4 
                AND id_presentacion = $5 
                AND id_cerveza = $6
            `, [
                producto.cantidad,
                id_evento,
                producto.id_proveedor,
                producto.id_tipo_cerveza,
                producto.id_presentacion,
                producto.id_cerveza
            ]);
        }
        
        // 3. Eliminar todos los productos del carrito
        await client.query(`
            DELETE FROM Detalle_Venta_Evento 
            WHERE id_evento = $1 AND id_cliente_natural = $2
        `, [id_evento, id_cliente_natural]);
        
        // 4. Actualizar el total de la venta a 0
        await client.query(`
            UPDATE Venta_Evento 
            SET total = 0 
            WHERE evento_id = $1 AND id_cliente_natural = $2
        `, [id_evento, id_cliente_natural]);
        
        await client.query('COMMIT'); // Confirmar transacción
        
        res.json({
            success: true,
            message: 'Carrito del evento limpiado correctamente',
            productos_restaurados: productosResult.rows.length
        });
        
    } catch (error) {
        await client.query('ROLLBACK'); // Revertir transacción en caso de error
        console.error('Error al limpiar carrito del evento:', error);
        res.status(500).json({
            success: false,
            message: error.message || 'Error al limpiar el carrito'
        });
    } finally {
        client.release();
    }
};

// =================================================================
// ACTUALIZAR EVENTO (ENTRADAS VENDIDAS Y PRECIO)
// =================================================================
exports.actualizarEvento = async (req, res) => {
    const client = await db.connect();
    
    try {
        await client.query('BEGIN'); // Iniciar transacción
        
        const { id_evento } = req.params;
        const { n_entradas_vendidas, precio_unitario_entrada } = req.body;
        
        console.log('Actualizando evento:', {
            id_evento,
            n_entradas_vendidas,
            precio_unitario_entrada
        });
        
        // Validaciones
        if (n_entradas_vendidas < 0) {
            throw new Error('El número de entradas vendidas no puede ser negativo');
        }
        
        if (precio_unitario_entrada < 0) {
            throw new Error('El precio unitario no puede ser negativo');
        }
        
        // Verificar que el evento existe
        const eventoResult = await client.query(`
            SELECT id_evento, nombre 
            FROM Evento 
            WHERE id_evento = $1
        `, [id_evento]);
        
        if (eventoResult.rows.length === 0) {
            throw new Error('Evento no encontrado');
        }
        
        const evento = eventoResult.rows[0];
        
        // Actualizar el evento
        await client.query(`
            UPDATE Evento 
            SET n_entradas_vendidas = $1, 
                precio_unitario_entrada = $2
            WHERE id_evento = $3
        `, [n_entradas_vendidas, precio_unitario_entrada, id_evento]);
        
        await client.query('COMMIT'); // Confirmar transacción
        
        res.json({
            success: true,
            message: `Evento "${evento.nombre}" actualizado correctamente`,
            evento: {
                id_evento: id_evento,
                nombre: evento.nombre,
                n_entradas_vendidas: n_entradas_vendidas,
                precio_unitario_entrada: precio_unitario_entrada
            }
        });
        
    } catch (error) {
        await client.query('ROLLBACK'); // Revertir transacción en caso de error
        console.error('Error al actualizar evento:', error);
        res.status(500).json({
            success: false,
            message: error.message || 'Error al actualizar el evento'
        });
    } finally {
        client.release();
    }
}; 