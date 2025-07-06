// eventos.js

// API_BASE_URL ya está definido en config.js
console.log('🔄 Cargando eventos.js...');
console.log('🔗 API_BASE_URL disponible:', typeof API_BASE_URL !== 'undefined' ? API_BASE_URL : 'NO DEFINIDO');

let proveedoresSeleccionados = [];
let invitadosSeleccionados = [];

// Función para inicializar el formulario de eventos
function initEventosForm() {
    cargarTiposEvento();
    cargarLugares();
    cargarInvitados();
    cargarProveedores();
    cargarCervezas();
    cargarPresentaciones();
    cargarTiposActividad();
    setTimeout(() => {
        actualizarProveedoresSeleccionados();
        actualizarInvitadosSeleccionados();
    }, 500); // Espera a que los selects estén poblados

    // Listener para el botón guardar evento
    document.getElementById('guardar-evento-btn').addEventListener('click', guardarEvento);
}

// Poblar el select de tipo de evento
function cargarTiposEvento() {
    fetch(`${API_BASE_URL}/eventos/tipos`)
        .then(res => res.json())
        .then(tipos => {
            console.log('Tipos de evento recibidos:', tipos);
            const select = document.getElementById('evento-tipo');
            if (!select) return;
            select.innerHTML = '<option value="">Seleccione Tipo de Evento</option>';
            tipos.forEach(tipo => {
                select.innerHTML += `<option value="${tipo.id_tipo_evento}">${tipo.nombre}</option>`;
            });
        })
        .catch(err => {
            console.error('Error cargando tipos de evento:', err);
        });
}

// Poblar los selects de lugar (estado, municipio, parroquia) en cascada
let eventosLugaresData = null;
function cargarLugares() {
    fetch(`${API_BASE_URL}/eventos/lugares`)
        .then(res => res.json())
        .then(data => {
            console.log('Lugares recibidos:', data);
            eventosLugaresData = data;
            poblarEstados();
        })
        .catch(err => {
            console.error('Error cargando lugares:', err);
        });
}

function poblarEstados() {
    const estadoSelect = document.getElementById('evento-estado');
    const municipioSelect = document.getElementById('evento-municipio');
    const parroquiaSelect = document.getElementById('evento-parroquia');
    if (!estadoSelect || !municipioSelect || !parroquiaSelect) return;
    estadoSelect.innerHTML = '<option value="">Seleccione Estado</option>';
    eventosLugaresData.estados.forEach(e => {
        estadoSelect.innerHTML += `<option value="${e.id_lugar}">${e.nombre}</option>`;
    });
    estadoSelect.disabled = false;
    municipioSelect.innerHTML = '<option value="">Seleccione Municipio</option>';
    municipioSelect.disabled = true;
    parroquiaSelect.innerHTML = '<option value="">Seleccione Parroquia</option>';
    parroquiaSelect.disabled = true;

    estadoSelect.onchange = function() {
        poblarMunicipios(this.value);
    };
    municipioSelect.onchange = function() {
        poblarParroquias(this.value);
    };
}

function poblarMunicipios(estadoId) {
    const municipioSelect = document.getElementById('evento-municipio');
    const parroquiaSelect = document.getElementById('evento-parroquia');
    municipioSelect.innerHTML = '<option value="">Seleccione Municipio</option>';
    parroquiaSelect.innerHTML = '<option value="">Seleccione Parroquia</option>';
    parroquiaSelect.disabled = true;
    if (!estadoId) {
        municipioSelect.disabled = true;
        return;
    }
    const municipios = eventosLugaresData.municipios.filter(m => m.estado_id == estadoId);
    municipios.forEach(m => {
        municipioSelect.innerHTML += `<option value="${m.id_lugar}">${m.nombre}</option>`;
    });
    municipioSelect.disabled = false;
}

function poblarParroquias(municipioId) {
    const parroquiaSelect = document.getElementById('evento-parroquia');
    parroquiaSelect.innerHTML = '<option value="">Seleccione Parroquia</option>';
    if (!municipioId) {
        parroquiaSelect.disabled = true;
        return;
    }
    const parroquias = eventosLugaresData.parroquias.filter(p => p.municipio_id == municipioId);
    parroquias.forEach(p => {
        parroquiaSelect.innerHTML += `<option value="${p.id_lugar}">${p.nombre}</option>`;
    });
    parroquiaSelect.disabled = false;
}

