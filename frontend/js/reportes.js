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

// Variable global para el gráfico de ingresos
let graficoIngresosPorTipo = null;

// variables globales para la comparativa de estilos
let comparativaEstilosData = [];
let paginaActualComparativa = 0;
const cervezasPorPagina = 6;

// Variables globales para la tabla de PDF
let datosTablaReporte = [];
let configTablaReporte = {};

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
    // Para ingresos no hay paginación, solo ocultamos las demás
    if (tipo === 'ingresos') {
        if (paginacionRanking) paginacionRanking.style.display = 'none';
        if (paginacionVacaciones) paginacionVacaciones.style.display = 'none';
        if (paginacionCervezas) paginacionCervezas.style.display = 'none';
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
            // Guardar datos y configuración para la tabla PDF
            datosTablaReporte = data.data;
            configTablaReporte = {
                titulo: 'Tabla completa de Ranking de Clientes',
                columnas: ['id_cliente', 'nombre_cliente', 'puntos_ganados', 'puntos_gastados'],
                titulos: ['ID', 'Nombre', 'Puntos Ganados', 'Puntos Gastados']
            };
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
        // Agregar botón de descarga PDF
        agregarBotonDescargaPDF();
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
            // Guardar datos y configuración para la tabla PDF
            datosTablaReporte = data.data;
            configTablaReporte = {
                titulo: 'Tabla completa de Vacaciones de Empleados',
                columnas: ['id_empleado', 'nombre_empleado', 'fecha_inicio', 'fecha_fin', 'descripcion', 'dias_periodo'],
                titulos: ['ID', 'Nombre', 'Fecha Inicio', 'Fecha Fin', 'Descripción', 'Días']
            };
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
        // Agregar botón de descarga PDF
        agregarBotonDescargaPDF();
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
            // Guardar datos y configuración para la tabla PDF
            datosTablaReporte = data.data;
            configTablaReporte = {
                titulo: 'Tabla de Cervezas por Proveedor',
                columnas: ['proveedor', 'cerveza', 'tipos_cerveza'],
                titulos: ['Proveedor', 'Cerveza', 'Tipo de Cerveza']
            };
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

    // Actualizar paginación
    actualizarPaginacionCervezas(proveedores.length, indiceProveedor);

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
        rango.textContent = `Mostrando Proveedor ${proveedorActual + 1} / ${totalProveedores}`;
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
        
        // Agregar botón de descarga PDF
        agregarBotonDescargaPDF();
        
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

// ==================================================================================================================================
// FUNCIONES DE REPORTE 5. INGRESOS POR VENTA FISICA U ONLINE 
// ==================================================================================================================================

// Función para obtener datos de ingresos por tipo
async function obtenerIngresosPorTipo(year = null) {
    try {
        const url = year 
            ? `${API_BASE_URL}/reportes/ingresos-por-tipo?year=${year}`
            : `${API_BASE_URL}/reportes/ingresos-por-tipo`;
            
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`Error HTTP: ${response.status}`);
        }
        const data = await response.json();
        if (data.success) {
            // Guardar datos y configuración para la tabla PDF
            datosTablaReporte = data.data;
            configTablaReporte = {
                titulo: 'Tabla de Ingresos por Tipo de Venta',
                columnas: ['anio', 'mes', 'periodo', 'tipo_venta', 'ingresos_totales'],
                titulos: ['Año', 'Mes', 'Periodo', 'Tipo de Venta', 'Ingresos Totales']
            };
            console.log('Datos de ingresos por tipo obtenidos:', data.data);
            return data.data;
        } else {
            throw new Error(data.error || 'Error al obtener los ingresos por tipo');
        }
    } catch (error) {
        console.error('Error al obtener ingresos por tipo:', error);
        throw error;
    }
}

