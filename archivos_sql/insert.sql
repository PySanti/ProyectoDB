INSERT INTO Tipo_Actividad (nombre) VALUES
('Taller Técnico'),
('Conferencia'),
('Degustación'),
('Masterclass'),
('Seminario'),
('Mesa Redonda'),
('Demostración'),
('Competencia'),
('Networking'),
('Presentación');

INSERT INTO Beneficio (nombre, descripcion, monto, activo) VALUES
('Bono Alimentación', 'Bono mensual para alimentación de empleados', 150.00, 'S'),
('Seguro Médico', 'Cobertura médica integral para empleados y familiares', 200.00, 'S'),
('Bono Transporte', 'Subsidio mensual para transporte público', 80.00, 'S'),
('Prima Vacacional', 'Bono adicional durante período vacacional', 300.00, 'S'),
('Bono Productividad', 'Incentivo por cumplimiento de metas de ventas', 250.00, 'S'),
('Capacitación Cervecera', 'Cursos y talleres sobre cerveza artesanal', 120.00, 'S'),
('Bono Navideño', 'Aguinaldo navideño para empleados', 400.00, 'S'),
('Descuento Productos', 'Descuento del 30% en productos ACAUCAB', 50.00, 'S'),
('Seguro de Vida', 'Póliza de seguro de vida para empleados', 100.00, 'S'),
('Bono Antigüedad', 'Bono por años de servicio en la asociación', 180.00, 'N');

INSERT INTO Empleado (cedula, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, direccion, activo, lugar_id_lugar) VALUES
('V-12345678', 'Carlos', 'Alberto', 'González', 'Pérez', 'Av. Libertador, Edificio Torre Central, Piso 5, Apt 5-A', 'S', 52), -- Distrito Capital - Libertador
('V-23456789', 'María', 'Elena', 'Rodríguez', 'Martínez', 'Calle Principal de Las Mercedes, Casa #45', 'S', 56), -- Miranda - Baruta
('V-34567890', 'José', 'Luis', 'Hernández', 'Silva', 'Urbanización El Trigal, Calle 5, Casa 123', 'S', 66), -- Carabobo - Valencia
('V-45678901', 'Ana', 'Beatriz', 'López', 'García', 'Sector La Candelaria, Carrera 15 con Calle 8, Casa 67', 'S', 52), -- Distrito Capital - Libertador
('V-56789012', 'Miguel', 'Ángel', 'Fernández', 'Morales', 'Av. Universidad, Residencias Los Rosales, Torre B, Apt 8-C', 'S', 58), -- Miranda - Chacao
('V-67890123', 'Carmen', 'Rosa', 'Jiménez', 'Vargas', 'Calle Bolívar, Centro Comercial Sambil, Local 234', 'S', 64), -- Carabobo - Naguanagua
('V-78901234', 'Roberto', 'Antonio', 'Mendoza', 'Castillo', 'Zona Industrial de Maracaibo, Galpón 15', 'S', 77), -- Zulia - Maracaibo
('V-89012345', 'Luisa', 'Fernanda', 'Torres', 'Ramos', 'Urbanización Santa Rosa, Calle Los Mangos, Casa 89', 'S', 33), -- Anzoátegui - Anaco
('V-90123456', 'Pedro', 'José', 'Moreno', 'Díaz', 'Av. Principal de Puerto La Cruz, Edificio Mar Azul, Piso 3', 'S', 49), -- Anzoátegui - Juan Antonio Sotillo
('V-01234567', 'Gabriela', 'Isabel', 'Ruiz', 'Herrera', 'Calle Real de Los Teques, Quinta Villa Hermosa', 'S', 61); -- Miranda - Guaicaipuro

