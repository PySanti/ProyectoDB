// =================================================================
// DASHBOARD DE DATOS - FUNCIONALIDAD JAVASCRIPT (SECCIÓN INTERNA)
// =================================================================

let graficoVentasTienda = null;
let graficoCrecimientoVentas = null;
let graficoTicketPromedio = null;
let graficoVolumenUnidades = null;
let graficoVentasEstilo = null;
let graficoTendenciaVentas = null;
let graficoVentasCanal = null;

// Función para aplicar colores según el rendimiento
function aplicarColorRendimiento(elemento, valor, tipo, umbralFavorable = 0) {
    let color = '#666'; // Color neutro por defecto
    
    switch(tipo) {
        case 'crecimiento':
            if (valor > umbralFavorable) color = '#28a745'; // Verde para crecimiento positivo
            else if (valor < umbralFavorable) color = '#dc3545'; // Rojo para crecimiento negativo
            break;
        case 'tasa_retencion':
            if (valor >= 70) color = '#28a745'; // Verde para retención alta
            else if (valor >= 50) color = '#ffc107'; // Amarillo para retención media
            else color = '#dc3545'; // Rojo para retención baja
            break;
        case 'rotacion_inventario':
            if (valor >= 4) color = '#28a745'; // Verde para rotación alta
            else if (valor >= 2) color = '#ffc107'; // Amarillo para rotación media
            else color = '#dc3545'; // Rojo para rotación baja
            break;
        case 'tasa_ruptura':
            if (valor <= 5) color = '#28a745'; // Verde para ruptura baja
            else if (valor <= 15) color = '#ffc107'; // Amarillo para ruptura media
            else color = '#dc3545'; // Rojo para ruptura alta
            break;
        case 'ticket_promedio':
            if (valor >= 50) color = '#28a745'; // Verde para ticket alto
            else if (valor >= 25) color = '#ffc107'; // Amarillo para ticket medio
            else color = '#dc3545'; // Rojo para ticket bajo
            break;
        case 'ventas_empleado':
            if (valor >= 1000) color = '#28a745'; // Verde para ventas altas
            else if (valor >= 500) color = '#ffc107'; // Amarillo para ventas medias
            else color = '#dc3545'; // Rojo para ventas bajas
            break;
    }
    
    if (elemento) {
        elemento.style.color = color;
    }
}

// Inicialización solo cuando la sección está visible
function inicializarDashboardDatos() {
    inicializarFechasDatos();
    cargarGraficosDatos();
    cargarDatosRelevantes(); // Cargar datos relevantes también
    document.getElementById('aplicar-filtros-datos').onclick = cargarGraficosDatos;
    var exportarBtn = document.getElementById('exportar-pdf-datos');
    if (exportarBtn) exportarBtn.onclick = exportarPDFDatos;
}

function inicializarFechasDatos() {
    const fechaFin = new Date();
    const fechaInicio = new Date();
    fechaInicio.setMonth(fechaInicio.getMonth() - 1);
    document.getElementById('fecha-inicio-datos').value = fechaInicio.toISOString().split('T')[0];
    document.getElementById('fecha-fin-datos').value = fechaFin.toISOString().split('T')[0];
}

