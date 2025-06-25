// =================================================================
// CONFIGURACIÓN E INICIALIZACIÓN
// =================================================================
const GUEST_USER_ID = 1;

document.addEventListener('DOMContentLoaded', () => {
    initCheckout();
    poblarSelectBancos();
    poblarSelectAnios();
});

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
        console.log('=== INICIANDO CARGA DE DATOS DEL CHECKOUT ===');
        const compraId = await ensureCompraId();
        console.log('Compra ID obtenida:', compraId);
        
        if (!compraId) {
            throw new Error('No se pudo obtener el ID de la compra');
        }
        
        const currentClient = getCurrentClient();
        const clientParams = currentClient ? `?id_cliente_natural=${currentClient.id}` : '';
        
        // Cargar resumen del carrito usando la compra_id correcta
        const summaryResponse = await fetch(`${API_BASE_URL}/carrito/resumen/${compraId}${clientParams}`);
        if (!summaryResponse.ok) throw new Error('No se pudo cargar el resumen del carrito.');
        
        const summary = await summaryResponse.json();
        console.log('Resumen del carrito:', summary);
        renderOrderSummary(summary);
        
        // Cargar items del carrito usando la compra_id correcta
        const itemsResponse = await fetch(`${API_BASE_URL}/carrito/usuario/${compraId}${clientParams}`);
        if (!itemsResponse.ok) throw new Error('No se pudo cargar los items del carrito.');
        
        const items = await itemsResponse.json();
        console.log('Items del carrito:', items);
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
        const details = paymentMethod.querySelector('.payment-details');
        // Deshabilitar por defecto
        amountInput.disabled = true;
        if (details) details.classList.remove('active');
        checkbox.addEventListener('change', function(event) {
            if (checkbox.checked) {
                amountInput.disabled = false;
                amountInput.focus();
                if (details) details.classList.add('active');
            } else {
                amountInput.disabled = true;
                amountInput.value = '';
                if (details) details.classList.remove('active');
            }
            updatePaymentSummary();
        });
    });
    
    // Event listeners para inputs de cantidad
    const amountInputs = document.querySelectorAll('.amount-input');
    amountInputs.forEach(input => {
        input.addEventListener('input', handleAmountChange);
        // Validación especial para efectivo
        if (input.closest('.payment-method')?.querySelector('#cash-denomination')) {
            input.addEventListener('input', function() {
                const denominaciones = [1, 5, 10, 20, 50, 100, 200, 500, 1000];
                const value = Number(input.value);
                if (value > 0 && !esSumaDeDenominaciones(value, denominaciones)) {
                    input.setCustomValidity('El monto debe ser suma de denominaciones válidas.');
                } else {
                    input.setCustomValidity('');
                }
            });
        }
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
    
    // Event listener para cerrar modal al hacer clic fuera
    const successModal = document.getElementById('success-modal');
    if (successModal) {
        successModal.addEventListener('click', function(event) {
            if (event.target === successModal) {
                closeSuccessModal();
            }
        });
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
    const compraId = await getCompraId();
    if (!compraId) {
        showNotification('No se pudo identificar la compra.', 'error');
        return;
    }
    const currentClient = getCurrentClient();
    if (!currentClient) {
        showNotification('Debe validar un cliente antes de pagar.', 'error');
        return;
    }
    const pagos = collectSelectedPayments();
    if (pagos.length === 0) {
        showNotification('Debe seleccionar al menos un método de pago con monto.', 'error');
        return;
    }
    try {
        const response = await fetch(`${API_BASE_URL}/carrito/pago`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ compra_id: compraId, pagos, cliente: currentClient })
        });
        const data = await response.json();
        if (response.ok && data.success) {
            showPaymentSuccessCountdown();
        } else {
            showNotification(data.message || 'Error al registrar el pago', 'error');
        }
    } catch (error) {
        showNotification('Error de conexión al registrar el pago', 'error');
    }
}

