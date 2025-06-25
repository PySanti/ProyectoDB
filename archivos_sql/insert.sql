-- ORDEN DE EJECUCIÓN DE BLOQUES DE INSERT
-- Sistema de Gestión de Cervecería Artesanal UCAB
-- Respeta todas las dependencias de Foreign Keys

-- =====================================================
-- BLOQUE 1: TABLAS BASE (Sin dependencias)
-- =====================================================

INSERT INTO Lugar (nombre, tipo) VALUES
('Anzoátegui', 'Estado'),
('Amazonas', 'Estado'),
('Apure', 'Estado'),
('Aragua', 'Estado'),
('Barinas', 'Estado'),
('Bolívar', 'Estado'),
('Carabobo', 'Estado'),
('Cojedes', 'Estado'),
('Delta Amacuro', 'Estado'),
('Distrito Capital', 'Estado'),
('Falcón', 'Estado'),
('Guárico', 'Estado'),
('Lara', 'Estado'),
('Mérida', 'Estado'),
('Miranda', 'Estado'),
('Monagas', 'Estado'),
('Nueva Esparta', 'Estado'),
('Portuguesa', 'Estado'),
('Sucre', 'Estado'),
('Táchira', 'Estado'),
('Trujillo', 'Estado'),
('La Guaira', 'Estado'),
('Yaracuy', 'Estado'),
('Zulia', 'Estado');

INSERT INTO Lugar (nombre, tipo, lugar_relacion_id) VALUES
-- Amazonas (id de Estado: 1)
('Alto Orinoco', 'Municipio', 1),
('Atabapo', 'Municipio', 1),
('Atures', 'Municipio', 1),
('Autana', 'Municipio', 1),
('Manapiare', 'Municipio', 1),
('Maroa', 'Municipio', 1),
('Río Negro', 'Municipio', 1),

-- Anzoátegui (id de Estado: 2)
('Anaco', 'Municipio', 2),
('Aragua', 'Municipio', 2),
('Diego Bautista Urbaneja', 'Municipio', 2),
('Fernando de Peñalver', 'Municipio', 2),
('Francisco del Carmen Carvajal', 'Municipio', 2),
('Francisco de Miranda', 'Municipio', 2),
('Guanta', 'Municipio', 2),
('Independencia', 'Municipio', 2),
('José Gregorio Monagas', 'Municipio', 2),
('Juan Antonio Sotillo', 'Municipio', 2),
('Juan Manuel Cajigal', 'Municipio', 2),
('Libertad', 'Municipio', 2),
('Manuel Ezequiel Bruzual', 'Municipio', 2),
('Pedro María Freites', 'Municipio', 2),
('Píritu', 'Municipio', 2),
('San José de Guanipa', 'Municipio', 2),
('San Juan de Capistrano', 'Municipio', 2),
('Santa Ana', 'Municipio', 2),
('Simón Bolívar', 'Municipio', 2),
('Simón Rodríguez', 'Municipio', 2),
('Sir Artur McGregor', 'Municipio', 2),

-- Apure (id de Estado: 3)
('Achaguas', 'Municipio', 3),
('Biruaca', 'Municipio', 3),
('Muñoz', 'Municipio', 3),
('Páez', 'Municipio', 3),
('Pedro Camejo', 'Municipio', 3),
('Rómulo Gallegos', 'Municipio', 3),
('San Fernando', 'Municipio', 3),

-- Aragua (id de Estado: 4)
('Bolívar', 'Municipio', 4),
('Camatagua', 'Municipio', 4),
('Francisco Linares Alcántara', 'Municipio', 4),
('Girardot', 'Municipio', 4),
('José Ángel Lamas', 'Municipio', 4),
('José Félix Ribas', 'Municipio', 4),
('José Rafael Revenga', 'Municipio', 4),
('Libertador', 'Municipio', 4),
('Mario Briceño Iragorry', 'Municipio', 4),
('Ocumare de la Costa de Oro', 'Municipio', 4),
('San Casimiro', 'Municipio', 4),
('San Sebastián', 'Municipio', 4),
('Santiago Mariño', 'Municipio', 4),
('Santos Michelena', 'Municipio', 4),
('Sucre', 'Municipio', 4),
('Tovar', 'Municipio', 4),
('Urdaneta', 'Municipio', 4),
('Zamora', 'Municipio', 4),

-- Barinas (id de Estado: 5)
('Alberto Arvelo Torrealba', 'Municipio', 5),
('Andrés Eloy Blanco', 'Municipio', 5),
('Antonio José de Sucre', 'Municipio', 5),
('Arismendi', 'Municipio', 5),
('Barinas', 'Municipio', 5),
('Bolívar', 'Municipio', 5),
('Cruz Paredes', 'Municipio', 5),
('Ezequiel Zamora', 'Municipio', 5),
('Obispos', 'Municipio', 5),
('Pedraza', 'Municipio', 5),
('Rojas', 'Municipio', 5),
('Sosa', 'Municipio', 5),

-- Bolívar (id de Estado: 6)
('Angostura', 'Municipio', 6),
('Caroní', 'Municipio', 6),
('Cedeño', 'Municipio', 6),
('El Callao', 'Municipio', 6),
('Gran Sabana', 'Municipio', 6),
('Heres', 'Municipio', 6),
('Padre Pedro Chien', 'Municipio', 6),
('Piar', 'Municipio', 6),
('Roscio', 'Municipio', 6),
('Sifontes', 'Municipio', 6),
('Sucre', 'Municipio', 6),

-- Carabobo (id de Estado: 7)
('Bejuma', 'Municipio', 7),
('Carlos Arvelo', 'Municipio', 7),
('Diego Ibarra', 'Municipio', 7),
('Guacara', 'Municipio', 7),
('Juan José Mora', 'Municipio', 7),
('Libertador', 'Municipio', 7),
('Los Guayos', 'Municipio', 7),
('Miranda', 'Municipio', 7),
('Montalbán', 'Municipio', 7),
('Naguanagua', 'Municipio', 7),
('Puerto Cabello', 'Municipio', 7),
('San Diego', 'Municipio', 7),
('San Joaquín', 'Municipio', 7),
('Valencia', 'Municipio', 7),

-- Cojedes (id de Estado: 8)
('Anzoátegui', 'Municipio', 8),
('Falcón', 'Municipio', 8),
('Girardot', 'Municipio', 8),
('Lima Blanco', 'Municipio', 8),
('Pao de San Juan Bautista', 'Municipio', 8),
('Ricaurte', 'Municipio', 8),
('Rómulo Gallegos', 'Municipio', 8),
('San Carlos', 'Municipio', 8),
('Tinaco', 'Municipio', 8),

-- Delta Amacuro (id de Estado: 9)
('Antonio Díaz', 'Municipio', 9),
('Casacoima', 'Municipio', 9),
('Pedernales', 'Municipio', 9),
('Tucupita', 'Municipio', 9),

-- Distrito Capital (id de Estado: 10)
('Libertador', 'Municipio', 10),

-- Falcón (id de Estado: 11)
('Acosta', 'Municipio', 11),
('Bolívar', 'Municipio', 11),
('Buchivacoa', 'Municipio', 11),
('Cacique Manaure', 'Municipio', 11),
('Carirubana', 'Municipio', 11),
('Colina', 'Municipio', 11),
('Dabajuro', 'Municipio', 11),
('Democracia', 'Municipio', 11),
('Falcón', 'Municipio', 11),
('Federación', 'Municipio', 11),
('Jacura', 'Municipio', 11),
('Los Taques', 'Municipio', 11),
('Mauroa', 'Municipio', 11),
('Miranda', 'Municipio', 11),
('Monseñor Iturriza', 'Municipio', 11),
('Palmasola', 'Municipio', 11),
('Petit', 'Municipio', 11),
('Píritu', 'Municipio', 11),
('San Francisco', 'Municipio', 11),
('Silva', 'Municipio', 11),
('Sucre', 'Municipio', 11),
('Tocopero', 'Municipio', 11),
('Unión', 'Municipio', 11),
('Urumaco', 'Municipio', 11),
('Zamora', 'Municipio', 11),

-- Guárico (id de Estado: 12)
('Camaguán', 'Municipio', 12),
('Chaguaramas', 'Municipio', 12),
('El Socorro', 'Municipio', 12),
('Francisco de Miranda', 'Municipio', 12),
('José Félix Ribas', 'Municipio', 12),
('José Tadeo Monagas', 'Municipio', 12),
('Juan Germán Roscio', 'Municipio', 12),
('Julián Mellado', 'Municipio', 12),
('Las Mercedes', 'Municipio', 12),
('Leonardo Infante', 'Municipio', 12),
('Ortiz', 'Municipio', 12),
('San Gerónimo de Guayabal', 'Municipio', 12),
('San José de Guaribe', 'Municipio', 12),
('Santa María de Ipire', 'Municipio', 12),
('Zaraza', 'Municipio', 12),

-- Lara (id de Estado: 13)
('Andrés Eloy Blanco', 'Municipio', 13),
('Crespo', 'Municipio', 13),
('Iribarren', 'Municipio', 13),
('Jiménez', 'Municipio', 13),
('Morán', 'Municipio', 13),
('Palavecino', 'Municipio', 13),
('Simón Planas', 'Municipio', 13),
('Torres', 'Municipio', 13),
('Urdaneta', 'Municipio', 13),

-- Mérida (id de Estado: 14)
('Alberto Adriani', 'Municipio', 14),
('Andrés Bello', 'Municipio', 14),
('Antonio Pinto Salinas', 'Municipio', 14),
('Aricagua', 'Municipio', 14),
('Arzobispo Chacón', 'Municipio', 14),
('Campo Elías', 'Municipio', 14),
('Caracciolo Parra Olmedo', 'Municipio', 14),
('Cardenal Quintero', 'Municipio', 14),
('Guaraque', 'Municipio', 14),
('Julio César Salas', 'Municipio', 14),
('Justo Briceño', 'Municipio', 14),
('Libertador', 'Municipio', 14),
('Miranda', 'Municipio', 14),
('Obispo Ramos de Lora', 'Municipio', 14),
('Padre Noguera', 'Municipio', 14),
('Pueblo Llano', 'Municipio', 14),
('Rangel', 'Municipio', 14),
('Rivas Dávila', 'Municipio', 14),
('Santos Marquina', 'Municipio', 14),
('Sucre', 'Municipio', 14),
('Tovar', 'Municipio', 14),
('Tulio Febres Cordero', 'Municipio', 14),
('Zea', 'Municipio', 14),

-- Miranda (id de Estado: 15)
('Acevedo', 'Municipio', 15),
('Andrés Bello', 'Municipio', 15),
('Baruta', 'Municipio', 15),
('Brión', 'Municipio', 15),
('Buroz', 'Municipio', 15),
('Carrizal', 'Municipio', 15),
('Chacao', 'Municipio', 15),
('Cristóbal Rojas', 'Municipio', 15),
('El Hatillo', 'Municipio', 15),
('Guaicaipuro', 'Municipio', 15),
('Independencia', 'Municipio', 15),
('Los Salias', 'Municipio', 15),
('Páez', 'Municipio', 15),
('Paz Castillo', 'Municipio', 15),
('Pedro Gual', 'Municipio', 15),
('Plaza', 'Municipio', 15),
('Simón Bolívar', 'Municipio', 15),
('Sucre', 'Municipio', 15),
('Tomás Lander', 'Municipio', 15),
('Urdaneta', 'Municipio', 15),
('Zamora', 'Municipio', 15),

-- Monagas (id de Estado: 16)
('Acosta', 'Municipio', 16),
('Aguasay', 'Municipio', 16),
('Bolívar', 'Municipio', 16),
('Caripe', 'Municipio', 16),
('Cedeño', 'Municipio', 16),
('Ezequiel Zamora', 'Municipio', 16),
('Libertador', 'Municipio', 16),
('Maturín', 'Municipio', 16),
('Piar', 'Municipio', 16),
('Punceres', 'Municipio', 16),
('Santa Bárbara', 'Municipio', 16),
('Sotillo', 'Municipio', 16),
('Uracoa', 'Municipio', 16),

-- Nueva Esparta (id de Estado: 17)
('Antolín del Campo', 'Municipio', 17),
('Arismendi', 'Municipio', 17),
('Díaz', 'Municipio', 17),
('García', 'Municipio', 17),
('Gómez', 'Municipio', 17),
('Macanao', 'Municipio', 17),
('Maneiro', 'Municipio', 17),
('Marcano', 'Municipio', 17),
('Mariño', 'Municipio', 17),
('Península de Macanao', 'Municipio', 17),
('Tubores', 'Municipio', 17),
('Villalba', 'Municipio', 17),

-- Portuguesa (id de Estado: 18)
('Agua Blanca', 'Municipio', 18),
('Araure', 'Municipio', 18),
('Esteller', 'Municipio', 18),
('Guanare', 'Municipio', 18),
('Guanarito', 'Municipio', 18),
('Monseñor José Vicente de Unda', 'Municipio', 18),
('Ospino', 'Municipio', 18),
('Páez', 'Municipio', 18),
('Papelón', 'Municipio', 18),
('San Genaro de Boconoíto', 'Municipio', 18),
('San Rafael de Onoto', 'Municipio', 18),
('Santa Rosalía', 'Municipio', 18),
('Sucre', 'Municipio', 18),
('Turén', 'Municipio', 18),

-- Sucre (id de Estado: 19)
('Andrés Eloy Blanco', 'Municipio', 19),
('Andrés Mata', 'Municipio', 19),
('Arismendi', 'Municipio', 19),
('Benítez', 'Municipio', 19),
('Bermúdez', 'Municipio', 19),
('Bolívar', 'Municipio', 19),
('Cajigal', 'Municipio', 19),
('Cruz Salmerón Acosta', 'Municipio', 19),
('Libertador', 'Municipio', 19),
('Mariño', 'Municipio', 19),
('Mejía', 'Municipio', 19),
('Montes', 'Municipio', 19),
('Ribero', 'Municipio', 19),
('Sucre', 'Municipio', 19),
('Valdez', 'Municipio', 19),

-- Táchira (id de Estado: 20)
('Andrés Bello', 'Municipio', 20),
('Antonio Rómulo Costa', 'Municipio', 20),
('Ayacucho', 'Municipio', 20),
('Bolívar', 'Municipio', 20),
('Cárdenas', 'Municipio', 20),
('Córdoba', 'Municipio', 20),
('Fernández Feo', 'Municipio', 20),
('Francisco de Miranda', 'Municipio', 20),
('García de Hevia', 'Municipio', 20),
('Guásimos', 'Municipio', 20),
('Independencia', 'Municipio', 20),
('Jáuregui', 'Municipio', 20),
('José María Vargas', 'Municipio', 20),
('Junín', 'Municipio', 20),
('Libertad', 'Municipio', 20),
('Libertador', 'Municipio', 20),
('Lobatera', 'Municipio', 20),
('Michelena', 'Municipio', 20),
('Panamericano', 'Municipio', 20),
('Pedro María Ureña', 'Municipio', 20),
('Rafael Urdaneta', 'Municipio', 20),
('Samuel Darío Maldonado', 'Municipio', 20),
('San Cristóbal', 'Municipio', 20),
('Seboruco', 'Municipio', 20),
('Simón Rodríguez', 'Municipio', 20),
('Sucre', 'Municipio', 20),
('Torbes', 'Municipio', 20),
('Uribante', 'Municipio', 20),

-- Trujillo (id de Estado: 21)
('Andrés Bello', 'Municipio', 21),
('Boconó', 'Municipio', 21),
('Bolívar', 'Municipio', 21),
('Candelaria', 'Municipio', 21),
('Carache', 'Municipio', 21),
('Escuque', 'Municipio', 21),
('José Felipe Márquez Cañizales', 'Municipio', 21),
('Juan Vicente Campo Elías', 'Municipio', 21),
('La Ceiba', 'Municipio', 21),
('Miranda', 'Municipio', 21),
('Monte Carmelo', 'Municipio', 21),
('Motatán', 'Municipio', 21),
('Pampán', 'Municipio', 21),
('Pampanito', 'Municipio', 21),
('Rafael Rangel', 'Municipio', 21),
('San Rafael de Carvajal', 'Municipio', 21),
('Sucre', 'Municipio', 21),
('Trujillo', 'Municipio', 21),
('Urdaneta', 'Municipio', 21),
('Valera', 'Municipio', 21),

-- La Guaira (Vargas) (id de Estado: 22)
('Vargas', 'Municipio', 22),

-- Yaracuy (id de Estado: 23)
('Arístides Bastidas', 'Municipio', 23),
('Bolívar', 'Municipio', 23),
('Bruzual', 'Municipio', 23),
('Cocorote', 'Municipio', 23),
('Independencia', 'Municipio', 23),
('José Antonio Páez', 'Municipio', 23),
('La Trinidad', 'Municipio', 23),
('Manuel Monge', 'Municipio', 23),
('Nirgua', 'Municipio', 23),
('Peña', 'Municipio', 23),
('San Felipe', 'Municipio', 23),
('Sucre', 'Municipio', 23),
('Urachiche', 'Municipio', 23),
('Veroes', 'Municipio', 23),

-- Zulia (id de Estado: 24)
('Almirante Padilla', 'Municipio', 24),
('Baralt', 'Municipio', 24),
('Cabimas', 'Municipio', 24),
('Catatumbo', 'Municipio', 24),
('Colón', 'Municipio', 24),
('Francisco Javier Pulgar', 'Municipio', 24),
('Guajira', 'Municipio', 24),
('Jesús Enrique Lossada', 'Municipio', 24),
('Jesús María Semprún', 'Municipio', 24),
('La Cañada de Urdaneta', 'Municipio', 24),
('Lagunillas', 'Municipio', 24),
('Machiques de Perijá', 'Municipio', 24),
('Mara', 'Municipio', 24),
('Maracaibo', 'Municipio', 24),
('Miranda', 'Municipio', 24),
('Rosario de Perijá', 'Municipio', 24),
('San Francisco', 'Municipio', 24),
('Santa Rita', 'Municipio', 24),
('Simón Bolívar', 'Municipio', 24),
('Sucre', 'Municipio', 24),
('Valmore Rodríguez', 'Municipio', 24);

-- Insertar Parroquias por Municipio (lugar_relacion_idar es la id del Municipio correspondiente)
-- ids de parroquias inician después de la última id de municipio (360)
INSERT INTO Lugar (nombre, tipo, lugar_relacion_id) VALUES
-- Parroquias del Distrito Capital (Municipio Libertador, id: 128)
('23 de Enero', 'Parroquia', 128),
('Altagracia', 'Parroquia', 128),
('Antímano', 'Parroquia', 128),
('Caricuao', 'Parroquia', 128),
('Catedral', 'Parroquia', 128),
('Coche', 'Parroquia', 128),
('El Junquito', 'Parroquia', 128),
('El Paraíso', 'Parroquia', 128),
('El Recreo', 'Parroquia', 128),
('El Valle', 'Parroquia', 128),
('La Candelaria', 'Parroquia', 128),
('La Pastora', 'Parroquia', 128),
('La Vega', 'Parroquia', 128),
('Macarao', 'Parroquia', 128),
('San Agustín', 'Parroquia', 128),
('San Bernardino', 'Parroquia', 128),
('San José', 'Parroquia', 128),
('San Juan', 'Parroquia', 128),
('San Pedro', 'Parroquia', 128),
('Santa Rosalía', 'Parroquia', 128),
('Santa Teresa', 'Parroquia', 128),
('Sucre (Catia)', 'Parroquia', 128),

-- Parroquias del Estado Amazonas
-- Municipio Alto Orinoco (id: 25)
('La Esmeralda', 'Parroquia', 25),
('Huachamacare', 'Parroquia', 25),
('Marawaka', 'Parroquia', 25),
('Mavaka', 'Parroquia', 25),
('Sierra Parima', 'Parroquia', 25),
-- Municipio Atabapo (id: 26)
('San Fernando de Atabapo', 'Parroquia', 26),
('Ucata', 'Parroquia', 26),
('Yapacana', 'Parroquia', 26),
('Caname', 'Parroquia', 26),
('Guayapo', 'Parroquia', 26),
-- Municipio Atures (id: 27)
('Puerto Ayacucho', 'Parroquia', 27),
('Fernando Girón Tovar', 'Parroquia', 27),
('Luis Alberto Gómez', 'Parroquia', 27),
('Parhueña', 'Parroquia', 27),
('Platanillal', 'Parroquia', 27),
('Samariapo', 'Parroquia', 27),
('Sipapo', 'Parroquia', 27),
('Tablones', 'Parroquia', 27),
('Coromoto', 'Parroquia', 27),
-- Municipio Autana (id: 28)
('Isla Ratón', 'Parroquia', 28),
('Samán de Atabapo', 'Parroquia', 28),
('Sipapo', 'Parroquia', 28),
-- Municipio Manapiare (id: 29)
('San Juan de Manapiare', 'Parroquia', 29),
('Alto Ventuari', 'Parroquia', 29),
('Medio Ventuari', 'Parroquia', 29),
('Bajo Ventuari', 'Parroquia', 29),
('Casiquiare', 'Parroquia', 29),
-- Municipio Maroa (id: 30)
('Maroa', 'Parroquia', 30),
('Victorino', 'Parroquia', 30),
('Comunidad', 'Parroquia', 30),
-- Municipio Río Negro (id: 31)
('San Carlos de Río Negro', 'Parroquia', 31),
('Solano', 'Parroquia', 31),
('Casiquiare', 'Parroquia', 31),

-- Parroquias del Estado Anzoátegui
-- Municipio Anaco (id: 32)
('Anaco', 'Parroquia', 32),
('San Joaquín', 'Parroquia', 32),
('San Mateo', 'Parroquia', 32),
-- Municipio Aragua (id: 33)
('Aragua de Barcelona', 'Parroquia', 33),
('Cachipo', 'Parroquia', 33),
-- Municipio Diego Bautista Urbaneja (id: 34)
('Lechería', 'Parroquia', 34),
('El Morro', 'Parroquia', 34),
-- Municipio Fernando de Peñalver (id: 35)
('Puerto Píritu', 'Parroquia', 35),
('San Miguel', 'Parroquia', 35),
('Sucre', 'Parroquia', 35),
-- Municipio Francisco del Carmen Carvajal (id: 36)
('Valle de Guanape', 'Parroquia', 36),
('Uveral', 'Parroquia', 36),
-- Municipio Francisco de Miranda (id: 37)
('Pariaguán', 'Parroquia', 37),
('Atapirire', 'Parroquia', 37),
('Bocas de Uchire', 'Parroquia', 37),
('El Pao', 'Parroquia', 37),
('San Diego de Cabrutica', 'Parroquia', 37),
-- Municipio Guanta (id: 38)
('Guanta', 'Parroquia', 38),
('Chorrerón', 'Parroquia', 38),
-- Municipio Independencia (id: 39)
('Soledad', 'Parroquia', 39),
('Mamo', 'Parroquia', 39),
('Carapa', 'Parroquia', 39),
-- Municipio José Gregorio Monagas (id: 40)
('Mapire', 'Parroquia', 40),
('Piar', 'Parroquia', 40),
('Santa Cruz', 'Parroquia', 40),
('San Diego de Cabrutica', 'Parroquia', 40),
-- Municipio Juan Antonio Sotillo (id: 41)
('Puerto La Cruz', 'Parroquia', 41),
('El Morro', 'Parroquia', 41),
('Pozuelos', 'Parroquia', 41),
('Santa Ana', 'Parroquia', 41),
-- Municipio Juan Manuel Cajigal (id: 42)
('Onoto', 'Parroquia', 42),
('San Pablo', 'Parroquia', 42),
-- Municipio Libertad (id: 43)
('San Mateo', 'Parroquia', 43),
('Bergantín', 'Parroquia', 43),
('Santa Rosa', 'Parroquia', 43),
-- Municipio Manuel Ezequiel Bruzual (id: 44)
('Clarines', 'Parroquia', 44),
('Guanape', 'Parroquia', 44),
('Sabana de Uchire', 'Parroquia', 44),
-- Municipio Pedro María Freites (id: 45)
('Cantaura', 'Parroquia', 45),
('Libertador', 'Parroquia', 45),
('Santa Rosa', 'Parroquia', 45),
('Sucre', 'Parroquia', 45),
-- Municipio Píritu (id: 46)
('Píritu', 'Parroquia', 46),
('San Francisco', 'Parroquia', 46),
-- Municipio San José de Guanipa (id: 47)
('San José de Guanipa', 'Parroquia', 47),
-- Municipio San Juan de Capistrano (id: 48)
('Boca de Uchire', 'Parroquia', 48),
('Puerto Píritu', 'Parroquia', 48),
-- Municipio Santa Ana (id: 49)
('Santa Ana', 'Parroquia', 49),
-- Municipio Simón Bolívar (Barcelona) (id: 50)
('El Carmen', 'Parroquia', 50),
('San Cristóbal', 'Parroquia', 50),
('Bergantín', 'Parroquia', 50),
('Caigua', 'Parroquia', 50),
('Naricual', 'Parroquia', 50),
('El Pilar', 'Parroquia', 50),
-- Municipio Simón Rodríguez (id: 51)
('El Tigre', 'Parroquia', 51),
('Guanipa', 'Parroquia', 51),
('Edmundo Barrios', 'Parroquia', 51),
-- Municipio Sir Artur McGregor (id: 52)
('El Chaparro', 'Parroquia', 52),
('Tomás Alfaro', 'Parroquia', 52),

-- Parroquias del Estado Apure
-- Municipio Achaguas (id: 53)
('Achaguas', 'Parroquia', 53),
('Apurito', 'Parroquia', 53),
('El Yagual', 'Parroquia', 53),
('Guachara', 'Parroquia', 53),
('Mucuritas', 'Parroquia', 53),
('Queseras del Medio', 'Parroquia', 53),
-- Municipio Biruaca (id: 54)
('Biruaca', 'Parroquia', 54),
('San Juan de Payara', 'Parroquia', 54),
-- Municipio Muñoz (id: 55)
('Bruzual', 'Parroquia', 55),
('Mantecal', 'Parroquia', 55),
('Quintero', 'Parroquia', 55),
('Rincón Hondo', 'Parroquia', 55),
('San Vicente', 'Parroquia', 55),
-- Municipio Páez (id: 56)
('Guasdualito', 'Parroquia', 56),
('Aramare', 'Parroquia', 56),
('Cunaviche', 'Parroquia', 56),
('El Amparo', 'Parroquia', 56),
('Puerto Páez', 'Parroquia', 56),
('San Camilo', 'Parroquia', 56),
('Urdaneta', 'Parroquia', 56),
-- Municipio Pedro Camejo (id: 57)
('San Juan de Payara', 'Parroquia', 57),
('Codazzi', 'Parroquia', 57),
('Cunaviche', 'Parroquia', 57),
('Elorza', 'Parroquia', 57),
-- Municipio Rómulo Gallegos (id: 58)
('Elorza', 'Parroquia', 58),
-- Municipio San Fernando (id: 59)
('San Fernando', 'Parroquia', 59),
('El Recreo', 'Parroquia', 59),
('Peñalver', 'Parroquia', 59),
('San Rafael de Atamaica', 'Parroquia', 59),
('Valle Hondo', 'Parroquia', 59),

