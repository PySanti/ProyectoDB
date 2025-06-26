// =================================================================
// CONFIGURACIÓN E INICIALIZACIÓN
// =================================================================
const GUEST_USER_ID = 1;
const TASA_BS = 100;

document.addEventListener('DOMContentLoaded', () => {
    initCheckout();
    poblarSelectBancos();
    poblarSelectAnios();
    setupTestClient(); // Configurar cliente de prueba
});

function initCheckout() {
    // Solo ejecuta la lógica de la página del checkout si encuentra el contenedor principal.
    if (document.querySelector('.checkout-section')) {
        loadCheckoutData();
        setupCheckoutEventListeners();
        loadPointsData(); // Cargar datos de puntos
    }
}

// =================================================================
// SISTEMA DE PUNTOS
// =================================================================

// Cargar datos de puntos del cliente
async function loadPointsData() {
    try {
        const currentClient = getCurrentClient();
        const pointsMethod = document.getElementById('points-payment-method');
        const pointsCheckbox = document.getElementById('payment-points');

        // Mostrar la sección de puntos siempre para pruebas
        if (pointsMethod) {
            pointsMethod.style.display = 'block';
            pointsMethod.classList.remove('disabled');
        }
        if (pointsCheckbox) {
            pointsCheckbox.disabled = false;
        }

        if (!currentClient || currentClient.tipo !== 'natural') {
            // Datos de prueba
            updatePointsDisplay({
                saldo_actual: 150,
                puntos_ganados: 200,
                puntos_gastados: 50,
                valor_punto: 1.0,
                minimo_canje: 50,
                tasa_actual: 1.0
            });
            return;
        }

        // Intenta fetch real
        const response = await fetch(`${API_BASE_URL}/puntos/info/${currentClient.id}`);
        if (response.ok) {
            const data = await response.json();
            if (data.success) {
                updatePointsDisplay(data.data);
                return;
            }
        }
        // Si falla el fetch o no hay success, usar datos de prueba
        updatePointsDisplay({
            saldo_actual: 150,
            puntos_ganados: 200,
            puntos_gastados: 50,
            valor_punto: 1.0,
            minimo_canje: 50,
            tasa_actual: 1.0
        });
    } catch (error) {
        // Siempre mostrar datos de prueba si hay error
        updatePointsDisplay({
            saldo_actual: 150,
            puntos_ganados: 200,
            puntos_gastados: 50,
            valor_punto: 1.0,
            minimo_canje: 50,
            tasa_actual: 1.0
        });
    }
}

// Actualizar display de puntos
function updatePointsDisplay(pointsData) {
    console.log('Actualizando display de puntos con datos:', pointsData);
    
    const pointsAvailable = document.getElementById('points-available');
    const pointsValue = document.getElementById('points-value');
    const pointsMinimum = document.getElementById('points-minimum');
    const pointsCheckbox = document.getElementById('payment-points');
    const pointsMethod = document.getElementById('points-payment-method');

    console.log('Elementos encontrados:', {
        pointsAvailable: !!pointsAvailable,
        pointsValue: !!pointsValue,
        pointsMinimum: !!pointsMinimum,
        pointsCheckbox: !!pointsCheckbox,
        pointsMethod: !!pointsMethod
    });

    // Actualizar valores
    if (pointsAvailable) {
        pointsAvailable.textContent = pointsData.saldo_actual;
        console.log('Puntos disponibles actualizados:', pointsData.saldo_actual);
    }
    if (pointsValue) {
        pointsValue.textContent = pointsData.valor_punto.toFixed(2);
        console.log('Valor por punto actualizado:', pointsData.valor_punto.toFixed(2));
    }
    if (pointsMinimum) {
        pointsMinimum.textContent = pointsData.minimo_canje;
        console.log('Mínimo para canje actualizado:', pointsData.minimo_canje);
    }

    // Habilitar/deshabilitar sección de puntos según saldo
    if (pointsData.saldo_actual >= pointsData.minimo_canje) {
        console.log('Habilitando sección de puntos - saldo suficiente');
        if (pointsMethod) {
            pointsMethod.classList.remove('disabled');
            pointsMethod.style.display = 'block';
        }
        if (pointsCheckbox) {
            pointsCheckbox.disabled = false;
            console.log('Checkbox de puntos habilitado');
        }
    } else {
        console.log('Deshabilitando sección de puntos - saldo insuficiente');
        if (pointsMethod) {
            pointsMethod.classList.add('disabled');
        }
        if (pointsCheckbox) {
            pointsCheckbox.disabled = true;
        }
    }
}

