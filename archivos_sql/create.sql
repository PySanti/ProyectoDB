CREATE TABLE Actividad (
    id_actividad SERIAL PRIMARY KEY,
    tema VARCHAR(50) NOT NULL,
    invitado_evento_invitado_id_invitado INTEGER NOT NULL,
    invitado_evento_evento_id_evento INTEGER NOT NULL,
    tipo_actividad_id_tipo_actividad INTEGER NOT NULL
);

CREATE TABLE Beneficio (
    id_beneficio SERIAL PRIMARY KEY,
    nombre       VARCHAR(50) NOT NULL,
    descripcion  TEXT NOT NULL,
    monto        NUMERIC NOT NULL,
    activo       CHAR(1)
);


CREATE TABLE Asistencia (
    id_asistencia        SERIAL PRIMARY KEY,
    fecha_hora_entrada   TIMESTAMP NOT NULL,
    fecha_hora_salida    TIMESTAMP NOT NULL,
    empleado_id_empleado INTEGER NOT NULL
);

CREATE TABLE Beneficio_Depto_Empleado (
    pagado          CHAR(1),
    id_empleado     INTEGER NOT NULL,
    id_departamento INTEGER NOT NULL,
    monto           DECIMAL NOT NULL,
    id_beneficio    INTEGER NOT NULL,
    PRIMARY KEY (id_empleado, id_departamento, id_beneficio)
);

CREATE TABLE Caracteristica (
    id_caracteristica    SERIAL PRIMARY KEY,
    tipo_caracteristica  VARCHAR(50) NOT NULL,
    valor_caracteristica VARCHAR(50) NOT NULL
);

CREATE TABLE Caracteristica_Especifica (
    id_tipo_cerveza    INTEGER NOT NULL,
    id_caracteristica  INTEGER NOT NULL,
    valor              VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_tipo_cerveza, id_caracteristica)
);

CREATE TABLE Cargo (
    id_cargo    SERIAL PRIMARY KEY,
    nombre      VARCHAR(50) NOT NULL,
    descripcion TEXT NOT NULL
);

CREATE TABLE Cerveza (
    id_cerveza      SERIAL PRIMARY KEY,
    nombre_cerveza  VARCHAR(50) NOT NULL,
    id_tipo_cerveza INTEGER NOT NULL,
    id_proveedor    INTEGER NOT NULL
);

CREATE TABLE Cliente_Juridico (
    id_cliente             SERIAL PRIMARY KEY,
    rif_cliente            INTEGER NOT NULL,  
    razon_social           VARCHAR(50) NOT NULL,  
    denominacion_comercial VARCHAR(50) NOT NULL,  
    capital_disponible     DECIMAL NOT NULL,  
    direccion_fiscal       TEXT NOT NULL, 
    direccion_fisica       TEXT NOT NULL,
    pagina_web             VARCHAR(100) NOT NULL, 
    lugar_id_lugar         INTEGER NOT NULL,
    lugar_id_lugar2        INTEGER NOT NULL
);

CREATE TABLE Cliente_Natural (
    id_cliente       SERIAL PRIMARY KEY,
    rif_cliente      INTEGER NOT NULL,        
    ci_cliente       INTEGER NOT NULL,             
    primer_nombre    VARCHAR(30) NOT NULL,
    segundo_nombre   VARCHAR(30),
    primer_apellido  VARCHAR(30) NOT NULL,
    segundo_apellido VARCHAR(30),
    direccion        TEXT NOT NULL,       
    lugar_id_lugar   INTEGER NOT NULL
);

CREATE TABLE Metodo_Pago (
    id_metodo SERIAL PRIMARY KEY,
    id_cliente_natural INTEGER,
    id_cliente_juridico INTEGER,
    FOREIGN KEY (id_cliente_natural) REFERENCES Cliente_Natural(id_cliente),
    FOREIGN KEY (id_cliente_juridico) REFERENCES Cliente_Juridico(id_cliente)
);

