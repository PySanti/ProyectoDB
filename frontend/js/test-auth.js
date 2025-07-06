// =====================================================
// SCRIPT DE PRUEBA PARA AUTENTICACIÓN
// =====================================================

console.log('🧪 Iniciando pruebas de autenticación...');

// Función para simular un usuario logueado
function simularUsuarioLogueado() {
    const usuarioTest = {
        id_usuario: 1,
        usuario: 'usuario_test',
        nombre: 'Usuario de Prueba',
        email: 'test@acaucab.com'
    };
    
    localStorage.setItem('user', JSON.stringify(usuarioTest));
    console.log('✅ Usuario de prueba logueado:', usuarioTest);
    
    // Actualizar interfaz
    if (typeof updateAuthUI === 'function') {
        updateAuthUI();
    } else {
        console.warn('⚠️ updateAuthUI no está disponible');
    }
}

// Función para simular logout
function simularLogout() {
    localStorage.removeItem('user');
    console.log('✅ Usuario deslogueado');
    
    // Actualizar interfaz
    if (typeof updateAuthUI === 'function') {
        updateAuthUI();
    } else {
        console.warn('⚠️ updateAuthUI no está disponible');
    }
}

// Función para mostrar estado actual
function mostrarEstadoActual() {
    const user = localStorage.getItem('user');
    const isLoggedIn = user ? true : false;
    
    console.log('📊 Estado actual de autenticación:');
    console.log('  - Usuario logueado:', isLoggedIn);
    console.log('  - Datos de usuario:', user ? JSON.parse(user) : 'No hay usuario');
    
    const loginBtn = document.querySelector('.login-btn');
    if (loginBtn) {
        console.log('  - Texto del botón:', loginBtn.textContent);
        console.log('  - Clases del botón:', loginBtn.className);
        console.log('  - Href del botón:', loginBtn.href);
    } else {
        console.warn('  - ⚠️ Botón de login no encontrado');
    }
}

// Ejecutar cuando se carga la página
document.addEventListener('DOMContentLoaded', function() {
    console.log('🚀 Página cargada, verificando funcionalidad...');
    
    // Esperar un poco para que auth-ui.js se cargue
    setTimeout(() => {
        mostrarEstadoActual();
        
        // Agregar botones de prueba al console
        console.log('🔧 Comandos de prueba disponibles:');
        console.log('  - simularUsuarioLogueado() - Simula un usuario logueado');
        console.log('  - simularLogout() - Simula logout');
        console.log('  - mostrarEstadoActual() - Muestra el estado actual');
        
        // Verificar que las funciones están disponibles
        console.log('🔍 Verificando funciones disponibles:');
        console.log('  - updateAuthUI:', typeof updateAuthUI);
        console.log('  - isUserLoggedIn:', typeof isUserLoggedIn);
        console.log('  - getCurrentUser:', typeof getCurrentUser);
        console.log('  - logoutUser:', typeof logoutUser);
    }, 500);
});

// Exportar funciones para uso en console
window.simularUsuarioLogueado = simularUsuarioLogueado;
window.simularLogout = simularLogout;
window.mostrarEstadoActual = mostrarEstadoActual;

console.log('✅ test-auth.js cargado correctamente'); 