// Función para procesar datos para el gráfico de líneas
function procesarDatosIngresosParaGrafico(datos) {
    // Agrupar datos por año y mes
    const agrupados = {};
    datos.forEach(row => {
        const key = `${row.anio}-${row.mes}`;
        if (!agrupados[key]) {
            agrupados[key] = {
                anio: row.anio,
                mes: row.mes,
                periodo: row.periodo.trim(),
                online: 0,
                fisica: 0
            };
        }
        if (row.tipo_venta === 'Online') {
            agrupados[key].online = parseFloat(row.ingresos_totales);
        } else if (row.tipo_venta === 'Física') {
            agrupados[key].fisica = parseFloat(row.ingresos_totales);
        }
    });
    // Convertir a array y ordenar por año y mes
    const ordenados = Object.values(agrupados).sort((a, b) => {
        if (a.anio !== b.anio) return a.anio - b.anio;
        return a.mes - b.mes;
    });
    // Construir arrays para el gráfico
    const periodos = ordenados.map(d => d.periodo.charAt(0).toUpperCase() + d.periodo.slice(1));
    const datosOnline = ordenados.map(d => d.online);
    const datosFisica = ordenados.map(d => d.fisica);
    return {
        periodos,
        datosOnline,
        datosFisica
    };
}

// Función para extraer años únicos de los datos
function extraerAniosUnicos(datos) {
    const anios = [...new Set(datos.map(row => row.anio))].sort();
    return anios;
}

// Función para llenar el selector de años
function llenarSelectorAnios(anios) {
    const selector = document.getElementById('selector-anio-ingresos');
    if (!selector) return;
    
    // Mantener la opción "Todos los años"
    selector.innerHTML = '<option value="">Todos los años</option>';
    
    // Agregar opciones de años
    anios.forEach(anio => {
        const option = document.createElement('option');
        option.value = anio;
        option.textContent = anio;
        selector.appendChild(option);
    });
}

// Función para crear el gráfico de líneas
function crearGraficoIngresosPorTipo(datos) {
    // Ordenar datos por año y mes (por si acaso)
    datos.sort((a, b) => {
        if (a.anio !== b.anio) return a.anio - b.anio;
        return a.mes - b.mes;
    });

    const ctx = document.getElementById('grafico-ingresos-por-tipo');
    if (graficoIngresosPorTipo) {
        graficoIngresosPorTipo.destroy();
    }
    
    const datosProcesados = procesarDatosIngresosParaGrafico(datos);
    
    graficoIngresosPorTipo = new Chart(ctx, {
        type: 'line',
        data: {
            labels: datosProcesados.periodos,
            datasets: [
                {
                    label: 'Ventas Online',
                    data: datosProcesados.datosOnline,
                    borderColor: '#43A047', // Verde
                    backgroundColor: 'rgba(67, 160, 71, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#43A047',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2,
                    pointRadius: 6,
                    pointHoverRadius: 8
                },
                {
                    label: 'Ventas Físicas',
                    data: datosProcesados.datosFisica,
                    borderColor: '#1976D2', // Azul
                    backgroundColor: 'rgba(25, 118, 210, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#1976D2',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2,
                    pointRadius: 6,
                    pointHoverRadius: 8
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                title: {
                    display: false
                },
                legend: {
                    display: true,
                    position: 'top',
                    labels: {
                        usePointStyle: true,
                        padding: 20
                    }
                },
                tooltip: {
                    mode: 'index',
                    intersect: false,
                    callbacks: {
                        label: function(context) {
                            return context.dataset.label + ': $' + context.parsed.y.toLocaleString();
                        }
                    }
                }
            },
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Período'
                    },
                    ticks: {
                        maxRotation: 45,
                        minRotation: 0
                    }
                },
                y: {
                    title: {
                        display: true,
                        text: 'Ingresos ($)'
                    },
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return '$' + value.toLocaleString();
                        }
                    }
                }
            },
            interaction: {
                mode: 'nearest',
                axis: 'x',
                intersect: false
            }
        }
    });
}

