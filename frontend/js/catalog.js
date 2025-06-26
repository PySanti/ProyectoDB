// =====================================================
// FUNCIÓN DE IMÁGENES (DECLARADA AL PRINCIPIO)
// =====================================================

function getProductImage(productName) {
    const imageMap = {
        'Destilo Amber Ale': 'https://images.unsplash.com/photo-1566633806327-68e152aaf26d?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
        'Benitz Pale Ale': 'https://images.unsplash.com/photo-1600788886242-5c96aabe3757?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
        'Mito Brewhouse Candileja': 'https://images.unsplash.com/photo-1612528443702-f6741f70a049?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
        'Cervecería Lago Ángel o Demonio': 'https://images.unsplash.com/photo-1618183479302-1e0aa382c36b?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
        'Barricas Saison Belga': 'https://images.unsplash.com/photo-1596424773667-11d2f98ad6b1?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
        'Aldarra Mantuana': 'https://images.unsplash.com/photo-1613989969925-d64b5a1fcf11?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80'
    };
    return imageMap[productName] || 'https://images.unsplash.com/photo-1586993451228-098b8b22e386?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80';
}

// =====================================================
// FUNCIONES AUXILIARES DE LOADING (pueden quedarse o moverse a utils.js)
// =====================================================

function showLoading() {
    document.querySelector('.catalog-products')?.classList.add('loading');
}

function hideLoading() {
    document.querySelector('.catalog-products')?.classList.remove('loading');
}

// =====================================================
// CATÁLOGO DE PRODUCTOS REDISEÑADO - FRONTEND
// =====================================================

const PRODUCTS_API = '/productos';

// Estado simplificado para manejar el catálogo
let catalogState = {
    products: [],
    currentPage: 1,
    itemsPerPage: 9,
    totalProducts: 0,
    totalPages: 1,
    sortBy: 'relevance' // Solo mantenemos el filtro de ordenamiento
};

// =====================================================
// INICIALIZACIÓN
// =====================================================
document.addEventListener('DOMContentLoaded', () => {
    initCatalog();
});

function initCatalog() {
    loadProducts();
    // No es necesario llamar a setupEventListeners aquí si usamos delegación en un contenedor estático
}

// =====================================================
// MANEJO DE EVENTOS
// =====================================================
function setupEventListeners() {
    // Implementación con delegación de eventos
    const productGrid = document.querySelector('.product-grid');
    if (productGrid) {
        productGrid.addEventListener('click', (event) => {
            const target = event.target;

            // Lógica para el botón 'Añadir al carrito'
            if (target.classList.contains('add-to-cart-btn')) {
                const card = target.closest('.product-card');
                const selectedPresentation = card.querySelector('input[name^="presentation-"]:checked');
                
                if (selectedPresentation) {
                    const inventarioId = selectedPresentation.value;
                    // Buscar el producto y presentación correspondientes
                    const product = catalogState.products.find(p => p.id_cerveza == card.dataset.cervezaId);
                    const presentation = product.presentaciones.find(p => p.id_inventario == inventarioId);
                    
                    if (product && presentation) {
                        handleAddToCart(presentation.id_inventario, 1);
                    } else {
                        showNotification('Error al obtener información del producto.', 'error');
                    }
                } else {
                    showNotification('Por favor, selecciona una presentación.', 'info');
                }
            }
        });
    }

    // Listener para el selector de ordenamiento
    const sortSelect = document.getElementById('sort-by');
    if (sortSelect) {
        sortSelect.addEventListener('change', (event) => {
            const sortBy = event.target.value;
            loadProducts(1, sortBy); // Recargar productos con el nuevo orden
        });
    }
}

// =====================================================
// LÓGICA DE CARGA Y RENDERIZADO
// =====================================================
async function loadProducts(page = 1, sortBy = 'relevance') {
    showLoading();
    try {
        const url = new URL(`${API_BASE_URL}/productos`);
        
        // Construir los parámetros de la URL
        url.searchParams.append('sortBy', sortBy);
        url.searchParams.append('page', page);
        url.searchParams.append('limit', catalogState.itemsPerPage);

        const response = await fetch(url);
        if (!response.ok) throw new Error(`Error HTTP: ${response.status}`);
        
        const data = await response.json();
        
        // Actualizar estado con los datos del backend
        catalogState.products = data.products;
        catalogState.totalProducts = data.totalProducts;
        catalogState.totalPages = data.totalPages;

        renderPage();

    } catch (error) {
        console.error('Error al cargar productos:', error);
        showNotification('No se pudieron cargar los productos.', 'error');
    } finally {
        hideLoading();
    }
}

function renderPage() {
    renderProducts();
    renderPagination();
    updateProductCount();
}

function renderProducts() {
    const productGrid = document.querySelector('.product-grid');
    if (!productGrid) return;

    productGrid.innerHTML = ''; // Limpiar grid

    if (catalogState.products.length === 0) {
        productGrid.innerHTML = `<p class="no-products-found">No se encontraron productos que coincidan con los filtros.</p>`;
        return;
    }

    catalogState.products.forEach(product => {
        const productCard = createProductCard(product);
        productGrid.appendChild(productCard);
    });

    // Re-configurar los listeners después de renderizar los productos
    setupEventListeners();
}

