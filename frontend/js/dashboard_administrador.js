// Archivo limpio para nueva implementación de la lógica del dashboard de órdenes del administrador 

document.addEventListener('DOMContentLoaded', function() {
    const filterOrden = document.getElementById('filter-orden');
    const ordenesTitulo = document.getElementById('ordenes-titulo');
    const tablaCompra = document.getElementById('tabla-ordenes-compra');
    const tablaReposicion = document.getElementById('tabla-ordenes-reposicion');
    const tablaAnaquel = document.getElementById('tabla-ordenes-anaquel');

    const titulos = {
        reposicion: 'Órdenes de Reposición a Proveedores',
        anaquel: 'Órdenes de Reposición de Anaquel',
        compra: 'Órdenes de compra'
    };

    if (filterOrden && ordenesTitulo) {
        filterOrden.addEventListener('change', function() {
            const value = filterOrden.value;
            ordenesTitulo.textContent = titulos[value] || '';
            alternarTablasOrdenes(value);
        });
    }

    function limpiarTbodys() {
        if (tablaReposicion) {
            const tbody = tablaReposicion.querySelector('tbody');
            if (tbody) tbody.innerHTML = '';
        }
        if (tablaAnaquel) {
            const tbody = tablaAnaquel.querySelector('tbody');
            if (tbody) tbody.innerHTML = '';
        }
        if (tablaCompra) {
            const tbody = tablaCompra.querySelector('tbody');
            if (tbody) tbody.innerHTML = '';
        }
    }

    function alternarTablasOrdenes(tipo) {
        limpiarTbodys();
        if (!tipo) tipo = filterOrden.value;
        if (tipo === 'reposicion') {
            tablaReposicion.style.display = '';
            tablaAnaquel.style.display = 'none';
            tablaCompra.style.display = 'none';
            cargarOrdenesReposicion();
        } else if (tipo === 'anaquel') {
            tablaReposicion.style.display = 'none';
            tablaAnaquel.style.display = '';
            tablaCompra.style.display = 'none';
            cargarOrdenesAnaquel();
        } else if (tipo === 'compra') {
            tablaReposicion.style.display = 'none';
            tablaAnaquel.style.display = 'none';
            tablaCompra.style.display = '';
            cargarOrdenesCompra();
        }
    }

    async function cargarOrdenesCompra() {
        const tbody = tablaCompra.querySelector('tbody');
        tbody.innerHTML = '<tr><td colspan="6">Cargando órdenes de compra...</td></tr>';
        try {
            const res = await fetch('http://localhost:3000/ordenes/compra');
            const ordenes = await res.json();
            if (!Array.isArray(ordenes) || ordenes.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6">No hay órdenes de compra registradas.</td></tr>';
                return;
            }
            tbody.innerHTML = '';
            ordenes.forEach(orden => {
                tbody.innerHTML += `
                    <tr>
                        <td>${orden.id_orden_compra || orden.id_compra || ''}</td>
                        <td>${orden.cliente_nombre || orden.cliente || ''}</td>
                        <td>${orden.tipo_cliente || ''}</td>
                        <td>${orden.monto_total != null ? '$' + Number(orden.monto_total).toFixed(2) : ''}</td>
                        <td>${orden.estatus || ''}</td>
                        <td class="actions">
                            <!-- Aquí puedes agregar botones para detalles o cambiar estatus -->
                        </td>
                    </tr>
                `;
            });
        } catch (err) {
            tbody.innerHTML = '<tr><td colspan="6">Error al cargar las órdenes de compra.</td></tr>';
        }
    }

    async function cargarOrdenesReposicion() {
        const tbody = tablaReposicion.querySelector('tbody');
        tbody.innerHTML = '<tr><td colspan="7">Cargando órdenes de reposición...</td></tr>';
        try {
            const res = await fetch('http://localhost:3000/ordenes/reposicion');
            const ordenes = await res.json();
            if (!Array.isArray(ordenes) || ordenes.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7">No hay órdenes de reposición registradas.</td></tr>';
                return;
            }
            tbody.innerHTML = '';
            ordenes.forEach(orden => {
                tbody.innerHTML += `
                    <tr>
                        <td>${orden.id_orden_reposicion}</td>
                        <td>${orden.nombre_departamento || ''}</td>
                        <td>${orden.razon_social_proveedor || ''}</td>
                        <td>${orden.fecha_emision || ''}</td>
                        <td>${orden.fecha_fin || ''}</td>
                        <td>${orden.estatus_actual || ''}</td>
                        <td class="actions">
                            <!-- Aquí puedes agregar botones para detalles o cambiar estatus -->
                        </td>
                    </tr>
                `;
            });
        } catch (err) {
            tbody.innerHTML = '<tr><td colspan="7">Error al cargar las órdenes de reposición.</td></tr>';
        }
    }

    async function cargarOrdenesAnaquel() {
        const tbody = tablaAnaquel.querySelector('tbody');
        tbody.innerHTML = '<tr><td colspan="5">Cargando órdenes de anaquel...</td></tr>';
        try {
            const res = await fetch('http://localhost:3000/ordenes/anaquel');
            const ordenes = await res.json();
            if (!Array.isArray(ordenes) || ordenes.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5">No hay órdenes de anaquel registradas.</td></tr>';
                return;
            }
            tbody.innerHTML = '';
            ordenes.forEach(orden => {
                tbody.innerHTML += `
                    <tr>
                        <td>${orden.id_orden_reposicion}</td>
                        <td>${orden.fecha_hora_generacion ? orden.fecha_hora_generacion.replace('T', ' ').slice(0, 16) : ''}</td>
                        <td>${orden.ubicacion_completa || ''}</td>
                        <td>${orden.estatus_actual || ''}</td>
                        <td class="actions">
                            <!-- Aquí puedes agregar botones para detalles o cambiar estatus -->
                        </td>
                    </tr>
                `;
            });
        } catch (err) {
            tbody.innerHTML = '<tr><td colspan="5">Error al cargar las órdenes de anaquel.</td></tr>';
        }
    }

    // Inicialización al cargar la página SOLO una vez
    alternarTablasOrdenes(filterOrden.value);
}); 