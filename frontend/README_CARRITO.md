# Sistema de Carrito de Compras - ACAUCAB

## Descripción

Este sistema implementa un carrito de compras completo para la tienda de cervezas artesanales ACAUCAB, utilizando las tablas existentes de la base de datos sin crear nuevas tablas.

## Arquitectura

### Backend (SQL)
- **Archivo**: `archivos_sql/carrito_functions.sql`
- **Enfoque**: Utiliza las tablas existentes:
  - `Compra` - Representa el carrito con status "Pendiente"
  - `Detalle_Compra` - Items del carrito
  - `Compra_Estatus` - Control de estados

### Frontend (JavaScript)
- **Archivo principal**: `frontend/js/cart.js`
- **Catálogo dinámico**: `frontend/js/catalog.js`
- **Estilos**: `frontend/css/notifications.css`, `frontend/css/catalog-dynamic.css`

## Funcionalidades Implementadas

### 1. Gestión del Carrito
- ✅ Agregar productos al carrito
- ✅ Actualizar cantidades
- ✅ Eliminar productos individuales
- ✅ Limpiar carrito completo
- ✅ Obtener resumen del carrito
- ✅ Verificar stock disponible

### 2. Interfaz de Usuario
- ✅ Notificaciones en tiempo real
- ✅ Indicador de carga
- ✅ Contador de items en el header
- ✅ Carrito vacío con mensaje informativo
- ✅ Botones de acción intuitivos

### 3. Catálogo Dinámico
- ✅ Carga de productos desde la API
- ✅ Filtros de búsqueda
- ✅ Filtros por categoría, precio y disponibilidad
- ✅ Paginación dinámica
- ✅ Estados de productos (agotado, oferta, nuevo)

## Configuración

### 1. Base de Datos
```sql
-- Ejecutar las funciones del carrito
\i archivos_sql/carrito_functions.sql

-- Insertar el status "Pendiente" si no existe
INSERT INTO Estatus (id_estatus, nombre_estatus) 
VALUES (13, 'Pendiente') 
ON CONFLICT (id_estatus) DO NOTHING;
```

### 2. Backend API
Asegúrate de que tu backend tenga los siguientes endpoints:
- `POST /api/carrito/agregar`
- `GET /api/carrito/usuario/{id_usuario}`
- `PUT /api/carrito/actualizar`
- `DELETE /api/carrito/eliminar`
- `DELETE /api/carrito/limpiar/{id_usuario}`
- `GET /api/carrito/resumen/{id_usuario}`
- `GET /api/carrito/verificar-stock/{id_usuario}`
- `GET /api/productos`

### 3. Frontend
Los archivos HTML ya incluyen los scripts necesarios:
- `catalog.html` - Catálogo con botones de agregar al carrito
- `cart.html` - Vista del carrito con gestión completa

## Uso

### 1. Agregar Productos
```javascript
// Desde el catálogo
addToCart(productId, quantity);

// Ejemplo
addToCart(1, 2); // Agregar 2 unidades del producto ID 1
```

### 2. Gestionar Carrito
```javascript
// Actualizar cantidad
updateQuantity(productId, newQuantity);

// Eliminar producto
removeFromCart(productId);

// Limpiar carrito
clearCart();

// Cargar carrito
loadCart();
```

### 3. Obtener Información
```javascript
// Resumen del carrito
const summary = await getCartSummary();

// Verificar stock
const stockData = await verifyCartStock();
```

## Estructura de Datos

### Producto en el Carrito
```json
{
  "id_inventario": 1,
  "nombre_cerveza": "Destilo Amber Ale",
  "nombre_presentacion": "Amber Ale",
  "precio_unitario": 8.50,
  "cantidad": 2,
  "stock_disponible": 10
}
```

### Resumen del Carrito
```json
{
  "id_compra": 123,
  "monto_total": 17.00,
  "cantidad_items": 2,
  "items": [...]
}
```

## Características Técnicas

### Seguridad
- Validación de stock antes de agregar
- Verificación de cantidades máximas
- Prevención de duplicados

### Rendimiento
- Carga asíncrona de productos
- Paginación del catálogo
- Actualizaciones optimizadas del carrito

### UX/UI
- Notificaciones no intrusivas
- Estados de carga claros
- Diseño responsive
- Animaciones suaves

## Personalización

### Cambiar ID de Usuario
En `frontend/js/cart.js`:
```javascript
let currentUserId = 1; // Cambiar por el ID del usuario logueado
```

### Modificar API Base URL
En `frontend/js/cart.js` y `frontend/js/catalog.js`:
```javascript
const API_BASE_URL = 'http://localhost:3000/api'; // Ajustar según tu backend
```

### Personalizar Notificaciones
En `frontend/js/cart.js`:
```javascript
function showNotification(message, type = 'info') {
    // Personalizar estilos y comportamiento
}
```

## Troubleshooting

### Problemas Comunes

1. **Error de CORS**
   - Asegúrate de que tu backend permita requests desde el frontend
   - Configura los headers apropiados

2. **Productos no se cargan**
   - Verifica que el endpoint `/api/productos` esté funcionando
   - Revisa la consola del navegador para errores

3. **Carrito no se actualiza**
   - Verifica que el `currentUserId` esté configurado correctamente
   - Asegúrate de que las funciones SQL estén ejecutadas

4. **Notificaciones no aparecen**
   - Verifica que `notifications.css` esté incluido
   - Revisa que no haya conflictos de CSS

### Debug
```javascript
// Habilitar logs detallados
console.log('Estado del carrito:', cartState);
console.log('Productos cargados:', catalogState.products);
```

## Próximas Mejoras

- [ ] Integración con sistema de usuarios
- [ ] Persistencia del carrito en localStorage
- [ ] Cupones de descuento
- [ ] Wishlist de productos
- [ ] Historial de compras
- [ ] Recomendaciones de productos

## Soporte

Para problemas o preguntas sobre el sistema de carrito, revisa:
1. Los logs de la consola del navegador
2. Los logs del backend
3. La documentación de las funciones SQL
4. Los comentarios en el código JavaScript 