// Función para mostrar el reporte de ingresos por tipo
async function mostrarIngresosPorTipo(year = null) {
    try {
        // Ocultar otros contenedores de gráficos
        document.getElementById('grafico-ranking-puntos').style.display = 'none';
        document.getElementById('grafico-vacaciones-container').style.display = 'none';
        document.getElementById('grafico-cervezas-container').style.display = 'none';
        
        // Mostrar contenedor de ingresos
        const contenedorIngresos = document.getElementById('grafico-ingresos-container');
        contenedorIngresos.style.display = 'block';
        
        // Obtener datos
        const datos = await obtenerIngresosPorTipo(year);
        
        if (datos.length === 0) {
            // Mostrar mensaje de no hay datos
            const titulo = document.getElementById('reporte-titulo-principal');
            const subtitulo = document.getElementById('reporte-titulo-sub');
            if (titulo) titulo.textContent = 'Desglose de Ingresos por Tipo de Venta';
            if (subtitulo) subtitulo.textContent = 'No hay datos disponibles para el período seleccionado';
            
            // Limpiar canvas
            const ctx = document.getElementById('grafico-ingresos-por-tipo').getContext('2d');
            ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
            return;
        }
        
        // Extraer años únicos y llenar selector (solo si no hay filtro de año)
        if (!year) {
            const anios = extraerAniosUnicos(datos);
            llenarSelectorAnios(anios);
        }
        
        // Crear gráfico
        crearGraficoIngresosPorTipo(datos);
        
        // Actualizar títulos
        const titulo = document.getElementById('reporte-titulo-principal');
        const subtitulo = document.getElementById('reporte-titulo-sub');
        if (titulo) titulo.textContent = 'Desglose de Ingresos por Tipo de Venta';
        if (subtitulo) subtitulo.textContent = year 
            ? `Comparación de ventas online vs físicas - Año ${year}`
            : 'Comparación de ventas online vs físicas por mes';
        
        // Ocultar paginaciones de otros reportes
        mostrarPaginacion('ingresos');
        
        // Agregar botón de descarga PDF
        agregarBotonDescargaPDF();
        
        return datos;
    } catch (error) {
        console.error('Error al mostrar ingresos por tipo:', error);
        const reporteContenido = document.getElementById('reporte-contenido');
        if (reporteContenido) {
            reporteContenido.innerHTML = `
                <div class="reporte-titulo">
                    <h3>Error al cargar el reporte</h3>
                    <p>No se pudieron cargar los datos de ingresos por tipo de venta</p>
                </div>
            `;
        }
        throw error;
    }
}


// =====================================================================================================
// FUNCIONES DE REPORTE 4. COMPARATIVA DE ESTILOS DE CERVEZA
// =====================================================================================================

async function obtenerComparativaEstilos() {
    try {
        const response = await fetch(`${API_BASE_URL}/reportes/comparativa-estilos`);
        if (!response.ok) throw new Error(`Error HTTP: ${response.status}`);
        const data = await response.json();
        if (data.success) {
            // Guardar datos y configuración para la tabla PDF
            datosTablaReporte = data.data;
            configTablaReporte = {
                titulo: 'Tabla Comparativa de Estilos de Cerveza',
                columnas: ['nombre_cerveza', 'color', 'graduacion_alcoholica', 'amargor'],
                titulos: ['Nombre', 'Color', 'Graduación Alcohólica', 'Amargor']
            };
            return data.data;
        } else {
            throw new Error(data.error || 'Error al obtener la comparativa de estilos');
        }
    } catch (error) {
        console.error('Error al obtener comparativa de estilos:', error);
        throw error;
    }
}