-- Parroquias del Estado Aragua
-- Municipio Bolívar (id: 60)
('San Mateo', 'Parroquia', 60),
('Cagua', 'Parroquia', 60),
('El Consejo', 'Parroquia', 60),
('Las Tejerías', 'Parroquia', 60),
('Santa Cruz', 'Parroquia', 60),
-- Municipio Camatagua (id: 61)
('Camatagua', 'Parroquia', 61),
('Carmen de Cura', 'Parroquia', 61),
-- Municipio Francisco Linares Alcántara (id: 62)
('Santa Rita', 'Parroquia', 62),
('Francisco de Miranda', 'Parroquia', 62),
('Monseñor Feliciano González', 'Parroquia', 62),
-- Municipio Girardot (id: 63)
('Maracay', 'Parroquia', 63),
('Castaño', 'Parroquia', 63),
('Choroní', 'Parroquia', 63),
('El Limón', 'Parroquia', 63),
('Las Delicias', 'Parroquia', 63),
('Pedro José Ovalles', 'Parroquia', 63),
('San Isidro', 'Parroquia', 63),
('José Casanova Godoy', 'Parroquia', 63),
('Los Tacarigua', 'Parroquia', 63),
('Andrés Eloy Blanco', 'Parroquia', 63),
-- Municipio José Ángel Lamas (id: 64)
('Santa Cruz', 'Parroquia', 64),
('Arévalo Aponte', 'Parroquia', 64),
('San Mateo', 'Parroquia', 64),
-- Municipio José Félix Ribas (id: 65)
('La Victoria', 'Parroquia', 65),
('Castor Nieves Ríos', 'Parroquia', 65),
('Las Guacamayas', 'Parroquia', 65),
('Pao de Zárate', 'Parroquia', 65),
('Zuata', 'Parroquia', 65),
-- Municipio José Rafael Revenga (id: 66)
('El Consejo', 'Parroquia', 66),
('Pocache', 'Parroquia', 66),
('Tocorón', 'Parroquia', 66),
-- Municipio Libertador (Aragua) (id: 67)
('Palo Negro', 'Parroquia', 67),
('San Martín de Porres', 'Parroquia', 67),
('Santa Rita', 'Parroquia', 67),
('El Libertador', 'Parroquia', 67),
-- Municipio Mario Briceño Iragorry (id: 68)
('El Limón', 'Parroquia', 68),
('Caña de Azúcar', 'Parroquia', 68),
-- Municipio Ocumare de la Costa de Oro (id: 69)
('Ocumare de la Costa', 'Parroquia', 69),
('Cata', 'Parroquia', 69),
('Independencia', 'Parroquia', 69),
-- Municipio San Casimiro (id: 70)
('San Casimiro', 'Parroquia', 70),
('Guiripa', 'Parroquia', 70),
('Ollas de Caramacate', 'Parroquia', 70),
('Valle Morín', 'Parroquia', 70),
-- Municipio San Sebastián (id: 71)
('San Sebastián', 'Parroquia', 71),
-- Municipio Santiago Mariño (id: 72)
('Turmero', 'Parroquia', 72),
('Aragua', 'Parroquia', 72),
('Alfredo Pacheco Miranda', 'Parroquia', 72),
('Chuao', 'Parroquia', 72),
('Samán de Güere', 'Parroquia', 72),
-- Municipio Santos Michelena (id: 73)
('Las Tejerías', 'Parroquia', 73),
('Tiara', 'Parroquia', 73),
-- Municipio Sucre (Aragua) (id: 74)
('Cagua', 'Parroquia', 74),
('Bella Vista', 'Parroquia', 74),
-- Municipio Tovar (id: 75)
('Colonia Tovar', 'Parroquia', 75),
-- Municipio Urdaneta (Aragua) (id: 76)
('Barbacoas', 'Parroquia', 76),
('San Francisco de Cara', 'Parroquia', 76),
('Taguay', 'Parroquia', 76),
('Las Peñitas', 'Parroquia', 76),
-- Municipio Zamora (Aragua) (id: 77)
('Villa de Cura', 'Parroquia', 77),
('Magdaleno', 'Parroquia', 77),
('San Francisco de Asís', 'Parroquia', 77),
('Valles de Tucutunemo', 'Parroquia', 77),
('Augusto Mijares', 'Parroquia', 77),

-- Parroquias del Estado Barinas
-- Municipio Alberto Arvelo Torrealba (id: 78)
('Sabaneta', 'Parroquia', 78),
('Juan Antonio Rodríguez Domínguez', 'Parroquia', 78),
-- Municipio Andrés Eloy Blanco (Barinas) (id: 79)
('El Cantón', 'Parroquia', 79),
('Santa Cruz de Guacas', 'Parroquia', 79),
('Puerto Vivas', 'Parroquia', 79),
-- Municipio Antonio José de Sucre (id: 80)
('Ticoporo', 'Parroquia', 80),
('Nicolás Pulido', 'Parroquia', 80),
('Andrés Bello', 'Parroquia', 80),
-- Municipio Arismendi (Barinas) (id: 81)
('Arismendi', 'Parroquia', 81),
('San Antonio', 'Parroquia', 81),
('Gabana', 'Parroquia', 81),
('San Rafael', 'Parroquia', 81),
-- Municipio Barinas (id: 82)
('Barinas', 'Parroquia', 82),
('Alfredo Arvelo Larriva', 'Parroquia', 82),
('Alto Barinas', 'Parroquia', 82),
('Corazón de Jesús', 'Parroquia', 82),
('Don Rómulo Betancourt', 'Parroquia', 82),
('Manuel Palacio Fajardo', 'Parroquia', 82),
('Ramón Ignacio Méndez', 'Parroquia', 82),
('San Silvestre', 'Parroquia', 82),
('Santa Inés', 'Parroquia', 82),
('Santa Lucía', 'Parroquia', 82),
('Trivino', 'Parroquia', 82),
('El Carmen', 'Parroquia', 82),
('Ciudad Bolivia', 'Parroquia', 82),
-- Municipio Bolívar (Barinas) (id: 83)
('Barinitas', 'Parroquia', 83),
('Altamira', 'Parroquia', 83),
('Calderas', 'Parroquia', 83),
-- Municipio Cruz Paredes (id: 84)
('Barrancas', 'Parroquia', 84),
('El Socorro', 'Parroquia', 84),
('Mazparrito', 'Parroquia', 84),
-- Municipio Ezequiel Zamora (Barinas) (id: 85)
('Santa Bárbara', 'Parroquia', 85),
('Pedro Briceño', 'Parroquia', 85),
('Ramón Ignacio Méndez', 'Parroquia', 85),
('Arismendi', 'Parroquia', 85),
-- Municipio Obispos (id: 86)
('Obispos', 'Parroquia', 86),
('El Real', 'Parroquia', 86),
('La Luz', 'Parroquia', 86),
('Los Guasimitos', 'Parroquia', 86),
-- Municipio Pedraza (id: 87)
('Ciudad Bolivia', 'Parroquia', 87),
('Andrés Bello', 'Parroquia', 87),
('Paez', 'Parroquia', 87),
('José Ignacio del Pumar', 'Parroquia', 87),
-- Municipio Rojas (id: 88)
('Libertad', 'Parroquia', 88),
('Dolores', 'Parroquia', 88),
('Palacio Fajardo', 'Parroquia', 88),
('Santa Rosa', 'Parroquia', 88),
-- Municipio Sosa (id: 89)
('Ciudad de Nutrias', 'Parroquia', 89),
('El Regalo', 'Parroquia', 89),
('Puerto de Nutrias', 'Parroquia', 89),
('Santa Catalina', 'Parroquia', 89),
('Simón Bolívar', 'Parroquia', 89),
('Valle de la Trinidad', 'Parroquia', 89),

-- Parroquias del Estado Bolívar
-- Municipio Angostura (anteriormente Heres) (id: 90)
('Ciudad Bolívar', 'Parroquia', 90),
('Agua Salada', 'Parroquia', 90),
('Caicara del Orinoco', 'Parroquia', 90),
('José Antonio Páez', 'Parroquia', 90),
('La Sabanita', 'Parroquia', 90),
('Maipure', 'Parroquia', 90),
('Panapana', 'Parroquia', 90),
('Orinoco', 'Parroquia', 90),
('San José de Tiznados', 'Parroquia', 90),
('Vista Hermosa', 'Parroquia', 90),
-- Municipio Caroní (id: 91)
('Ciudad Guayana', 'Parroquia', 91),
('Cachamay', 'Parroquia', 91),
('Dalla Costa', 'Parroquia', 91),
('Once de Abril', 'Parroquia', 91),
('Simón Bolívar', 'Parroquia', 91),
('Unare', 'Parroquia', 91),
('Universidad', 'Parroquia', 91),
('Vista al Sol', 'Parroquia', 91),
('Pozo Verde', 'Parroquia', 91),
('Yocoima', 'Parroquia', 91),
('5 de Julio', 'Parroquia', 91),
-- Municipio Cedeño (id: 92)
('Caicara del Orinoco', 'Parroquia', 92),
('Altagracia', 'Parroquia', 92),
('Ascensión de Sarare', 'Parroquia', 92),
('Guaniamo', 'Parroquia', 92),
('La Urbana', 'Parroquia', 92),
('Pijiguaos', 'Parroquia', 92),
-- Municipio El Callao (id: 93)
('El Callao', 'Parroquia', 93),
-- Municipio Gran Sabana (id: 94)
('Santa Elena de Uairén', 'Parroquia', 94),
('Ikabarú', 'Parroquia', 94),
-- Municipio Piar (id: 97)
('Upata', 'Parroquia', 97),
('Andrés Eloy Blanco', 'Parroquia', 97),
('Pedro Cova', 'Parroquia', 97),
-- Municipio Roscio (id: 98)
('Guasipati', 'Parroquia', 98),
('Salto Grande', 'Parroquia', 98),
('San José de Anacoco', 'Parroquia', 98),
('Santa Cruz', 'Parroquia', 98),
-- Municipio Sifontes (id: 99)
('Tumeremo', 'Parroquia', 99),
('Dalla Costa', 'Parroquia', 99),
('San Isidro', 'Parroquia', 99),
('Las Claritas', 'Parroquia', 99),
-- Municipio Sucre (Bolívar) (id: 100)
('Maripa', 'Parroquia', 100),
('Guarataro', 'Parroquia', 100),
('Aripao', 'Parroquia', 100),
('Las Majadas', 'Parroquia', 100),
('Moitaco', 'Parroquia', 100),

-- Parroquias del Estado Carabobo
-- Municipio Bejuma (id: 101)
('Bejuma', 'Parroquia', 101),
('Canoabo', 'Parroquia', 101),
('Simón Bolívar', 'Parroquia', 101),
-- Municipio Carlos Arvelo (id: 102)
('Güigüe', 'Parroquia', 102),
('Boquerón', 'Parroquia', 102),
('Tacaburua', 'Parroquia', 102),
('Capitán Aldama', 'Parroquia', 102),
-- Municipio Diego Ibarra (id: 103)
('Mariara', 'Parroquia', 103),
('Aguas Calientes', 'Parroquia', 103),
-- Municipio Guacara (id: 104)
('Guacara', 'Parroquia', 104),
('Ciudad Alianza', 'Parroquia', 104),
('Yagua', 'Parroquia', 104),
-- Municipio Juan José Mora (id: 105)
('Morón', 'Parroquia', 105),
('Urama', 'Parroquia', 105),
-- Municipio Libertador (Carabobo) (id: 106)
('Tocuyito', 'Parroquia', 106),
('Independencia', 'Parroquia', 106),
-- Municipio Los Guayos (id: 107)
('Los Guayos', 'Parroquia', 107),
-- Municipio Miranda (Carabobo) (id: 108)
('Miranda', 'Parroquia', 108),
-- Municipio Montalbán (id: 109)
('Montalbán', 'Parroquia', 109),
-- Municipio Naguanagua (id: 110)
('Naguanagua', 'Parroquia', 110),
-- Municipio Puerto Cabello (id: 111)
('Puerto Cabello', 'Parroquia', 111),
('Democracia', 'Parroquia', 111),
('Fraternidad', 'Parroquia', 111),
('Goaigoaza', 'Parroquia', 111),
('Independencia', 'Parroquia', 111),
('Juan José Flores', 'Parroquia', 111),
('Unión', 'Parroquia', 111),
('Borburata', 'Parroquia', 111),
('Patánemo', 'Parroquia', 111),
-- Municipio San Diego (Carabobo) (id: 112)
('San Diego', 'Parroquia', 112),
-- Municipio San Joaquín (id: 113)
('San Joaquín', 'Parroquia', 113),
-- Municipio Valencia (id: 114)
('Candelaria', 'Parroquia', 114),
('Catedral', 'Parroquia', 114),
('El Socorro', 'Parroquia', 114),
('Miguel Peña', 'Parroquia', 114),
('Rafael Urdaneta', 'Parroquia', 114),
('San Blas', 'Parroquia', 114),
('San José', 'Parroquia', 114),
('Santa Rosa', 'Parroquia', 114),
('Negro Primero', 'Parroquia', 114),

-- Parroquias del Estado Cojedes
-- Municipio Anzoátegui (Cojedes) (id: 115)
('Cojedes', 'Parroquia', 115),
('Juan de Mata Suárez', 'Parroquia', 115),
-- Municipio Falcón (Cojedes) (id: 116)
('Tinaquillo', 'Parroquia', 116),
-- Municipio Girardot (Cojedes) (id: 117)
('El Baúl', 'Parroquia', 117),
('Sucre', 'Parroquia', 117),
-- Municipio Lima Blanco (id: 118)
('Macapo', 'Parroquia', 118),
('La Aguadita', 'Parroquia', 118),
-- Municipio Pao de San Juan Bautista (id: 119)
('El Pao', 'Parroquia', 119),
-- Municipio Ricaurte (Cojedes) (id: 120)
('Libertad', 'Parroquia', 120),
('Manuel Manrique', 'Parroquia', 120),
-- Municipio Rómulo Gallegos (Cojedes) (id: 121)
('Las Vegas', 'Parroquia', 121),
-- Municipio San Carlos (Cojedes) (id: 122)
('San Carlos de Austria', 'Parroquia', 122),
('Juan Ángel Bravo', 'Parroquia', 122),
('Manuel Manrique', 'Parroquia', 122),
-- Municipio Tinaco (id: 123)
('Tinaco', 'Parroquia', 123),

-- Parroquias del Estado Delta Amacuro
-- Municipio Antonio Díaz (Delta Amacuro) (id: 124)
('Curiapo', 'Parroquia', 124),
('San José de Tucupita', 'Parroquia', 124),
('Canaima', 'Parroquia', 124),
('Padre Barral', 'Parroquia', 124),
('Manuel Renauld', 'Parroquia', 124),
('Capure', 'Parroquia', 124),
('Guayo', 'Parroquia', 124),
('Ibaruma', 'Parroquia', 124),
('Ambrosio', 'Parroquia', 124),
('Acosta', 'Parroquia', 124),
-- Municipio Casacoima (id: 125)
('Sierra Imataca', 'Parroquia', 125),
('Cinco de Julio', 'Parroquia', 125),
('Juan Bautista Arismendi', 'Parroquia', 125),
('Santos de Abelgas', 'Parroquia', 125),
('Imataca', 'Parroquia', 125),
-- Municipio Pedernales (id: 126)
('Pedernales', 'Parroquia', 126),
('Luis Beltrán Prieto Figueroa', 'Parroquia', 126),
-- Municipio Tucupita (id: 127)
('Tucupita', 'Parroquia', 127),
('Leonardo Ruiz Pineda', 'Parroquia', 127),
('Mariscal Antonio José de Sucre', 'Parroquia', 127),
('San Rafael', 'Parroquia', 127),
('Monseñor Argimiro García', 'Parroquia', 127),
('Antonio José de Sucre', 'Parroquia', 127),
('Josefa Camejo', 'Parroquia', 127),

-- Parroquias del Estado Falcón
-- Municipio Acosta (Falcón) (id: 130)
('San Juan de los Cayos', 'Parroquia', 130),
('Capadare', 'Parroquia', 130),
('La Pastora', 'Parroquia', 130),
('Libertador', 'Parroquia', 130),
-- Municipio Bolívar (Falcón) (id: 131)
('San Luis', 'Parroquia', 131),
('Aracua', 'Parroquia', 131),
('La Vela', 'Parroquia', 131),
('San Rafael de las Palmas', 'Parroquia', 131),
-- Municipio Buchivacoa (id: 132)
('Capatárida', 'Parroquia', 132),
('Bararida', 'Parroquia', 132),
('Goajiro', 'Parroquia', 132),
('Borojó', 'Parroquia', 132),
('Seque', 'Parroquia', 132),
('Zazárida', 'Parroquia', 132),
-- Municipio Cacique Manaure (id: 133)
('Yaracal', 'Parroquia', 133),
-- Municipio Carirubana (id: 134)
('Punto Fijo', 'Parroquia', 134),
('Carirubana', 'Parroquia', 134),
('Santa Ana', 'Parroquia', 134),
-- Municipio Colina (Falcón) (id: 135)
('La Vela de Coro', 'Parroquia', 135),
('Amuay', 'Parroquia', 135),
('La Esmeralda', 'Parroquia', 135),
('San Luis', 'Parroquia', 135),
('Sabana Grande', 'Parroquia', 135),
-- Municipio Dabajuro (id: 136)
('Dabajuro', 'Parroquia', 136),
-- Municipio Democracia (Falcón) (id: 137)
('Pedregal', 'Parroquia', 137),
('Aguas Buenas', 'Parroquia', 137),
('El Paují', 'Parroquia', 137),
('Purureche', 'Parroquia', 137),
('San Félix', 'Parroquia', 137),
-- Municipio Falcón (id: 138)
('Pueblo Nuevo', 'Parroquia', 138),
('Adícora', 'Parroquia', 138),
('Baraived', 'Parroquia', 138),
('Buena Vista', 'Parroquia', 138),
('Jadacaquiva', 'Parroquia', 138),
('Moruy', 'Parroquia', 138),
('Paramana', 'Parroquia', 138),
('El Vínculo', 'Parroquia', 138),
('Norte', 'Parroquia', 138),
-- Municipio Federación (id: 139)
('Churuguara', 'Parroquia', 139),
('Agua Larga', 'Parroquia', 139),
('El Paujicito', 'Parroquia', 139),
('Independencia', 'Parroquia', 139),
('Mapararí', 'Parroquia', 139),
-- Municipio Jacura (id: 140)
('Jacura', 'Parroquia', 140),
('Agua Salada', 'Parroquia', 140),
('Barrialito', 'Parroquia', 140),
('El Charal', 'Parroquia', 140),
-- Municipio Los Taques (id: 141)
('Santa Cruz de Los Taques', 'Parroquia', 141),
('Los Taques', 'Parroquia', 141),
-- Municipio Mauroa (id: 142)
('Mene de Mauroa', 'Parroquia', 142),
('Casigua', 'Parroquia', 142),
('San Félix', 'Parroquia', 142),
-- Municipio Miranda (Falcón) (id: 143)
('Santa Ana de Coro', 'Parroquia', 143),
('Guzmán Guillermo', 'Parroquia', 143),
('Mitare', 'Parroquia', 143),
('Río Seco', 'Parroquia', 143),
('Sabana Larga', 'Parroquia', 143),
('San Antonio', 'Parroquia', 143),
('San Gabriel', 'Parroquia', 143),
-- Municipio Monseñor Iturriza (id: 144)
('Chichiriviche', 'Parroquia', 144),
('Boca de Aroa', 'Parroquia', 144),
('San Juan de los Cayos', 'Parroquia', 144),
-- Municipio Palmasola (id: 145)
('Palmasola', 'Parroquia', 145),
-- Municipio Petit (id: 146)
('Cabure', 'Parroquia', 146),
('Colina', 'Parroquia', 146),
('El Paují', 'Parroquia', 146),
('Agua Larga', 'Parroquia', 146),
-- Municipio Píritu (Falcón) (id: 147)
('Píritu', 'Parroquia', 147),
('San José de la Costa', 'Parroquia', 147),
-- Municipio San Francisco (Falcón) (id: 148)
('Mirimire', 'Parroquia', 148),
('Agua Salada', 'Parroquia', 148),
('El Paují', 'Parroquia', 148),
-- Municipio Silva (id: 149)
('Tucacas', 'Parroquia', 149),
('Boca de Aroa', 'Parroquia', 149),
-- Municipio Sucre (Falcón) (id: 150)
('La Cruz de Taratara', 'Parroquia', 150),
('Agua Salada', 'Parroquia', 150),
('Piedra de Amolar', 'Parroquia', 150),
-- Municipio Tocopero (id: 151)
('Tocopero', 'Parroquia', 151),
-- Municipio Unión (Falcón) (id: 152)
('Santa Cruz de Bucaral', 'Parroquia', 152),
('El Charal', 'Parroquia', 152),
('Las Vegas', 'Parroquia', 152),
-- Municipio Urumaco (id: 153)
('Urumaco', 'Parroquia', 153),
-- Municipio Zamora (Falcón) (id: 154)
('Puerto Cumarebo', 'Parroquia', 154),
('La Ciénaga', 'Parroquia', 154),
('La Soledad', 'Parroquia', 154),
('Pueblo Nuevo', 'Parroquia', 154),
('San Rafael de La Vela', 'Parroquia', 154),

-- Parroquias del Estado Guárico
-- Municipio Camaguán (id: 155)
('Camaguán', 'Parroquia', 155),
('Puerto Miranda', 'Parroquia', 155),
('Uverito', 'Parroquia', 155),
-- Municipio Chaguaramas (id: 156)
('Chaguaramas', 'Parroquia', 156),
-- Municipio El Socorro (Guárico) (id: 157)
('El Socorro', 'Parroquia', 157),
-- Municipio Francisco de Miranda (Guárico) (id: 158)
('Calabozo', 'Parroquia', 158),
('El Calvario', 'Parroquia', 158),
('El Rastro', 'Parroquia', 158),
('Guardatinajas', 'Parroquia', 158),
('Saladillo', 'Parroquia', 158),
('San Rafael de los Cajones', 'Parroquia', 158),
-- Municipio José Félix Ribas (Guárico) (id: 159)
('Tucupido', 'Parroquia', 159),
('San Rafael de Orituco', 'Parroquia', 159),
-- Municipio José Tadeo Monagas (id: 160)
('Altagracia de Orituco', 'Parroquia', 160),
('Lezama', 'Parroquia', 160),
('Paso Real de Macaira', 'Parroquia', 160),
('San Francisco Javier de Lezama', 'Parroquia', 160),
('Santa María de Ipire', 'Parroquia', 160),
('Valle de la Pascua', 'Parroquia', 160),
-- Municipio Juan Germán Roscio (id: 161)
('San Juan de los Morros', 'Parroquia', 161),
('Cantagallo', 'Parroquia', 161),
('Parapara', 'Parroquia', 161),
-- Municipio Julián Mellado (id: 162)
('El Sombrero', 'Parroquia', 162),
('Sosa', 'Parroquia', 162),
-- Municipio Las Mercedes (Guárico) (id: 163)
('Las Mercedes', 'Parroquia', 163),
('Cabruta', 'Parroquia', 163),
('Santa Rita de Manapire', 'Parroquia', 163),
-- Municipio Leonardo Infante (id: 164)
('Valle de la Pascua', 'Parroquia', 164),
('Espino', 'Parroquia', 164),
-- Municipio Ortiz (id: 165)
('Ortiz', 'Parroquia', 165),
('San Francisco de Tiznados', 'Parroquia', 165),
('San José de Tiznados', 'Parroquia', 165),
('Guarico', 'Parroquia', 165),
-- Municipio San Gerónimo de Guayabal (id: 166)
('Guayabal', 'Parroquia', 166),
('Cazorla', 'Parroquia', 166),
-- Municipio San José de Guaribe (id: 167)
('San José de Guaribe', 'Parroquia', 167),
-- Municipio Santa María de Ipire (Guárico) (id: 168)
('Santa María de Ipire', 'Parroquia', 168),
('Altamira', 'Parroquia', 168),
-- Municipio Zaraza (id: 169)
('Zaraza', 'Parroquia', 169),
('San José de Unare', 'Parroquia', 169),

-- Parroquias del Estado Lara
-- Municipio Andrés Eloy Blanco (Lara) (id: 170)
('Sanare', 'Parroquia', 170),
('Pío Tamayo', 'Parroquia', 170),
('Yacambú', 'Parroquia', 170),
-- Municipio Crespo (id: 171)
('Duaca', 'Parroquia', 171),
('Farriar', 'Parroquia', 171),
-- Municipio Iribarren (id: 172)
('Barquisimeto', 'Parroquia', 172),
('Aguedo Felipe Alvarado', 'Parroquia', 172),
('Anselmo Belloso', 'Parroquia', 172),
('Buena Vista', 'Parroquia', 172),
('Catedral', 'Parroquia', 172),
('Concepción', 'Parroquia', 172),
('El Cují', 'Parroquia', 172),
('Juan de Villegas', 'Parroquia', 172),
('Santa Rosa', 'Parroquia', 172),
('Tamaca', 'Parroquia', 172),
('Unión', 'Parroquia', 172),
('Guerrera Ana Soto', 'Parroquia', 172),
-- Municipio Jiménez (Lara) (id: 173)
('Quíbor', 'Parroquia', 173),
('Coronel Mariano Peraza', 'Parroquia', 173),
('Diego de Lozada', 'Parroquia', 173),
('José Bernardo Dorantes', 'Parroquia', 173),
('Juan Bautista Rodríguez', 'Parroquia', 173),
('Paraíso de San José', 'Parroquia', 173),
('Tintorero', 'Parroquia', 173),
('Cuara', 'Parroquia', 173),
-- Municipio Morán (id: 174)
('El Tocuyo', 'Parroquia', 174),
('Anzoátegui', 'Parroquia', 174),
('Guárico', 'Parroquia', 174),
('Hilario Luna y Luna', 'Parroquia', 174),
('Humocaro Alto', 'Parroquia', 174),
('Humocaro Bajo', 'Parroquia', 174),
('La Candelaria', 'Parroquia', 174),
('Morán', 'Parroquia', 174),
-- Municipio Palavecino (id: 175)
('Cabudare', 'Parroquia', 175),
('José Gregorio Bastidas', 'Parroquia', 175),
('Agua Viva', 'Parroquia', 175),
-- Municipio Simón Planas (id: 176)
('Sarare', 'Parroquia', 176),
('Gustavo Vegas León', 'Parroquia', 176),
('Manzanita', 'Parroquia', 176),
-- Municipio Torres (id: 177)
('Carora', 'Parroquia', 177),
('Altagracia', 'Parroquia', 177),
('Antonio Díaz', 'Parroquia', 177),
('Camacaro', 'Parroquia', 177),
('Castañeda', 'Parroquia', 177),
('Cecilio Zubillaga', 'Parroquia', 177),
('Chiquinquirá', 'Parroquia', 177),
('El Blanco', 'Parroquia', 177),
('Espinoza de los Monteros', 'Parroquia', 177),
('Manuel Morillo', 'Parroquia', 177),
('Montaña', 'Parroquia', 177),
('Padre Pedro María Aguilar', 'Parroquia', 177),
('Torres', 'Parroquia', 177),
('Las Mercedes', 'Parroquia', 177),
('Paraíso de San José', 'Parroquia', 177),
-- Municipio Urdaneta (Lara) (id: 178)
('Siquisique', 'Parroquia', 178),
('Moroturo', 'Parroquia', 178),
('San Miguel', 'Parroquia', 178),
('Xaguas', 'Parroquia', 178),