CREATE TABLE Cheque (
    id_metodo  INTEGER PRIMARY KEY,
    num_cheque INTEGER NOT NULL,
    num_cuenta INTEGER NOT NULL,  
    banco      VARCHAR(30),
    FOREIGN KEY (id_metodo) REFERENCES Metodo_Pago(id_metodo)
);

CREATE TABLE Efectivo (
    id_metodo    INTEGER PRIMARY KEY,
    denominacion INTEGER NOT NULL,
    FOREIGN KEY (id_metodo) REFERENCES Metodo_Pago(id_metodo)
);


CREATE TABLE Compra (
    id_compra               SERIAL PRIMARY KEY,
    id_cliente_juridico      INTEGER,
    id_cliente_natural      INTEGER,
    monto_total             DECIMAL,
    usuario_id_usuario      INTEGER,
    tienda_web_id_tienda    INTEGER,
    tienda_fisica_id_tienda INTEGER,
    
    CONSTRAINT arc_tienda CHECK (
        (tienda_web_id_tienda IS NOT NULL AND tienda_fisica_id_tienda IS NULL) OR
        (tienda_fisica_id_tienda IS NOT NULL AND tienda_web_id_tienda IS NULL)
    ),
    
    CONSTRAINT arc_comprador CHECK (
        (id_cliente_juridico IS NOT NULL AND usuario_id_usuario IS NULL AND id_cliente_natural IS NULL) OR
        (id_cliente_juridico IS NULL AND usuario_id_usuario IS NOT NULL AND id_cliente_natural IS NULL) OR
        (id_cliente_juridico IS NULL AND usuario_id_usuario IS  NULL AND id_cliente_natural IS NOT NULL) 
    )
);

CREATE TABLE Compra_Estatus (
    compra_id_compra      INTEGER NOT NULL,
    estatus_id_estatus    INTEGER NOT NULL,
    fecha_hora_asignacion TIMESTAMP NOT NULL,
    fecha_hora_fin        TIMESTAMP NOT NULL,
    PRIMARY KEY (compra_id_compra, estatus_id_estatus)
);

CREATE TABLE Correo (
    id_correo              SERIAL PRIMARY KEY,
    nombre                 VARCHAR(50) NOT NULL,
    extension_pag              VARCHAR(20) NOT NULL,
    id_proveedor_proveedor INTEGER,
    id_cliente_natural     INTEGER,
    id_cliente_juridico     INTEGER,
    id_empleado             INTEGER,
    
    CONSTRAINT arc_propietario CHECK (
        (id_cliente_juridico IS NOT NULL AND id_cliente_natural IS NULL AND id_proveedor_proveedor IS NULL AND id_empleado IS NULL) OR
        (id_cliente_juridico IS NULL AND id_cliente_natural IS NOT NULL AND id_proveedor_proveedor IS NULL AND id_empleado IS NULL) OR
        (id_cliente_juridico IS NULL AND id_cliente_natural IS NULL AND id_proveedor_proveedor IS NOT NULL AND id_empleado IS NULL) OR
        (id_empleado IS NOT NULL AND id_cliente_juridico IS NULL AND id_cliente_natural IS NULL AND id_proveedor_proveedor IS NULL)
    )
);

CREATE TABLE Cuota_Afiliacion (
    id_cuota               SERIAL PRIMARY KEY,
    monto                  DECIMAL(10,2) NOT NULL,
    membresia_id_membresia INTEGER NOT NULL,
    fecha_pago             DATE NOT NULL
);

CREATE TABLE Departamento (
    id_departamento SERIAL PRIMARY KEY,
    nombre          VARCHAR(50) NOT NULL,
    fecha_creacion  DATE NOT NULL,
    descripcion     TEXT NOT NULL,
    activo          CHAR(1)
);

CREATE TABLE Departamento_Empleado (
    fecha_inicio     DATE NOT NULL,
    fecha_final      DATE,
    salario          DECIMAL NOT NULL,
    id_empleado      INTEGER NOT NULL,
    id_departamento  INTEGER NOT NULL,
    id_cargo         INTEGER NOT NULL,
    PRIMARY KEY (id_empleado, id_departamento)
);