function renderizarTablaComparativa(datos, pagina = 0) {
    const tabla = document.getElementById('comparativa-estilos-table');
    if (!tabla) return;
    // Limpiar tabla
    tabla.innerHTML = '';
    // Calcular paginación
    const inicio = pagina * cervezasPorPagina;
    const fin = Math.min(inicio + cervezasPorPagina, datos.length);
    const cervezasPagina = datos.slice(inicio, fin);
    // Encabezado
    let thead = '<thead><tr>';
    thead += '<th class="th-caracteristica-vacia"></th>';
    cervezasPagina.forEach(c => {
        thead += `<th>${c.nombre_cerveza}</th>`;
    });
    thead += '</tr></thead>';
    // Filas de características
    let tbody = '<tbody>';
    // Color
    tbody += '<tr><td>Color</td>';
    cervezasPagina.forEach(c => {
        const colorVal = c.color || '';
        tbody += `<td style="background:inherit;color:#111;font-weight:bold;text-align:center;">${colorVal}</td>`;
    });
    tbody += '</tr>';
    // Graduación alcohólica
    tbody += '<tr><td>Graduación alcohólica</td>';
    cervezasPagina.forEach(c => {
        tbody += `<td style="text-align:center;">${c.graduacion_alcoholica || ''}</td>`;
    });
    tbody += '</tr>';
    // Amargor
    tbody += '<tr><td>Amargor</td>';
    cervezasPagina.forEach(c => {
        const amargorVal = c.amargor || 'Medio';
        tbody += `<td style="text-align:center;">${amargorVal}</td>`;
    });
    tbody += '</tr>';
    tbody += '</tbody>';
    tabla.innerHTML = thead + tbody;
    // Actualizar rango y botones
    actualizarPaginacionComparativa(datos, pagina);
}

function actualizarPaginacionComparativa(datos, pagina) {
    const rango = document.getElementById('comparativa-rango');
    const btnAnterior = document.getElementById('comparativa-anterior');
    const btnSiguiente = document.getElementById('comparativa-siguiente');
    if (rango) {
        rango.textContent = `Mostrando ${pagina * cervezasPorPagina + 1}-${Math.min((pagina + 1) * cervezasPorPagina, datos.length)} de ${datos.length}`;
    }
    if (btnAnterior) btnAnterior.disabled = pagina === 0;
    if (btnSiguiente) btnSiguiente.disabled = (pagina + 1) * cervezasPorPagina >= datos.length;
}

async function mostrarComparativaEstilos() {
    // Ocultar otros contenedores
    document.getElementById('grafico-ranking-puntos').style.display = 'none';
    document.getElementById('grafico-vacaciones-container').style.display = 'none';
    document.getElementById('grafico-cervezas-container').style.display = 'none';
    document.getElementById('grafico-ingresos-container').style.display = 'none';
    // Mostrar comparativa
    const contenedor = document.getElementById('grid-comparativa-estilos-container');
    contenedor.style.display = 'flex';
    // Obtener datos solo una vez
    if (comparativaEstilosData.length === 0) {
        comparativaEstilosData = await obtenerComparativaEstilos();
    }
    paginaActualComparativa = 0;
    renderizarTablaComparativa(comparativaEstilosData, paginaActualComparativa);
    // Asignar eventos a los botones de paginación
    const btnAnterior = document.getElementById('comparativa-anterior');
    const btnSiguiente = document.getElementById('comparativa-siguiente');
    if (btnAnterior && btnSiguiente) {
        btnAnterior.onclick = function() {
            if (paginaActualComparativa > 0) {
                paginaActualComparativa--;
                renderizarTablaComparativa(comparativaEstilosData, paginaActualComparativa);
            }
        };
        btnSiguiente.onclick = function() {
            if ((paginaActualComparativa + 1) * cervezasPorPagina < comparativaEstilosData.length) {
                paginaActualComparativa++;
                renderizarTablaComparativa(comparativaEstilosData, paginaActualComparativa);
            }
        };
    }
    
    // Agregar botón de descarga PDF
    agregarBotonDescargaPDF();
}

// ========================================
// FUNCIÓN PARA DESCARGAR PDF
// ========================================

