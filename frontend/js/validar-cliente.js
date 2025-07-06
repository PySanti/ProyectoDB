// Variables globales
let currentClient = null;
let currentStep = 'cedula';

// Configuración inicial
document.addEventListener('DOMContentLoaded', function() {
    initializeTimeDisplay();
    updateTime();
    setupEventListeners();
    // Cargar lugares
    cargarEstados();
    // Actualizar tiempo cada segundo
    setInterval(updateTime, 1000);
});

/**
 * Configura los event listeners de la página
 */
function setupEventListeners() {
    // Formulario de cédula
    const cedulaForm = document.getElementById('cedula-form');
    if (cedulaForm) {
        cedulaForm.addEventListener('submit', handleCedulaSubmit);
    }
    
    // Formulario de registro
    const registroForm = document.getElementById('registro-form');
    if (registroForm) {
        registroForm.addEventListener('submit', handleRegistroSubmit);
    }
    
    // Input de cédula - validación en tiempo real
    const cedulaInput = document.getElementById('cedula');
    if (cedulaInput) {
        cedulaInput.addEventListener('input', validateCedulaInput);
        cedulaInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                handleCedulaSubmit(e);
            }
        });
    }
}

/**
 * Inicializa la visualización del tiempo
 */
function initializeTimeDisplay() {
    const timeElement = document.getElementById('current-time');
    if (timeElement) {
        updateTime();
    }
}

/**
 * Actualiza la hora actual en la pantalla
 */
function updateTime() {
    const now = new Date();
    const timeString = now.toLocaleTimeString('es-VE', {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
    });
    
    const timeElement = document.getElementById('current-time');
    if (timeElement) {
        timeElement.textContent = timeString;
    }
}

/**
 * Valida el input de cédula en tiempo real
 */
function validateCedulaInput(event) {
    const input = event.target;
    const value = input.value;
    const wrapper = input.closest('.input-wrapper');
    
    // Remover caracteres no numéricos
    const numericValue = value.replace(/\D/g, '');
    input.value = numericValue;
    
    // Validar longitud
    if (numericValue.length > 0 && (numericValue.length < 7 || numericValue.length > 8)) {
        wrapper.classList.add('error');
        wrapper.classList.remove('success');
    } else if (numericValue.length >= 7 && numericValue.length <= 8) {
        wrapper.classList.remove('error');
        wrapper.classList.add('success');
    } else {
        wrapper.classList.remove('error', 'success');
    }
}

/**
 * Valida el input de RIF en tiempo real
 */
function validateRIF(input) {
    const value = input.value;
    const wrapper = input.closest('.input-wrapper');
    
    // Si está vacío, no mostrar error
    if (!value) {
        wrapper.classList.remove('error', 'success');
        return;
    }
    
    // Convertir a número
    const numericValue = parseInt(value, 10);
    
    // Validar que sea un número válido
    if (isNaN(numericValue)) {
        wrapper.classList.add('error');
        wrapper.classList.remove('success');
        return;
    }
    
    // Validar rango (0 a 2147483647 - límite de INTEGER en PostgreSQL)
    if (numericValue < 0 || numericValue > 2147483647) {
        wrapper.classList.add('error');
        wrapper.classList.remove('success');
        return;
    }
    
    // Validar longitud máxima (10 dígitos)
    if (value.length > 10) {
        // Truncar a 10 dígitos
        input.value = value.substring(0, 10);
        wrapper.classList.add('error');
        wrapper.classList.remove('success');
        return;
    }
    
    // Si pasa todas las validaciones
    wrapper.classList.remove('error');
    wrapper.classList.add('success');
}

/**
 * Maneja el envío del formulario de cédula
 */