function cargarInvitados() {
    fetch(`${API_BASE_URL}/eventos/invitados`)
        .then(res => res.json())
        .then(data => {
            console.log('Invitados y tipos recibidos:', data);
            // Poblar todos los selects de invitados y tipos de invitado en el modal
            document.querySelectorAll('.invitado-select').forEach(select => {
                select.innerHTML = '<option value="">Seleccione Invitado</option>';
                data.invitados.forEach(inv => {
                    select.innerHTML += `<option value="${inv.id_invitado}">${inv.nombre}</option>`;
                });
            });
            document.querySelectorAll('.tipo-invitado-select').forEach(select => {
                select.innerHTML = '<option value="">Tipo de Invitado</option>';
                data.tipos.forEach(tipo => {
                    select.innerHTML += `<option value="${tipo.id_tipo_invitado}">${tipo.nombre}</option>`;
                });
            });
        })
        .catch(err => {
            console.error('Error cargando invitados y tipos:', err);
        });
}

function cargarProveedores() {
    fetch(`${API_BASE_URL}/eventos/proveedores`)
        .then(res => res.json())
        .then(proveedores => {
            console.log('Proveedores recibidos:', proveedores);
            document.querySelectorAll('.proveedor-select').forEach(select => {
                select.innerHTML = '<option value="">Seleccione Proveedor</option>';
                proveedores.forEach(prov => {
                    select.innerHTML += `<option value="${prov.id_proveedor}">${prov.razon_social}</option>`;
                });
            });
        })
        .catch(err => {
            console.error('Error cargando proveedores:', err);
        });
}

function cargarCervezas() {
    fetch(`${API_BASE_URL}/eventos/cervezas`)
        .then(res => res.json())
        .then(cervezas => {
            console.log('Cervezas recibidas:', cervezas);
            document.querySelectorAll('.inventario-cerveza-select').forEach(select => {
                select.innerHTML = '<option value="">Cerveza</option>';
                cervezas.forEach(cerveza => {
                    select.innerHTML += `<option value="${cerveza.id_cerveza}">${cerveza.nombre_cerveza}</option>`;
                });
            });
        })
        .catch(err => {
            console.error('Error cargando cervezas:', err);
        });
}

function cargarPresentaciones() {
    fetch(`${API_BASE_URL}/eventos/presentaciones`)
        .then(res => res.json())
        .then(presentaciones => {
            console.log('Presentaciones recibidas:', presentaciones);
            document.querySelectorAll('.inventario-presentacion-select').forEach(select => {
                select.innerHTML = '<option value="">Presentación</option>';
                presentaciones.forEach(pres => {
                    select.innerHTML += `<option value="${pres.id_presentacion}">${pres.nombre}</option>`;
                });
            });
        })
        .catch(err => {
            console.error('Error cargando presentaciones:', err);
        });
}

function cargarPresentacionesPorCerveza(idCerveza, selectElement) {
    fetch(`${API_BASE_URL}/eventos/presentaciones/${idCerveza}`)
        .then(res => res.json())
        .then(presentaciones => {
            console.log(`Presentaciones para cerveza ${idCerveza}:`, presentaciones);
            selectElement.innerHTML = '<option value="">Presentación</option>';
            presentaciones.forEach(pres => {
                selectElement.innerHTML += `<option value="${pres.id_presentacion}">${pres.nombre}</option>`;
            });
        })
        .catch(err => {
            console.error('Error cargando presentaciones por cerveza:', err);
        });
}

function cargarTiposActividad() {
    fetch(`${API_BASE_URL}/eventos/tipos-actividad`)
        .then(res => res.json())
        .then(tipos => {
            console.log('Tipos de actividad recibidos:', tipos);
            document.querySelectorAll('.tipo-actividad-select').forEach(select => {
                select.innerHTML = '<option value="">Tipo de Actividad</option>';
                tipos.forEach(tipo => {
                    select.innerHTML += `<option value="${tipo.id_tipo_actividad}">${tipo.nombre}</option>`;
                });
            });
        })
        .catch(err => {
            console.error('Error cargando tipos de actividad:', err);
        });
}