INSERT INTO Asistencia (fecha_hora_entrada, fecha_hora_salida, empleado_id_empleado) VALUES
-- Empleado 1 (Carlos González) - ID 1
('2024-12-16 08:15:00', '2024-12-16 17:30:00', 1),
('2024-12-17 08:00:00', '2024-12-17 17:15:00', 1),
('2024-12-18 08:30:00', '2024-12-18 17:45:00', 1),
-- Empleado 2 (María Rodríguez) - ID 2
('2024-12-16 07:45:00', '2024-12-16 16:45:00', 2),
('2024-12-17 08:10:00', '2024-12-17 17:00:00', 2),
('2024-12-18 08:05:00', '2024-12-18 17:20:00', 2),
-- Empleado 3 (José Hernández) - ID 3
('2024-12-16 08:20:00', '2024-12-16 17:25:00', 3),
('2024-12-17 08:15:00', '2024-12-17 17:10:00', 3),
('2024-12-18 08:00:00', '2024-12-18 17:00:00', 3),
-- Empleado 4 (Ana López) - ID 4
('2024-12-16 08:00:00', '2024-12-16 17:00:00', 4),
('2024-12-17 08:25:00', '2024-12-17 17:30:00', 4),
('2024-12-18 08:10:00', '2024-12-18 17:15:00', 4),
-- Empleado 5 (Miguel Fernández) - ID 5
('2024-12-16 08:35:00', '2024-12-16 17:40:00', 5),
('2024-12-17 08:05:00', '2024-12-17 17:05:00', 5),
('2024-12-18 08:20:00', '2024-12-18 17:25:00', 5),
-- Empleado 6 (Carmen Jiménez) - ID 6
('2024-12-16 07:55:00', '2024-12-16 16:55:00', 6),
('2024-12-17 08:15:00', '2024-12-17 17:20:00', 6),
('2024-12-18 08:30:00', '2024-12-18 17:35:00', 6),
-- Empleado 7 (Roberto Mendoza) - ID 7
('2024-12-16 08:10:00', '2024-12-16 17:15:00', 7),
('2024-12-17 08:00:00', '2024-12-17 17:00:00', 7),
('2024-12-18 08:25:00', '2024-12-18 17:30:00', 7),
-- Empleado 8 (Luisa Torres) - ID 8
('2024-12-16 08:05:00', '2024-12-16 17:10:00', 8),
('2024-12-17 08:20:00', '2024-12-17 17:25:00', 8),
('2024-12-18 08:15:00', '2024-12-18 17:20:00', 8),
-- Empleado 9 (Pedro Moreno) - ID 9
('2024-12-16 08:30:00', '2024-12-16 17:35:00', 9),
('2024-12-17 08:10:00', '2024-12-17 17:15:00', 9),
('2024-12-18 08:00:00', '2024-12-18 17:05:00', 9),
-- Empleado 10 (Gabriela Ruiz) - ID 10
('2024-12-16 07:50:00', '2024-12-16 16:50:00', 10),
('2024-12-17 08:15:00', '2024-12-17 17:20:00', 10),
('2024-12-18 08:25:00', '2024-12-18 17:30:00', 10);

INSERT INTO Vacacion (fecha_inicio, fecha_fin, descripcion, empleado_id) VALUES
-- Empleado 1 (Carlos González)
('2024-07-15', '2024-07-26', 'Vacaciones anuales de verano - Viaje familiar a Margarita', 1),
('2024-12-23', '2024-12-30', 'Vacaciones de fin de año - Celebraciones navideñas', 1),
-- Empleado 2 (María Rodríguez)
('2024-03-18', '2024-03-22', 'Vacaciones de Semana Santa - Descanso familiar', 2),
('2024-08-05', '2024-08-16', 'Vacaciones anuales - Viaje a Los Roques', 2),
-- Empleado 3 (José Hernández)
('2024-06-10', '2024-06-14', 'Vacaciones personales - Asuntos familiares', 3),
('2024-11-04', '2024-11-08', 'Vacaciones por motivos de salud - Recuperación médica', 3),
-- Empleado 4 (Ana López)
('2024-04-22', '2024-04-26', 'Vacaciones de primavera - Descanso personal', 4),
('2024-09-16', '2024-09-27', 'Vacaciones anuales - Viaje al exterior', 4),
-- Empleado 5 (Miguel Fernández)
('2024-05-13', '2024-05-17', 'Vacaciones por matrimonio - Luna de miel', 5),
('2024-12-16', '2024-12-20', 'Vacaciones de fin de año - Preparativos navideños', 5),
-- Empleado 6 (Carmen Jiménez)
('2024-02-12', '2024-02-16', 'Vacaciones de carnaval - Celebraciones tradicionales', 6),
('2024-10-07', '2024-10-18', 'Vacaciones anuales - Visita a familiares en el interior', 6),
-- Empleado 7 (Roberto Mendoza)
('2024-01-08', '2024-01-12', 'Vacaciones de inicio de año - Descanso post-navideño', 7),
('2024-08-19', '2024-08-30', 'Vacaciones anuales - Viaje a Mérida', 7),
-- Empleado 8 (Luisa Torres)
('2024-06-24', '2024-06-28', 'Vacaciones de San Juan - Celebraciones regionales', 8),
('2024-11-18', '2024-11-22', 'Vacaciones personales - Asuntos académicos', 8),
-- Empleado 9 (Pedro Moreno)
('2024-03-25', '2024-03-29', 'Vacaciones de Semana Santa - Retiro espiritual', 9),
('2024-07-29', '2024-08-02', 'Vacaciones de verano - Descanso familiar', 9),
-- Empleado 10 (Gabriela Ruiz)
('2024-05-27', '2024-05-31', 'Vacaciones por maternidad - Cuidado familiar', 10),
('2024-09-02', '2024-09-06', 'Vacaciones de regreso a clases - Asuntos familiares', 10);

