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

// Función para mostrar/ocultar paginaciones según el reporte activo
function mostrarPaginacion(tipo) {
    // Paginación de ranking
    const paginacionRanking = document.querySelector('.paginacion-ranking');
    if (paginacionRanking) {
        paginacionRanking.style.display = (tipo === 'puntos') ? 'flex' : 'none';
    }
    // Paginación de vacaciones
    const paginacionVacaciones = document.getElementById('vacaciones-paginacion');
    if (paginacionVacaciones) {
        paginacionVacaciones.style.display = (tipo === 'vacaciones') ? 'flex' : 'none';
    }
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
                x: { title: { display: true, text: 'Clientes' }, ticks: { maxRotation: 45, minRotation: 0 } },
                y: { title: { display: true, text: 'Puntos' }, beginAtZero: true }
            },
            interaction: { mode: 'nearest', axis: 'x', intersect: false }
        }
    });
    // Actualizar rango y botones
    actualizarPaginacionRanking(datosProcesados);
    // Mostrar solo la paginación de ranking
    mostrarPaginacion('puntos');
    // Actualizar leyenda dinámica
    actualizarLeyendaDinamica('puntos');
    // Actualizar títulos
    const titulo = document.getElementById('reporte-titulo-principal');
    const subtitulo = document.getElementById('reporte-titulo-sub');
    if (titulo) titulo.textContent = 'Ranking de Clientes por Puntos de Fidelidad';
    if (subtitulo) subtitulo.textContent = 'Top 10 clientes más leales según puntos acumulados';
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

// Función para obtener los periodos de vacaciones de empleados
async function obtenerVacacionesEmpleados() {
    try {
        const response = await fetch('http://localhost:3000/api/reportes/vacaciones-empleados');
        if (!response.ok) {
            throw new Error(`Error HTTP: ${response.status}`);
        }
        const data = await response.json();
        if (data.success) {
            return data.data;
        } else {
            throw new Error(data.error || 'Error al obtener el resumen de vacaciones');
        }
    } catch (error) {
        console.error('Error al obtener vacaciones de empleados:', error);
        throw error;
    }
}

// Variable global para el gráfico de vacaciones
let graficoVacaciones = null;

// Variables globales para paginación de vacaciones
let vacacionesDataGlobal = [];
let paginaActualVacaciones = 0;
const empleadosPorPagina = 10;

// Función para procesar datos de vacaciones para paginación
function procesarDatosVacacionesParaGrafico(empleados, pagina = 0) {
    const nombresEmpleados = Object.keys(empleados);
    const inicio = pagina * empleadosPorPagina;
    const fin = inicio + empleadosPorPagina;
    const nombresPagina = nombresEmpleados.slice(inicio, fin);
    // Filtrar los datos de empleados solo para la página actual
    const empleadosPagina = {};
    nombresPagina.forEach(nombre => {
        empleadosPagina[nombre] = empleados[nombre];
    });
    return {
        empleadosPagina,
        nombresPagina,
        inicio,
        fin: Math.min(fin, nombresEmpleados.length),
        total: nombresEmpleados.length
    };
}

