// Cargar lugares y poblar selects dinámicamente
let lugaresData = null;

async function cargarLugares() {
  if (!lugaresData) {
    const res = await fetch('../static_lugares.json');
    lugaresData = await res.json();
  }
  return lugaresData;
}

function poblarEstados(selectEstado, onChange) {
  cargarLugares().then(data => {
    selectEstado.innerHTML = '<option value="">Seleccione Estado</option>';
    data.estados.forEach(estado => {
      const opt = document.createElement('option');
      opt.value = estado.id;
      opt.textContent = estado.nombre;
      selectEstado.appendChild(opt);
    });
    if (onChange) selectEstado.onchange = onChange;
  });
}

function poblarMunicipios(selectMunicipio, estadoId, onChange) {
  cargarLugares().then(data => {
    selectMunicipio.innerHTML = '<option value="">Seleccione Municipio</option>';
    const estado = data.estados.find(e => e.id == estadoId);
    if (estado) {
      estado.municipios.forEach(mun => {
        const opt = document.createElement('option');
        opt.value = mun.id;
        opt.textContent = mun.nombre;
        selectMunicipio.appendChild(opt);
      });
    }
    if (onChange) selectMunicipio.onchange = onChange;
  });
}

function poblarParroquias(selectParroquia, estadoId, municipioId) {
  cargarLugares().then(data => {
    selectParroquia.innerHTML = '<option value="">Seleccione Parroquia</option>';
    const estado = data.estados.find(e => e.id == estadoId);
    if (estado) {
      const municipio = estado.municipios.find(m => m.id == municipioId);
      if (municipio) {
        municipio.parroquias.forEach(parr => {
          const opt = document.createElement('option');
          opt.value = parr.id;
          opt.textContent = parr.nombre;
          selectParroquia.appendChild(opt);
        });
      }
    }
  });
}

// Exportar funciones si se usa con módulos
// export { poblarEstados, poblarMunicipios, poblarParroquias }; 