-- Parroquias del Estado Mérida
-- Municipio Alberto Adriani (id: 179)
('El Vigía', 'Parroquia', 179),
('Presidente Páez', 'Parroquia', 179),
('Héctor Amable Mora', 'Parroquia', 179),
('Gabriel Picón González', 'Parroquia', 179),
('José Nucete Sardi', 'Parroquia', 179),
('Pulido Méndez', 'Parroquia', 179),
-- Municipio Andrés Bello (Mérida) (id: 180)
('La Azulita', 'Parroquia', 180),
-- Municipio Antonio Pinto Salinas (id: 181)
('Santa Cruz de Mora', 'Parroquia', 181),
('Mesa Bolívar', 'Parroquia', 181),
('Mesa de Las Palmas', 'Parroquia', 181),
-- Municipio Aricagua (id: 182)
('Aricagua', 'Parroquia', 182),
('San Antonio', 'Parroquia', 182),
-- Municipio Arzobispo Chacón (id: 183)
('Canaguá', 'Parroquia', 183),
('Capurí', 'Parroquia', 183),
('Chacantá', 'Parroquia', 183),
('El Molino', 'Parroquia', 183),
('Guaimaral', 'Parroquia', 183),
('Mucutuy', 'Parroquia', 183),
('Mucuchachí', 'Parroquia', 183),
-- Municipio Campo Elías (Mérida) (id: 184)
('Ejido', 'Parroquia', 184),
('Fernández Peña', 'Parroquia', 184),
('Montalbán', 'Parroquia', 184),
('San José del Sur', 'Parroquia', 184),
-- Municipio Caracciolo Parra Olmedo (id: 185)
('Tucaní', 'Parroquia', 185),
('Florencio Ramírez', 'Parroquia', 185),
('San Rafael de Alcázar', 'Parroquia', 185),
('Santa Elena de Arenales', 'Parroquia', 185),
-- Municipio Cardenal Quintero (id: 186)
('Santo Domingo', 'Parroquia', 186),
('Las Piedras', 'Parroquia', 186),
-- Municipio Guaraque (id: 187)
('Guaraque', 'Parroquia', 187),
('Mesa de Quintero', 'Parroquia', 187),
('Río Negro', 'Parroquia', 187),
-- Municipio Julio César Salas (id: 188)
('Arapuey', 'Parroquia', 188),
('Palmira', 'Parroquia', 188),
-- Municipio Justo Briceño (id: 189)
('Torondoy', 'Parroquia', 189),
('Las Playitas', 'Parroquia', 189),
-- Municipio Libertador (Mérida) (id: 190)
('Antonio Spinetti Dini', 'Parroquia', 190),
('Arias', 'Parroquia', 190),
('Caracciolo Parra Pérez', 'Parroquia', 190),
('Domingo Peña', 'Parroquia', 190),
('El Llano', 'Parroquia', 190),
('Gonzalo Picón Febres', 'Parroquia', 190),
('Juan Rodríguez Suárez', 'Parroquia', 190),
('Lagunillas', 'Parroquia', 190),
('Mariano Picón Salas', 'Parroquia', 190),
('Milla', 'Parroquia', 190),
('Osuna Rodríguez', 'Parroquia', 190),
('Presidente Betancourt', 'Parroquia', 190),
('Rómulo Gallegos', 'Parroquia', 190),
('Sagrario', 'Parroquia', 190),
('San Juan Bautista', 'Parroquia', 190),
('Santa Catalina', 'Parroquia', 190),
('Santa Lucía', 'Parroquia', 190),
('Santa Rosa', 'Parroquia', 190),
('Spinetti Dini', 'Parroquia', 190),
('El Morro', 'Parroquia', 190),
('Los Nevados', 'Parroquia', 190),
-- Municipio Miranda (Mérida) (id: 191)
('Timotes', 'Parroquia', 191),
('Andrés Eloy Blanco', 'Parroquia', 191),
('La Venta', 'Parroquia', 191),
('Santiago de la Punta', 'Parroquia', 191),
-- Municipio Obispo Ramos de Lora (id: 192)
('Santa Elena de Arenales', 'Parroquia', 192),
('Eloy Paredes', 'Parroquia', 192),
('San Rafael de Alcázar', 'Parroquia', 192),
-- Municipio Padre Noguera (id: 193)
('Santa María de Caparo', 'Parroquia', 193),
-- Municipio Pueblo Llano (id: 194)
('Pueblo Llano', 'Parroquia', 194),
-- Municipio Rangel (id: 195)
('Mucuchíes', 'Parroquia', 195),
('Cacute', 'Parroquia', 195),
('Gavidia', 'Parroquia', 195),
('La Toma', 'Parroquia', 195),
('Mucurubá', 'Parroquia', 195),
-- Municipio Rivas Dávila (id: 196)
('Bailadores', 'Parroquia', 196),
('Gerónimo Maldonado', 'Parroquia', 196),
-- Municipio Santos Marquina (id: 197)
('Tabay', 'Parroquia', 197),
-- Municipio Sucre (Mérida) (id: 198)
('Lagunillas', 'Parroquia', 198),
('Chiguará', 'Parroquia', 198),
('Estánques', 'Parroquia', 198),
('Pueblo Nuevo del Sur', 'Parroquia', 198),
('San Juan', 'Parroquia', 198),
-- Municipio Tovar (Mérida) (id: 199)
('Tovar', 'Parroquia', 199),
('El Amparo', 'Parroquia', 199),
('San Francisco', 'Parroquia', 199),
('Zea', 'Parroquia', 199),
-- Municipio Tulio Febres Cordero (id: 200)
('Nueva Bolivia', 'Parroquia', 200),
('Independencia', 'Parroquia', 200),
('Santa Apolonia', 'Parroquia', 200),
('Chaparral', 'Parroquia', 200),
-- Municipio Zea (id: 201)
('Zea', 'Parroquia', 201),
('Caño El Tigre', 'Parroquia', 201),

-- Parroquias del Estado Miranda
-- Municipio Acevedo (id: 202)
('Caucagua', 'Parroquia', 202),
('Aragüita', 'Parroquia', 202),
('Capaya', 'Parroquia', 202),
('Marizapa', 'Parroquia', 202),
('Panaquire', 'Parroquia', 202),
('Tapipa', 'Parroquia', 202),
('Ribas', 'Parroquia', 202),
-- Municipio Andrés Bello (Miranda) (id: 203)
('San José de Barlovento', 'Parroquia', 203),
('Cumbo', 'Parroquia', 203),
-- Municipio Baruta (id: 204)
('Nuestra Señora del Rosario', 'Parroquia', 204),
('El Cafetal', 'Parroquia', 204),
('Las Minas', 'Parroquia', 204),
-- Municipio Brión (id: 205)
('Higuerote', 'Parroquia', 205),
('Curiepe', 'Parroquia', 205),
('Tacarigua de Mamporal', 'Parroquia', 205),
-- Municipio Buroz (id: 206)
('Mamporal', 'Parroquia', 206),
-- Municipio Carrizal (id: 207)
('Carrizal', 'Parroquia', 207),
-- Municipio Chacao (id: 208)
('Chacao', 'Parroquia', 208),
-- Municipio Cristóbal Rojas (id: 209)
('Charallave', 'Parroquia', 209),
('Las Brisas', 'Parroquia', 209),
-- Municipio El Hatillo (id: 210)
('El Hatillo', 'Parroquia', 210),
-- Municipio Guaicaipuro (id: 211)
('Los Teques', 'Parroquia', 211),
('Paracotos', 'Parroquia', 211),
('San Antonio de los Altos', 'Parroquia', 211),
('San José de los Altos', 'Parroquia', 211),
('San Pedro', 'Parroquia', 211),
('Altagracia de la Montaña', 'Parroquia', 211),
('Cecilio Acosta', 'Parroquia', 211),
('Tacoa', 'Parroquia', 211),
-- Municipio Independencia (Miranda) (id: 212)
('Santa Teresa del Tuy', 'Parroquia', 212),
('El Cartanal', 'Parroquia', 212),
-- Municipio Los Salias (id: 213)
('San Antonio de los Altos', 'Parroquia', 213),
-- Municipio Páez (Miranda) (id: 214)
('Río Chico', 'Parroquia', 214),
('El Cafeto', 'Parroquia', 214),
('San Fernando', 'Parroquia', 214),
('Tacarigua de la Laguna', 'Parroquia', 214),
('Paparo', 'Parroquia', 214),
-- Municipio Paz Castillo (id: 215)
('Santa Lucía', 'Parroquia', 215),
-- Municipio Pedro Gual (id: 216)
('Cúpira', 'Parroquia', 216),
('Machurucuto', 'Parroquia', 216),
-- Municipio Plaza (id: 217)
('Guarenas', 'Parroquia', 217),
-- Municipio Simón Bolívar (Miranda) (id: 218)
('San Francisco de Yare', 'Parroquia', 218),
('San Antonio de Yare', 'Parroquia', 218),
('Simón Bolívar', 'Parroquia', 218),
-- Municipio Sucre (Miranda) (id: 219)
('Petare', 'Parroquia', 219),
('Caucagüita', 'Parroquia', 219),
('Fila de Mariches', 'Parroquia', 219),
('La Dolorita', 'Parroquia', 219),
('Leoncio Martínez', 'Parroquia', 219),
-- Municipio Tomás Lander (id: 220)
('Ocumare del Tuy', 'Parroquia', 220),
('La Democracia', 'Parroquia', 220),
('Santa Bárbara', 'Parroquia', 220),
('San Francisco de Yare', 'Parroquia', 220),
('Valle de la Pascua', 'Parroquia', 220),
-- Municipio Urdaneta (Miranda) (id: 221)
('Cúa', 'Parroquia', 221),
('Nueva Cúa', 'Parroquia', 221),
-- Municipio Zamora (Miranda) (id: 222)
('Guatire', 'Parroquia', 222),
('Araira', 'Parroquia', 222),
('Bolívar', 'Parroquia', 222),

-- Parroquias del Estado Monagas
-- Municipio Acosta (Monagas) (id: 223)
('San Antonio de Capayacuar', 'Parroquia', 223),
('San Francisco', 'Parroquia', 223),
-- Municipio Aguasay (id: 224)
('Aguasay', 'Parroquia', 224),
-- Municipio Bolívar (Monagas) (id: 225)
('Caripito', 'Parroquia', 225),
('Sabana Grande', 'Parroquia', 225),
-- Municipio Caripe (id: 226)
('Caripe', 'Parroquia', 226),
('El Guácharo', 'Parroquia', 226),
('La Guanota', 'Parroquia', 226),
('San Agustín', 'Parroquia', 226),
('Teresén', 'Parroquia', 226),
-- Municipio Cedeño (Monagas) (id: 227)
('Caicara de Maturín', 'Parroquia', 227),
('Areo', 'Parroquia', 227),
('San Félix', 'Parroquia', 227),
-- Municipio Ezequiel Zamora (Monagas) (id: 228)
('Punta de Mata', 'Parroquia', 228),
('El Tejero', 'Parroquia', 228),
-- Municipio Libertador (Monagas) (id: 229)
('Temblador', 'Parroquia', 229),
('Chaguaramas', 'Parroquia', 229),
('Las Alhuacas', 'Parroquia', 229),
-- Municipio Maturín (id: 230)
('Maturín', 'Parroquia', 230),
('Alto de Los Godos', 'Parroquia', 230),
('Boquerón', 'Parroquia', 230),
('Las Cocuizas', 'Parroquia', 230),
('La Pica', 'Parroquia', 230),
('San Simón', 'Parroquia', 230),
('El Corozo', 'Parroquia', 230),
('El Furrial', 'Parroquia', 230),
('Jusepín', 'Parroquia', 230),
('La Cruz', 'Parroquia', 230),
('San Vicente', 'Parroquia', 230),
-- Municipio Piar (Monagas) (id: 231)
('Aragua de Maturín', 'Parroquia', 231),
('Aparicio', 'Parroquia', 231),
('Chaguaramal', 'Parroquia', 231),
('El Pinto', 'Parroquia', 231),
('Guaripete', 'Parroquia', 231),
('La Cruz de la Paloma', 'Parroquia', 231),
('Taguaya', 'Parroquia', 231),
('El Zamuro', 'Parroquia', 231),
-- Municipio Punceres (id: 232)
('Quiriquire', 'Parroquia', 232),
('Punceres', 'Parroquia', 232),
-- Municipio Santa Bárbara (Monagas) (id: 233)
('Santa Bárbara', 'Parroquia', 233),
('Tabasca', 'Parroquia', 233),
-- Municipio Sotillo (Monagas) (id: 234)
('Barrancas del Orinoco', 'Parroquia', 234),
('Chaguaramos', 'Parroquia', 234),
-- Municipio Uracoa (id: 235)
('Uracoa', 'Parroquia', 235),

-- Parroquias del Estado Nueva Esparta
-- Municipio Antolín del Campo (id: 236)
('Paraguachí', 'Parroquia', 236),
('La Rinconada', 'Parroquia', 236),
-- Municipio Arismendi (Nueva Esparta) (id: 237)
('La Asunción', 'Parroquia', 237),
-- Municipio Díaz (id: 238)
('San Juan Bautista', 'Parroquia', 238),
('Concepción', 'Parroquia', 238),
-- Municipio García (id: 239)
('El Valle del Espíritu Santo', 'Parroquia', 239),
('San Antonio', 'Parroquia', 239),
-- Municipio Gómez (id: 240)
('Santa Ana', 'Parroquia', 240),
('Altagracia', 'Parroquia', 240),
('Coché', 'Parroquia', 240),
('Manzanillo', 'Parroquia', 240),
('Vicente Fuentes', 'Parroquia', 240),
-- Municipio Macanao (id: 241)
('Boca del Río', 'Parroquia', 241),
('San Francisco', 'Parroquia', 241),
-- Municipio Maneiro (id: 242)
('Pampatar', 'Parroquia', 242),
('Jorge Coll', 'Parroquia', 242),
('Aguas de Moya', 'Parroquia', 242),
-- Municipio Marcano (id: 243)
('Juan Griego', 'Parroquia', 243),
('Adrián', 'Parroquia', 243),
('Francisco Fajardo', 'Parroquia', 243),
-- Municipio Mariño (Nueva Esparta) (id: 244)
('Porlamar', 'Parroquia', 244),
('Los Robles', 'Parroquia', 244),
('Cristo de Aranza', 'Parroquia', 244),
('Bella Vista', 'Parroquia', 244),
('Mariño', 'Parroquia', 244),
('Villa Rosa', 'Parroquia', 244),
-- Municipio Península de Macanao (id: 245)
('Boca de Pozo', 'Parroquia', 245),
('San Francisco', 'Parroquia', 245),
-- Municipio Tubores (id: 246)
('Punta de Piedras', 'Parroquia', 246),
('Los Tubores', 'Parroquia', 246),
-- Municipio Villalba (id: 247)
('San Pedro de Coche', 'Parroquia', 247),
('El Bichar', 'Parroquia', 247),
('San Agustín', 'Parroquia', 247),

-- Parroquias del Estado Portuguesa
-- Municipio Agua Blanca (id: 248)
('Agua Blanca', 'Parroquia', 248),
-- Municipio Araure (id: 249)
('Araure', 'Parroquia', 249),
('Río Acarigua', 'Parroquia', 249),
-- Municipio Esteller (id: 250)
('Píritu', 'Parroquia', 250),
('Uveral', 'Parroquia', 250),
-- Municipio Guanare (id: 251)
('Guanare', 'Parroquia', 251),
('Córdoba', 'Parroquia', 251),
('Espino', 'Parroquia', 251),
('Mesa de Cavacas', 'Parroquia', 251),
('San Juan de Guanaguanare', 'Parroquia', 251),
('Virgen de Coromoto', 'Parroquia', 251),
-- Municipio Guanarito (id: 252)
('Guanarito', 'Parroquia', 252),
('Capital Guanarito', 'Parroquia', 252),
('Trinidad de la Capilla', 'Parroquia', 252),
('Uveral', 'Parroquia', 252),
-- Municipio Monseñor José Vicente de Unda (id: 253)
('Chabasquén', 'Parroquia', 253),
('Peña Blanca', 'Parroquia', 253),
-- Municipio Ospino (id: 254)
('Ospino', 'Parroquia', 254),
('La Aparición', 'Parroquia', 254),
('San Rafael de Palo Alzado', 'Parroquia', 254),
-- Municipio Páez (Portuguesa) (id: 255)
('Acarigua', 'Parroquia', 255),
('Payara', 'Parroquia', 255),
('Pimpinela', 'Parroquia', 255),
('Ramón Peraza', 'Parroquia', 255),
-- Municipio Papelón (id: 256)
('Papelón', 'Parroquia', 256),
('Caño Delgadito', 'Parroquia', 256),
-- Municipio San Genaro de Boconoíto (id: 257)
('San Genaro de Boconoíto', 'Parroquia', 257),
('Antolín Tovar', 'Parroquia', 257),
('Paraíso de San Genaro', 'Parroquia', 257),
-- Municipio San Rafael de Onoto (id: 258)
('San Rafael de Onoto', 'Parroquia', 258),
('Santa Fé', 'Parroquia', 258),
('San Roque', 'Parroquia', 258),
-- Municipio Santa Rosalía (id: 259)
('El Playón', 'Parroquia', 259),
('Canelones', 'Parroquia', 259),
-- Municipio Sucre (Portuguesa) (id: 260)
('Biscucuy', 'Parroquia', 260),
('San José de Saguaz', 'Parroquia', 260),
('San Rafael de Palo Alzado', 'Parroquia', 260),
('Uvencio Antonio Velásquez', 'Parroquia', 260),
('Villa de la Paz', 'Parroquia', 260),
-- Municipio Turén (id: 261)
('Villa Bruzual', 'Parroquia', 261),
('Canelones', 'Parroquia', 261),
('Santa Cruz', 'Parroquia', 261),
('San Isidro Labrador', 'Parroquia', 261),

-- Parroquias del Estado Sucre
-- Municipio Andrés Eloy Blanco (Sucre) (id: 262)
('Casanay', 'Parroquia', 262),
('Mariño', 'Parroquia', 262),
('Río Caribe', 'Parroquia', 262),
('San Juan de Unare', 'Parroquia', 262),
-- Municipio Andrés Mata (id: 263)
('San José de Aerocuar', 'Parroquia', 263),
('Tunapuy', 'Parroquia', 263),
-- Municipio Arismendi (Sucre) (id: 264)
('Río Caribe', 'Parroquia', 264),
('Antonio José de Sucre', 'Parroquia', 264),
('El Morro de Puerto Santo', 'Parroquia', 264),
('Punta de Piedras', 'Parroquia', 264),
('Río de Agua', 'Parroquia', 264),
-- Municipio Benítez (id: 265)
('El Pilar', 'Parroquia', 265),
('El Rincón', 'Parroquia', 265),
('Guaraúnos', 'Parroquia', 265),
('Tunapuicito', 'Parroquia', 265),
('Unión', 'Parroquia', 265),
-- Municipio Bermúdez (id: 266)
('Carúpano', 'Parroquia', 266),
('Macarapana', 'Parroquia', 266),
('Santa Catalina', 'Parroquia', 266),
('Santa Inés', 'Parroquia', 266),
('Santa Rosa', 'Parroquia', 266),
-- Municipio Bolívar (Sucre) (id: 267)
('Marigüitar', 'Parroquia', 267),
('San Antonio del Golfo', 'Parroquia', 267),
-- Municipio Cajigal (id: 268)
('Yaguaraparo', 'Parroquia', 268),
('El Paujil', 'Parroquia', 268),
('Libertad', 'Parroquia', 268),
('San Fernando', 'Parroquia', 268),
('Santa Bárbara', 'Parroquia', 268),
-- Municipio Cruz Salmerón Acosta (id: 269)
('Araya', 'Parroquia', 269),
('Chacopata', 'Parroquia', 269),
('Manicuare', 'Parroquia', 269),
-- Municipio Libertador (Sucre) (id: 270)
('San Juan de las Galdonas', 'Parroquia', 270),
('El Pilar', 'Parroquia', 270),
('San Juan', 'Parroquia', 270),
('San Vicente', 'Parroquia', 270),
-- Municipio Mariño (Sucre) (id: 271)
('Irapa', 'Parroquia', 271),
('Campo Elías', 'Parroquia', 271),
('Marigüitar', 'Parroquia', 271),
('San Antonio de Irapa', 'Parroquia', 271),
('Soro', 'Parroquia', 271),
-- Municipio Mejía (id: 272)
('San Antonio del Golfo', 'Parroquia', 272),
-- Municipio Montes (id: 273)
('Cumanacoa', 'Parroquia', 273),
('Arenas', 'Parroquia', 273),
('Aricagua', 'Parroquia', 273),
('Cocollar', 'Parroquia', 273),
('San Fernando', 'Parroquia', 273),
('San Lorenzo', 'Parroquia', 273),
-- Municipio Ribero (id: 274)
('Cariaco', 'Parroquia', 274),
('Catuaro', 'Parroquia', 274),
('Río Casanay', 'Parroquia', 274),
('San Agustín', 'Parroquia', 274),
('Santa María', 'Parroquia', 274),
-- Municipio Sucre (Sucre) (id: 275)
('Ayacucho', 'Parroquia', 275),
('Blanco', 'Parroquia', 275),
('Cumaná', 'Parroquia', 275),
('Valentín Valiente', 'Parroquia', 275),
('Altagracia', 'Parroquia', 275),
('Santa Inés', 'Parroquia', 275),
('San Juan', 'Parroquia', 275),
('Raúl Leoni', 'Parroquia', 275),
-- Municipio Valdez (id: 276)
('Güiria', 'Parroquia', 276),
('Bideau', 'Parroquia', 276),
('Cristóbal Colón', 'Parroquia', 276),
('Punta de Piedras', 'Parroquia', 276),
('Puerto Hierro', 'Parroquia', 276),

-- Parroquias del Estado Táchira
-- Municipio Andrés Bello (Táchira) (id: 277)
('Cordero', 'Parroquia', 277),
-- Municipio Antonio Rómulo Costa (id: 278)
('Las Mesas', 'Parroquia', 278),
-- Municipio Ayacucho (Táchira) (id: 279)
('Colón', 'Parroquia', 279),
('San Pedro del Río', 'Parroquia', 279),
('San Juan de Colón', 'Parroquia', 279),
-- Municipio Bolívar (Táchira) (id: 280)
('San Antonio del Táchira', 'Parroquia', 280),
('Juan Vicente Gómez', 'Parroquia', 280),
('Palotal', 'Parroquia', 280),
('Padre Marcos Figueroa', 'Parroquia', 280),
-- Municipio Cárdenas (id: 281)
('Táriba', 'Parroquia', 281),
('Jauregui', 'Parroquia', 281),
('La Florida', 'Parroquia', 281),
-- Municipio Córdoba (Táchira) (id: 282)
('Santa Ana', 'Parroquia', 282),
('San Rafael de Cordero', 'Parroquia', 282),
-- Municipio Fernández Feo (id: 283)
('San Rafael del Piñal', 'Parroquia', 283),
('Santo Domingo', 'Parroquia', 283),
('Juan Pablo Peñaloza', 'Parroquia', 283),
-- Municipio Francisco de Miranda (Táchira) (id: 284)
('San José de Bolívar', 'Parroquia', 284),
-- Municipio García de Hevia (id: 285)
('La Fría', 'Parroquia', 285),
('Panamericano', 'Parroquia', 285),
('Colón', 'Parroquia', 285),
-- Municipio Guásimos (id: 286)
('Palmira', 'Parroquia', 286),
('San Juan del Recreo', 'Parroquia', 286),
-- Municipio Independencia (Táchira) (id: 287)
('Capacho Nuevo', 'Parroquia', 287),
('Juan Vicente Bolívar', 'Parroquia', 287),
('Chipare', 'Parroquia', 287),
-- Municipio Jáuregui (Táchira) (id: 288)
('La Grita', 'Parroquia', 288),
('Emilio Constantino Guerrero', 'Parroquia', 288),
('Monseñor Alejandro Fernández Feo', 'Parroquia', 288),
-- Municipio José María Vargas (id: 289)
('El Cobre', 'Parroquia', 289),
-- Municipio Junín (Táchira) (id: 290)
('Rubio', 'Parroquia', 290),
('Bramón', 'Parroquia', 290),
('Delicias', 'Parroquia', 290),
('La Petrólea', 'Parroquia', 290),
-- Municipio Libertad (Táchira) (id: 291)
('Capacho Viejo', 'Parroquia', 291),
('Cipriano Castro', 'Parroquia', 291),
('Manuel Felipe Rugeles', 'Parroquia', 291),
-- Municipio Libertador (Táchira) (id: 292)
('Abejales', 'Parroquia', 292),
('Doradas', 'Parroquia', 292),
('Emilio Constantino Guerrero', 'Parroquia', 292),
('San Joaquín de Navay', 'Parroquia', 292),
-- Municipio Lobatera (id: 293)
('Lobatera', 'Parroquia', 293),
('Constitución', 'Parroquia', 293),
-- Municipio Michelena (id: 294)
('Michelena', 'Parroquia', 294),
-- Municipio Panamericano (id: 295)
('Colón', 'Parroquia', 295),
('La Palmita', 'Parroquia', 295),
('San Joaquín', 'Parroquia', 295),
-- Municipio Pedro María Ureña (id: 296)
('Ureña', 'Parroquia', 296),
('Pedro María Ureña', 'Parroquia', 296),
('Tienditas', 'Parroquia', 296),
-- Municipio Rafael Urdaneta (id: 297)
('Delicias', 'Parroquia', 297),
('Monseñor Miguel Ignacio Briceño', 'Parroquia', 297),
-- Municipio Samuel Darío Maldonado (id: 298)
('La Tendida', 'Parroquia', 298),
('Boconó', 'Parroquia', 298),
('Boconó Abajo', 'Parroquia', 298),
('Hernández', 'Parroquia', 298),
-- Municipio San Cristóbal (id: 299)
('San Cristóbal', 'Parroquia', 299),
('Francisco Romero Lobo', 'Parroquia', 299),
('La Concordia', 'Parroquia', 299),
('Pedro María Morantes', 'Parroquia', 299),
('San Juan Bautista', 'Parroquia', 299),
('San Sebastián', 'Parroquia', 299),
-- Municipio Seboruco (id: 300)
('Seboruco', 'Parroquia', 300),
-- Municipio Simón Rodríguez (Táchira) (id: 301)
('San Simón', 'Parroquia', 301),
-- Municipio Sucre (Táchira) (id: 302)
('Colón', 'Parroquia', 302),
('La Palmita', 'Parroquia', 302),
('San José', 'Parroquia', 302),
('San Pablo', 'Parroquia', 302),
-- Municipio Torbes (id: 303)
('San Josecito', 'Parroquia', 303),
-- Municipio Uribante (id: 304)
('Pregonero', 'Parroquia', 304),
('Cárdenas', 'Parroquia', 304),
('Juan Pablo Peñaloza', 'Parroquia', 304),
('Potosí', 'Parroquia', 304),

-- Parroquias del Estado Trujillo
-- Municipio Andrés Bello (Trujillo) (id: 305)
('Santa Isabel', 'Parroquia', 305),
('Araguaney', 'Parroquia', 305),
('El Jaguito', 'Parroquia', 305),
-- Municipio Boconó (id: 306)
('Boconó', 'Parroquia', 306),
('El Carmen', 'Parroquia', 306),
('Mosquey', 'Parroquia', 306),
('Ayacucho', 'Parroquia', 306),
('Burbusay', 'Parroquia', 306),
('General Ribas', 'Parroquia', 306),
('Guaramacal', 'Parroquia', 306),
('La Vega de Guaramacal', 'Parroquia', 306),
('San Miguel', 'Parroquia', 306),
('San Rafael', 'Parroquia', 306),
('Monseñor Carrillo', 'Parroquia', 306),
-- Municipio Bolívar (Trujillo) (id: 307)
('Sabana Grande', 'Parroquia', 307),
('Granados', 'Parroquia', 307),
('Cheregüé', 'Parroquia', 307),
-- Municipio Candelaria (Trujillo) (id: 308)
('Chejendé', 'Parroquia', 308),
('Arnoldo Gabaldón', 'Parroquia', 308),
('Carrillo', 'Parroquia', 308),
('Candelaria', 'Parroquia', 308),
('La Mesa de Esnujaque', 'Parroquia', 308),
('San José de la Haticos', 'Parroquia', 308),
('Santa Elena', 'Parroquia', 308),
-- Municipio Carache (id: 309)
('Carache', 'Parroquia', 309),
('La Concepción', 'Parroquia', 309),
('Cuicas', 'Parroquia', 309),
('Panamericana', 'Parroquia', 309),
('Santa Cruz', 'Parroquia', 309),
-- Municipio Escuque (id: 310)
('Escuque', 'Parroquia', 310),
('La Unión', 'Parroquia', 310),
('Sabana Libre', 'Parroquia', 310),
('Santa Rita', 'Parroquia', 310),
-- Municipio José Felipe Márquez Cañizales (id: 311)
('El Socorro', 'Parroquia', 311),
('Los Caprichos', 'Parroquia', 311),
-- Municipio Juan Vicente Campo Elías (id: 312)
('Campo Elías', 'Parroquia', 312),
('Arnoldo Gabaldón', 'Parroquia', 312),
-- Municipio La Ceiba (id: 313)
('Santa Apolonia', 'Parroquia', 313),
('El Progreso', 'Parroquia', 313),
('La Ceiba', 'Parroquia', 313),
('Tres de Febrero', 'Parroquia', 313),
-- Municipio Miranda (Trujillo) (id: 314)
('El Dividive', 'Parroquia', 314),
('Agua Santa', 'Parroquia', 314),
('Agua Caliente', 'Parroquia', 314),
('Flor de Patria', 'Parroquia', 314),
('La Paz', 'Parroquia', 314),
-- Municipio Monte Carmelo (id: 315)
('Monte Carmelo', 'Parroquia', 315),
('Buena Vista', 'Parroquia', 315),
('Santa Cruz', 'Parroquia', 315),
-- Municipio Motatán (id: 316)
('Motatán', 'Parroquia', 316),
('Jalisco', 'Parroquia', 316),
('El Baño', 'Parroquia', 316),
-- Municipio Pampán (id: 317)
('Pampán', 'Parroquia', 317),
('Flor de Patria', 'Parroquia', 317),
('La Paz', 'Parroquia', 317),
('Santa Ana', 'Parroquia', 317),
-- Municipio Pampanito (id: 318)
('Pampanito', 'Parroquia', 318),
('La Concepción', 'Parroquia', 318),
('Santa Rosa', 'Parroquia', 318),
-- Municipio Rafael Rangel (id: 319)
('Betijoque', 'Parroquia', 319),
('José Gregorio Hernández', 'Parroquia', 319),
('La Pueblita', 'Parroquia', 319),
('Los Cedros', 'Parroquia', 319),
-- Municipio San Rafael de Carvajal (id: 320)
('Carvajal', 'Parroquia', 320),
('Campo Alegre', 'Parroquia', 320),
('Antonio Nicolás Briceño', 'Parroquia', 320),
('José Leonardo Suárez', 'Parroquia', 320),
-- Municipio Sucre (Trujillo) (id: 321)
('Sabana de Mendoza', 'Parroquia', 321),
('Junín', 'Parroquia', 321),
('La Esperanza', 'Parroquia', 321),
('Valmore Rodríguez', 'Parroquia', 321),
-- Municipio Trujillo (id: 322)
('Trujillo', 'Parroquia', 322),
('Andrés Linares', 'Parroquia', 322),
('Chiquinquirá', 'Parroquia', 322),
('Cruz Carrillo', 'Parroquia', 322),
('Matriz', 'Parroquia', 322),
('Tres Esquinas', 'Parroquia', 322),
('San Lorenzo', 'Parroquia', 322),
-- Municipio Urdaneta (Trujillo) (id: 323)
('La Quebrada', 'Parroquia', 323),
('Cabimbú', 'Parroquia', 323),
('Jajó', 'Parroquia', 323),
('La Mesa de Esnujaque', 'Parroquia', 323),
('Santiago', 'Parroquia', 323),
('Tuñame', 'Parroquia', 323),
('La Venta', 'Parroquia', 323),
-- Municipio Valera (id: 324)
('Valera', 'Parroquia', 324),
('La Beatriz', 'Parroquia', 324),
('La Puerta', 'Parroquia', 324),
('Mendoza', 'Parroquia', 324),
('San Luis', 'Parroquia', 324),
('Carvajal', 'Parroquia', 324),

