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

// =================================================================
// RENDERIZADO DEL CARRITO
// =================================================================
async function loadCart() {
    try {
        const compraId = await ensureCompraId();
        if (!compraId) {
            renderEmptyCart();
            return;
        }
        const response = await fetch(`${API_BASE_URL}/carrito/resumen-por-id/${compraId}`);
        if (!response.ok) throw new Error('No se pudo cargar el carrito.');
        const resumen = await response.json();
        if (!resumen || resumen.estatus_nombre.toLowerCase() !== 'en proceso') {
            showNotification('El carrito ya fue pagado o cerrado. No se pueden realizar más operaciones.', 'info');
            renderEmptyCart();
            return;
        }
        if (!resumen.items_carrito || resumen.items_carrito.length === 0) {
            renderEmptyCart();
        } else {
            renderCartItems(resumen.items_carrito);
            renderSummary(resumen);
        }
    } catch (error) {
        console.error(error);
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

// Función directa para el checkout
async function proceedToCheckout() {
    console.log('Función proceedToCheckout llamada');
    
    try {
        const compraId = await ensureCompraId();
        if (!compraId) {
            showNotification('No hay carrito activo para este cliente.', 'error');
            return;
        }
        
        // Verificar que el carrito esté en proceso
        const resumen = await fetch(`${API_BASE_URL}/carrito/resumen-por-id/${compraId}`).then(r => r.json());
        if (!resumen || resumen.estatus_nombre.toLowerCase() !== 'en proceso') {
            showNotification('El carrito ya fue pagado o cerrado. No se puede proceder al pago.', 'error');
            return;
        }
        
        // Redirigir al checkout con el compra_id
        window.location.href = `checkout.html?compra_id=${compraId}`;
    } catch (error) {
        console.error('Error al proceder al checkout:', error);
        showNotification('Error de conexión al proceder al checkout', 'error');
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
    const compraId = sessionStorage.getItem('compra_id');
    if (!compraId) {
        showNotification('No hay carrito activo.', 'error');
        return;
    }
    apiCall('/carrito/actualizar-por-id', 'PUT', { compra_id: compraId, id_inventario: inventarioId, nueva_cantidad });
}

function removeFromCart(inventarioId) {
    const compraId = sessionStorage.getItem('compra_id');
    if (!compraId) {
        showNotification('No hay carrito activo.', 'error');
        return;
    }
    apiCall('/carrito/eliminar-por-id', 'DELETE', { compra_id: compraId, id_inventario: inventarioId });
}

function clearCart() {
    const compraId = sessionStorage.getItem('compra_id');
    if (!compraId) {
        showNotification('No hay carrito activo.', 'error');
        return;
    }
    apiCall(`/carrito/limpiar-por-id/${compraId}`, 'DELETE');
}

async function getCartResumen() {
    const compraId = await ensureCompraId();
    if (!compraId) {
        showNotification('No hay carrito activo para este cliente.', 'error');
        return null;
    }
    const response = await fetch(`${API_BASE_URL}/carrito/resumen-por-id/${compraId}`);
    if (!response.ok) {
        showNotification('No se pudo obtener el resumen del carrito.', 'error');
        return null;
    }
    const resumen = await response.json();
    if (!resumen || resumen.estatus_nombre.toLowerCase() !== 'en proceso') {
        showNotification('El carrito ya fue pagado o cerrado. No se pueden realizar más operaciones.', 'error');
        deshabilitarOperacionesCarrito();
        return null;
    }
    habilitarOperacionesCarrito();
    renderCartItems(resumen.items_carrito || []);
    return resumen;
}

function deshabilitarOperacionesCarrito() {
    document.querySelectorAll('.btn-cart-op').forEach(btn => btn.disabled = true);
}
function habilitarOperacionesCarrito() {
    document.querySelectorAll('.btn-cart-op').forEach(btn => btn.disabled = false);
}

// Todas las funciones de agregar, eliminar, actualizar, limpiar deben usar compraId actual
async function agregarAlCarrito(idInventario, cantidad) {
    const compraId = await ensureCompraId();
    if (!compraId) return;
    const resumen = await getCartResumen();
    if (!resumen) return;
    fetch(`${API_BASE_URL}/carrito/agregar-producto`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ compra_id: compraId, id_inventario: idInventario, cantidad })
    }).then(() => getCartResumen());
}

async function eliminarDelCarrito(idInventario) {
    const compraId = await ensureCompraId();
    if (!compraId) return;
    const resumen = await getCartResumen();
    if (!resumen) return;
    fetch(`${API_BASE_URL}/carrito/eliminar-producto`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ compra_id: compraId, id_inventario: idInventario })
    }).then(() => getCartResumen());
}

async function limpiarCarrito() {
    const compraId = await ensureCompraId();
    if (!compraId) return;
    const resumen = await getCartResumen();
    if (!resumen) return;
    fetch(`${API_BASE_URL}/carrito/limpiar`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ compra_id: compraId })
    }).then(() => getCartResumen());
}