CREATE TABLE Descuento (
    porcentaje     DECIMAL NOT NULL,
    id_promocion   INTEGER NOT NULL,
    id_tipo_cerveza INTEGER NOT NULL,
    id_presentacion INTEGER NOT NULL,
    id_cerveza      INTEGER NOT NULL,
    PRIMARY KEY (id_promocion, id_tipo_cerveza, id_presentacion, id_cerveza)
);

CREATE TABLE Detalle_Compra (
    precio_unitario DECIMAL NOT NULL,
    cantidad        INTEGER NOT NULL,
    id_inventario   INTEGER NOT NULL,
    id_compra       INTEGER NOT NULL,
    PRIMARY KEY (id_inventario, id_compra)
);

CREATE TABLE Detalle_Orden_Reposicion (
    cantidad          INTEGER NOT NULL,
    id_orden_reposicion INTEGER NOT NULL,
    id_proveedor      INTEGER NOT NULL,
    id_departamento   INTEGER NOT NULL,
    precio            DECIMAL NOT NULL,
    id_tipo_cerveza   INTEGER NOT NULL,
    id_presentacion   INTEGER NOT NULL,
    id_cerveza        INTEGER NOT NULL,
    PRIMARY KEY (id_orden_reposicion, id_proveedor, id_departamento, id_tipo_cerveza, id_presentacion, id_cerveza)
);

CREATE TABLE Detalle_Orden_Reposicion_Anaquel (
    id_orden_reposicion INTEGER NOT NULL,
    id_inventario      INTEGER NOT NULL,
    cantidad            INTEGER NOT NULL,
    PRIMARY KEY (id_orden_reposicion, id_inventario)
);

CREATE TABLE Detalle_Venta_Evento (
    precio_unitario    DECIMAL NOT NULL,
    cantidad           INTEGER NOT NULL,
    id_evento          INTEGER NOT NULL,
    id_cliente_natural         INTEGER NOT NULL,
    id_cerveza         INTEGER NOT NULL,
    id_proveedor       INTEGER NOT NULL,
    id_proveedor_evento INTEGER NOT NULL,
    id_tipo_cerveza    INTEGER NOT NULL,
    id_presentacion    INTEGER NOT NULL,
    id_cerveza_inv     INTEGER NOT NULL,

    PRIMARY KEY (id_evento,  id_cliente_natural, id_cerveza, id_proveedor, id_proveedor_evento, id_tipo_cerveza, id_presentacion, id_cerveza_inv)


);

CREATE TABLE Empleado (
    id_empleado      SERIAL PRIMARY KEY,
    cedula           VARCHAR(20) NOT NULL,
    primer_nombre    VARCHAR(30) NOT NULL,
    segundo_nombre   VARCHAR(30),
    primer_apellido  VARCHAR(30) NOT NULL,
    segundo_apellido VARCHAR(30),
    direccion        TEXT NOT NULL,
    activo           CHAR(1),
    lugar_id_lugar   INTEGER NOT NULL
);

CREATE TABLE Estatus (
    id_estatus SERIAL PRIMARY KEY,
    nombre     VARCHAR(20) NOT NULL
);

CREATE TABLE Estatus_Orden_Anaquel (
    id_orden_reposicion INTEGER NOT NULL,
    id_estatus          INTEGER NOT NULL,
    fecha_hora_asignacion TIMESTAMP NOT NULL,
    PRIMARY KEY (id_orden_reposicion, id_estatus)
);

CREATE TABLE Evento (
    id_evento               SERIAL PRIMARY KEY,
    nombre                  VARCHAR(100) NOT NULL,
    descripcion             TEXT NOT NULL,
    fecha_inicio            TIMESTAMP NOT NULL,
    fecha_fin               TIMESTAMP NOT NULL,
    lugar_id_lugar          INTEGER NOT NULL,
    n_entradas_vendidas     INTEGER,
    precio_unitario_entrada DECIMAL NOT NULL,
    tipo_evento_id          INTEGER NOT NULL
);

CREATE TABLE Evento_Proveedor (
    id_proveedor  INTEGER NOT NULL,
    id_evento     INTEGER NOT NULL,
    hora_llegada  TIME,
    hora_salida   TIME,
    dia           DATE NOT NULL,
    PRIMARY KEY (id_proveedor, id_evento)
);

