-- Insert Estados
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(1, 'Amazonas', 'estado', NULL),
(2, 'Anzoátegui', 'estado', NULL),
(3, 'Apure', 'estado', NULL),
(4, 'Aragua', 'estado', NULL),
(5, 'Barinas', 'estado', NULL),
(6, 'Bolívar', 'estado', NULL),
(7, 'Carabobo', 'estado', NULL),
(8, 'Cojedes', 'estado', NULL),
(9, 'Delta Amacuro', 'estado', NULL),
(10, 'Falcón', 'estado', NULL),
(11, 'Guárico', 'estado', NULL),
(12, 'Lara', 'estado', NULL),
(13, 'Mérida', 'estado', NULL),
(14, 'Miranda', 'estado', NULL),
(15, 'Monagas', 'estado', NULL),
(16, 'Nueva Esparta', 'estado', NULL),
(17, 'Portuguesa', 'estado', NULL),
(18, 'Sucre', 'estado', NULL),
(19, 'Táchira', 'estado', NULL),
(20, 'Trujillo', 'estado', NULL),
(21, 'Vargas', 'estado', NULL),
(22, 'Yaracuy', 'estado', NULL),
(23, 'Zulia', 'estado', NULL);

-- Insert Municipios Amazonas
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(24, 'Atures', 'municipio', 1),
(25, 'Autana', 'municipio', 1),
(26, 'Manapiare', 'municipio', 1),
(27, 'Maroa', 'municipio', 1),
(28, 'Río Negro', 'municipio', 1);

-- Insert Parroquias Amazonas
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(29, 'Parroquia Urbana Atures', 'parroquia', 24),
(30, 'Parroquia Fernando Girón Tovar', 'parroquia', 24),
(31, 'Parroquia Isla Ratón', 'parroquia', 25),
(32, 'Parroquia Samariapo', 'parroquia', 25),
(33, 'Parroquia Alto Orinoco', 'parroquia', 26),
(34, 'Parroquia Manapiare', 'parroquia', 26),
(35, 'Parroquia Maroa', 'parroquia', 27),
(36, 'Parroquia Victorino', 'parroquia', 27),
(37, 'Parroquia San Carlos de Río Negro', 'parroquia', 28),
(38, 'Parroquia Casiquiare', 'parroquia', 28);

-- Insert Municipios Anzoátegui
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(39, 'Anaco', 'municipio', 2),
(40, 'Aragua', 'municipio', 2),
(41, 'Bolívar', 'municipio', 2),
(42, 'Guanta', 'municipio', 2),
(43, 'Simón Rodríguez', 'municipio', 2);

-- Insert Parroquias Anzoátegui
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(44, 'Parroquia Anaco', 'parroquia', 39),
(45, 'Parroquia San Joaquín', 'parroquia', 39),
(46, 'Parroquia Aragua de Barcelona', 'parroquia', 40),
(47, 'Parroquia Cachipo', 'parroquia', 40),
(48, 'Parroquia Barcelona', 'parroquia', 41),
(49, 'Parroquia El Carmen', 'parroquia', 41),
(50, 'Parroquia Guanta', 'parroquia', 42),
(51, 'Parroquia Chorrerón', 'parroquia', 42),
(52, 'Parroquia El Tigre', 'parroquia', 43),
(53, 'Parroquia Pozuelos', 'parroquia', 43);

-- Insert Municipios Apure
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(54, 'Achaguas', 'municipio', 3),
(55, 'Biruaca', 'municipio', 3),
(56, 'Muñóz', 'municipio', 3),
(57, 'San Fernando', 'municipio', 3),
(58, 'Páez', 'municipio', 3);

-- Insert Parroquias Apure
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(59, 'Parroquia Achaguas', 'parroquia', 54),
(60, 'Parroquia Apurito', 'parroquia', 54),
(61, 'Parroquia Biruaca', 'parroquia', 55),
(62, 'Parroquia Bruzual', 'parroquia', 55),
(63, 'Parroquia Muñóz', 'parroquia', 56),
(64, 'Parroquia San Vicente', 'parroquia', 56),
(65, 'Parroquia San Fernando', 'parroquia', 57),
(66, 'Parroquia El Recreo', 'parroquia', 57),
(67, 'Parroquia Guasdualito', 'parroquia', 58),
(68, 'Parroquia El Amparo', 'parroquia', 58);