-- Parroquias del Estado La Guaira (Vargas)
-- Municipio Vargas (id: 325)
('Caraballeda', 'Parroquia', 325),
('Carayaca', 'Parroquia', 325),
('Carlos Soublette', 'Parroquia', 325),
('Caruao', 'Parroquia', 325),
('Catia La Mar', 'Parroquia', 325),
('El Junko', 'Parroquia', 325),
('La Guaira', 'Parroquia', 325),
('Macuto', 'Parroquia', 325),
('Maiquetía', 'Parroquia', 325),
('Naiguatá', 'Parroquia', 325),
('Urimare', 'Parroquia', 325),

-- Parroquias del Estado Yaracuy
-- Municipio Arístides Bastidas (id: 326)
('San Pablo', 'Parroquia', 326),
-- Municipio Bolívar (Yaracuy) (id: 327)
('Aroa', 'Parroquia', 327),
-- Municipio Bruzual (Yaracuy) (id: 328)
('Chivacoa', 'Parroquia', 328),
('Campo Elías', 'Parroquia', 328),
-- Municipio Cocorote (id: 329)
('Cocorote', 'Parroquia', 329),
-- Municipio Independencia (Yaracuy) (id: 330)
('Independencia', 'Parroquia', 330),
('Cambural', 'Parroquia', 330),
-- Municipio José Antonio Páez (Yaracuy) (id: 331)
('Sabana de Parra', 'Parroquia', 331),
-- Municipio La Trinidad (Yaracuy) (id: 332)
('La Trinidad', 'Parroquia', 332),
-- Municipio Manuel Monge (id: 333)
('Yumare', 'Parroquia', 333),
-- Municipio Nirgua (id: 334)
('Nirgua', 'Parroquia', 334),
('Salom', 'Parroquia', 334),
('Temerla', 'Parroquia', 334),
-- Municipio Peña (id: 335)
('Yaritagua', 'Parroquia', 335),
('San Andrés', 'Parroquia', 335),
-- Municipio San Felipe (Yaracuy) (id: 336)
('San Felipe', 'Parroquia', 336),
('Albarico', 'Parroquia', 336),
('San Javier', 'Parroquia', 336),
('Marín', 'Parroquia', 336),
-- Municipio Sucre (Yaracuy) (id: 337)
('Guama', 'Parroquia', 337),
-- Municipio Urachiche (id: 338)
('Urachiche', 'Parroquia', 338),
-- Municipio Veroes (id: 339)
('Farriar', 'Parroquia', 339),
('El Guayabo', 'Parroquia', 339),

-- Parroquias del Estado Zulia
-- Municipio Almirante Padilla (id: 340)
('Isla de Toas', 'Parroquia', 340),
('Monagas', 'Parroquia', 340),
-- Municipio Baralt (id: 341)
('San Timoteo', 'Parroquia', 341),
('General Urdaneta', 'Parroquia', 341),
('Manuel Manrique', 'Parroquia', 341),
('Rafael María Baralt', 'Parroquia', 341),
('San Timoteo', 'Parroquia', 341),
('Tomás Oropeza', 'Parroquia', 341),
-- Municipio Cabimas (id: 342)
('Ambrosio', 'Parroquia', 342),
('Carmen Herrera', 'Parroquia', 342),
('La Rosa', 'Parroquia', 342),
('Jorge Hernández', 'Parroquia', 342),
('Punta Gorda', 'Parroquia', 342),
('Rómulo Betancourt', 'Parroquia', 342),
('San Benito', 'Parroquia', 342),
('Aristides Calvani', 'Parroquia', 342),
('Germán Ríos Linares', 'Parroquia', 342),
('Manuel Manrique', 'Parroquia', 342),
-- Municipio Catatumbo (id: 343)
('Encontrados', 'Parroquia', 343),
('Udón Pérez', 'Parroquia', 343),
-- Municipio Colón (Zulia) (id: 344)
('San Carlos del Zulia', 'Parroquia', 344),
('Santa Cruz del Zulia', 'Parroquia', 344),
('Santa Bárbara', 'Parroquia', 344),
('Moralito', 'Parroquia', 344),
('Carlos Quevedo', 'Parroquia', 344),
-- Municipio Francisco Javier Pulgar (id: 345)
('Pueblo Nuevo', 'Parroquia', 345),
('Simón Rodríguez', 'Parroquia', 345),
-- Municipio Guajira (id: 346)
('Sinamaica', 'Parroquia', 346),
('Alta Guajira', 'Parroquia', 346),
('Elías Sánchez Rubio', 'Parroquia', 346),
('Luis de Vicente', 'Parroquia', 346),
('San Rafael de Moján', 'Parroquia', 346),
('Las Parcelas', 'Parroquia', 346),
('Guajira', 'Parroquia', 346),
-- Municipio Jesús Enrique Lossada (id: 347)
('La Concepción', 'Parroquia', 347),
('San José', 'Parroquia', 347),
('Mariano Escobedo', 'Parroquia', 347),
-- Municipio Jesús María Semprún (id: 348)
('Casigua El Cubo', 'Parroquia', 348),
('Barí', 'Parroquia', 348),
-- Municipio La Cañada de Urdaneta (id: 349)
('Concepción', 'Parroquia', 349),
('Andrés Bello', 'Parroquia', 349),
('Chiquinquirá', 'Parroquia', 349),
('El Carmelo', 'Parroquia', 349),
('Potreritos', 'Parroquia', 349),
-- Municipio Lagunillas (id: 350)
('Ciudad Ojeda', 'Parroquia', 350),
('Alonso de Ojeda', 'Parroquia', 350),
('Campo Lara', 'Parroquia', 350),
('La Victoria', 'Parroquia', 350),
('Libertad', 'Parroquia', 350),
('Venezuela', 'Parroquia', 350),
('Eleazar López Contreras', 'Parroquia', 350),
-- Municipio Machiques de Perijá (id: 351)
('Machiques', 'Parroquia', 351),
('Bartolomé de las Casas', 'Parroquia', 351),
('Libertad', 'Parroquia', 351),
('Río Negro', 'Parroquia', 351),
('San José de Perijá', 'Parroquia', 351),
-- Municipio Mara (id: 352)
('San Rafael de Moján', 'Parroquia', 352),
('La Sierrita', 'Parroquia', 352),
('Las Parcelas', 'Parroquia', 352),
('Luis de Vicente', 'Parroquia', 352),
('Monseñor Marcos Sergio Godoy', 'Parroquia', 352),
('Ricaurte', 'Parroquia', 352),
('Tamare', 'Parroquia', 352),
-- Municipio Maracaibo (id: 353)
('Antonio Borjas Romero', 'Parroquia', 353),
('Cacique Mara', 'Parroquia', 353),
('Caracciolo Parra Pérez', 'Parroquia', 353),
('Chiquinquirá', 'Parroquia', 353),
('Coquivacoa', 'Parroquia', 353),
('Francisco Eugenio Bustamante', 'Parroquia', 353),
('Idelfonso Vásquez', 'Parroquia', 353),
('Juana de Ávila', 'Parroquia', 353),
('Luis Hurtado Higuera', 'Parroquia', 353),
('Manuel Dagnino', 'Parroquia', 353),
('Olegario Villalobos', 'Parroquia', 353),
('Raúl Leoni', 'Parroquia', 353),
('Santa Lucía', 'Parroquia', 353),
('Venancio Pulgar', 'Parroquia', 353),
('San Isidro', 'Parroquia', 353),
('Cristo de Aranza', 'Parroquia', 353),
-- Municipio Miranda (Zulia) (id: 354)
('Los Puertos de Altagracia', 'Parroquia', 354),
('Ana María Campos', 'Parroquia', 354),
('Farra', 'Parroquia', 354),
('San Antonio', 'Parroquia', 354),
('San José', 'Parroquia', 354),
('El Mene', 'Parroquia', 354),
('Altagracia', 'Parroquia', 354),
-- Municipio Rosario de Perijá (id: 355)
('La Villa del Rosario', 'Parroquia', 355),
('El Rosario', 'Parroquia', 355),
('Sixto Zambrano', 'Parroquia', 355),
-- Municipio San Francisco (id: 356)
('San Francisco', 'Parroquia', 356),
('El Bajo', 'Parroquia', 356),
('Domitila Flores', 'Parroquia', 356),
('Francisco Ochoa', 'Parroquia', 356),
('Los Cortijos', 'Parroquia', 356),
('Marcial Hernández', 'Parroquia', 356),
-- Municipio Santa Rita (Zulia) (id: 357)
('Santa Rita', 'Parroquia', 357),
('El Mene', 'Parroquia', 357),
('Pedro Lucas Urribarrí', 'Parroquia', 357),
('José Cenobio Urribarrí', 'Parroquia', 357),
-- Municipio Simón Bolívar (Zulia) (id: 358)
('Tía Juana', 'Parroquia', 358),
('Manuel Manrique', 'Parroquia', 358),
('San Isidro', 'Parroquia', 358),
-- Municipio Sucre (Zulia) (id: 359)
('Bobures', 'Parroquia', 359),
('Gibraltar', 'Parroquia', 359),
('Héctor Manuel Briceño', 'Parroquia', 359),
('Heriberto Arroyo', 'Parroquia', 359),
('La Gran Parroquia', 'Parroquia', 359),
('Monseñor Arturo Celestino Álvarez', 'Parroquia', 359),
('Rómulo Gallegos', 'Parroquia', 359),
-- Municipio Valmore Rodríguez (id: 360)
('Bachaquero', 'Parroquia', 360),
('Eleazar López Contreras', 'Parroquia', 360),
('La Victoria', 'Parroquia', 360);


INSERT INTO Rol (nombre) VALUES 
('Supervisor'),
('Encargado'),
('Administrador'),
('Empleado Nuevo');


INSERT INTO Privilegio (nombre) VALUES
('Crear'),
('Actualizar'),
('Eliminar'),
('Leer');




INSERT INTO Rol_Privilegio (id_rol, id_privilegio, fecha_asignacion, motivo, nom_tabla_ojetivo) VALUES
(3, 1, '2025-01-15', 'Consultar catálogo de productos disponibles', 'all'),
(3, 2, '2025-01-15', 'Crear ventas y realizar compras', 'all'),
(3, 3, '2025-01-15', 'Consultar eventos disponibles', 'all'),
(3, 4, '2025-01-15', 'Acceso total al sistema como administrador principal', 'all');

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


INSERT INTO Estatus (id_estatus, nombre) VALUES
(1, 'Iniciada'),
(2, 'En proceso'),
(3, 'Atendida'),
(13, 'Pendiente');


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

INSERT INTO presentacion (nombre) VALUES
('Botella 330ml'),
('Botella 500ml'),
('Lata 330ml');


INSERT INTO Caracteristica (tipo_caracteristica, valor_caracteristica) VALUES
('Sabor', 'Amargo'),
('Sabor', 'Dulce'),
('Sabor', 'Ácido'),
('Color', 'Dorado'),
('Color', 'Ámbar'),
('Color', 'Oscuro'),
('Aroma', 'Floral'),
('Aroma', 'Frutal'),
('Cuerpo', 'Ligero'),
('Cuerpo', 'Robusto');


INSERT INTO Ingrediente (nombre, tipo, valor, ingrediente_padre) VALUES
('Malta Pilsner', 'Malta', 2.5, NULL),
('Malta Munich', 'Malta', 3.2, NULL),
('Lúpulo Cascade', 'Lúpulo', 5.5, NULL),
('Lúpulo Centennial', 'Lúpulo', 7.2, NULL),
('Levadura Ale', 'Levadura', 0.5, NULL),
('Levadura Lager', 'Levadura', 0.4, NULL),
('Agua Filtrada', 'Agua', 1.0, NULL),
('Mezcla Malta Base', 'Mezcla', 2.8, 1),  
('Blend Lúpulo Amargo', 'Mezcla', 6.3, 3), 
('Adjunto Maíz', 'Adjunto', 1.8, NULL);


INSERT INTO tipo_cerveza (id_tipo_cerveza,nombre,tipo_padre_id) VALUES
(1,'Lager',NULL),
(2,'Ale',NULL),
(3,'Pilsner',1),
(4,'Spezial',1),
(5,'Dortmunster',1),
(6,'Schwarzbier',1),
(7,'Vienna',1),
(8,'Bock',1),
(9,'Bohemian Pilsener',1),
(10,'Munich Helles',1),
(11,'Oktoberfest-Marzen',1),
(12,'Pale Ale',2),
(13,'IPA',2),
(14,'Amber Ale',2),
(15,'Brown Ale',2),
(16,'Golden Ale',2),
(17,'Stout',2),
(18,'Porter',2),
(19,'Belgian Dubbel',2),
(20,'Belgian Golden Strong',2),
(21,'Belgian Specialty Ale',2),
(22,'Wheat Beer',2),
(23,'Blonde Ale',2),
(24,'Barley Wine',2),
(25,'American Pale Ale',12),
(26,'English Pale Ale',12),
(27,'American IPA',13),
(28,'Imperial IPA',13),
(29,'India Pale Ale',13),
(30,'American Amber Ale',14),
(31,'Irish Red Ale',14),
(32,'Red Ale',14),
(33,'Dry Stout',17),
(34,'Imperial Stout',17),
(35,'Sweet Stout',17),
(36,'Artisanal Amber',21),
(37,'Artisanal Blond',21),
(38,'Artisanal Brown',21),
(39,'Belgian Barleywine',21),
(40,'Belgian IPA',21),
(41,'Belgian Spiced Christmas Beer',21),
(42,'Belgian Stout',21),
(43,'Fruit Lambic',21),
(44,'Spice, Herb o Vegetable',21),
(45,'Flanders Red/Brown',21),
(46,'Weizen-Weissbier',22),
(47,'Witbier',22),
(48,'Düsseldorf Altbier',2),
(49,'Extra-Strong Bitter',12);

INSERT INTO Metodo_Pago (id_metodo) VALUES
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10),
(11), (12), (13), (14), (15), (16), (17), (18), (19), (20),
(21), (22), (23), (24), (25), (26), (27), (28), (29), (30),
(31), (32), (33), (34), (35), (36), (37), (38), (39), (40),
(41), (42), (43), (44), (45), (46), (47), (48), (49), (50);


INSERT INTO Punto (id_metodo, origen) VALUES
(1, 'Tienda Fisica'),
(2, 'Tienda Fisica'),
(3, 'Tienda Fisica'),
(4, 'Tienda Fisica'),
(5, 'Tienda Fisica'),
(6, 'Tienda Fisica'),
(7, 'Tienda Fisica'),
(8, 'Tienda Fisica'),
(9, 'Tienda Fisica'),
(10, 'Tienda Fisica'),
(41, 'Tienda Fisica'),
(42, 'Tienda Fisica'),
(43, 'Tienda Fisica'),
(44, 'Tienda Fisica'),
(45, 'Tienda Fisica'),
(46, 'Tienda Fisica'),
(47, 'Tienda Fisica'),
(48, 'Tienda Fisica'),
(49, 'Tienda Fisica'),
(50, 'Tienda Fisica');



INSERT INTO Tasa (nombre, valor, fecha, punto_id, id_metodo) VALUES
('Dólar Estadounidense', 103.73, '2025-06-19', 41, 1),
('Euro', 119.44, '2025-06-19', 42, 2),
('Dólar Estadounidense', 102.15, '2025-06-18', 43, 3),
('Euro', 118.20, '2025-06-18', 44, 4),
('Dólar Estadounidense', 101.85, '2025-06-17', 45, 5),
('Euro', 117.95, '2025-06-17', 46, 6),
('Dólar Estadounidense', 100.92, '2025-06-16', 47, 7),
('Euro', 116.80, '2025-06-16', 48, 8),
('Dólar Estadounidense', 99.75, '2025-06-15', 49, 9),
('Euro', 115.60, '2025-06-15', 50, 10);

-- =====================================================
-- BLOQUE 2: ENTIDADES PRINCIPALES
-- =====================================================

-- Insertar clientes naturales
INSERT INTO Cliente_Natural (rif_cliente, ci_cliente, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, direccion, lugar_id_lugar) VALUES
(123456789, 12345678, 'Juan', 'Carlos', 'Rodríguez', 'Pérez', 'Avenida Principal de La Candelaria, Edificio Residencial Los Mangos, Piso 4, Apartamento 8', 365),
(234567890, 23456789, 'María', 'Isabel', 'González', 'Martínez', 'Calle El Paraíso, Residencia Premium, Piso 3, Apartamento 12', 368),
(345678901, 34567890, 'Pedro', 'José', 'López', 'García', 'Avenida San Bernardino, Edificio Gourmet, Piso 2, Apartamento 6', 376),
(456789012, 45678901, 'Ana', 'María', 'Hernández', 'Sánchez', 'Calle La Pastora, Residencia Comercial, Piso 5, Apartamento 9', 372),
(567890123, 56789012, 'Carlos', 'Alberto', 'Martínez', 'Torres', 'Avenida San Agustín, Edificio Premium, Piso 3, Apartamento 15', 375),
(678901234, 67890123, 'Laura', 'Patricia', 'Díaz', 'Ramírez', 'Calle La Vega, Residencia Gourmet, Piso 4, Apartamento 11', 373),
(789012345, 78901234, 'Roberto', 'Antonio', 'Sánchez', 'Morales', 'Avenida San José, Edificio Comercial, Piso 2, Apartamento 7', 377),
(890123456, 89012345, 'Carmen', 'Elena', 'Torres', 'Vargas', 'Calle San Juan, Residencia Premium, Piso 3, Apartamento 10', 378),
(901234567, 90123456, 'Miguel', 'Ángel', 'Ramírez', 'Castro', 'Avenida San Pedro, Edificio Gourmet, Piso 5, Apartamento 8', 379),
(012345678, 01234567, 'Sofía', 'Beatriz', 'Morales', 'Rojas', 'Calle Santa Rosalía, Residencia Comercial, Piso 4, Apartamento 13', 380),
(123456780, 12345670, 'José', 'Luis', 'Vargas', 'Mendoza', 'Avenida Santa Teresa, Edificio Premium, Piso 3, Apartamento 9', 381),
(234567801, 23456701, 'Isabel', 'Carmen', 'Castro', 'Guerrero', 'Calle Sucre, Residencia Gourmet, Piso 2, Apartamento 7', 382),
(345678012, 34567801, 'Antonio', 'Manuel', 'Rojas', 'Flores', 'Avenida 23 de Enero, Edificio Comercial, Piso 5, Apartamento 14', 361),
(456780123, 45678012, 'Patricia', 'Lucía', 'Mendoza', 'Ortiz', 'Calle Altagracia, Residencia Premium, Piso 4, Apartamento 11', 362),
(567801234, 56780123, 'Luis', 'Fernando', 'Guerrero', 'Silva', 'Avenida Antímano, Edificio Gourmet, Piso 3, Apartamento 8', 363),
(678012345, 67801234, 'Elena', 'Victoria', 'Flores', 'Navarro', 'Calle Caricuao, Residencia Comercial, Piso 2, Apartamento 12', 364),
(780123456, 78012345, 'Francisco', 'Javier', 'Ortiz', 'Medina', 'Avenida Catedral, Edificio Premium, Piso 5, Apartamento 10', 365),
(801234567, 80123456, 'Gabriela', 'Alejandra', 'Silva', 'Reyes', 'Calle Coche, Residencia Gourmet, Piso 4, Apartamento 15', 366),
(012345670, 01234560, 'Daniel', 'Alberto', 'Navarro', 'Acosta', 'Avenida El Junquito, Edificio Comercial, Piso 3, Apartamento 9', 367),
(123456701, 12345601, 'Valentina', 'María', 'Medina', 'Paredes', 'Calle del Valle, Residencia Premium, Piso 2, Apartamento 7', 370); 

-- Insertar clientes jurídicos
INSERT INTO Cliente_Juridico (rif_cliente, razon_social, denominacion_comercial, capital_disponible, direccion_fiscal, direccion_fisica, pagina_web, lugar_id_lugar, lugar_id_lugar2) VALUES
(987654321, 'Distribuidora de Cervezas Artesanales, C.A.', 'Cervezas Artesanales', 500000.00, 'Avenida Principal de La Candelaria, Edificio Comercial, Piso 4, Local 8', 'Calle Los Mangos, Zona Industrial La Candelaria, Galpón 15', 'www.cervezasartesanales.com', 365, 366),
(876543210, 'Importadora de Cervezas Premium, S.A.', 'Cervezas Premium', 750000.00, 'Calle El Paraíso, Edificio Premium, Piso 3, Local 12', 'Avenida Principal, Zona Industrial El Paraíso, Galpón 8', 'www.cervezaspremium.com', 368, 369),
(765432109, 'Comercializadora de Cervezas Gourmet, C.A.', 'Cervezas Gourmet', 600000.00, 'Avenida San Bernardino, Edificio Gourmet, Piso 2, Local 6', 'Calle Los Cedros, Zona Industrial San Bernardino, Galpón 10', 'www.cervezasgourmet.com', 376, 377),
(654321098, 'Distribuidora de Cervezas La Pastora, S.A.', 'Cervezas La Pastora', 450000.00, 'Calle La Pastora, Edificio Comercial, Piso 5, Local 9', 'Avenida Principal, Zona Industrial La Pastora, Galpón 14', 'www.cervezaslapastora.com', 372, 373),
(543210987, 'Importadora de Cervezas San Agustín, C.A.', 'Cervezas San Agustín', 550000.00, 'Avenida San Agustín, Edificio Premium, Piso 3, Local 15', 'Calle Los Pinos, Zona Industrial San Agustín, Galpón 7', 'www.cervezassanagustin.com', 375, 376),
(432109876, 'Comercializadora de Cervezas La Vega, S.A.', 'Cervezas La Vega', 650000.00, 'Calle La Vega, Edificio Gourmet, Piso 4, Local 11', 'Avenida Principal, Zona Industrial La Vega, Galpón 9', 'www.cervezaslavega.com', 373, 374),
(321098765, 'Distribuidora de Cervezas San José, C.A.', 'Cervezas San José', 480000.00, 'Avenida San José, Edificio Comercial, Piso 2, Local 7', 'Calle Los Cedros, Zona Industrial San José, Galpón 13', 'www.cervezassanjose.com', 377, 378),
(210987654, 'Importadora de Cervezas San Juan, S.A.', 'Cervezas San Juan', 520000.00, 'Calle San Juan, Edificio Premium, Piso 3, Local 10', 'Avenida Principal, Zona Industrial San Juan, Galpón 11', 'www.cervezassanjuan.com', 378, 379),
(109876543, 'Comercializadora de Cervezas San Pedro, C.A.', 'Cervezas San Pedro', 580000.00, 'Avenida San Pedro, Edificio Gourmet, Piso 5, Local 8', 'Calle Los Mangos, Zona Industrial San Pedro, Galpón 6', 'www.cervezassanpedro.com', 379, 380),
(987654320, 'Distribuidora de Cervezas Santa Rosalía, S.A.', 'Cervezas Santa Rosalía', 620000.00, 'Calle Santa Rosalía, Edificio Comercial, Piso 4, Local 13', 'Avenida Principal, Zona Industrial Santa Rosalía, Galpón 16', 'www.cervezassantarosalia.com', 380, 381),
(876543201, 'Importadora de Cervezas Santa Teresa, C.A.', 'Cervezas Santa Teresa', 490000.00, 'Avenida Santa Teresa, Edificio Premium, Piso 3, Local 9', 'Calle Los Cedros, Zona Industrial Santa Teresa, Galpón 8', 'www.cervezassantateresa.com', 381, 382),
(765432102, 'Comercializadora de Cervezas Sucre, S.A.', 'Cervezas Sucre', 530000.00, 'Calle Sucre, Edificio Gourmet, Piso 2, Local 7', 'Avenida Principal, Zona Industrial Sucre, Galpón 12', 'www.cervezassucre.com', 382, 361),
(654321023, 'Distribuidora de Cervezas 23 de Enero, C.A.', 'Cervezas 23 de Enero', 680000.00, 'Avenida 23 de Enero, Edificio Comercial, Piso 5, Local 14', 'Calle Los Pinos, Zona Industrial 23 de Enero, Galpón 9', 'www.cervezas23deenero.com', 361, 362),
(543210234, 'Importadora de Cervezas Altagracia, S.A.', 'Cervezas Altagracia', 510000.00, 'Calle Altagracia, Edificio Premium, Piso 4, Local 11', 'Avenida Principal, Zona Industrial Altagracia, Galpón 15', 'www.cervezasaltagracia.com', 362, 363),
(432102345, 'Comercializadora de Cervezas Antímano, C.A.', 'Cervezas Antímano', 590000.00, 'Avenida Antímano, Edificio Gourmet, Piso 3, Local 8', 'Calle Los Cedros, Zona Industrial Antímano, Galpón 10', 'www.cervezasantimano.com', 363, 364),
(321023456, 'Distribuidora de Cervezas Caricuao, S.A.', 'Cervezas Caricuao', 470000.00, 'Calle Caricuao, Edificio Comercial, Piso 2, Local 12', 'Avenida Principal, Zona Industrial Caricuao, Galpón 7', 'www.cervezascaricuao.com', 364, 365),
(210234567, 'Importadora de Cervezas Catedral, C.A.', 'Cervezas Catedral', 540000.00, 'Avenida Catedral, Edificio Premium, Piso 5, Local 10', 'Calle Los Mangos, Zona Industrial Catedral, Galpón 14', 'www.cervezascatedral.com', 365, 366),
(102345678, 'Comercializadora de Cervezas Coche, S.A.', 'Cervezas Coche', 610000.00, 'Calle Coche, Edificio Gourmet, Piso 4, Local 15', 'Avenida Principal, Zona Industrial Coche, Galpón 11', 'www.cervezascoche.com', 366, 367),
(123456789, 'Distribuidora de Cervezas El Junquito, C.A.', 'Cervezas El Junquito', 500000.00, 'Avenida El Junquito, Edificio Comercial, Piso 3, Local 9', 'Calle Los Cedros, Zona Industrial El Junquito, Galpón 13', 'www.cervezaseljunquito.com', 367, 368),
(234567890, 'Importadora de Cervezas del Valle, S.A.', 'Cervezas del Valle', 570000.00, 'Calle del Valle, Edificio Premium, Piso 2, Local 7', 'Avenida Principal, Zona Industrial del Valle, Galpón 12', 'www.cervezasdelvalle.com', 370, 371); 


