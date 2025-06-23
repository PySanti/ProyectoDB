const db = require('../db_connection');

// =================================================================
// OBTENER TODOS LOS PRODUCTOS PARA EL CATÁLOGO (CON FILTROS Y PAGINACIÓN)
// =================================================================
async function getProducts(req, res) {
    try {
        const { sortBy = 'relevance', page = 1, limit = 9 } = req.query;
        
        // Llamar a las funciones SQL para obtener productos y total
        const productsResult = await db.query(
            'SELECT * FROM obtener_productos_catalogo($1, $2, $3)',
            [sortBy, parseInt(page), parseInt(limit)]
        );
        
        const totalResult = await db.query('SELECT contar_productos_catalogo() as total');
        const totalProducts = parseInt(totalResult.rows[0].total);
        const totalPages = Math.ceil(totalProducts / limit);
        
        // Limpiar la columna helper antes de enviar la respuesta
        const products = productsResult.rows.map(p => {
            delete p.min_price;
            return p;
        });
        
        res.json({ 
            products, 
            totalProducts, 
            totalPages, 
            currentPage: parseInt(page) 
        });
        
    } catch (error) {
        console.error('Error al obtener productos:', error);
        res.status(500).json({ success: false, message: 'Error interno del servidor' });
    }
}

module.exports = {
    getProducts,
}; 