// =================================================================
// CONFIGURACIÓN E INICIALIZACIÓN
// =================================================================
const GUEST_USER_ID = 1;

document.addEventListener('DOMContentLoaded', () => {
    initCheckout();
    poblarSelectBancos();
    poblarSelectAnios();
});

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

function initCheckout() {
    // Solo ejecuta la lógica de la página del checkout si encuentra el contenedor principal.
    if (document.querySelector('.checkout-section')) {
        loadCheckoutData();
        // Los event listeners se configurarán después de cargar los datos según el tipo de venta
    }
}

// =================================================================
// CARGA DE DATOS DEL CHECKOUT
// =================================================================
async function loadCheckoutData() {
    try {
        console.log('=== INICIANDO CARGA DE DATOS DEL CHECKOUT ===');
        
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
            // Cargar datos del checkout de eventos
            await loadEventoCheckoutData(eventoData);
        } else {
            // Cargar datos del checkout regular (web/físico)
            await loadRegularCheckoutData();
        }
        
    } catch (error) {
        console.error('Error al cargar datos del checkout:', error);
        showNotification('Error al cargar los datos del checkout', 'error');
        // Redirigir al carrito si hay error
        setTimeout(() => {
            window.location.href = 'cart.html';
        }, 2000);
    }
}

/**
 * Carga datos del checkout de eventos
 */
async function loadEventoCheckoutData(eventoData) {
    try {
        console.log('Cargando checkout de eventos:', eventoData);
        
        // Obtener el cliente validado
        const currentClientStr = sessionStorage.getItem('currentClient');
        if (!currentClientStr) {
            throw new Error('Cliente no validado para evento');
        }

        const client = JSON.parse(currentClientStr);
        if (client.tipo !== 'natural') {
            throw new Error('Solo clientes naturales pueden comprar en eventos');
        }

        // Cargar resumen del carrito del evento
        const summaryResponse = await fetch(`${API_BASE_URL}/eventos/${eventoData.id_evento}/carrito/${client.id}`);
        if (!summaryResponse.ok) throw new Error('No se pudo cargar el resumen del carrito del evento.');
        
        const summary = await summaryResponse.json();
        console.log('Resumen del carrito del evento:', summary);
        renderEventoOrderSummary(summary, eventoData);
        
        // Cargar items del carrito del evento
        const itemsResponse = await fetch(`${API_BASE_URL}/eventos/${eventoData.id_evento}/carrito/${client.id}/items`);
        if (!itemsResponse.ok) throw new Error('No se pudo cargar los items del carrito del evento.');
        
        const items = await itemsResponse.json();
        console.log('Items del carrito del evento:', items);
        renderEventoOrderItems(items, eventoData);
        
        // Configurar métodos de pago para eventos (sin puntos)
        setupEventoPaymentMethods();
        
        // Configurar event listeners generales (términos, botón de pago, etc.)
        setupGeneralEventListeners();
        
        // Actualizar contador del carrito
        updateCartCounter();
        
    } catch (error) {
        console.error('Error al cargar datos del checkout de eventos:', error);
        showNotification('Error al cargar los datos del checkout del evento', 'error');
        setTimeout(() => {
            window.location.href = 'cart.html';
        }, 2000);
    }
}

/**
 * Carga datos del checkout regular (web/físico)
 */