// --- Proveedores Dinámicos ---
function actualizarProveedoresSeleccionados() {
    proveedoresSeleccionados = [];
    document.querySelectorAll('.proveedor-select').forEach(select => {
        if (select.value) {
            const id = select.value;
            const text = select.options[select.selectedIndex].text;
            if (!proveedoresSeleccionados.find(p => p.id === id)) {
                proveedoresSeleccionados.push({ id, text });
            }
        }
    });
    console.log('Proveedores seleccionados:', proveedoresSeleccionados);
    actualizarSelectsProveedoresInventario();
}

function actualizarSelectsProveedoresInventario() {
    document.querySelectorAll('.inventario-proveedor-select').forEach(select => {
        const prev = select.value;
        select.innerHTML = '<option value="">Proveedor</option>';
        proveedoresSeleccionados.forEach(p => {
            select.innerHTML += `<option value="${p.id}">${p.text}</option>`;
        });
        select.value = prev;
    });
}

// --- Invitados Dinámicos ---
function actualizarInvitadosSeleccionados() {
    invitadosSeleccionados = [];
    document.querySelectorAll('.invitado-select').forEach(select => {
        if (select.value) {
            const id = select.value;
            const text = select.options[select.selectedIndex].text;
            if (!invitadosSeleccionados.find(i => i.id === id)) {
                invitadosSeleccionados.push({ id, text });
            }
        }
    });
    console.log('Invitados seleccionados:', invitadosSeleccionados);
    actualizarSelectsInvitadosActividades();
}

function actualizarSelectsInvitadosActividades() {
    document.querySelectorAll('.actividad-invitado-select').forEach(select => {
        const prev = select.value;
        select.innerHTML = '<option value="">Invitado Responsable</option>';
        invitadosSeleccionados.forEach(i => {
            select.innerHTML += `<option value="${i.id}">${i.text}</option>`;
        });
        select.value = prev;
    });
}

// --- Listeners para cambios dinámicos ---
document.addEventListener('change', function(e) {
    if (e.target.classList.contains('proveedor-select')) {
        actualizarProveedoresSeleccionados();
    }
    if (e.target.classList.contains('invitado-select')) {
        actualizarInvitadosSeleccionados();
    }
    if (e.target.classList.contains('inventario-cerveza-select')) {
        const inventarioItem = e.target.closest('.inventario-item');
        const presentacionSelect = inventarioItem.querySelector('.inventario-presentacion-select');
        if (e.target.value) {
            cargarPresentacionesPorCerveza(e.target.value, presentacionSelect);
        } else {
            presentacionSelect.innerHTML = '<option value="">Presentación</option>';
        }
    }
});

document.addEventListener('click', function(e) {
    if (e.target.classList.contains('proveedor-eliminar')) {
        setTimeout(actualizarProveedoresSeleccionados, 100);
    }
    if (e.target.classList.contains('invitado-eliminar')) {
        setTimeout(actualizarInvitadosSeleccionados, 100);
    }
    if (e.target.classList.contains('horario-eliminar')) {
        e.target.closest('.horario-item').remove();
    }
    if (e.target.id === 'agregar-horario') {
        agregarHorario();
    }
    if (e.target.id === 'agregar-invitado') {
        agregarInvitado();
    }
    if (e.target.id === 'agregar-proveedor') {
        agregarProveedor();
    }
    if (e.target.id === 'agregar-actividad') {
        agregarActividad();
    }
    if (e.target.id === 'agregar-inventario') {
        agregarInventario();
    }
});

// --- Funciones para agregar elementos dinámicamente ---
function agregarHorario() {
    const horariosLista = document.querySelector('.horarios-lista');
    const nuevoHorario = document.createElement('div');
    nuevoHorario.className = 'horario-item';
    nuevoHorario.innerHTML = `
        <select class="horario-dia-select">
            <option value="">Día de la semana</option>
            <option value="lunes">Lunes</option>
            <option value="martes">Martes</option>
            <option value="miercoles">Miércoles</option>
            <option value="jueves">Jueves</option>
            <option value="viernes">Viernes</option>
            <option value="sabado">Sábado</option>
            <option value="domingo">Domingo</option>
        </select>
        <input type="time" class="horario-inicio" placeholder="Inicio">
        <input type="time" class="horario-fin" placeholder="Fin">
        <button type="button" class="horario-eliminar"><i class="fas fa-trash-alt"></i></button>
    `;
    horariosLista.appendChild(nuevoHorario);
}

