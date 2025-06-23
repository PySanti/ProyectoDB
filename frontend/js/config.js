// =====================================================
// CONFIGURACIÓN GLOBAL - FRONTEND
// =====================================================

// Configuración de la API
const API_BASE_URL = 'http://localhost:3000/api'; // Ajusta según tu backend 

/**
 * Obtener imagen del producto (lógica centralizada)
 */
function getProductImage(productName) {
    // Mapeo temporal de productos a imágenes
    const imageMap = {
        'Destilo Amber Ale': 'https://images.unsplash.com/photo-1566633806327-68e152aaf26d?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
        'Benitz Pale Ale': 'https://images.unsplash.com/photo-1600788886242-5c96aabe3757?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
        'Mito Brewhouse Candileja': 'https://images.unsplash.com/photo-1612528443702-f6741f70a049?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
        'Cervecería Lago Ángel o Demonio': 'https://images.unsplash.com/photo-1618183479302-1e0aa382c36b?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
        'Barricas Saison Belga': 'https://images.unsplash.com/photo-1596424773667-11d2f98ad6b1?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
        'Aldarra Mantuana': 'https://images.unsplash.com/photo-1613989969925-d64b5a1fcf11?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80'
    };
    
    // Imagen por defecto si no se encuentra una específica
    return imageMap[productName] || 'https://images.unsplash.com/photo-1586993451228-098b8b22e386?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80';
} 