async function loadRegularCheckoutData() {
    try {
        const userId = getCurrentUserId();
        console.log('Cargando checkout regular para usuario ID:', userId);
        
        // Verificar el tipo de venta
        const tipoVenta = getVentaType();
        console.log('Tipo de venta en loadCheckoutData:', tipoVenta);
        let currentClient = null;
        let clientParams = '';
        
        if (tipoVenta === 'tienda') {
            // Para compras físicas, necesitamos el cliente validado
            currentClient = getCurrentClient();
            if (currentClient) {
                clientParams = `?id_cliente_natural=${currentClient.id}`;
            }
        } else if (tipoVenta === 'web') {
            // Para compras web, no necesitamos cliente adicional
            console.log('Compra web - cargando datos sin cliente adicional');
        } else {
            console.warn('Tipo de venta no válido:', tipoVenta);
            // Intentar inferir el tipo de venta
            const user = localStorage.getItem('user');
            if (user) {
                console.log('Usuario autenticado detectado, asumiendo compra web');
            } else {
                console.log('No hay usuario autenticado, asumiendo compra física');
                currentClient = getCurrentClient();
                if (currentClient) {
                    clientParams = `?id_cliente_natural=${currentClient.id}`;
                }
            }
        }
        
        // Cargar resumen del carrito usando el usuario real
        const summaryResponse = await fetch(`${API_BASE_URL}/carrito/resumen/${userId}${clientParams}`);
        if (!summaryResponse.ok) throw new Error('No se pudo cargar el resumen del carrito.');
        
        const summary = await summaryResponse.json();
        console.log('Resumen del carrito:', summary);
        renderOrderSummary(summary);
        
        // Cargar items del carrito usando el usuario real
        const itemsResponse = await fetch(`${API_BASE_URL}/carrito/usuario/${userId}${clientParams}`);
        if (!itemsResponse.ok) throw new Error('No se pudo cargar los items del carrito.');
        
        const items = await itemsResponse.json();
        console.log('Items del carrito:', items);
        renderOrderItems(items);
        
        // Configurar event listeners para ventas regulares
        setupCheckoutEventListeners();
        
        // Actualizar contador del carrito
        updateCartCounter();
        
    } catch (error) {
        console.error('Error al cargar datos del checkout regular:', error);
        showNotification('Error al cargar los datos del checkout', 'error');
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

/**
 * Renderiza el resumen de la orden para eventos
 */
function renderEventoOrderSummary(summary, eventoData) {
    const subtotalElement = document.getElementById('summary-subtotal');
    const totalElement = document.getElementById('summary-total');
    
    if (subtotalElement && totalElement) {
        const total = Number(summary.total || 0);
        subtotalElement.textContent = `$${total.toFixed(2)}`;
        totalElement.textContent = `$${total.toFixed(2)}`;
    }
    
    // Actualizar título para mostrar que es evento
    const orderTitle = document.querySelector('.checkout-title h1');
    if (orderTitle) {
        orderTitle.textContent = `Checkout - ${eventoData.nombre_evento}`;
    }
}

/**
 * Renderiza los items de la orden para eventos
 */
function renderEventoOrderItems(items, eventoData) {
    const summaryProducts = document.getElementById('summary-products');
    if (!summaryProducts) return;
    
    summaryProducts.innerHTML = '';
    
    if (items.length === 0) {
        summaryProducts.innerHTML = '<p class="no-items">No hay productos en el carrito del evento</p>';
        return;
    }
    
    items.forEach(item => {
        const productElement = document.createElement('div');
        productElement.className = 'summary-product';
        productElement.innerHTML = `
            <div class="summary-product-info">
                <h3>${item.nombre_cerveza}</h3>
                <p>${item.nombre_presentacion}</p>
                <p>Evento: ${eventoData.nombre_evento}</p>
                <p>${item.cantidad} x $${Number(item.precio_unitario).toFixed(2)}</p>
            </div>
            <div class="summary-product-price">$${Number(item.precio_unitario * item.cantidad).toFixed(2)}</div>
        `;
        summaryProducts.appendChild(productElement);
    });
}

/**
 * Configura los métodos de pago para eventos (sin puntos)
 */
function setupEventoPaymentMethods() {
    console.log('Configurando métodos de pago para eventos...');
    
    // Ocultar el método de pago con puntos
    const puntosPaymentMethod = document.getElementById('new-points-method');
    if (puntosPaymentMethod) {
        puntosPaymentMethod.style.display = 'none';
        console.log('Método de puntos oculto');
    }
    
    // Asegurar que los métodos válidos estén visibles
    const validMethodIds = ['payment-credit', 'payment-debit', 'payment-cash', 'payment-check'];
    validMethodIds.forEach(methodId => {
        const checkbox = document.getElementById(methodId);
        if (checkbox) {
            const paymentMethod = checkbox.closest('.payment-method');
            if (paymentMethod) {
                paymentMethod.style.display = 'block';
                console.log(`Método ${methodId} visible`);
            }
        }
    });
    
    // Configurar event listeners específicos para eventos
    setupEventoPaymentEventListeners();
    
    console.log('Métodos de pago configurados para eventos (sin puntos)');
}

/**
 * Configura event listeners específicos para métodos de pago de eventos
 */
function setupEventoPaymentEventListeners() {
    // Event listeners para checkboxes de métodos de pago
    const paymentCheckboxes = document.querySelectorAll('.payment-checkbox');
    paymentCheckboxes.forEach(checkbox => {
        const paymentMethod = checkbox.closest('.payment-method');
        const amountInput = paymentMethod.querySelector('.amount-input');
        const details = paymentMethod.querySelector('.payment-details');
        
        // Deshabilitar por defecto
        if (amountInput) amountInput.disabled = true;
        if (details) details.classList.remove('active');
        
        checkbox.addEventListener('change', function(event) {
            console.log('Checkbox cambiado:', checkbox.id, 'checked:', checkbox.checked);
            
            if (checkbox.checked) {
                if (amountInput) {
                    amountInput.disabled = false;
                    amountInput.focus();
                }
                if (details) {
                    details.classList.add('active');
                    console.log('Detalles activados para:', checkbox.id);
                }
            } else {
                if (amountInput) {
                    amountInput.disabled = true;
                    amountInput.value = '';
                }
                if (details) {
                    details.classList.remove('active');
                    console.log('Detalles desactivados para:', checkbox.id);
                }
            }
            updatePaymentSummary();
        });
    });
    
    // Event listeners para inputs de cantidad
    const amountInputs = document.querySelectorAll('.amount-input');
    amountInputs.forEach(input => {
        input.addEventListener('input', handleAmountChange);
    });
    
    console.log('Event listeners configurados para métodos de pago de eventos');
}

/**
 * Configura event listeners generales (términos, botón de pago, etc.)
 */
function setupGeneralEventListeners() {
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
    
    console.log('Event listeners generales configurados');
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
        // Procesar pago de evento
        await handleEventoPlaceOrder(eventoData);
    } else {
        // Procesar pago regular (web/físico)
        await handleRegularPlaceOrder();
    }
}

/**
 * Procesa el pago de un evento
 */
async function handleEventoPlaceOrder(eventoData) {
    try {
        console.log('Procesando pago de evento:', eventoData);
        
        // Obtener el cliente validado
        const currentClientStr = sessionStorage.getItem('currentClient');
        if (!currentClientStr) {
            showNotification('Cliente no validado para evento.', 'error');
            return;
        }

        const client = JSON.parse(currentClientStr);
        if (client.tipo !== 'natural') {
            showNotification('Solo clientes naturales pueden comprar en eventos.', 'error');
            return;
        }

        const pagos = collectSelectedPayments();
        if (pagos.length === 0) {
            showNotification('Debe seleccionar al menos un método de pago con monto.', 'error');
            return;
        }

        // Verificar que el total pagado coincida con el total de la venta
        const totalToPay = getTotalToPay();
        const totalPaid = calculateTotalPaid();
        
        if (totalPaid !== totalToPay) {
            showNotification('El monto pagado debe ser igual al total de la venta.', 'error');
            return;
        }

        // Procesar el pago del evento
        const response = await fetch(`${API_BASE_URL}/eventos/${eventoData.id_evento}/procesar-pago`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                id_cliente_natural: client.id,
                pagos: pagos,
                total: totalToPay
            }),
        });

        const result = await response.json();

        if (result.success) {
            showNotification('Pago procesado correctamente', 'success');
            showPaymentSuccessCountdown();
            // Limpiar datos del evento
            sessionStorage.removeItem('eventoVenta');
            sessionStorage.removeItem('currentClient');
        } else {
            showNotification(result.message || 'Error al procesar el pago del evento', 'error');
        }
        
    } catch (error) {
        console.error('Error al procesar pago del evento:', error);
        showNotification('Error de conexión al procesar el pago del evento', 'error');
    }
}