function agregarInvitado() {
    const invitadosLista = document.querySelector('.invitados-lista');
    const nuevoInvitado = document.createElement('div');
    nuevoInvitado.className = 'invitado-item';
    nuevoInvitado.innerHTML = `
        <select class="invitado-select">
            <option value="">Seleccione Invitado</option>
        </select>
        <select class="tipo-invitado-select">
            <option value="">Tipo de Invitado</option>
        </select>
        <button type="button" class="invitado-eliminar"><i class="fas fa-trash-alt"></i></button>
    `;
    invitadosLista.appendChild(nuevoInvitado);
    
    // Poblar los nuevos selects
    setTimeout(() => {
        cargarInvitados();
        actualizarInvitadosSeleccionados();
    }, 100);
}

function agregarProveedor() {
    const proveedoresLista = document.querySelector('.proveedores-lista');
    const nuevoProveedor = document.createElement('div');
    nuevoProveedor.className = 'proveedor-item';
    nuevoProveedor.innerHTML = `
        <select class="proveedor-select">
            <option value="">Seleccione Proveedor</option>
        </select>
        <button type="button" class="proveedor-eliminar"><i class="fas fa-trash-alt"></i></button>
    `;
    proveedoresLista.appendChild(nuevoProveedor);
    
    // Poblar el nuevo select
    setTimeout(() => {
        cargarProveedores();
        actualizarProveedoresSeleccionados();
    }, 100);
}

function agregarActividad() {
    const actividadesLista = document.querySelector('.actividades-lista');
    const nuevaActividad = document.createElement('div');
    nuevaActividad.className = 'actividad-item';
    nuevaActividad.innerHTML = `
        <input type="text" class="actividad-tema" placeholder="Tema de la actividad">
        <select class="tipo-actividad-select">
            <option value="">Tipo de Actividad</option>
        </select>
        <select class="actividad-invitado-select">
            <option value="">Invitado Responsable</option>
        </select>
        <button type="button" class="actividad-eliminar"><i class="fas fa-trash-alt"></i></button>
    `;
    actividadesLista.appendChild(nuevaActividad);
    
    // Poblar los nuevos selects
    setTimeout(() => {
        cargarTiposActividad();
        actualizarSelectsInvitadosActividades();
    }, 100);
}

function agregarInventario() {
    const inventarioLista = document.querySelector('.inventario-lista');
    const nuevoInventario = document.createElement('div');
    nuevoInventario.className = 'inventario-item';
    nuevoInventario.innerHTML = `
        <select class="inventario-cerveza-select">
            <option value="">Cerveza</option>
        </select>
        <select class="inventario-presentacion-select">
            <option value="">Presentación</option>
        </select>
        <select class="inventario-proveedor-select">
            <option value="">Proveedor</option>
        </select>
        <input type="number" class="inventario-cantidad" min="1" value="1" placeholder="Cantidad">
        <button type="button" class="inventario-eliminar"><i class="fas fa-trash-alt"></i></button>
    `;
    inventarioLista.appendChild(nuevoInventario);
    
    // Poblar los nuevos selects
    setTimeout(() => {
        cargarCervezas();
        actualizarSelectsProveedoresInventario();
    }, 100);
}