-- Insert Municipios Aragua
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(69, 'Bolívar', 'municipio', 4),
(70, 'Girardot', 'municipio', 4),
(71, 'Mario Briceño Iragorry', 'municipio', 4),
(72, 'San Casimiro', 'municipio', 4),
(73, 'Santiago Mariño', 'municipio', 4);

-- Insert Parroquias Aragua
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(74, 'Parroquia San Mateo', 'parroquia', 69),
(75, 'Parroquia Las Tejerías', 'parroquia', 69),
(76, 'Parroquia Maracay', 'parroquia', 70),
(77, 'Parroquia Choroní', 'parroquia', 70),
(78, 'Parroquia Caña de Azúcar', 'parroquia', 71),
(79, 'Parroquia Palo Negro', 'parroquia', 71),
(80, 'Parroquia San Casimiro', 'parroquia', 72),
(81, 'Parroquia Güiripa', 'parroquia', 72),
(82, 'Parroquia Turmero', 'parroquia', 73),
(83, 'Parroquia Arevalo Aponte', 'parroquia', 73);

-- Insert Municipios Barinas
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(84, 'Barinas', 'municipio', 5),
(85, 'Alberto Arvelo Torrealba', 'municipio', 5),
(86, 'Obispos', 'municipio', 5),
(87, 'Pedraza', 'municipio', 5),
(88, 'Ezequiel Zamora', 'municipio', 5);

-- Insert Parroquias Barinas
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(89, 'Parroquia Barinas', 'parroquia', 84),
(90, 'Parroquia Corazón de Jesús', 'parroquia', 84),
(91, 'Parroquia Sabaneta', 'parroquia', 85),
(92, 'Parroquia El Cantón', 'parroquia', 85),
(93, 'Parroquia Obispos', 'parroquia', 86),
(94, 'Parroquia Los Guasimitos', 'parroquia', 86),
(95, 'Parroquia Ciudad Bolivia', 'parroquia', 87),
(96, 'Parroquia Ignacio Briceño', 'parroquia', 87),
(97, 'Parroquia Santa Bárbara', 'parroquia', 88),
(98, 'Parroquia El Real', 'parroquia', 88);

-- Insert Municipios Bolívar
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(99, 'Caroní', 'municipio', 6),
(100, 'Cedeño', 'municipio', 6),
(101, 'El Callao', 'municipio', 6),
(102, 'Heres', 'municipio', 6),
(103, 'Piar', 'municipio', 6);

-- Insert Parroquias Bolívar
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(104, 'Parroquia Ciudad Guayana', 'parroquia', 99),
(105, 'Parroquia Pozo Verde', 'parroquia', 99),
(106, 'Parroquia Caicara del Orinoco', 'parroquia', 100),
(107, 'Parroquia Altagracia', 'parroquia', 100),
(108, 'Parroquia El Callao', 'parroquia', 101),
(109, 'Parroquia La Urbana', 'parroquia', 101),
(110, 'Parroquia Ciudad Bolívar', 'parroquia', 102),
(111, 'Parroquia Orinoco', 'parroquia', 102),
(112, 'Parroquia Upata', 'parroquia', 103),
(113, 'Parroquia Andrés Eloy Blanco', 'parroquia', 103);

-- Insert Municipios Carabobo
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(114, 'Valencia', 'municipio', 7),
(115, 'Guacara', 'municipio', 7),
(116, 'Los Guayos', 'municipio', 7),
(117, 'Miranda', 'municipio', 7),
(118, 'San Diego', 'municipio', 7);

-- Insert Parroquias Carabobo
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(119, 'Parroquia Catedral', 'parroquia', 114),
(120, 'Parroquia San José', 'parroquia', 114),
(121, 'Parroquia Guacara', 'parroquia', 115),
(122, 'Parroquia Yagua', 'parroquia', 115),
(123, 'Parroquia Los Guayos', 'parroquia', 116),
(124, 'Parroquia Libertad', 'parroquia', 116),
(125, 'Parroquia Miranda', 'parroquia', 117),
(126, 'Parroquia Urama', 'parroquia', 117),
(127, 'Parroquia San Diego', 'parroquia', 118),
(128, 'Parroquia Unión', 'parroquia', 118);

