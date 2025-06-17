-- Insertar Estados de Venezuela (fk_lugar es NULL para los estados)
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

-- Insertar Municipios por Estado (fk_lugar es la id del Estado correspondiente)
INSERT INTO Lugar (nombre, tipo, fk_lugar) VALUES
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

-- Insertar Parroquias por Municipio (fk_lugar es la id del Municipio correspondiente)
-- ids de parroquias inician después de la última id de municipio (360)
INSERT INTO Lugar (nombre, tipo, fk_lugar) VALUES
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