// --- Función para guardar evento completo ---
function guardarEvento() {
    try {
        console.log('Iniciando guardado de evento...');
        
        // Recopilar datos básicos del evento
        const datosEvento = {
            nombre: document.getElementById('evento-nombre').value,
            descripcion: document.getElementById('evento-descripcion').value,
            fecha_inicio: document.getElementById('evento-fecha-inicio').value,
            fecha_fin: document.getElementById('evento-fecha-fin').value,
            lugar_id_lugar: document.getElementById('evento-parroquia').value,
            n_entradas_vendidas: parseInt(document.getElementById('evento-entradas-vendidas').value) || 0,
            precio_unitario_entrada: parseFloat(document.getElementById('evento-precio-entrada').value),
            tipo_evento_id: parseInt(document.getElementById('evento-tipo').value)
        };

        // Validar campos requeridos
        const camposRequeridos = ['nombre', 'descripcion', 'fecha_inicio', 'fecha_fin', 'lugar_id_lugar', 'precio_unitario_entrada', 'tipo_evento_id'];
        for (const campo of camposRequeridos) {
            if (!datosEvento[campo] || datosEvento[campo] === '') {
                throw new Error(`El campo ${campo} es requerido`);
            }
        }

        // Recopilar horarios
        const horarios = [];
        document.querySelectorAll('.horario-item').forEach(item => {
            const dia = item.querySelector('.horario-dia-select').value;
            const horaInicio = item.querySelector('.horario-inicio').value;
            const horaFin = item.querySelector('.horario-fin').value;
            
            if (dia && horaInicio && horaFin) {
                horarios.push({
                    dia: dia,
                    hora_inicio: horaInicio,
                    hora_fin: horaFin
                });
            }
        });

        // Recopilar invitados
        const invitados = [];
        document.querySelectorAll('.invitado-item').forEach(item => {
            const idInvitado = item.querySelector('.invitado-select').value;
            const idTipoInvitado = item.querySelector('.tipo-invitado-select').value;
            
            if (idInvitado && idTipoInvitado) {
                invitados.push({
                    id_invitado: parseInt(idInvitado),
                    id_tipo_invitado: parseInt(idTipoInvitado)
                });
            }
        });

        // Recopilar proveedores
        const proveedores = [];
        document.querySelectorAll('.proveedor-item').forEach(item => {
            const idProveedor = item.querySelector('.proveedor-select').value;
            
            if (idProveedor) {
                proveedores.push({
                    id_proveedor: parseInt(idProveedor)
                });
            }
        });

        // Recopilar actividades
        const actividades = [];
        document.querySelectorAll('.actividad-item').forEach(item => {
            const tema = item.querySelector('.actividad-tema').value;
            const idTipoActividad = item.querySelector('.tipo-actividad-select').value;
            const idInvitado = item.querySelector('.actividad-invitado-select').value;
            
            if (tema && idTipoActividad && idInvitado) {
                actividades.push({
                    tema: tema,
                    id_tipo_actividad: parseInt(idTipoActividad),
                    id_invitado: parseInt(idInvitado)
                });
            }
        });

        // Recopilar inventario
        const inventario = [];
        document.querySelectorAll('.inventario-item').forEach(item => {
            const idCerveza = item.querySelector('.inventario-cerveza-select').value;
            const idPresentacion = item.querySelector('.inventario-presentacion-select').value;
            const idProveedor = item.querySelector('.inventario-proveedor-select').value;
            const cantidad = parseInt(item.querySelector('.inventario-cantidad').value);
            
            if (idCerveza && idPresentacion && idProveedor && cantidad > 0) {
                inventario.push({
                    id_cerveza: parseInt(idCerveza),
                    id_presentacion: parseInt(idPresentacion),
                    id_proveedor: parseInt(idProveedor),
                    cantidad: cantidad
                });
            }
        });

        // Construir objeto completo
        const datosCompletos = {
            ...datosEvento,
            horarios: horarios,
            invitados: invitados,
            proveedores: proveedores,
            actividades: actividades,
            inventario: inventario
        };

        console.log('Datos a enviar:', datosCompletos);

        // Enviar al backend
        fetch(`${API_BASE_URL}/eventos/crear`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(datosCompletos)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Evento creado exitosamente!');
                console.log('Evento creado con ID:', data.id_evento);
                // Cerrar modal y limpiar formulario
                cerrarModalEvento();
                limpiarFormularioEvento();
            } else {
                throw new Error(data.error || 'Error al crear evento');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error al crear evento: ' + error.message);
        });

    } catch (error) {
        console.error('Error en validación:', error);
        alert('Error: ' + error.message);
    }
}

// --- Funciones auxiliares ---
function cerrarModalEvento() {
    const modal = document.getElementById('nuevo-evento-modal');
    if (modal) {
        modal.classList.remove('active');
    }
}