CREATE TABLE Fermentacion (
    id_fermentacion    SERIAL PRIMARY KEY,
    receta_id_receta   INTEGER NOT NULL,
    fecha_inicio       DATE NOT NULL,
    fecha_fin_estimada DATE NOT NULL
);

CREATE TABLE Horario (
    id_horario   SERIAL PRIMARY KEY,
    dia          DATE NOT NULL,
    hora_entrada TIME NOT NULL,
    hora_salida  TIME NOT NULL
);

CREATE TABLE Horario_Empleado (
    id_empleado INTEGER NOT NULL,
    id_horario  INTEGER NOT NULL,
    PRIMARY KEY (id_empleado, id_horario)
);

CREATE TABLE Horario_Evento (
    id_evento   INTEGER NOT NULL,
    id_horario  INTEGER NOT NULL,
    PRIMARY KEY (id_evento, id_horario)
);

CREATE TABLE Ingrediente (
    id_ingrediente SERIAL PRIMARY KEY,
    tipo           VARCHAR(20) NOT NULL,
    valor          DECIMAL NOT NULL,
    ingrediente_padre INTEGER,
    nombre         VARCHAR(50) NOT NULL
);

CREATE TABLE Instruccion (
    id_instruccion SERIAL PRIMARY KEY,
    nombre         VARCHAR(50) NOT NULL,
    descripcion    TEXT NOT NULL,
    receta_id      INTEGER NOT NULL
);

CREATE TABLE Inventario (
    id_inventario   SERIAL PRIMARY KEY,
    cantidad        INTEGER NOT NULL,
    id_tienda_web   INTEGER ,
    id_tienda_fisica INTEGER ,
    id_ubicacion    INTEGER ,
    id_presentacion INTEGER NOT NULL ,
    id_cerveza      INTEGER NOT NULL,

    CONSTRAINT arc_ubicacion CHECK (
        (id_tienda_web IS NOT NULL AND id_tienda_fisica IS NULL AND id_ubicacion IS NULL) OR
        (id_tienda_web IS NULL AND id_tienda_fisica IS NOT NULL AND id_ubicacion IS NULL) OR
        (id_tienda_web IS NULL AND id_tienda_fisica IS NULL AND id_ubicacion IS NOT NULL)
    )
);

CREATE TABLE Inventario_Evento_Proveedor (
    id_proveedor    INTEGER NOT NULL,
    id_evento       INTEGER NOT NULL,
    cantidad        INTEGER NOT NULL,
    id_tipo_cerveza INTEGER NOT NULL,
    id_presentacion INTEGER NOT NULL,
    id_cerveza      INTEGER NOT NULL,
    PRIMARY KEY (id_proveedor, id_evento, id_tipo_cerveza, id_presentacion, id_cerveza)
);

CREATE TABLE Invitado (
    id_invitado     SERIAL PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    lugar_id        INTEGER NOT NULL,
    tipo_invitado_id INTEGER NOT NULL,
    rif             INTEGER NOT NULL,
    direccion       TEXT NOT NULL
);

CREATE TABLE Invitado_Evento (
    id_invitado  INTEGER NOT NULL,
    id_evento    INTEGER NOT NULL,
    hora_llegada TIME,
    hora_salida  TIME,
    PRIMARY KEY (id_invitado, id_evento)
);

CREATE TABLE Lugar (
    id_lugar   SERIAL PRIMARY KEY,
    nombre     VARCHAR(100) NOT NULL,
    tipo       VARCHAR(50) NOT NULL,
    lugar_relacion_id INTEGER
);

CREATE TABLE Membresia (
    id_membresia    SERIAL PRIMARY KEY,
    fecha_inicio    DATE NOT NULL,
    fecha_fin       DATE,
    id_proveedor    INTEGER NOT NULL
);

CREATE TABLE Orden_Reposicion (
    id_orden_reposicion SERIAL PRIMARY KEY,
    id_departamento     INTEGER NOT NULL,
    id_proveedor        INTEGER NOT NULL,
    fecha_emision       DATE NOT NULL,
    id_empleado         INTEGER,
    fecha_fin           DATE
);

