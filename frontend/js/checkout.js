// =================================================================
// CONFIGURACIÓN E INICIALIZACIÓN
// =================================================================
const GUEST_USER_ID = 1;

document.addEventListener('DOMContentLoaded', initCheckout);

function initCheckout() {
    // Solo ejecuta la lógica de la página del checkout si encuentra el contenedor principal.
    if (document.querySelector('.checkout-section')) {
        loadCheckoutData();
        setupCheckoutEventListeners();
    }
}

// =================================================================
// CARGA DE DATOS DEL CHECKOUT
// =================================================================
async function loadCheckoutData() {
    try {
        // Cargar resumen del carrito
        const summaryResponse = await fetch(`${API_BASE_URL}/carrito/resumen/${GUEST_USER_ID}`);
        if (!summaryResponse.ok) throw new Error('No se pudo cargar el resumen del carrito.');
        
        const summary = await summaryResponse.json();
        renderOrderSummary(summary);
        
        // Cargar items del carrito
        const itemsResponse = await fetch(`${API_BASE_URL}/carrito/usuario/${GUEST_USER_ID}`);
        if (!itemsResponse.ok) throw new Error('No se pudo cargar los items del carrito.');
        
        const items = await itemsResponse.json();
        renderOrderItems(items);
        
        // Actualizar contador del carrito
        updateCartCounter();
        
    } catch (error) {
        console.error('Error al cargar datos del checkout:', error);
        showNotification('Error al cargar los datos del checkout', 'error');
        // Redirigir al carrito si hay error
        setTimeout(() => {
            window.location.href = 'cart.html';
        }, 2000);
    }
}

// =================================================================
// RENDERIZADO DEL RESUMEN DE LA ORDEN
// =================================================================
function renderOrderSummary(summary) {
    const subtotalElement = document.getElementById('summary-subtotal');
    const totalElement = document.getElementById('summary-total');
    
    if (subtotalElement && totalElement) {
        const total = Number(summary.monto_total || 0);
        subtotalElement.textContent = `$${total.toFixed(2)}`;
        totalElement.textContent = `$${total.toFixed(2)}`;
    }
}

function renderOrderItems(items) {
    const summaryProducts = document.getElementById('summary-products');
    if (!summaryProducts) return;
    
    summaryProducts.innerHTML = '';
    
    if (items.length === 0) {
        summaryProducts.innerHTML = '<p class="no-items">No hay productos en el carrito</p>';
        return;
    }
    
    items.forEach(item => {
        const productElement = document.createElement('div');
        productElement.className = 'summary-product';
        productElement.innerHTML = `
            <div class="summary-product-info">
                <h3>${item.nombre_cerveza}</h3>
                <p>${item.nombre_presentacion}</p>
                <p>${item.cantidad} x $${Number(item.precio_unitario).toFixed(2)}</p>
            </div>
            <div class="summary-product-price">$${Number(item.subtotal).toFixed(2)}</div>
        `;
        summaryProducts.appendChild(productElement);
    });
}

// =================================================================
// MANEJO DE EVENTOS DEL CHECKOUT
// =================================================================
function setupCheckoutEventListeners() {
    // Event listeners para checkboxes de métodos de pago
    const paymentCheckboxes = document.querySelectorAll('.payment-checkbox');
    paymentCheckboxes.forEach(checkbox => {
        const paymentMethod = checkbox.closest('.payment-method');
        const amountInput = paymentMethod.querySelector('.amount-input');
        // Deshabilitar por defecto
        amountInput.disabled = true;
        checkbox.addEventListener('change', function(event) {
            if (checkbox.checked) {
                amountInput.disabled = false;
                amountInput.focus();
            } else {
                amountInput.disabled = true;
                amountInput.value = '';
            }
            updatePaymentSummary();
        });
    });
    
    // Event listeners para inputs de cantidad
    const amountInputs = document.querySelectorAll('.amount-input');
    amountInputs.forEach(input => {
        input.addEventListener('input', handleAmountChange);
    });
    
    // Event listener para términos y condiciones
    const termsCheckbox = document.getElementById('terms-checkout');
    if (termsCheckbox) {
        termsCheckbox.addEventListener('change', handleTermsChange);
    }
    
    // Event listener para botón de completar pago
    const placeOrderBtn = document.getElementById('place-order-btn');
    if (placeOrderBtn) {
        placeOrderBtn.addEventListener('click', handlePlaceOrder);
    }
}

function handleAmountChange() {
    updatePaymentSummary();
}

