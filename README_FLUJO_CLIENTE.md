# Flujo de Cliente - Sistema ACAUCAB

## Descripción
Se han implementado dos nuevas páginas para el flujo de atención al cliente en la tienda física:

1. **Página de Tiempo Muerto** (`tiempo-muerto.html`)
2. **Página de Validación de Cliente** (`validar-cliente.html`)

## Flujo de Navegación

### 1. Página de Tiempo Muerto
- **URL**: `frontend/html/tiempo-muerto.html`
- **Propósito**: Pantalla de bienvenida para empleados de la tienda
- **Características**:
  - Diseño atractivo con gradiente de colores ACAUCAB
  - Botón grande "Realizar Compra"
  - Reloj en tiempo real
  - Información de la tienda
  - Características de los productos

### 2. Página de Validación de Cliente
- **URL**: `frontend/html/validar-cliente.html`
- **Propósito**: Validar si el cliente está registrado o registrarlo
- **Flujo**:
  1. **Paso 1**: Ingresar cédula del cliente
  2. **Paso 2a**: Si el cliente existe → Mostrar información y continuar al catálogo
  3. **Paso 2b**: Si el cliente no existe → Mostrar formulario de registro

## Funcionalidades Implementadas

### Frontend
- ✅ Página de tiempo muerto con diseño responsive
- ✅ Validación de cédula en tiempo real
- ✅ Formulario de registro de cliente
- ✅ Navegación entre pasos
- ✅ Notificaciones de estado
- ✅ Manejo de errores
- ✅ Almacenamiento de cliente en sessionStorage

### Backend
- ✅ Endpoint para validar cédula: `POST /api/users/validate-cedula`
- ✅ Endpoint para registrar cliente: `POST /api/users/register`
- ✅ Búsqueda en clientes naturales y jurídicos
- ✅ Validación de datos
- ✅ Manejo de errores

### Base de Datos
- ✅ Función `get_cliente_natural_by_cedula()`
- ✅ Función `get_cliente_juridico_by_rif()`
- ✅ Función `create_cliente_natural()`
- ✅ Función `check_cliente_exists()`

## Archivos Creados/Modificados

### Frontend
```
frontend/html/
├── tiempo-muerto.html          (NUEVO)
└── validar-cliente.html        (NUEVO)

frontend/css/
├── tiempo-muerto.css           (NUEVO)
└── validar-cliente.css         (NUEVO)

frontend/js/
├── tiempo-muerto.js            (NUEVO)
└── validar-cliente.js          (NUEVO)
```

### Backend
```
backend/controllers/
└── userController.js           (MODIFICADO - nuevas funciones)

backend/routes/
└── userRoutes.js               (MODIFICADO - nuevas rutas)

archivos_sql/
└── client_validation_functions.sql  (NUEVO)
```

## Instalación y Configuración

### 1. Ejecutar Funciones SQL
```sql
-- Ejecutar el archivo de funciones SQL
\i archivos_sql/client_validation_functions.sql
```

### 2. Reiniciar Backend
```bash
cd backend
npm start
```

### 3. Probar el Flujo
1. Abrir `tiempo-muerto.html` en el navegador
2. Hacer clic en "Realizar Compra"
3. Probar con cédulas existentes y nuevas

## Endpoints de la API

### Validar Cédula
```http
POST /api/users/validate-cedula
Content-Type: application/json

{
  "cedula": "12345678"
}
```

**Respuesta (Cliente encontrado)**:
```json
{
  "exists": true,
  "client": {
    "id": 1,
    "cedula": "12345678",
    "nombre": "Juan Pérez",
    "email": "juan@email.com",
    "telefono": "0412-1234567",
    "tipo": "natural"
  }
}
```

**Respuesta (Cliente no encontrado)**:
```json
{
  "exists": false,
  "message": "Cliente no encontrado"
}
```

### Registrar Cliente
```http
POST /api/users/register
Content-Type: application/json

{
  "cedula": "12345678",
  "nombre": "Juan Carlos Pérez López",
  "email": "juan@email.com",
  "telefono": "0412-1234567",
  "fecha_nacimiento": "1990-01-01",
  "direccion": "Caracas, Venezuela"
}
```

**Respuesta**:
```json
{
  "message": "Cliente registrado exitosamente",
  "client": {
    "id": 1,
    "cedula": "12345678",
    "nombre": "Juan Carlos",
    "email": "juan@email.com",
    "telefono": "0412-1234567",
    "tipo": "natural"
  }
}
```

## Características Técnicas

### Validaciones
- ✅ Cédula: 7-8 dígitos numéricos
- ✅ Email: Formato válido
- ✅ Campos requeridos
- ✅ Cliente duplicado

### UX/UI
- ✅ Diseño responsive
- ✅ Animaciones suaves
- ✅ Estados de loading
- ✅ Notificaciones informativas
- ✅ Navegación intuitiva
- ✅ Accesibilidad (teclado)

### Seguridad
- ✅ Validación en frontend y backend
- ✅ Sanitización de datos
- ✅ Manejo de errores
- ✅ Prevención de duplicados

## Próximos Pasos

1. **Integración con Catálogo**: El cliente validado se almacena en sessionStorage
2. **Validación de Empleados**: Implementar autenticación para empleados
3. **Historial de Compras**: Mostrar compras anteriores del cliente
4. **Puntos de Fidelidad**: Sistema de puntos para clientes registrados
5. **Perfil de Cliente**: Permitir edición de datos del cliente

## Notas Importantes

- El sistema está diseñado para tienda física
- Los clientes se registran automáticamente si no existen
- La información del cliente se mantiene durante la sesión
- El flujo es intuitivo y rápido para uso en punto de venta 