CREATE TABLE Orden_Reposicion_Anaquel (
    id_orden_reposicion SERIAL PRIMARY KEY,
    fecha_hora_generacion TIMESTAMP NOT NULL
);

CREATE TABLE Orden_Reposicion_Estatus (
    id_orden_reposicion INTEGER NOT NULL,
    id_proveedor        INTEGER NOT NULL,
    id_departamento     INTEGER NOT NULL,
    id_estatus          INTEGER NOT NULL,
    fecha_asignacion    TIMESTAMP NOT NULL,
    fecha_fin           TIMESTAMP,
    PRIMARY KEY (id_orden_reposicion, id_proveedor, id_departamento, id_estatus)
);

CREATE TABLE Tasa (
    id_tasa      SERIAL PRIMARY KEY,
    nombre       VARCHAR(50) NOT NULL,
    valor        DECIMAL NOT NULL,
    fecha        DATE NOT NULL,
    punto_id     INTEGER NOT NULL,
    id_metodo INTEGER NOT NULL
);

CREATE TABLE Pago_Compra (
    id_pago         SERIAL PRIMARY KEY,
    metodo_id      INTEGER NOT NULL,
    compra_id      INTEGER NOT NULL,
    monto          DECIMAL NOT NULL,
    fecha_hora     TIMESTAMP NOT NULL,
    referencia     VARCHAR(50) NOT NULL,
    tasa_id        INTEGER,
    
    -- Foreign Keys para integridad referencial
    FOREIGN KEY (metodo_id) REFERENCES Metodo_Pago(id_metodo),
    FOREIGN KEY (compra_id) REFERENCES Compra(id_compra),
    FOREIGN KEY (tasa_id) REFERENCES Tasa(id_tasa)
);

CREATE TABLE Pago_Cuota_Afiliacion (
    metodo_id      INTEGER NOT NULL,
    cuota_id       INTEGER NOT NULL,
    monto          DECIMAL NOT NULL,
    fecha_pago     DATE NOT NULL,
    tasa_id        INTEGER,
    PRIMARY KEY (metodo_id, cuota_id)
);

CREATE TABLE Pago_Evento (
    metodo_id      INTEGER NOT NULL,
    evento_id      INTEGER NOT NULL,
    id_cliente_natural     INTEGER NOT NULL,
    fecha_hora     TIMESTAMP NOT NULL,
    monto          DECIMAL NOT NULL,
    tasa_id        INTEGER,
    referencia     VARCHAR(50) NOT NULL,

    PRIMARY KEY (metodo_id, evento_id, id_cliente_natural)
);

CREATE TABLE Pago_Orden_Reposicion (
    id_pago        SERIAL PRIMARY KEY,
    id_proveedor   INTEGER NOT NULL,
    id_departamento INTEGER NOT NULL,
    id_orden_reposicion INTEGER NOT NULL,
    fecha_ejecucion TIMESTAMP NOT NULL,
    monto          DECIMAL NOT NULL
);

CREATE TABLE Rol_Privilegio (
    id_rol          INTEGER NOT NULL,
    id_privilegio   INTEGER NOT NULL,
    fecha_asignacion DATE NOT NULL DEFAULT CURRENT_DATE,
    nom_tabla_ojetivo VARCHAR(25) NOT NULL,
    motivo          TEXT,
    PRIMARY KEY (id_rol, id_privilegio)
);

CREATE TABLE Persona_Contacto (
    id_contacto     SERIAL PRIMARY KEY,
    nombre          VARCHAR(50) NOT NULL,
    apellido        VARCHAR(50) NOT NULL,
    id_proveedor    INTEGER,
    id_cliente_juridico INTEGER,
    
    CONSTRAINT arc_propietario_contacto CHECK (
        (id_cliente_juridico IS NOT NULL AND id_proveedor IS NULL) OR
        (id_proveedor IS NOT NULL AND id_cliente_juridico IS NULL)
    )
);