-- Insert Municipios Cojedes
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(129, 'Anzoátegui', 'municipio', 8),
(130, 'Falcón', 'municipio', 8),
(131, 'Girardot', 'municipio', 8),
(132, 'Lima Blanco', 'municipio', 8),
(133, 'Ricaurte', 'municipio', 8);

-- Insert Parroquias Cojedes
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(134, 'Parroquia Cojedes', 'parroquia', 129),
(135, 'Parroquia Juan de Mata Suárez', 'parroquia', 129),
(136, 'Parroquia Tinaquillo', 'parroquia', 130),
(137, 'Parroquia El Baúl', 'parroquia', 130),
(138, 'Parroquia El Pao', 'parroquia', 131),
(139, 'Parroquia Rómulo Gallegos', 'parroquia', 131),
(140, 'Parroquia Macapo', 'parroquia', 132),
(141, 'Parroquia La Aguadita', 'parroquia', 132),
(142, 'Parroquia Libertad', 'parroquia', 133),
(143, 'Parroquia El Amparo', 'parroquia', 133);

-- Insert Municipios Delta Amacuro
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(144, 'Antonio Díaz', 'municipio', 9),
(145, 'Casacoima', 'municipio', 9),
(146, 'Pedernales', 'municipio', 9),
(147, 'Tucupita', 'municipio', 9),
(148, 'Manuel Renaud', 'municipio', 9);

-- Insert Parroquias Delta Amacuro
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(149, 'Parroquia Curiapo', 'parroquia', 144),
(150, 'Parroquia Francisco Aniceto Lugo', 'parroquia', 144),
(151, 'Parroquia Sierra Imataca', 'parroquia', 145),
(152, 'Parroquia Juan Bautista Arismendi', 'parroquia', 145),
(153, 'Parroquia Pedernales', 'parroquia', 146),
(154, 'Parroquia Luis Beltrán Prieto Figueroa', 'parroquia', 146),
(155, 'Parroquia Tucupita', 'parroquia', 147),
(156, 'Parroquia José Vidal Marcano', 'parroquia', 147),
(157, 'Parroquia Boca de Uchire', 'parroquia', 148),
(158, 'Parroquia Santa Catalina', 'parroquia', 148);

-- Insert Municipios Falcón
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(159, 'Acosta', 'municipio', 10),
(160, 'Bolívar', 'municipio', 10),
(161, 'Carirubana', 'municipio', 10),
(162, 'Colina', 'municipio', 10),
(163, 'Miranda', 'municipio', 10);

-- Insert Parroquias Falcón
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(164, 'Parroquia San Juan de los Cayos', 'parroquia', 159),
(165, 'Parroquia La Pastora', 'parroquia', 159),
(166, 'Parroquia San Luis', 'parroquia', 160),
(167, 'Parroquia Aracua', 'parroquia', 160),
(168, 'Parroquia Punta Cardón', 'parroquia', 161),
(169, 'Parroquia Santa Ana', 'parroquia', 161),
(170, 'Parroquia La Vela de Coro', 'parroquia', 162),
(171, 'Parroquia Acurigua', 'parroquia', 162),
(172, 'Parroquia Pueblo Nuevo', 'parroquia', 163),
(173, 'Parroquia Churuguara', 'parroquia', 163);

-- Insert Municipios Guárico
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(174, 'Camaguán', 'municipio', 11),
(175, 'Chaguaramas', 'municipio', 11),
(176, 'San Gerónimo de Guayabal', 'municipio', 11),
(177, 'Valle de la Pascua', 'municipio', 11),
(178, 'Zaraza', 'municipio', 11);

-- Insert Parroquias Guárico
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(179, 'Parroquia Camaguán', 'parroquia', 174),
(180, 'Parroquia Puerto Miranda', 'parroquia', 174),
(181, 'Parroquia Chaguaramas', 'parroquia', 175),
(182, 'Parroquia El Socorro', 'parroquia', 175),
(183, 'Parroquia Guayabal', 'parroquia', 176),
(184, 'Parroquia Cazorla', 'parroquia', 176),
(185, 'Parroquia Valle de la Pascua', 'parroquia', 177),
(186, 'Parroquia Espino', 'parroquia', 177),
(187, 'Parroquia Zaraza', 'parroquia', 178),
(188, 'Parroquia San José de Unare', 'parroquia', 178);