async function cargarGraficosDatos() {
    const fechaInicio = document.getElementById('fecha-inicio-datos').value;
    const fechaFin = document.getElementById('fecha-fin-datos').value;
    try {
        console.log('Obteniendo indicadores de ventas para:', fechaInicio, 'a', fechaFin);
        const indicadores = await obtenerIndicadoresVentas(fechaInicio, fechaFin);
        console.log('Indicadores obtenidos (raw):', JSON.stringify(indicadores, null, 2));
        Object.keys(indicadores).forEach(key => {
            console.log(`Campo: ${key} | Valor:`, indicadores[key]);
        });

        // Actualizar tarjetas de indicadores con colores
        const ventasFisica = Number(indicadores.ventas_totales_fisica);
        const ventasOnline = Number(indicadores.ventas_totales_web);
        const crecimiento = Number(indicadores.crecimiento_porcentual);
        const ticketPromedio = Number(indicadores.ticket_promedio);
        const volumenUnidades = Number(indicadores.volumen_unidades);

        document.getElementById('valor-ventas-tienda-fisica').textContent = `$${ventasFisica.toLocaleString()}`;
        document.getElementById('valor-ventas-tienda-online').textContent = `$${ventasOnline.toLocaleString()}`;
        document.getElementById('valor-crecimiento-ventas').textContent = `$${Number(indicadores.crecimiento_ventas).toLocaleString()} (${crecimiento.toFixed(2)}%)`;
        document.getElementById('valor-ticket-promedio').textContent = `$${ticketPromedio.toLocaleString()}`;
        document.getElementById('valor-volumen-vendido').textContent = volumenUnidades.toLocaleString();

        // Aplicar colores según rendimiento
        aplicarColorRendimiento(document.getElementById('valor-crecimiento-ventas'), crecimiento, 'crecimiento');
        aplicarColorRendimiento(document.getElementById('valor-ticket-promedio'), ticketPromedio, 'ticket_promedio');

        // Obtener y mostrar desglose por presentaciones
        const volumenPresentaciones = await obtenerVolumenPorPresentacion(fechaInicio, fechaFin);
        const subVolumen = document.getElementById('sub-volumen-vendido');
        if (volumenPresentaciones.length > 0) {
            subVolumen.innerHTML = volumenPresentaciones.map(p => `${p.presentacion}: <b>${p.volumen_total}</b>`).join(' · ');
        } else {
            subVolumen.textContent = '';
        }

        // Actualizar tabla de ventas por estilo
        const ventasEstilo = await obtenerVentasPorEstilo(fechaInicio, fechaFin);
        console.log('Ventas por estilo obtenidas (raw):', JSON.stringify(ventasEstilo, null, 2));
        const tbody = document.getElementById('tbody-ventas-estilo');
        tbody.innerHTML = '';
        let totalEstilo = 0;
        ventasEstilo.forEach(e => {
            const tr = document.createElement('tr');
            tr.innerHTML = `<td style='padding:8px; border-bottom:1px solid #e2e8f0;'>${e.estilo_cerveza}</td><td style='padding:8px; text-align:right; border-bottom:1px solid #e2e8f0; font-weight:600;'>${Number(e.unidades_vendidas).toLocaleString()}</td>`;
            tbody.appendChild(tr);
            totalEstilo += Number(e.unidades_vendidas);
        });
        document.getElementById('total-ventas-estilo').textContent = totalEstilo.toLocaleString();

        console.log('Indicadores y tabla actualizados exitosamente');
    } catch (error) {
        console.error('Error al cargar datos de ventas:', error);
        alert(`Error al cargar los datos: ${error.message}`);
    }

    // Indicadores de clientes
    try {
        const clientes = await obtenerIndicadoresClientes(fechaInicio, fechaFin);
        const clientesNuevos = Number(clientes.clientes_nuevos);
        const clientesRecurrentes = Number(clientes.clientes_recurrentes);
        const tasaRetencion = Number(clientes.tasa_retencion);
        
        document.getElementById('valor-clientes-nuevos').textContent = clientesNuevos;
        document.getElementById('valor-clientes-recurrentes').textContent = clientesRecurrentes;
        document.getElementById('valor-tasa-retencion').textContent = `${tasaRetencion.toFixed(2)}%`;
        
        // Aplicar colores según rendimiento
        aplicarColorRendimiento(document.getElementById('valor-tasa-retencion'), tasaRetencion, 'tasa_retencion');
    } catch (error) {
        document.getElementById('valor-clientes-nuevos').textContent = '0';
        document.getElementById('valor-clientes-recurrentes').textContent = '0';
        document.getElementById('valor-tasa-retencion').textContent = '0%';
    }

    // =================================================================
    // INDICADORES DE INVENTARIO Y OPERACIONES
    // =================================================================
    
    // Rotación de inventario
    try {
        const rotacion = await obtenerRotacionInventario(fechaInicio, fechaFin);
        const rotacionValor = Number(rotacion.rotacion_inventario);
        const valorPromedio = Number(rotacion.valor_promedio_inventario);
        const costoVendido = Number(rotacion.costo_productos_vendidos);
        
        document.getElementById('valor-rotacion-inventario').textContent = rotacionValor.toFixed(2);
        document.getElementById('valor-promedio-inventario').textContent = `$${valorPromedio.toLocaleString()}`;
        document.getElementById('valor-costo-vendido').textContent = `$${costoVendido.toLocaleString()}`;
        
        // Aplicar colores según rendimiento
        aplicarColorRendimiento(document.getElementById('valor-rotacion-inventario'), rotacionValor, 'rotacion_inventario');
    } catch (error) {
        document.getElementById('valor-rotacion-inventario').textContent = '0';
        document.getElementById('valor-promedio-inventario').textContent = '$0';
        document.getElementById('valor-costo-vendido').textContent = '$0';
    }

    // Tasa de ruptura de stock
    try {
        const ruptura = await obtenerTasaRupturaStock(fechaInicio, fechaFin);
        const tasaRuptura = Number(ruptura.tasa_ruptura_stock);
        const productosSinStock = Number(ruptura.productos_sin_stock);
        const totalProductos = Number(ruptura.total_productos);
        
        document.getElementById('valor-tasa-ruptura').textContent = `${tasaRuptura.toFixed(2)}%`;
        document.getElementById('valor-productos-sin-stock').textContent = productosSinStock;
        document.getElementById('valor-total-productos').textContent = totalProductos;
        
        // Aplicar colores según rendimiento
        aplicarColorRendimiento(document.getElementById('valor-tasa-ruptura'), tasaRuptura, 'tasa_ruptura');
        aplicarColorRendimiento(document.getElementById('valor-productos-sin-stock'), productosSinStock, 'tasa_ruptura');
    } catch (error) {
        document.getElementById('valor-tasa-ruptura').textContent = '0%';
        document.getElementById('valor-productos-sin-stock').textContent = '0';
        document.getElementById('valor-total-productos').textContent = '0';
    }

    // Ventas por empleado
    try {
        const ventasEmpleado = await obtenerVentasPorEmpleado(fechaInicio, fechaFin);
        const tbody = document.getElementById('tbody-ventas-empleado');
        tbody.innerHTML = '';
        let totalVentasEmpleados = 0;
        ventasEmpleado.forEach(emp => {
            const tr = document.createElement('tr');
            const montoTotal = Number(emp.monto_total_ventas);
            const promedioVenta = Number(emp.promedio_por_venta);
            
            tr.innerHTML = `
                <td style='padding:6px; border-bottom:1px solid #e2e8f0;'>${emp.nombre_empleado}</td>
                <td style='padding:6px; text-align:right; border-bottom:1px solid #e2e8f0; font-weight:600;'>${emp.cantidad_ventas}</td>
                <td style='padding:6px; text-align:right; border-bottom:1px solid #e2e8f0; font-weight:600; color: ${montoTotal >= 1000 ? '#28a745' : montoTotal >= 500 ? '#ffc107' : '#dc3545'}'>$${montoTotal.toLocaleString()}</td>
                <td style='padding:6px; text-align:right; border-bottom:1px solid #e2e8f0; font-weight:600; color: ${promedioVenta >= 50 ? '#28a745' : promedioVenta >= 25 ? '#ffc107' : '#dc3545'}'>$${promedioVenta.toFixed(2)}</td>
            `;
            tbody.appendChild(tr);
            totalVentasEmpleados += montoTotal;
        });
        document.getElementById('total-ventas-empleados').textContent = `$${totalVentasEmpleados.toLocaleString()}`;
    } catch (error) {
        const tbody = document.getElementById('tbody-ventas-empleado');
        tbody.innerHTML = '<tr><td colspan="4" style="text-align:center; padding:1em;">No hay datos disponibles</td></tr>';
        document.getElementById('total-ventas-empleados').textContent = '$0';
    }
    
    // Cargar datos relevantes también cuando se apliquen filtros
    cargarDatosRelevantes();
}

