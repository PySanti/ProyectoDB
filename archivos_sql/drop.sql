DROP TABLE Actividad CASCADE   
;

DROP TABLE Asistencia CASCADE   
;

DROP TABLE Beneficio CASCADE   
;

DROP TABLE beneficio_depto_empleado CASCADE   
;

DROP TABLE Caracteristica CASCADE   
;

DROP TABLE Caracteristica_Especifica CASCADE   
;

DROP TABLE Cargo CASCADE   
;

DROP TABLE Cerveza CASCADE   
;

DROP TABLE Cheque CASCADE   
;


DROP TABLE Cliente_Juridico CASCADE   
;

DROP TABLE Cliente_Natural CASCADE   
;

DROP TABLE Compra CASCADE   
;

DROP TABLE Compra_Estatus CASCADE   
;

DROP TABLE Correo CASCADE   
;

DROP TABLE Cuota_Afiliacion CASCADE   
;

DROP TABLE Departamento CASCADE   
;

DROP TABLE Departamento_Empleado CASCADE   
;

DROP TABLE Descuento CASCADE   
;

DROP TABLE Detalle_Compra CASCADE   
;

DROP TABLE Detalle_Orden_Reposicion CASCADE   
;

DROP TABLE Detalle_Orden_Reposicion_Anaquel CASCADE   
;

DROP TABLE Detalle_Venta_Evento CASCADE   
;

DROP TABLE Efectivo CASCADE   
;

DROP TABLE Empleado CASCADE   
;

DROP TABLE Estatus CASCADE   
;

DROP TABLE estatus_orden_anaquel CASCADE   
;

DROP TABLE Evento CASCADE   
;

DROP TABLE Evento_Proveedor CASCADE   
;



DROP TABLE Fermentacion CASCADE   
;

DROP TABLE Horario CASCADE   
;

DROP TABLE Horario_Empleado CASCADE   
;

DROP TABLE Horario_Evento CASCADE   
;

DROP TABLE Ingrediente CASCADE   
;

DROP TABLE Instruccion CASCADE   
;

DROP TABLE Inventario CASCADE   
;

DROP TABLE Inventario_Evento_Proveedor CASCADE   
;

DROP TABLE Invitado CASCADE   
;

DROP TABLE Invitado_Evento CASCADE   
;

DROP TABLE Lugar CASCADE   
;

DROP TABLE Membresia CASCADE   
;

DROP TABLE Metodo_Pago CASCADE   
;

DROP TABLE Orden_Reposicion CASCADE   
;

DROP TABLE Orden_Reposicion_Anaquel CASCADE   
;

DROP TABLE Orden_Reposicion_Estatus CASCADE   
;

DROP TABLE Pago_Compra CASCADE   
;

DROP TABLE Pago_Cuota_Afiliacion CASCADE   
;

DROP TABLE Pago_Evento CASCADE   
;

DROP TABLE Pago_Orden_Reposicion CASCADE   
;

DROP TABLE Rol_Privilegio CASCADE   
;

DROP TABLE Persona_Contacto CASCADE   
;

DROP TABLE Presentacion CASCADE   
;

DROP TABLE Presentacion_Cerveza CASCADE   
;

DROP TABLE Privilegio CASCADE   
;

DROP TABLE Promocion CASCADE   
;

DROP TABLE Proveedor CASCADE   
;

DROP TABLE Punto CASCADE   
;

DROP TABLE Punto_Cliente CASCADE   
;

DROP TABLE Receta CASCADE   
;

DROP TABLE Receta_Ingrediente CASCADE   
;

DROP TABLE Rol CASCADE   
;

DROP TABLE Tarjeta_Credito CASCADE   
;

DROP TABLE Tarjeta_Debito CASCADE   
;

DROP TABLE Tasa CASCADE   
;

DROP TABLE Telefono CASCADE   
;

DROP TABLE Tienda_Fisica CASCADE   
;

DROP TABLE Tienda_Web CASCADE   
;

DROP TABLE Tipo_Actividad CASCADE   
;

DROP TABLE Tipo_Cerveza CASCADE   
;

DROP TABLE Tipo_Invitado CASCADE   
;

DROP TABLE TipoEvento CASCADE   
;

DROP TABLE Ubicacion_Tienda CASCADE   
;

DROP TABLE Usuario CASCADE   
;

DROP TABLE Vacacion CASCADE   
;

DROP TABLE Venta_Evento CASCADE   
;

DROP FUNCTION IF EXISTS verificar_credenciales;
DROP FUNCTION IF EXISTS create_cliente_juridico;
DROP FUNCTION IF EXISTS create_cliente_natural;
DROP FUNCTION IF EXISTS create_proveedor;

DROP FUNCTION IF EXISTS get_usuarios_clientes_juridicos;
DROP FUNCTION IF EXISTS get_usuarios_clientes_naturales;
DROP FUNCTION IF EXISTS get_usuarios_empleados;
DROP FUNCTION IF EXISTS get_usuarios_proveedores;
DROP FUNCTION IF EXISTS get_roles;
DROP FUNCTION IF EXISTS create_role;
DROP FUNCTION IF EXISTS update_role_privileges;

DROP FUNCTION IF EXISTS set_rol_usuario;
DROP FUNCTION IF EXISTS create_empleado;
DROP FUNCTION IF EXISTS get_ordenes_reposicion_proveedores;
DROP FUNCTION IF EXISTS set_estatus_orden_reposicion;
DROP FUNCTION IF EXISTS get_ordenes_anaquel;
DROP FUNCTION IF EXISTS set_estatus_orden_anaquel;
DROP FUNCTION IF EXISTS get_full_location_path;
DROP FUNCTION IF exists get_detalle_orden_anaquel;