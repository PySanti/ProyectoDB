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
        checkbox.addEventListener('change', handlePaymentMethodChange);
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

function handlePaymentMethodChange(event) {
    const checkbox = event.target;
    const paymentMethod = checkbox.closest('.payment-method');
    const details = paymentMethod.querySelector('.payment-details');
    const amountInput = paymentMethod.querySelector('.amount-input');
    
    if (checkbox.checked) {
        details.style.display = 'block';
        amountInput.disabled = false;
        amountInput.focus();
    } else {
        details.style.display = 'none';
        amountInput.disabled = true;
        amountInput.value = '';
    }
    
    updatePaymentSummary();
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
    const methods = ['card', 'cash', 'check', 'points'];
    
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
    const termsCheckbox = document.getElementById('terms-checkout');
    
    if (placeOrderBtn) {
        const isComplete = totalPaid >= totalToPay && termsCheckbox?.checked;
        placeOrderBtn.disabled = !isComplete;
        
        if (totalPaid > totalToPay) {
            showNotification('El monto pagado excede el total. Se procesará como cambio.', 'info');
        }
    }
}

// =================================================================
// PROCESAMIENTO DEL PEDIDO
// =================================================================
async function handlePlaceOrder() {
    const placeOrderBtn = document.getElementById('place-order-btn');
    if (placeOrderBtn) {
        placeOrderBtn.disabled = true;
        placeOrderBtn.textContent = 'Procesando...';
    }
    
    try {
        // Recopilar datos de los métodos de pago
        const paymentData = collectPaymentData();
        
        // Validar datos
        if (!validatePaymentData(paymentData)) {
            throw new Error('Por favor, completa todos los campos requeridos');
        }
        
        // Aquí iría la llamada al backend para procesar el pago
        // Por ahora solo mostramos un mensaje de éxito
        showNotification('Pago procesado correctamente', 'success');
        
        // Redirigir a página de confirmación o limpiar carrito
        setTimeout(() => {
            window.location.href = 'home.html';
        }, 2000);
        
    } catch (error) {
        console.error('Error al procesar el pago:', error);
        showNotification(error.message, 'error');
        
        if (placeOrderBtn) {
            placeOrderBtn.disabled = false;
            placeOrderBtn.textContent = 'Completar Pago';
        }
    }
}

function collectPaymentData() {
    const paymentData = {
        methods: [],
        total: getTotalToPay()
    };
    
    const methods = ['card', 'cash', 'check', 'points'];
    
    methods.forEach(method => {
        const checkbox = document.getElementById(`payment-${method}`);
        const amountInput = checkbox?.closest('.payment-method')?.querySelector('.amount-input');
        
        if (checkbox?.checked && amountInput && !amountInput.disabled) {
            const amount = Number(amountInput.value) || 0;
            if (amount > 0) {
                const methodData = {
                    type: method,
                    amount: amount,
                    details: getMethodDetails(method)
                };
                paymentData.methods.push(methodData);
            }
        }
    });
    
    return paymentData;
}

function getMethodDetails(method) {
    const details = {};
    
    switch (method) {
        case 'card':
            details.cardNumber = document.getElementById('card-number')?.value || '';
            details.cardName = document.getElementById('card-name')?.value || '';
            details.cardExpiry = document.getElementById('card-expiry')?.value || '';
            details.cardCvv = document.getElementById('card-cvv')?.value || '';
            break;
        case 'cash':
            details.currency = document.getElementById('cash-currency')?.value || 'bs';
            break;
        case 'check':
            details.checkNumber = document.getElementById('check-number')?.value || '';
            details.bank = document.getElementById('check-bank')?.value || '';
            details.account = document.getElementById('check-account')?.value || '';
            break;
        case 'points':
            // Por ahora no implementado
            break;
    }
    
    return details;
}

function validatePaymentData(paymentData) {
    if (paymentData.methods.length === 0) {
        showNotification('Debes seleccionar al menos un método de pago', 'error');
        return false;
    }
    
    const totalPaid = paymentData.methods.reduce((sum, method) => sum + method.amount, 0);
    if (totalPaid < paymentData.total) {
        showNotification('El monto pagado debe ser igual o mayor al total', 'error');
        return false;
    }
    
    // Validar detalles específicos de cada método
    for (const method of paymentData.methods) {
        if (!validateMethodDetails(method)) {
            return false;
        }
    }
    
    return true;
}

function validateMethodDetails(method) {
    switch (method.type) {
        case 'card':
            if (!method.details.cardNumber || !method.details.cardName || 
                !method.details.cardExpiry || !method.details.cardCvv) {
                showNotification('Por favor, completa todos los campos de la tarjeta', 'error');
                return false;
            }
            break;
        case 'check':
            if (!method.details.checkNumber || !method.details.bank || !method.details.account) {
                showNotification('Por favor, completa todos los campos del cheque', 'error');
                return false;
            }
            break;
    }
    
    return true;
} 