function handleTermsChange(event) {
    const placeOrderBtn = document.getElementById('place-order-btn');
    if (placeOrderBtn) {
        placeOrderBtn.disabled = !event.target.checked;
    }
}

// =================================================================
// CÁLCULO Y ACTUALIZACIÓN DEL RESUMEN DE PAGOS
// =================================================================
function updatePaymentSummary() {
    const totalToPay = getTotalToPay();
    const totalPaid = calculateTotalPaid();
    const remaining = totalToPay - totalPaid;
    
    // Actualizar totales por método
    updateMethodTotals();
    
    // Actualizar total pagado y restante
    document.getElementById('total-paid').textContent = `$${totalPaid.toFixed(2)}`;
    document.getElementById('amount-remaining').textContent = `$${remaining.toFixed(2)}`;
    
    // Actualizar estado del botón
    updatePlaceOrderButton(totalPaid, totalToPay);
}

function getTotalToPay() {
    const totalElement = document.getElementById('summary-total');
    if (totalElement) {
        const totalText = totalElement.textContent.replace('$', '');
        return Number(totalText) || 0;
    }
    return 0;
}

function calculateTotalPaid() {
    const amountInputs = document.querySelectorAll('.amount-input:not([disabled])');
    let total = 0;
    
    amountInputs.forEach(input => {
        const value = Number(input.value) || 0;
        total += value;
    });
    
    return total;
}

function updateMethodTotals() {
    const methods = ['credit', 'debit', 'cash', 'check', 'points'];
    
    methods.forEach(method => {
        const checkbox = document.getElementById(`payment-${method}`);
        const amountInput = checkbox?.closest('.payment-method')?.querySelector('.amount-input');
        const totalElement = document.getElementById(`${method}-total`);
        
        if (checkbox && amountInput && totalElement) {
            if (checkbox.checked && !amountInput.disabled) {
                const amount = Number(amountInput.value) || 0;
                totalElement.textContent = `$${amount.toFixed(2)}`;
            } else {
                totalElement.textContent = '$0.00';
            }
        }
    });
}

function updatePlaceOrderButton(totalPaid, totalToPay) {
    const placeOrderBtn = document.getElementById('place-order-btn');
    if (placeOrderBtn) {
        placeOrderBtn.disabled = !(totalPaid === totalToPay && totalToPay > 0);
    }
}

// =================================================================
// PROCESAMIENTO DEL PEDIDO
// =================================================================
async function handlePlaceOrder() {
    // Obtener compra_id (puede venir del backend o sessionStorage, aquí lo simulo)
    const compraId = await getCompraId();
    if (!compraId) {
        showNotification('No se pudo identificar la compra.', 'error');
        return;
    }
    // Recolectar métodos de pago seleccionados y sus montos
    const pagos = collectSelectedPayments();
    if (pagos.length === 0) {
        showNotification('Debe seleccionar al menos un método de pago con monto.', 'error');
        return;
    }
    try {
        const response = await fetch(`${API_BASE_URL}/carrito/pago`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ compra_id: compraId, pagos })
        });
        const data = await response.json();
        if (response.ok && data.success) {
            showNotification('¡Compra realizada exitosamente!', 'success');
            setTimeout(() => {
                window.location.href = 'tiempo-muerto.html';
            }, 2500);
        } else {
            showNotification(data.message || 'Error al registrar el pago', 'error');
        }
    } catch (error) {
        showNotification('Error de conexión al registrar el pago', 'error');
    }
}

function collectSelectedPayments() {
    // Mapear los métodos de pago a sus ids según la base de datos
    const metodoIds = {
        credit: 21, // Puedes ajustar según tu base
        debit: 31,
        cash: 1,
        check: 11,
        points: 41
    };
    const pagos = [];
    const methods = ['credit', 'debit', 'cash', 'check', 'points'];
    methods.forEach(method => {
        const checkbox = document.getElementById(`payment-${method}`);
        const amountInput = checkbox?.closest('.payment-method')?.querySelector('.amount-input');
        if (checkbox && checkbox.checked && amountInput && Number(amountInput.value) > 0) {
            pagos.push({
                metodo_id: metodoIds[method],
                monto: Number(amountInput.value),
                tipo: method
            });
        }
    });
    return pagos;
}

async function getCompraId() {
    // Aquí deberías obtener el id de la compra real del usuario
    // Por ahora, simulo con sessionStorage o un valor dummy
    // TODO: Integrar con el backend real
    return sessionStorage.getItem('compra_id') || 1;
} 