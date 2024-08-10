-- Tabla asignada #1: Rutinas
CREATE TABLE `tbd_rutinas` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) NOT NULL,
  `Programa_Saludable_ID` int unsigned NOT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `Tiempo_Aproximado` time DEFAULT NULL,
  `Estatus` enum('Concluido','Actual','Suspendida') DEFAULT NULL,
  `Resultados_Esperados` text,
  PRIMARY KEY (`ID`),
  KEY `fk_programa_saludable_idx` (`Programa_Saludable_ID`),
  CONSTRAINT `fk_programa_saludable_1` FOREIGN KEY (`Programa_Saludable_ID`) REFERENCES `tbd_programas_saludables` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabla asignada #2: Ejercicios - Rutinas
CREATE TABLE `tbd_ejercicios_rutinas` (
  `Ejercicio_ID` int unsigned NOT NULL,
  `Rutina_ID` int unsigned NOT NULL,
  `Cantidad` varchar(10) NOT NULL,
  `Tipo` enum('Repeticiones','Tiempo') NOT NULL,
  `Observaciones` text,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`Ejercicio_ID`,`Rutina_ID`),
  KEY `fk_rutinas_1_idx` (`Rutina_ID`),
  CONSTRAINT `fk_ejercicios_1` FOREIGN KEY (`Ejercicio_ID`) REFERENCES `tbc_ejercicios` (`ID`),
  CONSTRAINT `fk_rutinas_1` FOREIGN KEY (`Rutina_ID`) REFERENCES `tbd_rutinas` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;