-- Insertar proveedores de cerveza artesanal
INSERT INTO Proveedor (razon_social, denominacion, rif, direccion_fiscal, direccion_fisica, id_lugar, lugar_id2, url_web) VALUES
('Cervecería Artesanal del Valle, C.A.', 'Cerveza del Valle', 123456789, 'Avenida Principal del Valle, Edificio Cervecero, Piso 3, Local 5', 'Calle Los Mangos, Zona Industrial del Valle, Galpón 12', 370, 371, 'www.cervezadelvalle.com'),
('Cerveza Premium de La Candelaria, S.A.', 'Cerveza Premium', 234567890, 'Calle La Candelaria, Edificio Premium, Piso 2, Local 8', 'Avenida Principal, Zona Industrial La Candelaria, Galpón 15', 365, 366, 'www.cervezapremium.com'),
('Cervecería Artesanal El Paraíso, C.A.', 'Cerveza El Paraíso', 345678901, 'Avenida El Paraíso, Edificio Artesanal, Piso 4, Local 12', 'Calle Los Pinos, Zona Industrial El Paraíso, Galpón 8', 368, 369, 'www.cervezaelparaiso.com'),
('Cerveza Gourmet de San Bernardino, S.A.', 'Cerveza Gourmet', 456789012, 'Calle San Bernardino, Edificio Gourmet, Piso 3, Local 6', 'Avenida Principal, Zona Industrial San Bernardino, Galpón 10', 376, 377, 'www.cervezagourmet.com'),
('Cervecería Artesanal de La Pastora, C.A.', 'Cerveza La Pastora', 567890123, 'Avenida La Pastora, Edificio Artesanal, Piso 2, Local 9', 'Calle Los Cedros, Zona Industrial La Pastora, Galpón 14', 372, 373, 'www.cervezalapastora.com'),
('Cerveza Premium de San Agustín, S.A.', 'Cerveza San Agustín', 678901234, 'Calle San Agustín, Edificio Premium, Piso 5, Local 15', 'Avenida Principal, Zona Industrial San Agustín, Galpón 7', 375, 376, 'www.cervezasanagustin.com'),
('Cervecería Artesanal de La Vega, C.A.', 'Cerveza La Vega', 789012345, 'Avenida La Vega, Edificio Artesanal, Piso 3, Local 11', 'Calle Los Mangos, Zona Industrial La Vega, Galpón 9', 373, 374, 'www.cervezalavega.com'),
('Cerveza Gourmet de San José, S.A.', 'Cerveza San José', 890123456, 'Calle San José, Edificio Gourmet, Piso 4, Local 7', 'Avenida Principal, Zona Industrial San José, Galpón 13', 377, 378, 'www.cervezasanjose.com'),
('Cervecería Artesanal de San Juan, C.A.', 'Cerveza San Juan', 901234567, 'Avenida San Juan, Edificio Artesanal, Piso 2, Local 10', 'Calle Los Pinos, Zona Industrial San Juan, Galpón 11', 378, 379, 'www.cervezasanjuan.com'),
('Cerveza Premium de San Pedro, S.A.', 'Cerveza San Pedro', 012345678, 'Calle San Pedro, Edificio Premium, Piso 3, Local 8', 'Avenida Principal, Zona Industrial San Pedro, Galpón 6', 379, 380, 'www.cervezasanpedro.com'),
('Cervecería Artesanal de Santa Rosalía, C.A.', 'Cerveza Santa Rosalía', 123456780, 'Avenida Santa Rosalía, Edificio Artesanal, Piso 4, Local 13', 'Calle Los Cedros, Zona Industrial Santa Rosalía, Galpón 16', 380, 381, 'www.cervezasantarosalia.com'),
('Cerveza Gourmet de Santa Teresa, S.A.', 'Cerveza Santa Teresa', 234567801, 'Calle Santa Teresa, Edificio Gourmet, Piso 2, Local 9', 'Avenida Principal, Zona Industrial Santa Teresa, Galpón 8', 381, 382, 'www.cervezasantateresa.com'),
('Cervecería Artesanal de Sucre, C.A.', 'Cerveza Sucre', 345678012, 'Avenida Sucre, Edificio Artesanal, Piso 3, Local 7', 'Calle Los Mangos, Zona Industrial Sucre, Galpón 12', 382, 361, 'www.cervezasucre.com'),
('Cerveza Premium de 23 de Enero, S.A.', 'Cerveza 23 de Enero', 456780123, 'Calle 23 de Enero, Edificio Premium, Piso 5, Local 14', 'Avenida Principal, Zona Industrial 23 de Enero, Galpón 9', 361, 362, 'www.cerveza23deenero.com'),
('Cervecería Artesanal de Altagracia, C.A.', 'Cerveza Altagracia', 567801234, 'Avenida Altagracia, Edificio Artesanal, Piso 2, Local 11', 'Calle Los Pinos, Zona Industrial Altagracia, Galpón 15', 362, 363, 'www.cervezaaltagracia.com'),
('Cerveza Gourmet de Antímano, S.A.', 'Cerveza Antímano', 678012345, 'Calle Antímano, Edificio Gourmet, Piso 4, Local 8', 'Avenida Principal, Zona Industrial Antímano, Galpón 10', 363, 364, 'www.cervezaantimano.com'),
('Cervecería Artesanal de Caricuao, C.A.', 'Cerveza Caricuao', 780123456, 'Avenida Caricuao, Edificio Artesanal, Piso 3, Local 12', 'Calle Los Cedros, Zona Industrial Caricuao, Galpón 7', 364, 365, 'www.cervezacaricuao.com'),
('Cerveza Premium de Catedral, S.A.', 'Cerveza Catedral', 801234567, 'Calle Catedral, Edificio Premium, Piso 2, Local 10', 'Avenida Principal, Zona Industrial Catedral, Galpón 14', 365, 366, 'www.cervezacatedral.com'),
('Cervecería Artesanal de Coche, C.A.', 'Cerveza Coche', 901234568, 'Avenida Coche, Edificio Artesanal, Piso 5, Local 15', 'Calle Los Mangos, Zona Industrial Coche, Galpón 11', 366, 367, 'www.cervezacoche.com'),
('Cerveza Gourmet de El Junquito, S.A.', 'Cerveza El Junquito', 012345689, 'Calle El Junquito, Edificio Gourmet, Piso 3, Local 9', 'Avenida Principal, Zona Industrial El Junquito, Galpón 13', 367, 368, 'www.cervezaeljunquito.com'); 


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


INSERT INTO Empleado (cedula, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, direccion, activo, lugar_id_lugar) VALUES
('V-12345678', 'Carlos', 'Alberto', 'González', 'Pérez', 'Av. Libertador, Edificio Torre Central, Piso 5, Apt 5-A', 'S', 360), -- Distrito Capital - Libertador
('V-23456789', 'María', 'Elena', 'Rodríguez', 'Martínez', 'Calle Principal de Las Mercedes, Casa #45', 'S', 365), -- Miranda - Baruta
('V-34567890', 'José', 'Luis', 'Hernández', 'Silva', 'Urbanización El Trigal, Calle 5, Casa 123', 'S', 366), -- Carabobo - Valencia
('V-45678901', 'Ana', 'Beatriz', 'López', 'García', 'Sector La Candelaria, Carrera 15 con Calle 8, Casa 67', 'S', 367), -- Distrito Capital - Libertador
('V-56789012', 'Miguel', 'Ángel', 'Fernández', 'Morales', 'Av. Universidad, Residencias Los Rosales, Torre B, Apt 8-C', 'S', 368), -- Miranda - Chacao
('V-67890123', 'Carmen', 'Rosa', 'Jiménez', 'Vargas', 'Calle Bolívar, Centro Comercial Sambil, Local 234', 'S', 369), -- Carabobo - Naguanagua
('V-78901234', 'Roberto', 'Antonio', 'Mendoza', 'Castillo', 'Zona Industrial de Maracaibo, Galpón 15', 'S', 370), -- Zulia - Maracaibo
('V-89012345', 'Luisa', 'Fernanda', 'Torres', 'Ramos', 'Urbanización Santa Rosa, Calle Los Mangos, Casa 89', 'S', 375), -- Anzoátegui - Anaco
('V-90123456', 'Pedro', 'José', 'Moreno', 'Díaz', 'Av. Principal de Puerto La Cruz, Edificio Mar Azul, Piso 3', 'S', 378), -- Anzoátegui - Juan Antonio Sotillo
('V-01234567', 'Gabriela', 'Isabel', 'Ruiz', 'Herrera', 'Calle Real de Los Teques, Quinta Villa Hermosa', 'S', 380); -- Miranda - Guaicaipuro


INSERT INTO Tienda_Fisica (id_lugar, nombre, direccion) VALUES
(25, 'ACAUCAB Cervecería Artesanal', 'Av. Francisco de Miranda, Centro Comercial Lido, Nivel PB, Local 12, El Rosal, Caracas');


INSERT INTO Tienda_Web (id_tienda_web, nombre, url) VALUES
(1, 'Tienda Web 1', 'https://www.tiendaweb1.com');


INSERT INTO Ubicacion_Tienda (tipo, nombre, ubicacion_tienda_relacion_id, id_tienda_web, id_tienda_fisica) VALUES
('Seccion', 'Área de Cervezas Lager', NULL, 1, 1),
('Seccion', 'Área de Cervezas Ale', NULL, 1, 1),
('Seccion', 'Área de Cervezas Especiales', NULL, 1, 1),
('Anaquel', 'Anaquel Pilsner', 1, 1, 1),
('Anaquel', 'Anaquel Munich Helles', 1, 1, 1),
('Anaquel', 'Anaquel IPA', 2, 1, 1),
('Anaquel', 'Anaquel Pale Ale', 2, 1, 1),
('Anaquel', 'Anaquel Stout', 2, 1, 1),
('Anaquel', 'Anaquel Wheat Beer', 3, 1, 1),
('Refrigerador', 'Nevera Cervezas Frías', NULL, 1, 1);


/** Inserción de cervezas específicas con tipos correctos según nueva numeración **/
INSERT INTO cerveza (nombre_cerveza, id_tipo_cerveza, id_proveedor) VALUES
/** Cervezas artesanales venezolanas específicas **/
('Destilo', 30,1 ), -- American Amber Ale (ID 30)
('Dos Leones', 21,2), -- Belgian Specialty Ale (ID 21)
('Benitz Pale Ale', 25,3), -- American Pale Ale (ID 25)
('Candileja de Abadía', 19,4), -- Belgian Dubbel (ID 19)
('Ángel o Demonio', 20,5), -- Belgian Golden Strong (ID 20)
('Barricas Saison Belga', 21,6), -- Belgian Specialty Ale (ID 21)
('Aldarra Mantuana', 23,7), -- Blonde Ale (ID 23)

/** Cervezas americanas específicas **/
('Tröegs HopBack Amber', 30,8), -- American Amber Ale (ID 30)
('Full Sail Amber', 30,9), -- American Amber Ale (ID 30)
('Deschutes Cinder Cone', 30,10), -- American Amber Ale (ID 30)  
('Rogue American Amber', 30,11), -- American Amber Ale (ID 30)

/** Cervezas belgas específicas **/
('La Chouffe', 21,12), -- Belgian Specialty Ale (ID 21)
('Orval', 21,13), -- Belgian Specialty Ale (ID 21)
('Chimay', 19,14), -- Belgian Dubbel (ID 19)
('Leffe Blonde', 23,15), -- Blonde Ale (ID 23)
('Hoegaarden', 47,16), -- Witbier (ID 47)

/** Cervezas específicas por estilo **/
('Pilsner Urquell', 3,17), -- Pilsner (ID 3)
('Samuel Adams', 9,18); -- Bohemian Pilsener (ID 9)


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



-- =====================================================
-- BLOQUE 3: RELACIONES Y CONFIGURACIONES
-- =====================================================


INSERT INTO Usuario (id_cliente_juridico, id_cliente_natural, id_rol, fecha_creacion, id_proveedor, empleado_id, contraseña) VALUES
(NULL, NULL, NULL, CURRENT_DATE, 1, NULL, 'proveedor123'),
(NULL, NULL, NULL, CURRENT_DATE, 2, NULL, 'proveedor456'),
(NULL, NULL, NULL, CURRENT_DATE, 3, NULL, 'proveedor789'),
(NULL, NULL, NULL, CURRENT_DATE, 4, NULL, 'proveedor101'),
(NULL, NULL, NULL, CURRENT_DATE, 5, NULL, 'proveedor202'),
(NULL, NULL, NULL, CURRENT_DATE, 6, NULL, 'proveedor303'),
(NULL, NULL, NULL, CURRENT_DATE, 7, NULL, 'proveedor404'),
(NULL, NULL, NULL, CURRENT_DATE, 8, NULL, 'proveedor505'),
(NULL, NULL, NULL, CURRENT_DATE, 9, NULL, 'proveedor606'),
(NULL, NULL, NULL, CURRENT_DATE, 10, NULL, 'proveedor707'),
(NULL, NULL, NULL, CURRENT_DATE, 11, NULL, 'proveedor808'),
(NULL, NULL, NULL, CURRENT_DATE, 12, NULL, 'proveedor909'),
(NULL, NULL, NULL, CURRENT_DATE, 13, NULL, 'proveedor111'),
(NULL, NULL, NULL, CURRENT_DATE, 14, NULL, 'proveedor222'),
(NULL, NULL, NULL, CURRENT_DATE, 15, NULL, 'proveedor333'),
(NULL, NULL, NULL, CURRENT_DATE, 16, NULL, 'proveedor444'),
(NULL, NULL, NULL, CURRENT_DATE, 17, NULL, 'proveedor555'),
(NULL, NULL, NULL, CURRENT_DATE, 18, NULL, 'proveedor666'),
(NULL, NULL, NULL, CURRENT_DATE, 19, NULL, 'proveedor777'),
(NULL, NULL, NULL, CURRENT_DATE, 20, NULL, 'proveedor888'),
(NULL, 1,  NULL, CURRENT_DATE, NULL, NULL, 'cliente001'),
(NULL, 2,  NULL, CURRENT_DATE, NULL, NULL, 'cliente002'),
(NULL, 3,  NULL, CURRENT_DATE, NULL, NULL, 'cliente003'),
(NULL, 4,  NULL, CURRENT_DATE, NULL, NULL, 'cliente004'),
(NULL, 5,  NULL, CURRENT_DATE, NULL, NULL, 'cliente005'),
(NULL, 6,  NULL, CURRENT_DATE, NULL, NULL, 'cliente006'),
(NULL, 7,  NULL, CURRENT_DATE, NULL, NULL, 'cliente007'),
(NULL, 8,  NULL, CURRENT_DATE, NULL, NULL, 'cliente008'),
(NULL, 9,  NULL, CURRENT_DATE, NULL, NULL, 'cliente009'),
(NULL, 10, NULL, CURRENT_DATE, NULL, NULL, 'cliente010'),
(NULL, 11, NULL, CURRENT_DATE, NULL, NULL, 'cliente011'),
(NULL, 12, NULL, CURRENT_DATE, NULL, NULL, 'cliente012'),
(NULL, 13, NULL, CURRENT_DATE, NULL, NULL, 'cliente013'),
(NULL, 14, NULL, CURRENT_DATE, NULL, NULL, 'cliente014'),
(NULL, 15, NULL, CURRENT_DATE, NULL, NULL, 'cliente015'),
(NULL, 16, NULL, CURRENT_DATE, NULL, NULL, 'cliente016'),
(NULL, 17, NULL, CURRENT_DATE, NULL, NULL, 'cliente017'),
(NULL, 18, NULL, CURRENT_DATE, NULL, NULL, 'cliente018'),
(NULL, 19, NULL, CURRENT_DATE, NULL, NULL, 'cliente019'),
(NULL, 20, NULL, CURRENT_DATE, NULL, NULL, 'cliente020'),
(1, NULL,  NULL, CURRENT_DATE, NULL, NULL, 'empresa001'),
(2, NULL,  NULL, CURRENT_DATE, NULL, NULL, 'empresa002'),
(3, NULL,  NULL, CURRENT_DATE, NULL, NULL, 'empresa003'),
(4, NULL,  NULL, CURRENT_DATE, NULL, NULL, 'empresa004'),
(5, NULL,  NULL, CURRENT_DATE, NULL, NULL, 'empresa005'),
(6, NULL,  NULL, CURRENT_DATE, NULL, NULL, 'empresa006'),
(7, NULL,  NULL, CURRENT_DATE, NULL, NULL, 'empresa007'),
(8, NULL,  NULL, CURRENT_DATE, NULL, NULL, 'empresa008'),
(9, NULL,  NULL, CURRENT_DATE, NULL, NULL, 'empresa009'),
(10, NULL, NULL, CURRENT_DATE, NULL, NULL, 'empresa010'),
(11, NULL, NULL, CURRENT_DATE, NULL, NULL, 'empresa011'),
(12, NULL, NULL, CURRENT_DATE, NULL, NULL, 'empresa012'),
(13, NULL, NULL, CURRENT_DATE, NULL, NULL, 'empresa013'),
(14, NULL, NULL, CURRENT_DATE, NULL, NULL, 'empresa014'),
(15, NULL, NULL, CURRENT_DATE, NULL, NULL, 'empresa015'),
(16, NULL, NULL, CURRENT_DATE, NULL, NULL, 'empresa016'),
(17, NULL, NULL, CURRENT_DATE, NULL, NULL, 'empresa017'),
(18, NULL, NULL, CURRENT_DATE, NULL, NULL, 'empresa018'),
(19, NULL, NULL, CURRENT_DATE, NULL, NULL, 'empresa019'),
(20, NULL, NULL, CURRENT_DATE, NULL, NULL, 'empresa020'),
(NULL, NULL, 3, CURRENT_DATE, NULL, 1, 'empleado123'),
(NULL, NULL, 4, CURRENT_DATE, NULL, 2, 'empleado123'),
(NULL, NULL, 4, CURRENT_DATE, NULL, 3, 'empleado123'),
(NULL, NULL, 4, CURRENT_DATE, NULL, 4, 'empleado123'),
(NULL, NULL, 4, CURRENT_DATE, NULL, 5, 'empleado123'),
(NULL, NULL, 4, CURRENT_DATE, NULL, 6, 'empleado123'),
(NULL, NULL, 4, CURRENT_DATE, NULL, 7, 'empleado123'),
(NULL, NULL, 4, CURRENT_DATE, NULL, 8, 'empleado123'),
(NULL, NULL, 4, CURRENT_DATE, NULL, 9, 'empleado123'),
(NULL, NULL, 4, CURRENT_DATE, NULL, 10, 'empleado123');

-- Insertar correos de proveedores
INSERT INTO Correo (nombre, extension_pag, id_proveedor_proveedor, id_cliente_natural, id_cliente_juridico) VALUES
('cervezadelvalle', 'gmail.com', 1, NULL, NULL),
('ventas.cervezadelvalle', 'outlook.com', 1, NULL, NULL),
('cervezapremium', 'hotmail.com', 2, NULL, NULL),
('ventas.cervezapremium', 'yahoo.com', 2, NULL, NULL),
('cervezaelparaiso', 'outlook.com', 3, NULL, NULL),
('ventas.cervezaelparaiso', 'gmail.com', 3, NULL, NULL),
('cervezagourmet', 'yahoo.com', 4, NULL, NULL),
('ventas.cervezagourmet', 'hotmail.com', 4, NULL, NULL),
('cervezalapastora', 'gmail.com', 5, NULL, NULL),
('ventas.cervezalapastora', 'outlook.com', 5, NULL, NULL),
('cervezasanagustin', 'hotmail.com', 6, NULL, NULL),
('ventas.cervezasanagustin', 'yahoo.com', 6, NULL, NULL),
('cervezalavega', 'outlook.com', 7, NULL, NULL),
('ventas.cervezalavega', 'gmail.com', 7, NULL, NULL),
('cervezasanjose', 'yahoo.com', 8, NULL, NULL),
('ventas.cervezasanjose', 'hotmail.com', 8, NULL, NULL),
('cervezasanjuan', 'gmail.com', 9, NULL, NULL),
('ventas.cervezasanjuan', 'outlook.com', 9, NULL, NULL),
('cervezasanpedro', 'hotmail.com', 10, NULL, NULL),
('ventas.cervezasanpedro', 'yahoo.com', 10, NULL, NULL),
('cervezasantarosalia', 'outlook.com', 11, NULL, NULL),
('ventas.cervezasantarosalia', 'gmail.com', 11, NULL, NULL),
('cervezasantateresa', 'yahoo.com', 12, NULL, NULL),
('ventas.cervezasantateresa', 'hotmail.com', 12, NULL, NULL),
('cervezasucre', 'gmail.com', 13, NULL, NULL),
('ventas.cervezasucre', 'outlook.com', 13, NULL, NULL),
('cerveza23deenero', 'hotmail.com', 14, NULL, NULL),
('ventas.cerveza23deenero', 'yahoo.com', 14, NULL, NULL),
('cervezaaltagracia', 'outlook.com', 15, NULL, NULL),
('ventas.cervezaaltagracia', 'gmail.com', 15, NULL, NULL),
('cervezaantimano', 'yahoo.com', 16, NULL, NULL),
('ventas.cervezaantimano', 'hotmail.com', 16, NULL, NULL),
('cervezacaricuao', 'gmail.com', 17, NULL, NULL),
('ventas.cervezacaricuao', 'outlook.com', 17, NULL, NULL),
('cervezacatedral', 'hotmail.com', 18, NULL, NULL),
('ventas.cervezacatedral', 'yahoo.com', 18, NULL, NULL),
('cervezacoche', 'outlook.com', 19, NULL, NULL),
('ventas.cervezacoche', 'gmail.com', 19, NULL, NULL),
('cervezaeljunquito', 'yahoo.com', 20, NULL, NULL),
('ventas.cervezaeljunquito', 'hotmail.com', 20, NULL, NULL);


-- Insertar correos para clientes jurídicos
INSERT INTO Correo (nombre, extension_pag, id_cliente_juridico, id_cliente_natural, id_proveedor_proveedor) VALUES
('info.cervezasartesanales', 'gmail.com', 1, NULL, NULL),
('ventas.cervezasartesanales', 'outlook.com', 1, NULL, NULL),
('info.cervezaspremium', 'hotmail.com', 2, NULL, NULL),
('ventas.cervezaspremium', 'yahoo.com', 2, NULL, NULL),
('info.cervezasgourmet', 'gmail.com', 3, NULL, NULL),
('ventas.cervezasgourmet', 'outlook.com', 3, NULL, NULL),
('info.cervezaslapastora', 'hotmail.com', 4, NULL, NULL),
('ventas.cervezaslapastora', 'yahoo.com', 4, NULL, NULL),
('info.cervezassanagustin', 'gmail.com', 5, NULL, NULL),
('ventas.cervezassanagustin', 'outlook.com', 5, NULL, NULL),
('info.cervezaslavega', 'hotmail.com', 6, NULL, NULL),
('ventas.cervezaslavega', 'yahoo.com', 6, NULL, NULL),
('info.cervezassanjose', 'gmail.com', 7, NULL, NULL),
('ventas.cervezassanjose', 'outlook.com', 7, NULL, NULL),
('info.cervezassanjuan', 'hotmail.com', 8, NULL, NULL),
('ventas.cervezassanjuan', 'yahoo.com', 8, NULL, NULL),
('info.cervezassanpedro', 'gmail.com', 9, NULL, NULL),
('ventas.cervezassanpedro', 'outlook.com', 9, NULL, NULL),
('info.cervezassantarosalia', 'hotmail.com', 10, NULL, NULL),
('ventas.cervezassantarosalia', 'yahoo.com', 10, NULL, NULL),
('info.cervezassantateresa', 'gmail.com', 11, NULL, NULL),
('ventas.cervezassantateresa', 'outlook.com', 11, NULL, NULL),
('info.cervezassucre', 'hotmail.com', 12, NULL, NULL),
('ventas.cervezassucre', 'yahoo.com', 12, NULL, NULL),
('info.cervezas23deenero', 'gmail.com', 13, NULL, NULL),
('ventas.cervezas23deenero', 'outlook.com', 13, NULL, NULL),
('info.cervezasaltagracia', 'hotmail.com', 14, NULL, NULL),
('ventas.cervezasaltagracia', 'yahoo.com', 14, NULL, NULL),
('info.cervezasantimano', 'gmail.com', 15, NULL, NULL),
('ventas.cervezasantimano', 'outlook.com', 15, NULL, NULL),
('info.cervezascaricuao', 'hotmail.com', 16, NULL, NULL),
('ventas.cervezascaricuao', 'yahoo.com', 16, NULL, NULL),
('info.cervezascatedral', 'gmail.com', 17, NULL, NULL),
('ventas.cervezascatedral', 'outlook.com', 17, NULL, NULL),
('info.cervezascoche', 'hotmail.com', 18, NULL, NULL),
('ventas.cervezascoche', 'yahoo.com', 18, NULL, NULL),
('info.cervezaseljunquito', 'gmail.com', 19, NULL, NULL),
('ventas.cervezaseljunquito', 'outlook.com', 19, NULL, NULL),
('info.cervezasdelvalle', 'hotmail.com', 20, NULL, NULL),
('ventas.cervezasdelvalle', 'yahoo.com', 20, NULL, NULL);

-- Insertar correos para clientes naturales
INSERT INTO Correo (nombre, extension_pag, id_cliente_juridico, id_cliente_natural, id_proveedor_proveedor) VALUES
('juan.rodriguez', 'gmail.com', NULL, 1, NULL),
('juan.c.rodriguez', 'outlook.com', NULL, 1, NULL),
('maria.gonzalez', 'hotmail.com', NULL, 2, NULL),
('maria.i.gonzalez', 'yahoo.com', NULL, 2, NULL),
('pedro.lopez', 'gmail.com', NULL, 3, NULL),
('pedro.j.lopez', 'outlook.com', NULL, 3, NULL),
('ana.hernandez', 'hotmail.com', NULL, 4, NULL),
('ana.m.hernandez', 'yahoo.com', NULL, 4, NULL),
('carlos.martinez', 'gmail.com', NULL, 5, NULL),
('carlos.a.martinez', 'outlook.com', NULL, 5, NULL),
('laura.diaz', 'hotmail.com', NULL, 6, NULL),
('laura.p.diaz', 'yahoo.com', NULL, 6, NULL),
('roberto.sanchez', 'gmail.com', NULL, 7, NULL),
('roberto.a.sanchez', 'outlook.com', NULL, 7, NULL),
('carmen.torres', 'hotmail.com', NULL, 8, NULL),
('carmen.e.torres', 'yahoo.com', NULL, 8, NULL),
('miguel.ramirez', 'gmail.com', NULL, 9, NULL),
('miguel.a.ramirez', 'outlook.com', NULL, 9, NULL),
('sofia.morales', 'hotmail.com', NULL, 10, NULL),
('sofia.b.morales', 'yahoo.com', NULL, 10, NULL),
('jose.vargas', 'gmail.com', NULL, 11, NULL),
('jose.l.vargas', 'outlook.com', NULL, 11, NULL),
('isabel.castro', 'hotmail.com', NULL, 12, NULL),
('isabel.c.castro', 'yahoo.com', NULL, 12, NULL),
('antonio.rojas', 'gmail.com', NULL, 13, NULL),
('antonio.m.rojas', 'outlook.com', NULL, 13, NULL),
('patricia.mendoza', 'hotmail.com', NULL, 14, NULL),
('patricia.l.mendoza', 'yahoo.com', NULL, 14, NULL),
('luis.guerrero', 'gmail.com', NULL, 15, NULL),
('luis.f.guerrero', 'outlook.com', NULL, 15, NULL),
('elena.flores', 'hotmail.com', NULL, 16, NULL),
('elena.v.flores', 'yahoo.com', NULL, 16, NULL),
('francisco.ortiz', 'gmail.com', NULL, 17, NULL),
('francisco.j.ortiz', 'outlook.com', NULL, 17, NULL),
('gabriela.silva', 'hotmail.com', NULL, 18, NULL),
('gabriela.a.silva', 'yahoo.com', NULL, 18, NULL),
('daniel.navarro', 'gmail.com', NULL, 19, NULL),
('daniel.a.navarro', 'outlook.com', NULL, 19, NULL),
('valentina.medina', 'hotmail.com', NULL, 20, NULL),
('valentina.m.medina', 'yahoo.com', NULL, 20, NULL); 