// Función para descargar el reporte actual como PDF
async function descargarReportePDF(datosTabla = null, opcionesTabla = {}) {
    const boton = document.getElementById('btn-descargar-pdf');
    try {
        if (boton) {
            boton.classList.add('loading');
            boton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generando PDF...';
        }

        if (typeof html2pdf === 'undefined') {
            console.error('html2pdf no está cargado. Asegúrate de incluir la librería.');
            alert('Error: La librería para generar PDF no está disponible.');
            return;
        }

        // Obtener el contenedor del reporte
        const contenedorReporte = document.querySelector('.reportes-navegacion');
        if (!contenedorReporte) {
            console.error('No se encontró el contenedor de reportes');
            alert('Error: No se encontró el contenido del reporte.');
            return;
        }

        // Obtener el título del reporte actual
        const titulo = document.getElementById('reporte-titulo-principal');
        const subtitulo = document.getElementById('reporte-titulo-sub');
        const tituloReporte = titulo ? titulo.textContent : 'Reporte';
        const subtituloReporte = subtitulo ? subtitulo.textContent : '';

        // Crear un contenedor padre para el PDF
        const contenedorPDF = document.createElement('div');
        contenedorPDF.style.background = 'white';
        contenedorPDF.style.color = 'black';
        contenedorPDF.style.fontFamily = 'Arial, sans-serif';

        // --- PRIMERA PÁGINA: contenido principal ---
        const divPrimeraPagina = document.createElement('div');
        divPrimeraPagina.style.padding = '20px';
        divPrimeraPagina.style.minHeight = '100vh';
        divPrimeraPagina.style.maxHeight = '950px';
        divPrimeraPagina.style.overflow = 'hidden';

        // Encabezado
        divPrimeraPagina.innerHTML = `
            <div style="text-align: center; margin-bottom: 30px; border-bottom: 2px solid #333; padding-bottom: 20px;">
                <h1 style="color: #333; margin: 0; font-size: 24px;">${tituloReporte}</h1>
                ${subtituloReporte ? `<p style="color: #666; margin: 10px 0 0 0; font-size: 16px;">${subtituloReporte}</p>` : ''}
                <p style="color: #999; margin: 10px 0 0 0; font-size: 12px;">Generado el: ${new Date().toLocaleDateString('es-ES')} a las ${new Date().toLocaleTimeString('es-ES')}</p>
            </div>
        `;

        // Clonar el contenido del reporte
        const contenidoClonado = contenedorReporte.cloneNode(true);
        // Reemplazar todos los canvas por imágenes en el DOM clonado
        const canvasOriginales = contenedorReporte.querySelectorAll('canvas');
        const canvasClonados = contenidoClonado.querySelectorAll('canvas');
        canvasClonados.forEach((canvasClonado, idx) => {
            const canvasOriginal = canvasOriginales[idx];
            if (canvasOriginal) {
                const img = document.createElement('img');
                img.src = canvasOriginal.toDataURL('image/png');
                img.style.maxWidth = '100%';
                img.style.display = 'block';
                img.style.margin = '0 auto';
                img.style.background = '#fff';
                img.style.border = '1px solid #ddd';
                img.style.borderRadius = '4px';
                img.width = canvasOriginal.width;
                img.height = canvasOriginal.height;
                canvasClonado.parentNode.replaceChild(img, canvasClonado);
            }
        });
        // Aplicar estilos para PDF
        aplicarEstilosParaPDF(contenidoClonado);
        // Limitar el tamaño del contenido principal
        contenidoClonado.style.maxHeight = '700px';
        contenidoClonado.style.overflow = 'hidden';
        divPrimeraPagina.appendChild(contenidoClonado);
        contenedorPDF.appendChild(divPrimeraPagina);

        // --- SEGUNDA PÁGINA: tabla ---
        if (Array.isArray(datosTabla) && datosTabla.length > 0) {
            const divTabla = document.createElement('div');
            divTabla.style.pageBreakBefore = 'always';
            divTabla.style.marginTop = '40px';
            divTabla.style.padding = '10px';
            divTabla.innerHTML = `
                <h2 style="text-align:center; margin-bottom:20px;">${opcionesTabla.titulo || 'Datos Detallados'}</h2>
                ${generarTablaHTML(datosTabla, opcionesTabla)}
            `;
            contenedorPDF.appendChild(divTabla);
        }

        // Configuración para html2pdf
        const opciones = {
            margin: [15, 15, 15, 15],
            filename: `reporte_${tituloReporte.toLowerCase().replace(/[^a-z0-9]/g, '_')}_${new Date().toISOString().split('T')[0]}.pdf`,
            image: { type: 'jpeg', quality: 0.98 },
            html2canvas: { 
                scale: 2,
                useCORS: true,
                allowTaint: true,
                backgroundColor: '#ffffff'
            },
            jsPDF: { 
                unit: 'mm', 
                format: 'a4', 
                orientation: 'portrait' 
            }
        };

        // Generar y descargar el PDF
        await html2pdf().set(opciones).from(contenedorPDF).save();
        
        if (boton) {
            boton.innerHTML = '<i class="fas fa-check"></i> ¡PDF Descargado!';
            setTimeout(() => {
                boton.innerHTML = '<i class="fas fa-download"></i> Descargar PDF';
            }, 2000);
        }
    } catch (error) {
        console.error('Error al generar PDF:', error);
        alert('Error al generar el PDF. Por favor, inténtalo de nuevo.');
    } finally {
        if (boton) {
            boton.classList.remove('loading');
            boton.innerHTML = '<i class="fas fa-download"></i> Descargar PDF';
        }
    }
}

