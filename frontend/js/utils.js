/**
 * Muestra una notificación en la esquina de la pantalla.
 * @param {string} message - El mensaje a mostrar.
 * @param {string} type - El tipo de notificación ('success', 'error', 'info').
 */
function showNotification(message, type = 'info') {
    // Elimina cualquier notificación existente para evitar duplicados
    document.querySelectorAll('.notification').forEach(n => n.remove());

    const container = document.body;
    const notification = document.createElement('div');
    // La animación de entrada se activa directamente por la clase base
    notification.className = `notification notification-${type}`; 

    notification.innerHTML = `
        <div class="notification-content">
            <span class="notification-message">${message}</span>
            <button class="notification-close">&times;</button>
        </div>
    `;

    container.appendChild(notification);

    const hide = () => {
        // La clase 'removing' activa la animación de salida
        notification.classList.add('removing');
        // El elemento se elimina cuando la animación termina
        notification.addEventListener('animationend', () => notification.remove());
    };

    // Cierra la notificación al hacer clic en el botón o después de 4 segundos
    notification.querySelector('.notification-close').addEventListener('click', hide);
    setTimeout(hide, 4000);
}

/**
 * Actualiza el contador de productos en el ícono del carrito.
 * Maneja tanto carrito regular como carrito de eventos.
 */
async function updateCartCounter() {
    const cartCountElement = document.querySelector('.cart-count');
    if (!cartCountElement) return;

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
        // Contador para ventas de eventos
        await updateEventoCartCounter(cartCountElement, eventoData);
    } else {
        // Contador para ventas regulares (web/físicas)
        await updateRegularCartCounter(cartCountElement);
    }
}

/**
 * Actualiza el contador del carrito de eventos
 */
async function updateEventoCartCounter(cartCountElement, eventoData) {
    try {
        // Obtener el cliente validado
        const currentClientStr = sessionStorage.getItem('currentClient');
        if (!currentClientStr) {
            cartCountElement.textContent = '0';
            return;
        }

        const client = JSON.parse(currentClientStr);
        if (client.tipo !== 'natural') {
            cartCountElement.textContent = '0';
            return;
        }

        const response = await fetch(`${API_BASE_URL}/eventos/${eventoData.id_evento}/carrito/${client.id}`);
        if (!response.ok) {
            if (response.status === 404) {
                cartCountElement.textContent = '0';
                return;
            }
            throw new Error('Error al obtener el resumen del carrito del evento');
        }
        const summary = await response.json();
        cartCountElement.textContent = summary.total_items || '0';
    } catch (error) {
        console.error('Error al obtener contador del carrito de eventos:', error);
        cartCountElement.textContent = '0';
    }
}

/**
 * Actualiza el contador del carrito regular (web/físico)
 */
async function updateRegularCartCounter(cartCountElement) {
    // Obtener el usuario actual
    const userStr = localStorage.getItem('user');
    let userId = 1; // GUEST_USER_ID por defecto
    
    if (userStr) {
        try {
            const user = JSON.parse(userStr);
            userId = user.id_usuario;
        } catch (error) {
            console.error('Error al parsear usuario:', error);
        }
    }

    try {
        const response = await fetch(`${API_BASE_URL}/carrito/resumen/${userId}`);
        if (!response.ok) {
            if (response.status === 404) {
                cartCountElement.textContent = '0';
                return;
            }
            throw new Error('Error al obtener el resumen del carrito');
        }
        const summary = await response.json();
        cartCountElement.textContent = summary.total_items || '0';
    } catch (error) {
        // No mostramos error en consola para no generar ruido, pero aseguramos el 0.
        cartCountElement.textContent = '0';
    }
}

// Actualizar el contador en cuanto cargue cualquier página que incluya este script.
document.addEventListener('DOMContentLoaded', updateCartCounter); 