// Función para actualizar el rango y los botones de paginación de vacaciones
function actualizarPaginacionVacaciones(datosProcesados) {
    let paginacionDiv = document.getElementById('vacaciones-paginacion');
    if (!paginacionDiv) {
        // Crear el contenedor si no existe
        paginacionDiv = document.createElement('div');
        paginacionDiv.id = 'vacaciones-paginacion';
        paginacionDiv.className = 'paginacion-ranking';
        const graficoContainer = document.getElementById('grafico-vacaciones-container');
        if (graficoContainer) {
            graficoContainer.parentElement.appendChild(paginacionDiv);
        }
    }
    paginacionDiv.innerHTML = `
        <span id="vacaciones-rango" style="font-size:14px; color:#666;"></span>
        <button id="vacaciones-anterior" class="paginacion-btn">Anterior</button>
        <button id="vacaciones-siguiente" class="paginacion-btn">Siguiente</button>
    `;
    // Actualizar rango
    const rango = document.getElementById('vacaciones-rango');
    if (rango) {
        rango.textContent = `Mostrando ${datosProcesados.inicio + 1}-${datosProcesados.fin} de ${datosProcesados.total}`;
    }
    // Actualizar botones
    const btnAnterior = document.getElementById('vacaciones-anterior');
    const btnSiguiente = document.getElementById('vacaciones-siguiente');
    if (btnAnterior) {
        btnAnterior.disabled = datosProcesados.inicio === 0;
        btnAnterior.onclick = function() {
            if (paginaActualVacaciones > 0) {
                paginaActualVacaciones--;
                crearGraficoVacaciones(vacacionesDataGlobal, paginaActualVacaciones);
            }
        };
    }
    if (btnSiguiente) {
        btnSiguiente.disabled = datosProcesados.fin >= datosProcesados.total;
        btnSiguiente.onclick = function() {
            if ((paginaActualVacaciones + 1) * empleadosPorPagina < datosProcesados.total) {
                paginaActualVacaciones++;
                crearGraficoVacaciones(vacacionesDataGlobal, paginaActualVacaciones);
            }
        };
    }
}

// Función para actualizar la leyenda dinámica según el reporte
function actualizarLeyendaDinamica(tipo, datasets) {
    const leyendaDiv = document.getElementById('leyenda-dinamica');
    if (!leyendaDiv) return;
    leyendaDiv.innerHTML = '';
    if (tipo === 'vacaciones' && datasets) {
        // Leyenda de períodos de vacaciones
        datasets.forEach(ds => {
            const item = document.createElement('span');
            item.className = 'leyenda-item';
            item.innerHTML = `<span class="leyenda-color" style="background-color: ${ds.backgroundColor}; border:2px solid #fff;"></span>${ds.label}`;
            leyendaDiv.appendChild(item);
        });
    } else if (tipo === 'puntos') {
        // Leyenda de puntos ganados/gastados
        leyendaDiv.innerHTML = `
            <span class="leyenda-item"><span class="leyenda-color" style="background-color: #4CAF50;"></span>Puntos Ganados</span>
            <span class="leyenda-item"><span class="leyenda-color" style="background-color: #F44336;"></span>Puntos Gastados</span>
        `;
    }
}

// Modificar la función para crear el gráfico de vacaciones con paginación
function crearGraficoVacaciones(vacaciones, pagina = 0) {
    const ctx = document.getElementById('grafico-vacaciones');
    if (!ctx) {
        console.error('No se encontró el canvas para el gráfico de vacaciones');
        return;
    }
    if (graficoVacaciones) {
        graficoVacaciones.destroy();
    }
    const empleados = agruparVacacionesPorEmpleado(vacaciones);
    const datosProcesados = procesarDatosVacacionesParaGrafico(empleados, pagina);
    const { datasets, nombresEmpleados } = construirDatasetsApilados(datosProcesados.empleadosPagina);
    graficoVacaciones = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: datosProcesados.nombresPagina,
            datasets: datasets
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
                        title: function(context) {
                            return context[0].label;
                        },
                        label: function(context) {
                            const data = context.dataset.customData[context.dataIndex];
                            if (data && data.dias > 0) {
                                const fechaInicio = new Date(data.fecha_inicio).toLocaleDateString('es-ES');
                                const fechaFin = new Date(data.fecha_fin).toLocaleDateString('es-ES');
                                return [
                                    `Período ${context.datasetIndex + 1}: ${data.dias} días`,
                                    `(${fechaInicio} a ${fechaFin})`,
                                    `Motivo: ${data.descripcion}`
                                ];
                            }
                            return '';
                        }
                    }
                }
            },
            scales: {
                x: {
                    stacked: true,
                    title: { display: true, text: 'Empleados' },
                    ticks: { maxRotation: 45, minRotation: 0 }
                },
                y: {
                    stacked: true,
                    title: { display: true, text: 'Días de Vacaciones' },
                    beginAtZero: true
                }
            },
            interaction: { mode: 'nearest', axis: 'x', intersect: false }
        }
    });
    // Actualizar paginación
    actualizarPaginacionVacaciones(datosProcesados);
    // Mostrar solo la paginación de vacaciones
    mostrarPaginacion('vacaciones');
    // Actualizar leyenda dinámica
    actualizarLeyendaDinamica('vacaciones', datasets);
    // Actualizar títulos
    const titulo = document.getElementById('reporte-titulo-principal');
    const subtitulo = document.getElementById('reporte-titulo-sub');
    if (titulo) titulo.textContent = 'Resumen de Días de Vacaciones';
    if (subtitulo) subtitulo.textContent = 'Distribución de períodos de vacaciones por empleado';
}

