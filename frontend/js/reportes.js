// Configuración de la API
const API_BASE_URL = 'http://localhost:3000/api';

// Variable global para el gráfico
let graficoRankingPuntos = null;

// Variables globales para paginación
let rankingClientesData = [];
let paginaActualRanking = 0;
const clientesPorPagina = 10;

// Función para obtener el ranking de clientes por puntos
async function obtenerRankingPuntos() {
    try {
        const response = await fetch(`${API_BASE_URL}/reportes/ranking-puntos`);
        if (!response.ok) {
            throw new Error(`Error HTTP: ${response.status}`);
        }
        const data = await response.json();
        if (data.success) {
            // Recibiendo los datos del ranking pidiendoselos al back 
            console.log('Datos del ranking obtenidos:', data.data);
            return data.data;
        } else {
            throw new Error(data.error || 'Error al obtener el ranking');
        }
    } catch (error) {
        console.error('Error al obtener ranking de puntos:', error);
        throw error;
    }
}
        
// Función para procesar datos para Chart.js con paginación
function procesarDatosParaGrafico(datos, pagina = 0) {
    const inicio = pagina * clientesPorPagina;
    const fin = inicio + clientesPorPagina;
    const segmento = datos.slice(inicio, fin);
    const nombres = segmento.map(cliente => cliente.nombre_cliente);
    const puntosGanados = segmento.map(cliente => parseInt(cliente.puntos_ganados));
    const puntosGastados = segmento.map(cliente => parseInt(cliente.puntos_gastados));
    return {
        nombres,
        puntosGanados,
        puntosGastados,
        inicio,
        fin: Math.min(fin, datos.length),
        total: datos.length
    };
}

// Función para crear el gráfico con Chart.js (adaptada para paginación)
function crearGraficoRankingPuntos(datos, pagina = 0) {
    const ctx = document.getElementById('grafico-ranking-puntos');
    if (graficoRankingPuntos) {
        graficoRankingPuntos.destroy();
    }
    const datosProcesados = procesarDatosParaGrafico(datos, pagina);
    graficoRankingPuntos = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: datosProcesados.nombres,
            datasets: [
                {
                    label: 'Puntos Ganados',
                    data: datosProcesados.puntosGanados,
                    backgroundColor: '#4CAF50',
                    borderColor: '#45a049',
                    borderWidth: 1,
                    barPercentage: 0.7,
                    categoryPercentage: 0.7
                },
                {
                    label: 'Puntos Gastados',
                    data: datosProcesados.puntosGastados,
                    backgroundColor: '#F44336',
                    borderColor: '#d32f2f',
                    borderWidth: 1,
                    barPercentage: 0.7,
                    categoryPercentage: 0.7
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                title: { display: false },
                legend: { display: false },
                tooltip: {
                    mode: 'index',
                    intersect: false,
                    callbacks: {
                        label: function(context) {
                            return context.dataset.label + ': ' + context.parsed.y + ' puntos';
                        }
                    }
                }
            },
            scales: {
                x: {
                    title: { display: true, text: 'Clientes' },
                    ticks: { maxRotation: 45, minRotation: 0 }
                },
                y: {
                    title: { display: true, text: 'Puntos' },
                    beginAtZero: true
                }
            },
            interaction: { mode: 'nearest', axis: 'x', intersect: false }
        }
    });
    // Actualizar rango y botones
    actualizarPaginacionRanking(datosProcesados);
}

// Función para actualizar el rango y los botones de paginación
function actualizarPaginacionRanking(datosProcesados) {
    const rango = document.getElementById('ranking-rango');
    const btnAnterior = document.getElementById('ranking-anterior');
    const btnSiguiente = document.getElementById('ranking-siguiente');
    if (rango) {
        rango.textContent = `Mostrando ${datosProcesados.inicio + 1}-${datosProcesados.fin} de ${datosProcesados.total}`;
    }
    if (btnAnterior) {
        btnAnterior.disabled = datosProcesados.inicio === 0;
    }
    if (btnSiguiente) {
        btnSiguiente.disabled = datosProcesados.fin >= datosProcesados.total;
    }
}

// Función para mostrar el ranking de puntos en el dashboard (con paginación)
async function mostrarRankingPuntos() {
    try {
        const rankingData = await obtenerRankingPuntos();
        rankingClientesData = rankingData;
        paginaActualRanking = 0;
        crearGraficoRankingPuntos(rankingClientesData, paginaActualRanking);
        // Asignar eventos a los botones de paginación
        const btnAnterior = document.getElementById('ranking-anterior');
        const btnSiguiente = document.getElementById('ranking-siguiente');
        if (btnAnterior && btnSiguiente) {
            btnAnterior.onclick = function() {
                if (paginaActualRanking > 0) {
                    paginaActualRanking--;
                    crearGraficoRankingPuntos(rankingClientesData, paginaActualRanking);
                }
            };
            btnSiguiente.onclick = function() {
                if ((paginaActualRanking + 1) * clientesPorPagina < rankingClientesData.length) {
                    paginaActualRanking++;
                    crearGraficoRankingPuntos(rankingClientesData, paginaActualRanking);
                }
            };
        }
        return rankingData;
    } catch (error) {
        console.error('Error al mostrar ranking de puntos:', error);
        const reporteContenido = document.getElementById('reporte-contenido');
        if (reporteContenido) {
            reporteContenido.innerHTML = `
                <div class="reporte-titulo">
                    <h3>Error al cargar el reporte</h3>
                    <p>No se pudieron cargar los datos del ranking de puntos</p>
                </div>
            `;
        }
        throw error;
    }
}

// Función principal para inicializar los reportes
function inicializarReportes() {
    console.log('Inicializando reportes...');
    
    // Mostrar el ranking de puntos cuando se cargue la página
    // mostrarRankingPuntos();
    
    // Aquí podemos agregar más reportes en el futuro
    // mostrarVentasMensuales();
    // etc...
}

// Exportar funciones para uso en otros archivos
window.reportes = {
    obtenerRankingPuntos,
    mostrarRankingPuntos,
    inicializarReportes,
    crearGraficoRankingPuntos
}; 