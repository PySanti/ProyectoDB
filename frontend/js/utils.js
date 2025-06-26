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
 * Llama al backend para obtener el total de ítems para el usuario invitado.
 */
async function updateCartCounter() {
    const cartCountElement = document.querySelector('.cart-count');
    if (!cartCountElement) return;
    try {
        const compraId = sessionStorage.getItem('compra_id');
        if (!compraId) {
            cartCountElement.textContent = '0';
            return;
        }
        const response = await fetch(`${API_BASE_URL}/carrito/resumen-por-id/${compraId}`);
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
        cartCountElement.textContent = '0';
    }
}

// Actualizar el contador en cuanto cargue cualquier página que incluya este script.
document.addEventListener('DOMContentLoaded', updateCartCounter);

/**
 * Obtiene o crea el id de la compra pendiente para el cliente actual.
 * Devuelve el id de compra o null si no hay cliente.
 */
async function ensureCompraId() {
    let compraId = sessionStorage.getItem('compra_id');
    const currentClient = getCurrentClient ? getCurrentClient() : null;
    // Si hay compraId, verificar que realmente exista en el backend y esté en proceso
    if (compraId) {
        try {
            const response = await fetch(`${API_BASE_URL}/carrito/resumen-por-id/${compraId}`);
            if (response.ok) {
                const resumen = await response.json();
                // Solo permitir si la compra está en proceso
                if (resumen && resumen.estatus_nombre && resumen.estatus_nombre.toLowerCase() === 'en proceso') {
                    return compraId;
                }
            }
            // Si no está en proceso o no existe, limpiar
            sessionStorage.removeItem('compra_id');
            compraId = null;
        } catch {
            sessionStorage.removeItem('compra_id');
            compraId = null;
        }
    }
    // Si no hay cliente, no se puede crear carrito
    if (!currentClient) return null;
    // Llama al backend para crear o asociar la compra con el cliente
    const requestBody = {
        cliente: currentClient
    };
    try {
        const response = await fetch(`${API_BASE_URL}/carrito/create-or-get`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(requestBody)
        });
        const data = await response.json();
        if (data.success && data.id_compra) {
            compraId = data.id_compra;
            sessionStorage.setItem('compra_id', compraId);
            return compraId;
        } else {
            return null;
        }
    } catch (error) {
        return null;
    }
}

function getCurrentClient() {
    try {
        return JSON.parse(sessionStorage.getItem('currentClient'));
    } catch {
        return null;
    }
} 