CREATE TABLE Presentacion (
    id_presentacion SERIAL,
    nombre          VARCHAR(40) NOT NULL,
    PRIMARY KEY (id_presentacion)
);

CREATE TABLE Presentacion_Cerveza (
    id_presentacion     INTEGER NOT NULL,
    id_cerveza          INTEGER NOT NULL,
    cantidad            INTEGER NOT NULL,
    descripcion         TEXT,
    precio              DECIMAL NOT NULL,
    PRIMARY KEY (id_presentacion, id_cerveza)
);

CREATE TABLE Privilegio (
    id_privilegio   SERIAL PRIMARY KEY,
    nombre          VARCHAR(50) NOT NULL
);

CREATE TABLE Promocion (
    id_promocion    SERIAL PRIMARY KEY,
    descripcion     TEXT NOT NULL,
    id_departamento INTEGER NOT NULL,
    fecha_inicio    DATE NOT NULL,
    fecha_fin       DATE NOT NULL,
    id_usuario      INTEGER
);

CREATE TABLE Proveedor (
    id_proveedor     SERIAL PRIMARY KEY,
    razon_social     VARCHAR(100) NOT NULL,
    denominacion     VARCHAR(100) NOT NULL,
    rif              INTEGER NOT NULL,
    direccion_fiscal TEXT NOT NULL,
    direccion_fisica TEXT NOT NULL,
    id_lugar         INTEGER NOT NULL,
    lugar_id2        INTEGER NOT NULL,
    url_web          VARCHAR(200) NOT NULL
);

CREATE TABLE Punto (
    id_metodo    INTEGER PRIMARY KEY,
    origen       VARCHAR(20) NOT NULL
);

CREATE TABLE Punto_Cliente (
    id_punto_cliente SERIAL PRIMARY KEY,
    id_cliente_natural INTEGER NOT NULL,
    id_metodo INTEGER NOT NULL,
    cantidad_mov INTEGER NOT NULL,
    fecha DATE NOT NULL,
    tipo_movimiento VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_cliente_natural) REFERENCES Cliente_Natural(id_cliente),
    FOREIGN KEY (id_metodo) REFERENCES Punto(id_metodo)
);

CREATE TABLE Receta (
    id_receta        SERIAL PRIMARY KEY,
    id_tipo_cerveza  INTEGER NOT NULL,
    descripcion      TEXT
);

CREATE TABLE Receta_Ingrediente (
    id_receta      INTEGER NOT NULL,
    id_ingrediente INTEGER NOT NULL,
    PRIMARY KEY (id_receta, id_ingrediente)
);

CREATE TABLE Rol (
    id_rol     SERIAL PRIMARY KEY,
    nombre     VARCHAR(50) NOT NULL
);

CREATE TABLE Tarjeta_Credito (
    id_metodo         INTEGER PRIMARY KEY,
    tipo              VARCHAR(20) NOT NULL,
    numero            VARCHAR(20) NOT NULL,
    banco             VARCHAR(30) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    FOREIGN KEY (id_metodo) REFERENCES Metodo_Pago(id_metodo)
);

CREATE TABLE Tarjeta_Debito (
    id_metodo INTEGER PRIMARY KEY,
    numero    VARCHAR(20) NOT NULL,
    banco     VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_metodo) REFERENCES Metodo_Pago(id_metodo)
);


CREATE TABLE Telefono (
    id_telefono     SERIAL PRIMARY KEY,
    codigo_area     VARCHAR(5) NOT NULL,
    numero          VARCHAR(15) NOT NULL,
    id_proveedor    INTEGER,
    id_contacto     INTEGER,
    id_invitado     INTEGER,
    id_cliente_juridico      INTEGER,
    id_cliente_natural      INTEGER,
    
    CONSTRAINT arc_propietario_telefono CHECK (
        (id_invitado IS NOT NULL AND id_proveedor IS NULL AND id_contacto IS NULL AND id_cliente_natural IS NULL AND id_cliente_juridico IS NULL) OR
        (id_proveedor IS NOT NULL AND id_invitado IS NULL AND id_contacto IS NULL AND id_cliente_natural IS NULL AND id_cliente_juridico IS NULL) OR
        (id_contacto IS NOT NULL AND id_invitado IS NULL AND id_proveedor IS NULL AND id_cliente_natural IS NULL AND id_cliente_juridico IS NULL) OR
        (id_cliente_juridico IS NOT NULL AND id_cliente_natural IS NULL AND id_invitado IS NULL AND id_proveedor IS NULL AND id_contacto IS NULL) OR
        (id_cliente_natural IS NOT NULL AND id_cliente_juridico IS NULL AND id_invitado IS NULL AND id_proveedor IS NULL AND id_contacto IS NULL)
    )
);

