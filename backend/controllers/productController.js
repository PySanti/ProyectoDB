const db = require('../db_connection');

// =================================================================
// OBTENER TODOS LOS PRODUCTOS PARA EL CATÁLOGO (CON FILTROS Y PAGINACIÓN)
// =================================================================
async function getProducts(req, res) {
    try {
        const { sortBy = 'relevance', page = 1, limit = 9 } = req.query;

        const offset = (parseInt(page) - 1) * parseInt(limit);
        
        // CTE para asegurar que cada presentación de inventario sea única
        const baseQuery = `
            WITH UnicoInventario AS (
                SELECT DISTINCT ON (id_cerveza, id_presentacion)
                    id_inventario, cantidad, id_presentacion, id_cerveza
                FROM Inventario
                -- Priorizamos la tienda física si hay múltiples entradas
                ORDER BY id_cerveza, id_presentacion, id_tienda_fisica DESC NULLS LAST
            )
        `;

        // Contar el total de productos (cervezas distintas)
        const countResult = await db.query('SELECT COUNT(*) FROM Cerveza;');
        const totalProducts = parseInt(countResult.rows[0].count);
        const totalPages = Math.ceil(totalProducts / limit);

        // Construir la consulta final de productos
        let finalQuery = `
            ${baseQuery}
            SELECT
                c.id_cerveza, c.nombre_cerveza, tc.nombre AS tipo_cerveza,
                MIN(pc.cantidad) as min_price, -- Helper para ordenar por precio
                COALESCE(
                    json_agg(
                        json_build_object(
                            'id_inventario', i.id_inventario,
                            'id_presentacion', p.id_presentacion, 'nombre_presentacion', p.nombre,
                            'precio_unitario', pc.precio,
                            'stock_disponible', COALESCE(i.cantidad, 0)
                        ) ORDER BY p.id_presentacion
                    ) FILTER (WHERE p.id_presentacion IS NOT NULL),
                    '[]'::json
                ) AS presentaciones
            FROM Cerveza c
            JOIN Tipo_Cerveza tc ON c.id_tipo_cerveza = tc.id_tipo_cerveza
            LEFT JOIN presentacion_cerveza pc ON c.id_cerveza = pc.id_cerveza
            LEFT JOIN Presentacion p ON pc.id_presentacion = p.id_presentacion
            -- Unimos con nuestro inventario único para evitar duplicados
            LEFT JOIN UnicoInventario i ON pc.id_cerveza = i.id_cerveza AND pc.id_presentacion = i.id_presentacion
            GROUP BY c.id_cerveza, tc.nombre
        `;

        // Aplicar ordenamiento
        let orderByClause = ' ORDER BY ';
        switch(sortBy) {
            case 'price-asc': orderByClause += 'min_price ASC NULLS LAST'; break;
            case 'price-desc': orderByClause += 'min_price DESC NULLS LAST'; break;
            case 'name-asc': orderByClause += 'c.nombre_cerveza ASC'; break;
            case 'name-desc': orderByClause += 'c.nombre_cerveza DESC'; break;
            default: orderByClause += 'c.id_cerveza ASC';
        }
        finalQuery += orderByClause;

        // Aplicar paginación
        finalQuery += ` LIMIT ${parseInt(limit)} OFFSET ${offset}`;

        const productsResult = await db.query(finalQuery);

        // Limpiar la columna helper antes de enviar la respuesta
        const products = productsResult.rows.map(p => {
            delete p.min_price;
            return p;
        });

        res.json({ products, totalProducts, totalPages, currentPage: parseInt(page) });

    } catch (error) {
        console.error('Error al obtener productos:', error);
        res.status(500).json({ success: false, message: 'Error interno del servidor' });
    }
}

module.exports = {
    getProducts,
}; 