// Actualizar configuración de puntos
function updatePointsConfiguration(config) {
    const pointsValue = document.getElementById('points-value');
    const pointsMinimum = document.getElementById('points-minimum');

    if (pointsValue) pointsValue.textContent = config.valor_punto.toFixed(2);
    if (pointsMinimum) pointsMinimum.textContent = config.minimo_canje;
}

// Manejar cambios en puntos a usar
function handlePointsChange() {
    const pointsToUse = document.getElementById('points-to-use');
    const pointsEquivalent = document.getElementById('points-equivalent');
    const pointsValue = document.getElementById('points-value');
    const pointsAvailable = document.getElementById('points-available');
    const pointsError = document.getElementById('points-error');
    const amountInput = document.querySelector('#payment-points').closest('.payment-method').querySelector('.amount-input');

    if (!pointsToUse || !pointsEquivalent || !pointsValue || !pointsAvailable) return;

    const points = parseInt(pointsToUse.value) || 0;
    const valuePerPoint = parseFloat(pointsValue.textContent);
    const available = parseInt(pointsAvailable.textContent);
    const equivalent = points * valuePerPoint;

    // Validar puntos
    let errorMessage = '';
    if (points > available) {
        errorMessage = 'No tienes suficientes puntos disponibles';
    } else if (points < 0) {
        errorMessage = 'Los puntos no pueden ser negativos';
    }

    // Mostrar error si existe
    if (errorMessage) {
        pointsError.textContent = errorMessage;
        pointsError.style.display = 'block';
        pointsToUse.classList.add('error');
    } else {
        pointsError.style.display = 'none';
        pointsToUse.classList.remove('error');
    }

    // Actualizar equivalentes
    pointsEquivalent.textContent = equivalent.toFixed(2);
    if (amountInput) {
        amountInput.value = equivalent.toFixed(2);
    }

    updatePaymentSummary();
}