INSERT INTO Horario (dia, hora_entrada, hora_salida) VALUES
('2024-12-16', '08:00:00', '17:00:00'),
('2024-12-17', '08:00:00', '17:00:00'),
('2024-12-18', '08:00:00', '17:00:00'),
('2024-12-19', '08:00:00', '17:00:00'),
('2024-12-20', '08:00:00', '17:00:00'),
('2024-12-21', '09:00:00', '13:00:00'),
('2024-12-23', '08:30:00', '16:30:00'),
('2024-12-24', '08:00:00', '12:00:00'),
('2024-12-26', '09:00:00', '18:00:00'),
('2024-12-27', '08:00:00', '17:00:00');

INSERT INTO Horario_Empleado (id_empleado, id_horario) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

INSERT INTO TipoEvento (nombre, descripcion) VALUES
('Festival de Cerveza', 'Evento masivo de degustación y venta de cervezas artesanales con múltiples proveedores'),
('Taller de Cata', 'Sesión educativa para aprender a degustar y evaluar diferentes tipos de cerveza artesanal'),
('Lanzamiento de Producto', 'Presentación oficial de nuevas cervezas artesanales de nuestros miembros proveedores'),
('Maridaje Gastronómico', 'Evento de combinación de cervezas artesanales con platos gourmet y comida tradicional'),
('Competencia de Cerveceros', 'Concurso entre cerveceros artesanales para premiar la mejor cerveza por categoría'),
('Conferencia Técnica', 'Charlas especializadas sobre técnicas de elaboración y tendencias en cerveza artesanal'),
('Networking Empresarial', 'Encuentro de negocios entre proveedores, distribuidores y clientes del sector cervecero'),
('Celebración Temática', 'Eventos especiales por fechas importantes como Oktoberfest, Día de la Cerveza, etc.'),
('Curso de Elaboración', 'Capacitación práctica para aprender a elaborar cerveza artesanal desde cero'),
('Feria Comercial', 'Exposición comercial de productos, equipos y servicios relacionados con cerveza artesanal');

INSERT INTO Evento (nombre, descripcion, fecha_inicio, fecha_fin, lugar_id_lugar, n_entradas_vendidas, precio_unitario_entrada, tipo_evento_id) VALUES
('UBirra 2024', 'Festival anual de cerveza artesanal con 30 productores venezolanos y degustación de más de 50 tipos de cerveza', '2024-07-19 10:00:00', '2024-07-20 22:00:00', 52, 850, 25.00, 1),
('Taller de Cata Premium', 'Sesión especializada de degustación dirigida por maestros cerveceros con cervezas importadas y nacionales', '2024-08-15 18:00:00', '2024-08-15 21:00:00', 58, 45, 75.00, 2),
('Lanzamiento Cerveza Caraqueña', 'Presentación oficial de la nueva línea de cervezas artesanales inspiradas en sabores tradicionales de Caracas', '2024-09-10 19:00:00', '2024-09-10 23:00:00', 56, 120, 35.00, 3),
('Maridaje Andino', 'Experiencia gastronómica combinando cervezas artesanales con platos típicos de la región andina venezolana', '2024-10-05 17:00:00', '2024-10-05 22:00:00', 61, 80, 95.00, 4),
('Copa ACAUCAB 2024', 'Competencia nacional de cerveceros artesanales con jurado internacional y premios por categorías', '2024-11-12 09:00:00', '2024-11-14 18:00:00', 66, 200, 45.00, 5),
('Conferencia Técnica Avanzada', 'Charlas magistrales sobre innovación en procesos de fermentación y nuevas tendencias mundiales', '2024-06-22 14:00:00', '2024-06-22 18:00:00', 64, 75, 55.00, 6),
('Networking Cervecero Valencia', 'Encuentro de negocios para fortalecer alianzas entre productores, distribuidores y puntos de venta', '2024-05-18 16:00:00', '2024-05-18 20:00:00', 66, 95, 40.00, 7),
('Oktoberfest Venezolano', 'Celebración tradicional alemana adaptada con cervezas artesanales venezolanas y música folklórica', '2024-10-19 15:00:00', '2024-10-19 23:00:00', 77, 650, 30.00, 8),
('Curso Básico de Elaboración', 'Capacitación práctica de fin de semana para aprender técnicas básicas de producción cervecera artesanal', '2024-09-28 08:00:00', '2024-09-29 17:00:00', 33, 25, 180.00, 9),
('Feria Cervecera del Zulia', 'Exposición comercial regional con stands de equipos, insumos y productos cerveceros artesanales', '2024-12-07 10:00:00', '2024-12-08 19:00:00', 77, 320, 20.00, 10);

