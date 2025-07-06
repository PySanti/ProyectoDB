// Configuración y utilidades
document.addEventListener('DOMContentLoaded', function() {
    initializeTimeDisplay();
    updateTime();
    
    // Actualizar tiempo cada segundo
    setInterval(updateTime, 1000);
    
    // Verificar si viene de una venta de eventos
    checkEventoVenta();
});

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
 * Verificar si viene de una venta de eventos y ajustar la interfaz
 */
function checkEventoVenta() {
    const eventoVenta = sessionStorage.getItem('eventoVenta');
    if (eventoVenta) {
        try {
            const eventoData = JSON.parse(eventoVenta);
            if (eventoData.tipo_venta === 'eventos') {
                // Ajustar la interfaz para ventas de eventos
                adjustInterfaceForEventos();
            }
        } catch (error) {
            console.error('Error al parsear datos del evento:', error);
        }
    }
}

/**
 * Ajustar la interfaz para ventas de eventos
 */
function adjustInterfaceForEventos() {
    // Cambiar el título
    const welcomeTitle = document.querySelector('.welcome-title');
    if (welcomeTitle) {
        welcomeTitle.textContent = 'Venta de Eventos - ACAUCAB';
    }
    
    // Cambiar el subtítulo
    const welcomeSubtitle = document.querySelector('.welcome-subtitle');
    if (welcomeSubtitle) {
        welcomeSubtitle.textContent = 'Registro de ventas para eventos especiales';
    }
    
    // Cambiar la descripción
    const welcomeDescription = document.querySelector('.welcome-description');
    if (welcomeDescription) {
        welcomeDescription.textContent = 'Valide el cliente para proceder con la venta de productos del evento';
    }
    
    // Cambiar el texto del botón
    const startButton = document.querySelector('.start-purchase-btn span');
    if (startButton) {
        startButton.textContent = 'Validar Cliente para Evento';
    }
    
    // Cambiar el ícono del botón
    const startButtonIcon = document.querySelector('.start-purchase-btn i');
    if (startButtonIcon) {
        startButtonIcon.className = 'fas fa-calendar-check';
    }
    
    // Cambiar el texto del footer
    const footerText = document.querySelector('.footer-content p:last-child');
    if (footerText) {
        footerText.textContent = 'Sistema de Venta - Eventos';
    }
}

/**
 * Función para iniciar el proceso de compra
 * Redirige a la página de validación de cliente
 */
function startPurchase() {
    console.log('Iniciando proceso de compra...');
    
    // Verificar si es venta de eventos
    const eventoVenta = sessionStorage.getItem('eventoVenta');
    let isEventoVenta = false;
    
    if (eventoVenta) {
        try {
            const eventoData = JSON.parse(eventoVenta);
            isEventoVenta = eventoData.tipo_venta === 'eventos';
        } catch (error) {
            console.error('Error al parsear datos del evento:', error);
        }
    }
    
    // Establecer tipo de venta
    if (isEventoVenta) {
        setVentaType('eventos');
        console.log('Iniciando venta de eventos...');
    } else {
        setVentaType('tienda');
        console.log('Iniciando venta de tienda física...');
    }
    
    // Mostrar indicador de carga
    const button = document.querySelector('.start-purchase-btn');
    const originalContent = button.innerHTML;
    
    button.innerHTML = '<i class="fas fa-spinner fa-spin"></i><span>Iniciando...</span>';
    button.disabled = true;
    
    // Simular un pequeño delay para mejor UX
    setTimeout(() => {
        // Redirigir a la página de validación de cliente
        window.location.href = 'validar-cliente.html';
    }, 1000);
}

/**
 * Función para manejar errores de redirección
 */
function handleNavigationError() {
    console.error('Error al navegar a la página de validación de cliente');
    
    // Restaurar el botón
    const button = document.querySelector('.start-purchase-btn');
    button.innerHTML = '<i class="fas fa-shopping-cart"></i><span>Realizar Compra</span>';
    button.disabled = false;
    
    // Mostrar mensaje de error
    showNotification('Error al iniciar el proceso. Intente nuevamente.', 'error');
}

/**
 * Función para mostrar notificaciones
 */
function showNotification(message, type = 'info') {
    // Crear elemento de notificación
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <i class="fas fa-${type === 'error' ? 'exclamation-triangle' : 'info-circle'}"></i>
            <span>${message}</span>
        </div>
    `;
    
    // Agregar estilos inline para la notificación
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${type === 'error' ? '#e74c3c' : '#3498db'};
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        z-index: 1000;
        transform: translateX(100%);
        transition: transform 0.3s ease;
        max-width: 300px;
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

/**
 * Función para verificar si el usuario está en modo empleado
 * (Para futuras implementaciones de validación de roles)
 */
function checkEmployeeMode() {
    // Por ahora, siempre permitir acceso
    // En el futuro, aquí se validaría si el usuario es empleado
    return true;
}

/**
 * Función para obtener información del dispositivo
 * (Útil para debugging y analytics)
 */
function getDeviceInfo() {
    return {
        userAgent: navigator.userAgent,
        screenWidth: window.screen.width,
        screenHeight: window.screen.height,
        viewportWidth: window.innerWidth,
        viewportHeight: window.innerHeight,
        timestamp: new Date().toISOString()
    };
}

// Event listeners adicionales
document.addEventListener('keydown', function(event) {
    // Permitir iniciar compra con Enter o Espacio
    if (event.key === 'Enter' || event.key === ' ') {
        event.preventDefault();
        const button = document.querySelector('.start-purchase-btn');
        if (button && !button.disabled) {
            startPurchase();
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