async function handleCedulaSubmit(event) {
    event.preventDefault();
    
    let cedula = document.getElementById('cedula').value.trim();
    // Validar cédula
    if (!cedula || cedula.length < 7 || cedula.length > 8) {
        showNotification('Por favor ingrese un número de cédula válido (7 u 8 dígitos)', 'error');
        return;
    }
    // Convertir a número
    cedula = parseInt(cedula, 10);
    if (isNaN(cedula)) {
        showNotification('La cédula debe ser numérica', 'error');
        return;
    }
    // Mostrar loading
    showLoading('Verificando cliente...');
    try {
        // Buscar cliente en el backend
        const response = await fetch(`${API_BASE_URL}/users/validate-cedula`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ cedula: cedula })
        });
        const data = await response.json();
        hideLoading();
        if (response.ok) {
            if (data.exists) {
                // Cliente encontrado
                currentClient = data.client;
                showClientFound();
            } else {
                // Cliente no encontrado - mostrar formulario de registro
                showRegistrationForm(cedula);
            }
        } else {
            showNotification(data.message || 'Error al verificar cliente', 'error');
        }
    } catch (error) {
        console.error('Error al verificar cliente:', error);
        hideLoading();
        showNotification('Error de conexión. Intente nuevamente.', 'error');
    }
}

/**
 * Muestra la pantalla de cliente encontrado
 */
function showClientFound() {
    // Ocultar todos los pasos
    hideAllSteps();
    // Mostrar información del cliente
    document.getElementById('client-name').textContent = currentClient.nombre;
    document.getElementById('client-cedula').textContent = `Cédula: ${currentClient.cedula}`;
    document.getElementById('client-email').textContent = currentClient.email || '';
    // Mostrar paso de cliente encontrado
    document.getElementById('step-cliente-encontrado').classList.remove('hidden');
    // Guardar cliente en sessionStorage para uso posterior
    sessionStorage.setItem('currentClient', JSON.stringify(currentClient));
}

/**
 * Muestra el formulario de registro
 */
function showRegistrationForm(cedula) {
    // Ocultar todos los pasos
    hideAllSteps();
    // Limpiar inputs hidden previos
    const regForm = document.getElementById('registro-form');
    Array.from(regForm.querySelectorAll('input[type="hidden"][name="cedula"]')).forEach(e => e.remove());
    // Pre-llenar cédula en el formulario de registro
    const cedulaInput = document.createElement('input');
    cedulaInput.type = 'hidden';
    cedulaInput.name = 'cedula';
    cedulaInput.value = cedula;
    regForm.appendChild(cedulaInput);
    // Mostrar paso de registro
    document.getElementById('step-registro').classList.remove('hidden');
    // Enfocar en el primer campo
    setTimeout(() => {
        document.getElementById('primer_nombre').focus();
    }, 100);
}

/**
 * Maneja el envío del formulario de registro
 */
async function handleRegistroSubmit(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    const clientData = {
        cedula: formData.get('cedula'),
        rif_cliente: formData.get('rif_cliente'),
        primer_nombre: formData.get('primer_nombre'),
        segundo_nombre: formData.get('segundo_nombre'),
        primer_apellido: formData.get('primer_apellido'),
        segundo_apellido: formData.get('segundo_apellido'),
        email: formData.get('email'),
        codigo_area: formData.get('codigo_area'),
        telefono: formData.get('telefono'),
        estado: formData.get('estado'),
        municipio: formData.get('municipio'),
        parroquia: formData.get('parroquia'),
        fecha_nacimiento: formData.get('fecha_nacimiento') || null,
        direccion: formData.get('direccion') || null
    };
    
    // Validar datos requeridos
    if (!clientData.primer_nombre || !clientData.primer_apellido || !clientData.email || !clientData.telefono) {
        showNotification('Por favor complete todos los campos requeridos', 'error');
        return;
    }
    
    // Validar email
    if (!isValidEmail(clientData.email)) {
        showNotification('Por favor ingrese un email válido', 'error');
        return;
    }
    
    // Mostrar loading
    showLoading('Registrando cliente...');
    
    try {
        // Registrar cliente en el backend
        const response = await fetch(`${API_BASE_URL}/users/register`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(clientData)
        });
        
        const data = await response.json();
        
        hideLoading();
        
        if (response.ok) {
            // Cliente registrado exitosamente
            currentClient = data.client;
            showNotification('Cliente registrado exitosamente', 'success');
            
            // Guardar cliente en sessionStorage
            sessionStorage.setItem('currentClient', JSON.stringify(currentClient));
            
            // Continuar al catálogo
            setTimeout(() => {
                continueToCatalog();
            }, 1500);
            
        } else {
            showNotification(data.message || 'Error al registrar cliente', 'error');
        }
        
    } catch (error) {
        console.error('Error al registrar cliente:', error);
        hideLoading();
        showNotification('Error de conexión. Intente nuevamente.', 'error');
    }
}

