# Sistema de Carrito de Compras - Documentación

## Descripción General

Este sistema permite a los usuarios agregar productos (cervezas) al carrito desde el catálogo y realizar compras. El carrito se almacena temporalmente en la base de datos y se convierte en una compra real cuando el usuario finaliza la transacción.

## Estructura del Sistema

### Tabla Principal: `Carrito_Temporal`

```sql
CREATE TABLE Carrito_Temporal (
    id_carrito SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_inventario INTEGER NOT NULL,
    cantidad INTEGER NOT NULL DEFAULT 1,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Restricciones
    CONSTRAINT fk_carrito_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_carrito_inventario FOREIGN KEY (id_inventario) REFERENCES Inventario(id_inventario) ON DELETE CASCADE,
    CONSTRAINT chk_cantidad_positiva CHECK (cantidad > 0),
    
    -- Un usuario no puede tener el mismo producto dos veces en el carrito
    UNIQUE(id_usuario, id_inventario)
);
```

## Funciones Disponibles

### 1. `agregar_al_carrito(p_id_usuario, p_id_inventario, p_cantidad)`

**Propósito**: Agrega un producto al carrito del usuario.

**Parámetros**:
- `p_id_usuario`: ID del usuario
- `p_id_inventario`: ID del producto en inventario
- `p_cantidad`: Cantidad a agregar (opcional, por defecto 1)

**Retorna**: JSON con el resultado de la operación

**Ejemplo de uso**:
```sql
SELECT agregar_al_carrito(1, 5, 2);
```

**Respuesta exitosa**:
```json
{
    "success": true,
    "message": "Producto agregado al carrito exitosamente",
    "cantidad_agregada": 2
}
```

### 2. `obtener_carrito_usuario(p_id_usuario)`

**Propósito**: Obtiene todos los productos en el carrito de un usuario.

**Parámetros**:
- `p_id_usuario`: ID del usuario

**Retorna**: Tabla con los productos del carrito

**Ejemplo de uso**:
```sql
SELECT * FROM obtener_carrito_usuario(1);
```

### 3. `actualizar_cantidad_carrito(p_id_carrito, p_nueva_cantidad)`

**Propósito**: Actualiza la cantidad de un producto específico en el carrito.

**Parámetros**:
- `p_id_carrito`: ID del item en el carrito
- `p_nueva_cantidad`: Nueva cantidad

**Retorna**: JSON con el resultado

**Ejemplo de uso**:
```sql
SELECT actualizar_cantidad_carrito(3, 5);
```

### 4. `eliminar_del_carrito(p_id_carrito)`

**Propósito**: Elimina un producto específico del carrito.

**Parámetros**:
- `p_id_carrito`: ID del item en el carrito

**Retorna**: JSON con el resultado

**Ejemplo de uso**:
```sql
SELECT eliminar_del_carrito(3);
```

### 5. `limpiar_carrito_usuario(p_id_usuario)`

**Propósito**: Elimina todos los productos del carrito de un usuario.

**Parámetros**:
- `p_id_usuario`: ID del usuario

**Retorna**: JSON con el resultado

**Ejemplo de uso**:
```sql
SELECT limpiar_carrito_usuario(1);
```

### 6. `crear_compra_desde_carrito(p_id_usuario, p_id_tienda_web, p_id_tienda_fisica)`

**Propósito**: Crea una compra completa desde el carrito del usuario.

**Parámetros**:
- `p_id_usuario`: ID del usuario
- `p_id_tienda_web`: ID de la tienda web (opcional)
- `p_id_tienda_fisica`: ID de la tienda física (opcional)

**Retorna**: JSON con el resultado de la compra

**Ejemplo de uso**:
```sql
SELECT crear_compra_desde_carrito(1, 1, NULL);
```

**Respuesta exitosa**:
```json
{
    "success": true,
    "message": "Compra realizada exitosamente",
    "id_compra": 123,
    "monto_total": 150.00,
    "productos_agregados": 3
}
```

### 7. `obtener_resumen_carrito(p_id_usuario)`

**Propósito**: Obtiene un resumen del carrito con totales y detalles.

**Parámetros**:
- `p_id_usuario`: ID del usuario

**Retorna**: Tabla con resumen del carrito

**Ejemplo de uso**:
```sql
SELECT * FROM obtener_resumen_carrito(1);
```

### 8. `verificar_stock_carrito(p_id_usuario)`

**Propósito**: Verifica el stock disponible para todos los productos en el carrito.

**Parámetros**:
- `p_id_usuario`: ID del usuario

**Retorna**: Tabla con información de stock

**Ejemplo de uso**:
```sql
SELECT * FROM verificar_stock_carrito(1);
```

## Flujo de Trabajo Típico

### 1. Agregar Productos al Carrito
```sql
-- Usuario agrega una cerveza al carrito
SELECT agregar_al_carrito(1, 5, 2);

-- Usuario agrega otra cerveza
SELECT agregar_al_carrito(1, 8, 1);
```

