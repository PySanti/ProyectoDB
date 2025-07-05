document.addEventListener("DOMContentLoaded", async () => {
  const compraId = getCompraIdFromUrlOrSession();
  if (!compraId) {
    document.getElementById("factura-resumen").innerHTML =
      "<p>No se encontró la compra.</p>";
    return;
  }
  try {
    const response = await fetch(
      `${API_BASE_URL}/carrito/resumen-por-id/${compraId}`
    );
    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.message || "No se pudo obtener la factura");
    }
    const data = await response.json();
    console.log("Datos recibidos:", data); // Para debugging
    renderFactura(data);
  } catch (err) {
    console.error("Error en factura:", err);
    document.getElementById(
      "factura-resumen"
    ).innerHTML = `<p>Error: ${err.message}</p>`;
  }
});

function getCompraIdFromUrlOrSession() {
  const params = new URLSearchParams(window.location.search);
  if (params.has("compra_id")) return params.get("compra_id");
  return sessionStorage.getItem("compra_id");
}

function renderFactura(data) {
  // Resumen general
  const resumenDiv = document.getElementById("factura-resumen");
  resumenDiv.innerHTML = `
        <h2>Resumen de la compra</h2>
        <p><strong>ID de compra:</strong> ${data.id_compra || ""}</p>
        <p><strong>Fecha:</strong> ${new Date().toLocaleString()}</p>
        <p><strong>Total de productos:</strong> ${data.total_productos || 0}</p>
        <p><strong>Total de items:</strong> ${data.total_items || 0}</p>
    `;

  // Productos
  const productosDiv = document.getElementById("factura-productos");
  if (data.items_carrito && data.items_carrito.length > 0) {
    productosDiv.innerHTML = `
            <h3>Productos</h3>
            <table class="factura-table">
                <thead><tr><th>Producto</th><th>Presentación</th><th>Cantidad</th><th>Precio Unitario</th><th>Subtotal</th></tr></thead>
                <tbody>
                    ${data.items_carrito
                      .map(
                        (p) => `
                        <tr>
                            <td>${p.nombre_cerveza || ""}</td>
                            <td>${p.nombre_presentacion || ""}</td>
                            <td>${p.cantidad}</td>
                            <td>$${
                              p.precio_unitario
                                ? p.precio_unitario.toFixed(2)
                                : "0.00"
                            }</td>
                            <td>$${
                              p.subtotal ? p.subtotal.toFixed(2) : "0.00"
                            }</td>
                        </tr>
                    `
                      )
                      .join("")}
                </tbody>
            </table>
        `;
  } else {
    productosDiv.innerHTML = "<p>No hay productos en la compra.</p>";
  }

  // Total
  const totalDiv = document.getElementById("factura-total");
  totalDiv.innerHTML = `<h3>Total: $${
    data.monto_total ? data.monto_total : "0.00"
  }</h3>`;
}
