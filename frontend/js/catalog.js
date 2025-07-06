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
document.addEventListener('DOMContentLoaded', async () => {
    // Detectar cambio de usuario/cliente
    const lastUserKey = 'lastUserOrClient';
    let currentUser = null;
    let currentClient = null;
    let userType = null;
    
    if (localStorage.getItem('user')) {
        try {
            currentUser = JSON.parse(localStorage.getItem('user'));
            userType = 'usuario';
        } catch {}
    } else if (sessionStorage.getItem('currentClient')) {
        try {
            currentClient = JSON.parse(sessionStorage.getItem('currentClient'));
            userType = 'cliente';
        } catch {}
    }
    
    let currentId = null;
    if (userType === 'usuario' && currentUser) currentId = currentUser.id_usuario;
    if (userType === 'cliente' && currentClient) currentId = currentClient.id;
    
    const lastUserOrClient = sessionStorage.getItem(lastUserKey);
    if (lastUserOrClient && lastUserOrClient !== String(currentId)) {
        // Limpiar carrito en backend
        try {
            let url = '';
            if (userType === 'usuario') {
                url = `${API_BASE_URL}/carrito/limpiar/${currentId}`;
            } else if (userType === 'cliente') {
                url = `${API_BASE_URL}/carrito/limpiar/1?id_cliente_natural=${currentId}`;
            }
            if (url) {
                await fetch(url, { method: 'DELETE' });
            }
        } catch (e) { console.error('Error limpiando carrito:', e); }
    }
    // Guardar el usuario/cliente actual para la próxima vez
    if (currentId) sessionStorage.setItem(lastUserKey, String(currentId));
    
    initCatalog();
});

function initCatalog() {
    // Verificar si es venta de eventos y ajustar la interfaz
    const eventoVenta = sessionStorage.getItem('eventoVenta');
    if (eventoVenta) {
        try {
            const eventoData = JSON.parse(eventoVenta);
            if (eventoData.tipo_venta === 'eventos') {
                adjustInterfaceForEventos();
            }
        } catch (error) {
            console.error('Error al parsear datos del evento:', error);
        }
    }
    
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
                        addToCart(product.nombre_cerveza, presentation.nombre_presentacion);
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
        // Verificar si es venta de eventos
        const eventoVenta = sessionStorage.getItem('eventoVenta');
        let isEventoVenta = false;
        let eventoData = null;
        
        if (eventoVenta) {
            try {
                eventoData = JSON.parse(eventoVenta);
                isEventoVenta = eventoData.tipo_venta === 'eventos';
            } catch (error) {
                console.error('Error al parsear datos del evento:', error);
            }
        }
        
        let url;
        if (isEventoVenta && eventoData) {
            // Cargar inventario específico del evento
            url = new URL(`${API_BASE_URL}/eventos/${eventoData.id_evento}/inventario`);
            console.log('Cargando inventario del evento:', eventoData.id_evento);
        } else {
            // Cargar productos normales del catálogo
            url = new URL(`${API_BASE_URL}/productos`);
            console.log('Cargando productos del catálogo general');
        }
        
        // Construir los parámetros de la URL
        url.searchParams.append('sortBy', sortBy);
        url.searchParams.append('page', page);
        url.searchParams.append('limit', catalogState.itemsPerPage);

        const response = await fetch(url);
        if (!response.ok) throw new Error(`Error HTTP: ${response.status}`);
        
        const data = await response.json();
        
        // Actualizar estado con los datos del backend
        catalogState.products = data.products || data.inventario || [];
        catalogState.totalProducts = data.totalProducts || data.total || 0;
        catalogState.totalPages = data.totalPages || 1;

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
 * Agrega un producto al carrito en la base de datos.
 * Maneja ventas web/físicas y ventas de eventos de manera diferente.
 */
async function addToCart(nombre_cerveza, nombre_presentacion, cantidad = 1) {
    if (!nombre_cerveza || !nombre_presentacion) {
        showNotification('Por favor, selecciona una presentación.', 'info');
        return;
    }

    // Verificar si es venta de eventos
    const eventoVenta = sessionStorage.getItem('eventoVenta');
    let isEventoVenta = false;
    let eventoData = null;
    
    if (eventoVenta) {
        try {
            eventoData = JSON.parse(eventoVenta);
            isEventoVenta = eventoData.tipo_venta === 'eventos';
        } catch (error) {
            console.error('Error al parsear datos del evento:', error);
        }
    }

    if (isEventoVenta) {
        // Lógica para ventas de eventos
        await addToEventoCart(nombre_cerveza, nombre_presentacion, cantidad, eventoData);
    } else {
        // Lógica para ventas web/físicas (código original)
        await addToRegularCart(nombre_cerveza, nombre_presentacion, cantidad);
    }
}

/**
 * Agrega un producto al carrito de eventos
 */
async function addToEventoCart(nombre_cerveza, nombre_presentacion, cantidad, eventoData) {
    try {
        // Obtener el cliente validado
        const currentClientStr = sessionStorage.getItem('currentClient');
        if (!currentClientStr) {
            showNotification('Debe validar un cliente antes de agregar productos.', 'error');
            return;
        }

        const client = JSON.parse(currentClientStr);
        if (client.tipo !== 'natural') {
            showNotification('Solo clientes naturales pueden comprar en eventos.', 'error');
            return;
        }

        const response = await fetch(`${API_BASE_URL}/eventos/${eventoData.id_evento}/agregar-producto`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                id_cliente_natural: client.id,
                nombre_cerveza: nombre_cerveza,
                nombre_presentacion: nombre_presentacion,
                cantidad: cantidad
            }),
        });

        const result = await response.json();

        if (result.success) {
            showNotification(result.message || 'Producto agregado al carrito del evento', 'success');
            updateCartCounter();
        } else {
            showNotification(result.message || 'Error al agregar el producto al evento', 'error');
        }
    } catch (error) {
        console.error('Error al agregar al carrito del evento:', error);
        showNotification('Error de conexión al agregar al carrito del evento.', 'error');
    }
}

