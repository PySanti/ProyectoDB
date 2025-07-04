/**
 * Sistema de Gestión de Tipos de Venta - ACAUCAB
 * 
 * Este archivo maneja la lógica para diferenciar entre:
 * - Venta Web (tienda online)
 * - Venta Tienda Física
 * - Venta Eventos (futuro)
 */

// Constantes para tipos de venta
const TIPOS_VENTA = {
    WEB: 'web',
    TIENDA: 'tienda',
    EVENTOS: 'eventos'
};

// Nombres de visualización para cada tipo
const NOMBRES_VENTA = {
    [TIPOS_VENTA.WEB]: 'ACAUCAB, Web',
    [TIPOS_VENTA.TIENDA]: 'ACAUCAB, Tienda',
    [TIPOS_VENTA.EVENTOS]: 'ACAUCAB, Eventos'
};

/**
 * Establece el tipo de venta en sessionStorage
 * @param {string} tipo - El tipo de venta ('web', 'tienda', 'eventos')
 */
function setVentaType(tipo) {
    if (Object.values(TIPOS_VENTA).includes(tipo)) {
        sessionStorage.setItem('tipoVenta', tipo);
        console.log('Tipo de venta establecido:', tipo);
        return true;
    } else {
        console.error('Tipo de venta inválido:', tipo);
        return false;
    }
}

/**
 * Obtiene el tipo de venta actual desde sessionStorage
 * @returns {string|null} El tipo de venta o null si no está establecido
 */
function getVentaType() {
    return sessionStorage.getItem('tipoVenta');
}

/**
 * Obtiene el nombre de visualización del tipo de venta actual
 * @returns {string} El nombre de visualización
 */
function getVentaDisplayName() {
    const tipo = getVentaType();
    return tipo ? NOMBRES_VENTA[tipo] : 'ACAUCAB';
}

/**
 * Actualiza el título del logo en el header según el tipo de venta
 * @param {string} elementId - ID del elemento que contiene el título
 */
function actualizarTituloVenta(elementId = 'logo-title') {
    const logoTitle = document.getElementById(elementId);
    if (logoTitle) {
        logoTitle.textContent = getVentaDisplayName();
        console.log('Título actualizado:', logoTitle.textContent);
    }
}

/**
 * Actualiza el título de la página según el tipo de venta
 * @param {string} elementId - ID del elemento que contiene el título de la página
 * @param {string} tituloBase - Título base de la página
 */
function actualizarTituloPagina(elementId, tituloBase) {
    const tituloElement = document.getElementById(elementId);
    if (tituloElement) {
        const tipo = getVentaType();
        let tituloCompleto = tituloBase;
        
        if (tipo === TIPOS_VENTA.WEB) {
            tituloCompleto += ' - Tienda Web';
        } else if (tipo === TIPOS_VENTA.TIENDA) {
            tituloCompleto += ' - Tienda Física';
        } else if (tipo === TIPOS_VENTA.EVENTOS) {
            tituloCompleto += ' - Eventos';
        }
        
        tituloElement.textContent = tituloCompleto;
        console.log('Título de página actualizado:', tituloCompleto);
    }
}

/**
 * Inicializa la visualización del tipo de venta en la página
 * @param {Object} options - Opciones de configuración
 * @param {string} options.logoId - ID del elemento del logo (default: 'logo-title')
 * @param {string} options.tituloId - ID del elemento del título de página
 * @param {string} options.tituloBase - Título base de la página
 */
function inicializarTipoVenta(options = {}) {
    const {
        logoId = 'logo-title',
        tituloId = null,
        tituloBase = null
    } = options;
    
    // Actualizar logo
    actualizarTituloVenta(logoId);
    
    // Actualizar título de página si se especifica
    if (tituloId && tituloBase) {
        actualizarTituloPagina(tituloId, tituloBase);
    }
    
    console.log('Tipo de venta inicializado:', getVentaType());
}

/**
 * Verifica si el tipo de venta actual es válido
 * @returns {boolean} True si el tipo de venta es válido
 */
function esTipoVentaValido() {
    const tipo = getVentaType();
    return tipo && Object.values(TIPOS_VENTA).includes(tipo);
}

/**
 * Obtiene información completa del tipo de venta actual
 * @returns {Object} Objeto con información del tipo de venta
 */
function getVentaInfo() {
    const tipo = getVentaType();
    return {
        tipo: tipo,
        nombre: getVentaDisplayName(),
        esWeb: tipo === TIPOS_VENTA.WEB,
        esTienda: tipo === TIPOS_VENTA.TIENDA,
        esEventos: tipo === TIPOS_VENTA.EVENTOS,
        esValido: esTipoVentaValido()
    };
}

// Exportar funciones para uso global
window.setVentaType = setVentaType;
window.getVentaType = getVentaType;
window.getVentaDisplayName = getVentaDisplayName;
window.actualizarTituloVenta = actualizarTituloVenta;
window.actualizarTituloPagina = actualizarTituloPagina;
window.inicializarTipoVenta = inicializarTipoVenta;
window.esTipoVentaValido = esTipoVentaValido;
window.getVentaInfo = getVentaInfo; 