function collectSelectedPayments() {
    const pagos = [];
    
    // Tarjeta de Crédito
    const creditCheckbox = document.getElementById('payment-credit');
    if (creditCheckbox && creditCheckbox.checked) {
        const amountInput = creditCheckbox.closest('.payment-method').querySelector('.amount-input');
        const amount = Number(amountInput.value) || 0;
        if (amount > 0) {
            const tipo = document.getElementById('credit-card-type').value;
            const numero = document.getElementById('credit-card-number').value;
            const banco = document.getElementById('credit-card-bank').value;
            const mes = document.getElementById('credit-card-expiry-month').value;
            const anio = document.getElementById('credit-card-expiry-year').value;
            const fecha_vencimiento = (anio && mes) ? `${anio}-${mes}-01` : '';
            if (!tipo || !numero || !banco || !mes || !anio) {
                showNotification('Por favor complete todos los campos de la tarjeta de crédito', 'error');
                return [];
            }
            pagos.push({
                tipo: 'tarjeta_credito',
                monto: amount,
                tipo_tarjeta: tipo,
                numero: numero,
                banco: banco,
                fecha_vencimiento: fecha_vencimiento
            });
        }
    }
    
    // Tarjeta de Débito
    const debitCheckbox = document.getElementById('payment-debit');
    if (debitCheckbox && debitCheckbox.checked) {
        const amountInput = debitCheckbox.closest('.payment-method').querySelector('.amount-input');
        const amount = Number(amountInput.value) || 0;
        if (amount > 0) {
            const numero = document.getElementById('debit-card-number').value;
            const banco = document.getElementById('debit-card-bank').value;
            const mes = document.getElementById('debit-card-expiry-month').value;
            const anio = document.getElementById('debit-card-expiry-year').value;
            const fecha_vencimiento = (anio && mes) ? `${anio}-${mes}-01` : '';
            if (!numero || !banco || !mes || !anio) {
                showNotification('Por favor complete todos los campos de la tarjeta de débito', 'error');
                return [];
            }
            pagos.push({
                tipo: 'tarjeta_debito',
                monto: amount,
                numero: numero,
                banco: banco,
                fecha_vencimiento: fecha_vencimiento
            });
        }
    }
    
    // Efectivo
    const cashCheckbox = document.getElementById('payment-cash');
    if (cashCheckbox && cashCheckbox.checked) {
        const amountInput = cashCheckbox.closest('.payment-method').querySelector('.amount-input');
        const amount = Number(amountInput.value) || 0;
        if (amount > 0) {
            const denominacion = document.getElementById('cash-denomination').value;
            
            if (!denominacion) {
                showNotification('Por favor seleccione la denominación del efectivo', 'error');
                return [];
            }
            
            pagos.push({
                tipo: 'efectivo',
                monto: amount,
                denominacion: Number(denominacion)
            });
        }
    }
    
    // Cheque
    const checkCheckbox = document.getElementById('payment-check');
    if (checkCheckbox && checkCheckbox.checked) {
        const amountInput = checkCheckbox.closest('.payment-method').querySelector('.amount-input');
        const amount = Number(amountInput.value) || 0;
        if (amount > 0) {
            const num_cheque = document.getElementById('check-number').value;
            const banco = document.getElementById('check-bank').value;
            const num_cuenta = document.getElementById('check-account').value;
            
            if (!num_cheque || !banco || !num_cuenta) {
                showNotification('Por favor complete todos los campos del cheque', 'error');
                return [];
            }
            
            pagos.push({
                tipo: 'cheque',
                monto: amount,
                num_cheque: Number(num_cheque),
                banco: banco,
                num_cuenta: Number(num_cuenta)
            });
        }
    }
    
    return pagos;
}

async function getCompraId() {
    // Aquí deberías obtener el id de la compra real del usuario
    // Por ahora, simulo con sessionStorage o un valor dummy
    // TODO: Integrar con el backend real
    return sessionStorage.getItem('compra_id') || 1;
}