-- Insert Municipios Lara
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(189, 'Iribarren', 'municipio', 12),
(190, 'Jiménez', 'municipio', 12),
(191, 'Morán', 'municipio', 12),
(192, 'Palavecino', 'municipio', 12),
(193, 'Torres', 'municipio', 12);

-- Insert Parroquias Lara
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(194, 'Parroquia Barquisimeto', 'parroquia', 189),
(195, 'Parroquia Concepción', 'parroquia', 189),
(196, 'Parroquia Quíbor', 'parroquia', 190),
(197, 'Parroquia Juan Bautista Rodríguez', 'parroquia', 190),
(198, 'Parroquia El Tocuyo', 'parroquia', 191),
(199, 'Parroquia Anzoátegui', 'parroquia', 191),
(200, 'Parroquia Cabudare', 'parroquia', 192),
(201, 'Parroquia José Gregorio Bastidas', 'parroquia', 192),
(202, 'Parroquia Carora', 'parroquia', 193),
(203, 'Parroquia Antonio Díaz', 'parroquia', 193);

-- Insert Municipios Mérida
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(204, 'Alberto Adriani', 'municipio', 13),
(205, 'Libertador', 'municipio', 13),
(206, 'Miranda', 'municipio', 13),
(207, 'Rangel', 'municipio', 13),
(208, 'Sucre', 'municipio', 13);

-- Insert Parroquias Mérida
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(209, 'Parroquia El Vigía', 'parroquia', 204),
(210, 'Parroquia La Azulita', 'parroquia', 204),
(211, 'Parroquia Mérida', 'parroquia', 205),
(212, 'Parroquia Jacinto Plaza', 'parroquia', 205),
(213, 'Parroquia Timotes', 'parroquia', 206),
(214, 'Parroquia Mesa de Bolívar', 'parroquia', 206),
(215, 'Parroquia Mucuchíes', 'parroquia', 207),
(216, 'Parroquia Mucurubá', 'parroquia', 207),
(217, 'Parroquia Lagunillas', 'parroquia', 208),
(218, 'Parroquia Chiguará', 'parroquia', 208);

-- Insert Municipios Miranda
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(219, 'Baruta', 'municipio', 14),
(220, 'Chacao', 'municipio', 14),
(221, 'Guaicaipuro', 'municipio', 14),
(222, 'Sucre', 'municipio', 14),
(223, 'Zamora', 'municipio', 14);

-- Insert Parroquias Miranda
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(224, 'Parroquia Baruta', 'parroquia', 219),
(225, 'Parroquia El Cafetal', 'parroquia', 219),
(226, 'Parroquia Chacao', 'parroquia', 220),
(227, 'Parroquia Municipio Chacao', 'parroquia', 220),
(228, 'Parroquia Los Teques', 'parroquia', 221),
(229, 'Parroquia San Pedro', 'parroquia', 221),
(230, 'Parroquia Petare', 'parroquia', 222),
(231, 'Parroquia Caucagüita', 'parroquia', 222),
(232, 'Parroquia Guatire', 'parroquia', 223),
(233, 'Parroquia Bolívar', 'parroquia', 223);

-- Insert Municipios Monagas
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(234, 'Acosta', 'municipio', 15),
(235, 'Caripe', 'municipio', 15),
(236, 'Maturín', 'municipio', 15),
(237, 'Piar', 'municipio', 15),
(238, 'Sotillo', 'municipio', 15);

-- Insert Parroquias Monagas
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(239, 'Parroquia San Antonio de Capayacuar', 'parroquia', 234),
(240, 'Parroquia El Guácharo', 'parroquia', 234),
(241, 'Parroquia Caripe', 'parroquia', 235),
(242, 'Parroquia Teresén', 'parroquia', 235),
(243, 'Parroquia Maturín', 'parroquia', 236),
(244, 'Parroquia Alto de Los Godos', 'parroquia', 236),
(245, 'Parroquia Aragua de Maturín', 'parroquia', 237),
(246, 'Parroquia Chaguaramal', 'parroquia', 237),
(247, 'Parroquia Barrancas', 'parroquia', 238),
(248, 'Parroquia Los Barrancos de Fajardo', 'parroquia', 238);

