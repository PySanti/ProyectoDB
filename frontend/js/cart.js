// =================================================================
// CONFIGURACIÓN E INICIALIZACIÓN
// =================================================================
const GUEST_USER_ID = 1; 

document.addEventListener('DOMContentLoaded', initCart);

function initCart() {
    // Solo ejecuta la lógica de la página del carrito si encuentra el contenedor principal.
    if (document.querySelector('.cart-section')) {
        loadCart();
        setupCartEventListeners();
    }
}

// Función para obtener el ID de usuario actual
function getCurrentUserId() {
    const userStr = localStorage.getItem('user');
    if (userStr) {
        try {
            const user = JSON.parse(userStr);
            return user.id_usuario;
        } catch (error) {
            console.error('Error al parsear usuario:', error);
        }
    }
    return GUEST_USER_ID;
}

// =================================================================
// RENDERIZADO DEL CARRITO
// =================================================================
async function loadCart() {
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

        if (isEventoVenta) {
            // Cargar carrito de eventos
            await loadEventoCart(eventoData);
        } else {
            // Cargar carrito regular (web/físico)
            await loadRegularCart();
        }
    } catch (error) {
        console.error('Error al cargar carrito:', error);
        renderEmptyCart();
    }
}

/**
 * Carga el carrito de eventos
 */
async function loadEventoCart(eventoData) {
    try {
        // Obtener el cliente validado
        const currentClientStr = sessionStorage.getItem('currentClient');
        if (!currentClientStr) {
            renderEmptyCart();
            return;
        }

        const client = JSON.parse(currentClientStr);
        if (client.tipo !== 'natural') {
            renderEmptyCart();
            return;
        }

        console.log('Cargando carrito de eventos para cliente:', client.id);
        
        const response = await fetch(`${API_BASE_URL}/eventos/${eventoData.id_evento}/carrito/${client.id}/items`);
        if (!response.ok) throw new Error('No se pudo cargar el carrito del evento.');
        
        const items = await response.json();
        
        if (items.length === 0) {
            renderEmptyCart();
        } else {
            renderEventoCartItems(items, eventoData);
            const summaryResponse = await fetch(`${API_BASE_URL}/eventos/${eventoData.id_evento}/carrito/${client.id}`);
            const summary = await summaryResponse.json();
            renderEventoSummary(summary, eventoData);
        }
    } catch (error) {
        console.error('Error al cargar carrito de eventos:', error);
        renderEmptyCart();
    }
}

/**
 * Carga el carrito regular (web/físico)
 */
async function loadRegularCart() {
    try {
        const userId = getCurrentUserId();
        console.log('Cargando carrito regular para usuario ID:', userId);
        
        const response = await fetch(`${API_BASE_URL}/carrito/usuario/${userId}`);
        if (!response.ok) throw new Error('No se pudo cargar el carrito.');
        
        const items = await response.json();
        
        if (items.length === 0) {
            renderEmptyCart();
        } else {
            renderCartItems(items);
            const summaryResponse = await fetch(`${API_BASE_URL}/carrito/resumen/${userId}`);
            const summary = await summaryResponse.json();
            renderSummary(summary);
        }
    } catch (error) {
        console.error('Error al cargar carrito regular:', error);
        renderEmptyCart();
    }
}

function renderCartItems(items) {
    const cartList = document.querySelector('.cart-items-list');
    cartList.innerHTML = ''; // Limpiar la lista
    items.forEach(item => {
        const itemElement = document.createElement('div');
        itemElement.className = 'cart-item';
        itemElement.innerHTML = `
            <div class="cart-item-product">
                <div class="cart-item-details">
                    <h4 class="cart-item-title">${item.nombre_cerveza}</h4>
                    <p class="cart-item-presentation">${item.nombre_presentacion}</p>
                </div>
            </div>
            <div class="cart-item-price">$${Number(item.precio_unitario).toFixed(2)}</div>
            <div class="cart-item-quantity">
                <button class="quantity-btn decrease-btn" data-inventario-id="${item.id_inventario}">-</button>
                <input type="number" class="quantity-input" value="${item.cantidad}" min="1" max="${item.stock_disponible}" data-inventario-id="${item.id_inventario}">
                <button class="quantity-btn increase-btn" data-inventario-id="${item.id_inventario}">+</button>
            </div>
            <div class="cart-item-total">$${Number(item.subtotal).toFixed(2)}</div>
            <div class="cart-item-remove">
                <button class="remove-item-btn" data-inventario-id="${item.id_inventario}"><i class="fas fa-trash-alt"></i></button>
            </div>
        `;
        cartList.appendChild(itemElement);
    });
}