function renderPagination() {
    const paginationContainer = document.querySelector('.pagination');
    if (!paginationContainer) return;

    paginationContainer.innerHTML = '';
    if (catalogState.totalPages <= 1) return;

    for (let i = 1; i <= catalogState.totalPages; i++) {
        const pageLink = document.createElement('a');
        pageLink.href = '#';
        pageLink.textContent = i;
        pageLink.className = `page-link ${i === catalogState.currentPage ? 'active' : ''}`;
        pageLink.addEventListener('click', (e) => {
            e.preventDefault();
            if (catalogState.currentPage !== i) {
                catalogState.currentPage = i;
                loadProducts(i, catalogState.sortBy);
                scrollToCatalogTop();
            }
        });
        paginationContainer.appendChild(pageLink);
    }
}

function scrollToCatalogTop() {
    const catalogSection = document.querySelector('.product-grid');
    if (catalogSection) {
        catalogSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
    } else {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
}

function updateProductCount() {
    const countElement = document.querySelector('.product-count');
    if (!countElement) return;

    const { currentPage, itemsPerPage, totalProducts } = catalogState;
    const start = Math.min((currentPage - 1) * itemsPerPage + 1, totalProducts);
    const end = Math.min(currentPage * itemsPerPage, totalProducts);
    
    countElement.textContent = `Mostrando ${start}-${end} de ${totalProducts} productos`;
}

// =====================================================
// FUNCIONES AUXILIARES
// =====================================================

/**
 * Agrega un producto al carrito en la base de datos para un usuario genérico.
 */
async function handleAddToCart(idInventario, cantidad) {
    const compraId = await ensureCompraId();
    if (!compraId) {
        showNotification('No hay carrito activo para este cliente.', 'info');
        return;
    }
    const resumen = await fetch(`${API_BASE_URL}/carrito/resumen-por-id/${compraId}`).then(r => r.json());
    if (!resumen || resumen.estatus_nombre.toLowerCase() !== 'en proceso') {
        showNotification('El carrito ya fue pagado o cerrado. No se pueden realizar más operaciones.', 'info');
        return;
    }
    try {
        const response = await fetch(`${API_BASE_URL}/carrito/agregar-producto`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ compra_id: compraId, id_inventario: idInventario, cantidad })
        });

        const result = await response.json();

        if (result.success) {
            showNotification(result.message || 'Producto agregado al carrito', 'success');
            updateCartCounter();
        } else {
            showNotification(result.message || 'Error al agregar el producto', 'error');
        }
    } catch (error) {
        console.error('Error al agregar al carrito:', error);
        showNotification('Error de conexión al agregar al carrito.', 'error');
    }
}

function createProductCard(product) {
    const card = document.createElement('div');
    card.className = 'product-card';
    card.dataset.cervezaId = product.id_cerveza;

    // Generar un nombre único para el grupo de radio buttons de esta tarjeta
    const radioGroupName = `cerveza-${product.id_cerveza}`;

    card.innerHTML = `
        <div class="product-header">
            <h3 class="product-title">${product.nombre_cerveza}</h3>
            <p class="product-type">${product.tipo_cerveza}</p>
        </div>

        <div class="product-body">
            <h4>Presentaciones:</h4>
            <div class="presentation-list">
                ${product.presentaciones.map(p => `
                    <div class="presentation-item">
                        <input type="radio" 
                               name="${radioGroupName}" 
                               id="inv-${p.id_inventario}" 
                               value="${p.id_inventario}" 
                               ${p.stock_disponible === 0 ? 'disabled' : ''}>
                        <label for="inv-${p.id_inventario}">
                            ${p.nombre_presentacion}
                        </label>
                    </div>
                `).join('')}
            </div>
        </div>

        <div class="product-footer">
            <span class="product-price">$0.00</span>
            <button class="add-to-cart-btn" disabled>Seleccione</button>
        </div>
    `;

    const radioButtons = card.querySelectorAll('input[type="radio"]');
    const priceElement = card.querySelector('.product-price');
    const addToCartButton = card.querySelector('.add-to-cart-btn');

    // Función para actualizar la tarjeta
    function updateCard(selectedInventarioId) {
        const selectedPresentation = product.presentaciones.find(p => p.id_inventario == selectedInventarioId);
        if (selectedPresentation) {
            const price = parseFloat(selectedPresentation.precio_unitario) || 0;
            priceElement.textContent = `$${price.toFixed(2)}`;
            addToCartButton.disabled = false;
            addToCartButton.textContent = 'Añadir al carrito';
            addToCartButton.onclick = () => handleAddToCart(selectedPresentation.id_inventario, 1);
        }
    }

    radioButtons.forEach(radio => {
        radio.addEventListener('change', () => updateCard(radio.value));
    });

    // Seleccionar la primera presentación disponible por defecto
    const firstAvailableRadio = Array.from(radioButtons).find(r => !r.disabled);
    if (firstAvailableRadio) {
        firstAvailableRadio.checked = true;
        updateCard(firstAvailableRadio.value);
    }

    return card;
} 