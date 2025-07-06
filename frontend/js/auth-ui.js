// =====================================================
// MANEJO DE INTERFAZ DE AUTENTICACIÓN
// =====================================================

/**
 * Verifica si hay una sesión de usuario activa
 * @returns {boolean} true si hay sesión activa, false en caso contrario
 */
function isUserLoggedIn() {
    const user = localStorage.getItem('user');
    if (user) {
        try {
            const userData = JSON.parse(user);
            return userData && userData.id_usuario;
        } catch (error) {
            console.error('Error al parsear datos de usuario:', error);
            return false;
        }
    }
    return false;
}

/**
 * Obtiene los datos del usuario logueado
 * @returns {Object|null} Datos del usuario o null si no hay sesión
 */
function getCurrentUser() {
    const user = localStorage.getItem('user');
    if (user) {
        try {
            return JSON.parse(user);
        } catch (error) {
            console.error('Error al parsear datos de usuario:', error);
            return null;
        }
    }
    return null;
}

/**
 * Actualiza la interfaz de autenticación en el header
 */
function updateAuthUI() {
    const loginBtn = document.querySelector('.login-btn');
    const profileBtn = document.querySelector('.profile-btn');
    
    if (!loginBtn) {
        console.warn('Botón de login no encontrado en el header');
        return;
    }
    
    const isLoggedIn = isUserLoggedIn();
    const user = getCurrentUser();
    
    if (isLoggedIn && user) {
        // Usuario logueado
        loginBtn.textContent = 'Cerrar Sesión';
        loginBtn.href = 'javascript:void(0)';
        loginBtn.onclick = logoutUser;
        loginBtn.classList.add('logged-in');
        
        // Mostrar botón de perfil
        if (profileBtn) {
            profileBtn.style.display = 'inline-flex';
            profileBtn.title = `Perfil de ${user.nombre || user.usuario || 'Usuario'}`;
        }
    } else {
        // Usuario no logueado
        loginBtn.textContent = 'Iniciar Sesión';
        loginBtn.href = 'inicio.html';
        loginBtn.onclick = null;
        loginBtn.classList.remove('logged-in');
        
        // Ocultar botón de perfil
        if (profileBtn) {
            profileBtn.style.display = 'none';
        }
    }
    
    console.log('Auth UI actualizada:', {
        isLoggedIn,
        user: user ? user.usuario : null,
        buttonText: loginBtn.textContent
    });
}

/**
 * Cierra la sesión del usuario
 */
function logoutUser() {
    // Mostrar confirmación
    if (confirm('¿Estás seguro de que quieres cerrar sesión?')) {
        // Limpiar datos de sesión
        localStorage.removeItem('user');
        sessionStorage.removeItem('currentClient');
        sessionStorage.removeItem('eventoVenta');
        
        // Limpiar carrito en el backend si es necesario
        clearUserCart();
        
        // Actualizar interfaz
        updateAuthUI();
        
        // Redirigir a home
        window.location.href = 'home.html';
        
        console.log('Sesión cerrada exitosamente');
    }
}

/**
 * Limpia el carrito del usuario en el backend
 */
async function clearUserCart() {
    try {
        const user = getCurrentUser();
        if (user) {
            const response = await fetch(`${API_BASE_URL}/carrito/limpiar/${user.id_usuario}`, {
                method: 'DELETE'
            });
            
            if (response.ok) {
                console.log('Carrito limpiado en el backend');
            }
        }
    } catch (error) {
        console.error('Error al limpiar carrito:', error);
    }
}

/**
 * Inicializa la interfaz de autenticación
 */
function initAuthUI() {
    // Actualizar interfaz al cargar la página
    updateAuthUI();
    
    // Escuchar cambios en localStorage para actualizar en tiempo real
    window.addEventListener('storage', function(e) {
        if (e.key === 'user') {
            updateAuthUI();
        }
    });
    
    // También actualizar cuando se detecte un cambio en la misma ventana
    // (para casos donde se modifica localStorage desde la misma página)
    const originalSetItem = localStorage.setItem;
    localStorage.setItem = function(key, value) {
        originalSetItem.apply(this, arguments);
        if (key === 'user') {
            setTimeout(updateAuthUI, 100); // Pequeño delay para asegurar que se actualice
        }
    };
}

// =====================================================
// INICIALIZACIÓN AUTOMÁTICA
// =====================================================

// Inicializar cuando se carga el DOM
document.addEventListener('DOMContentLoaded', function() {
    // Esperar un poco para que otros scripts se carguen
    setTimeout(initAuthUI, 100);
});

// Exportar funciones para uso global
window.updateAuthUI = updateAuthUI;
window.logoutUser = logoutUser;
window.isUserLoggedIn = isUserLoggedIn;
window.getCurrentUser = getCurrentUser;

console.log('✅ auth-ui.js cargado correctamente'); 