INSERT INTO Horario_Evento (id_evento, id_horario) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

INSERT INTO Tipo_Invitado (nombre) VALUES
('Maestro Cervecero'),
('Sommelier de Cerveza'),
('Distribuidor Mayorista'),
('Propietario de Brewpub'),
('Consultor en Cervecería'),
('Periodista Especializado'),
('Influencer Gastronómico'),
('Chef Especialista en Maridajes'),
('Proveedor de Equipos'),
('Académico Investigador');

INSERT INTO Invitado (nombre, lugar_id, tipo_invitado_id, rif, direccion) VALUES
('Carlos Mendoza - Cervecería Artesanal El Dorado', 52, 1, 123456789, 'Av. Francisco de Miranda, Torre Empresarial, Piso 12, Caracas'),
('María Fernández - Sommelier Certificada', 56, 2, 234567890, 'Calle Los Rosales, Quinta Villa Hermosa, Las Mercedes, Miranda'),
('José Rodríguez - Distribuidora Cervecera Nacional', 66, 3, 345678901, 'Zona Industrial Norte, Galpón 45, Valencia, Carabobo'),
('Ana Gutiérrez - Brewpub La Tradición', 77, 4, 456789012, 'Av. Bella Vista, Centro Comercial Maracaibo Plaza, Local 234'),
('Miguel Torres - Consultor Técnico Cervecero', 58, 5, 567890123, 'Urbanización El Rosal, Torre Financiera, Oficina 801, Chacao'),
('Carmen López - Revista Cerveza & Gastronomía', 52, 6, 678901234, 'Av. Urdaneta, Edificio El Universal, Piso 8, Caracas'),
('Roberto Silva - @CervezaVenezuela', 61, 7, 789012345, 'Calle Real de Los Teques, Residencias Los Pinos, Apt 15-B'),
('Luisa Morales - Chef Especialista', 64, 8, 890123456, 'Av. Bolívar Norte, Restaurante Tradición, Naguanagua, Carabobo'),
('Pedro Ramírez - Equipos Cerveceros Andinos', 33, 9, 901234567, 'Sector Industrial, Calle Principal, Galpón 12, Anaco'),
('Gabriela Herrera - Universidad Gastronómica', 49, 10, 012345678, 'Campus Universitario, Facultad de Ciencias, Puerto La Cruz');

INSERT INTO Invitado_Evento (id_invitado, id_evento, hora_llegada, hora_salida) VALUES
(1, 1, '10:30:00', '21:30:00'),
(2, 2, '18:15:00', '20:45:00'),
(3, 3, '19:30:00', '22:30:00'),
(4, 4, '17:30:00', '21:30:00'),
(5, 5, '09:30:00', '17:30:00'),
(6, 6, '14:30:00', '17:30:00'),
(7, 7, '16:30:00', '19:30:00'),
(8, 8, '15:30:00', '22:30:00'),
(9, 9, '08:30:00', '16:30:00'),
(10, 10, '10:30:00', '18:30:00');

INSERT INTO Actividad (tema, invitado_evento_invitado_id_invitado, invitado_evento_evento_id_evento, tipo_actividad_id_tipo_actividad) VALUES
('Técnicas de Fermentación', 1, 1, 1),
('Historia de la Cerveza Venezolana', 2, 2, 2),
('Cata Dirigida de Cervezas Tipo Ale', 3, 3, 3),
(' Elaboración de Cerveza Belga', 4, 4, 4),
('Seminario sobre Producción Cervecera', 5, 5, 5),
('Futuro de la Cerveza Artesanal', 6, 6, 6),
('Demostración Práctica de Lupulado', 7, 7, 7),
('Competencia de Cata a Ciegas ', 8, 8, 8),
('Oportunidades de Negocio en Cerveza', 9, 9, 9),
('Presentación de Nuevas Variedades', 10, 10, 10);