// =================================================================
// FUNCIONES PARA OBTENER DATOS
// =================================================================

// Obtener indicadores de ventas desde el backend
async function obtenerIndicadoresVentas(fechaInicio, fechaFin) {
    const response = await fetch(`${API_BASE_URL}/reportes/indicadores-ventas?fecha_inicio=${fechaInicio}&fecha_fin=${fechaFin}`);
    if (!response.ok) throw new Error('Error al obtener indicadores');
    const data = await response.json();
    if (data.success) return data.data;
    throw new Error('Error en la respuesta de indicadores');
}

// Obtener ventas por estilo de cerveza
async function obtenerVentasPorEstilo(fechaInicio, fechaFin) {
    const response = await fetch(`${API_BASE_URL}/reportes/ventas-por-estilo?fecha_inicio=${fechaInicio}&fecha_fin=${fechaFin}`);
    if (!response.ok) throw new Error('Error al obtener ventas por estilo');
    const data = await response.json();
    if (data.success) return data.data;
    throw new Error('Error en la respuesta de ventas por estilo');
}

// Simulación de función para obtener el desglose por presentaciones
async function obtenerVolumenPorPresentacion(fechaInicio, fechaFin) {
    const response = await fetch(`${API_BASE_URL}/reportes/volumen-por-presentacion?fecha_inicio=${fechaInicio}&fecha_fin=${fechaFin}`);
    if (!response.ok) throw new Error('Error al obtener volumen por presentación');
    const data = await response.json();
    if (data.success) return data.data;
    throw new Error('Error en la respuesta de volumen por presentación');
}