// Modificar mostrarVacacionesEmpleados para usar la paginación
async function mostrarVacacionesEmpleados() {
    try {
        const vacacionesData = await obtenerVacacionesEmpleados();
        vacacionesDataGlobal = vacacionesData;
        paginaActualVacaciones = 0;
        crearGraficoVacaciones(vacacionesDataGlobal, paginaActualVacaciones);
        return vacacionesData;
    } catch (error) {
        console.error('Error al mostrar vacaciones de empleados:', error);
        const reporteContenido = document.getElementById('reporte-contenido');
        if (reporteContenido) {
            reporteContenido.innerHTML = `
                <div class="reporte-titulo">
                    <h3>Error al cargar el reporte</h3>
                    <p>No se pudieron cargar los datos de vacaciones de empleados</p>
                </div>
            `;
        }
        throw error;
    }
}

// Función para agrupar vacaciones por empleado
function agruparVacacionesPorEmpleado(vacaciones) {
    const empleados = {};
    vacaciones.forEach(v => {
        if (!empleados[v.nombre_empleado]) {
            empleados[v.nombre_empleado] = [];
        }
        // Calcular días de vacaciones
        const inicio = new Date(v.fecha_inicio);
        const fin = new Date(v.fecha_fin);
        const dias = Math.round((fin - inicio) / (1000 * 60 * 60 * 24)) + 1;
        
        empleados[v.nombre_empleado].push({
            dias: dias,
            descripcion: v.descripcion,
            fecha_inicio: v.fecha_inicio,
            fecha_fin: v.fecha_fin
        });
    });
    return empleados;
}

// Función para construir datasets para gráfico de barras apiladas
function construirDatasetsApilados(empleados) {
    // Encontrar el máximo número de períodos de vacaciones por empleado
    const maxPeriodos = Math.max(...Object.values(empleados).map(arr => arr.length));
    const nombresEmpleados = Object.keys(empleados);

    // Generar tonos de naranja con mayor contraste para cada período
    function naranjaTono(i, total) {
        // De muy claro a muy oscuro
        const lightness = 90 - (60 * (i / Math.max(1, total - 1))); // 90% a 30%
        return `hsl(30, 90%, ${lightness}%)`;
    }

    const datasets = [];
    for (let i = 0; i < maxPeriodos; i++) {
        datasets.push({
            label: `Período ${i + 1}`,
            data: nombresEmpleados.map(nombre => empleados[nombre][i] ? empleados[nombre][i].dias : 0),
            backgroundColor: naranjaTono(i, maxPeriodos),
            borderColor: '#fff', // Borde blanco
            borderWidth: 3, // Más grueso
            barPercentage: 0.5, // Más delgadas
            categoryPercentage: 0.6, // Más delgadas
            customData: nombresEmpleados.map(nombre => empleados[nombre][i] ? empleados[nombre][i] : null)
        });
    }
    return { datasets, nombresEmpleados };
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
    crearGraficoRankingPuntos,
    obtenerVacacionesEmpleados,
    mostrarVacacionesEmpleados
}; 