// Usar máximo de puntos disponibles
function useMaxPoints() {
    const pointsToUse = document.getElementById('points-to-use');
    const pointsAvailable = document.getElementById('points-available');
    const totalToPay = getTotalToPay();

    if (!pointsToUse || !pointsAvailable) return;

    const available = parseInt(pointsAvailable.textContent);
    const pointsValue = parseFloat(document.getElementById('points-value').textContent);
    const maxPointsForTotal = Math.floor(totalToPay / pointsValue);

    // Usar el mínimo entre puntos disponibles y puntos necesarios para el total
    const pointsToUseValue = Math.min(available, maxPointsForTotal);
    
    pointsToUse.value = pointsToUseValue;
    handlePointsChange();
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
        
        // Llamar updatePaymentSummary después de renderOrderSummary
        updatePaymentSummary();
        
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
        // Guardar el total del carrito en una variable global solo si es válido
        if (total > 0) {
            window.CARRITO_TOTAL = total;
            console.log('[CARRITO] Total seteado correctamente:', total);
        } else {
            console.warn('[CARRITO] Total recibido es 0, se intentará refrescar después de cargar productos.');
        }
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
    // Si el total sigue en 0 pero hay productos, forzar refresco del resumen
    if ((typeof window.CARRITO_TOTAL !== 'number' || window.CARRITO_TOTAL === 0) && items.length > 0) {
        // Sumar subtotales de los items
        let total = 0;
        items.forEach(item => {
            total += Number(item.subtotal) || 0;
        });
        window.CARRITO_TOTAL = total;
        document.getElementById('summary-total').textContent = `$${total.toFixed(2)}`;
        document.getElementById('summary-subtotal').textContent = `$${total.toFixed(2)}`;
        console.log('[CARRITO] Total corregido tras cargar productos:', total);
        updatePaymentSummary();
    }
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
        if (amountInput) {
            amountInput.disabled = true;
            amountInput.value = '';
        }
        if (details) details.classList.remove('active');
        
        checkbox.addEventListener('change', function(event) {
            if (checkbox.checked) {
                if (amountInput) {
                    amountInput.disabled = false;
                    amountInput.focus();
                }
                if (details) details.classList.add('active');
            } else {
                if (amountInput) {
                    amountInput.disabled = true;
                    amountInput.value = '';
                    // NUEVO: poner el monto en 0 si se deselecciona
                    amountInput.value = '0.00';
                }
                if (details) details.classList.remove('active');
            }
            updatePaymentSummary();
        });
    });
    
    // Event listeners para inputs de cantidad (excepto efectivo)
    const amountInputs = document.querySelectorAll('.amount-input');
    amountInputs.forEach(input => {
        input.addEventListener('input', handleAmountChange);
    });
    
    // Event listeners para billetes de efectivo
    const billInputs = document.querySelectorAll('.bill-quantity');
    billInputs.forEach(input => {
        input.addEventListener('input', handleCashBillsChange);
    });
    
    // Event listeners para puntos
    const pointsToUse = document.getElementById('points-to-use');
    const useMaxPointsBtn = document.getElementById('use-max-points');
    
    if (pointsToUse) {
        pointsToUse.addEventListener('input', handlePointsChange);
    }
    
    if (useMaxPointsBtn) {
        useMaxPointsBtn.addEventListener('click', useMaxPoints);
    }
    
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

    // NUEVO: para la nueva sección de puntos
    const newPointsCheckbox = document.getElementById('new-payment-points');
    const newPointsAmount = document.getElementById('new-points-amount');
    if (newPointsCheckbox && newPointsAmount) {
        newPointsCheckbox.addEventListener('change', function() {
            if (!newPointsCheckbox.checked) {
                newPointsAmount.value = '0.00';
            }
            updatePaymentSummary();
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

/**
 * Maneja los cambios en los billetes de efectivo
 */
function handleCashBillsChange() {
    const cashTotal = calculateCashTotal();
    
    // Actualizar el display del total en efectivo
    const cashTotalDisplay = document.querySelector('.cash-total-display');
    const cashTotalAmount = document.getElementById('cash-total-amount');
    
    if (cashTotalDisplay) {
        cashTotalDisplay.textContent = `$${cashTotal.toFixed(2)}`;
    }
    if (cashTotalAmount) {
        cashTotalAmount.textContent = `$${cashTotal.toFixed(2)}`;
    }
    
    updatePaymentSummary();
}

/**
 * Calcula el total en efectivo basado en los billetes seleccionados
 */
function calculateCashTotal() {
    const selects = document.querySelectorAll('.cash-bill-select');
    let total = 0;
    selects.forEach(sel => {
        const val = parseInt(sel.value);
        if (!isNaN(val)) total += val;
    });
    return total;
}

// =================================================================
// CÁLCULO Y ACTUALIZACIÓN DEL RESUMEN DE PAGOS
// =================================================================
function updatePaymentSummary() {
    // Solo delegar la actualización a updateMethodTotals (que a su vez llama a updateTotalsSummary)
    updateMethodTotals();
    // Ya no actualizar aquí los campos de total-paid ni amount-remaining
    // La lógica completa está en updateTotalsSummary
}

function getTotalToPay() {
    // Usar siempre el valor guardado del carrito
    return typeof window.CARRITO_TOTAL === 'number' ? window.CARRITO_TOTAL : 0;
}

function calculateTotalPaid() {
    let total = 0;
    // Calcular total de otros métodos de pago (tarjetas, cheque, etc.)
    const amountInputs = document.querySelectorAll('.amount-input:not([disabled])');
    amountInputs.forEach(input => {
        let value = Number(input.value) || 0;
        // Buscar el select de moneda asociado a este input
        const currencySelect = input.closest('.payment-method-header')?.querySelector('.currency-select');
        let currency = currencySelect ? currencySelect.value : 'USD';
        if (currency === 'BS') {
            value = value / TASA_BS;
        }
        total += value;
    });
    // Calcular total de efectivo basado en billetes
    const cashCheckbox = document.getElementById('payment-cash');
    if (cashCheckbox && cashCheckbox.checked) {
        total += calculateCashTotal();
    }
    // NUEVO: sumar puntos si está seleccionada la nueva sección
    const newPointsCheckbox = document.getElementById('new-payment-points');
    if (newPointsCheckbox && newPointsCheckbox.checked) {
        const amountInput = document.getElementById('new-points-amount');
        if (amountInput && !amountInput.disabled) {
            total += Number(amountInput.value) || 0;
        }
    }
    return total;
}

function updateMethodTotals() {
    // Métodos de pago con moneda
    const methods = [
        { id: 'credit', currencyId: 'credit-currency' },
        { id: 'debit', currencyId: 'debit-currency' },
        { id: 'check', currencyId: 'check-currency' }
    ];
    methods.forEach(method => {
        const checkbox = document.getElementById(`payment-${method.id}`);
        const totalElement = document.getElementById(`${method.id}-total`);
        const currencySelect = document.getElementById(method.currencyId);
        if (checkbox && totalElement) {
            if (checkbox.checked) {
                const amountInput = checkbox.closest('.payment-method')?.querySelector('.amount-input');
                let amount = 0;
                let currency = 'USD';
                if (amountInput && !amountInput.disabled) {
                    currency = currencySelect ? currencySelect.value : 'USD';
                    amount = parseFloat(amountInput.value) || 0;
                }
                totalElement.textContent = getCurrencyDisplay(amount, currency);
            } else {
                totalElement.textContent = '$0.00 | Bs 0,00';
            }
        }
    });
    // Efectivo (si quieres agregar Bs, puedes hacerlo aquí)
    const cashCheckbox = document.getElementById('payment-cash');
    const cashTotal = document.getElementById('cash-total');
    if (cashCheckbox && cashTotal) {
        if (cashCheckbox.checked) {
            const amount = calculateCashTotal();
            cashTotal.textContent = getCurrencyDisplay(amount, 'USD');
        } else {
            cashTotal.textContent = '$0.00 | Bs 0,00';
        }
    }
    // Puntos
    const pointsCheckbox = document.getElementById('new-payment-points');
    const pointsTotal = document.getElementById('points-total');
    if (pointsCheckbox && pointsTotal) {
        if (pointsCheckbox.checked) {
            const amountInput = document.getElementById('new-points-amount');
            let amount = 0;
            if (amountInput && !amountInput.disabled) {
                amount = parseFloat(amountInput.value) || 0;
            }
            pointsTotal.textContent = getCurrencyDisplay(amount, 'USD');
        } else {
            pointsTotal.textContent = '$0.00 | Bs 0,00';
        }
    }
    updateTotalsSummary();
}

function updateTotalsSummary() {
    // Sumar todos los pagos en $ y Bs
    let totalUSD = 0;
    let totalBS = 0;
    // Métodos de pago con moneda
    const methods = [
        { id: 'credit', currencyId: 'credit-currency' },
        { id: 'debit', currencyId: 'debit-currency' },
        { id: 'check', currencyId: 'check-currency' }
    ];
    methods.forEach(method => {
        const checkbox = document.getElementById(`payment-${method.id}`);
        const currencySelect = document.getElementById(method.currencyId);
        if (checkbox && checkbox.checked) {
            const amountInput = checkbox.closest('.payment-method')?.querySelector('.amount-input');
            let amount = 0;
            let currency = 'USD';
            if (amountInput && !amountInput.disabled) {
                currency = currencySelect ? currencySelect.value : 'USD';
                amount = parseFloat(amountInput.value) || 0;
            }
            if (currency === 'BS') {
                totalUSD += amount / TASA_BS;
                totalBS += amount;
            } else {
                totalUSD += amount;
                totalBS += amount * TASA_BS;
            }
        }
    });
    // Efectivo
    const cashCheckbox = document.getElementById('payment-cash');
    if (cashCheckbox && cashCheckbox.checked) {
        const amount = calculateCashTotal();
        totalUSD += amount;
        totalBS += amount * TASA_BS;
    }
    // Puntos
    const pointsCheckbox = document.getElementById('new-payment-points');
    if (pointsCheckbox && pointsCheckbox.checked) {
        const amountInput = document.getElementById('new-points-amount');
        let amount = 0;
        if (amountInput && !amountInput.disabled) {
            amount = parseFloat(amountInput.value) || 0;
        }
        totalUSD += amount;
        totalBS += amount * TASA_BS;
    }
    // Usar el total del carrito guardado
    const totalToPay = getTotalToPay();
    document.getElementById('summary-total').textContent = `$${totalToPay.toFixed(2)} | Bs ${(totalToPay * TASA_BS).toLocaleString('es-VE', {minimumFractionDigits: 2, maximumFractionDigits: 2})}`;
    document.getElementById('total-paid').textContent = `$${totalUSD.toFixed(2)} | Bs ${totalBS.toLocaleString('es-VE', {minimumFractionDigits: 2, maximumFractionDigits: 2})}`;
    document.getElementById('amount-remaining').textContent = `$${(totalToPay - totalUSD).toFixed(2)} | Bs ${(totalToPay * TASA_BS - totalBS).toLocaleString('es-VE', {minimumFractionDigits: 2, maximumFractionDigits: 2})}`;
    // NUEVO: actualizar el total a pagar en el resumen de pagos
    const summaryTotalPayment = document.getElementById('summary-total-payment');
    if (summaryTotalPayment) {
        summaryTotalPayment.textContent = `$${totalToPay.toFixed(2)} | Bs ${(totalToPay * TASA_BS).toLocaleString('es-VE', {minimumFractionDigits: 2, maximumFractionDigits: 2})}`;
    }
}

function updatePlaceOrderButton(totalPaid, totalToPay) {
    const placeOrderBtn = document.getElementById('place-order-btn');
    const errorMsg = document.getElementById('payment-mismatch-error');
    if (placeOrderBtn) {
        if (totalPaid === totalToPay && totalToPay > 0) {
            placeOrderBtn.disabled = false;
            if (errorMsg) errorMsg.style.display = 'none';
        } else {
            placeOrderBtn.disabled = true;
            if (errorMsg) errorMsg.style.display = 'block';
        }
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
    const pagos = await collectSelectedPayments();
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

async function collectSelectedPayments() {
    const pagos = [];
    // Tarjeta de Crédito
    const creditCheckbox = document.getElementById('payment-credit');
    if (creditCheckbox && creditCheckbox.checked) {
        const amountInput = creditCheckbox.closest('.payment-method').querySelector('.amount-input');
        const currencySelect = document.getElementById('credit-currency');
        let amount = Number(amountInput.value) || 0;
        let currency = currencySelect ? currencySelect.value : 'USD';
        if (currency === 'BS') {
            amount = amount / TASA_BS;
        }
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
        const currencySelect = document.getElementById('debit-currency');
        let amount = Number(amountInput.value) || 0;
        let currency = currencySelect ? currencySelect.value : 'USD';
        if (currency === 'BS') {
            amount = amount / TASA_BS;
        }
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
    // Efectivo (nuevo)
    const cashCheckbox = document.getElementById('payment-cash');
    if (cashCheckbox && cashCheckbox.checked) {
        const selects = document.querySelectorAll('.cash-bill-select');
        let hasBills = false;
        selects.forEach(sel => {
            const val = parseInt(sel.value);
            if (!isNaN(val)) {
                hasBills = true;
                pagos.push({
                    tipo: 'efectivo',
                    monto: val,
                    denominacion: val
                });
            }
        });
        if (!hasBills) {
            showNotification('Por favor seleccione al menos un billete para el pago en efectivo', 'error');
            return [];
        }
    }
    // Cheque
    const checkCheckbox = document.getElementById('payment-check');
    if (checkCheckbox && checkCheckbox.checked) {
        const amountInput = checkCheckbox.closest('.payment-method').querySelector('.amount-input');
        const currencySelect = document.getElementById('check-currency');
        let amount = Number(amountInput.value) || 0;
        let currency = currencySelect ? currencySelect.value : 'USD';
        if (currency === 'BS') {
            amount = amount / TASA_BS;
        }
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
    // Puntos (nueva sección)
    const newPointsCheckbox = document.getElementById('new-payment-points');
    if (newPointsCheckbox && newPointsCheckbox.checked) {
        const pointsToUse = document.getElementById('new-points-to-use');
        const points = parseInt(pointsToUse.value) || 0;
        if (points > 0) {
            const currentClient = getCurrentClient();
            if (!currentClient || currentClient.tipo !== 'natural') {
                showNotification('Solo los clientes naturales pueden usar puntos', 'error');
                return [];
            }
            // Validar puntos antes de enviar
            try {
                const validationResponse = await fetch(`${API_BASE_URL}/puntos/validar`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        id_cliente_natural: currentClient.id,
                        puntos_a_usar: points
                    })
                });
                const validationData = await validationResponse.json();
                if (!validationData.success || !validationData.puede_usar) {
                    showNotification(validationData.message || 'No puede usar los puntos especificados', 'error');
                    return [];
                }
            } catch (error) {
                console.error('Error al validar puntos:', error);
                showNotification('Error al validar puntos', 'error');
                return [];
            }
            pagos.push({
                tipo: 'puntos',
                monto: points * parseFloat(document.getElementById('new-points-value').textContent),
                puntos_usados: points
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
    // Actualizar el contador del carrito inmediatamente después del pago exitoso
    updateCartCounter();
    let seconds = 2;
    showNotification(`Pago realizado exitosamente, generando factura en: ${seconds}...`, 'success');
    const compraId = sessionStorage.getItem('compra_id');
    const interval = setInterval(() => {
        seconds--;
        if (seconds > 0) {
            showNotification(`Pago realizado exitosamente, generando factura en: ${seconds}...`, 'success');
        } else {
            clearInterval(interval);
            if (compraId) {
                window.location.href = `factura.html?compra_id=${compraId}`;
            } else {
                window.location.href = 'factura.html';
            }
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

// ===================== NUEVO: EFECTIVO DINÁMICO =====================

const CASH_DENOMINATIONS = [1, 5, 10, 20, 50, 100, 200, 500, 1000];

function renderCashBillSelectors() {
    const numBills = Math.max(1, Math.min(5, parseInt(document.getElementById('num-cash-bills').value) || 1));
    const container = document.getElementById('cash-bills-selectors');
    container.innerHTML = '';
    for (let i = 0; i < numBills; i++) {
        const selectorDiv = document.createElement('div');
        selectorDiv.className = 'cash-bill-selector';
        selectorDiv.innerHTML = `
            <label>Billete ${i + 1}:</label>
            <select class="cash-bill-select" data-bill-index="${i}">
                <option value="">Seleccionar denominación</option>
                ${CASH_DENOMINATIONS.map(d => `<option value="${d}">$${d}</option>`).join('')}
            </select>
        `;
        container.appendChild(selectorDiv);
    }
    // Agregar listeners
    container.querySelectorAll('.cash-bill-select').forEach(sel => {
        sel.addEventListener('change', handleCashBillsChange);
    });
}

// Hook para inicializar los selectores al cargar y al cambiar el número de billetes
function setupDynamicCashBills() {
    const numBillsInput = document.getElementById('num-cash-bills');
    if (numBillsInput) {
        numBillsInput.addEventListener('input', renderCashBillSelectors);
        renderCashBillSelectors();
    }
}

// Hook para inicializar todo al cargar
const oldInitCheckout = window.initCheckout;
window.initCheckout = function() {
    if (typeof oldInitCheckout === 'function') oldInitCheckout();
    setupDynamicCashBills();
};

document.addEventListener('DOMContentLoaded', () => {
    if (typeof window.initCheckout === 'function') window.initCheckout();
});

// Configurar cliente de prueba para testing
function setupTestClient() {
    // Si no hay cliente configurado, crear uno de prueba
    if (!getCurrentClient()) {
        const testClient = {
            id: 1,
            tipo: 'natural',
            nombre: 'Cliente Prueba',
            ci: 12345678,
            rif: 123456789
        };
        sessionStorage.setItem('currentClient', JSON.stringify(testClient));
        console.log('Cliente de prueba configurado:', testClient);
    }
}

// Función para mostrar datos de puntos inmediatamente (para testing)
function showPointsDataImmediately() {
    console.log('=== MOSTRANDO DATOS DE PUNTOS INMEDIATAMENTE ===');
    
    // Mostrar la sección de puntos
    const pointsMethod = document.getElementById('points-payment-method');
    if (pointsMethod) {
        pointsMethod.style.display = 'block';
        pointsMethod.classList.remove('disabled');
        console.log('Sección de puntos mostrada');
    }
    
    // Habilitar el checkbox
    const pointsCheckbox = document.getElementById('payment-points');
    if (pointsCheckbox) {
        pointsCheckbox.disabled = false;
        console.log('Checkbox de puntos habilitado');
    }
    
    // Mostrar datos de prueba
    const testData = {
        saldo_actual: 250,
        puntos_ganados: 300,
        puntos_gastados: 50,
        valor_punto: 1.0,
        minimo_canje: 50,
        tasa_actual: 1.0
    };
    
    updatePointsDisplay(testData);
    console.log('Datos de prueba mostrados:', testData);
}

// Ejecutar inmediatamente para testing
document.addEventListener('DOMContentLoaded', () => {
    showPointsDataImmediately();
});

// ================= NUEVA SECCIÓN DE PUNTOS ACAUCAB =================

function setupNewPointsSection() {
    // Mostrar la sección siempre
    const pointsMethod = document.getElementById('new-points-method');
    if (pointsMethod) {
        pointsMethod.style.display = 'block';
        pointsMethod.classList.remove('disabled');
    }
    // Habilitar el checkbox
    const pointsCheckbox = document.getElementById('new-payment-points');
    if (pointsCheckbox) {
        pointsCheckbox.disabled = false;
    }

    // Cargar datos reales del backend
    const currentClient = getCurrentClient();
    if (!currentClient || currentClient.tipo !== 'natural') {
        updateNewPointsDisplay({
            saldo_actual: 0,
            valor_punto: 1.0,
            minimo_canje: 5
        });
        return;
    }
    fetch(`${API_BASE_URL}/puntos/info/${currentClient.id}`)
        .then(res => res.ok ? res.json() : null)
        .then(data => {
            if (data && data.success) {
                // Usar el mínimo de canje real del backend
                updateNewPointsDisplay(data.data);
            } else {
                updateNewPointsDisplay({ saldo_actual: 0, valor_punto: 1.0, minimo_canje: 5 });
            }
        })
        .catch(() => {
            updateNewPointsDisplay({ saldo_actual: 0, valor_punto: 1.0, minimo_canje: 5 });
        });

    // Event listeners
    if (pointsCheckbox) {
        pointsCheckbox.addEventListener('change', function() {
            const details = document.getElementById('new-points-details');
            const amountInput = document.getElementById('new-points-amount');
            if (pointsCheckbox.checked) {
                if (details) details.classList.add('active');
                if (amountInput) amountInput.disabled = false;
            } else {
                if (details) details.classList.remove('active');
                if (amountInput) amountInput.disabled = true;
            }
        });
    }
    const pointsToUse = document.getElementById('new-points-to-use');
    if (pointsToUse) {
        pointsToUse.addEventListener('input', handleNewPointsChange);
    }
    const useMaxBtn = document.getElementById('new-use-max-points');
    if (useMaxBtn) {
        useMaxBtn.addEventListener('click', useNewMaxPoints);
    }
}

function updateNewPointsDisplay(data) {
    document.getElementById('new-points-available').textContent = data.saldo_actual;
    document.getElementById('new-points-value').textContent = data.valor_punto.toFixed(2);
    document.getElementById('new-points-minimum').textContent = data.minimo_canje;
}

function handleNewPointsChange() {
    const pointsToUse = document.getElementById('new-points-to-use');
    const pointsAvailable = parseInt(document.getElementById('new-points-available').textContent);
    const pointsValue = parseFloat(document.getElementById('new-points-value').textContent);
    const equivalent = document.getElementById('new-points-equivalent');
    const errorDiv = document.getElementById('new-points-error');
    const amountInput = document.getElementById('new-points-amount');
    const pointsCheckbox = document.getElementById('new-payment-points');
    const points = parseInt(pointsToUse.value) || 0;
    let error = '';
    if (points > pointsAvailable) error = 'No tienes suficientes puntos disponibles';
    if (points < 0) error = 'Los puntos no pueden ser negativos';
    if (error) {
        errorDiv.textContent = error;
        errorDiv.style.display = 'block';
        pointsToUse.classList.add('error');
    } else {
        errorDiv.style.display = 'none';
        pointsToUse.classList.remove('error');
    }
    // Siempre usar punto decimal y dos decimales
    const monto = parseFloat((points * pointsValue).toFixed(2));
    equivalent.textContent = monto.toFixed(2);
    if (amountInput) {
        amountInput.value = monto;
        amountInput.readOnly = true;
        if (pointsCheckbox && pointsCheckbox.checked) {
            amountInput.disabled = false;
        }
    }
    updatePaymentSummary();
}

function useNewMaxPoints() {
    const pointsAvailable = parseInt(document.getElementById('new-points-available').textContent);
    const pointsValue = parseFloat(document.getElementById('new-points-value').textContent);
    const totalToPay = getTotalToPay();
    const maxPoints = Math.min(pointsAvailable, Math.floor(totalToPay / pointsValue));
    document.getElementById('new-points-to-use').value = maxPoints;
    handleNewPointsChange();
}

document.addEventListener('DOMContentLoaded', setupNewPointsSection);

function getCurrencyValue(input, currency) {
    let value = parseFloat(input.value) || 0;
    if (currency === 'BS') {
        // Convertir Bs a $ para la lógica interna
        return value / TASA_BS;
    }
    return value;
}

function getCurrencyDisplay(value, currency) {
    if (currency === 'BS') {
        // Mostrar Bs y su equivalente en $
        return `Bs ${value.toLocaleString('es-VE', {minimumFractionDigits: 2, maximumFractionDigits: 2})} | $${(value / TASA_BS).toFixed(2)}`;
    } else {
        // Mostrar $ y su equivalente en Bs
        return `$${value.toFixed(2)} | Bs ${(value * TASA_BS).toLocaleString('es-VE', {minimumFractionDigits: 2, maximumFractionDigits: 2})}`;
    }
} 