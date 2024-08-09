CREATE TABLE `tbb_productos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(150) NOT NULL,
  `Marca` varchar(100) NOT NULL,
  `Codigo_Barras` varchar(100) DEFAULT NULL,
  `Descripcion` text,
  `Presentacion` varchar(50) NOT NULL,
  `Precio_Actual` decimal(6,2) NOT NULL,
  `Fotografia` varchar(50) DEFAULT NULL,
  `Estatus` bit(1) DEFAULT b'1',
  `Fecha_Registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



CREATE TABLE `tbd_detalles_productos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Producto_ID` int unsigned NOT NULL,
  `Descripcion` text,
  `Valor` varchar(10) DEFAULT NULL,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_productos_4_idx` (`Producto_ID`),
  CONSTRAINT `producto_id_3` FOREIGN KEY (`Producto_ID`) REFERENCES `tbb_productos` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