/**
 * Agrega un producto al carrito regular (web/físico)
 */
async function addToRegularCart(nombre_cerveza, nombre_presentacion, cantidad) {
    // Obtener el usuario actual
    const userStr = localStorage.getItem('user');
    let idUsuario = 1; // GUEST_USER_ID por defecto
    if (userStr) {
        try {
            const user = JSON.parse(userStr);
            idUsuario = user.id_usuario;
            console.log('Usuario logueado detectado, ID:', idUsuario);
        } catch (error) {
            console.error('Error al parsear usuario:', error);
        }
    }

    // Detectar tipo de venta
    let tipo_venta = 'web';
    let id_ubicacion = null;
    let id_cliente_natural = null;
    let id_cliente_juridico = null;
    // Si hay un currentClient en sessionStorage, asumimos venta física
    const currentClientStr = sessionStorage.getItem('currentClient');
    if (currentClientStr) {
        tipo_venta = 'fisica';
        try {
            const client = JSON.parse(currentClientStr);
            if (client.tipo === 'natural') {
                id_cliente_natural = client.id;
            } else if (client.tipo === 'juridico') {
                id_cliente_juridico = client.id;
            }
        } catch (e) {
            console.error('Error al parsear currentClient:', e);
        }
    }

    try {
        const response = await fetch(`${API_BASE_URL}/carrito/agregar-por-producto`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                id_usuario: tipo_venta === 'web' ? idUsuario : null,
                nombre_cerveza: nombre_cerveza,
                nombre_presentacion: nombre_presentacion,
                cantidad: cantidad,
                tipo_venta: tipo_venta,
                id_ubicacion: id_ubicacion,
                id_cliente_natural: id_cliente_natural,
                id_cliente_juridico: id_cliente_juridico
            }),
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
                            <span class="stock-info">(${p.stock_disponible} disponibles)</span>
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
            
            // Mostrar información de stock en el botón
            const stockInfo = selectedPresentation.stock_disponible > 0 
                ? `Añadir al carrito (${selectedPresentation.stock_disponible} disponibles)`
                : 'Sin stock disponible';
            
            addToCartButton.textContent = stockInfo;
            
            // Deshabilitar botón si no hay stock
            if (selectedPresentation.stock_disponible <= 0) {
                addToCartButton.disabled = true;
                addToCartButton.textContent = 'Sin stock disponible';
            } else {
                addToCartButton.disabled = false;
                addToCartButton.onclick = () => addToCart(product.nombre_cerveza, selectedPresentation.nombre_presentacion, 1);
            }
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

/**
 * Ajustar la interfaz para ventas de eventos
 */
function adjustInterfaceForEventos() {
    // Cambiar el título del header
    const logoTitle = document.getElementById('logo-title');
    if (logoTitle) {
        const eventoVenta = sessionStorage.getItem('eventoVenta');
        if (eventoVenta) {
            try {
                const eventoData = JSON.parse(eventoVenta);
                logoTitle.textContent = `ACAUCAB - Evento #${eventoData.id_evento}`;
            } catch (error) {
                console.error('Error al parsear datos del evento:', error);
                logoTitle.textContent = 'ACAUCAB - Eventos';
            }
        }
    }
    
    // Cambiar el título de la página
    const pageTitle = document.querySelector('.page-title h1');
    if (pageTitle) {
        pageTitle.textContent = 'Catálogo de Productos del Evento';
    }
    
    // Cambiar la descripción
    const pageDescription = document.querySelector('.page-title p');
    if (pageDescription) {
        pageDescription.textContent = 'Selecciona los productos disponibles para este evento especial';
    }
    
    console.log('Interfaz ajustada para ventas de eventos');
} 