// Obtener indicadores de clientes
async function obtenerIndicadoresClientes(fechaInicio, fechaFin) {
    const response = await fetch(`${API_BASE_URL}/reportes/indicadores-clientes?fecha_inicio=${fechaInicio}&fecha_fin=${fechaFin}`);
    if (!response.ok) throw new Error('Error al obtener indicadores de clientes');
    const data = await response.json();
    if (data.success) return data.data;
    throw new Error('Error en la respuesta de indicadores de clientes');
}

// ===================== GRAFICOS =====================

function crearGraficoVentasTienda(data) {
    const ctx = document.getElementById('grafico-ventas-tienda');
    if (graficoVentasTienda) graficoVentasTienda.destroy();
    graficoVentasTienda = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Tienda Física', 'Tienda Web'],
            datasets: [{
                label: 'Ventas Totales (Bs)',
                data: [data.ventas_totales_fisica, data.ventas_totales_web],
                backgroundColor: ['#ff6b35', '#f7931e']
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } }
        }
    });
}

function crearGraficoCrecimientoVentas(data) {
    const ctx = document.getElementById('grafico-crecimiento-ventas');
    if (graficoCrecimientoVentas) graficoCrecimientoVentas.destroy();
    graficoCrecimientoVentas = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Crecimiento ($)', 'Crecimiento (%)'],
            datasets: [{
                label: 'Crecimiento',
                data: [data.crecimiento_ventas, data.crecimiento_porcentual],
                backgroundColor: ['#ff6b35', '#f7931e']
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } }
        }
    });
}

function crearGraficoTicketPromedio(data) {
    const ctx = document.getElementById('grafico-ticket-promedio');
    if (graficoTicketPromedio) graficoTicketPromedio.destroy();
    graficoTicketPromedio = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Ticket Promedio'],
            datasets: [{
                label: 'Ticket Promedio (Bs)',
                data: [data.ticket_promedio],
                backgroundColor: ['#ff6b35']
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } }
        }
    });
}

function crearGraficoVolumenUnidades(data) {
    const ctx = document.getElementById('grafico-volumen-unidades');
    if (graficoVolumenUnidades) graficoVolumenUnidades.destroy();
    graficoVolumenUnidades = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Unidades Vendidas'],
            datasets: [{
                label: 'Volumen de Unidades',
                data: [data.volumen_unidades],
                backgroundColor: ['#ff6b35']
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } }
        }
    });
}

function crearGraficoVentasEstilo(datos) {
    const ctx = document.getElementById('grafico-ventas-estilo');
    if (graficoVentasEstilo) graficoVentasEstilo.destroy();
    graficoVentasEstilo = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: datos.map(e => e.estilo_cerveza),
            datasets: [{
                data: datos.map(e => e.unidades_vendidas),
                backgroundColor: [
                    '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
                    '#DDA0DD', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E9'
                ]
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: { position: 'bottom' },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
                            const porcentaje = ((context.parsed / total) * 100).toFixed(1);
                            return `${context.label}: ${context.parsed} unidades (${porcentaje}%)`;
                        }
                    }
                }
            }
        }
    });
}

// =================================================================
// FUNCIONES DE INTERACCIÓN
// =================================================================