INSERT INTO Metodo_Pago (id_metodo) VALUES
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10),
(11), (12), (13), (14), (15), (16), (17), (18), (19), (20),
(21), (22), (23), (24), (25), (26), (27), (28), (29), (30),
(31), (32), (33), (34), (35), (36), (37), (38), (39), (40);

INSERT INTO Efectivo (id_metodo, denominacion) VALUES
(1, 1),
(2, 5),
(3, 10),
(4, 20),
(5, 50),
(6, 100),
(7, 200),
(8, 500);


INSERT INTO Cheque (id_metodo, num_cheque, num_cuenta, banco) VALUES
(11, 1001, 112345678, 'Banco de Venezuela'),
(12, 1002, 213456789, 'Banesco'),
(13, 1003, 314567890, 'Banco Mercantil'),
(14, 1004, 415678901, 'BBVA Provincial'),
(15, 1005, 516789012, 'Banco Bicentenario'),
(16, 1006, 617890123, 'Bancaribe'),
(17, 1007, 718901234, 'Banco Exterior'),
(18, 1008, 819012345, 'Banco Plaza'),
(19, 1009, 910123456, 'Mi Banco'),
(20, 1010, 101234569, 'Banco Activo');

INSERT INTO Tarjeta_Credito (id_metodo, tipo, numero, banco, fecha_vencimiento) VALUES
(21, 'Visa', '4111111111111111', 'Banco de Venezuela', '2026-12-31'),
(22, 'MasterCard', '5555555555554444', 'Banesco', '2027-06-30'),
(23, 'American Express', '378282246310005', 'Banco Mercantil', '2025-09-30'),
(24, 'Visa', '4000000000000002', 'BBVA Provincial', '2026-03-31'),
(25, 'MasterCard', '5105105105105100', 'Banco Bicentenario', '2027-11-30'),
(26, 'Visa', '4012888888881881', 'Bancaribe', '2025-08-31'),
(27, 'MasterCard', '5431111111111111', 'Banco Exterior', '2026-07-31'),
(28, 'Visa', '4222222222222', 'Banco Plaza', '2027-02-28'),
(29, 'American Express', '371449635398431', 'Mi Banco', '2025-12-31'),
(30, 'MasterCard', '5555555555554444', 'Banco Activo', '2026-10-31');

INSERT INTO Tarjeta_Debito (id_metodo, numero, banco) VALUES
(31, '4111111111111112', 'Banco de Venezuela'),
(32, '5555555555554445', 'Banesco'),
(33, '4000000000000003', 'Banco Mercantil'),
(34, '4012888888881882', 'BBVA Provincial'),
(35, '5105105105105101', 'Banco Bicentenario'),
(36, '4222222222223', 'Bancaribe'),
(37, '5431111111111112', 'Banco Exterior'),
(38, '4111111111111113', 'Banco Plaza'),
(39, '5555555555554446', 'Mi Banco'),
(40, '4000000000000004', 'Banco Activo');

INSERT INTO Cargo (nombre, descripcion) VALUES
('Gerente General', 'Responsable de la dirección estratégica y operativa general de ACAUCAB, supervisa todos los departamentos'),
('Jefe de Compras', 'Responsable de aprobar órdenes de reposición de inventario y gestionar compras a proveedores miembros'),
('Gerente de Promociones', 'Encargado de seleccionar productos y descuentos para el DiarioDeUnaCerveza cada 30 días'),
('Jefe de Pasillos', 'Responsable de la reposición de productos en anaqueles cuando quedan 20 unidades disponibles'),
('Responsable de Talento Humano', 'Encargado del análisis de cumplimiento de horarios y gestión del personal mediante reportes biométricos'),
('Empleado de Ventas en Línea', 'Procesa presupuestos y compras vía correo electrónico, prepara pedidos para entrega'),
('Empleado de Despacho', 'Procesa pedidos y los tiene listos para entrega en máximo 2 horas, cambia estatus a "Listo para entrega"'),
('Empleado de Entrega', 'Busca pedidos en zona de despacho y los entrega a clientes, cambia estatus a "Entregado"'),
('Cajero de Tienda', 'Maneja ventas en tienda física, descuento de inventario, control y canjeo de puntos de clientes'),
('Especialista en Afiliaciones', 'Gestiona fichas de afiliación de miembros proveedores y cobro de cuotas mensuales');