-- Insert Municipios Nueva Esparta
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(249, 'Antolín del Campo', 'municipio', 16),
(250, 'Arismendi', 'municipio', 16),
(251, 'Díaz', 'municipio', 16),
(252, 'Gómez', 'municipio', 16),
(253, 'Marcano', 'municipio', 16);

-- Insert Parroquias Nueva Esparta
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(254, 'Parroquia La Plaza de Paraguachí', 'parroquia', 249),
(255, 'Parroquia Santa Ana', 'parroquia', 249),
(256, 'Parroquia La Asunción', 'parroquia', 250),
(257, 'Parroquia San Juan Bautista', 'parroquia', 250),
(258, 'Parroquia Porlamar', 'parroquia', 251),
(259, 'Parroquia San Francisco', 'parroquia', 251),
(260, 'Parroquia Santa Ana del Norte', 'parroquia', 252),
(261, 'Parroquia El Valle del Espíritu Santo', 'parroquia', 252),
(262, 'Parroquia Juan Griego', 'parroquia', 253),
(263, 'Parroquia San Juan', 'parroquia', 253);

-- Insert Municipios Portuguesa
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(264, 'Araure', 'municipio', 17),
(265, 'Esteller', 'municipio', 17),
(266, 'Guanare', 'municipio', 17),
(267, 'Ospino', 'municipio', 17),
(268, 'Páez', 'municipio', 17);

-- Insert Parroquias Portuguesa
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(269, 'Parroquia Araure', 'parroquia', 264),
(270, 'Parroquia Río Acarigua', 'parroquia', 264),
(271, 'Parroquia Píritu', 'parroquia', 265),
(272, 'Parroquia Uveral', 'parroquia', 265),
(273, 'Parroquia Guanare', 'parroquia', 266),
(274, 'Parroquia Córdoba', 'parroquia', 266),
(275, 'Parroquia Ospino', 'parroquia', 267),
(276, 'Parroquia La Estación', 'parroquia', 267),
(277, 'Parroquia Acarigua', 'parroquia', 268),
(278, 'Parroquia Payara', 'parroquia', 268);

-- Insert Municipios Sucre
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(279, 'Andrés Eloy Blanco', 'municipio', 18),
(280, 'Bermúdez', 'municipio', 18),
(281, 'Libertador', 'municipio', 18),
(282, 'Mariño', 'municipio', 18),
(283, 'Valdez', 'municipio', 18);

-- Insert Parroquias Sucre
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(284, 'Parroquia Casanay', 'parroquia', 279),
(285, 'Parroquia San Juan de Unare', 'parroquia', 279),
(286, 'Parroquia Carúpano', 'parroquia', 280),
(287, 'Parroquia Santa Catalina', 'parroquia', 280),
(288, 'Parroquia Tunapuy', 'parroquia', 281),
(289, 'Parroquia Campo Elías', 'parroquia', 281),
(290, 'Parroquia Irapa', 'parroquia', 282),
(291, 'Parroquia Campo Claro', 'parroquia', 282),
(292, 'Parroquia Güiria', 'parroquia', 283),
(293, 'Parroquia Cristóbal Colón', 'parroquia', 283);

-- Insert Municipios Táchira
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(294, 'Andrés Bello', 'municipio', 19),
(295, 'Cárdenas', 'municipio', 19),
(296, 'Guásimos', 'municipio', 19),
(297, 'San Cristóbal', 'municipio', 19),
(298, 'Seboruco', 'municipio', 19);

-- Insert Parroquias Táchira
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(299, 'Parroquia Cordero', 'parroquia', 294),
(300, 'Parroquia Las Mesas', 'parroquia', 294),
(301, 'Parroquia Táriba', 'parroquia', 295),
(302, 'Parroquia San José de Bolívar', 'parroquia', 295),
(303, 'Parroquia Palmira', 'parroquia', 296),
(304, 'Parroquia Independencia', 'parroquia', 296),
(305, 'Parroquia San Cristóbal', 'parroquia', 297),
(306, 'Parroquia La Concordia', 'parroquia', 297),
(307, 'Parroquia Seboruco', 'parroquia', 298),
(308, 'Parroquia Morrón', 'parroquia', 298);