-- Insertar correos para empleados

INSERT INTO Correo (nombre, extension_pag, id_empleado, id_cliente_juridico, id_cliente_natural, id_proveedor_proveedor) VALUES
('admin', 'gmail.com', 1, NULL, NULL, NULL),
('prueba12', 'gmail.com', 2, NULL, NULL, NULL),
('prueba', 'gmail.com', 3, NULL, NULL, NULL),
('viscabarca', 'gmail.com', 4, NULL, NULL, NULL),
('pedri', 'gmail.com', 5, NULL, NULL, NULL),
('gavi', 'gmail.com', 6, NULL, NULL, NULL),
('lamine', 'gmail.com', 7, NULL, NULL, NULL),
('nico', 'gmail.com', 8, NULL, NULL, NULL),
('kounde', 'gmail.com', 9, NULL, NULL, NULL),
('nigga', 'gmail.com', 10, NULL, NULL, NULL);

INSERT INTO Persona_Contacto (nombre, apellido, id_proveedor, id_cliente_juridico) VALUES
('María', 'González', 1,  NULL),
('Carlos', 'Rodríguez', 2,  NULL),
('Ana', 'Martínez', 3,  NULL),
('Luis', 'Fernández', 4,  NULL),
('Carmen', 'López', 5,  NULL),
('Roberto', 'Pérez', NULL,  1),
('Elena', 'Sánchez', NULL,  2),
('Diego', 'Morales', NULL,  3),
('Patricia', 'Herrera', NULL,  4),
('Andrés', 'Castillo', NULL,  5);


INSERT INTO Telefono (codigo_area, numero, id_proveedor, id_contacto, id_invitado, id_cliente_juridico, id_cliente_natural) VALUES
('0212', '5551234', 1, NULL, NULL, NULL, NULL),
('0414', '7778899', 2, NULL, NULL, NULL, NULL),
('0212', '4445566', NULL, 1, NULL, NULL, NULL),
('0424', '3332211', NULL, 2, NULL, NULL, NULL),
('0212', '6667788', NULL, NULL, 1, NULL, NULL),
('0416', '9998877', NULL, NULL, 2, NULL, NULL),
('0212', '2223344', NULL, NULL, NULL, 1, NULL),
('0414', '8889900', NULL, NULL, NULL, 2, NULL),
('0212', '1112233', NULL, NULL, NULL, NULL, 1),
('0426', '5554433', NULL, NULL, NULL, NULL, 2);




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



INSERT INTO presentacion_cerveza (cantidad, id_presentacion, id_cerveza, precio) VALUES
-- Cerveza 1: Destilo
(1, 1, 1, 3.00), -- Botella 330ml
(1, 2, 1, 5.00), -- Botella 500ml
(1, 3, 1, 2.00), -- Lata 330ml

-- Cerveza 2: Dos Leones Latin American Pale Ale
(1, 1, 2, 3.00), -- Botella 330ml
(1, 2, 2, 5.00), -- Botella 500ml
(1, 3, 2, 2.00), -- Lata 330ml

-- Cerveza 3: Benitz Pale Ale
(1, 1, 3, 3.00), -- Botella 330ml
(1, 2, 3, 5.00), -- Botella 500ml
(1, 3, 3, 2.00), -- Lata 330ml

-- Cerveza 4: Mito Brewhouse Candileja de Abadía
(1, 1, 4, 3.00), -- Botella 330ml
(1, 2, 4, 5.00), -- Botella 500ml
(1, 3, 4, 2.00), -- Lata 330ml

-- Cerveza 5: Cervecería Lago Ángel o Demonio
(1, 1, 5, 3.00), -- Botella 330ml
(1, 2, 5, 5.00), -- Botella 500ml
(1, 3, 5, 2.00), -- Lata 330ml

-- Cerveza 6: Barricas Saison Belga
(1, 1, 6, 3.00), -- Botella 330ml
(1, 2, 6, 5.00), -- Botella 500ml
(1, 3, 6, 2.00), -- Lata 330ml

-- Cerveza 7: Aldarra Mantuana
(1, 1, 7, 3.00), -- Botella 330ml
(1, 2, 7, 5.00), -- Botella 500ml
(1, 3, 7, 2.00), -- Lata 330ml

-- Cerveza 8: Tröegs HopBack Amber Ale
(1, 1, 8, 3.00), -- Botella 330ml
(1, 2, 8, 5.00), -- Botella 500ml
(1, 3, 8, 2.00), -- Lata 330ml

-- Cerveza 9: Full Sail Amber
(1, 1, 9, 3.00), -- Botella 330ml
(1, 2, 9, 5.00), -- Botella 500ml
(1, 3, 9, 2.00), -- Lata 330ml

-- Cerveza 10: Deschutes Cinder Cone Red
(1, 1, 10, 3.00), -- Botella 330ml
(1, 2, 10, 5.00), -- Botella 500ml
(1, 3, 10, 2.00), -- Lata 330ml

-- Cerveza 11: Rogue American Amber Ale
(1, 1, 11, 3.00), -- Botella 330ml
(1, 2, 11, 5.00), -- Botella 500ml
(1, 3, 11, 2.00), -- Lata 330ml

-- Cerveza 12: La Chouffe
(1, 1, 12, 3.00), -- Botella 330ml
(1, 2, 12, 5.00), -- Botella 500ml
(1, 3, 12, 2.00), -- Lata 330ml

-- Cerveza 13: Orval
(1, 1, 13, 3.00), -- Botella 330ml
(1, 2, 13, 5.00), -- Botella 500ml
(1, 3, 13, 2.00), -- Lata 330ml

-- Cerveza 14: Chimay Rouge (Première)
(1, 1, 14, 3.00), -- Botella 330ml
(1, 2, 14, 5.00), -- Botella 500ml
(1, 3, 14, 2.00), -- Lata 330ml

-- Cerveza 15: Duvel
(1, 1, 15, 3.00), -- Botella 330ml
(1, 2, 15, 5.00), -- Botella 500ml
(1, 3, 15, 2.00), -- Lata 330ml

-- Cerveza 16: Hoegaarden Witbier
(1, 1, 16, 3.00), -- Botella 330ml
(1, 2, 16, 5.00), -- Botella 500ml
(1, 3, 16, 2.00), -- Lata 330ml

-- Cerveza 17: Pilsner Urquell
(1, 1, 17, 3.00), -- Botella 330ml
(1, 2, 17, 5.00), -- Botella 500ml
(1, 3, 17, 2.00), -- Lata 330ml

-- Cerveza 18: Sierra Nevada Pale Ale
(1, 1, 18, 3.00), -- Botella 330ml
(1, 2, 18, 5.00), -- Botella 500ml
(1, 3, 18, 2.00); -- Lata 330ml




INSERT INTO Caracteristica_Especifica (id_tipo_cerveza, id_caracteristica, valor) VALUES
(1, 4, 'Dorado claro'),        
(1, 9, 'Ligero y refrescante'), 
(2, 5, 'Ámbar intenso'),       
(2, 10, 'Robusto y complejo'), 
(3, 4, 'Dorado brillante'),    
(3, 1, 'Amargo equilibrado'),  
(13, 1, 'Muy amargo'),         
(13, 7, 'Floral intenso'),     
(17, 6, 'Negro profundo'),     
(17, 10, 'Robusto cremoso'),   
(22, 8, 'Frutal cítrico'),     
(22, 9, 'Ligero sedoso'); 



INSERT INTO Receta (id_tipo_cerveza, descripcion) VALUES
-- === RECETAS LAGER ===
(1, 'RECETA LAGER TRADICIONAL: Fermentación baja con levadura Saccharomyces Carlsbergenesis. 1) Usar alta proporción de malta clara, poco o nada de malta tostada. 2) Agregar malta de trigo opcional. 3) Fermentar a menos de 10°C durante 1-3 meses. 4) Usar poco lúpulo para mantener color claro. 5) Graduación entre 3.5-5%. 6) Requiere cámara frigorífica o elaboración en invierno.'),

(3, 'RECETA PILSNER BOHEMIA: Cerveza comercial ligera pero intensa. 1) Fermentar con levadura de baja fermentación. 2) Contenido alcohólico medio. 3) Sabor ligero pero intenso característico. 4) Proceso de fermentación lenta a bajas temperaturas. 5) Una de las cervezas más consumidas mundialmente.'),

-- === RECETAS ALE ===
(2, 'RECETA ALE TRADICIONAL: Fermentación alta con levadura Saccharomyces Cerevisiae. 1) Fermentar en superficie del fermentador a 19°C durante 5-7 días. 2) Usar bastante lúpulo para contenido alcohólico elevado. 3) Segunda fermentación para reducir turbidez. 4) No servir helada como las lager. 5) Popular en Reino Unido, USA y antiguas colonias británicas.'),

(12, 'RECETA PALE ALE: Cerveza ale de color claro con pequeñas proporciones de malta tostada. 1) Usar mucho lúpulo para sabor intenso y amargor. 2) Malta Pale americana de dos hileras como base. 3) Lúpulos americanos con carácter cítrico. 4) Levadura ale americana. 5) Agua con sulfatos variables pero carbonatos bajos. 6) Maltas especiales para carácter a pan y tostado.'),

(13, 'RECETA IPA (INDIAN PALE ALE): Cerveza muy alcohólica y rica en lúpulo diseñada para largas travesías. 1) American IPA menos maltosa y más lupulizada. 2) Lúpulos americanos con proceso dry hopping. 3) Aroma y sabor claramente a lúpulo: floral, frutal, cítrico o resinoso. 4) Sabor a malta medio-bajo. 5) 40-60 IBUs de amargor. 6) 5-7.5% graduación alcohólica.'),

(17, 'RECETA STOUT IRLANDESA: Cerveza negra muy oscura. 1) Buena proporción de maltas tostadas y caramelizadas. 2) Buena dosis de lúpulo. 3) Textura espesa y cremosa. 4) Fuerte aroma a malta y regusto dulce. 5) Fermentación ale. 6) Variantes: Imperial Stout (alta concentración malta), Chocolate/Coffee Stout, Milk Stout (endulzada con lactosa).'),

-- === RECETAS ESPECIALES ===
(22, 'RECETA CERVEZA DE TRIGO ALEMANA: Weisse beer del Oktober Fest. 1) Hecha total o parcialmente con malta de trigo. 2) Color claro y baja graduación. 3) Fermentar con levadura ale. 4) Especialmente importante en Alemania. 5) Variante berlinesa también disponible.'),

(19, 'RECETA BELGIAN DUBBEL MONÁSTICA: Cerveza de monasterios con sabor intenso. 1) Buenas dosis de lúpulo con fondo dulce de maltas ámbar y cristal. 2) Tonos rojizos característicos. 3) Bastante alcohólica superando 6-7% alcohol. 4) Incluye cerveza de Abadía, Trapense, Ámbar, Flamenca. 5) Tradición monástica medieval.'),

(30, 'RECETA AMERICAN AMBER ALE: Estilo moderno del siglo XX. 1) Malta Pale Ale norteamericana (5kg) + Malta Aromatic (0.5kg) + Malta Caramel Light (0.4kg). 2) Lúpulo Columbus (7gr-60min) + Cascade (7gr-20min) + Columbus (10gr-flameout) + Cascade (30gr-flameout). 3) Levadura Danstar Bry-97. 4) Maceración 1 hora a 66°C. 5) Sparging a 76°C. 6) Fermentar 18-20°C. 7) Madurar 4 semanas. 8) 5.8% alcohol, 16 IBUs.'),

(8, 'RECETA BOCK TRADICIONAL: Lager muy rica en maltas tostadas. 1) Color muy oscuro con espuma blanca contrastante. 2) Más de 7% contenido alcohólico. 3) Eisbock: técnica de congelación parcial para retirar hielo y aumentar graduación. 4) No muy lupulosa, predomina sabor a malta y dulzor. 5) Diferente a otras cervezas oscuras por menor lupulización.');



INSERT INTO Receta_Ingrediente (id_receta, id_ingrediente) VALUES
(1, 1),  
(1, 7),  
(2, 1),  
(2, 6),  
(3, 2),  
(3, 5),  
(4, 1),  
(4, 3),  
(5, 3),  
(5, 4),  
(10, 8);


INSERT INTO Instruccion (nombre, descripcion, receta_id) VALUES
('Fermentación Fría', 'Fermentar con levadura Saccharomyces Carlsbergenesis a temperatura menor a 10°C durante 1-3 meses. Mantener temperatura constante en cámara frigorífica.', 1),
('Preparación Malta Clara', 'Usar alta proporción de malta clara con poco o nada de malta tostada. Agregar malta de trigo opcional para mejorar textura.', 1),
('Fermentación Lenta', 'Utilizar levadura de baja fermentación manteniendo proceso lento para desarrollar el sabor ligero pero intenso característico del estilo Pilsner.', 2),
('Fermentación Superficial', 'Fermentar con levadura Saccharomyces Cerevisiae en la superficie del fermentador a 19°C durante 5-7 días para lograr fermentación alta característica.', 3),
('Segunda Fermentación', 'Realizar segunda fermentación durante 3-5 días adicionales para reducir la turbidez y mejorar la claridad de la cerveza ale.', 3),
('Lupulización Intensa', 'Usar abundante lúpulo americano con carácter cítrico para lograr el sabor intenso y amargor característico. Aplicar lúpulos en diferentes momentos del hervor.', 4),
('Dry Hopping', 'Aplicar proceso de dry hopping con lúpulos americanos para intensificar el aroma floral, frutal, cítrico o resinoso característico de las American IPA.', 5),
('Control de Amargor', 'Mantener IBUs entre 40-60 y graduación alcohólica entre 5-7.5% para cumplir con estándares del estilo IPA diseñado para largas travesías.', 5),
('Preparación Trigo', 'Usar malta de trigo total o parcialmente manteniendo color claro y baja graduación. Fermentar con levadura ale siguiendo tradición alemana del Oktober Fest.', 7),
('Tradición Monástica', 'Seguir técnicas tradicionales de monasterios usando buenas dosis de lúpulo con fondo dulce de maltas ámbar y cristal. Lograr tonos rojizos y alta graduación alcohólica (+6-7%).', 8);



INSERT INTO Fermentacion (receta_id_receta, fecha_inicio, fecha_fin_estimada) VALUES
(1, '2025-01-01', '2025-03-01'),  
(2, '2025-01-15', '2025-04-15'),  
(3, '2025-01-10', '2025-01-24'),  
(4, '2025-01-20', '2025-02-03'),  
(5, '2025-01-25', '2025-02-08'), 
(7, '2025-02-01', '2025-02-15'),  
(8, '2025-02-05', '2025-04-05'),  
(10, '2025-02-10', '2025-05-10'), 
(1, '2025-02-01', '2025-04-01'),  
(5, '2025-02-15', '2025-03-01');



INSERT INTO Inventario (cantidad, id_tienda_fisica, id_presentacion, id_cerveza)
SELECT
    35 AS cantidad,
    1 AS id_tienda_fisica,
    pc.id_presentacion,
    pc.id_cerveza
FROM presentacion_cerveza pc;



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




INSERT INTO Evento_Proveedor (id_proveedor, id_evento, hora_llegada, hora_salida, dia) VALUES
(1, 1, '09:00:00', '17:00:00', '2025-01-15'),  
(2, 1, '09:30:00', '16:30:00', '2025-01-15'),  
(3, 1, '10:00:00', '18:00:00', '2025-01-15'),  
(4, 2, '08:30:00', '15:00:00', '2025-01-20'),  
(5, 2, '09:15:00', '16:45:00', '2025-01-20'),  
(1, 3, '11:00:00', '19:00:00', '2025-01-25'),  
(6, 3, '12:00:00', '18:30:00', '2025-01-25'),  
(7, 4, '18:00:00', '23:00:00', '2025-02-01'),  
(8, 5, '07:00:00', '12:00:00', '2025-02-05'),  
(9, 6, '10:30:00', '20:00:00', '2025-02-10');  


INSERT INTO Inventario_Evento_Proveedor (id_proveedor, id_evento, cantidad, id_tipo_cerveza, id_presentacion, id_cerveza) VALUES
(1, 1, 200, 30, 1, 1),
(1, 1, 150, 30, 2, 2),
(1, 1, 100, 30, 3, 3),
(2, 1, 180, 21, 1, 1),
(2, 1, 120, 21, 2, 2),
(2, 1, 80, 21, 3, 3),
(3, 1, 250, 25, 3, 3),
(3, 1, 150, 25, 3, 4),
(4, 2, 50, 19, 3, 4),
(5, 2, 60, 20, 2, 5),
(5, 2, 45, 20, 1, 6),
(1, 3, 100, 30, 1, 1),
(1, 3, 80, 30, 2, 2),
(6, 3, 120, 21, 1, 6),
(7, 4, 80, 23, 1, 7),
(8, 5, 100, 30, 1, 8),
(9, 6, 40, 30, 1, 9);


INSERT INTO Membresia (fecha_inicio, fecha_fin, id_proveedor) VALUES
('2024-01-15', NULL, 1),
('2024-03-20', NULL, 2),
('2024-06-10', NULL, 3),
('2024-09-05', NULL, 4),
('2024-11-12', NULL, 5),
('2023-01-10', '2024-01-10', 6),
('2023-05-15', '2024-05-15', 7),
('2023-08-20', '2024-08-20', 8),
('2024-02-01', '2025-02-01', 9),
('2024-04-15', '2025-04-15', 10);


INSERT INTO Cuota_Afiliacion (monto, membresia_id_membresia, fecha_pago) VALUES
(150.00, 1, '2024-01-15'),  
(150.00, 2, '2024-03-20'),  
(150.00, 3, '2024-06-10'),  
(150.00, 4, '2024-09-05'),  
(150.00, 5, '2024-11-12'),  
(120.00, 6, '2023-01-10'),  
(120.00, 7, '2023-05-15'),  
(120.00, 8, '2023-08-20'), 
(180.00, 9, '2024-02-01'),  
(180.00, 10, '2024-04-15');







INSERT INTO Orden_Reposicion_Anaquel (fecha_hora_generacion, id_ubicacion) VALUES
('2025-01-15 08:30:00',1),  
('2025-01-15 14:45:00',2),  
('2025-01-16 09:15:00',3),  
('2025-01-16 16:20:00',4),  
('2025-01-17 10:00:00',5),  
('2025-01-17 13:30:00',6),  
('2025-01-18 11:45:00',7),  
('2025-01-18 17:10:00',8),  
('2025-01-19 08:00:00',9),  
('2025-01-19 15:25:00',10);

INSERT INTO Estatus_Orden_Anaquel (id_orden_reposicion, id_estatus, fecha_hora_asignacion) VALUES
(1, 1, '2025-01-15 08:30:00'),  
(2, 2, '2025-01-15 08:45:00'),  
(3, 3, '2025-01-15 10:30:00'), 
(4, 1, '2025-01-15 14:45:00'),  
(5, 2, '2025-01-15 15:00:00'),  
(6, 3, '2025-01-15 15:15:00'),  
(7, 1, '2025-01-16 09:15:00'),  
(8, 3, '2025-01-16 09:30:00'),  
(9, 1, '2025-01-16 16:20:00'),  
(10, 2, '2025-01-16 16:35:00'); 


INSERT INTO Detalle_Orden_Reposicion_Anaquel (id_orden_reposicion, id_inventario, cantidad) VALUES
(1, 11, 50),  
(1, 12, 30),  
(2, 13, 75),  
(2, 14, 25),  
(3, 15, 40), 
(4, 16, 60),  
(4, 17, 45), 
(5, 18, 35), 
(6, 19, 80),  
(7, 20, 20);

-- Insertar 10 órdenes de reposición
INSERT INTO Orden_Reposicion (id_departamento, id_proveedor, fecha_emision) VALUES
(3, 1, CURRENT_DATE),
(3, 2, CURRENT_DATE),
(3, 3, CURRENT_DATE),
(3, 4, CURRENT_DATE),
(3, 5, CURRENT_DATE),
(3, 6, CURRENT_DATE),
(3, 7, CURRENT_DATE),
(3, 8, CURRENT_DATE),
(3, 9, CURRENT_DATE),
(3, 10, CURRENT_DATE); 

-- Detalles de órdenes de reposición (solo combinaciones válidas de id_presentacion y id_cerveza)
INSERT INTO Detalle_Orden_Reposicion (cantidad, id_orden_reposicion, id_proveedor, id_departamento, precio, id_tipo_cerveza, id_presentacion, id_cerveza) VALUES
-- Detalles para la orden 1
(5, 1, 1, 3, 5, 7, 1, 1),
(5, 1, 1, 3, 5, 15, 2, 2),
(5, 1, 1, 3, 5, 22, 3, 3),
(5, 1, 1, 3, 5, 4, 3, 4),
(5, 1, 1, 3, 5, 29, 2, 5),
-- Detalles para la orden 2
(5, 2, 2, 3, 5, 11, 1, 6),
(5, 2, 2, 3, 5, 18, 1, 7),
(5, 2, 2, 3, 5, 25, 1, 8),
(5, 2, 2, 3, 5, 6, 1, 9),
(5, 2, 2, 3, 5, 30, 1, 10),
-- Detalles para la orden 3
(5, 3, 3, 3, 5, 2, 1, 1),
(5, 3, 3, 3, 5, 13, 2, 2),
(5, 3, 3, 3, 5, 21, 3, 3),
(5, 3, 3, 3, 5, 8, 3, 4),
(5, 3, 3, 3, 5, 27, 2, 5),
-- Detalles para la orden 4
(5, 4, 4, 3, 5, 5, 1, 6),
(5, 4, 4, 3, 5, 19, 1, 7),
(5, 4, 4, 3, 5, 23, 1, 8),
(5, 4, 4, 3, 5, 10, 1, 9),
(5, 4, 4, 3, 5, 28, 1, 10),
-- Detalles para la orden 5
(5, 5, 5, 3, 5, 12, 1, 1),
(5, 5, 5, 3, 5, 16, 2, 2),
(5, 5, 5, 3, 5, 24, 3, 3),
(5, 5, 5, 3, 5, 3, 3, 4),
(5, 5, 5, 3, 5, 26, 2, 5),
-- Detalles para la orden 6
(5, 6, 6, 3, 5, 9, 1, 6),
(5, 6, 6, 3, 5, 20, 1, 7),
(5, 6, 6, 3, 5, 14, 1, 8),
(5, 6, 6, 3, 5, 1, 1, 9),
(5, 6, 6, 3, 5, 17, 1, 10),
-- Detalles para la orden 7
(5, 7, 7, 3, 5, 6, 1, 1),
(5, 7, 7, 3, 5, 28, 2, 2),
(5, 7, 7, 3, 5, 11, 3, 3),
(5, 7, 7, 3, 5, 24, 3, 4),
(5, 7, 7, 3, 5, 15, 2, 5),
-- Detalles para la orden 8
(5, 8, 8, 3, 5, 7, 1, 6),
(5, 8, 8, 3, 5, 18, 1, 7),
(5, 8, 8, 3, 5, 22, 1, 8),
(5, 8, 8, 3, 5, 13, 1, 9),
(5, 8, 8, 3, 5, 29, 1, 10),
-- Detalles para la orden 9
(5, 9, 9, 3, 5, 2, 1, 1),
(5, 9, 9, 3, 5, 17, 2, 2),
(5, 9, 9, 3, 5, 25, 3, 3),
(5, 9, 9, 3, 5, 8, 3, 4),
(5, 9, 9, 3, 5, 30, 2, 5),
-- Detalles para la orden 10
(5, 10, 10, 3, 5, 10, 1, 6),
(5, 10, 10, 3, 5, 21, 1, 7),
(5, 10, 10, 3, 5, 14, 1, 8),
(5, 10, 10, 3, 5, 4, 1, 9),
(5, 10, 10, 3, 5, 27, 1, 10); 


INSERT INTO Orden_Reposicion_Estatus (id_orden_reposicion, id_proveedor, id_departamento, id_estatus, fecha_asignacion, fecha_fin) VALUES
(1, 1, 3, 1, '2025-01-15 14:00:00', '2025-01-15 14:01:00'),  
(2, 2, 3, 2, '2025-01-16 09:00:00', '2025-01-16 09:01:00'),  
(3, 3, 3, 2, '2025-01-17 11:00:00', '2025-01-17 11:01:00'),  
(4, 4, 3, 2, '2025-01-17 11:00:00', '2025-01-17 11:01:00'),  
(5, 5, 3, 2, '2025-01-17 11:00:00', '2025-01-17 11:01:00'),  
(6, 6, 3, 2, '2025-01-17 11:00:00', '2025-01-17 11:01:00'),  
(7, 7, 3, 1, '2025-01-17 11:00:00', '2025-01-17 11:01:00'),  
(8, 8, 3, 1, '2025-01-17 11:00:00', '2025-01-17 11:01:00'),  
(9, 9, 3, 1, '2025-01-17 11:00:00', '2025-01-17 11:01:00'),  
(10, 10, 3, 2, '2025-01-17 11:00:00', '2025-01-17 11:01:00') ;



-- =====================================================
-- BLOQUE 4: MÉTODOS DE PAGO Y TRANSACCIONES
-- =====================================================



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



-- Ejemplo de inserciones para Punto_Cliente (historial de movimientos)
INSERT INTO Punto_Cliente (id_cliente_natural, id_metodo, cantidad_mov, fecha, tipo_movimiento) VALUES
(1, 41, 150, '2025-01-10', 'GANADO'),
(1, 41, -50, '2025-02-15', 'GASTADO'),
(2, 42, 200, '2025-01-12', 'GANADO'),
(2, 42, -80, '2025-03-10', 'GASTADO'),
(3, 41, 300, '2025-01-08', 'GANADO'),
(3, 41, -120, '2025-04-05', 'GASTADO'),
(4, 43, 180, '2025-01-11', 'GANADO'),
(4, 43, -60, '2025-02-20', 'GASTADO'),
(5, 42, 120, '2025-01-09', 'GANADO'),
(5, 42, -30, '2025-03-15', 'GASTADO'),
(6, 44, 250, '2025-01-13', 'GANADO'),
(6, 44, -100, '2025-05-01', 'GASTADO'),
(7, 45, 170, '2025-01-14', 'GANADO'),
(7, 45, -70, '2025-03-25', 'GASTADO'),
(8, 46, 220, '2025-01-15', 'GANADO'),
(8, 46, -90, '2025-04-10', 'GASTADO'),
(9, 47, 190, '2025-01-16', 'GANADO'),
(9, 47, -40, '2025-02-28', 'GASTADO'),
(10, 48, 210, '2025-01-17', 'GANADO'),
(10, 48, -60, '2025-03-30', 'GASTADO');


--- Compras de usuarios de clientes naturales