/**
 * Continúa al catálogo
 */
function continueToCatalog() {
    console.log('Continuando al catálogo...');
    
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
    
    // Limpiar carrito si el cliente cambió
    const lastUserKey = 'lastUserOrClient';
    let currentClient = null;
    if (sessionStorage.getItem('currentClient')) {
        try {
            currentClient = JSON.parse(sessionStorage.getItem('currentClient'));
        } catch {}
    }
    let currentId = currentClient ? currentClient.id : null;
    const lastUserOrClient = sessionStorage.getItem(lastUserKey);
    if (lastUserOrClient && lastUserOrClient !== String(currentId)) {
        // Limpiar carrito en backend
        fetch(`${API_BASE_URL}/carrito/limpiar/1?id_cliente_natural=${currentId}`, { method: 'DELETE' });
    }
    if (currentId) sessionStorage.setItem(lastUserKey, String(currentId));
    
    // Establecer tipo de venta según el contexto
    if (isEventoVenta) {
        setVentaType('eventos');
        console.log('Continuando a catálogo de eventos...');
    } else {
        setVentaType('tienda');
        console.log('Continuando a catálogo de tienda...');
    }
    
    window.location.href = 'catalog.html';
}

/**
 * Cambia de cliente (volver al paso 1)
 */
function changeClient() {
    // Limpiar datos
    currentClient = null;
    sessionStorage.removeItem('currentClient');
    
    // Limpiar formularios
    document.getElementById('cedula-form').reset();
    document.getElementById('registro-form').reset();
    
    // Remover clases de validación
    const inputWrappers = document.querySelectorAll('.input-wrapper');
    inputWrappers.forEach(wrapper => {
        wrapper.classList.remove('error', 'success');
    });
    
    // Mostrar paso 1
    hideAllSteps();
    document.getElementById('step-cedula').classList.remove('hidden');
    
    // Enfocar en cédula
    setTimeout(() => {
        document.getElementById('cedula').focus();
    }, 100);
}

/**
 * Volver a la página anterior
 */
function goBack() {
    window.history.back();
}

/**
 * Oculta todos los pasos
 */
function hideAllSteps() {
    const steps = document.querySelectorAll('.step-container');
    steps.forEach(step => {
        step.classList.add('hidden');
    });
}

/**
 * Muestra el estado de loading
 */
function showLoading(message = 'Cargando...') {
    document.getElementById('loading-text').textContent = message;
    document.getElementById('loading').classList.remove('hidden');
    
    // Ocultar todos los pasos
    hideAllSteps();
}

/**
 * Oculta el estado de loading
 */
function hideLoading() {
    document.getElementById('loading').classList.add('hidden');
}

/**
 * Valida formato de email
 */
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

/**
 * Función para mostrar notificaciones
 */