function renderSummary(summary) {
    const summaryBox = document.querySelector('.cart-summary');
    summaryBox.innerHTML = `
        <h3>Resumen del Pedido</h3>
        <div class="summary-item">
            <span>Total Items</span>
            <span>${summary.total_items || 0}</span>
        </div>
        <div class="summary-item total">
            <span>Total</span>
            <span>$${Number(summary.monto_total || 0).toFixed(2)}</span>
        </div>
        <button class="checkout-btn" onclick="proceedToCheckout()">Proceder al Pago</button>
        <a href="catalog.html" class="continue-shopping-btn">← Continuar Comprando</a>
    `;
}

// Función directa para el checkout regular
async function proceedToCheckout() {
    console.log('Función proceedToCheckout llamada');
    
    try {
        const userId = getCurrentUserId();
        console.log('Procediendo al checkout con usuario ID:', userId);
        
        // Primero actualizar el monto de la compra
        const response = await fetch(`${API_BASE_URL}/carrito/actualizar-monto`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                id_usuario: userId
            }),
        });

        const result = await response.json();

        if (result.success) {
            console.log('Monto actualizado:', result.monto_total);
            showNotification('Monto de compra actualizado correctamente', 'success');
            // Redirigir al checkout
            window.location.href = 'checkout.html';
        } else {
            showNotification(result.message || 'Error al actualizar el monto', 'error');
        }
    } catch (error) {
        console.error('Error al actualizar monto:', error);
        showNotification('Error de conexión al actualizar el monto', 'error');
    }
}

// Función para el checkout de eventos
async function proceedToEventoCheckout() {
    console.log('Función proceedToEventoCheckout llamada');
    
    try {
        // Verificar que tenemos los datos del evento
        const eventoVenta = sessionStorage.getItem('eventoVenta');
        const currentClient = sessionStorage.getItem('currentClient');
        
        if (!eventoVenta || !currentClient) {
            showNotification('Error: Datos del evento no encontrados', 'error');
            return;
        }
        
        const eventoData = JSON.parse(eventoVenta);
        const client = JSON.parse(currentClient);
        
        console.log('Procediendo al checkout del evento:', eventoData.id_evento);
        
        // Redirigir al checkout de eventos
        window.location.href = 'checkout.html';
        
    } catch (error) {
        console.error('Error al proceder al checkout del evento:', error);
        showNotification('Error al proceder al checkout del evento', 'error');
    }
}

function renderEmptyCart() {
    const cartItems = document.querySelector('.cart-items');
    cartItems.innerHTML = `
        <div class="empty-cart-message">
            <h3>Tu carrito está vacío</h3>
            <p>Parece que no has agregado ningún producto todavía.</p>
            <a href="catalog.html" class="btn-primary">Ir al Catálogo</a>
        </div>
    `;
}

/**
 * Renderiza los items del carrito de eventos
 */
function renderEventoCartItems(items, eventoData) {
    const cartList = document.querySelector('.cart-items-list');
    cartList.innerHTML = ''; // Limpiar la lista
    
    items.forEach(item => {
        const itemElement = document.createElement('div');
        itemElement.className = 'cart-item';
        itemElement.innerHTML = `
            <div class="cart-item-product">
                <div class="cart-item-details">
                    <h4 class="cart-item-title">${item.nombre_cerveza}</h4>
                    <p class="cart-item-presentation">${item.nombre_presentacion}</p>
                    <p class="cart-item-event">Evento: ${eventoData.nombre_evento}</p>
                </div>
            </div>
            <div class="cart-item-price">$${Number(item.precio_unitario).toFixed(2)}</div>
            <div class="cart-item-quantity">
                <button class="quantity-btn decrease-btn" data-evento-id="${eventoData.id_evento}" data-cliente-id="${item.id_cliente_natural}" data-cerveza-id="${item.id_cerveza}" data-proveedor-id="${item.id_proveedor}" data-tipo-cerveza-id="${item.id_tipo_cerveza}" data-presentacion-id="${item.id_presentacion}">-</button>
                <input type="number" class="quantity-input" value="${item.cantidad}" min="1" data-evento-id="${eventoData.id_evento}" data-cliente-id="${item.id_cliente_natural}" data-cerveza-id="${item.id_cerveza}" data-proveedor-id="${item.id_proveedor}" data-tipo-cerveza-id="${item.id_tipo_cerveza}" data-presentacion-id="${item.id_presentacion}">
                <button class="quantity-btn increase-btn" data-evento-id="${eventoData.id_evento}" data-cliente-id="${item.id_cliente_natural}" data-cerveza-id="${item.id_cerveza}" data-proveedor-id="${item.id_proveedor}" data-tipo-cerveza-id="${item.id_tipo_cerveza}" data-presentacion-id="${item.id_presentacion}">+</button>
            </div>
            <div class="cart-item-total">$${Number(item.precio_unitario * item.cantidad).toFixed(2)}</div>
            <div class="cart-item-remove">
                <button class="remove-item-btn" data-evento-id="${eventoData.id_evento}" data-cliente-id="${item.id_cliente_natural}" data-cerveza-id="${item.id_cerveza}" data-proveedor-id="${item.id_proveedor}" data-tipo-cerveza-id="${item.id_tipo_cerveza}" data-presentacion-id="${item.id_presentacion}"><i class="fas fa-trash-alt"></i></button>
            </div>
        `;
        cartList.appendChild(itemElement);
    });
}