// Función para generar tabla HTML a partir de un array de objetos
function generarTablaHTML(datos, opciones = {}) {
    if (!Array.isArray(datos) || datos.length === 0) return '<p>No hay datos para mostrar.</p>';
    // Determinar columnas
    let columnas = opciones.columnas || Object.keys(datos[0]);
    let titulos = opciones.titulos || columnas.map(c => c.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase()));
    // Construir tabla
    let html = '<div style="overflow-x:auto;"><table style="width:100%;border-collapse:collapse;font-size:12px;">';
    html += '<thead><tr>';
    titulos.forEach(t => {
        html += `<th style="border:1px solid #ccc;padding:6px 8px;background:#f5f5f5;">${t}</th>`;
    });
    html += '</tr></thead><tbody>';
    datos.forEach(row => {
        html += '<tr>';
        columnas.forEach(col => {
            let valor = row[col];
            if (valor === null || valor === undefined) valor = '';
            // Formatear fechas
            if ((col === 'fecha_inicio' || col === 'fecha_fin') && valor) {
                try {
                    const d = new Date(valor);
                    if (!isNaN(d)) {
                        valor = d.toLocaleDateString('es-ES');
                    }
                } catch (e) {}
            }
            html += `<td style="border:1px solid #ccc;padding:6px 8px;">${valor}</td>`;
        });
        html += '</tr>';
    });
    html += '</tbody></table></div>';
    return html;
}

