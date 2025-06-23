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
    const GUEST_USER_ID = 1; // ID del usuario invitado genérico
    const cartCountElement = document.querySelector('.cart-count');
    if (!cartCountElement) return;

    try {
        const response = await fetch(`${API_BASE_URL}/carrito/resumen/${GUEST_USER_ID}`);
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