// Exportar a PDF
async function exportarPDFDatos() {
    try {
        const element = document.getElementById('graficos-section-datos');
        const opt = {
            margin: 1,
            filename: `dashboard-datos.pdf`,
            image: { type: 'jpeg', quality: 0.98 },
            html2canvas: { scale: 2 },
            jsPDF: { unit: 'in', format: 'a4', orientation: 'portrait' }
        };
        html2pdf().set(opt).from(element).save();
    } catch (error) {
        alert('Error al exportar el PDF');
    }
}

// Exponer para uso desde el dashboard principal
window.inicializarDashboardDatos = inicializarDashboardDatos;

// =================================================================
// INICIALIZACIÓN AUTOMÁTICA DEL DASHBOARD DE DATOS
// =================================================================

// Inicializar automáticamente cuando se carga la página
document.addEventListener('DOMContentLoaded', function() {
    const dashboardSection = document.getElementById('dashboard-datos-section');
    const inputInicio = document.getElementById('fecha-inicio-datos');
    const inputFin = document.getElementById('fecha-fin-datos');
    if (dashboardSection && inputInicio && inputFin) {
        console.log('Inicializando dashboard de datos...');
        inicializarDashboardDatos();
    } else {
        console.warn('No se encontró el dashboard de datos o los inputs de fecha en el DOM.');
    }
});

// =================================================================
// FUNCIONES PARA INDICADORES DE INVENTARIO Y OPERACIONES
// =================================================================

// Obtener rotación de inventario
async function obtenerRotacionInventario(fechaInicio, fechaFin) {
    const response = await fetch(`${API_BASE_URL}/reportes/rotacion-inventario?fecha_inicio=${fechaInicio}&fecha_fin=${fechaFin}`);
    if (!response.ok) throw new Error('Error al obtener rotación de inventario');
    const data = await response.json();
    if (data.success) return data.data;
    throw new Error('Error en la respuesta de rotación de inventario');
}

// Obtener tasa de ruptura de stock
async function obtenerTasaRupturaStock(fechaInicio, fechaFin) {
    const response = await fetch(`${API_BASE_URL}/reportes/tasa-ruptura-stock?fecha_inicio=${fechaInicio}&fecha_fin=${fechaFin}`);
    if (!response.ok) throw new Error('Error al obtener tasa de ruptura de stock');
    const data = await response.json();
    if (data.success) return data.data;
    throw new Error('Error en la respuesta de tasa de ruptura de stock');
}

// Obtener ventas por empleado
async function obtenerVentasPorEmpleado(fechaInicio, fechaFin) {
    const response = await fetch(`${API_BASE_URL}/reportes/ventas-por-empleado?fecha_inicio=${fechaInicio}&fecha_fin=${fechaFin}`);
    if (!response.ok) throw new Error('Error al obtener ventas por empleado');
    const data = await response.json();
    if (data.success) return data.data;
    throw new Error('Error en la respuesta de ventas por empleado');
}

// ===================== DATOS RELEVANTES =====================