INSERT INTO Compra (monto_total, id_cliente_juridico, id_cliente_natural, usuario_id_usuario, tienda_web_id_tienda, tienda_fisica_id_tienda) VALUES
(0, NULL, NULL, 21, 1, NULL),
(0, NULL, NULL, 21, 1, NULL),
(0, NULL, NULL, 22, 1, NULL),
(0, NULL, NULL, 22, 1, NULL),
(0, NULL, NULL, 23, 1, NULL),
(0, NULL, NULL, 23, 1, NULL),
(0, NULL, NULL, 24, 1, NULL),
(0, NULL, NULL, 24, 1, NULL),
(0, NULL, NULL, 25, 1, NULL),
(0, NULL, NULL, 25, 1, NULL),
(0, NULL, NULL, 26, 1, NULL),
(0, NULL, NULL, 26, 1, NULL),
(0, NULL, NULL, 27, 1, NULL),
(0, NULL, NULL, 27, 1, NULL),
(0, NULL, NULL, 28, 1, NULL),
(0, NULL, NULL, 28, 1, NULL),
(0, NULL, NULL, 29, 1, NULL),
(0, NULL, NULL, 29, 1, NULL),
(0, NULL, NULL, 30, 1, NULL),
(0, NULL, NULL, 30, 1, NULL),
(0, NULL, NULL, 31, 1, NULL),
(0, NULL, NULL, 31, 1, NULL),
(0, NULL, NULL, 32, 1, NULL),
(0, NULL, NULL, 32, 1, NULL),
(0, NULL, NULL, 33, 1, NULL),
(0, NULL, NULL, 33, 1, NULL),
(0, NULL, NULL, 34, 1, NULL),
(0, NULL, NULL, 34, 1, NULL),
(0, NULL, NULL, 35, 1, NULL),
(0, NULL, NULL, 35, 1, NULL),
(0, NULL, NULL, 36, 1, NULL),
(0, NULL, NULL, 36, 1, NULL),
(0, NULL, NULL, 37, 1, NULL),
(0, NULL, NULL, 37, 1, NULL),
(0, NULL, NULL, 38, 1, NULL),
(0, NULL, NULL, 38, 1, NULL),
(0, NULL, NULL, 39, 1, NULL),
(0, NULL, NULL, 39, 1, NULL),
(0, NULL, NULL, 40, 1, NULL),
(0, NULL, NULL, 40, 1, NULL);


INSERT INTO Compra (monto_total, id_cliente_juridico, id_cliente_natural, usuario_id_usuario, tienda_web_id_tienda, tienda_fisica_id_tienda) VALUES
(0, NULL, NULL, 41, 1, NULL),
(0, NULL, NULL, 41, 1, NULL),
(0, NULL, NULL, 42, 1, NULL),
(0, NULL, NULL, 42, 1, NULL),
(0, NULL, NULL, 43, 1, NULL),
(0, NULL, NULL, 43, 1, NULL),
(0, NULL, NULL, 44, 1, NULL),
(0, NULL, NULL, 44, 1, NULL),
(0, NULL, NULL, 45, 1, NULL),
(0, NULL, NULL, 45, 1, NULL),
(0, NULL, NULL, 46, 1, NULL),
(0, NULL, NULL, 46, 1, NULL),
(0, NULL, NULL, 47, 1, NULL),
(0, NULL, NULL, 47, 1, NULL),
(0, NULL, NULL, 48, 1, NULL),
(0, NULL, NULL, 48, 1, NULL),
(0, NULL, NULL, 49, 1, NULL),
(0, NULL, NULL, 49, 1, NULL),
(0, NULL, NULL, 50, 1, NULL),
(0, NULL, NULL, 50, 1, NULL),
(0, NULL, NULL, 51, 1, NULL),
(0, NULL, NULL, 51, 1, NULL),
(0, NULL, NULL, 52, 1, NULL),
(0, NULL, NULL, 52, 1, NULL),
(0, NULL, NULL, 53, 1, NULL),
(0, NULL, NULL, 53, 1, NULL),
(0, NULL, NULL, 54, 1, NULL),
(0, NULL, NULL, 54, 1, NULL),
(0, NULL, NULL, 55, 1, NULL),
(0, NULL, NULL, 55, 1, NULL),
(0, NULL, NULL, 56, 1, NULL),
(0, NULL, NULL, 56, 1, NULL),
(0, NULL, NULL, 57, 1, NULL),
(0, NULL, NULL, 57, 1, NULL),
(0, NULL, NULL, 58, 1, NULL),
(0, NULL, NULL, 58, 1, NULL),
(0, NULL, NULL, 59, 1, NULL),
(0, NULL, NULL, 59, 1, NULL),
(0, NULL, NULL, 60, 1, NULL),
(0, NULL, NULL, 60, 1, NULL); 


INSERT INTO Detalle_Compra (precio_unitario, cantidad, id_inventario, id_compra) VALUES
-- detalles para la compra 41
(10.00, 1, 1, 41),
(10.00, 1, 2, 41),
(10.00, 1, 3, 41),
(10.00, 1, 4, 41),
(10.00, 1, 5, 41),
(10.00, 1, 6, 41),
(10.00, 1, 7, 41),
(10.00, 1, 8, 41),
(10.00, 1, 9, 41),
(10.00, 1, 10, 41),
-- detalles para la compra 42
(10.00, 1, 1, 42),
(10.00, 1, 2, 42),
(10.00, 1, 3, 42),
(10.00, 1, 4, 42),
(10.00, 1, 5, 42),
(10.00, 1, 6, 42),
(10.00, 1, 7, 42),
(10.00, 1, 8, 42),
(10.00, 1, 9, 42),
(10.00, 1, 10, 42),
-- detalles para la compra 43
(10.00, 1, 1, 43),
(10.00, 1, 2, 43),
(10.00, 1, 3, 43),
(10.00, 1, 4, 43),
(10.00, 1, 5, 43),
(10.00, 1, 6, 43),
(10.00, 1, 7, 43),
(10.00, 1, 8, 43),
(10.00, 1, 9, 43),
(10.00, 1, 10, 43),
-- detalles para la compra 44
(10.00, 1, 1, 44),
(10.00, 1, 2, 44),
(10.00, 1, 3, 44),
(10.00, 1, 4, 44),
(10.00, 1, 5, 44),
(10.00, 1, 6, 44),
(10.00, 1, 7, 44),
(10.00, 1, 8, 44),
(10.00, 1, 9, 44),
(10.00, 1, 10, 44),
-- detalles para la compra 45
(10.00, 1, 1, 45),
(10.00, 1, 2, 45),
(10.00, 1, 3, 45),
(10.00, 1, 4, 45),
(10.00, 1, 5, 45),
(10.00, 1, 6, 45),
(10.00, 1, 7, 45),
(10.00, 1, 8, 45),
(10.00, 1, 9, 45),
(10.00, 1, 10, 45),
-- detalles para la compra 46
(10.00, 1, 1, 46),
(10.00, 1, 2, 46),
(10.00, 1, 3, 46),
(10.00, 1, 4, 46),
(10.00, 1, 5, 46),
(10.00, 1, 6, 46),
(10.00, 1, 7, 46),
(10.00, 1, 8, 46),
(10.00, 1, 9, 46),
(10.00, 1, 10, 46),
-- detalles para la compra 47
(10.00, 1, 1, 47),
(10.00, 1, 2, 47),
(10.00, 1, 3, 47),
(10.00, 1, 4, 47),
(10.00, 1, 5, 47),
(10.00, 1, 6, 47),
(10.00, 1, 7, 47),
(10.00, 1, 8, 47),
(10.00, 1, 9, 47),
(10.00, 1, 10, 47),
-- detalles para la compra 48
(10.00, 1, 1, 48),
(10.00, 1, 2, 48),
(10.00, 1, 3, 48),
(10.00, 1, 4, 48),
(10.00, 1, 5, 48),
(10.00, 1, 6, 48),
(10.00, 1, 7, 48),
(10.00, 1, 8, 48),
(10.00, 1, 9, 48),
(10.00, 1, 10, 48),
-- detalles para la compra 49
(10.00, 1, 1, 49),
(10.00, 1, 2, 49),
(10.00, 1, 3, 49),
(10.00, 1, 4, 49),
(10.00, 1, 5, 49),
(10.00, 1, 6, 49),
(10.00, 1, 7, 49),
(10.00, 1, 8, 49),
(10.00, 1, 9, 49),
(10.00, 1, 10, 49),
-- detalles para la compra 50
(10.00, 1, 1, 50),
(10.00, 1, 2, 50),
(10.00, 1, 3, 50),
(10.00, 1, 4, 50),
(10.00, 1, 5, 50),
(10.00, 1, 6, 50),
(10.00, 1, 7, 50),
(10.00, 1, 8, 50),
(10.00, 1, 9, 50),
(10.00, 1, 10, 50),
-- detalles para la compra 51
(10.00, 1, 1, 51),
(10.00, 1, 2, 51),
(10.00, 1, 3, 51),
(10.00, 1, 4, 51),
(10.00, 1, 5, 51),
(10.00, 1, 6, 51),
(10.00, 1, 7, 51),
(10.00, 1, 8, 51),
(10.00, 1, 9, 51),
(10.00, 1, 10, 51),
-- detalles para la compra 52
(10.00, 1, 1, 52),
(10.00, 1, 2, 52),
(10.00, 1, 3, 52),
(10.00, 1, 4, 52),
(10.00, 1, 5, 52),
(10.00, 1, 6, 52),
(10.00, 1, 7, 52),
(10.00, 1, 8, 52),
(10.00, 1, 9, 52),
(10.00, 1, 10, 52),
-- detalles para la compra 53
(10.00, 1, 1, 53),
(10.00, 1, 2, 53),
(10.00, 1, 3, 53),
(10.00, 1, 4, 53),
(10.00, 1, 5, 53),
(10.00, 1, 6, 53),
(10.00, 1, 7, 53),
(10.00, 1, 8, 53),
(10.00, 1, 9, 53),
(10.00, 1, 10, 53),
-- detalles para la compra 54
(10.00, 1, 1, 54),
(10.00, 1, 2, 54),
(10.00, 1, 3, 54),
(10.00, 1, 4, 54),
(10.00, 1, 5, 54),
(10.00, 1, 6, 54),
(10.00, 1, 7, 54),
(10.00, 1, 8, 54),
(10.00, 1, 9, 54),
(10.00, 1, 10, 54),
-- detalles para la compra 55
(10.00, 1, 1, 55),
(10.00, 1, 2, 55),
(10.00, 1, 3, 55),
(10.00, 1, 4, 55),
(10.00, 1, 5, 55),
(10.00, 1, 6, 55),
(10.00, 1, 7, 55),
(10.00, 1, 8, 55),
(10.00, 1, 9, 55),
(10.00, 1, 10, 55),
-- detalles para la compra 56
(10.00, 1, 1, 56),
(10.00, 1, 2, 56),
(10.00, 1, 3, 56),
(10.00, 1, 4, 56),
(10.00, 1, 5, 56),
(10.00, 1, 6, 56),
(10.00, 1, 7, 56),
(10.00, 1, 8, 56),
(10.00, 1, 9, 56),
(10.00, 1, 10, 56),
-- detalles para la compra 57
(10.00, 1, 1, 57),
(10.00, 1, 2, 57),
(10.00, 1, 3, 57),
(10.00, 1, 4, 57),
(10.00, 1, 5, 57),
(10.00, 1, 6, 57),
(10.00, 1, 7, 57),
(10.00, 1, 8, 57),
(10.00, 1, 9, 57),
(10.00, 1, 10, 57),
-- detalles para la compra 58
(10.00, 1, 1, 58),
(10.00, 1, 2, 58),
(10.00, 1, 3, 58),
(10.00, 1, 4, 58),
(10.00, 1, 5, 58),
(10.00, 1, 6, 58),
(10.00, 1, 7, 58),
(10.00, 1, 8, 58),
(10.00, 1, 9, 58),
(10.00, 1, 10, 58),
-- detalles para la compra 59
(10.00, 1, 1, 59),
(10.00, 1, 2, 59),
(10.00, 1, 3, 59),
(10.00, 1, 4, 59),
(10.00, 1, 5, 59),
(10.00, 1, 6, 59),
(10.00, 1, 7, 59),
(10.00, 1, 8, 59),
(10.00, 1, 9, 59),
(10.00, 1, 10, 59),
-- detalles para la compra 60
(10.00, 1, 1, 60),
(10.00, 1, 2, 60),
(10.00, 1, 3, 60),
(10.00, 1, 4, 60),
(10.00, 1, 5, 60),
(10.00, 1, 6, 60),
(10.00, 1, 7, 60),
(10.00, 1, 8, 60),
(10.00, 1, 9, 60),
(10.00, 1, 10, 60),
-- detalles para la compra 61
(10.00, 1, 1, 61),
(10.00, 1, 2, 61),
(10.00, 1, 3, 61),
(10.00, 1, 4, 61),
(10.00, 1, 5, 61),
(10.00, 1, 6, 61),
(10.00, 1, 7, 61),
(10.00, 1, 8, 61),
(10.00, 1, 9, 61),
(10.00, 1, 10, 61),
-- detalles para la compra 62
(10.00, 1, 1, 62),
(10.00, 1, 2, 62),
(10.00, 1, 3, 62),
(10.00, 1, 4, 62),
(10.00, 1, 5, 62),
(10.00, 1, 6, 62),
(10.00, 1, 7, 62),
(10.00, 1, 8, 62),
(10.00, 1, 9, 62),
(10.00, 1, 10, 62),
-- detalles para la compra 63
(10.00, 1, 1, 63),
(10.00, 1, 2, 63),
(10.00, 1, 3, 63),
(10.00, 1, 4, 63),
(10.00, 1, 5, 63),
(10.00, 1, 6, 63),
(10.00, 1, 7, 63),
(10.00, 1, 8, 63),
(10.00, 1, 9, 63),
(10.00, 1, 10, 63),
-- detalles para la compra 64
(10.00, 1, 1, 64),
(10.00, 1, 2, 64),
(10.00, 1, 3, 64),
(10.00, 1, 4, 64),
(10.00, 1, 5, 64),
(10.00, 1, 6, 64),
(10.00, 1, 7, 64),
(10.00, 1, 8, 64),
(10.00, 1, 9, 64),
(10.00, 1, 10, 64),
-- detalles para la compra 65
(10.00, 1, 1, 65),
(10.00, 1, 2, 65),
(10.00, 1, 3, 65),
(10.00, 1, 4, 65),
(10.00, 1, 5, 65),
(10.00, 1, 6, 65),
(10.00, 1, 7, 65),
(10.00, 1, 8, 65),
(10.00, 1, 9, 65),
(10.00, 1, 10, 65),
-- detalles para la compra 66
(10.00, 1, 1, 66),
(10.00, 1, 2, 66),
(10.00, 1, 3, 66),
(10.00, 1, 4, 66),
(10.00, 1, 5, 66),
(10.00, 1, 6, 66),
(10.00, 1, 7, 66),
(10.00, 1, 8, 66),
(10.00, 1, 9, 66),
(10.00, 1, 10, 66),
-- detalles para la compra 67
(10.00, 1, 1, 67),
(10.00, 1, 2, 67),
(10.00, 1, 3, 67),
(10.00, 1, 4, 67),
(10.00, 1, 5, 67),
(10.00, 1, 6, 67),
(10.00, 1, 7, 67),
(10.00, 1, 8, 67),
(10.00, 1, 9, 67),
(10.00, 1, 10, 67),
-- detalles para la compra 68
(10.00, 1, 1, 68),
(10.00, 1, 2, 68),
(10.00, 1, 3, 68),
(10.00, 1, 4, 68),
(10.00, 1, 5, 68),
(10.00, 1, 6, 68),
(10.00, 1, 7, 68),
(10.00, 1, 8, 68),
(10.00, 1, 9, 68),
(10.00, 1, 10, 68),
-- detalles para la compra 69
(10.00, 1, 1, 69),
(10.00, 1, 2, 69),
(10.00, 1, 3, 69),
(10.00, 1, 4, 69),
(10.00, 1, 5, 69),
(10.00, 1, 6, 69),
(10.00, 1, 7, 69),
(10.00, 1, 8, 69),
(10.00, 1, 9, 69),
(10.00, 1, 10, 69),
-- detalles para la compra 70
(10.00, 1, 1, 70),
(10.00, 1, 2, 70),
(10.00, 1, 3, 70),
(10.00, 1, 4, 70),
(10.00, 1, 5, 70),
(10.00, 1, 6, 70),
(10.00, 1, 7, 70),
(10.00, 1, 8, 70),
(10.00, 1, 9, 70),
(10.00, 1, 10, 70),
-- detalles para la compra 71
(10.00, 1, 1, 71),
(10.00, 1, 2, 71),
(10.00, 1, 3, 71),
(10.00, 1, 4, 71),
(10.00, 1, 5, 71),
(10.00, 1, 6, 71),
(10.00, 1, 7, 71),
(10.00, 1, 8, 71),
(10.00, 1, 9, 71),
(10.00, 1, 10, 71),
-- detalles para la compra 72
(10.00, 1, 1, 72),
(10.00, 1, 2, 72),
(10.00, 1, 3, 72),
(10.00, 1, 4, 72),
(10.00, 1, 5, 72),
(10.00, 1, 6, 72),
(10.00, 1, 7, 72),
(10.00, 1, 8, 72),
(10.00, 1, 9, 72),
(10.00, 1, 10, 72),
-- detalles para la compra 73
(10.00, 1, 1, 73),
(10.00, 1, 2, 73),
(10.00, 1, 3, 73),
(10.00, 1, 4, 73),
(10.00, 1, 5, 73),
(10.00, 1, 6, 73),
(10.00, 1, 7, 73),
(10.00, 1, 8, 73),
(10.00, 1, 9, 73),
(10.00, 1, 10, 73),
-- detalles para la compra 74
(10.00, 1, 1, 74),
(10.00, 1, 2, 74),
(10.00, 1, 3, 74),
(10.00, 1, 4, 74),
(10.00, 1, 5, 74),
(10.00, 1, 6, 74),
(10.00, 1, 7, 74),
(10.00, 1, 8, 74),
(10.00, 1, 9, 74),
(10.00, 1, 10, 74),
-- detalles para la compra 75
(10.00, 1, 1, 75),
(10.00, 1, 2, 75),
(10.00, 1, 3, 75),
(10.00, 1, 4, 75),
(10.00, 1, 5, 75),
(10.00, 1, 6, 75),
(10.00, 1, 7, 75),
(10.00, 1, 8, 75),
(10.00, 1, 9, 75),
(10.00, 1, 10, 75),
-- detalles para la compra 76
(10.00, 1, 1, 76),
(10.00, 1, 2, 76),
(10.00, 1, 3, 76),
(10.00, 1, 4, 76),
(10.00, 1, 5, 76),
(10.00, 1, 6, 76),
(10.00, 1, 7, 76),
(10.00, 1, 8, 76),
(10.00, 1, 9, 76),
(10.00, 1, 10, 76),
-- detalles para la compra 77
(10.00, 1, 1, 77),
(10.00, 1, 2, 77),
(10.00, 1, 3, 77),
(10.00, 1, 4, 77),
(10.00, 1, 5, 77),
(10.00, 1, 6, 77),
(10.00, 1, 7, 77),
(10.00, 1, 8, 77),
(10.00, 1, 9, 77),
(10.00, 1, 10, 77),
-- detalles para la compra 78
(10.00, 1, 1, 78),
(10.00, 1, 2, 78),
(10.00, 1, 3, 78),
(10.00, 1, 4, 78),
(10.00, 1, 5, 78),
(10.00, 1, 6, 78),
(10.00, 1, 7, 78),
(10.00, 1, 8, 78),
(10.00, 1, 9, 78),
(10.00, 1, 10, 78),
-- detalles para la compra 79
(10.00, 1, 1, 79),
(10.00, 1, 2, 79),
(10.00, 1, 3, 79),
(10.00, 1, 4, 79),
(10.00, 1, 5, 79),
(10.00, 1, 6, 79),
(10.00, 1, 7, 79),
(10.00, 1, 8, 79),
(10.00, 1, 9, 79),
(10.00, 1, 10, 79),
-- detalles para la compra 80
(10.00, 1, 1, 80),
(10.00, 1, 2, 80),
(10.00, 1, 3, 80),
(10.00, 1, 4, 80),
(10.00, 1, 5, 80),
(10.00, 1, 6, 80),
(10.00, 1, 7, 80),
(10.00, 1, 8, 80),
(10.00, 1, 9, 80),
(10.00, 1, 10, 80);

-- Detalles de compras de clientes naturales

INSERT INTO Detalle_Compra (precio_unitario, cantidad, id_inventario, id_compra) VALUES
-- detalles para la compra 1
(10.00, 1, 1, 1),
(10.00, 1, 2, 1),
(10.00, 1, 3, 1),
(10.00, 1, 4, 1),
(10.00, 1, 5, 1),
(10.00, 1, 6, 1),
(10.00, 1, 7, 1),
(10.00, 1, 8, 1),
(10.00, 1, 9, 1),
(10.00, 1, 10, 1),
-- detalles para la compra 2
(10.00, 1, 1, 2),
(10.00, 1, 2, 2),
(10.00, 1, 3, 2),
(10.00, 1, 4, 2),
(10.00, 1, 5, 2),
(10.00, 1, 6, 2),
(10.00, 1, 7, 2),
(10.00, 1, 8, 2),
(10.00, 1, 9, 2),
(10.00, 1, 10, 2),
-- detalles para la compra 3
(10.00, 1, 1, 3),
(10.00, 1, 2, 3),
(10.00, 1, 3, 3),
(10.00, 1, 4, 3),
(10.00, 1, 5, 3),
(10.00, 1, 6, 3),
(10.00, 1, 7, 3),
(10.00, 1, 8, 3),
(10.00, 1, 9, 3),
(10.00, 1, 10, 3),
-- detalles para la compra 4
(10.00, 1, 1, 4),
(10.00, 1, 2, 4),
(10.00, 1, 3, 4),
(10.00, 1, 4, 4),
(10.00, 1, 5, 4),
(10.00, 1, 6, 4),
(10.00, 1, 7, 4),
(10.00, 1, 8, 4),
(10.00, 1, 9, 4),
(10.00, 1, 10, 4),
-- detalles para la compra 5
(10.00, 1, 1, 5),
(10.00, 1, 2, 5),
(10.00, 1, 3, 5),
(10.00, 1, 4, 5),
(10.00, 1, 5, 5),
(10.00, 1, 6, 5),
(10.00, 1, 7, 5),
(10.00, 1, 8, 5),
(10.00, 1, 9, 5),
(10.00, 1, 10, 5),
-- detalles para la compra 6
(10.00, 1, 1, 6),
(10.00, 1, 2, 6),
(10.00, 1, 3, 6),
(10.00, 1, 4, 6),
(10.00, 1, 5, 6),
(10.00, 1, 6, 6),
(10.00, 1, 7, 6),
(10.00, 1, 8, 6),
(10.00, 1, 9, 6),
(10.00, 1, 10, 6),
-- detalles para la compra 7
(10.00, 1, 1, 7),
(10.00, 1, 2, 7),
(10.00, 1, 3, 7),
(10.00, 1, 4, 7),
(10.00, 1, 5, 7),
(10.00, 1, 6, 7),
(10.00, 1, 7, 7),
(10.00, 1, 8, 7),
(10.00, 1, 9, 7),
(10.00, 1, 10, 7),
-- detalles para la compra 8
(10.00, 1, 1, 8),
(10.00, 1, 2, 8),
(10.00, 1, 3, 8),
(10.00, 1, 4, 8),
(10.00, 1, 5, 8),
(10.00, 1, 6, 8),
(10.00, 1, 7, 8),
(10.00, 1, 8, 8),
(10.00, 1, 9, 8),
(10.00, 1, 10, 8),
-- detalles para la compra 9
(10.00, 1, 1, 9),
(10.00, 1, 2, 9),
(10.00, 1, 3, 9),
(10.00, 1, 4, 9),
(10.00, 1, 5, 9),
(10.00, 1, 6, 9),
(10.00, 1, 7, 9),
(10.00, 1, 8, 9),
(10.00, 1, 9, 9),
(10.00, 1, 10, 9),
-- detalles para la compra 10
(10.00, 1, 1, 10),
(10.00, 1, 2, 10),
(10.00, 1, 3, 10),
(10.00, 1, 4, 10),
(10.00, 1, 5, 10),
(10.00, 1, 6, 10),
(10.00, 1, 7, 10),
(10.00, 1, 8, 10),
(10.00, 1, 9, 10),
(10.00, 1, 10, 10),
-- detalles para la compra 11
(10.00, 1, 1, 11),
(10.00, 1, 2, 11),
(10.00, 1, 3, 11),
(10.00, 1, 4, 11),
(10.00, 1, 5, 11),
(10.00, 1, 6, 11),
(10.00, 1, 7, 11),
(10.00, 1, 8, 11),
(10.00, 1, 9, 11),
(10.00, 1, 10, 11),
-- detalles para la compra 12
(10.00, 1, 1, 12),
(10.00, 1, 2, 12),
(10.00, 1, 3, 12),
(10.00, 1, 4, 12),
(10.00, 1, 5, 12),
(10.00, 1, 6, 12),
(10.00, 1, 7, 12),
(10.00, 1, 8, 12),
(10.00, 1, 9, 12),
(10.00, 1, 10, 12),
-- detalles para la compra 13
(10.00, 1, 1, 13),
(10.00, 1, 2, 13),
(10.00, 1, 3, 13),
(10.00, 1, 4, 13),
(10.00, 1, 5, 13),
(10.00, 1, 6, 13),
(10.00, 1, 7, 13),
(10.00, 1, 8, 13),
(10.00, 1, 9, 13),
(10.00, 1, 10, 13),
-- detalles para la compra 14
(10.00, 1, 1, 14),
(10.00, 1, 2, 14),
(10.00, 1, 3, 14),
(10.00, 1, 4, 14),
(10.00, 1, 5, 14),
(10.00, 1, 6, 14),
(10.00, 1, 7, 14),
(10.00, 1, 8, 14),
(10.00, 1, 9, 14),
(10.00, 1, 10, 14),
-- detalles para la compra 15
(10.00, 1, 1, 15),
(10.00, 1, 2, 15),
(10.00, 1, 3, 15),
(10.00, 1, 4, 15),
(10.00, 1, 5, 15),
(10.00, 1, 6, 15),
(10.00, 1, 7, 15),
(10.00, 1, 8, 15),
(10.00, 1, 9, 15),
(10.00, 1, 10, 15),
-- detalles para la compra 16
(10.00, 1, 1, 16),
(10.00, 1, 2, 16),
(10.00, 1, 3, 16),
(10.00, 1, 4, 16),
(10.00, 1, 5, 16),
(10.00, 1, 6, 16),
(10.00, 1, 7, 16),
(10.00, 1, 8, 16),
(10.00, 1, 9, 16),
(10.00, 1, 10, 16),
-- detalles para la compra 17
(10.00, 1, 1, 17),
(10.00, 1, 2, 17),
(10.00, 1, 3, 17),
(10.00, 1, 4, 17),
(10.00, 1, 5, 17),
(10.00, 1, 6, 17),
(10.00, 1, 7, 17),
(10.00, 1, 8, 17),
(10.00, 1, 9, 17),
(10.00, 1, 10, 17),
-- detalles para la compra 18
(10.00, 1, 1, 18),
(10.00, 1, 2, 18),
(10.00, 1, 3, 18),
(10.00, 1, 4, 18),
(10.00, 1, 5, 18),
(10.00, 1, 6, 18),
(10.00, 1, 7, 18),
(10.00, 1, 8, 18),
(10.00, 1, 9, 18),
(10.00, 1, 10, 18),
-- detalles para la compra 19
(10.00, 1, 1, 19),
(10.00, 1, 2, 19),
(10.00, 1, 3, 19),
(10.00, 1, 4, 19),
(10.00, 1, 5, 19),
(10.00, 1, 6, 19),
(10.00, 1, 7, 19),
(10.00, 1, 8, 19),
(10.00, 1, 9, 19),
(10.00, 1, 10, 19),
-- detalles para la compra 20
(10.00, 1, 1, 20),
(10.00, 1, 2, 20),
(10.00, 1, 3, 20),
(10.00, 1, 4, 20),
(10.00, 1, 5, 20),
(10.00, 1, 6, 20),
(10.00, 1, 7, 20),
(10.00, 1, 8, 20),
(10.00, 1, 9, 20),
(10.00, 1, 10, 20),
-- detalles para la compra 21
(10.00, 1, 1, 21),
(10.00, 1, 2, 21),
(10.00, 1, 3, 21),
(10.00, 1, 4, 21),
(10.00, 1, 5, 21),
(10.00, 1, 6, 21),
(10.00, 1, 7, 21),
(10.00, 1, 8, 21),
(10.00, 1, 9, 21),
(10.00, 1, 10, 21),
-- detalles para la compra 22
(10.00, 1, 1, 22),
(10.00, 1, 2, 22),
(10.00, 1, 3, 22),
(10.00, 1, 4, 22),
(10.00, 1, 5, 22),
(10.00, 1, 6, 22),
(10.00, 1, 7, 22),
(10.00, 1, 8, 22),
(10.00, 1, 9, 22),
(10.00, 1, 10, 22),
-- detalles para la compra 23
(10.00, 1, 1, 23),
(10.00, 1, 2, 23),
(10.00, 1, 3, 23),
(10.00, 1, 4, 23),
(10.00, 1, 5, 23),
(10.00, 1, 6, 23),
(10.00, 1, 7, 23),
(10.00, 1, 8, 23),
(10.00, 1, 9, 23),
(10.00, 1, 10, 23),
-- detalles para la compra 24
(10.00, 1, 1, 24),
(10.00, 1, 2, 24),
(10.00, 1, 3, 24),
(10.00, 1, 4, 24),
(10.00, 1, 5, 24),
(10.00, 1, 6, 24),
(10.00, 1, 7, 24),
(10.00, 1, 8, 24),
(10.00, 1, 9, 24),
(10.00, 1, 10, 24),
-- detalles para la compra 25
(10.00, 1, 1, 25),
(10.00, 1, 2, 25),
(10.00, 1, 3, 25),
(10.00, 1, 4, 25),
(10.00, 1, 5, 25),
(10.00, 1, 6, 25),
(10.00, 1, 7, 25),
(10.00, 1, 8, 25),
(10.00, 1, 9, 25),
(10.00, 1, 10, 25),
-- detalles para la compra 26
(10.00, 1, 1, 26),
(10.00, 1, 2, 26),
(10.00, 1, 3, 26),
(10.00, 1, 4, 26),
(10.00, 1, 5, 26),
(10.00, 1, 6, 26),
(10.00, 1, 7, 26),
(10.00, 1, 8, 26),
(10.00, 1, 9, 26),
(10.00, 1, 10, 26),
-- detalles para la compra 27
(10.00, 1, 1, 27),
(10.00, 1, 2, 27),
(10.00, 1, 3, 27),
(10.00, 1, 4, 27),
(10.00, 1, 5, 27),
(10.00, 1, 6, 27),
(10.00, 1, 7, 27),
(10.00, 1, 8, 27),
(10.00, 1, 9, 27),
(10.00, 1, 10, 27),
-- detalles para la compra 28
(10.00, 1, 1, 28),
(10.00, 1, 2, 28),
(10.00, 1, 3, 28),
(10.00, 1, 4, 28),
(10.00, 1, 5, 28),
(10.00, 1, 6, 28),
(10.00, 1, 7, 28),
(10.00, 1, 8, 28),
(10.00, 1, 9, 28),
(10.00, 1, 10, 28),
-- detalles para la compra 29
(10.00, 1, 1, 29),
(10.00, 1, 2, 29),
(10.00, 1, 3, 29),
(10.00, 1, 4, 29),
(10.00, 1, 5, 29),
(10.00, 1, 6, 29),
(10.00, 1, 7, 29),
(10.00, 1, 8, 29),
(10.00, 1, 9, 29),
(10.00, 1, 10, 29),
-- detalles para la compra 30
(10.00, 1, 1, 30),
(10.00, 1, 2, 30),
(10.00, 1, 3, 30),
(10.00, 1, 4, 30),
(10.00, 1, 5, 30),
(10.00, 1, 6, 30),
(10.00, 1, 7, 30),
(10.00, 1, 8, 30),
(10.00, 1, 9, 30),
(10.00, 1, 10, 30),
-- detalles para la compra 31
(10.00, 1, 1, 31),
(10.00, 1, 2, 31),
(10.00, 1, 3, 31),
(10.00, 1, 4, 31),
(10.00, 1, 5, 31),
(10.00, 1, 6, 31),
(10.00, 1, 7, 31),
(10.00, 1, 8, 31),
(10.00, 1, 9, 31),
(10.00, 1, 10, 31),
-- detalles para la compra 32
(10.00, 1, 1, 32),
(10.00, 1, 2, 32),
(10.00, 1, 3, 32),
(10.00, 1, 4, 32),
(10.00, 1, 5, 32),
(10.00, 1, 6, 32),
(10.00, 1, 7, 32),
(10.00, 1, 8, 32),
(10.00, 1, 9, 32),
(10.00, 1, 10, 32),
-- detalles para la compra 33
(10.00, 1, 1, 33),
(10.00, 1, 2, 33),
(10.00, 1, 3, 33),
(10.00, 1, 4, 33),
(10.00, 1, 5, 33),
(10.00, 1, 6, 33),
(10.00, 1, 7, 33),
(10.00, 1, 8, 33),
(10.00, 1, 9, 33),
(10.00, 1, 10, 33),
-- detalles para la compra 34
(10.00, 1, 1, 34),
(10.00, 1, 2, 34),
(10.00, 1, 3, 34),
(10.00, 1, 4, 34),
(10.00, 1, 5, 34),
(10.00, 1, 6, 34),
(10.00, 1, 7, 34),
(10.00, 1, 8, 34),
(10.00, 1, 9, 34),
(10.00, 1, 10, 34),
-- detalles para la compra 35
(10.00, 1, 1, 35),
(10.00, 1, 2, 35),
(10.00, 1, 3, 35),
(10.00, 1, 4, 35),
(10.00, 1, 5, 35),
(10.00, 1, 6, 35),
(10.00, 1, 7, 35),
(10.00, 1, 8, 35),
(10.00, 1, 9, 35),
(10.00, 1, 10, 35),
-- detalles para la compra 36
(10.00, 1, 1, 36),
(10.00, 1, 2, 36),
(10.00, 1, 3, 36),
(10.00, 1, 4, 36),
(10.00, 1, 5, 36),
(10.00, 1, 6, 36),
(10.00, 1, 7, 36),
(10.00, 1, 8, 36),
(10.00, 1, 9, 36),
(10.00, 1, 10, 36),
-- detalles para la compra 37
(10.00, 1, 1, 37),
(10.00, 1, 2, 37),
(10.00, 1, 3, 37),
(10.00, 1, 4, 37),
(10.00, 1, 5, 37),
(10.00, 1, 6, 37),
(10.00, 1, 7, 37),
(10.00, 1, 8, 37),
(10.00, 1, 9, 37),
(10.00, 1, 10, 37),
-- detalles para la compra 38
(10.00, 1, 1, 38),
(10.00, 1, 2, 38),
(10.00, 1, 3, 38),
(10.00, 1, 4, 38),
(10.00, 1, 5, 38),
(10.00, 1, 6, 38),
(10.00, 1, 7, 38),
(10.00, 1, 8, 38),
(10.00, 1, 9, 38),
(10.00, 1, 10, 38),
-- detalles para la compra 39
(10.00, 1, 1, 39),
(10.00, 1, 2, 39),
(10.00, 1, 3, 39),
(10.00, 1, 4, 39),
(10.00, 1, 5, 39),
(10.00, 1, 6, 39),
(10.00, 1, 7, 39),
(10.00, 1, 8, 39),
(10.00, 1, 9, 39),
(10.00, 1, 10, 39),
-- detalles para la compra 40
(10.00, 1, 1, 40),
(10.00, 1, 2, 40),
(10.00, 1, 3, 40),
(10.00, 1, 4, 40),
(10.00, 1, 5, 40),
(10.00, 1, 6, 40),
(10.00, 1, 7, 40),
(10.00, 1, 8, 40),
(10.00, 1, 9, 40),
(10.00, 1, 10, 40); 