-- Insert Municipios Trujillo
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(309, 'Boconó', 'municipio', 20),
(310, 'La Ceiba', 'municipio', 20),
(311, 'Miranda', 'municipio', 20),
(312, 'Pampán', 'municipio', 20),
(313, 'Valera', 'municipio', 20);

-- Insert Parroquias Trujillo
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(314, 'Parroquia Boconó', 'parroquia', 309),
(315, 'Parroquia El Carmen', 'parroquia', 309),
(316, 'Parroquia Santa Apolonia', 'parroquia', 310),
(317, 'Parroquia La Ceiba', 'parroquia', 310),
(318, 'Parroquia El Dividive', 'parroquia', 311),
(319, 'Parroquia Agua Santa', 'parroquia', 311),
(320, 'Parroquia Pampán', 'parroquia', 312),
(321, 'Parroquia Flor de Patria', 'parroquia', 312),
(322, 'Parroquia Valera', 'parroquia', 313),
(323, 'Parroquia Mendoza', 'parroquia', 313);

-- Insert Municipios Vargas
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(324, 'Vargas', 'municipio', 21),
(325, 'Capital Vargas', 'municipio', 21),
(326, 'Carayaca', 'municipio', 21),
(327, 'Macuto', 'municipio', 21),
(328, 'Catia La Mar', 'municipio', 21);

-- Insert Parroquias Vargas
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(329, 'Parroquia Caraballeda', 'parroquia', 324),
(330, 'Parroquia Maiquetía', 'parroquia', 324),
(331, 'Parroquia La Guaira', 'parroquia', 325),
(332, 'Parroquia Catia La Mar', 'parroquia', 325),
(333, 'Parroquia Carayaca', 'parroquia', 326),
(334, 'Parroquia El Junko', 'parroquia', 326),
(335, 'Parroquia Macuto', 'parroquia', 327),
(336, 'Parroquia Naiguatá', 'parroquia', 327),
(337, 'Parroquia Carlos Soublette', 'parroquia', 328),
(338, 'Parroquia Raúl Leoni', 'parroquia', 328);

-- Insert Municipios Yaracuy
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(339, 'Arístides Bastidas', 'municipio', 22),
(340, 'Bolívar', 'municipio', 22),
(341, 'Bruzual', 'municipio', 22),
(342, 'Nirgua', 'municipio', 22),
(343, 'San Felipe', 'municipio', 22);

-- Insert Parroquias Yaracuy
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(344, 'Parroquia San Pablo', 'parroquia', 339),
(345, 'Parroquia San Javier', 'parroquia', 339),
(346, 'Parroquia Aroa', 'parroquia', 340),
(347, 'Parroquia Chivacoa', 'parroquia', 340),
(348, 'Parroquia Campo Elías', 'parroquia', 341),
(349, 'Parroquia Urachiche', 'parroquia', 341),
(350, 'Parroquia Nirgua', 'parroquia', 342),
(351, 'Parroquia Salom', 'parroquia', 342),
(352, 'Parroquia San Felipe', 'parroquia', 343),
(353, 'Parroquia Albarico', 'parroquia', 343);

-- Insert Municipios Zulia
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(354, 'Almirante Padilla', 'municipio', 23),
(355, 'Cabimas', 'municipio', 23),
(356, 'Lagunillas', 'municipio', 23),
(357, 'Maracaibo', 'municipio', 23),
(358, 'San Francisco', 'municipio', 23);

-- Insert Parroquias Zulia
INSERT INTO Lugar (id_lugar, nombre, tipo, lugar_relacion_id) VALUES
(359, 'Parroquia El Toro', 'parroquia', 354),
(360, 'Parroquia San Timoteo', 'parroquia', 354),
(361, 'Parroquia Cabimas', 'parroquia', 355),
(362, 'Parroquia Ambrosio', 'parroquia', 355),
(363, 'Parroquia Ciudad Ojeda', 'parroquia', 356),
(364, 'Parroquia Alonso de Ojeda', 'parroquia', 356),
(365, 'Parroquia Maracaibo', 'parroquia', 357),
(366, 'Parroquia Idelfonso Vásquez', 'parroquia', 357),
(367, 'Parroquia San Francisco', 'parroquia', 358),
(368, 'Parroquia El Bajo', 'parroquia', 358); 