function limpiarFormularioEvento() {
    // Limpiar campos básicos
    document.getElementById('evento-nombre').value = '';
    document.getElementById('evento-descripcion').value = '';
    document.getElementById('evento-fecha-inicio').value = '';
    document.getElementById('evento-fecha-fin').value = '';
    document.getElementById('evento-estado').value = '';
    document.getElementById('evento-municipio').value = '';
    document.getElementById('evento-parroquia').value = '';
    document.getElementById('evento-entradas-vendidas').value = '0';
    document.getElementById('evento-precio-entrada').value = '';
    document.getElementById('evento-tipo').value = '';

    // Limpiar listas dinámicas
    document.querySelector('.horarios-lista').innerHTML = `
        <div class="horario-item">
            <select class="horario-dia-select">
                <option value="">Día de la semana</option>
                <option value="lunes">Lunes</option>
                <option value="martes">Martes</option>
                <option value="miercoles">Miércoles</option>
                <option value="jueves">Jueves</option>
                <option value="viernes">Viernes</option>
                <option value="sabado">Sábado</option>
                <option value="domingo">Domingo</option>
            </select>
            <input type="time" class="horario-inicio" placeholder="Inicio">
            <input type="time" class="horario-fin" placeholder="Fin">
            <button type="button" class="horario-eliminar"><i class="fas fa-trash-alt"></i></button>
        </div>
    `;

    document.querySelector('.invitados-lista').innerHTML = `
        <div class="invitado-item">
            <select class="invitado-select">
                <option value="">Seleccione Invitado</option>
            </select>
            <select class="tipo-invitado-select">
                <option value="">Tipo de Invitado</option>
            </select>
            <button type="button" class="invitado-eliminar"><i class="fas fa-trash-alt"></i></button>
        </div>
    `;

    document.querySelector('.proveedores-lista').innerHTML = `
        <div class="proveedor-item">
            <select class="proveedor-select">
                <option value="">Seleccione Proveedor</option>
            </select>
            <button type="button" class="proveedor-eliminar"><i class="fas fa-trash-alt"></i></button>
        </div>
    `;

    document.querySelector('.actividades-lista').innerHTML = `
        <div class="actividad-item">
            <input type="text" class="actividad-tema" placeholder="Tema de la actividad">
            <select class="tipo-actividad-select">
                <option value="">Tipo de Actividad</option>
            </select>
            <select class="actividad-invitado-select">
                <option value="">Invitado Responsable</option>
            </select>
            <button type="button" class="actividad-eliminar"><i class="fas fa-trash-alt"></i></button>
        </div>
    `;

    document.querySelector('.inventario-lista').innerHTML = `
        <div class="inventario-item">
            <select class="inventario-cerveza-select">
                <option value="">Cerveza</option>
            </select>
            <select class="inventario-presentacion-select">
                <option value="">Presentación</option>
            </select>
            <select class="inventario-proveedor-select">
                <option value="">Proveedor</option>
            </select>
            <input type="number" class="inventario-cantidad" min="1" value="1" placeholder="Cantidad">
            <button type="button" class="inventario-eliminar"><i class="fas fa-trash-alt"></i></button>
        </div>
    `;

    // Repoblar selects
    setTimeout(() => {
        cargarTiposEvento();
        cargarLugares();
        cargarInvitados();
        cargarProveedores();
        cargarCervezas();
        cargarTiposActividad();
    }, 100);
}

// =================================================================
// CARGAR EVENTOS DESDE LA BASE DE DATOS
// =================================================================
async function loadEventos() {
    try {
        const response = await fetch(`${API_BASE_URL}/eventos`);
        const data = await response.json();
        
        if (data.success) {
            renderEventos(data.eventos);
        } else {
            console.error('Error al cargar eventos:', data.message);
            showNotification('Error al cargar eventos', 'error');
        }
    } catch (error) {
        console.error('Error de conexión:', error);
        showNotification('Error de conexión al cargar eventos', 'error');
    }
}