async function cargarDatosRelevantes() {
  // 1. Tendencia de ventas
  try {
    const res = await fetch(`${API_BASE_URL}/reportes/tendencia-ventas`);
    const data = (await res.json()).data;
    const ctx = document.getElementById('grafico-tendencia-ventas').getContext('2d');
    if (graficoTendenciaVentas) graficoTendenciaVentas.destroy();
    graficoTendenciaVentas = new Chart(ctx, {
      type: 'line',
      data: {
        labels: data.map(d => d.periodo),
        datasets: [{
          label: 'Ventas Totales',
          data: data.map(d => d.total_ventas),
          borderColor: '#ff6b35',
          backgroundColor: 'rgba(255,107,53,0.1)',
          fill: true
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        plugins: { legend: { display: false } }
      }
    });
  } catch (e) { console.error('Error tendencia ventas', e); }

  // 2. Ventas por canal
  try {
    const res = await fetch(`${API_BASE_URL}/reportes/ventas-por-canal`);
    const data = (await res.json()).data;
    const ctx = document.getElementById('grafico-ventas-canal').getContext('2d');
    if (graficoVentasCanal) graficoVentasCanal.destroy();
    graficoVentasCanal = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: data.map(d => d.canal),
        datasets: [{
          label: 'Ventas',
          data: data.map(d => d.total_ventas),
          backgroundColor: ['#ff6b35', '#f7931e', '#fd7e14']
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true
      }
    });
  } catch (e) { console.error('Error ventas canal', e); }

  // 3. Top productos más vendidos
  try {
    const res = await fetch(`${API_BASE_URL}/reportes/top-productos-vendidos`);
    const data = (await res.json()).data;
    const tbody = document.getElementById('tbody-top-productos');
    tbody.innerHTML = '';
    data.forEach(row => {
      const tr = document.createElement('tr');
      const unidadesVendidas = Number(row.unidades_vendidas);
      const color = unidadesVendidas >= 100 ? '#28a745' : unidadesVendidas >= 50 ? '#ffc107' : '#dc3545';
      tr.innerHTML = `<td style='padding:8px; border-bottom:1px solid #e2e8f0;'>${row.producto}</td><td style='padding:8px; text-align:right; border-bottom:1px solid #e2e8f0; font-weight:600; color: ${color}'>${unidadesVendidas.toLocaleString()}</td>`;
      tbody.appendChild(tr);
    });
  } catch (e) { console.error('Error top productos', e); }

  // 4. Stock actual
  try {
    const res = await fetch(`${API_BASE_URL}/reportes/stock-actual`);
    const data = (await res.json()).data;
    const tbody = document.getElementById('tbody-stock-actual');
    tbody.innerHTML = '';
    data.forEach(row => {
      const tr = document.createElement('tr');
      const stockDisponible = Number(row.stock_disponible);
      const color = stockDisponible >= 50 ? '#28a745' : stockDisponible >= 20 ? '#ffc107' : '#dc3545';
      tr.innerHTML = `<td style='padding:8px; border-bottom:1px solid #e2e8f0;'>${row.producto}</td><td style='padding:8px; border-bottom:1px solid #e2e8f0;'>${row.presentacion}</td><td style='padding:8px; text-align:right; border-bottom:1px solid #e2e8f0; font-weight:600; color: ${color}'>${(stockDisponible < 0 ? 0 : stockDisponible).toLocaleString()}</td>`;
      tbody.appendChild(tr);
    });
  } catch (e) { console.error('Error stock actual', e); }
}

// Llamar a cargarDatosRelevantes al inicializar el dashboard de datos
window.addEventListener('DOMContentLoaded', () => {
  if (document.getElementById('datos-relevantes-section')) {
    cargarDatosRelevantes();
  }
});

// Función para insertar el botón de exportar PDF dinámicamente
function insertarBotonExportarPDF() {
  const dashboardSection = document.getElementById('dashboard-datos-section');
  if (dashboardSection && !document.getElementById('exportar-pdf-datos')) {
    const btnDiv = document.createElement('div');
    btnDiv.style.display = 'flex';
    btnDiv.style.justifyContent = 'flex-end';
    btnDiv.style.marginBottom = '1em';
    btnDiv.innerHTML = `<button id="exportar-pdf-datos" style="background: #4a90e2; color: #fff; border: none; padding: 10px 22px; border-radius: 6px; font-size: 1em; font-weight: 600; box-shadow: 0 2px 8px rgba(0,0,0,0.08); cursor: pointer; transition: background 0.2s;"><i class='fas fa-download'></i> Descargar PDF</button>`;
    dashboardSection.insertBefore(btnDiv, dashboardSection.firstChild);
    document.getElementById('exportar-pdf-datos').onclick = exportarPDFDatos;
  }
}

// Insertar botón cuando se carga la página
document.addEventListener('DOMContentLoaded', insertarBotonExportarPDF);

// También insertar cuando se muestra la sección (por si acaso)
document.addEventListener('DOMContentLoaded', function() {
  // Observar cambios en la visibilidad de la sección
  const observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      if (mutation.type === 'attributes' && mutation.attributeName === 'style') {
        const dashboardSection = document.getElementById('dashboard-datos-section');
        if (dashboardSection && dashboardSection.style.display !== 'none') {
          insertarBotonExportarPDF();
        }
      }
    });
  });
  
  const dashboardSection = document.getElementById('dashboard-datos-section');
  if (dashboardSection) {
    observer.observe(dashboardSection, { attributes: true });
  }
}); 