function showPaymentSuccessCountdown() {
    let seconds = 3;
    showNotification(`Pago realizado exitosamente, volviendo al inicio en: ${seconds}...`, 'success');
    const interval = setInterval(() => {
        seconds--;
        if (seconds > 0) {
            showNotification(`Pago realizado exitosamente, volviendo al inicio en: ${seconds}...`, 'success');
        } else {
            clearInterval(interval);
            window.location.href = 'tiempo-muerto.html';
        }
    }, 1000);
}

async function clearCart() {
    try {
        await fetch(`${API_BASE_URL}/carrito/limpiar/${GUEST_USER_ID}`, {
            method: 'DELETE'
        });
        // Actualizar contador del carrito
        updateCartCounter();
    } catch (error) {
        console.error('Error al limpiar el carrito:', error);
    }
}

function poblarSelectBancos() {
    const bancos = [
        'Banco de Venezuela',
        'Banesco',
        'Banco Mercantil',
        'BBVA Provincial',
        'Banco Nacional de Crédito (BNC)',
        'Banco del Tesoro',
        'Bancaribe',
        'Banco Exterior',
        'Banco Plaza',
        'Banco Caroní',
        'Banco Fondo Común (BFC)',
        'Banco Sofitasa',
        'Banplus',
        'Bancamiga',
        'DELSUR Banco Universal',
        '100% Banco',
        'Banco Activo',
        'Mi Banco',
        'Venezolano de Crédito'
    ];
    ['credit-card-bank', 'debit-card-bank', 'check-bank'].forEach(id => {
        const select = document.getElementById(id);
        if (select) {
            select.innerHTML = '<option value="">Seleccione un banco</option>' + bancos.map(b => `<option value="${b}">${b}</option>`).join('');
        }
    });
}

function poblarSelectAnios() {
    const anioActual = new Date().getFullYear();
    const anios = Array.from({length: 15}, (_, i) => anioActual + i);
    ['credit-card-expiry-year', 'debit-card-expiry-year'].forEach(id => {
        const select = document.getElementById(id);
        if (select) {
            select.innerHTML = '<option value="">Año</option>' + anios.map(a => `<option value="${a}">${a}</option>`).join('');
        }
    });
}

function getCurrentClient() {
    const clientStr = sessionStorage.getItem('currentClient');
    if (!clientStr) return null;
    try {
        return JSON.parse(clientStr);
    } catch {
        return null;
    }
}

function esSumaDeDenominaciones(monto, denominaciones) {
    monto = Math.round(monto * 100);
    denominaciones = denominaciones.map(d => Math.round(d * 100));
    denominaciones.sort((a, b) => b - a);
    for (let i = 0; i < denominaciones.length; i++) {
        while (monto >= denominaciones[i]) {
            monto -= denominaciones[i];
        }
    }
    return monto === 0;
}

async function ensureCompraId() {
    let compraId = sessionStorage.getItem('compra_id');
    const currentClient = getCurrentClient();
    
    if (!compraId && currentClient) {
        // Para compra en tienda física, NO usar id_usuario, solo el cliente
        const requestBody = {
            id_usuario: null,  // Para tienda física, usuario debe ser NULL
            cliente: currentClient  // El cliente ya tiene el ID correcto
        };
        
        console.log('Creando compra con:', requestBody);
        
        // Llama al backend para crear o asociar la compra con el cliente
        const response = await fetch(`${API_BASE_URL}/carrito/create-or-get`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(requestBody)
        });
        
        const data = await response.json();
        if (data.success && data.id_compra) {
            compraId = data.id_compra;
            sessionStorage.setItem('compra_id', compraId);
            console.log('Compra creada con ID:', compraId);
        } else {
            console.error('Error al crear compra:', data);
        }
    }
    return compraId;
} 