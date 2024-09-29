DROP DATABASE `jetlag_travel_agency`;
CREATE DATABASE  IF NOT EXISTS `jetlag_travel_agency`;
USE `jetlag_travel_agency`;

DROP TABLE IF EXISTS `cliente`;
CREATE TABLE `cliente` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `dni` varchar(50) DEFAULT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `mail` varchar(50) DEFAULT NULL,
  `telefono` varchar (20) DEFAULT NULL,
  `creado` DATE DEFAULT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `dni` (`dni`)
);

DROP TABLE IF EXISTS `sucursal`;
CREATE TABLE `sucursal` (
  `id_sucursal` int NOT NULL AUTO_INCREMENT,
  `nombre_sucursal` varchar(100) DEFAULT NULL,
  `telefono_sucursal` varchar(20) DEFAULT NULL,
  `direccion_sucursal` varchar(255) DEFAULT NULL,
  `mail` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_sucursal`)
);

-- AGREGO TABLA VENDEDOR 
DROP TABLE IF EXISTS `vendedor`;

CREATE TABLE `vendedor` (
  `nro_legajo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `mail` varchar(50) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `cargo` varchar(50) DEFAULT NULL,
  `id_sucursal` int NOT NULL,
  PRIMARY KEY (`nro_legajo`),
  FOREIGN KEY (`id_sucursal`) REFERENCES `sucursal` (`id_sucursal`)
);

-- AGREGO TABLA PROVEEDOR 

DROP TABLE IF EXISTS `proveedor`;
CREATE TABLE `proveedor` (
  `id_proveedor` int NOT NULL AUTO_INCREMENT,
  `cuit` varchar(20) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `mail` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_proveedor`)
) AUTO_INCREMENT = 5000;

-- CREO TABLA RESERVA 
DROP TABLE IF EXISTS `reserva`;
CREATE TABLE `reserva` (
  `id_reserva` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int DEFAULT NULL,
  `id_pasaje` int DEFAULT NULL,
  `monto_total` decimal(10,2) DEFAULT NULL,
  `monto_abonado` decimal(10,2) DEFAULT '0.00',
  `fecha_reserva` date DEFAULT NULL,
  `tipo_reserva` varchar(50) DEFAULT NULL,
  `estado` enum('Pendiente de Pago','Seña Pagada','Total Pagado','Confirmado','Cancelado') NOT NULL,
  PRIMARY KEY (`id_reserva`),
  KEY `id_cliente` (`id_cliente`),
  CONSTRAINT `reserva_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`)
);

-- INSERTO TABLA VENTAS 
DROP TABLE IF EXISTS `venta`;
CREATE TABLE `venta` (
  `id_venta` int NOT NULL AUTO_INCREMENT,
  `id_reserva` int DEFAULT NULL,
  `nro_legajo` int DEFAULT NULL,
  `monto_pago` decimal(10,2) DEFAULT NULL,
  `fecha_pago` datetime DEFAULT NULL,
  `forma_pago` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_venta`),
  KEY `id_reserva` (`id_reserva`),
  KEY `fk_nro_legajo` (`nro_legajo`),
  CONSTRAINT `venta_ibfk_1` FOREIGN KEY (`id_reserva`) REFERENCES `reserva` (`id_reserva`)
);ALTER TABLE venta AUTO_INCREMENT = 36;TRUNCATE TABLE venta;

-- CREO TABAL PASAJES 
DROP TABLE IF EXISTS `pasaje`;
CREATE TABLE `pasaje` (
  `id_pasaje` int NOT NULL AUTO_INCREMENT,
  `id_venta` int DEFAULT NULL,
  `id_reserva` int DEFAULT NULL,
  `id_proveedor` int DEFAULT NULL,
  `origen` varchar(100) DEFAULT NULL,
  `destino` varchar(100) DEFAULT NULL,
  `fecha_ida` datetime DEFAULT NULL,
  `fecha_vuelta` datetime DEFAULT NULL,
  `nro_ticket` varchar(50) DEFAULT NULL,
  `cantidad_ticket` int DEFAULT NULL,
  PRIMARY KEY (`id_pasaje`),
  KEY `id_venta` (`id_venta`),
  KEY `id_reserva` (`id_reserva`),
  KEY `id_proveedor` (`id_proveedor`),
  CONSTRAINT `pasaje_ibfk_1` FOREIGN KEY (`id_venta`) REFERENCES `venta` (`id_venta`)
);

-- INSERTO TABLA COMPRA 

DROP TABLE IF EXISTS `compra`;
CREATE TABLE `compra` (
  `id_compra` int NOT NULL AUTO_INCREMENT,
  `id_pasaje` int DEFAULT NULL,
  `fecha_compra` date DEFAULT NULL,
  `tipo_compra` varchar(50) DEFAULT NULL,
  `id_proveedor` int DEFAULT NULL,
  `nro_legajo` int DEFAULT NULL,
  PRIMARY KEY (`id_compra`),
  KEY `fk_id_pasaje` (`id_pasaje`),
  KEY `fk_id_proveedor` (`id_proveedor`),
  KEY `fk_nro_legajo` (`nro_legajo`),
  CONSTRAINT `fk_id_pasaje` FOREIGN KEY (`id_pasaje`) REFERENCES `pasaje` (`id_pasaje`),
  CONSTRAINT `fk_id_proveedor` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedor` (`id_proveedor`),
  CONSTRAINT `fk_nro_legajo` FOREIGN KEY (`nro_legajo`) REFERENCES `vendedor` (`nro_legajo`)  
);

DROP TABLE IF EXISTS `compra`;
CREATE TABLE `compra` (
  `id_compra` int NOT NULL AUTO_INCREMENT,
  `id_pasaje` int DEFAULT NULL,
  `fecha_compra` date DEFAULT NULL,
  `tipo_compra` varchar(50) DEFAULT NULL,
  `id_proveedor` int DEFAULT NULL,
  `nro_legajo` int DEFAULT NULL,
  PRIMARY KEY (`id_compra`),
  KEY `fk_id_pasaje` (`id_pasaje`),
  KEY `fk_id_proveedor` (`id_proveedor`),
  KEY `fk_nro_legajo` (`nro_legajo`),
  CONSTRAINT `fk_id_pasaje` FOREIGN KEY (`id_pasaje`) REFERENCES `pasaje` (`id_pasaje`),
  CONSTRAINT `fk_id_proveedor` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedor` (`id_proveedor`),
  CONSTRAINT `fk_nro_legajo` FOREIGN KEY (`nro_legajo`) REFERENCES `vendedor` (`nro_legajo`)  
);