INSERT INTO Compra_Estatus (compra_id_compra, estatus_id_estatus, fecha_hora_asignacion, fecha_hora_fin) VALUES
(1, 1, '2025-01-15 08:00:00', '2025-01-15 08:30:00'), 
(1, 2, '2025-01-15 08:30:00', '2025-01-15 09:00:00'),
(1, 3, '2025-01-15 09:00:00', '2025-01-15 09:15:00'),
(2, 1, '2025-01-16 10:00:00', '2025-01-16 10:20:00'), 
(2, 3, '2025-01-16 11:00:00', '2025-01-16 11:10:00'), 
(2, 2, '2025-01-16 11:10:00', '2025-01-16 13:10:00'), 
(3, 1, '2025-01-17 14:00:00', '2025-01-17 14:15:00'),  
(3, 2, '2025-01-17 14:15:00', '2025-01-17 14:30:00'); 


INSERT INTO Venta_Evento (evento_id, id_cliente_natural, fecha_compra, total) VALUES
(1, 1, '2024-07-19 11:30:00', 85.50),
(1, 3, '2024-07-19 14:20:00', 120.75),
(1, 5, '2024-07-20 16:45:00', 95.25),
(1, 7, '2024-07-20 19:10:00', 110.00),
(2, 2, '2024-08-15 19:15:00', 180.00),
(2, 4, '2024-08-15 20:30:00', 165.50),
(3, 1, '2024-09-10 20:45:00', 75.80),
(3, 6, '2024-09-10 21:30:00', 90.25),
(3, 8, '2024-09-10 22:15:00', 105.60),
(4, 3, '2024-10-05 18:20:00', 145.75),
(4, 9, '2024-10-05 20:45:00', 135.90),
(5, 2, '2024-11-12 10:30:00', 200.50),
(5, 5, '2024-11-13 14:15:00', 175.25),
(5, 10, '2024-11-14 16:00:00', 190.80),
(6, 4, '2024-06-22 15:45:00', 125.40),
(7, 6, '2024-05-18 17:30:00', 95.75),
(7, 8, '2024-05-18 19:20:00', 110.50),
(8, 1, '2024-10-19 16:45:00', 155.60),
(8, 7, '2024-10-19 20:30:00', 140.25),
(8, 9, '2024-10-19 22:10:00', 125.90),
(9, 3, '2024-09-28 09:45:00', 220.75),
(9, 10, '2024-09-29 15:20:00', 195.50),
(10, 2, '2024-12-07 12:30:00', 165.80),
(10, 4, '2024-12-07 16:45:00', 180.25),
(10, 6, '2024-12-08 14:15:00', 145.60);
INSERT INTO Detalle_Venta_Evento (
    precio_unitario, cantidad, id_evento, id_cliente_natural, id_cerveza, id_proveedor, id_proveedor_evento, id_tipo_cerveza, id_presentacion, id_cerveza_inv
) VALUES
-- Evento 1, cliente 1
(15.50, 3, 1, 1, 1, 1, 1, 30, 1, 1),
-- Evento 1, cliente 3
(16.00, 2, 1, 3, 1, 1, 1, 30, 1, 1),
-- Evento 1, cliente 5
(16.50, 2, 1, 5, 1, 1, 1, 30, 1, 1),
-- Evento 1, cliente 7
(17.00, 2, 1, 7, 1, 1, 1, 30, 1, 1),
-- Evento 2, cliente 2
(18.00, 2, 2, 2, 5, 5, 2, 20, 2, 5),
-- Evento 2, cliente 4
(18.50, 2, 2, 4, 5, 5, 2, 20, 2, 5),
-- Evento 3, cliente 1
(19.00, 2, 3, 1, 1, 1, 1, 30, 1, 1),
-- Evento 3, cliente 6
(19.50, 2, 3, 6, 1, 1, 1, 30, 1, 1),
-- Evento 3, cliente 8
(20.00, 2, 3, 8, 1, 1, 1, 30, 1, 1);



INSERT INTO Promocion (descripcion, id_departamento, fecha_inicio, fecha_fin, id_usuario) VALUES
('Descuento 15% en Cervezas IPA durante Enero', 1, '2025-01-01', '2025-01-31', 1),
('2x1 en Cervezas Lager los Viernes', 1, '2025-01-15', '2025-03-15', 2),
('Happy Hour: 20% descuento de 5-7 PM', 1, '2025-02-01', '2025-02-28', NULL),
('Promoción San Valentín: Cerveza + Copa', 2, '2025-02-10', '2025-02-16', 3),
('Mes de la Cerveza Artesanal - 25% descuento', 2, '2025-03-01', '2025-03-31', 4),
('Promoción Día del Padre: Pack Degustación', 2, '2025-06-15', '2025-06-22', NULL),
('Lanzamiento Cerveza Nueva: 30% descuento', 1, '2025-04-01', '2025-04-15', 5),
('Promoción Clientes VIP: Descuento Exclusivo', 3, '2025-01-01', '2025-12-31', 6),
('Verano Cervecero: Cervezas Refrescantes', 1, '2025-06-01', '2025-08-31', NULL),
('Navidad Cervecera: Packs Especiales', 2, '2025-12-01', '2025-12-31', 7);

INSERT INTO Descuento (porcentaje, id_promocion, id_tipo_cerveza, id_presentacion, id_cerveza) VALUES
(15.00, 1, 13, 2, 2),
(50.00, 2, 1, 1, 1),
(50.00, 2, 1, 2, 2),
(50.00, 2, 3, 3, 4),
(20.00, 3, 1, 2, 5),
(20.00, 3, 2, 1, 1),
(20.00, 3, 12, 2, 2),
(10.00, 4, 17, 2, 5),
(10.00, 4, 19, 3, 4), -- corregido a (3,4)
(25.00, 5, 2, 1, 6),
(25.00, 5, 12, 1, 7),
(25.00, 5, 22, 1, 6),
(25.00, 5, 8, 1, 9),
(15.00, 6, 13, 1, 6),
(15.00, 6, 17, 2, 5),
(15.00, 6, 30, 1, 10),
(30.00, 7, 30, 1, 10),
(30.00, 7, 30, 3, 3),
(35.00, 8, 19, 3, 4), -- corregido a (3,4)
(35.00, 8, 17, 2, 5),
(18.00, 9, 1, 1, 6),
(18.00, 9, 3, 1, 7),
(18.00, 9, 22, 1, 6),
(22.00, 10, 17, 2, 5),
(22.00, 10, 19, 3, 4), -- corregido a (3,4)
(22.00, 10, 8, 1, 9); 


-- =====================================================
-- BLOQUE 5: PAGOS (Último - dependen de todo)
-- =====================================================


INSERT INTO Pago_Compra (metodo_id, compra_id, monto, fecha_hora, referencia, tasa_id) VALUES
(21, 1, 100.00, '2025-01-15 10:30:00', 'COMP-001-001', 1),
(22, 2, 100.00, '2025-01-15 11:45:00', 'COMP-002-001', 1),
(23, 3, 60.00, '2025-01-16 09:15:00', 'COMP-003-001', 2),
(1, 3, 40.00, '2025-01-16 09:16:00', 'COMP-003-002', 2),
(24, 4, 100.00, '2025-01-16 14:20:00', 'COMP-004-001', 2),
(25, 5, 100.00, '2025-01-17 08:30:00', 'COMP-005-001', 3),
(26, 6, 70.00, '2025-01-17 16:45:00', 'COMP-006-001', 3),
(2, 6, 30.00, '2025-01-17 16:46:00', 'COMP-006-002', 3),
(27, 7, 100.00, '2025-01-18 12:10:00', 'COMP-007-001', 4),
(28, 8, 100.00, '2025-01-18 15:25:00', 'COMP-008-001', 4),
(29, 9, 100.00, '2025-01-19 09:40:00', 'COMP-009-001', 5),
(30, 10, 80.00, '2025-01-19 13:55:00', 'COMP-010-001', 5),
(3, 10, 20.00, '2025-01-19 13:56:00', 'COMP-010-002', 5),
(31, 11, 100.00, '2025-01-20 10:15:00', 'COMP-011-001', 6),
(32, 12, 100.00, '2025-01-20 14:30:00', 'COMP-012-001', 6),
(33, 13, 100.00, '2025-01-21 08:45:00', 'COMP-013-001', 7),
(34, 14, 100.00, '2025-01-21 11:20:00', 'COMP-014-001', 7),
(35, 15, 100.00, '2025-01-22 09:35:00', 'COMP-015-001', 8),
(36, 16, 75.00, '2025-01-22 16:10:00', 'COMP-016-001', 8),
(4, 16, 25.00, '2025-01-22 16:11:00', 'COMP-016-002', 8),
(37, 17, 100.00, '2025-01-23 10:25:00', 'COMP-017-001', 9),
(38, 18, 100.00, '2025-01-23 13:40:00', 'COMP-018-001', 9),
(39, 19, 100.00, '2025-01-24 08:55:00', 'COMP-019-001', 10),
(40, 20, 100.00, '2025-01-24 15:15:00', 'COMP-020-001', 10),
(11, 21, 100.00, '2025-01-25 09:30:00', 'COMP-021-001', 1),
(12, 22, 100.00, '2025-01-25 12:45:00', 'COMP-022-001', 1),
(13, 23, 100.00, '2025-01-26 10:00:00', 'COMP-023-001', 2),
(14, 24, 90.00, '2025-01-26 14:15:00', 'COMP-024-001', 2),
(5, 24, 10.00, '2025-01-26 14:16:00', 'COMP-024-002', 2),
(15, 25, 100.00, '2025-01-27 08:30:00', 'COMP-025-001', 3),
(16, 26, 100.00, '2025-01-27 11:45:00', 'COMP-026-001', 3),
(17, 27, 100.00, '2025-01-28 09:00:00', 'COMP-027-001', 4),
(18, 28, 100.00, '2025-01-28 13:20:00', 'COMP-028-001', 4),
(19, 29, 100.00, '2025-01-29 10:35:00', 'COMP-029-001', 5),
(20, 30, 100.00, '2025-01-29 15:50:00', 'COMP-030-001', 5),
(21, 31, 100.00, '2025-01-30 09:15:00', 'COMP-031-001', 6),
(22, 32, 85.00, '2025-01-30 12:30:00', 'COMP-032-001', 6),
(6, 32, 15.00, '2025-01-30 12:31:00', 'COMP-032-002', 6),
(23, 33, 100.00, '2025-01-31 08:45:00', 'COMP-033-001', 7),
(24, 34, 100.00, '2025-01-31 14:00:00', 'COMP-034-001', 7),
(25, 35, 100.00, '2025-02-01 10:20:00', 'COMP-035-001', 8),
(26, 36, 100.00, '2025-02-01 13:35:00', 'COMP-036-001', 8),
(27, 37, 100.00, '2025-02-02 09:50:00', 'COMP-037-001', 9),
(28, 38, 100.00, '2025-02-02 12:05:00', 'COMP-038-001', 9),
(29, 39, 100.00, '2025-02-03 08:20:00', 'COMP-039-001', 10),
(30, 40, 100.00, '2025-02-03 15:40:00', 'COMP-040-001', 10),
(11, 41, 100.00, '2025-02-04 09:10:00', 'COMP-041-001', 1),
(12, 42, 100.00, '2025-02-04 11:25:00', 'COMP-042-001', 1),
(13, 43, 100.00, '2025-02-05 08:40:00', 'COMP-043-001', 2),
(14, 44, 100.00, '2025-02-05 13:55:00', 'COMP-044-001', 2),
(15, 45, 100.00, '2025-02-06 10:10:00', 'COMP-045-001', 3),
(16, 46, 100.00, '2025-02-06 14:25:00', 'COMP-046-001', 3),
(17, 47, 100.00, '2025-02-07 09:40:00', 'COMP-047-001', 4),
(18, 48, 100.00, '2025-02-07 12:55:00', 'COMP-048-001', 4),
(19, 49, 100.00, '2025-02-08 08:15:00', 'COMP-049-001', 5),
(20, 50, 100.00, '2025-02-08 15:30:00', 'COMP-050-001', 5),
(21, 51, 100.00, '2025-02-09 10:45:00', 'COMP-051-001', 6),
(22, 52, 100.00, '2025-02-09 13:00:00', 'COMP-052-001', 6),
(23, 53, 100.00, '2025-02-10 09:20:00', 'COMP-053-001', 7),
(24, 54, 100.00, '2025-02-10 14:35:00', 'COMP-054-001', 7),
(25, 55, 100.00, '2025-02-11 08:50:00', 'COMP-055-001', 8),
(26, 56, 100.00, '2025-02-11 12:05:00', 'COMP-056-001', 8),
(27, 57, 100.00, '2025-02-12 10:20:00', 'COMP-057-001', 9),
(28, 58, 100.00, '2025-02-12 15:35:00', 'COMP-058-001', 9),
(29, 59, 100.00, '2025-02-13 09:50:00', 'COMP-059-001', 10),
(30, 60, 100.00, '2025-02-13 13:05:00', 'COMP-060-001', 10),
(31, 61, 100.00, '2025-02-14 08:25:00', 'COMP-061-001', 1),
(32, 62, 100.00, '2025-02-14 11:40:00', 'COMP-062-001', 1),
(33, 63, 100.00, '2025-02-15 09:55:00', 'COMP-063-001', 2),
(34, 64, 100.00, '2025-02-15 14:10:00', 'COMP-064-001', 2),
(35, 65, 100.00, '2025-02-16 10:25:00', 'COMP-065-001', 3),
(36, 66, 100.00, '2025-02-16 13:40:00', 'COMP-066-001', 3),
(37, 67, 100.00, '2025-02-17 08:55:00', 'COMP-067-001', 4),
(38, 68, 100.00, '2025-02-17 12:10:00', 'COMP-068-001', 4),
(39, 69, 100.00, '2025-02-18 09:30:00', 'COMP-069-001', 5),
(40, 70, 100.00, '2025-02-18 14:45:00', 'COMP-070-001', 5),
(11, 71, 100.00, '2025-02-19 10:00:00', 'COMP-071-001', 6),
(12, 72, 100.00, '2025-02-19 13:15:00', 'COMP-072-001', 6),
(13, 73, 100.00, '2025-02-20 08:35:00', 'COMP-073-001', 7),
(14, 74, 100.00, '2025-02-20 11:50:00', 'COMP-074-001', 7),
(15, 75, 100.00, '2025-02-21 09:05:00', 'COMP-075-001', 8),
(16, 76, 100.00, '2025-02-21 14:20:00', 'COMP-076-001', 8),
(17, 77, 100.00, '2025-02-22 10:40:00', 'COMP-077-001', 9),
(18, 78, 100.00, '2025-02-22 13:55:00', 'COMP-078-001', 9),
(19, 79, 100.00, '2025-02-23 09:15:00', 'COMP-079-001', 10),
(20, 80, 100.00, '2025-02-23 15:30:00', 'COMP-080-001', 10);


INSERT INTO Pago_Evento (metodo_id, evento_id, id_cliente_natural, fecha_hora, monto, tasa_id, referencia) VALUES
(21, 1, 1, '2024-07-19 11:30:00', 85.50, 1, 'TXN-20240719-001'),
(22, 1, 3, '2024-07-19 14:20:00', 70.75, 1, 'TXN-20240719-002'),
(1, 1, 3, '2024-07-19 14:21:00', 50.00, 1, 'EFE-20240719-001'),
(31, 1, 5, '2024-07-20 16:45:00', 95.25, 2, 'TXN-20240720-001'),
(23, 1, 7, '2024-07-20 19:10:00', 110.00, 2, 'TXN-20240720-002'),
(24, 2, 2, '2024-08-15 19:15:00', 100.00, 3, 'TXN-20240815-001'),
(32, 2, 2, '2024-08-15 19:16:00', 80.00, 3, 'TXN-20240815-002'),
(25, 2, 4, '2024-08-15 20:30:00', 165.50, 3, 'TXN-20240815-003'),
(33, 3, 1, '2024-09-10 20:45:00', 75.80, 4, 'TXN-20240910-001'),
(26, 3, 6, '2024-09-10 21:30:00', 90.25, 4, 'TXN-20240910-002'),
(2, 3, 8, '2024-09-10 22:15:00', 55.60, 4, 'EFE-20240910-001'),
(34, 3, 8, '2024-09-10 22:16:00', 50.00, 4, 'TXN-20240910-003'),
(27, 4, 3, '2024-10-05 18:20:00', 145.75, 5, 'TXN-20241005-001'),
(35, 4, 9, '2024-10-05 20:45:00', 85.90, 5, 'TXN-20241005-002'),
(3, 4, 9, '2024-10-05 20:46:00', 50.00, 5, 'EFE-20241005-001'),
(28, 5, 2, '2024-11-12 10:30:00', 200.50, 6, 'TXN-20241112-001'),
(36, 5, 5, '2024-11-13 14:15:00', 125.25, 6, 'TXN-20241113-001'),
(4, 5, 5, '2024-11-13 14:16:00', 50.00, 6, 'EFE-20241113-001'),
(29, 5, 10, '2024-11-14 16:00:00', 140.80, 6, 'TXN-20241114-001'),
(5, 5, 10, '2024-11-14 16:01:00', 50.00, 6, 'EFE-20241114-001'),
(37, 6, 4, '2024-06-22 15:45:00', 125.40, 7, 'TXN-20240622-001'),
(30, 7, 6, '2024-05-18 17:30:00', 95.75, 8, 'TXN-20240518-001'),
(38, 7, 8, '2024-05-18 19:20:00', 110.50, 8, 'TXN-20240518-002'),
(39, 8, 1, '2024-10-19 16:45:00', 105.60, 9, 'TXN-20241019-001'),
(6, 8, 1, '2024-10-19 16:46:00', 50.00, 9, 'EFE-20241019-001'),
(40, 8, 7, '2024-10-19 20:30:00', 140.25, 9, 'TXN-20241019-002'),
(11, 8, 9, '2024-10-19 22:10:00', 125.90, 9, 'CHQ-20241019-001'),
(12, 9, 3, '2024-09-28 09:45:00', 170.75, 10, 'CHQ-20240928-001'),
(7, 9, 3, '2024-09-28 09:46:00', 50.00, 10, 'EFE-20240928-001'),
(13, 9, 10, '2024-09-29 15:20:00', 145.50, 10, 'CHQ-20240929-001'),
(8, 9, 10, '2024-09-29 15:21:00', 50.00, 10, 'EFE-20240929-001'),
(14, 10, 2, '2024-12-07 12:30:00', 165.80, 1, 'CHQ-20241207-001'),
(15, 10, 4, '2024-12-07 16:45:00', 130.25, 1, 'CHQ-20241207-002'),
(1, 10, 4, '2024-12-07 16:46:00', 50.00, 1, 'EFE-20241207-001'),
(16, 10, 6, '2024-12-08 14:15:00', 95.60, 2, 'CHQ-20241208-001'),
(2, 10, 6, '2024-12-08 14:16:00', 50.00, 2, 'EFE-20241208-001');


INSERT INTO Pago_Cuota_Afiliacion (metodo_id, cuota_id, monto, fecha_pago, tasa_id) VALUES
(21, 1, 150.00, '2024-01-15', NULL), 
(12, 2, 150.00, '2024-03-20', NULL),
(32, 3, 150.00, '2024-06-10', NULL),
(6, 4, 150.00, '2024-09-05', NULL),
(22, 5, 150.00, '2024-11-12', NULL),
(11, 6, 120.00, '2023-01-10', NULL),
(4, 7, 120.00, '2023-05-15', NULL),
(34, 8, 120.00, '2023-08-20', NULL),
(23, 9, 180.00, '2024-02-01', 1),
(13, 10, 180.00, '2024-04-15', 2);


INSERT INTO Pago_Orden_Reposicion (id_proveedor, id_departamento, id_orden_reposicion, fecha_ejecucion, monto) VALUES
(1, 3, 1, CURRENT_TIMESTAMP + INTERVAL '1 day', 2850.00),
(2, 3, 2, CURRENT_TIMESTAMP + INTERVAL '1 day 2 hours', 3200.00),
(3, 3, 3, CURRENT_TIMESTAMP + INTERVAL '1 day 4 hours', 1950.00),
(4, 3, 4, CURRENT_TIMESTAMP + INTERVAL '1 day 6 hours', 4100.00),
(5, 3, 5, CURRENT_TIMESTAMP + INTERVAL '2 days', 2750.00),
(6, 3, 6, CURRENT_TIMESTAMP + INTERVAL '2 days 2 hours', 3650.00),
(7, 3, 7, CURRENT_TIMESTAMP + INTERVAL '2 days 4 hours', 2400.00),
(8, 3, 8, CURRENT_TIMESTAMP + INTERVAL '2 days 6 hours', 3850.00),
(9, 3, 9, CURRENT_TIMESTAMP + INTERVAL '3 days', 3100.00),
(10, 3, 10, CURRENT_TIMESTAMP + INTERVAL '3 days 2 hours', 3500.00);