// =================================================================
// RENDERIZAR EVENTOS EN LA TABLA
// =================================================================
function renderEventos(eventos) {
    const tbody = document.querySelector('#eventos-section .data-table tbody');
    if (!tbody) return;
    
    tbody.innerHTML = '';
    
    if (eventos.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center">No hay eventos registrados</td></tr>';
        return;
    }
    
    eventos.forEach(evento => {
        const row = document.createElement('tr');
        row.setAttribute('data-event-id', evento.id_evento);
        
        // Formatear fechas
        const fechaInicio = new Date(evento.fecha_inicio);
        const fechaFin = new Date(evento.fecha_fin);
        const fechaInicioFormateada = fechaInicio.toLocaleDateString('es-ES') + ' ' + fechaInicio.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' });
        const fechaFinFormateada = fechaFin.toLocaleDateString('es-ES') + ' ' + fechaFin.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' });
        
        // Formatear precio
        const precioFormateado = `$${parseFloat(evento.precio_unitario_entrada).toFixed(2)}`;
        
        row.innerHTML = `
            <td>EVT${String(evento.id_evento).padStart(3, '0')}</td>
            <td>${evento.nombre}</td>
            <td>${fechaInicioFormateada}</td>
            <td>${fechaFinFormateada}</td>
            <td>${evento.n_entradas_vendidas || 0}</td>
            <td>${precioFormateado}</td>
            <td class="actions">
                <button class="action-btn register" title="Registrar compra" onclick="registrarCompra(${evento.id_evento})">
                    <i class="fas fa-shopping-cart"></i>
                </button>
            </td>
        `;
        
        tbody.appendChild(row);
    });
}

// =================================================================
// REGISTRAR COMPRA
// =================================================================
function registrarCompra(id) {
    console.log('Registrar compra para evento:', id);
    
    // Buscar el nombre del evento en la tabla
    const eventoRow = document.querySelector(`tr[data-event-id="${id}"]`);
    let nombreEvento = 'Evento #' + id; // Valor por defecto
    
    if (eventoRow) {
        const nombreCell = eventoRow.querySelector('td:nth-child(2)'); // La segunda columna es el nombre
        if (nombreCell) {
            nombreEvento = nombreCell.textContent.trim();
        }
    }
    
    // Guardar información del evento en sessionStorage para usar en el flujo de venta
    sessionStorage.setItem('eventoVenta', JSON.stringify({
        id_evento: id,
        nombre_evento: nombreEvento,
        tipo_venta: 'eventos'
    }));
    
    console.log('Información del evento guardada:', {
        id_evento: id,
        nombre_evento: nombreEvento,
        tipo_venta: 'eventos'
    });
    
    // Redirigir a tiempo-muerto.html para validar cliente
    window.location.href = '../html/tiempo-muerto.html';
}

// =================================================================
// MOSTRAR NOTIFICACIÓN
// =================================================================
function showNotification(message, type = 'info') {
    // Crear elemento de notificación
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <span class="notification-message">${message}</span>
            <button class="notification-close" onclick="this.parentElement.parentElement.remove()">
                <i class="fas fa-times"></i>
            </button>
        </div>
    `;
    
    // Agregar al DOM
    const container = document.querySelector('.dashboard-content') || document.body;
    container.appendChild(notification);
    
    // Auto-remover después de 5 segundos
    setTimeout(() => {
        if (notification.parentElement) {
            notification.remove();
        }
    }, 5000);
}

// =================================================================
// INICIALIZACIÓN
// =================================================================

// Cargar eventos cuando se carga la página
document.addEventListener('DOMContentLoaded', function() {
    // Solo cargar eventos si estamos en la sección de eventos
    const eventosSection = document.getElementById('eventos-section');
    if (eventosSection && eventosSection.classList.contains('active')) {
        loadEventos();
    }
    
    // Escuchar cambios de sección
    document.querySelectorAll('.sidebar-nav a').forEach(link => {
        link.addEventListener('click', function(e) {
            const sectionId = this.getAttribute('data-section');
            if (sectionId === 'eventos') {
                // Cargar eventos cuando se activa la sección
                setTimeout(loadEventos, 100);
            }
        });
    });
});

// Exportar funciones para uso global
window.loadEventos = loadEventos;
window.registrarCompra = registrarCompra;
window.initEventosForm = initEventosForm;
window.guardarEvento = guardarEvento;

// Log para verificar que el script se cargó
console.log('✅ eventos.js cargado correctamente');
console.log('✅ API_BASE_URL:', API_BASE_URL);
console.log('✅ Funciones disponibles:', {
    loadEventos: typeof loadEventos,
    registrarCompra: typeof registrarCompra,
    initEventosForm: typeof initEventosForm,
    guardarEvento: typeof guardarEvento
});
console.log('✅ Funciones en window:', {
    loadEventos: typeof window.loadEventos,
    registrarCompra: typeof window.registrarCompra,
    initEventosForm: typeof window.initEventosForm,
    guardarEvento: typeof window.guardarEvento
}); 