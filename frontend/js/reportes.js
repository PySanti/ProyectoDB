// ========================================
// CONFIGURACIÓN Y VARIABLES GLOBALES
// ========================================

// Configuración de la API
const API_BASE_URL = 'http://localhost:3000/api';

// Variables globales para gráficos
let graficoRankingPuntos = null;
let graficoVacaciones = null;
let graficoCervezasProveedores = null;

// Variables globales para paginación
let rankingClientesData = [];
let paginaActualRanking = 0;
const clientesPorPagina = 10;

// Variables globales para paginación de vacaciones
let vacacionesDataGlobal = [];
let paginaActualVacaciones = 0;
const empleadosPorPagina = 10;

// Variables globales para cervezas por proveedores
let cervezasProveedoresData = [];
let proveedorActual = 0;

// ========================================
// FUNCIONES COMUNES
// ========================================

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
    // Paginación de cervezas
    const paginacionCervezas = document.getElementById('cervezas-paginacion');
    if (paginacionCervezas) {
        paginacionCervezas.style.display = (tipo === 'cervezas') ? 'flex' : 'none';
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

// ========================================
// FUNCIONES DE REPORTE PUNTOS
// ========================================

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

// ========================================
// FUNCIONES DE VACACIONES
// ========================================

// Función para obtener los periodos de vacaciones de empleados
async function obtenerVacacionesEmpleados() {
    try {
        const response = await fetch('http://localhost:3000/api/reportes/vacaciones-empleados');
        if (!response.ok) {
            throw new Error(`Error HTTP: ${response.status}`);
        }
        const data = await response.json();
        if (data.success) {
            console.log('Datos de vacaciones obtenidos:', data.data);
            return data.data;
        } else {
            throw new Error(data.error || 'Error al obtener los datos de vacaciones');
        }
    } catch (error) {
        console.error('Error al obtener vacaciones de empleados:', error);
        throw error;
    }
}

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
    const paginacionDiv = document.getElementById('vacaciones-paginacion');
    if (!paginacionDiv) {
        console.error('No se encontró el contenedor de paginación de vacaciones');
        return;
    }
    
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
    // Ajustar el grosor de las barras
    datasets.forEach(ds => {
        ds.barPercentage = 0.5; // más delgadas
        ds.categoryPercentage = 0.6;
    });
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
                    <p>No se pudieron cargar los datos de vacaciones</p>
                </div>
            `;
        }
        throw error;
    }
}

// Función para agrupar vacaciones por empleado
function agruparVacacionesPorEmpleado(vacaciones) {
    const empleados = {};
    vacaciones.forEach(vacacion => {
        // Usar el campo correcto del backend
        const nombreEmpleado = vacacion.nombre_empleado;
        if (!empleados[nombreEmpleado]) {
            empleados[nombreEmpleado] = [];
        }
        empleados[nombreEmpleado].push(vacacion);
    });
    return empleados;
}

// Función para construir datasets apilados para el gráfico
function construirDatasetsApilados(empleados) {
    const nombresEmpleados = Object.keys(empleados);
    const maxPeriodos = Math.max(...nombresEmpleados.map(nombre => empleados[nombre].length));
    
    const datasets = [];
    for (let i = 0; i < maxPeriodos; i++) {
        const data = nombresEmpleados.map(nombre => {
            const vacaciones = empleados[nombre];
            return vacaciones[i] ? {
                dias: vacaciones[i].dias_periodo,
                fecha_inicio: vacaciones[i].fecha_inicio,
                fecha_fin: vacaciones[i].fecha_fin,
                descripcion: vacaciones[i].descripcion
            } : { dias: 0 };
        });
        datasets.push({
            label: `Período ${i + 1}`,
            data: data.map(d => d.dias),
            backgroundColor: naranjaTono(i, maxPeriodos),
            borderColor: '#fff',
            borderWidth: 1,
            customData: data
        });
    }
    // Paleta de naranjas más variada
    function naranjaTono(i, total) {
        const palette = [
            '#FFA726', '#FF9800', '#FB8C00', '#F57C00', '#EF6C00', '#FFB300', '#FF7043', '#FFCC80', '#FFAB91', '#FFD54F', '#FF8A65', '#FF6F00'
        ];
        return palette[i % palette.length];
    }
    return { datasets, nombresEmpleados };
}

// ========================================
// FUNCIONES DE CERVEZAS DE PROVEEDORES
// ========================================

// Función para obtener cervezas por proveedores
async function obtenerCervezasProveedores() {
    try {
        const response = await fetch(`${API_BASE_URL}/reportes/cervezas-proveedores`);
        if (!response.ok) {
            throw new Error(`Error HTTP: ${response.status}`);
        }
        const data = await response.json();
        if (data.success) {
            console.log('Datos de cervezas por proveedores obtenidos:', data.data);
            return data.data;
        } else {
            throw new Error(data.error || 'Error al obtener el listado de cervezas por proveedores');
        }
    } catch (error) {
        console.error('Error al obtener cervezas por proveedores:', error);
        throw error;
    }
}

// Función para procesar datos por proveedor
function procesarDatosPorProveedor(datos) {
    const proveedores = {};
    
    datos.forEach(item => {
        if (!proveedores[item.proveedor]) {
            proveedores[item.proveedor] = [];
        }
        proveedores[item.proveedor].push({
            cerveza: item.cerveza,
            tipos_cerveza: item.tipos_cerveza
        });
    });
    
    return Object.keys(proveedores).map(proveedor => ({
        nombre: proveedor,
        cervezas: proveedores[proveedor]
    }));
}

// Función para generar colores para las cervezas
function generarColoresCerveza(cantidad) {
    // Paleta de naranjas y análogos, vibrante y diferenciada
    const colores = [
        "#FF9800", // naranja
        "#FFB300", // ámbar
        "#FF7043", // naranja coral
        "#FFA726", // naranja claro
        "#FF5722", // naranja rojizo
        "#FFD600", // amarillo fuerte
        "#FF8A65", // salmón
        "#FF6F00", // naranja oscuro
        "#FFC107", // amarillo anaranjado
        "#FFAB40", // naranja pastel
        "#FF3D00", // rojo anaranjado
        "#FFCC80"  // durazno claro
    ];
    const coloresGenerados = [];
    for (let i = 0; i < cantidad; i++) {
        coloresGenerados.push(colores[i % colores.length]);
    }
    return coloresGenerados;
}

// Función para crear el gráfico de dona de cervezas por proveedor
function crearGraficoCervezasProveedores(datos, indiceProveedor) {
    // Oculta otros gráficos
    document.getElementById('grafico-ranking-puntos').parentElement.style.display = 'none';
    document.getElementById('grafico-vacaciones-container').style.display = 'none';
    document.getElementById('grafico-cervezas-container').style.display = 'flex';

    // Limpia la leyenda dinámica (usada por otros reportes)
    const leyendaDinamica = document.getElementById('leyenda-dinamica');
    if (leyendaDinamica) {
        leyendaDinamica.innerHTML = '';
    }

    // Actualiza títulos
    const titulo = document.getElementById('reporte-titulo-principal');
    const subtitulo = document.getElementById('reporte-titulo-sub');
    const proveedores = procesarDatosPorProveedor(datos);

    if (proveedores.length === 0) {
        if (titulo) titulo.textContent = 'Cervezas Producidas por Proveedor';
        if (subtitulo) subtitulo.textContent = '';
        document.getElementById('proveedor-info').innerHTML = '<h3>No hay datos disponibles</h3><p>No se encontraron cervezas registradas en el sistema</p>';
        document.getElementById('leyenda-cervezas').innerHTML = '';
        // Limpia el canvas
        const ctx = document.getElementById('grafico-cervezas-proveedores').getContext('2d');
        ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
        return;
    }

    const proveedor = proveedores[indiceProveedor];
    const cervezas = proveedor.cervezas;
    const colores = generarColoresCerveza(cervezas.length);

    if (titulo) titulo.textContent = 'Cervezas Producidas por Proveedor';
    if (subtitulo) subtitulo.textContent = `Proveedor: ${proveedor.nombre}`;
    document.getElementById('proveedor-info').innerHTML = `
        <h3>${proveedor.nombre}</h3>
        <p>${cervezas.length} cerveza${cervezas.length !== 1 ? 's' : ''} producida${cervezas.length !== 1 ? 's' : ''}</p>
    `;

    // Crea el gráfico de dona
    const ctx = document.getElementById('grafico-cervezas-proveedores');
    if (window.graficoCervezasProveedores) {
        window.graficoCervezasProveedores.destroy();
    }
    window.graficoCervezasProveedores = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: cervezas.map(c => c.cerveza),
            datasets: [{
                data: cervezas.map(() => 1),
                backgroundColor: colores,
                borderColor: '#fff',
                borderWidth: 2,
                hoverBorderWidth: 3
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        title: function(context) {
                            return context[0].label;
                        },
                        label: function(context) {
                            const cerveza = cervezas[context.dataIndex];
                            return `Clasificación: ${cerveza.tipos_cerveza}`;
                        }
                    }
                }
            },
            cutout: '60%'
        }
    });

    crearLeyendaCervezas(cervezas, colores);

    // Muestra solo la paginación de cervezas
    mostrarPaginacion('cervezas');
}

// Función para crear leyenda personalizada
function crearLeyendaCervezas(cervezas, colores) {
    // Limpia la leyenda dinámica (usada por otros reportes)
    const leyendaDinamica = document.getElementById('leyenda-dinamica');
    if (leyendaDinamica) {
        leyendaDinamica.innerHTML = '';
    }
    
    const leyendaDiv = document.getElementById('leyenda-cervezas');
    if (!leyendaDiv) return;
    
    leyendaDiv.innerHTML = '';
    cervezas.forEach((cerveza, index) => {
        const item = document.createElement('div');
        item.className = 'leyenda-item-cerveza';
        item.innerHTML = `
            <span class="leyenda-color" style="background-color: ${colores[index]};"></span>
            <div class="leyenda-texto">
                <strong>${cerveza.cerveza}</strong>
                <span class="clasificacion">${cerveza.tipos_cerveza}</span>
            </div>
        `;
        leyendaDiv.appendChild(item);
    });
}

// Función para actualizar paginación de cervezas
function actualizarPaginacionCervezas(totalProveedores, proveedorActual) {
    const rango = document.getElementById('cervezas-rango');
    const btnAnterior = document.getElementById('cervezas-anterior');
    const btnSiguiente = document.getElementById('cervezas-siguiente');
    
    if (rango) {
        rango.textContent = `Proveedor ${proveedorActual + 1} de ${totalProveedores}`;
    }
    if (btnAnterior) {
        btnAnterior.disabled = proveedorActual === 0;
    }
    if (btnSiguiente) {
        btnSiguiente.disabled = proveedorActual >= totalProveedores - 1;
    }
}

// Función principal para mostrar cervezas por proveedores
async function mostrarCervezasProveedores() {
    try {
        const cervezasData = await obtenerCervezasProveedores();
        cervezasProveedoresData = cervezasData;
        proveedorActual = 0;
        
        // Actualizar títulos
        const titulo = document.getElementById('reporte-titulo-principal');
        const subtitulo = document.getElementById('reporte-titulo-sub');
        if (titulo) titulo.textContent = 'Cervezas Producidas por Proveedores';
        if (subtitulo) subtitulo.textContent = 'Distribución de cervezas por proveedor';
        
        // Mostrar paginación de cervezas
        mostrarPaginacion('cervezas');
        
        console.log('cervezasprovdata', cervezasProveedoresData);
        console.log('proveedoractual',proveedorActual);
        crearGraficoCervezasProveedores(cervezasProveedoresData, proveedorActual);
        
        // Asignar eventos a los botones de paginación
        const btnAnterior = document.getElementById('cervezas-anterior');
        const btnSiguiente = document.getElementById('cervezas-siguiente');
        if (btnAnterior && btnSiguiente) {
            btnAnterior.onclick = function() {
                if (proveedorActual > 0) {
                    proveedorActual--;
                    crearGraficoCervezasProveedores(cervezasProveedoresData, proveedorActual);
                }
            };
            btnSiguiente.onclick = function() {
                const proveedores = procesarDatosPorProveedor(cervezasProveedoresData);
                if (proveedorActual < proveedores.length - 1) {
                    proveedorActual++;
                    crearGraficoCervezasProveedores(cervezasProveedoresData, proveedorActual);
                }
            };
        }
        
        return cervezasData;
    } catch (error) {
        console.error('Error al mostrar cervezas por proveedores:', error);
        const reporteContenido = document.getElementById('reporte-contenido');
        if (reporteContenido) {
            reporteContenido.innerHTML = `
                <div class="reporte-titulo">
                    <h3>Error al cargar el reporte</h3>
                    <p>No se pudieron cargar los datos de cervezas por proveedores</p>
                </div>
            `;
        }
        throw error;
    }
}

// ========================================
// FUNCIÓN DE INICIALIZACIÓN
// ========================================

// Función principal para inicializar los reportes
function inicializarReportes() {
    console.log('Inicializando reportes...');
    
    // Mostrar el ranking de puntos cuando se cargue la página
    // mostrarRankingPuntos();
    
    // Aquí podemos agregar más reportes en el futuro
    // mostrarVentasMensuales();
    // etc...
}

// ========================================
// EXPORTACIÓN DE FUNCIONES
// ========================================

// Exportar funciones para uso en otros archivos
window.reportes = {
    obtenerRankingPuntos,
    mostrarRankingPuntos,
    inicializarReportes,
    crearGraficoRankingPuntos,
    obtenerVacacionesEmpleados,
    mostrarVacacionesEmpleados,
    mostrarCervezasProveedores
};