### 2. Ver el Carrito
```sql
-- Ver todos los productos en el carrito
SELECT * FROM obtener_carrito_usuario(1);

-- Ver resumen del carrito
SELECT * FROM obtener_resumen_carrito(1);
```

### 3. Modificar el Carrito
```sql
-- Actualizar cantidad
SELECT actualizar_cantidad_carrito(3, 5);

-- Eliminar un producto
SELECT eliminar_del_carrito(3);
```

### 4. Verificar Stock
```sql
-- Verificar que hay stock suficiente
SELECT * FROM verificar_stock_carrito(1);
```

### 5. Realizar la Compra
```sql
-- Crear la compra desde el carrito
SELECT crear_compra_desde_carrito(1, 1, NULL);
```

## Integración con el Frontend

### Endpoints Sugeridos para el Backend

```javascript
// Agregar al carrito
POST /api/carrito/agregar
{
    "id_usuario": 1,
    "id_inventario": 5,
    "cantidad": 2
}

// Obtener carrito
GET /api/carrito/usuario/1

// Actualizar cantidad
PUT /api/carrito/actualizar
{
    "id_carrito": 3,
    "nueva_cantidad": 5
}

// Eliminar del carrito
DELETE /api/carrito/eliminar/3

// Limpiar carrito
DELETE /api/carrito/limpiar/1

// Realizar compra
POST /api/carrito/comprar
{
    "id_usuario": 1,
    "id_tienda_web": 1
}

// Obtener resumen
GET /api/carrito/resumen/1

// Verificar stock
GET /api/carrito/verificar-stock/1
```

### Ejemplo de Implementación en JavaScript

```javascript
// Función para agregar al carrito
async function agregarAlCarrito(idUsuario, idInventario, cantidad = 1) {
    try {
        const response = await fetch('/api/carrito/agregar', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                id_usuario: idUsuario,
                id_inventario: idInventario,
                cantidad: cantidad
            })
        });
        
        const result = await response.json();
        
        if (result.success) {
            alert('Producto agregado al carrito');
            actualizarContadorCarrito();
        } else {
            alert('Error: ' + result.message);
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Error al agregar al carrito');
    }
}

// Función para obtener el carrito
async function obtenerCarrito(idUsuario) {
    try {
        const response = await fetch(`/api/carrito/usuario/${idUsuario}`);
        const carrito = await response.json();
        return carrito;
    } catch (error) {
        console.error('Error:', error);
        return [];
    }
}

// Función para realizar compra
async function realizarCompra(idUsuario, idTiendaWeb = null) {
    try {
        const response = await fetch('/api/carrito/comprar', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                id_usuario: idUsuario,
                id_tienda_web: idTiendaWeb
            })
        });
        
        const result = await response.json();
        
        if (result.success) {
            alert('Compra realizada exitosamente. ID de compra: ' + result.id_compra);
            // Redirigir a página de confirmación
            window.location.href = '/compra-exitosa.html';
        } else {
            alert('Error: ' + result.message);
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Error al realizar la compra');
    }
}
```

## Consideraciones Importantes

### 1. Validaciones
- Todas las funciones validan que el usuario existe
- Se verifica que el producto existe en inventario
- Se valida el stock disponible antes de agregar al carrito
- Se verifica que la cantidad sea positiva

### 2. Transacciones
- La función `crear_compra_desde_carrito` maneja transacciones automáticamente
- Si hay un error durante la compra, se hace rollback automático
- El carrito se limpia automáticamente después de una compra exitosa

### 3. Rendimiento
- Se han creado índices para optimizar las consultas
- Las funciones están optimizadas para minimizar el número de consultas

### 4. Seguridad
- Todas las funciones validan los datos de entrada
- Se manejan errores de manera segura
- No se exponen información sensible en los mensajes de error

## Instalación

Para instalar el sistema de carrito, ejecuta el archivo SQL:

```bash
psql -d tu_base_de_datos -f archivos_sql/carrito_functions.sql
```

## Pruebas

Puedes probar las funciones con estos ejemplos:

```sql
-- Crear un usuario de prueba (si no existe)
INSERT INTO Usuario (id_rol, fecha_creacion, contraseña) VALUES (2, CURRENT_DATE, 'test123');

-- Agregar productos al carrito
SELECT agregar_al_carrito(1, 1, 2);
SELECT agregar_al_carrito(1, 2, 1);

-- Ver el carrito
SELECT * FROM obtener_carrito_usuario(1);

-- Realizar compra
SELECT crear_compra_desde_carrito(1, 1, NULL);
```

## Soporte

Si tienes problemas o preguntas sobre el sistema de carrito, revisa:
1. Los logs de la base de datos
2. Los mensajes de error retornados por las funciones
3. La documentación de PostgreSQL para funciones PL/pgSQL 