function showNotification(message, type = 'info') {
    // Crear elemento de notificación
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    
    const icon = type === 'error' ? 'exclamation-triangle' : 
                 type === 'success' ? 'check-circle' : 'info-circle';
    
    notification.innerHTML = `
        <div class="notification-content">
            <i class="fas fa-${icon}"></i>
            <span>${message}</span>
        </div>
    `;
    
    // Agregar estilos inline para la notificación
    const bgColor = type === 'error' ? '#e74c3c' : 
                   type === 'success' ? '#2ecc71' : '#3498db';
    
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${bgColor};
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        z-index: 1000;
        transform: translateX(100%);
        transition: transform 0.3s ease;
        max-width: 300px;
        font-family: 'Poppins', sans-serif;
    `;
    
    // Agregar al DOM
    document.body.appendChild(notification);
    
    // Animar entrada
    setTimeout(() => {
        notification.style.transform = 'translateX(0)';
    }, 100);
    
    // Remover después de 5 segundos
    setTimeout(() => {
        notification.style.transform = 'translateX(100%)';
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, 5000);
}

// Event listeners adicionales
document.addEventListener('keydown', function(event) {
    // Permitir navegación con Enter en formularios
    if (event.key === 'Enter') {
        const activeElement = document.activeElement;
        if (activeElement && activeElement.tagName === 'INPUT') {
            const form = activeElement.closest('form');
            if (form) {
                event.preventDefault();
                form.dispatchEvent(new Event('submit'));
            }
        }
    }
});

// Manejar errores de carga de página
window.addEventListener('error', function(event) {
    console.error('Error en la página:', event.error);
});

// Manejar errores de red
window.addEventListener('offline', function() {
    showNotification('Sin conexión a internet. Algunas funciones pueden no estar disponibles.', 'warning');
});

window.addEventListener('online', function() {
    showNotification('Conexión restaurada.', 'success');
});

async function cargarEstados() {
    try {
        const res = await fetch(`${API_BASE_URL}/users/estados`);
        const estados = await res.json();
        const select = document.getElementById('estado');
        select.innerHTML = '<option value="">Seleccione un estado</option>';
        estados.forEach(e => {
            const opt = document.createElement('option');
            opt.value = e.id_lugar;
            opt.textContent = e.nombre;
            select.appendChild(opt);
        });
        select.addEventListener('change', cargarMunicipios);
    } catch (e) { console.error('Error cargando estados', e); }
}

async function cargarMunicipios() {
    const estadoId = document.getElementById('estado').value;
    const select = document.getElementById('municipio');
    select.innerHTML = '<option value="">Seleccione un municipio</option>';
    document.getElementById('parroquia').innerHTML = '<option value="">Seleccione una parroquia</option>';
    if (!estadoId || isNaN(parseInt(estadoId, 10))) return;
    try {
        const res = await fetch(`${API_BASE_URL}/users/municipios?estado_id=${estadoId}`);
        const municipios = await res.json();
        console.log('Municipios recibidos:', municipios);
        if (!Array.isArray(municipios)) {
            showNotification(municipios.error || 'Error al cargar municipios', 'error');
            return;
        }
        municipios.forEach(m => {
            const opt = document.createElement('option');
            opt.value = m.id_lugar;
            opt.textContent = m.nombre;
            select.appendChild(opt);
        });
        // Elimina listeners previos antes de agregar uno nuevo
        select.replaceWith(select.cloneNode(true));
        const newSelect = document.getElementById('municipio');
        newSelect.addEventListener('change', cargarParroquias);
    } catch (e) { 
        console.error('Error cargando municipios', e); 
    }
}

async function cargarParroquias() {
    const municipioId = document.getElementById('municipio').value;
    const select = document.getElementById('parroquia');
    select.innerHTML = '<option value="">Seleccione una parroquia</option>';
    if (!municipioId || isNaN(parseInt(municipioId, 10))) return;
    try {
        const res = await fetch(`${API_BASE_URL}/users/parroquias?municipio_id=${municipioId}`);
        const parroquias = await res.json();
        console.log('Parroquias recibidas:', parroquias);
        if (!Array.isArray(parroquias)) {
            showNotification(parroquias.error || 'Error al cargar parroquias', 'error');
            return;
        }
        parroquias.forEach(p => {
            const opt = document.createElement('option');
            opt.value = p.id_lugar;
            opt.textContent = p.nombre;
            select.appendChild(opt);
        });
    } catch (e) { 
        console.error('Error cargando parroquias', e); 
    }
} 