INSERT INTO Departamento (nombre, fecha_creacion, descripcion, activo) VALUES
('Gerencia General', '2012-10-01', 'Departamento responsable de la dirección estratégica y operativa general de ACAUCAB', 'S'),
('Ventas en Línea', '2013-03-15', 'Departamento encargado de gestionar presupuestos y compras vía correo electrónico e internet', 'S'),
('Despacho', '2012-11-20', 'Departamento responsable de procesar pedidos y tenerlos listos para entrega en máximo 2 horas', 'S'),
('Entrega', '2012-12-01', 'Departamento encargado de la entrega de pedidos a clientes y cambio de estatus a "Entregado"', 'S'),
('Compras', '2013-01-10', 'Departamento responsable de órdenes de reposición de inventario y aprobación de compras a proveedores', 'S'),
('Promociones', '2013-02-14', 'Departamento encargado de la creación del DiarioDeUnaCerveza y gestión de ofertas cada 30 días', 'S'),
('Talento Humano', '2012-10-15', 'Departamento responsable del control de nómina, horarios, vacaciones, salarios y beneficios del personal', 'S'),
('Gestión de Miembros', '2012-10-01', 'Departamento encargado de la gestión de miembros proveedores, afiliaciones y cuotas mensuales', 'S'),
('Gestión de Clientes', '2013-01-05', 'Departamento responsable de la emisión de carnets, gestión de puntos y atención a clientes', 'S'),
('Sostenibilidad', '2020-01-01', 'Departamento encargado de informes de sostenibilidad, auditorías y cumplimiento de ODS', 'S');

INSERT INTO Departamento_Empleado (fecha_inicio, fecha_final, salario, id_empleado, id_departamento, id_cargo) VALUES
('2023-01-15', NULL, 8500.00, 1, 1, 1),  -- Carlos González - Gerencia General - Gerente General
('2023-02-01', NULL, 4200.00, 2, 7, 6),  -- María Rodríguez - Talento Humano - Asistente Administrativo
('2023-01-20', NULL, 5800.00, 3, 2, 4),  -- José Hernández - Ventas en Línea - Analista Financiero
('2023-03-01', NULL, 4800.00, 4, 9, 3),  -- Ana López - Gestión de Clientes - Especialista en Membresías
('2023-02-15', NULL, 5200.00, 5, 6, 5),  -- Miguel Fernández - Promociones - Coordinador de Marketing
('2023-01-10', NULL, 4000.00, 6, 3, 8),  -- Carmen Jiménez - Despacho - Coordinador Logístico
('2023-04-01', NULL, 4500.00, 7, 4, 8),  -- Roberto Mendoza - Entrega - Coordinador Logístico
('2023-03-15', NULL, 5500.00, 8, 5, 2),  -- Luisa Torres - Compras - Coordinador de Eventos
('2023-02-20', NULL, 4800.00, 9, 8, 9),  -- Pedro Moreno - Gestión de Miembros - Analista de Sistemas
('2023-05-01', NULL, 6200.00, 10, 10, 10); -- Gabriela Ruiz - Sostenibilidad - Relacionista Público

INSERT INTO Beneficio_Depto_Empleado (pagado, id_empleado, id_departamento, monto, id_beneficio) VALUES
('S', 1, 1, 150.00, 1),  -- Carlos González - Gerencia General - Bono de Alimentación
('S', 1, 1, 300.00, 2),  -- Carlos González - Gerencia General - Seguro de Salud
('S', 2, 7, 150.00, 1),  -- María Rodríguez - Talento Humano - Bono de Alimentación
('N', 2, 7, 80.00, 3),   -- María Rodríguez - Talento Humano - Bono de Transporte (pendiente)
('S', 3, 2, 300.00, 2),  -- José Hernández - Ventas en Línea - Seguro de Salud
('S', 4, 9, 150.00, 1),  -- Ana López - Gestión de Clientes - Bono de Alimentación
('S', 5, 6, 250.00, 6),  -- Miguel Fernández - Promociones - Bono de Productividad
('N', 6, 3, 400.00, 7),  -- Carmen Jiménez - Despacho - Capacitación Profesional (pendiente)
('S', 8, 5, 50.00, 8),   -- Luisa Torres - Compras - Seguro de Vida
('S', 10, 10, 300.00, 2); -- Gabriela Ruiz - Sostenibilidad - Seguro de Salud