CREATE TABLE Tienda_Fisica (
    id_tienda_fisica SERIAL PRIMARY KEY,
    id_lugar         INTEGER NOT NULL,
    nombre           VARCHAR(50) NOT NULL,
    direccion        TEXT NOT NULL
);

CREATE TABLE Tienda_Web (
    id_tienda_web SERIAL PRIMARY KEY,
    nombre        VARCHAR(50) NOT NULL,
    url           VARCHAR(200) NOT NULL
);

CREATE TABLE Tipo_Actividad (
    id_tipo_actividad SERIAL PRIMARY KEY,
    nombre            VARCHAR(100) NOT NULL
);

CREATE TABLE Tipo_Cerveza (
    id_tipo_cerveza   SERIAL PRIMARY KEY,
    nombre            VARCHAR(50) NOT NULL,
    tipo_padre_id     INTEGER
);

CREATE TABLE Tipo_Invitado (
    id_tipo_invitado SERIAL PRIMARY KEY,
    nombre           VARCHAR(100) NOT NULL
);

CREATE TABLE TipoEvento (
    id_tipo_evento SERIAL PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    descripcion    TEXT NOT NULL
);

CREATE TABLE Ubicacion_Tienda (
    id_ubicacion        SERIAL PRIMARY KEY,
    tipo                VARCHAR(20) NOT NULL,
    nombre              VARCHAR(50) NOT NULL,
    ubicacion_tienda_relacion_id  INTEGER,
    id_tienda_web       INTEGER NOT NULL,
    id_tienda_fisica    INTEGER NOT NULL
);

CREATE TABLE Usuario (
    id_usuario      SERIAL PRIMARY KEY,
    id_cliente_juridico      INTEGER,
    id_cliente_natural      INTEGER,
    id_rol          INTEGER,
    fecha_creacion  DATE NOT NULL,
    id_proveedor    INTEGER,
    empleado_id     INTEGER,
    contraseña      VARCHAR(255) NOT NULL,

    CONSTRAINT arc_tipo_usuario CHECK (
        (id_cliente_natural IS NOT NULL AND id_cliente_juridico IS NULL AND empleado_id IS NULL AND id_proveedor IS NULL) OR
        (id_cliente_natural IS NULL AND id_cliente_juridico IS NOT NULL AND empleado_id IS NULL AND id_proveedor IS NULL) OR
        (id_cliente_natural IS NULL AND id_cliente_juridico IS NULL AND empleado_id IS NOT NULL AND id_proveedor IS NULL) OR
        (id_cliente_natural IS NULL AND id_cliente_juridico IS NULL AND empleado_id IS NULL AND id_proveedor IS NOT NULL) 
    ),

    CONSTRAINT rol_para_empleado CHECK (
        (empleado_id IS NOT NULL AND id_rol IS NOT NULL) OR
        (empleado_id IS NULL AND id_rol IS NULL) 

    )
);

CREATE TABLE Vacacion (
    id_vacacion     SERIAL PRIMARY KEY,
    fecha_inicio    DATE NOT NULL,
    fecha_fin       DATE NOT NULL,
    descripcion     TEXT NOT NULL,
    empleado_id     INTEGER NOT NULL
);

CREATE TABLE Venta_Evento (
    evento_id       INTEGER NOT NULL,
    id_cliente_natural      INTEGER NOT NULL,
    fecha_compra    TIMESTAMP NOT NULL,
    total           DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (evento_id, id_cliente_natural)
);