// Función para aplicar estilos específicos para PDF
function aplicarEstilosParaPDF(elemento) {
    // Ocultar elementos que no queremos en el PDF
    const elementosAOcultar = elemento.querySelectorAll('.paginacion-ranking, .paginacion-vacaciones, .paginacion-cervezas, button, .btn, .arrow-btn');
    elementosAOcultar.forEach(el => {
        el.style.display = 'none';
    });

    // Aplicar estilos para mejor visualización en PDF
    const elementosGraficos = elemento.querySelectorAll('canvas');
    elementosGraficos.forEach(canvas => {
        canvas.style.maxWidth = '100%';
        canvas.style.height = 'auto';
        canvas.style.border = '1px solid #ddd';
        canvas.style.borderRadius = '4px';
        canvas.style.margin = '10px 0';
    });

    // Asegurar que los colores sean visibles en PDF
    const elementosConColor = elemento.querySelectorAll('[style*="color"]');
    elementosConColor.forEach(el => {
        const color = window.getComputedStyle(el).color;
        if (color === 'rgb(255, 255, 255)' || color === 'white') {
            el.style.color = '#000000';
        }
    });

    // Mejorar la visualización de tablas
    const tablas = elemento.querySelectorAll('table');
    tablas.forEach(tabla => {
        tabla.style.width = '100%';
        tabla.style.borderCollapse = 'collapse';
        tabla.style.margin = '15px 0';
        tabla.style.fontSize = '12px';
        
        // Estilos para las celdas
        const celdas = tabla.querySelectorAll('td, th');
        celdas.forEach(celda => {
            celda.style.border = '1px solid #ddd';
            celda.style.padding = '8px';
            celda.style.textAlign = 'left';
        });
        
        // Estilos para encabezados
        const encabezados = tabla.querySelectorAll('th');
        encabezados.forEach(encabezado => {
            encabezado.style.backgroundColor = '#f5f5f5';
            encabezado.style.fontWeight = 'bold';
        });
    });

    // Mejorar la visualización de leyendas
    const leyendas = elemento.querySelectorAll('.leyenda-dinamica, .leyenda-cervezas');
    leyendas.forEach(leyenda => {
        leyenda.style.display = 'flex';
        leyenda.style.flexWrap = 'wrap';
        leyenda.style.gap = '10px';
        leyenda.style.margin = '15px 0';
        leyenda.style.padding = '10px';
        leyenda.style.backgroundColor = '#f9f9f9';
        leyenda.style.borderRadius = '4px';
    });

    // Mejorar la visualización de elementos de leyenda
    const itemsLeyenda = elemento.querySelectorAll('.leyenda-item, .leyenda-item-cerveza');
    itemsLeyenda.forEach(item => {
        item.style.display = 'flex';
        item.style.alignItems = 'center';
        item.style.gap = '5px';
        item.style.margin = '5px 0';
        item.style.fontSize = '12px';
    });

    // Mejorar la visualización de colores de leyenda
    const coloresLeyenda = elemento.querySelectorAll('.leyenda-color');
    coloresLeyenda.forEach(color => {
        color.style.width = '15px';
        color.style.height = '15px';
        color.style.borderRadius = '2px';
        color.style.border = '1px solid #ccc';
    });

    // Asegurar que los contenedores tengan el ancho correcto
    const contenedores = elemento.querySelectorAll('.grafico-container, .reporte-contenido');
    contenedores.forEach(contenedor => {
        contenedor.style.width = '100%';
        contenedor.style.maxWidth = '100%';
        contenedor.style.overflow = 'visible';
    });

    // Mejorar la visualización de títulos
    const titulos = elemento.querySelectorAll('.reporte-titulo h3, .reporte-titulo p');
    titulos.forEach(titulo => {
        titulo.style.margin = '10px 0';
        titulo.style.color = '#333';
    });
}

// Función para agregar botón de descarga al reporte actual
function agregarBotonDescargaPDF() {
    // Buscar si ya existe un botón de descarga
    let botonExistente = document.getElementById('btn-descargar-pdf');
    
    if (!botonExistente) {
        // Crear el botón
        botonExistente = document.createElement('button');
        botonExistente.id = 'btn-descargar-pdf';
        botonExistente.className = 'btn-descargar-pdf';
        botonExistente.innerHTML = `
            <i class="fas fa-download"></i>
            Descargar PDF
        `;
        botonExistente.style.cssText = `
            position: fixed;
            top: 90px;
            right: 20px;
            background: #4CAF50;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            z-index: 1000;
            transition: background 0.3s;
        `;
        
        // Agregar evento hover
        botonExistente.addEventListener('mouseenter', function() {
            this.style.background = '#45a049';
        });
        
        botonExistente.addEventListener('mouseleave', function() {
            this.style.background = '#4CAF50';
        });
        
        // Agregar evento click
        botonExistente.addEventListener('click', () => descargarReportePDF(datosTablaReporte, configTablaReporte));
        
        // Agregar al body
        document.body.appendChild(botonExistente);
    } else {
        // Si ya existe, actualizar el evento click para usar los datos actuales
        botonExistente.onclick = () => descargarReportePDF(datosTablaReporte, configTablaReporte);
    }
}

// Función para remover botón de descarga
function removerBotonDescargaPDF() {
    const boton = document.getElementById('btn-descargar-pdf');
    if (boton) {
        boton.remove();
    }
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
    mostrarCervezasProveedores,
    mostrarIngresosPorTipo,
    mostrarComparativaEstilos,
    descargarReportePDF,
    agregarBotonDescargaPDF,
    removerBotonDescargaPDF
};