ALTER TABLE Actividad 
    ADD CONSTRAINT Actividad_Invitado_Evento_FK FOREIGN KEY 
    ( 
     Invitado_Evento_Invitado_id_invitado,
     Invitado_Evento_Evento_id_evento
    ) 
    REFERENCES Invitado_Evento 
    ( 
     id_invitado,
     id_evento
    ) 
;

ALTER TABLE Actividad 
    ADD CONSTRAINT Actividad_Tipo_Actividad_FK FOREIGN KEY 
    ( 
     Tipo_Actividad_id_tipo_actividad
    ) 
    REFERENCES Tipo_Actividad 
    ( 
     id_tipo_actividad
    ) 
;

ALTER TABLE Asistencia 
    ADD CONSTRAINT Asistencia_Empleado_FK FOREIGN KEY 
    ( 
     Empleado_id_empleado
    ) 
    REFERENCES Empleado 
    ( 
     id_empleado
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Beneficio_Depto_Empleado 
    ADD CONSTRAINT Beneficio_Departamento_Empleado_Beneficio_FK FOREIGN KEY 
    ( 
     id_beneficio
    ) 
    REFERENCES Beneficio 
    ( 
     id_beneficio
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Beneficio_Depto_Empleado 
    ADD CONSTRAINT Beneficio_Departamento_Empleado_Departamento_Empleado_FK FOREIGN KEY 
    ( 
     id_empleado,
     id_departamento
    ) 
    REFERENCES Departamento_Empleado 
    ( 
     id_empleado,
     id_departamento
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Caracteristica_Especifica 
    ADD CONSTRAINT Caracteristica_Especifica_Caracteristica_FK FOREIGN KEY 
    ( 
     id_caracteristica
    ) 
    REFERENCES Caracteristica 
    ( 
     id_caracteristica
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Caracteristica_Especifica 
    ADD CONSTRAINT Caracteristica_Especifica_Tipo_Cerveza_FK FOREIGN KEY 
    ( 
     id_tipo_cerveza
    ) 
    REFERENCES Tipo_Cerveza 
    ( 
     id_tipo_cerveza
    ) 
;

ALTER TABLE Cerveza 
    ADD CONSTRAINT Cerveza_Proveedor_FK FOREIGN KEY 
    ( 
     id_proveedor
    ) 
    REFERENCES Proveedor 
    ( 
     id_proveedor
    ) 
;

ALTER TABLE Cerveza 
    ADD CONSTRAINT Cerveza_Tipo_Cerveza_FK FOREIGN KEY 
    ( 
     id_tipo_cerveza
    ) 
    REFERENCES Tipo_Cerveza 
    ( 
     id_tipo_cerveza
    ) 
;

ALTER TABLE Cheque 
    ADD CONSTRAINT Cheque_Metodo_Pago_FK FOREIGN KEY 
    ( 
     id_metodo
    ) 
    REFERENCES Metodo_Pago 
    ( 
     id_metodo
    ) 
;



ALTER TABLE Cliente_Juridico 
    ADD CONSTRAINT Cliente_Juridico_Lugar_FK FOREIGN KEY 
    ( 
     Lugar_id_lugar
    ) 
    REFERENCES Lugar 
    ( 
     id_lugar
    ) 
;

ALTER TABLE Cliente_Juridico 
    ADD CONSTRAINT Cliente_Juridico_Lugar_FKv2 FOREIGN KEY 
    ( 
     Lugar_id_lugar2
    ) 
    REFERENCES Lugar 
    ( 
     id_lugar
    ) 
;



ALTER TABLE Cliente_Natural 
    ADD CONSTRAINT Cliente_Natural_Lugar_FK FOREIGN KEY 
    ( 
     Lugar_id_lugar
    ) 
    REFERENCES Lugar 
    ( 
     id_lugar
    ) 
;

ALTER TABLE Compra 
    ADD CONSTRAINT Compra_Cliente_N_FK FOREIGN KEY 
    ( 
     id_cliente_natural
    ) 
    REFERENCES Cliente_Natural
    ( 
     id_cliente
    ) 
;
ALTER TABLE Compra 
    ADD CONSTRAINT Compra_Cliente_J_FK FOREIGN KEY 
    ( 
     id_cliente_juridico
    ) 
    REFERENCES Cliente_Juridico
    ( 
     id_cliente
    ) 
;


ALTER TABLE Compra_Estatus 
    ADD CONSTRAINT Compra_Estatus_Compra_FK FOREIGN KEY 
    ( 
     Compra_id_compra
    ) 
    REFERENCES Compra 
    ( 
     id_compra
    ) 
;

ALTER TABLE Compra_Estatus 
    ADD CONSTRAINT Compra_Estatus_Estatus_FK FOREIGN KEY 
    ( 
     estatus_id_estatus
    ) 
    REFERENCES Estatus 
    ( 
     id_estatus
    ) 
;

ALTER TABLE Compra 
    ADD CONSTRAINT Compra_Tienda_Fisica_FK FOREIGN KEY 
    ( 
     tienda_fisica_id_tienda
    ) 
    REFERENCES Tienda_Fisica 
    ( 
     id_tienda_fisica
    ) 
;

ALTER TABLE Compra 
    ADD CONSTRAINT Compra_Tienda_Web_FK FOREIGN KEY 
    ( 
     tienda_web_id_tienda
    ) 
    REFERENCES Tienda_Web 
    ( 
     id_tienda_web
    ) 
;

ALTER TABLE Compra 
    ADD CONSTRAINT Compra_Usuario_FK FOREIGN KEY 
    ( 
     Usuario_id_usuario
    ) 
    REFERENCES Usuario 
    ( 
     id_usuario
    ) 
;

ALTER TABLE Correo 
    ADD CONSTRAINT Correo_Cliente_N_FK FOREIGN KEY 
    ( 
     id_cliente_natural
    ) 
    REFERENCES Cliente_Natural 
    ( 
     id_cliente
    ) 
;
ALTER TABLE Correo 
    ADD CONSTRAINT Correo_Cliente_J_FK FOREIGN KEY 
    ( 
     id_cliente_juridico
    ) 
    REFERENCES Cliente_Juridico
    ( 
     id_cliente
    ) 
;

ALTER TABLE Correo 
    ADD CONSTRAINT Correo_Proveedor_FK FOREIGN KEY 
    ( 
     id_proveedor_proveedor
    ) 
    REFERENCES Proveedor 
    ( 
     id_proveedor
    ) 
;

ALTER TABLE Correo 
    ADD CONSTRAINT Correo_Empleado_FK FOREIGN KEY 
    ( 
     id_empleado
    ) 
    REFERENCES Empleado 
    ( 
     id_empleado
    ) 
;

ALTER TABLE Cuota_Afiliacion 
    ADD CONSTRAINT Cuota_Afiliacion_Membresia_FK FOREIGN KEY 
    ( 
     Membresia_id_membresia
    ) 
    REFERENCES Membresia 
    ( 
     id_membresia
    ) 
;

ALTER TABLE Departamento_Empleado 
    ADD CONSTRAINT Departamento_Empleado_Cargo_FK FOREIGN KEY 
    ( 
     id_cargo
    ) 
    REFERENCES Cargo 
    ( 
     id_cargo
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Departamento_Empleado 
    ADD CONSTRAINT Departamento_Empleado_Departamento_FK FOREIGN KEY 
    ( 
     id_departamento
    ) 
    REFERENCES Departamento 
    ( 
     id_departamento
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Departamento_Empleado 
    ADD CONSTRAINT Departamento_Empleado_Empleado_FK FOREIGN KEY 
    ( 
     id_empleado
    ) 
    REFERENCES Empleado 
    ( 
     id_empleado
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Descuento 
    ADD CONSTRAINT Descuento_Presentacion_Cerveza_FK FOREIGN KEY 
    (
     id_presentacion,
     id_cerveza
    ) 
    REFERENCES Presentacion_Cerveza 
    ( 
     id_presentacion,
     id_cerveza
    ) 
;

ALTER TABLE Descuento 
    ADD CONSTRAINT Descuento_Promocion_FK FOREIGN KEY 
    ( 
     id_promocion
    ) 
    REFERENCES Promocion 
    ( 
     id_promocion
    ) 
;

ALTER TABLE Detalle_Compra 
    ADD CONSTRAINT Detalle_Compra_Compra_FK FOREIGN KEY 
    ( 
     id_compra
    ) 
    REFERENCES Compra 
    ( 
     id_compra
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Inventario 
    ADD CONSTRAINT Inventario_Presentacion_Cerveza_FK FOREIGN KEY 
    ( 
     id_presentacion,
     id_cerveza
    ) 
    REFERENCES Presentacion_Cerveza 
    ( 
     id_presentacion,
     id_cerveza
    ) 
;



ALTER TABLE Inventario 
    ADD CONSTRAINT Inventario_Tienda_Fisica_FK FOREIGN KEY 
    ( 
     id_tienda_fisica
    ) 
    REFERENCES Tienda_Fisica 
    ( 
     id_tienda_fisica
    ) 
;

ALTER TABLE Inventario 
    ADD CONSTRAINT Inventario_Tienda_Web_FK FOREIGN KEY 
    ( 
     id_tienda_web
    ) 
    REFERENCES Tienda_Web 
    ( 
     id_tienda_web
    ) 
;

ALTER TABLE Inventario 
    ADD CONSTRAINT Inventario_Ubicacion_Tienda_FK FOREIGN KEY 
    ( 
     id_ubicacion
    ) 
    REFERENCES Ubicacion_Tienda 
    ( 
     id_ubicacion
    ) 
;


ALTER TABLE Detalle_Compra 
    ADD CONSTRAINT Detalle_Compra_Inventario_FK FOREIGN KEY 
    ( 
        id_inventario
    ) 
    REFERENCES Inventario 
    ( 
     id_inventario
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Detalle_Orden_Reposicion_Anaquel 
    ADD CONSTRAINT Detalle_Orden_Reposicion_Anaquel_Inventario_FK FOREIGN KEY 
    ( 
     id_inventario
    ) 
    REFERENCES Inventario 
    ( 
     id_inventario
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Detalle_Orden_Reposicion_Anaquel 
    ADD CONSTRAINT Detalle_Orden_Reposicion_Anaquel_Orden_Reposicion_Anaquel_FK FOREIGN KEY 
    ( 
     id_orden_reposicion
    ) 
    REFERENCES Orden_Reposicion_Anaquel 
    ( 
     id_orden_reposicion
    ) 
;


ALTER TABLE orden_reposicion 
ADD CONSTRAINT orden_reposicion_unq 
UNIQUE (id_orden_reposicion, id_proveedor, id_departamento);

ALTER TABLE Orden_Reposicion 
    ADD CONSTRAINT Orden_Reposicion_Depto_FK FOREIGN KEY 
    ( 
     id_departamento
    ) 
    REFERENCES Departamento 
    ( 
     id_departamento
    ) 
;
ALTER TABLE Orden_Reposicion 
    ADD CONSTRAINT Orden_Reposicion_Proveedor_FK FOREIGN KEY 
    ( 
     id_proveedor
    ) 
    REFERENCES Proveedor 
    ( 
     id_proveedor
    ) 
;
ALTER TABLE Detalle_Orden_Reposicion 
    ADD CONSTRAINT "FK para detalle orden_repo" FOREIGN KEY 
    ( 
     id_orden_reposicion,
     id_proveedor,
     id_departamento
    ) 
    REFERENCES Orden_Reposicion 
    ( 
     id_orden_reposicion,
     id_proveedor,
     id_departamento
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Detalle_Orden_Reposicion 
    ADD CONSTRAINT Detalle_Orden_Reposicion_Presentacion_Cerveza_FK FOREIGN KEY 
    ( 
     id_presentacion,
     id_cerveza
    ) 
    REFERENCES Presentacion_Cerveza 
    ( 
     id_presentacion,
     id_cerveza
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Detalle_Venta_Evento 
    ADD CONSTRAINT Detalle_Venta_Evento_Inventario_Evento_Proveedor_FK FOREIGN KEY 
    ( 
     id_proveedor,
     id_evento,
     id_tipo_cerveza,
     id_presentacion,
     id_cerveza
    ) 
    REFERENCES Inventario_Evento_Proveedor 
    ( 
     id_proveedor,
     id_evento,
     id_tipo_cerveza,
     id_presentacion,
     id_cerveza
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Detalle_Venta_Evento 
    ADD CONSTRAINT Detalle_Venta_Evento_Venta_Evento_FK FOREIGN KEY 
    ( 
     id_evento,
     id_cliente_natural
    ) 
    REFERENCES Venta_Evento 
    ( 
     evento_id,
     id_cliente_natural
    ) 
;

ALTER TABLE Efectivo 
    ADD CONSTRAINT Efectivo_Metodo_Pago_FK FOREIGN KEY 
    ( 
     id_metodo
    ) 
    REFERENCES Metodo_Pago 
    ( 
     id_metodo
    ) 
;

ALTER TABLE Empleado 
    ADD CONSTRAINT Empleado_Lugar_FK FOREIGN KEY 
    ( 
     Lugar_id_lugar
    ) 
    REFERENCES Lugar 
    ( 
     id_lugar
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Estatus_Orden_Anaquel 
    ADD CONSTRAINT Estatus_Orden_Reposicion_Anaquel_Estatus_FK FOREIGN KEY 
    ( 
     id_estatus
    ) 
    REFERENCES Estatus 
    ( 
     id_estatus
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Estatus_Orden_Anaquel 
    ADD CONSTRAINT Estatus_Orden_Reposicion_Anaquel_Orden_Reposicion_Anaquel_FK FOREIGN KEY 
    ( 
     id_orden_reposicion
    ) 
    REFERENCES Orden_Reposicion_Anaquel 
    ( 
     id_orden_reposicion
    ) 
;

ALTER TABLE Evento 
    ADD CONSTRAINT Evento_Lugar_FK FOREIGN KEY 
    ( 
     Lugar_id_lugar
    ) 
    REFERENCES Lugar 
    ( 
     id_lugar
    ) 
;

ALTER TABLE Evento_Proveedor 
    ADD CONSTRAINT Evento_Proveedor_Evento_FK FOREIGN KEY 
    ( 
     id_evento
    ) 
    REFERENCES Evento 
    ( 
     id_evento
    ) 
;

ALTER TABLE Evento_Proveedor 
    ADD CONSTRAINT Evento_Proveedor_Proveedor_FK FOREIGN KEY 
    ( 
     id_proveedor
    ) 
    REFERENCES Proveedor 
    ( 
     id_proveedor
    ) 
;

ALTER TABLE Evento 
    ADD CONSTRAINT Evento_TipoEvento_FK FOREIGN KEY 
    ( 
     tipo_evento_id
    ) 
    REFERENCES TipoEvento 
    ( 
     id_tipo_evento
    ) 
;

ALTER TABLE Fermentacion 
    ADD CONSTRAINT Fermentacion_Receta_FK FOREIGN KEY 
    ( 
     Receta_id_receta
    ) 
    REFERENCES Receta 
    ( 
     id_receta
    ) 
;

ALTER TABLE Horario_Empleado 
    ADD CONSTRAINT Horario_Empleado_Empleado_FK FOREIGN KEY 
    ( 
     id_empleado
    ) 
    REFERENCES Empleado 
    ( 
     id_empleado
    ) 
;

ALTER TABLE Horario_Empleado 
    ADD CONSTRAINT Horario_Empleado_Horario_FK FOREIGN KEY 
    ( 
     id_horario
    ) 
    REFERENCES Horario 
    ( 
     id_horario
    ) 
;

ALTER TABLE Horario_Evento 
    ADD CONSTRAINT Horario_Evento_Evento_FK FOREIGN KEY 
    ( 
     id_evento
    ) 
    REFERENCES Evento 
    ( 
     id_evento
    ) 
;

ALTER TABLE Horario_Evento 
    ADD CONSTRAINT Horario_Evento_Horario_FK FOREIGN KEY 
    ( 
     id_horario
    ) 
    REFERENCES Horario 
    ( 
     id_horario
    ) 
;

ALTER TABLE Ingrediente 
    ADD CONSTRAINT Ingrediente_Ingrediente_FK FOREIGN KEY 
    ( 
     id_ingrediente
    ) 
    REFERENCES Ingrediente 
    ( 
     id_ingrediente
    ) 
;

ALTER TABLE Instruccion 
    ADD CONSTRAINT Instruccion_Receta_FK FOREIGN KEY 
    ( 
     receta_id
    ) 
    REFERENCES Receta 
    ( 
     id_receta
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Inventario_Evento_Proveedor 
    ADD CONSTRAINT Inventario_Evento_Proveedor_Evento_Proveedor_FK FOREIGN KEY 
    ( 
     id_proveedor,
     id_evento
    ) 
    REFERENCES Evento_Proveedor 
    ( 
     id_proveedor,
     id_evento
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Inventario_Evento_Proveedor 
    ADD CONSTRAINT Inventario_Evento_Proveedor_Presentacion_Cerveza_FK FOREIGN KEY 
    ( 
     id_presentacion,
     id_cerveza
    ) 
    REFERENCES Presentacion_Cerveza 
    ( 
     id_presentacion,
     id_cerveza
    ) 
;


ALTER TABLE Invitado_Evento 
    ADD CONSTRAINT Invitado_Evento_Evento_FK FOREIGN KEY 
    ( 
     id_evento
    ) 
    REFERENCES Evento 
    ( 
     id_evento
    ) 
;

ALTER TABLE Invitado_Evento 
    ADD CONSTRAINT Invitado_Evento_Invitado_FK FOREIGN KEY 
    ( 
     id_invitado
    ) 
    REFERENCES Invitado 
    ( 
     id_invitado
    ) 
;

ALTER TABLE Invitado 
    ADD CONSTRAINT Invitado_Lugar_FK FOREIGN KEY 
    ( 
     lugar_id
    ) 
    REFERENCES Lugar 
    ( 
     id_lugar
    ) 
;

ALTER TABLE Invitado 
    ADD CONSTRAINT Invitado_Tipo_Invitado_FK FOREIGN KEY 
    ( 
     tipo_invitado_id
    ) 
    REFERENCES Tipo_Invitado 
    ( 
     id_tipo_invitado
    ) 
;

ALTER TABLE Lugar 
    ADD CONSTRAINT Lugar_Lugar_FK FOREIGN KEY 
    ( 
     id_lugar
    ) 
    REFERENCES Lugar 
    ( 
     id_lugar
    ) 
;

ALTER TABLE Membresia 
    ADD CONSTRAINT Membresia_Proveedor_FK FOREIGN KEY 
    ( 
     id_proveedor
    ) 
    REFERENCES Proveedor 
    ( 
     id_proveedor
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 


--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Orden_Reposicion_Estatus 
    ADD CONSTRAINT Orden_Reposicion_Estatus_Estatus_FK FOREIGN KEY 
    ( 
     id_estatus
    ) 
    REFERENCES Estatus 
    ( 
     id_estatus
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Orden_Reposicion_Estatus 
    ADD CONSTRAINT Orden_Reposicion_Estatus_Orden_Reposicion_FK FOREIGN KEY 
    ( 
     id_orden_reposicion,
     id_proveedor,
     id_departamento
    ) 
    REFERENCES Orden_Reposicion 
    ( 
     id_orden_reposicion,
     id_proveedor,
     id_departamento
    ) 
;



-- Error - Foreign Key Orden_Reposicion_Usuario_FK has no columns

ALTER TABLE Pago_Compra 
    ADD CONSTRAINT Pago_Compra_Compra_FK FOREIGN KEY 
    ( 
     compra_id
    ) 
    REFERENCES Compra 
    ( 
     id_compra
    ) 
;

ALTER TABLE Pago_Compra 
    ADD CONSTRAINT Pago_Compra_Metodo_Pago_FK FOREIGN KEY 
    ( 
     metodo_id
    ) 
    REFERENCES Metodo_Pago 
    ( 
     id_metodo
    ) 
;

ALTER TABLE Pago_Compra 
    ADD CONSTRAINT Pago_Compra_Tasa_FK FOREIGN KEY 
    ( 
     tasa_id
    ) 
    REFERENCES Tasa 
    ( 
     id_tasa
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Pago_Cuota_Afiliacion 
    ADD CONSTRAINT Pago_Cuota_Afiliacion_Cuota_Afiliacion_FK FOREIGN KEY 
    ( 
     cuota_id
    ) 
    REFERENCES Cuota_Afiliacion 
    ( 
     id_cuota
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Pago_Cuota_Afiliacion 
    ADD CONSTRAINT Pago_Cuota_Afiliacion_Metodo_Pago_FK FOREIGN KEY 
    ( 
     metodo_id
    ) 
    REFERENCES Metodo_Pago 
    ( 
     id_metodo
    ) 
;

ALTER TABLE Pago_Cuota_Afiliacion 
    ADD CONSTRAINT Pago_Cuota_Afiliacion_Tasa_FK FOREIGN KEY 
    ( 
     tasa_id
    ) 
    REFERENCES Tasa 
    ( 
     id_tasa
    ) 
;

ALTER TABLE Pago_Evento 
    ADD CONSTRAINT Pago_Evento_Metodo_Pago_FK FOREIGN KEY 
    ( 
     metodo_id
    ) 
    REFERENCES Metodo_Pago 
    ( 
     id_metodo
    ) 
;

ALTER TABLE Pago_Evento 
    ADD CONSTRAINT Pago_Evento_Tasa_FK FOREIGN KEY 
    ( 
     tasa_id
    ) 
    REFERENCES Tasa 
    ( 
     id_tasa
    ) 
;

ALTER TABLE Pago_Evento 
    ADD CONSTRAINT Pago_Evento_Venta_Evento_FK FOREIGN KEY 
    ( 
     evento_id,
     id_cliente_natural
    ) 
    REFERENCES Venta_Evento 
    ( 
     evento_id,
     id_cliente_natural
    ) 
;

-- Error - Foreign Key Pago_Orden_Reposicion_Efectivo_FK has no columns

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Pago_Orden_Reposicion 
    ADD CONSTRAINT Pago_Orden_Reposicion_Orden_Reposicion_FK FOREIGN KEY 
    ( 
     id_orden_reposicion,
     id_proveedor,
     id_departamento
    ) 
    REFERENCES Orden_Reposicion 
    ( 
     id_orden_reposicion,
     id_proveedor,
     id_departamento
    ) 
;

ALTER TABLE Rol_Privilegio 
    ADD CONSTRAINT Rpl_Privilegio_Privilegio_FK FOREIGN KEY 
    ( 
     id_privilegio
    ) 
    REFERENCES Privilegio 
    ( 
     id_privilegio
    ) 
;

ALTER TABLE Rol_Privilegio
    ADD CONSTRAINT Rol_Privilegio_Rol_FK FOREIGN KEY 
    ( 
     id_rol
    ) 
    REFERENCES Rol 
    ( 
     id_rol
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Persona_Contacto 
    ADD CONSTRAINT Persona_Contacto_Cliente_Juridico_FK FOREIGN KEY 
    ( 
     id_cliente_juridico
    ) 
    REFERENCES Cliente_Juridico 
    ( 
     id_cliente
    ) 
;

ALTER TABLE Persona_Contacto 
    ADD CONSTRAINT Persona_Contacto_Proveedor_FK FOREIGN KEY 
    ( 
     id_proveedor
    ) 
    REFERENCES Proveedor 
    ( 
     id_proveedor
    ) 
;



--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Presentacion_Cerveza 
    ADD CONSTRAINT Presentacion_Cerveza_Presentacion_FK FOREIGN KEY 
    ( 
     id_presentacion
    ) 
    REFERENCES Presentacion 
    ( 
     id_presentacion
    ) 
;

ALTER TABLE Presentacion_Cerveza 
    ADD CONSTRAINT Presentacion_Cerveza_Cerveza_FK FOREIGN KEY 
    ( 
     id_cerveza
    ) 
    REFERENCES Cerveza 
    ( 
     id_cerveza
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 

ALTER TABLE Promocion 
    ADD CONSTRAINT Promocion_Departamento_FK FOREIGN KEY 
    ( 
     id_departamento
    ) 
    REFERENCES Departamento 
    ( 
     id_departamento
    ) 
;

ALTER TABLE Promocion 
    ADD CONSTRAINT Promocion_Usuario_FK FOREIGN KEY 
    ( 
     id_usuario
    ) 
    REFERENCES Usuario 
    ( 
     id_usuario
    ) 
;

ALTER TABLE Proveedor 
    ADD CONSTRAINT Proveedor_Lugar_FK FOREIGN KEY 
    ( 
     id_lugar
    ) 
    REFERENCES Lugar 
    ( 
     id_lugar
    ) 
;

ALTER TABLE Proveedor 
    ADD CONSTRAINT Proveedor_Lugar_FKv2 FOREIGN KEY 
    ( 
     id_lugar
    ) 
    REFERENCES Lugar 
    ( 
     id_lugar
    ) 
;


ALTER TABLE Punto_Cliente 
    ADD CONSTRAINT Punto_Cliente_Cliente_FK FOREIGN KEY 
    ( 
     id_cliente_natural
    ) 
    REFERENCES Cliente_Natural 
    ( 
     id_cliente
    ) 
;

ALTER TABLE Punto_Cliente 
    ADD CONSTRAINT Punto_Cliente_Punto_FK FOREIGN KEY 
    ( 
     id_metodo
    ) 
    REFERENCES Punto 
    ( 
     id_metodo
    ) 
;

ALTER TABLE Punto 
    ADD CONSTRAINT Punto_Metodo_Pago_FK FOREIGN KEY 
    ( 
     id_metodo
    ) 
    REFERENCES Metodo_Pago 
    ( 
     id_metodo
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Receta_Ingrediente 
    ADD CONSTRAINT Receta_Ingrediente_Ingrediente_FK FOREIGN KEY 
    ( 
     id_ingrediente
    ) 
    REFERENCES Ingrediente 
    ( 
     id_ingrediente
    ) 
;

ALTER TABLE Receta_Ingrediente 
    ADD CONSTRAINT Receta_Ingrediente_Receta_FK FOREIGN KEY 
    ( 
     id_receta
    ) 
    REFERENCES Receta 
    ( 
     id_receta
    ) 
;

ALTER TABLE Receta 
    ADD CONSTRAINT Receta_Tipo_Cerveza_FK FOREIGN KEY 
    ( 
     id_tipo_cerveza
    ) 
    REFERENCES Tipo_Cerveza 
    ( 
     id_tipo_cerveza
    ) 
;

ALTER TABLE Tarjeta_Credito 
    ADD CONSTRAINT Tarjeta_Credito_Metodo_Pago_FK FOREIGN KEY 
    ( 
     id_metodo
    ) 
    REFERENCES Metodo_Pago 
    ( 
     id_metodo
    ) 
;

ALTER TABLE Tarjeta_Debito 
    ADD CONSTRAINT Tarjeta_Debito_Metodo_Pago_FK FOREIGN KEY 
    ( 
     id_metodo
    ) 
    REFERENCES Metodo_Pago 
    ( 
     id_metodo
    ) 
;

ALTER TABLE Tasa 
    ADD CONSTRAINT Tasa_Punto_FK FOREIGN KEY 
    ( 
     id_metodo
    ) 
    REFERENCES Punto 
    ( 
     id_metodo
    ) 
;

ALTER TABLE Telefono 
    ADD CONSTRAINT Telefono_Cliente_N_FK FOREIGN KEY 
    ( 
     id_cliente_natural
    ) 
    REFERENCES Cliente_Natural
    ( 
     id_cliente
    ) 
;
ALTER TABLE Telefono 
    ADD CONSTRAINT Telefono_Cliente_J_FK FOREIGN KEY 
    ( 
     id_cliente_juridico
    ) 
    REFERENCES Cliente_Juridico
    ( 
     id_cliente
    ) 
;



ALTER TABLE Telefono 
    ADD CONSTRAINT Telefono_Invitado_FK FOREIGN KEY 
    ( 
     id_invitado
    ) 
    REFERENCES Invitado 
    ( 
     id_invitado
    ) 
;

ALTER TABLE Telefono 
    ADD CONSTRAINT Telefono_Persona_Contacto_FK FOREIGN KEY 
    ( 
     id_contacto
    ) 
    REFERENCES Persona_Contacto 
    ( 
     id_contacto
    ) 
;

ALTER TABLE Telefono 
    ADD CONSTRAINT Telefono_Proveedor_FK FOREIGN KEY 
    ( 
     id_proveedor
    ) 
    REFERENCES Proveedor 
    ( 
     id_proveedor
    ) 
;

ALTER TABLE Tienda_Fisica 
    ADD CONSTRAINT Tienda_Fisica_Lugar_FK FOREIGN KEY 
    ( 
     id_lugar
    ) 
    REFERENCES Lugar 
    ( 
     id_lugar
    ) 
;

ALTER TABLE Tipo_Cerveza 
    ADD CONSTRAINT Tipo_Cerveza_Tipo_Cerveza_FK FOREIGN KEY 
    ( 
     id_tipo_cerveza
    ) 
    REFERENCES Tipo_Cerveza 
    ( 
     id_tipo_cerveza
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Ubicacion_Tienda 
    ADD CONSTRAINT Ubicacion_Tienda_Tienda_Fisica_FK FOREIGN KEY 
    ( 
     id_tienda_fisica
    ) 
    REFERENCES Tienda_Fisica 
    ( 
     id_tienda_fisica
    ) 
;

ALTER TABLE Ubicacion_Tienda 
    ADD CONSTRAINT Ubicacion_Tienda_Tienda_Web_FK FOREIGN KEY 
    ( 
     id_tienda_web
    ) 
    REFERENCES Tienda_Web 
    ( 
     id_tienda_web
    ) 
;

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE Ubicacion_Tienda 
    ADD CONSTRAINT Ubicacion_Tienda_Ubicacion_Tienda_FK FOREIGN KEY 
    ( 
      ubicacion_tienda_relacion_id
    ) 
    REFERENCES Ubicacion_Tienda 
    ( 
     id_ubicacion
    ) 
;

ALTER TABLE Usuario 
    ADD CONSTRAINT Usuario_Cliente_N_FK FOREIGN KEY 
    ( 
     id_cliente_natural
    ) 
    REFERENCES Cliente_Natural 
    ( 
     id_cliente
    ) 
;
ALTER TABLE Usuario 
    ADD CONSTRAINT Usuario_Cliente_J_FK FOREIGN KEY 
    ( 
     id_cliente_juridico
    ) 
    REFERENCES Cliente_Juridico
    ( 
     id_cliente
    ) 
;

ALTER TABLE Usuario 
    ADD CONSTRAINT Usuario_Empleado_FK FOREIGN KEY 
    ( 
     empleado_id
    ) 
    REFERENCES Empleado 
    ( 
     id_empleado
    ) 
;

ALTER TABLE Usuario 
    ADD CONSTRAINT Usuario_Proveedor_FK FOREIGN KEY 
    ( 
     empleado_id
    ) 
    REFERENCES Proveedor 
    ( 
     id_proveedor
    ) 
;

ALTER TABLE Usuario 
    ADD CONSTRAINT Usuario_Rol_FK FOREIGN KEY 
    ( 
     id_rol
    ) 
    REFERENCES Rol 
    ( 
     id_rol
    ) 
;

ALTER TABLE Vacacion 
    ADD CONSTRAINT Vacacion_Empleado_FK FOREIGN KEY 
    ( 
     empleado_id
    ) 
    REFERENCES Empleado 
    ( 
     id_empleado
    ) 
;

ALTER TABLE Venta_Evento 
    ADD CONSTRAINT Venta_Evento_Cliente_FK FOREIGN KEY 
    ( 
     id_cliente_natural
    ) 
    REFERENCES Cliente_Natural
    ( 
     id_cliente
    ) 
;

ALTER TABLE Venta_Evento 
    ADD CONSTRAINT Venta_Evento_Evento_FK FOREIGN KEY 
    ( 
     evento_id
    ) 
    REFERENCES Evento 
    ( 
     id_evento
    ) 
;

--  ERROR: No Discriminator Column found in Arc FKArc_1 - constraint trigger for Arc cannot be generated 

--  ERROR: No Discriminator Column found in Arc FKArc_1 - constraint trigger for Arc cannot be generated

--  ERROR: No Discriminator Column found in Arc FKArc_2 - constraint trigger for Arc cannot be generated 

--  ERROR: No Discriminator Column found in Arc FKArc_2 - constraint trigger for Arc cannot be generated 

--  ERROR: No Discriminator Column found in Arc FKArc_2 - constraint trigger for Arc cannot be generated 

--  ERROR: No Discriminator Column found in Arc FKArc_2 - constraint trigger for Arc cannot be generated 

--  ERROR: No Discriminator Column found in Arc FKArc_2 - constraint trigger for Arc cannot be generated



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            76
-- CREATE INDEX                             0
-- ALTER TABLE                            200
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                  94
-- WARNINGS                                 0