/**
 * Procesa el pago regular (web/físico)
 */
async function handleRegularPlaceOrder() {
    const compraId = await getCompraId();
    if (!compraId) {
        showNotification('No se pudo identificar la compra.', 'error');
        return;
    }
    
    // Verificar el tipo de venta
    const tipoVenta = getVentaType();
    console.log('Tipo de venta detectado:', tipoVenta);
    let currentClient = null;
    
    if (tipoVenta === 'tienda') {
        // Para compras físicas, necesitamos un cliente validado
        currentClient = getCurrentClient();
        if (!currentClient) {
            showNotification('Debe validar un cliente antes de pagar.', 'error');
            return;
        }
    } else if (tipoVenta === 'web') {
        // Para compras web, el usuario ya está autenticado, no necesitamos cliente adicional
        console.log('Compra web - usuario autenticado:', getCurrentUserId());
    } else {
        // Si no hay tipo de venta establecido, intentar inferirlo
        console.log('Tipo de venta no detectado, intentando inferir...');
        const user = localStorage.getItem('user');
        if (user) {
            // Si hay usuario autenticado, asumir que es compra web
            console.log('Usuario autenticado detectado, asumiendo compra web');
        } else {
            // Si no hay usuario, asumir que es compra física
            console.log('No hay usuario autenticado, asumiendo compra física');
            currentClient = getCurrentClient();
            if (!currentClient) {
                showNotification('Debe validar un cliente antes de pagar.', 'error');
                return;
            }
        }
    }
    
    const pagos = collectSelectedPayments();
    if (pagos.length === 0) {
        showNotification('Debe seleccionar al menos un método de pago con monto.', 'error');
        return;
    }
    
    try {
        const requestBody = { 
            compra_id: compraId, 
            pagos, 
            id_usuario: getCurrentUserId()  // Usar el usuario real
        };
        
        // Solo incluir cliente si es compra física
        if (currentClient) {
            requestBody.cliente = currentClient;
        }
        
        const response = await fetch(`${API_BASE_URL}/carrito/pago`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(requestBody)
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
    const userId = getCurrentUserId();
    let params = `id_usuario=${userId}`;
    // Si hay cliente validado, agregarlo a la consulta
    const currentClient = getCurrentClient();
    if (currentClient) {
        params += `&id_cliente_natural=${currentClient.id}`;
    }
    const response = await fetch(`${API_BASE_URL}/carrito/compra-id?${params}`);
    const data = await response.json();
    return data.id_compra;
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
    // Usar el usuario real para asegurar consistencia
    return getCurrentUserId();
} 