/**
 * Renderiza el resumen del carrito de eventos
 */
function renderEventoSummary(summary, eventoData) {
    const summaryBox = document.querySelector('.cart-summary');
    summaryBox.innerHTML = `
        <h3>Resumen del Pedido - Evento</h3>
        <div class="summary-item">
            <span>Evento</span>
            <span>${eventoData.nombre_evento}</span>
        </div>
        <div class="summary-item">
            <span>Total Items</span>
            <span>${summary.total_items || 0}</span>
        </div>
        <div class="summary-item total">
            <span>Total</span>
            <span>$${Number(summary.total || 0).toFixed(2)}</span>
        </div>
        <button class="checkout-btn" onclick="proceedToEventoCheckout()">Proceder al Pago</button>
        <a href="catalog.html" class="continue-shopping-btn">← Continuar Comprando</a>
    `;
}

// =================================================================
// MANEJO DE EVENTOS (DELEGACIÓN)
// =================================================================
function setupCartEventListeners() {
    document.body.addEventListener('click', event => {
        const target = event.target;
        console.log('Click detectado en:', target);
        console.log('Clases del elemento:', target.className);
        
        const removeBtn = target.closest('.remove-item-btn');
        const decreaseBtn = target.closest('.decrease-btn');
        const increaseBtn = target.closest('.increase-btn');
        const clearCartBtn = target.closest('.clear-cart-btn');
        const checkoutBtn = target.closest('.checkout-btn');

        console.log('checkoutBtn encontrado:', checkoutBtn);

        if (removeBtn) {
            const inventarioId = removeBtn.dataset.inventarioId;
            if(confirm('¿Seguro que quieres eliminar este producto?')) removeFromCart(inventarioId);
        } else if (decreaseBtn) {
            const input = decreaseBtn.nextElementSibling;
            const newQuantity = parseInt(input.value) - 1;
            if (newQuantity > 0) {
                updateQuantity(input.dataset.inventarioId, newQuantity);
            } else {
                if(confirm('¿Quieres eliminar este producto del carrito?')) removeFromCart(input.dataset.inventarioId);
            }
        } else if (increaseBtn) {
            const input = increaseBtn.previousElementSibling;
            updateQuantity(input.dataset.inventarioId, parseInt(input.value) + 1);
        } else if (clearCartBtn) {
            if(confirm('¿Estás seguro de que quieres vaciar el carrito?')) clearCart();
        } else if (checkoutBtn) {
            console.log('Redirigiendo al checkout...');
            // Redirigir al checkout
            proceedToCheckout();
        }
    });
}

// =================================================================
// FUNCIONES DE API DEL CARRITO
// =================================================================
async function apiCall(endpoint, method, body) {
    const options = {
        method,
        headers: { 'Content-Type': 'application/json' }
    };
    if (body) options.body = JSON.stringify(body);
    
    try {
        const response = await fetch(`${API_BASE_URL}${endpoint}`, options);
        const result = await response.json();
        if (!response.ok || !result.success) {
            throw new Error(result.message || 'Error en la operación');
        }
        showNotification(result.message, 'success');
        loadCart();
        updateCartCounter();
    } catch (error) {
        showNotification(error.message, 'error');
        console.error(`Error en ${method} ${endpoint}:`, error);
    }
}

function updateQuantity(inventarioId, nueva_cantidad) {
    const userId = getCurrentUserId();
    apiCall('/carrito/actualizar', 'PUT', { id_usuario: userId, id_inventario: inventarioId, nueva_cantidad });
}

function removeFromCart(inventarioId) {
    const userId = getCurrentUserId();
    apiCall('/carrito/eliminar', 'DELETE', { id_usuario: userId, id_inventario: inventarioId });
}

function clearCart() {
    apiCall(`/carrito/limpiar/${GUEST_USER_ID}`, 'DELETE');
}
