CREATE DATABASE  IF NOT EXISTS `gimnasio_9b_idgs` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `gimnasio_9b_idgs`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: gimnasio_9b_idgs
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tbb_areas`
--

DROP TABLE IF EXISTS `tbb_areas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_areas` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  `Descripcion` text,
  `Sucursal_ID` int unsigned NOT NULL,
  `Estatus` bit(1) DEFAULT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_sucursales_1_idx` (`Sucursal_ID`),
  CONSTRAINT `fk_sucursales_1` FOREIGN KEY (`Sucursal_ID`) REFERENCES `tbc_sucursales` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbb_areas`
--

LOCK TABLES `tbb_areas` WRITE;
/*!40000 ALTER TABLE `tbb_areas` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbb_areas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbb_areas_AFTER_INSERT` AFTER INSERT ON `tbb_areas` FOR EACH ROW BEGIN
	
    DECLARE v_estatus varchar(20) default 'Activo';
    
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not NEW.estatus then
		set v_estatus = "Inactivo";
	end if;
    
	
	-- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbb_areas",
        CONCAT_WS(" ","Se ha insertado una nueva area con los siguientes datos: ",
        "NOMBRE = ", new.Nombre,
        "DESCRIPCION = ", new.Descripcion,
        "SUCURSAL = ", new.Sucursal_ID,
        "ESTATUS = ", v_estatus,
		"FECHA REGISTRO = ", new.fecha_registro,
        "FECHA ACTUALIZACION = ", new.fecha_actualizacion), 
        DEFAULT,
		DEFAULT  
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbb_areas_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_areas` FOR EACH ROW BEGIN
set new.Fecha_Actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbb_areas_AFTER_UPDATE` AFTER UPDATE ON `tbb_areas` FOR EACH ROW BEGIN
	
    declare v_estatus_old varchar(20) default 'Activo';
    declare v_estatus_new varchar(20) default 'Activo';
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not old.estatus then
		set v_estatus_old = "Inactivo";
	end if;
    if not NEW.estatus then
		set v_estatus_new = "Inactivo";
	end if;
    
	insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Update' ,
		'tbb_areas',
		concat_ws(" ","Se ha modificado una area existente con los siguientes datos: ",
		"NOMBRE = ", old.Nombre, ' - ', new.Nombre, 
        "DESCRIPCION = ", old.Descripcion, ' - ', new.Descripcion,
        "SUCURSAL = ", old.Sucursal_ID, ' - ', new.Sucursal_ID,
        "ESTATUS = ", v_estatus_old, ' - ', v_estatus_new),
	DEFAULT,
	DEFAULT  
);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbb_areas_BEFORE_DELETE` BEFORE DELETE ON `tbb_areas` FOR EACH ROW BEGIN
declare v_estatus varchar(20) default 'Activo';
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if  not old.estatus then
		set v_estatus = "Inactivo";
	end if;
    
	insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Delete' ,
		'tbb_areas',
		CONCAT_WS(" ","Se ha eliminado una area con los siguientes datos: ",
        "NOMBRE = ", old.Nombre, 
        "DESCRIPCION = ", old.Descripcion,
        "SUCURSAL = ", old.Sucursal_ID,
        "ESTATUS = ", v_estatus),
	DEFAULT,
	DEFAULT );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbb_empleados`
--

DROP TABLE IF EXISTS `tbb_empleados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_empleados` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Area_ID` int unsigned NOT NULL,
  `Fecha_Contratacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Puesto_ID` int unsigned NOT NULL,
  `Persona_ID` int unsigned NOT NULL,
  `Numero_Empleado` varchar(45) NOT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `Estatus` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`),
  KEY `Area_ID_idx` (`Area_ID`),
  KEY `Puesto_ID_idx` (`Puesto_ID`),
  KEY `Persona_ID_idx` (`Persona_ID`),
  CONSTRAINT `Area_ID` FOREIGN KEY (`Area_ID`) REFERENCES `tbb_areas` (`ID`),
  CONSTRAINT `Persona_ID_2` FOREIGN KEY (`Persona_ID`) REFERENCES `tbb_personas` (`ID`),
  CONSTRAINT `Puesto_ID` FOREIGN KEY (`Puesto_ID`) REFERENCES `tbc_puestos` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbb_empleados`
--

LOCK TABLES `tbb_empleados` WRITE;
/*!40000 ALTER TABLE `tbb_empleados` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbb_empleados` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbb_empleados_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_empleados` FOR EACH ROW BEGIN
	set new.Fecha_Actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbb_instalaciones`
--

DROP TABLE IF EXISTS `tbb_instalaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_instalaciones` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Descripcion` text NOT NULL,
  `Tipo` varchar(50) NOT NULL,
  `Fecha_Registro` datetime NOT NULL,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Fecha_Actualizacion` datetime NOT NULL,
  `Calificacion` enum('Exelente servicio','Buen servicio','Servicio Regular','Puede mejorar el servicio') NOT NULL,
  `ID_Sucursal` int NOT NULL,
  `Horario_Disponibilidad` text NOT NULL,
  `Servicio` varchar(200) NOT NULL,
  `Observaciones` text NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbb_instalaciones`
--

LOCK TABLES `tbb_instalaciones` WRITE;
/*!40000 ALTER TABLE `tbb_instalaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbb_instalaciones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`valencia`@`%`*/ /*!50003 TRIGGER `tbd_instalacion_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_instalaciones` FOR EACH ROW BEGIN
	set new.Fecha_Actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbb_instructores`
--

DROP TABLE IF EXISTS `tbb_instructores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_instructores` (
  `ID` int NOT NULL,
  `Total_Años_Experiencia` int NOT NULL,
  `Especialidad` varchar(100) DEFAULT NULL,
  `Total_Clientes_Atendidos` int unsigned NOT NULL DEFAULT '0',
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  `Calificacion` int unsigned DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbb_instructores`
--

LOCK TABLES `tbb_instructores` WRITE;
/*!40000 ALTER TABLE `tbb_instructores` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbb_instructores` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`jorge`@`%`*/ /*!50003 TRIGGER `tbb_instructores_AFTER_INSERT` AFTER INSERT ON `tbb_instructores` FOR EACH ROW BEGIN
DECLARE v_estatus varchar(20) default 'Activo';

if not new.estatus then
set v_estatus = 'Inactivo';
end if;

insert into tbi_bitacora values
(default,
current_user(),
'Create', 
'tbb_instructores',
concat_ws(' ', 'Se ha creado un nuevo instructor con los siguientes datos:',
'ID: ', new.id, 
'TOTAL_AÑOS_EXPERIENCIA: ', new.total_años_experiencia, 
'ESPECIALIDAD: ',new.especialidad,
'TOTAL_CLIENTES_ATENDIDOS: ', new.total_clientes_atendidos, 
'ESTATUS: ', new.estatus, 
'FECHA_REGISTRO: ',new.fecha_registro,
'FECHA_ACTUALIZACION: ', new.fecha_actualizacion,
'CALIFICACION: ', new.calificacion,
'ESTATUS: ',v_estatus ), default, default
);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`jorge`@`%`*/ /*!50003 TRIGGER `tbb_instructores_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_instructores` FOR EACH ROW BEGIN
SET NEW.Fecha_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`jorge`@`%`*/ /*!50003 TRIGGER `tbb_instructores_AFTER_UPDATE` AFTER UPDATE ON `tbb_instructores` FOR EACH ROW BEGIN
DECLARE v_estatus_old varchar(20) default 'Activo';
declare v_estatus_new varchar(20) default 'Activo';

if not old.estatus then
set v_estatus_old = 'Inactivo';
end if;

if not new.estatus then
set v_estatus_new = 'Inactivo';
end if;


insert into tbi_bitacora values
(default,
current_user(),
'Update', 
'tbb_instructores',
concat_ws(' ', 'Se ha editado el nuevo usuario con los siguientes datos:',
'ID: ', old.id, 
'TOTAL_AÑOS_EXPERIENCIA: ', old.total_años_experiencia, 
'ESPECIALIDAD: ',old.especialidad,
'TOTAL_CLIENTES_ATENDIDOS: ', old.total_clientes_atendidos, 
'ESTATUS: ', old.estatus, 
'FECHA_REGISTRO: ',old.fecha_registro,
'FECHA_ACTUALIZACION: ', old.fecha_actualizacion,
'CALIFICACION: ', old.calificacion,
'ESTATUS: ',v_estatus_old, '-',  v_estatus_new  ), default, default
);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`jorge`@`%`*/ /*!50003 TRIGGER `tbb_instructores_BEFORE_DELETE` BEFORE DELETE ON `tbb_instructores` FOR EACH ROW BEGIN
DECLARE v_estatus varchar(20) default 'Activo';

if NOT OLD.estatus then
set v_estatus = 'Inactivo';
end if;


insert into tbi_bitacora values
(default,
current_user(),
'Delete', 
'tbb_instructores',
concat_ws(' ', 'Se ha eliminado el usuario con los siguientes datos:',
 
'ID: ', old.id, 
'TOTAL_AÑOS_EXPERIENCIA: ', old.total_años_experiencia, 
'ESPECIALIDAD: ',old.especialidad,
'TOTAL_CLIENTES_ATENDIDOS: ', old.total_clientes_atendidos, 
'ESTATUS: ', old.estatus, 
'FECHA_REGISTRO: ',old.fecha_registro,
'FECHA_ACTUALIZACION: ', old.fecha_actualizacion,
'CALIFICACION: ', old.calificacion,
'ESTATUS: ',v_estatus ), default, default
);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbb_mantenimientos`
--

DROP TABLE IF EXISTS `tbb_mantenimientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_mantenimientos` (
  `id_mantenimiento` int NOT NULL AUTO_INCREMENT,
  `Equipo` varchar(50) NOT NULL,
  `Fecha_mantenimiento` date NOT NULL,
  `Descripcion` text,
  `Responsable` varchar(50) NOT NULL,
  `Costo` decimal(10,2) NOT NULL,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Fecha_actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id_mantenimiento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbb_mantenimientos`
--

LOCK TABLES `tbb_mantenimientos` WRITE;
/*!40000 ALTER TABLE `tbb_mantenimientos` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbb_mantenimientos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zahid`@`%`*/ /*!50003 TRIGGER `tbb_mantenimientos_AFTER_INSERT` AFTER INSERT ON `tbb_mantenimientos` FOR EACH ROW BEGIN
declare v_estatus varchar(20) default 'Activo';
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not NEW.estatus then
		set v_estatus = "Inactivo";
	end if;
    
	-- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbb_mantenimientos",
        CONCAT_WS(" ","Se ha insertado un nuevo equipo ",
        "EQUIPO = ", new.Equipo,
		"FECHA MANTENIMIENTO = ", new.fecha_mantenimiento,
		"DESCRIPCION = ", NEW.Descripcion, 
		"RESPONSABLE = ", NEW.Responsable,
		"COSTO = ", NEW.Costo, 
        "ESTATUS = ", v_estatus),
        DEFAULT,
		DEFAULT  
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zahid`@`%`*/ /*!50003 TRIGGER `tbb_mantenimientos_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_mantenimientos` FOR EACH ROW BEGIN
set new.Fecha_Actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zahid`@`%`*/ /*!50003 TRIGGER `tbb_mantenimientos_AFTER_UPDATE` AFTER UPDATE ON `tbb_mantenimientos` FOR EACH ROW BEGIN
declare v_estatus_old varchar(20) default 'Activo';
    declare v_estatus_new varchar(20) default 'Activo';
    
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not old.estatus then
		set v_estatus_old = "Inactivo";
	end if;
    if not NEW.estatus then
		set v_estatus_new = "Inactivo";
	end if;
    
    insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Update' ,
		'tbb_mantenimientos',
		concat_ws(" ","Se ha modificado un equipo",
        "EQUIPO = ", old.Equipo, ' - ', new.Equipo,
        " DESCRIPCION =", old.Descripcion, ' - ', new.Descripcion,
        " RESPONSABLE =", old.Responsable, ' - ', new.Responsable,
        "ESTATUS = ", v_estatus_old, ' - ', v_estatus_new),
	DEFAULT,
	DEFAULT );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`zahid`@`%`*/ /*!50003 TRIGGER `tbb_mantenimientos_AFTER_DELETE` AFTER DELETE ON `tbb_mantenimientos` FOR EACH ROW BEGIN
declare v_estatus varchar(20) default 'Activo';
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if  not old.estatus then
		set v_estatus = "Inactivo";
	end if;
    
	insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Delete' ,
		"tbb_mantenimientos",
        CONCAT_WS(" ","Se ha eliminado un equipo: ",
        "EQUIPO = ", old.Equipo,
		"DESCRIPCION = ", old.Descripcion, 
        "RESPONSABLE = ", old.Responsable,
        "ESTATUS = ", v_estatus),
        DEFAULT,
		DEFAULT   );

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbb_miembros`
--

DROP TABLE IF EXISTS `tbb_miembros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_miembros` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Membresia_ID` int unsigned NOT NULL,
  `Usuario_ID` int unsigned NOT NULL,
  `Tipo` enum('Frecuente','Ocasional','Nuevo','Esporadico','Una sola visita') NOT NULL DEFAULT 'Nuevo',
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Antiguedad` varchar(80) NOT NULL,
  `Fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbb_miembros`
--

LOCK TABLES `tbb_miembros` WRITE;
/*!40000 ALTER TABLE `tbb_miembros` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbb_miembros` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`max`@`%`*/ /*!50003 TRIGGER `tb_miembros_AFTER_INSERT` AFTER INSERT ON `tbb_miembros` FOR EACH ROW BEGIN
	DECLARE v_estatus varchar(20) default 'Activo';
    
    IF not new.estatus = b'1' then
        set v_estatus = "Inactiva";
    end if;

    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbb_miembros",
        CONCAT_WS(" ","Se ha insertado un nuevo miembro con los siguientes datos: ",
        "ID = ", NEW.id,
        "MEMBRESIA_ID = ", NEW.membresia_id,
        "USUARIO_ID = ", new.usuario_id,
        "TIPO = ", NEW.tipo,
        "ANTIGUEDAD = ", new.antiguedad,
        "FECHA_REGISTRO = ", new.fecha_registro,
        "FECHA_ACTUALIZACION = ", new.fecha_actualizacion,
        "ESTATUS = ", v_estatus),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`max`@`%`*/ /*!50003 TRIGGER `tb_miembros_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_miembros` FOR EACH ROW BEGIN
	set new.fecha_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`max`@`%`*/ /*!50003 TRIGGER `tb_miembros_AFTER_UPDATE` AFTER UPDATE ON `tbb_miembros` FOR EACH ROW BEGIN
	DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
    DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Activo'; 
    
    IF not NEW.estatus then
        set v_estatus_old = "Inactiva";
    end if;
    
    IF  not new.estatus then
        set v_estatus_new = "Inactiva";
    end if;
    
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Update",
        "tbb_miembros",
        CONCAT_WS(" ","Se ha actualizado un miembro con los datos: ",
        "ID = ",old.id,' - ', NEW.id,
        "MEMBRESIA_ID = ",old.membresia_id,' - ', NEW.membresia_id,
        "USUARIO_ID = ",old.usuario_id,' - ', new.usuario_id,
        "TIPO = ",old.tipo, ' - ',NEW.tipo,
        "ANTIGUEDAD = ",old.antiguedad, ' - ',new.antiguedad,
        "FECHA_REGISTRO = ",old.fecha_registro,' - ', new.fecha_registro,
        "FECHA_ACTUALIZACION = ",old.fecha_actualizacion,' - ', new.fecha_actualizacion,
        "ESTATUS = ", v_estatus_old, ' - ', v_estatus_new),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`max`@`%`*/ /*!50003 TRIGGER `tb_miembros_BEFORE_DELETE` BEFORE DELETE ON `tbb_miembros` FOR EACH ROW BEGIN
	DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    IF  not OLD.estatus then
        set v_estatus = "Inactiva";
    end if;
    
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Delete",
        "tbb_miembros",
        CONCAT_WS(" ","Se ha eliminado un miembro con los siguientes datos: ",
        "ID = ",old.id,
        "MEMBRESIA_ID = ",old.membresia_id,
        "USUARIO_ID = ",old.usuario_id,
        "TIPO = ",old.tipo, 
        "ANTIGUEDAD = ",old.antiguedad,
        "FECHA_REGISTRO = ",old.fecha_registro,
        "FECHA_ACTUALIZACION = ",old.fecha_actualizacion,
        "ESTATUS = ", v_estatus),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbb_pedidos`
--

DROP TABLE IF EXISTS `tbb_pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_pedidos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Producto_id` int unsigned NOT NULL,
  `Tipo` enum('Promoción',' Descuento','Precio tienda') NOT NULL DEFAULT 'Precio tienda',
  `Fecha_Registro` datetime NOT NULL,
  `Fecha_Actualizacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `Estatus` bit(1) DEFAULT b'1',
  `Total_Productos` int NOT NULL,
  `Costo_total` double NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Producto_id_idx` (`Producto_id`),
  CONSTRAINT `Producto_id_1` FOREIGN KEY (`Producto_id`) REFERENCES `tbb_productos` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbb_pedidos`
--

LOCK TABLES `tbb_pedidos` WRITE;
/*!40000 ALTER TABLE `tbb_pedidos` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbb_pedidos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`edgar`@`%`*/ /*!50003 TRIGGER `tbd_pedido_AFTER_INSERT` AFTER INSERT ON `tbb_pedidos` FOR EACH ROW BEGIN
	
    DECLARE v_estatus varchar(20) default 'Activo';
	DECLARE v_nombre_producto varchar(60) default null;
    
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not NEW.estatus then
		set v_estatus = "Inactivo";
	end if;
    
    if new.producto_id is not null then
        -- En caso de tener el id del usuario debemos recuperar su nombre
        set v_nombre_producto = (SELECT CONCAT_WS(" ", p.nombre, p.marca, p.descripcion) FROM tbb_productos p WHERE id = NEW.producto_id);
    else
        SET v_nombre_producto = "Sin producto asignado";
    end if;
    
    
    
	-- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbb_pedido",
        CONCAT_WS(" ","Se ha insertado un nuevo pedido con los siguientes datos: ",
        "ID PRODUCTOS = ", v_nombre_producto,
        "TIPO = ", new.Tipo,
		"FECHA REGISTRO = ", new.fecha_registro,
        "FECHA ACTUALIZACION = ", new.fecha_actualizacion, 
        "ESTATUS = ", v_estatus,
        "TOTAL PRODUCTOS = ", new.Total_Productos,
        "COSTO TOTAL = ", new.Costo_Total),
        DEFAULT,
		DEFAULT  
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`edgar`@`%`*/ /*!50003 TRIGGER `tbd_pedido_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_pedidos` FOR EACH ROW BEGIN
	set new.Fecha_Actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`edgar`@`%`*/ /*!50003 TRIGGER `tbd_pedido_AFTER_UPDATE` AFTER UPDATE ON `tbb_pedidos` FOR EACH ROW BEGIN
	
    declare v_estatus_old varchar(20) default 'Activo';
    declare v_estatus_new varchar(20) default 'Activo';
    DECLARE v_producto_old varchar(60) default null;
    DECLARE v_producto_new varchar(60) default null;
    
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not old.estatus then
		set v_estatus_old = "Inactivo";
	end if;
    if not NEW.estatus then
		set v_estatus_new = "Inactivo";
	end if;
    
    IF NEW.producto_id IS NOT NULL THEN 
		-- En caso de tener el id del usuario
		SET v_producto_new = (SELECT CONCAT_WS(" ", p.nombre, p.marca, p.descripcion) FROM tbb_productos p WHERE id = NEW.producto_id);
    else
		SET v_producto_new = "Sin usuario asignado.";
    END IF;
    
    IF OLD.producto_id IS NOT NULL THEN 
		-- En caso de tener el id del usuario
		SET v_producto_old = (SELECT CONCAT_WS(" ", p.nombre, p.marca, p.descripcion) FROM tbb_productos p WHERE id = old.producto_id);
    else
		SET v_producto_old = "Sin usuario asignado.";
    END IF;
    
    
	insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Update' ,
		'tbb_pedido',
		concat_ws(" ","Se ha modificado un pedido de un producto existente con los siguientes datos: ",
        "ID PRODUCTO = ", v_producto_old, '-', v_producto_new,
        "TIPO = ", old.Tipo, ' - ', new.Tipo,
        "ESTATUS = ", v_estatus_old, ' - ', v_estatus_new,
        "TOTAL PRODUCTOS", old.Total_Productos, ' - ', new.Total_Productos,
        "COSTO TOTAL", old.Costo_Total, ' - ', new.Costo_Total),
	DEFAULT,
	DEFAULT  
);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`edgar`@`%`*/ /*!50003 TRIGGER `tbd_pedido_BEFORE_DELETE` BEFORE DELETE ON `tbb_pedidos` FOR EACH ROW BEGIN
declare v_estatus varchar(20) default 'Activo';
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if  not old.estatus then
		set v_estatus = "Inactivo";
	end if;
    
	insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Delete' ,
		'tbb_pedido',
		CONCAT_WS(" ","Se ha eliminado un pedido de un producto con los siguientes datos: ",
        "TIPO = ", old.Tipo, 
        "ESTATUS = ", v_estatus,
        "TOTAL PROCUTOS =", old.Total_Productos,
        "COSTO TOTAL =", old.Costo_Total),
	DEFAULT,
	DEFAULT );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbb_personas`
--

DROP TABLE IF EXISTS `tbb_personas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_personas` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Titulo_Cortesia` varchar(20) DEFAULT NULL,
  `Nombre` varchar(80) NOT NULL,
  `Primer_Apellido` varchar(80) NOT NULL,
  `Segundo_Apellido` varchar(80) NOT NULL,
  `Fecha_Nacimiento` date NOT NULL,
  `Fotografia` varchar(100) DEFAULT NULL,
  `Genero` enum('M','F','N/B') NOT NULL,
  `Tipo_Sangre` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
  `Estatus` bit(1) DEFAULT b'1',
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbb_personas`
--

LOCK TABLES `tbb_personas` WRITE;
/*!40000 ALTER TABLE `tbb_personas` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbb_personas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`daniel`@`%`*/ /*!50003 TRIGGER `tbb_personas_AFTER_INSERT` AFTER INSERT ON `tbb_personas` FOR EACH ROW BEGIN
	INSERT INTO tbi_bitacora VALUES(
		DEFAULT,
        USER(),
        "Create",
        "tbb_personas",
        CONCAT_WS(" ","Se ha insertado una nueva persona con el ID: ",NEW.ID, 
        "con los siguientes datos:  TITULO CORTESIA = ", NEW.titulo_cortesia,
        "NOMBRE=", NEW.nombre,
        "PRIMER APELLIDO = ", NEW.primer_apellido,
        "SEGUNDO APELLIDO = ", NEW.segundo_apellido,
        "FECHA NACIMIENTO = ",  NEW.fecha_nacimiento,
        "FOTOGRAFIA = ", NEW.fotografia, 
        "GENERO = ", NEW.genero, 
        "TIPO SANGRE = ", NEW.tipo_sangre,
        "ESTATUS = ", NEW.estatus,
        "FECHA REGISTRO = ",  NEW.fecha_registro,
        "FECHA ACTUALIZACIÓN = ",  NEW.fecha_actualizacion),
        NOW(),
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`daniel`@`%`*/ /*!50003 TRIGGER `tbb_personas_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_personas` FOR EACH ROW BEGIN
	set new.fecha_actualizacion=current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`daniel`@`%`*/ /*!50003 TRIGGER `tbb_personas_AFTER_UPDATE` AFTER UPDATE ON `tbb_personas` FOR EACH ROW BEGIN
INSERT INTO tbi_bitacora VALUES(
		DEFAULT,
        USER(),
        "Update",
        "tbb_personas",
        CONCAT_WS(" ","Se han actualizado los datos de la persona con el ID: ",NEW.ID, 
        "con los siguientes datos: TITULO CORTESIA = ", old.titulo_cortesia, " cambio a " ,NEW.titulo_cortesia,
        "NOMBRE=", OLD.nombre, " cambio a " ,NEW.nombre,
        "PRIMER APELLIDO = ", OLD.primer_apellido, " cambio a " , NEW.primer_apellido,
        "SEGUNDO APELLIDO = ", OLD.segundo_apellido, " cambio a " , NEW.segundo_apellido, 
        "FECHA NACIMIENTO = ",  OLD.fecha_nacimiento, " cambio a " ,NEW.fecha_nacimiento, 
        "FOTOGRAFIA = ",  OLD.fotografia, " cambio a " ,NEW.fotografia, 
        "GENERO = ", OLD.genero, " cambio a " , NEW.genero,
        "TIPO SANGRE = ", OLD.tipo_sangre, " cambio a " , NEW.tipo_sangre,
        "ESTATUS = ", OLD.estatus, " cambio a " ,  NEW.estatus,
        "FECHA REGISTRO = ", OLD.fecha_registro, " cambio a " ,   NEW.fecha_registro,
        "FECHA ACTUALIZACIÓN = ",  OLD.fecha_actualizacion, " cambio a " ,  NEW.fecha_actualizacion),
        NOW(),
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`daniel`@`%`*/ /*!50003 TRIGGER `tbb_personas_AFTER_DELETE` AFTER DELETE ON `tbb_personas` FOR EACH ROW BEGIN
	INSERT INTO tbi_bitacora VALUES(
		DEFAULT,
        USER(),
        "Delete",
        "tbb_personas",
        CONCAT_WS(" ","Se ha eliminado una persona con el ID: ", OLD.ID),
        now(),
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbb_preguntas_nutricionales`
--

DROP TABLE IF EXISTS `tbb_preguntas_nutricionales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_preguntas_nutricionales` (
  `ID_Pregunta` int NOT NULL AUTO_INCREMENT,
  `Pregunta` varchar(255) NOT NULL,
  `Tipo_Respuesta` enum('Abierta','Cerrada') NOT NULL,
  `Descripcion` text,
  `Fecha_Creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Opciones_Respuesta` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ID_Pregunta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbb_preguntas_nutricionales`
--

LOCK TABLES `tbb_preguntas_nutricionales` WRITE;
/*!40000 ALTER TABLE `tbb_preguntas_nutricionales` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbb_preguntas_nutricionales` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`ame`@`%`*/ /*!50003 TRIGGER `tbb_preguntas_nutricionales_AFTER_INSERT` AFTER INSERT ON `tbb_preguntas_nutricionales` FOR EACH ROW BEGIN
declare v_estatus varchar(20) default 'Activo';
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not NEW.estatus then
		set v_estatus = "Inactivo";
	end if;
    
	-- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbb_preguntas_nutricionales",
        CONCAT_WS(" ","Se ha insertado una nueva pregunta con los siguientes datos: ",
        "PREGUNTA = ", new.Pregunta,
		"TIPO RESPUESTA = ", new.Tipo_Respuesta,
		"DESCRIPCION = ", NEW.Descripcion, 
		"FECHA CREACION = ", NEW.Fecha_Creacion,
		"FECHA ACTUALIZACION = ", NEW.Fecha_Actualizacion, 
        "OPCIONES RESPUESTA = ", NEW.Opciones_Respuesta, 
        "ESTATUS = ", v_estatus),
        DEFAULT,
		DEFAULT  
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`ame`@`%`*/ /*!50003 TRIGGER `tbb_preguntas_nutricionales_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_preguntas_nutricionales` FOR EACH ROW BEGIN
set new.Fecha_Actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`ame`@`%`*/ /*!50003 TRIGGER `tbb_preguntas_nutricionales_AFTER_UPDATE` AFTER UPDATE ON `tbb_preguntas_nutricionales` FOR EACH ROW BEGIN
declare v_estatus_old varchar(20) default 'Activo';
    declare v_estatus_new varchar(20) default 'Activo';
    
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not old.estatus then
		set v_estatus_old = "Inactivo";
	end if;
    if not NEW.estatus then
		set v_estatus_new = "Inactivo";
	end if;
    
    insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Update' ,
		'tbb_preguntas_nutricionales',
		concat_ws(" ","Se ha modificado una pregunta existente con los siguientes datos: ",
        "PREGUNTA = ", old.Pregunta, ' - ', new.Pregunta,
        " TIPO RESPUESTA =", old.Tipo_Respuesta, ' - ', new.Tipo_Respuesta,
        " DESCRIPCION =", old.Descripcion, ' - ', new.Descripcion,
        " OPCIONES RESPUESTA =", old.Opciones_Respuesta, ' - ', new.Opciones_Respuesta,
        "ESTATUS = ", v_estatus_old, ' - ', v_estatus_new),
	DEFAULT,
	DEFAULT );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`ame`@`%`*/ /*!50003 TRIGGER `tbb_preguntas_nutricionales_AFTER_DELETE` AFTER DELETE ON `tbb_preguntas_nutricionales` FOR EACH ROW BEGIN
declare v_estatus varchar(20) default 'Activo';
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if  not old.estatus then
		set v_estatus = "Inactivo";
	end if;
    
	insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Delete' ,
		"tbb_preguntas_nutricionales",
        CONCAT_WS(" ","Se ha eliminado una pregunta con los siguientes datos: ",
        "PREGUNTA = ", old.Pregunta,
		"TIPO RESPUESTA = ", old.Tipo_Respuesta,
		"DESCRIPCION = ", old.Descripcion, 
        "OPCIONES RESPUESTA = ", old.Opciones_Respuesta,
        "ESTATUS = ", v_estatus),
        DEFAULT,
		DEFAULT   );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbb_prestamos`
--

DROP TABLE IF EXISTS `tbb_prestamos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_prestamos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fecha_prestamo` datetime NOT NULL,
  `fecha_devolucion` datetime DEFAULT NULL,
  `fecha_actualizacion` datetime DEFAULT NULL,
  `fecha_registro` datetime DEFAULT NULL,
  `situacion` enum('pendiente','devuelto','retrasado','cancelado') NOT NULL,
  `observaciones` text,
  `estatus` bit(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbb_prestamos`
--

LOCK TABLES `tbb_prestamos` WRITE;
/*!40000 ALTER TABLE `tbb_prestamos` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbb_prestamos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbb_productos`
--

DROP TABLE IF EXISTS `tbb_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbb_productos`
--

LOCK TABLES `tbb_productos` WRITE;
/*!40000 ALTER TABLE `tbb_productos` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbb_productos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`luz`@`%`*/ /*!50003 TRIGGER `tbb_productos_AFTER_INSERT` AFTER INSERT ON `tbb_productos` FOR EACH ROW BEGIN
DECLARE v_estatus varchar(20) default 'Activo';
if not new.estatus then
set v_estatus = 'Inactivo';
end if;
insert into tbi_bitacora values
(default,
current_user(),
'Create',
'tbb_productos',
concat_ws(' ', 'Se ha creado el nuevo producto con los
siguientes datos:',
'ID: ', new.id, ' NOMBRE: ', new.nombre, 'MARCA:
',new.marca,
'CODIGO_BARRAS: ', new.codigo_barras, 'DESCRIPCION: ',
new.descripcion, 'PRESENTACIÓN : ',new.presentacion,
'PRECIO_ACTUAL: ', new.precio_actual, 'FOTOGRAFÍA: ',
new.fotografia, 'ESTATUS: ',new.estatus,
'ESTATUS: ',v_estatus ,
"FECHA REGISTRO:", new.Fecha_Registro, 
"FECHA ACTUALIZACION", new.Fecha_Actualizacion), default, default
);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`luz`@`%`*/ /*!50003 TRIGGER `tbb_productos_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_productos` FOR EACH ROW BEGIN
SET NEW.Fecha_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`luz`@`%`*/ /*!50003 TRIGGER `tbb_productos_AFTER_UPDATE` AFTER UPDATE ON `tbb_productos` FOR EACH ROW BEGIN
DECLARE v_estatus_old varchar(20) default 'Activo';
declare v_estatus_new varchar(20) default 'Activo';
if not old.estatus then
set v_estatus_old = 'Inactivo';
end if;
if not new.estatus then
set v_estatus_new = 'Inactivo';
end if;
insert into tbi_bitacora values
(default,
current_user(),
'Update',
'tbb_productos',
concat_ws(' ', 'Se ha editado el producto con los siguientes
datos:',
'ID: ', old.id, ' NOMBRE: ', old.nombre, 'MARCA:
',old.marca,
'CODIGO_BARRAS: ', old.codigo_barras, 'DESCRIPCION: ',
old.descripcion, 'PRESENTACIÓN : ',old.presentacion,
'PRECIO_ACTUAL: ', old.precio_actual, 'FOTOGRAFÍA: ',
old.fotografia, 'ESTATUS: ',old.estatus,
'ESTATUS: ',v_estatus_old, '-', v_estatus_new ,
 "FECHA REGISTRO:", old.Fecha_Registro, 
"FECHA ACTUALIZACION", old.Fecha_Actualizacion),default,
default
);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`luz`@`%`*/ /*!50003 TRIGGER `tbb_productos_BEFORE_DELETE` BEFORE DELETE ON `tbb_productos` FOR EACH ROW BEGIN
DECLARE v_estatus varchar(20) default 'Activo';
if NOT OLD.estatus then
set v_estatus = 'Inactivo';
end if;
insert into tbi_bitacora values
(default,
current_user(),
'Delete',
'tbb_productos',
concat_ws(' ', 'Se ha eliminado el producto con los
siguientes datos:',
'ID: ', old.id, ' NOMBRE: ', old.nombre, 'MARCA:
',old.marca,
'CODIGO_BARRAS: ', old.codigo_barras, 'DESCRIPCION: ',
old.descripcion, 'PRESENTACIÓN : ',old.presentacion,
'PRECIO_ACTUAL: ', old.precio_actual, 'FOTOGRAFÍA: ',
old.fotografia, 'ESTATUS: ',old.estatus,
'ESTATUS: ',v_estatus ,
"FECHA REGISTRO:", old.Fecha_Registro, 
"FECHA ACTUALIZACION", old.Fecha_Actualizacion), default, default
);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbb_promociones`
--

DROP TABLE IF EXISTS `tbb_promociones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_promociones` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Producto_id` int unsigned NOT NULL,
  `Tipo` enum('Miembro','Usuario','Empleado') NOT NULL DEFAULT 'Usuario',
  `Aplicacion_en` enum('Tienda virtual','Tienda Presencial') NOT NULL DEFAULT 'Tienda Presencial',
  `Estatus` bit(1) DEFAULT b'1',
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Producto_id_idx` (`Producto_id`),
  CONSTRAINT `Producto_id_2` FOREIGN KEY (`Producto_id`) REFERENCES `tbb_productos` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbb_promociones`
--

LOCK TABLES `tbb_promociones` WRITE;
/*!40000 ALTER TABLE `tbb_promociones` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbb_promociones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`edgar`@`%`*/ /*!50003 TRIGGER `tbd_promocion_AFTER_INSERT` AFTER INSERT ON `tbb_promociones` FOR EACH ROW begin
	
    declare v_estatus varchar(20) default 'Activo';
    DECLARE v_nombre_producto varchar(60) default null;
    DECLARE v_producto_old varchar(60) default null;
    DECLARE v_producto_new varchar(60) default null;
    
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not NEW.estatus then
		set v_estatus = "Inactivo";
	end if;
    
    if new.producto_id is not null then
        -- En caso de tener el id del usuario debemos recuperar su nombre
        set v_nombre_producto = (SELECT CONCAT_WS(" ", p.nombre, p.marca, p.descripcion) FROM tbb_productos p WHERE id = NEW.producto_id);
    else
        SET v_nombre_producto = "Sin producto asignado";
    end if;
    
	-- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbb_promocion",
        CONCAT_WS(" ","Se ha insertado una nueva promocion con los siguientes datos: ",
        "ID PRODUCTOS = ", v_nombre_producto,
        "TIPO = ", new.Tipo,
        "APLICACION EN = ", NEW.Aplicacion_en, 
		"FECHA REGISTRO = ", new.fecha_registro,
        "FECHA ACTUALIZACION = ", NEW.fecha_actualizacion, 
        "ESTATUS = ", v_estatus),
        DEFAULT,
		DEFAULT  
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`edgar`@`%`*/ /*!50003 TRIGGER `tbd_promocion_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_promociones` FOR EACH ROW BEGIN
	set new.Fecha_Actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`edgar`@`%`*/ /*!50003 TRIGGER `tbd_promocion_AFTER_UPDATE` AFTER UPDATE ON `tbb_promociones` FOR EACH ROW BEGIN
	
    declare v_estatus_old varchar(20) default 'Activo';
    declare v_estatus_new varchar(20) default 'Activo';
    DECLARE v_producto_old varchar(60) default null;
    DECLARE v_producto_new varchar(60) default null;
    
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not old.estatus then
		set v_estatus_old = "Inactivo";
	end if;
    if not NEW.estatus then
		set v_estatus_new = "Inactivo";
	end if;
    
    
    IF NEW.producto_id IS NOT NULL THEN 
		-- En caso de tener el id del usuario
		SET v_producto_new = (SELECT CONCAT_WS(" ", p.nombre, p.marca, p.descripcion) FROM tbb_productos p WHERE id = NEW.producto_id);
    else
		SET v_producto_new = "Sin usuario asignado.";
    END IF;
    
    IF OLD.producto_id IS NOT NULL THEN 
		-- En caso de tener el id del usuario
		SET v_producto_old = (SELECT CONCAT_WS(" ", p.nombre, p.marca, p.descripcion) FROM tbb_productos p WHERE id = old.producto_id);
    else
		SET v_producto_old = "Sin usuario asignado.";
    END IF;
    
    
	insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Update' ,
		'tbb_promocion',
		concat_ws(" ","Se ha modificado una promocion de un producto existente con los siguientes datos: ",
        "ID PRODUCTO = ", v_producto_old, '-', v_producto_new,
        "TIPO = ", old.Tipo, ' - ', new.Tipo,
        "APLICACION EN =", old.Aplicacion_en, ' - ', new.Aplicacion_en,
        "ESTATUS = ", v_estatus_old, ' - ', v_estatus_new),
	DEFAULT,
	DEFAULT  
);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`edgar`@`%`*/ /*!50003 TRIGGER `tbd_promocion_BEFORE_DELETE` BEFORE DELETE ON `tbb_promociones` FOR EACH ROW BEGIN
declare v_estatus varchar(20) default 'Activo';
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if  not old.estatus then
		set v_estatus = "Inactivo";
	end if;
    
	insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Delete' ,
		'tbb_promocion',
		CONCAT_WS(" ","Se ha eliminado una promoción de un producto con los siguientes datos: ",
        "TIPO = ", old.Tipo, 
        "APLICACION EN =", old.Aplicacion_en,
        "ESTATUS = ", v_estatus),
	DEFAULT,
	DEFAULT );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbb_transacciones`
--

DROP TABLE IF EXISTS `tbb_transacciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_transacciones` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Metodo_Pago` enum('Tarjeta de debito','Tarjeta de credito') NOT NULL,
  `Monto` float NOT NULL,
  `Estatus` tinyint(1) NOT NULL DEFAULT '1',
  `Fecha_Transaccion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  `Usuario_ID` int unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_transaccion_usuario_idx` (`Usuario_ID`),
  CONSTRAINT `fk_transaccion_usuario` FOREIGN KEY (`Usuario_ID`) REFERENCES `tbb_usuarios` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbb_transacciones`
--

LOCK TABLES `tbb_transacciones` WRITE;
/*!40000 ALTER TABLE `tbb_transacciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbb_transacciones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sebastian.marquez`@`%`*/ /*!50003 TRIGGER `tbb_transacciones_AFTER_INSERT` AFTER INSERT ON `tbb_transacciones` FOR EACH ROW BEGIN
	DECLARE v_estatus varchar(20) default 'Activo';
    
    IF not new.estatus = b'1' then
        set v_estatus = "Inactivo";
    end if;

    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbb_transacciones",
        CONCAT_WS(" ","Se ha insertado una nueva transaccion con los siguientes datos: ",
        "ID = ", NEW.ID,
        "METODO_PAGO = ", NEW.Metodo_Pago,
        "MONTO = ", NEW.Monto, 
        "ESTATUS = ", v_estatus,
        "FECHA_TRANSACCION = ", NEW.Fecha_Transaccion,
        "FECHA_ACTUALIZACION = ", NEW.Fecha_Actualizacion),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sebastian.marquez`@`%`*/ /*!50003 TRIGGER `tbb_transacciones_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_transacciones` FOR EACH ROW BEGIN
	SET NEW.Fecha_Actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sebastian.marquez`@`%`*/ /*!50003 TRIGGER `tbb_transacciones_AFTER_UPDATE` AFTER UPDATE ON `tbb_transacciones` FOR EACH ROW BEGIN
	DECLARE v_estatus_old varchar(20) default 'Activo';
	DECLARE v_estatus_new varchar(20) default 'Activo';
    
    IF not old.estatus = b'1' then
        set v_estatus_old = "Inactivo";
    end if;

    IF not new.estatus = b'1' then
        set v_estatus_new = "Inactivo";
    end if;

    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Update",
        "tbb_transacciones",
        CONCAT_WS(" ","Se ha actualizado transaccion con los siguientes datos: ",
        "ID = ", OLD.ID, "-", NEW.ID,
        "METODO_PAGO = ", OLD.Metodo_Pago, "-", NEW.Metodo_Pago,
        "MONTO = ", OLD.Monto, "-", NEW.Monto, 
        "ESTATUS = ", v_estatus_old, "-", v_estatus_new,
        "FECHA_TRANSACCION = ", OLD.Fecha_Transaccion, "-", NEW.Fecha_Transaccion,
        "FECHA_ACTUALIZACION = ", OLD.Fecha_Actualizacion, "-", NEW.Fecha_Actualizacion),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sebastian.marquez`@`%`*/ /*!50003 TRIGGER `tbb_transacciones_AFTER_DELETE` AFTER DELETE ON `tbb_transacciones` FOR EACH ROW BEGIN
	DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    IF NOT OLD.estatus = b'1' THEN
        SET v_estatus = "Inactivo";
    END IF;
	
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Delete",
        "tbb_transacciones",
        CONCAT_WS(" ","Se ha eliminado la transaccion con los siguientes datos: ", 
        "ID = ", OLD.ID,
        "METODO_PAGO = ", OLD.Metodo_Pago,
        "MONTO = ", OLD.Monto, 
        "ESTATUS = ", v_estatus,
        "FECHA_TRANSACCION = ", OLD.Fecha_Transaccion,
        "FECHA_ACTUALIZACION = ", OLD.Fecha_Actualizacion),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbb_usuarios`
--

DROP TABLE IF EXISTS `tbb_usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbb_usuarios` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Persona_ID` int unsigned NOT NULL,
  `Nombre_Usuario` varchar(60) NOT NULL,
  `Correo_Electronico` varchar(100) NOT NULL,
  `Contrasena` varchar(40) NOT NULL,
  `Numero_Telefonico_Movil` char(20) NOT NULL,
  `Estatus` enum('Activo','Inactivo','Bloqueado','Suspendido') DEFAULT 'Activo',
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Nombre_Usuario_UNIQUE` (`Nombre_Usuario`),
  UNIQUE KEY `Correo_Electronico_UNIQUE` (`Correo_Electronico`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbb_usuarios`
--

LOCK TABLES `tbb_usuarios` WRITE;
/*!40000 ALTER TABLE `tbb_usuarios` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbb_usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbb_usuarios_AFTER_INSERT` AFTER INSERT ON `tbb_usuarios` FOR EACH ROW BEGIN
	
	INSERT INTO tbi_bitacora VALUES
    (DEFAULT,
    current_user(), 
    'Create', 
    'tbb_usuarios', 
    CONCAT_WS(' ','Se ha creado un nuevo usuario con los siguientes datos:',
    'ID: ', new.id, '\n',
    'PERSONA ID: ', new.persona_id, '\n',
    'NOMBRE USUARIO: ', new.nombre_usuario, '\n',
    'CORREO ELECTRÓNICO: ', new.correo_electronico, '\n',
    'CONTRASEÑA: ', new.contrasena, '\n',
    'NÚMERO TELEFÓNICO MÓVIL: ', new.numero_telefonico_movil, '\n',
    'ESTATUS: ', new.estatus, '\n'),
    DEFAULT, DEFAULT);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbb_usuarios_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_usuarios` FOR EACH ROW BEGIN
SET new.fecha_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbb_usuarios_AFTER_UPDATE` AFTER UPDATE ON `tbb_usuarios` FOR EACH ROW BEGIN
INSERT INTO tbi_bitacora VALUES
    (DEFAULT,
    current_user(), 
    'Update', 
    'tbb_usuarios', 
    CONCAT_WS(' ','Se ha creado un modificado ul usuario con ID :', old.id,"con los 
    siguientes datos: \n",
    'PERSONA ID: ', old.persona_id, ' - ', new.persona_id, '\n',
    'NOMBRE USUARIO: ', old.nombre_usuario, ' - ', new.nombre_usuario, '\n',
    'CORREO ELECTRÓNICO: ', old.correo_electronico, ' - ',new.correo_electronico, '\n',
    'CONTRASEÑA: ', old.contrasena, ' - ',new.contrasena, '\n',
    'NÚMERO TELEFÓNICO MÓVIL: ', old.numero_telefonico_movil, ' - ',new.numero_telefonico_movil, '\n',
    'ESTATUS: ', old.estatus, ' - ',new.estatus, '\n'),
    DEFAULT, DEFAULT);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbb_usuarios_AFTER_DELETE` AFTER DELETE ON `tbb_usuarios` FOR EACH ROW BEGIN
INSERT INTO tbi_bitacora VALUES
    (DEFAULT,
    current_user(), 
    'Delete', 
    'tbb_usuarios', 
    CONCAT_WS(' ','Se ha eliminado un usuario existente con los siguientes datos:',
    'ID: ', old.id, '\n',
    'PERSONA ID: ', old.persona_id, '\n',
    'NOMBRE USUARIO: ', old.nombre_usuario, '\n',
    'CORREO ELECTRÓNICO: ', old.correo_electronico, '\n',
    'CONTRASEÑA: ', old.contrasena, '\n',
    'NÚMERO TELEFÓNICO MÓVIL: ', old.numero_telefonico_movil, '\n',
    'ESTATUS: ', old.estatus, '\n'),
    DEFAULT, DEFAULT);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbc_ejercicios`
--

DROP TABLE IF EXISTS `tbc_ejercicios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_ejercicios` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) NOT NULL,
  `Descripcion` text,
  `Video` varchar(100) DEFAULT NULL,
  `Tipo` enum('Aerobico','Resistencia','Fuerza','Flexibilidad') NOT NULL,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Dificultad` enum('Basico','Avanzado','Intermedio') NOT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  `Recomendaciones` text,
  `Restricciones` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbc_ejercicios`
--

LOCK TABLES `tbc_ejercicios` WRITE;
/*!40000 ALTER TABLE `tbc_ejercicios` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbc_ejercicios` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`suri`@`%`*/ /*!50003 TRIGGER `tbc_ejercicios_AFTER_INSERT` AFTER INSERT ON `tbc_ejercicios` FOR EACH ROW BEGIN
DECLARE v_estatus varchar(20) default 'Activo';

if not new.estatus then
set v_estatus = 'Inactivo';
end if;

insert into tbi_bitacora values
(default,
current_user(),
'Create', 
'tbc_ejercicio',
concat_ws(' ', 'Se ha creado un nuevo ejercicio con los siguientes datos:',
'ID: ', new.id, 
'NOMBRE: ', new.nombre, 
'DESCRIPCION: ',new.descripcion,
'VIDEO: ', new.video, 
'TIPO ', new.tipo, 
'ESTATUS ', new.estatus,
'DIFICULTAD ', new.dificultad,  
'FECHA_REGISTRO: ',new.fecha_registro,
'FECHA_ACTUALIZACION: ', new.fecha_actualizacion,
'RECOMENDACIONES: ', new.recomendaciones,
'RESTRICCIONES: ', new.restricciones,
'ESTATUS: ',v_estatus ), default, default
);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`suri`@`%`*/ /*!50003 TRIGGER `tbc_ejercicios_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_ejercicios` FOR EACH ROW BEGIN
SET NEW.Fecha_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`suri`@`%`*/ /*!50003 TRIGGER `tbc_ejercicios_AFTER_UPDATE` AFTER UPDATE ON `tbc_ejercicios` FOR EACH ROW BEGIN
DECLARE v_estatus_old varchar(20) default 'Activo';
declare v_estatus_new varchar(20) default 'Activo';

if not old.estatus then
set v_estatus_old = 'Inactivo';
end if;

if not new.estatus then
set v_estatus_new = 'Inactivo';
end if;


insert into tbi_bitacora values
(default,
current_user(),
'Update', 
'tbc_ejercicio',
concat_ws(' ', 'Se ha editado el ejercicio con los siguientes datos:',
'ID: ', old.id, 
'NOMBRE: ', old.nombre, 
'DESCRIPCION: ',old.descripcion,
'VIDEO: ', old.video, 
'TIPO ', old.tipo, 
'ESTATUS ', old.estatus,
'DIFICULTAD ', old.dificultad,  
'FECHA_REGISTRO: ',old.fecha_registro,
'FECHA_ACTUALIZACION: ', old.fecha_actualizacion,
'RECOMENDACIONES: ', old.recomendaciones,
'RESTRICCIONES: ', old.restricciones,
'ESTATUS: ',v_estatus_old, '-',  v_estatus_new  ), default, default
);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`suri`@`%`*/ /*!50003 TRIGGER `tbc_ejercicios_BEFORE_DELETE` BEFORE DELETE ON `tbc_ejercicios` FOR EACH ROW BEGIN
DECLARE v_estatus varchar(20) default 'Activo';

if NOT OLD.estatus then
set v_estatus = 'Inactivo';
end if;


insert into tbi_bitacora values
(default,
current_user(),
'Delete', 
'tbc_ejercicio',
concat_ws(' ', 'Se ha eliminado el ejercicio con los siguientes datos:',
'ID: ', old.id, 
'NOMBRE: ', old.nombre, 
'DESCRIPCION: ',old.descripcion,
'VIDEO: ', old.video, 
'TIPO ', old.tipo, 
'ESTATUS ', old.estatus,
'DIFICULTAD ', old.dificultad,  
'FECHA_REGISTRO: ',old.fecha_registro,
'FECHA_ACTUALIZACION: ', old.fecha_actualizacion,
'RECOMENDACIONES: ', old.recomendaciones,
'RESTRICCIONES: ', old.restricciones,
'ESTATUS: ',v_estatus ), default, default
);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbc_indicadores_nutricionales`
--

DROP TABLE IF EXISTS `tbc_indicadores_nutricionales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_indicadores_nutricionales` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `tipo` enum('vitamina','mineral','macronutriente','fibra','antioxidante','otro') NOT NULL,
  `descripcion` text,
  `estatus` enum('activo','inactivo','pendiente','obsoleto','archivado') NOT NULL,
  `observaciones` text,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbc_indicadores_nutricionales`
--

LOCK TABLES `tbc_indicadores_nutricionales` WRITE;
/*!40000 ALTER TABLE `tbc_indicadores_nutricionales` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbc_indicadores_nutricionales` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbc_indicador_nutricional_AFTER_INSERT` AFTER INSERT ON `tbc_indicadores_nutricionales` FOR EACH ROW BEGIN
	INSERT INTO tbi_bitacora VALUES
    (DEFAULT,
    current_user(), 
    'Create', 
    'tbc_indicador_nutricional', 
    CONCAT_WS(' ','Se ha creado un indicador nutricional con los siguientes datos:',
    'NOMBRE: ', new.nombre, '\n',
    'TIPO: ', new.tipo, '\n',
    'DESCRIPCION: ', new.descripcion, '\n',
    'ESTATUS: ', new.estatus, '\n',
    'OBSERVACIONES: ', new.observaciones, '\n',
    'FECHA REGISTRO: ', new.fecha_registro, '\n',
    'FECHA ACTUALIZACION: ', new.fecha_actualizacion, '\n'),
    DEFAULT, DEFAULT);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbc_indicador_nutricional_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_indicadores_nutricionales` FOR EACH ROW BEGIN
	SET new.fecha_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbc_indicador_nutricional_AFTER_UPDATE` AFTER UPDATE ON `tbc_indicadores_nutricionales` FOR EACH ROW BEGIN
	INSERT INTO tbi_bitacora VALUES
    (DEFAULT,
    current_user(), 
    'Update', 
    'tbc_indicador_nutricional', 
    CONCAT_WS(' ','Se ha creado o modificado un indicador nutricional al usuario con ID :', old.id,"con los 
    siguientes datos: \n",
    'NOMBRE: ', old.nombre, ' - ', new.nombre, '\n',
    'TIPO: ', old.tipo, ' - ',new.tipo, '\n',
    'DESCRIPCION: ', old.descripcion, ' - ',new.descripcion, '\n',
    'ESTATUS: ', old.estatus, ' - ',new.estatus, '\n',
    'OBSERVACIONES: ', old.observaciones, ' _ ', new.observaciones, '\n'),
    
    DEFAULT,
    DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbc_indicador_nutricional_BEFORE_DELETE` BEFORE DELETE ON `tbc_indicadores_nutricionales` FOR EACH ROW BEGIN
	
	INSERT INTO tbi_bitacora VALUES
    (DEFAULT,
    current_user(), 
    'Delete', 
    'tbc_indicador_nutricional', 
    CONCAT_WS(' ','Se ha eliminado un indicador nutricional del usuario existente con los siguientes datos:',
    'NOMBRE: ', old.nombre, 
    'TIPO: ', old.tipo, 
    'DESCRIPCION: ', old.descripcion, 
    'ESTATUS: ', old.estatus, 
    'OBSERVACIONES: ', old.observaciones), 
    
    DEFAULT, DEFAULT);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbc_membresias`
--

DROP TABLE IF EXISTS `tbc_membresias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_membresias` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Codigo` varchar(50) NOT NULL,
  `Tipo` enum('Individual','Familiar','Empresarial') NOT NULL,
  `Tipo_Servicios` enum('Basicos','Completa','Coaching','Nutriólogo') NOT NULL,
  `Tipo_Plan` enum('Anual','Semestral','Trimestral','Bimestral','Mensual','Semanal','Diaria') DEFAULT NULL,
  `Nivel` enum('Nuevo','Plata','Oro','Diamante') NOT NULL,
  `Fecha_Inicio` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Fin` datetime DEFAULT NULL,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbc_membresias`
--

LOCK TABLES `tbc_membresias` WRITE;
/*!40000 ALTER TABLE `tbc_membresias` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbc_membresias` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbc_membresias_AFTER_INSERT` AFTER INSERT ON `tbc_membresias` FOR EACH ROW BEGIN
	 -- Declaración de variables
    DECLARE v_cadena_estatus VARCHAR(15) DEFAULT NULL;
    
    -- Inicialización de las variables 
    IF NEW.estatus = b'1' THEN
		SET v_cadena_estatus= "Activa";
    ELSE
		SET v_cadena_estatus= "Inactiva";
    END IF; 
    
	INSERT INTO tbi_bitacora VALUES(
		DEFAULT,
        USER(),
        "Create",
        "tbc_membresias",
        CONCAT_WS(" ","Se han creado los datos de la MEMBRESIA con el ID: ",NEW.ID, 
        "con los siguientes datos:",
        "CODIGO = ",NEW.codigo,
        "TIPO = ", NEW.tipo, 
		"TIPO SERVICIOS = ",NEW.tipo_servicios,
        "TIPO PLAN = ",NEW.tipo_plan, 
        "NIVEL = ", NEW.nivel,
        "FECHA INICIO = ",NEW.fecha_inicio, 
        "FECHA FIN = ", NEW.fecha_fin,
        "ESTATUS = ", v_cadena_estatus,
        "FECHA REGISTRO = ",  NEW.fecha_registro,
        "FECHA ACTUALIZACIÓN = ", NEW.fecha_actualizacion),
        NOW(),
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`hugo`@`%`*/ /*!50003 TRIGGER `tbc_membresias_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_membresias` FOR EACH ROW BEGIN
	set new.fecha_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`hugo`@`%`*/ /*!50003 TRIGGER `tbc_membresias_AFTER_UPDATE` AFTER UPDATE ON `tbc_membresias` FOR EACH ROW BEGIN
	 -- Declaración de variables
    DECLARE v_cadena_estatus VARCHAR(15) DEFAULT NULL;
    DECLARE v_cadena_estatus2 VARCHAR(15) DEFAULT NULL;
    
    -- Inicialización de las variables 
    IF NEW.estatus = b'1' THEN
		SET v_cadena_estatus= "Activa";
    ELSE
		SET v_cadena_estatus= "Inactiva";
    END IF; 
    
    IF OLD.estatus = b'1' THEN
		SET v_cadena_estatus2= "Activa";
    ELSE
		SET v_cadena_estatus2= "Inactiva";
    END IF; 
	INSERT INTO tbi_bitacora VALUES(
		DEFAULT,
        USER(),
        "Update",
        "tbc_membresias",
        CONCAT_WS(" ","Se han actualizado los datos de la MEMBRESIA con el ID: ",NEW.ID, 
        "con los siguientes datos:",
        "CODIGO = ", OLD.codigo, " cambio a " ,NEW.codigo,
        "TIPO = ",  OLD.tipo, " cambio a " ,NEW.tipo, 
		"TIPO SERVICIOS = ", OLD.tipo_servicios, " cambio a " , NEW.tipo_servicios,
        "TIPO PLAN = ", OLD.tipo_plan, " cambio a " , NEW.tipo_plan, 
        "NIVEL = ", OLD.nivel, " cambio a " , NEW.nivel,
        "FECHA INICIO = ",  OLD.fecha_inicio, " cambio a " ,NEW.fecha_inicio, 
        "FECHA FIN = ", OLD.fecha_fin, " cambio a " , NEW.fecha_fin,
        "ESTATUS = ",  v_cadena_estatus2, " cambio a " ,v_cadena_estatus,
        "FECHA REGISTRO = ",  OLD.fecha_registro, " cambio a " ,NEW.fecha_registro,
        "FECHA ACTUALIZACIÓN = ",  OLD.fecha_actualizacion, " cambio a " ,NEW.fecha_actualizacion),
        NOW(),
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`hugo`@`%`*/ /*!50003 TRIGGER `tbc_membresias_BEFORE_DELETE` BEFORE DELETE ON `tbc_membresias` FOR EACH ROW BEGIN
	insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Delete' ,
		'tbc_membresias',
		CONCAT_WS(" ","Se ha eliminado una membresia con los siguientes datos: ",
        "CODIGO = ", OLD.codigo,
        "TIPO = ",  OLD.tipo, 
		"TIPO SERVICIOS = ", OLD.tipo_servicios,
        "TIPO PLAN = ", OLD.tipo_plan,
        "NIVEL = ", OLD.nivel,
        "FECHA INICIO = ",  OLD.fecha_inicio,  
        "FECHA FIN = ", OLD.fecha_fin, 
        "ESTATUS = ", old.estatus,
        "FECHA REGISTRO = ",  OLD.fecha_registro,
        "FECHA ACTUALIZACIÓN = ", old.fecha_actualizacion),
        DEFAULT,
        default
);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbc_puestos`
--

DROP TABLE IF EXISTS `tbc_puestos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_puestos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  `Descripcion` text NOT NULL,
  `Salario` decimal(7,2) NOT NULL DEFAULT '0.00',
  `Requisitos` text NOT NULL,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbc_puestos`
--

LOCK TABLES `tbc_puestos` WRITE;
/*!40000 ALTER TABLE `tbc_puestos` DISABLE KEYS */;
INSERT INTO `tbc_puestos` VALUES (1,'Gerente','Empleado responsable de la Sucursal del Gimnasio.',22300.00,'Carrera Universitaria, Habilidades Informática y Trabajo en Equipo.',_binary '','2024-07-16 13:23:04','2024-07-16 13:23:04'),(2,'Entrenador','Empleado responsable de acompañar al cliente en sus programas saludables',12500.00,'Experiencia en Couching, Desempeño Físico y Primeros Auxilios',_binary '','2024-07-16 13:23:04',NULL),(3,'Nutriologo','Empleado responsable en dietas \n      y seguimiento alimienticio de los clientes',16400.00,'Carrera Profesional en \n      Mediciona o Nutrición.',_binary '','2024-07-16 13:23:04',NULL),(4,'Recepcionista','Empleado responsable de la atención a los clientes del gimnasio,\n      registros de entradas y salidas ',6300.00,'Bachillerato, Habilidades Informática.',_binary '','2024-07-16 13:23:04',NULL),(5,'Técnico en Mantenimiento','Empleado responsable de mantener en funcionamiento el\n      equipamiento de la sucursal.',10500.00,'Bachillerato, Mecánica y Electrónica básica.',_binary '','2024-07-16 13:23:04','2024-07-16 13:23:04');
/*!40000 ALTER TABLE `tbc_puestos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`amisadai`@`%`*/ /*!50003 TRIGGER `tbc_puestos_AFTER_INSERT` AFTER INSERT ON `tbc_puestos` FOR EACH ROW BEGIN
declare v_estatus varchar(20) default 'Activo';
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not NEW.estatus then
		set v_estatus = "Inactivo";
	end if;
    
	-- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbc_puestos",
        CONCAT_WS(" ","Se ha insertado una nuevo puesto con los siguientes datos: ",
        "NOMBRE = ", NEW.Nombre,
        "DESCRIPCIÓN = ", NEW.Descripcion,
		"SALARIO = ", NEW.Salario,
        "REQUISITOS = ", NEW.Requisitos,
		"ESTATUS = ", v_estatus,
        "FECHA REGISTRO = ", new.Fecha_Registro,
		"FECHA_ACTUALIZACION = ", NEW.Fecha_Actualizacion
       ),
        DEFAULT,
        DEFAULT
    );

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`amisadai`@`%`*/ /*!50003 TRIGGER `tbc_puestos_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_puestos` FOR EACH ROW BEGIN
set new.Fecha_Actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`amisadai`@`%`*/ /*!50003 TRIGGER `tbc_puestos_AFTER_UPDATE` AFTER UPDATE ON `tbc_puestos` FOR EACH ROW BEGIN
DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
	DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Activo';
    
    -- Verificamos si el estatus del puesto, para ubicar el valor en la descripción de la bitácora
    IF NOT OLD.Estatus THEN
        SET v_estatus_old = "Inactivo";
    END IF;
    IF NOT NEW.Estatus THEN
        SET v_estatus_new = "Inactivo";
    END IF;
    
    INSERT INTO tbi_bitacora VALUES (
        DEFAULT,
        CURRENT_USER(),
        'Update',
        'tbc_puestos',
			CONCAT_WS(", ", "Se ha modificado un puesto de usuario con los siguientes datos:",
            "NOMBRE =", OLD.Nombre, ' - ', NEW.Nombre,
            "DESCRIPCIÓN =", OLD.Descripcion, ' - ', NEW.Descripcion,
            "SALARIO =", OLD.Salario, ' - ', NEW.Salario,
            "REQUISITOS =", OLD.Requisitos, ' - ', NEW.Requisitos,
             "ESTATUS =", v_estatus_old, ' - ', v_estatus_new,
            "FECHA REGISTRO =", OLD.Fecha_Registro, ' - ', NEW.Fecha_Registro, 
            "FECHA ACTUALIZACION =", OLD.Fecha_Actualizacion, ' - ', NEW.Fecha_Actualizacion
        ),
	DEFAULT,
	DEFAULT  
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`amisadai`@`%`*/ /*!50003 TRIGGER `tbc_puestos_AFTER_DELETE` AFTER DELETE ON `tbc_puestos` FOR EACH ROW BEGIN
DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    IF NOT OLD.estatus THEN
        SET v_estatus = "Inactiva";
    END IF;
    
    INSERT INTO tbi_bitacora VALUES (
        DEFAULT,
        CURRENT_USER(),
        'Delete',
        'tbc_puestos',
			CONCAT_WS(" ", "Se ha eliminado un puesto con los siguientes datos:",
            "NOMBRE =", OLD.Nombre,
            "DESCRIPCIÓN =", OLD.Descripcion,
            "SALARIO =", OLD.Salario,
            "REQUISITOS =", OLD.Requisitos,
            "ESTATUS =", v_estatus,
            "FECHA REGISTRO =", OLD.Fecha_Registro,
            "FECHA ACTUALIZACION =", OLD.Fecha_Actualizacion
        ),
	DEFAULT,
	DEFAULT );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbc_roles`
--

DROP TABLE IF EXISTS `tbc_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_roles` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  `Descripcion` text,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbc_roles`
--

LOCK TABLES `tbc_roles` WRITE;
/*!40000 ALTER TABLE `tbc_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbc_roles` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbc_roles_AFTER_INSERT` AFTER INSERT ON `tbc_roles` FOR EACH ROW BEGIN
	DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    -- Verificamos el estatus del rol , para ubicar el valor en la descripción 
    -- de la bitácora
    IF NOT new.estatus THEN 
      SET v_estatus = 'Inactivo';
	END IF; 
    
	INSERT INTO tbi_bitacora VALUES
    (DEFAULT,
    current_user(), 
    'Create', 
    'tbc_roles', 
    CONCAT_WS(' ','Se ha creado un nuevo rol de usuario con los siguientes datos:',
    'NOMBRE: ', new.nombre, 'DESCRIPCIÓN:', new.descripcion, 'ESTATUS:',  v_estatus),
    DEFAULT, DEFAULT);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbc_roles_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_roles` FOR EACH ROW BEGIN     
	SET NEW.Fecha_Actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbc_roles_AFTER_UPDATE` AFTER UPDATE ON `tbc_roles` FOR EACH ROW BEGIN
 DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
 DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Activo';
 
 -- Validaciones para las etiqueta del estatus
      IF NOT old.estatus THEN 
		SET v_estatus_old = 'Inactivo';
      END IF; 
    
	  IF NOT new.estatus THEN 
		SET v_estatus_new = 'Inactivo';
      END IF; 

INSERT INTO tbi_bitacora VALUES
    (DEFAULT,
    current_user(), 
    'Update', 
    'tbc_roles', 
    CONCAT_WS(' ','Se ha modificado un rol de usuario existente con los siguientes datos:',
    'NOMBRE: ', old.nombre, ' - ' , new.nombre , 'DESCRIPCIÓN:', old.descripcion, ' - ',
    new.descripcion, 'ESTATUS:', v_estatus_old, ' - ', v_estatus_new),
    DEFAULT,DEFAULT);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbc_roles_BEFORE_DELETE` BEFORE DELETE ON `tbc_roles` FOR EACH ROW BEGIN
    DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    -- Verificamos el estatus del rol , para ubicar el valor en la descripción 
    -- de la bitácora
    IF NOT old.estatus THEN 
      SET v_estatus = 'Inactivo';
	END IF; 
    
	INSERT INTO tbi_bitacora VALUES
    (DEFAULT,
    current_user(), 
    'Delete', 
    'tbc_roles', 
    CONCAT_WS(' ','Se ha eliminado un rol de usuario existente con los siguientes datos:',
    'NOMBRE: ', old.nombre, 'DESCRIPCIÓN:', old.descripcion, 'ESTATUS:',  v_estatus),
    DEFAULT, DEFAULT);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbc_sucursales`
--

DROP TABLE IF EXISTS `tbc_sucursales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbc_sucursales` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(150) NOT NULL,
  `Direccion` varchar(250) NOT NULL,
  `Responsable_ID` int unsigned DEFAULT NULL,
  `Total_Clientes_Atendidos` int unsigned NOT NULL DEFAULT '0',
  `Promedio_Clientes_X_Dia` int unsigned NOT NULL DEFAULT '0',
  `Capacidad_Maxima` int unsigned NOT NULL DEFAULT '0',
  `Total_Empleados` int unsigned DEFAULT '0',
  `Horario_Disponibilidad` text NOT NULL,
  `Estatus` bit(1) DEFAULT b'1',
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbc_sucursales`
--

LOCK TABLES `tbc_sucursales` WRITE;
/*!40000 ALTER TABLE `tbc_sucursales` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbc_sucursales` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`valencia`@`%`*/ /*!50003 TRIGGER `tbc_sucursales_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_sucursales` FOR EACH ROW BEGIN
	set new.Fecha_Actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbd_adeudos`
--

DROP TABLE IF EXISTS `tbd_adeudos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_adeudos` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `area` varchar(90) NOT NULL,
  `cliente` varchar(90) NOT NULL,
  `descripcion` varchar(45) NOT NULL,
  `fecha_registro` datetime DEFAULT NULL,
  `fecha_actualizacion` datetime DEFAULT NULL,
  `estatus` bit(1) NOT NULL DEFAULT b'1',
  `tipo` varchar(45) NOT NULL,
  `detalle` enum('Producto','Equipamiento','Servicio') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbd_adeudos`
--

LOCK TABLES `tbd_adeudos` WRITE;
/*!40000 ALTER TABLE `tbd_adeudos` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbd_adeudos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`YairS`@`%`*/ /*!50003 TRIGGER `tbd_adeudos_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_adeudos` FOR EACH ROW BEGIN
SET NEW.Fecha_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbd_detalles_dietas`
--

DROP TABLE IF EXISTS `tbd_detalles_dietas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_detalles_dietas` (
  `Dieta_id` int unsigned NOT NULL,
  `Detalle` text NOT NULL,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`Dieta_id`),
  CONSTRAINT `fk_dieta_3` FOREIGN KEY (`Dieta_id`) REFERENCES `tbd_dietas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbd_detalles_dietas`
--

LOCK TABLES `tbd_detalles_dietas` WRITE;
/*!40000 ALTER TABLE `tbd_detalles_dietas` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbd_detalles_dietas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`emilio`@`%`*/ /*!50003 TRIGGER `tbd_detalles_dietas_AFTER_INSERT` AFTER INSERT ON `tbd_detalles_dietas` FOR EACH ROW BEGIN
	-- Declaración de variables
    DECLARE v_estatus varchar(20) default 'Activo';
    
    IF not new.estatus = b'1' then
        set v_estatus = "Inactiva";
    end if;

    -- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbd_detalles_dietas",
        CONCAT_WS(" ","Se ha insertado un nuevo detalle de dieta con el id",NEW.Dieta_id, "\n los siguientes datos: ",
        "DETALLE = ", NEW.detalle, "\n ",
        "ESTATUS = ", v_estatus, "\n ",
        "Fecha registro = ", new.fecha_registro, "\n ",
        "Fecha Actualización = ", NEW.fecha_actualizacion ),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`emilio`@`%`*/ /*!50003 TRIGGER `tbd_detalle_dieta_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_detalles_dietas` FOR EACH ROW BEGIN
	set new.Fecha_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`emilio`@`%`*/ /*!50003 TRIGGER `tbd_detalles_dietas_AFTER_UPDATE` AFTER UPDATE ON `tbd_detalles_dietas` FOR EACH ROW BEGIN
	DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
    DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Inactivo'; 
    
    IF not NEW.estatus then
        set v_estatus_old = "Activo";
    end if;
    
    IF  not old.estatus then
        set v_estatus_new = "Activo";
    end if;

	insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Update' ,
		'tbd_detalles_dietas',
		concat_ws(" ","Se ha modificado un detalle de dieta con el id",NEW.Dieta_id, "\n los siguientes datos: ",
        "DETALLE = ", old.detalle, ' - ', NEW.detalle, "\n "
        "ESTATUS = ", v_estatus_old, ' - ', v_estatus_new),
	DEFAULT,
	DEFAULT);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`emilio`@`%`*/ /*!50003 TRIGGER `tbd_detalles_dietas_BEFORE_DELETE` BEFORE DELETE ON `tbd_detalles_dietas` FOR EACH ROW BEGIN
	DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    IF  not OLD.estatus then
        set v_estatus = "Inactiva";
    end if; 
    insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Delete' ,
		'tbd_detalles_dietas',
		CONCAT_WS(" ","Se ha eliminado un detalle de dieta con el id",old.Dieta_id, "\n los siguientes datos: ",
        "DETALLE = ", old.detalle, "\n ",
        "ESTATUS = ", v_estatus),
	DEFAULT,
	DEFAULT );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbd_detalles_productos`
--

DROP TABLE IF EXISTS `tbd_detalles_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbd_detalles_productos`
--

LOCK TABLES `tbd_detalles_productos` WRITE;
/*!40000 ALTER TABLE `tbd_detalles_productos` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbd_detalles_productos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`luz`@`%`*/ /*!50003 TRIGGER `tbd_detalles_productos_AFTER_INSERT` AFTER INSERT ON `tbd_detalles_productos` FOR EACH ROW BEGIN
DECLARE v_estatus varchar(20) default 'Activo';
if not new.estatus then
set v_estatus = 'Inactivo';
end if;
insert into tbi_bitacora values
(default,
current_user(),
'Create',
'tbd_detalles_productos',
concat_ws(' ', 'Se han insertado los dettales de un nuevo producto con los
siguientes datos:',
'ID: ', new.id, 
' ID PRODUCTO: ', new.producto_id, 
'DESCRIPCIÓN:',new.descripcion,
'VALOR: ', new.valor, 
'ESTATUS: ',new.estatus,
'ESTATUS: ',v_estatus,
"FECHA REGISTRO:", new.Fecha_Registro, 
"FECHA ACTUALIZACION", new.Fecha_Actualizacion), default, default
);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`luz`@`%`*/ /*!50003 TRIGGER `tbd_detalles_productos_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_detalles_productos` FOR EACH ROW BEGIN
SET NEW.Fecha_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`luz`@`%`*/ /*!50003 TRIGGER `tbd_detalles_productos_AFTER_UPDATE` AFTER UPDATE ON `tbd_detalles_productos` FOR EACH ROW BEGIN
DECLARE v_estatus_old varchar(20) default 'Activo';
declare v_estatus_new varchar(20) default 'Activo';
if not old.estatus then
set v_estatus_old = 'Inactivo';
end if;
if not new.estatus then
set v_estatus_new = 'Inactivo';
end if;
insert into tbi_bitacora values
(default,
current_user(),
'Update',
'tbd_detalles_productos',
concat_ws(' ', 'Se han editado los detalles de un nuevo producto con los
siguientes datos:',
'ID: ', old.id, 
'ID PRODUCTO: ', old.producto_id, 
'DESCRIPCIÓN:',old.descripcion,
'VALOR: ', old.valor, 
'ESTATUS: ',old.estatus,
'ESTATUS: ',v_estatus_old, '-', v_estatus_new ,
"FECHA REGISTRO:", old.Fecha_Registro, 
"FECHA ACTUALIZACION", old.Fecha_Actualizacion), default, default
);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`luz`@`%`*/ /*!50003 TRIGGER `tbd_detalles_productos_BEFORE_DELETE` BEFORE DELETE ON `tbd_detalles_productos` FOR EACH ROW BEGIN
DECLARE v_estatus varchar(20) default 'Activo';
if NOT OLD.estatus then
set v_estatus = 'Inactivo';
end if;
insert into tbi_bitacora values
(default,
current_user(),
'Delete',
'tbd_detalles_productos',
concat_ws(' ', 'Se han eliminado los detalles de un nuevo producto con los
siguientes datos:',
'ID: ', old.id, 
'ID PRODUCTO: ', old.producto_id, 
'DESCRIPCIÓN:',old.descripcion,
'VALOR: ', old.valor, 
'ESTATUS: ',old.estatus,
'ESTATUS: ',v_estatus ,
"FECHA REGISTRO:", old.Fecha_Registro, 
"FECHA ACTUALIZACION", old.Fecha_Actualizacion), default, default
);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbd_dietas`
--

DROP TABLE IF EXISTS `tbd_dietas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_dietas` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  `Detalle` int unsigned DEFAULT NULL,
  `Descripcion` text,
  `Objetivo` int unsigned DEFAULT NULL,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbd_dietas`
--

LOCK TABLES `tbd_dietas` WRITE;
/*!40000 ALTER TABLE `tbd_dietas` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbd_dietas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`emilio`@`%`*/ /*!50003 TRIGGER `tbb_dietas_AFTER_INSERT` AFTER INSERT ON `tbd_dietas` FOR EACH ROW BEGIN
	-- Declaración de variables
    DECLARE v_estatus varchar(20) default 'Activo';
    
    IF not new.estatus = b'1' then
        set v_estatus = "Inactiva";
    end if;

    -- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbd_dietas",
        CONCAT_WS(" ","Se ha insertado una nueva dieta con los siguientes datos: ",
        "NOMBRE = ", NEW.nombre, "\n ",
        "DETALLE = ", NEW.detalle, "\n ",
        "DESCRIPCIÓN = ", NEW.descripcion, "\n ",
        "ESTATUS = ", v_estatus, "\n ",
        "OBJETIVO = ", NEW.objetivo, "\n ",
        "Fecha registro = ", new.fecha_registro, "\n ",
        "Fecha Actualización = ", NEW.fecha_actualizacion ),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`emilio`@`%`*/ /*!50003 TRIGGER `tbc_dietas_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_dietas` FOR EACH ROW BEGIN
	set new.Fecha_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`emilio`@`%`*/ /*!50003 TRIGGER `tbc_dietas_AFTER_UPDATE` AFTER UPDATE ON `tbd_dietas` FOR EACH ROW BEGIN
	DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
    DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Inactivo'; 
    
    IF not NEW.estatus then
        set v_estatus_old = "Activo";
    end if;
    
    IF  not old.estatus then
        set v_estatus_new = "Activo";
    end if;

	insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Update' ,
		'tbd_dietas',
		concat_ws(" ","Se ha modificado una dieta existente con los siguientes datos: ",
        "Nombre = ", old.nombre, ' - ', new.nombre, "\n ",
        "DETALLE = ", old.detalle, ' - ', NEW.detalle, "\n ",
        "Descripción ID =", old.descripcion, ' - ', new.descripcion, "\n ",
        "ESTATUS = ", v_estatus_old, ' - ', v_estatus_new, "\n ",
        "OBJETIVO = ", old.objetivo, ' - ', NEW.objetivo),
	DEFAULT,
	DEFAULT);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`emilio`@`%`*/ /*!50003 TRIGGER `tbc_dietas_BEFORE_DELETE` BEFORE DELETE ON `tbd_dietas` FOR EACH ROW BEGIN
	DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    IF  not OLD.estatus then
        set v_estatus = "Inactiva";
    end if; 
    insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Delete' ,
		'tbd_dietas',
		CONCAT_WS(" ","Se ha eliminado una dieta con el id",old.id, "\n los siguientes datos: ",
        "NOMBRE = ", old.nombre, "\n ",
        "DETALLE = ", old.detalle, "\n ",
        "Descripción =", old.descripcion, "\n ",
        "ESTATUS = ", v_estatus, "\n ",
        "OBJETIVO = ", old.objetivo),
	DEFAULT,
	DEFAULT );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbd_ejercicios_rutinas`
--

DROP TABLE IF EXISTS `tbd_ejercicios_rutinas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
  KEY `fk_rutinas_1_idx` (`Rutina_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbd_ejercicios_rutinas`
--

LOCK TABLES `tbd_ejercicios_rutinas` WRITE;
/*!40000 ALTER TABLE `tbd_ejercicios_rutinas` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbd_ejercicios_rutinas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`marinho`@`%`*/ /*!50003 TRIGGER `tbd_ejercicios_rutinas_AFTER_INSERT` AFTER INSERT ON `tbd_ejercicios_rutinas` FOR EACH ROW BEGIN
DECLARE v_nombre_rutina VARCHAR(100) DEFAULT (SELECT Nombre FROM tbd_usuarios WHERE id = new.Rutina_ID);
DECLARE v_nombre_ejercicio VARCHAR(100) DEFAULT (SELECT Nombre FROM tbc_ejercicios WHERE id = new.Ejercicio_ID);
-- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbd_ejercicios_rutinas",
        CONCAT_WS(" ","Se ha insertado una nueva RUTINA-EJERCICIOS con los siguientes datos:",
		" N.Ejercicio =", v_nombre_ejercicio,
        " N.Rutina =", v_nombre_rutina,
        " Cantidad =", new.Cantidad,
        " Tipo =", new.Tipo,
        " Observaciones =", new.Observaciones, 
		" Fecha Registro =", new.Fecha_Registro, 
        " Fecha Actualizacion =", new.Fecha_Actualizacion,
        " Estatus =", new.Estatus),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`marinho`@`%`*/ /*!50003 TRIGGER `tbd_ejercicios_rutinas_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_ejercicios_rutinas` FOR EACH ROW BEGIN
	set new.Fecha_Actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`marinho`@`%`*/ /*!50003 TRIGGER `tbd_ejercicios_rutinas_AFTER_UPDATE` AFTER UPDATE ON `tbd_ejercicios_rutinas` FOR EACH ROW BEGIN
    DECLARE v_nombre_ejercicio_old VARCHAR(100) DEFAULT (SELECT Nombre FROM tbc_ejercicios WHERE id = old.Ejercicio_ID);
    DECLARE v_nombre_ejercicio_new VARCHAR(100) DEFAULT (SELECT Nombre FROM tbc_ejercicios WHERE id = new.Ejercicio_ID);
    DECLARE v_nombre_rutina_old VARCHAR(100) DEFAULT (SELECT Nombre FROM tbd_rutinas WHERE id = old.Rutina_ID);
    DECLARE v_nombre_rutina_new VARCHAR(100) DEFAULT (SELECT Nombre FROM tbd_rutinas WHERE id = new.Rutina_ID);
    
    -- Validamos el estatus para asignarle su valor textual
    -- IF NOT old.estatus THEN
    -- SET v_estatus= "Inactivo";
	-- END IF;
    
-- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Update",
        "tbd_ejercicios_rutinas",
        CONCAT_WS(" ","Se ha actualizado una RUTINA-EJERCICIOS con los siguientes datos:",
		" N.Ejercicio =", v_nombre_ejercicio_old, "al Nombre", v_nombre_ejercicio_new,
        " N.Rutina =", v_nombre_rutina_old, "al Nombre", v_nombre_rutina_new,
        " Cantidad =", old.Cantidad, " - ", new.Cantidad,
        " Tipo =", old.Tipo, " - ", new.Tipo,
        " Observaciones =", old.Observaciones, " - ", new.Observaciones,
		" Fecha Registro =", old.Fecha_Registro, " - ", new.Fecha_Registro,
        " Fecha Actualizacion =", old.Fecha_Actualizacion, " - ", new.Fecha_Actualizacion,
        " Estatus =", old.Estatus, " - ", new.Estatus),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`marinho`@`%`*/ /*!50003 TRIGGER `tbd_ejercicios_rutinas_AFTER_DELETE` AFTER DELETE ON `tbd_ejercicios_rutinas` FOR EACH ROW BEGIN
	DECLARE v_nombre_ejercicio_old VARCHAR(100) DEFAULT (SELECT Nombre FROM tbc_ejercicios WHERE id = old.Ejercicio_ID);
    DECLARE v_nombre_rutina_old VARCHAR(100) DEFAULT (SELECT Nombre FROM tbd_rutinas WHERE id = old.Rutina_ID);
    
    -- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Delete",
        "tbd_ejercicios_rutinas",
        CONCAT_WS(" ","Se ha eliminado una nueva RUTINA-EJERCICIOS con los siguientes datos:",
		" N.Ejercicio =", v_nombre_ejercicio_old,
        " N.Rutina =", v_nombre_rutina_old,
        " Cantidad =", old.Cantidad,
        " Tipo =", old.Tipo,
        " Observaciones =", old.Observaciones, 
		" Fecha Registro =", old.Fecha_Registro, 
        " Fecha Actualizacion =", old.Fecha_Actualizacion,
        " Estatus =", old.Estatus),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbd_evaluaciones_servicios`
--

DROP TABLE IF EXISTS `tbd_evaluaciones_servicios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_evaluaciones_servicios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario` varchar(50) NOT NULL,
  `servicio` enum('Servicio de nutrición','Horarios y Precios','Comunidad','Programas de entrenamiento') NOT NULL,
  `calificacion` int NOT NULL,
  `criterio` text NOT NULL,
  `fecha_registro` datetime NOT NULL,
  `estatus` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbd_evaluaciones_servicios`
--

LOCK TABLES `tbd_evaluaciones_servicios` WRITE;
/*!40000 ALTER TABLE `tbd_evaluaciones_servicios` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbd_evaluaciones_servicios` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`lorena`@`%`*/ /*!50003 TRIGGER `tbd_evaluaciones_servicios_AFTER_INSERT` AFTER INSERT ON `tbd_evaluaciones_servicios` FOR EACH ROW BEGIN
DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    -- Verificamos si el estatus del servicio para ubicar el valor en la descripción de la bitácora
    IF NOT NEW.estatus THEN
        SET v_estatus = "Inactivo";
    END IF;
    
    -- Insertar en la bitácora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "evaluacionServicio",
        CONCAT_WS(" ","Se ha insertado una nueva evaluación de servicio con los siguientes datos: ",
            "USUARIO = ", NEW.usuario,
            "SERVICIO = ", NEW.servicio,
            "CALIFICACION = ", NEW.calificacion,
            "CRITERIO = ", NEW.criterio,
            "FECHA DE REGISTRO = ", NEW.fecha_registro,
            "ESTATUS = ", v_estatus),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`lorena`@`%`*/ /*!50003 TRIGGER `tbd_evaluaciones_servicios` BEFORE UPDATE ON `tbd_evaluaciones_servicios` FOR EACH ROW BEGIN
	SET NEW.fecha_registro = CURRENT_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`lorena`@`%`*/ /*!50003 TRIGGER `tbd_evaluaciones_servicios_BEFORE_DELETE` BEFORE DELETE ON `tbd_evaluaciones_servicios` FOR EACH ROW BEGIN
DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    IF NOT OLD.estatus THEN
        SET v_estatus = "Inactivo";
    END IF;
    
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        CURRENT_USER(),
        'Delete',
        'evaluacionServicio',
        CONCAT_WS(" ","Se ha eliminado una evaluación de servicio con los siguientes datos: ",
            "Usuario = ", OLD.usuario,
            "Servicio = ", OLD.servicio,
            "Calificación = ", OLD.calificacion,
            "Criterio = ", OLD.criterio,
            "Fecha de registro = ", OLD.fecha_registro,
            "Estatus = ", v_estatus),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbd_horarios`
--

DROP TABLE IF EXISTS `tbd_horarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_horarios` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Usuario` int NOT NULL,
  `Tipo` varchar(50) NOT NULL,
  `Fecha_Inicio` datetime NOT NULL,
  `Fecha_Fin` datetime NOT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Estatus` varchar(50) NOT NULL,
  `Empleado` int NOT NULL,
  `Sucursal` int NOT NULL,
  `Servicio` int NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbd_horarios`
--

LOCK TABLES `tbd_horarios` WRITE;
/*!40000 ALTER TABLE `tbd_horarios` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbd_horarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`alejandro`@`%`*/ /*!50003 TRIGGER `tbd_horarios_AFTER_INSERT` AFTER INSERT ON `tbd_horarios` FOR EACH ROW BEGIN
INSERT INTO tbi_bitacora VALUES(
		DEFAULT,
        USER(),
        "Create",
        "horarios",
        CONCAT_WS(" ","Se ha insertado una nuevo horario con los siguientes datos: ",
        "ID = ",new.ID,
        "Usuario = ",new.Usuario,
        "Tipo = ",new.Tipo,
        "Fecha Inicio = ",NEW.Fecha_Inicio, 
        "Fecha Fin = ",NEW.Fecha_Fin, 
        "Fecha Registro = ",NEW.Fecha_Registro, 
        "Estatus = ",NEW.Estatus, 
        "Empleado = ",NEW.Empleado, 
        "Sucursal = ",NEW.Sucursal, 
        "Servicio = ",NEW.Servicio),        
        NOW(),
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`alejandro`@`%`*/ /*!50003 TRIGGER `tbd_horarios_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_horarios` FOR EACH ROW BEGIN
set new.fecha_registro = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`alejandro`@`%`*/ /*!50003 TRIGGER `tbd_horarios_AFTER_UPDATE` AFTER UPDATE ON `tbd_horarios` FOR EACH ROW BEGIN
INSERT INTO tbi_bitacora VALUES(
		DEFAULT,
        USER(),
        "Update",
        "horario",
        CONCAT_WS(" ","Se ha actualizado un horario con los siguientes datos: ",
        "ID = ",new.ID,
        "Usuario = ",old.Usuario," - ",new.Usuario,
        "Tipo = ",old.Tipo," - ",new.Tipo,
        "Fecha Inicio = ",old.Fecha_Inicio," - ",NEW.Fecha_Inicio, 
        "Fecha Fin = ",old.Fecha_Fin," - ",NEW.Fecha_Fin, 
        "Fecha Registro = ",old.Fecha_Registro," - ",NEW.Fecha_Registro, 
        "Estatus = ",old.Estatus," - ",NEW.Estatus, 
        "Empleado = ",old.Empleado," - ",NEW.Empleado, 
        "Sucursal = ",old.Sucursal," - ",NEW.Sucursal, 
        "Servicio = ",old.Servicio," - ",NEW.Servicio),        
        NOW(),
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`alejandro`@`%`*/ /*!50003 TRIGGER `tbd_horarios_BEFORE_DELETE` BEFORE DELETE ON `tbd_horarios` FOR EACH ROW BEGIN
	INSERT INTO tbi_bitacora VALUES(
		DEFAULT,
        USER(),
        "Delete",
        "horario",
        CONCAT_WS(" ","Se ha eliminado el horario con el ID: ",old.ID),
        NOW(),
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbd_objetivos_dietas`
--

DROP TABLE IF EXISTS `tbd_objetivos_dietas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_objetivos_dietas` (
  `Dieta_id` int unsigned NOT NULL,
  `Objetivo` text NOT NULL,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_actualizacion` datetime DEFAULT NULL,
  KEY `fk_dieta_1_idx` (`Dieta_id`),
  CONSTRAINT `fk_dieta_1` FOREIGN KEY (`Dieta_id`) REFERENCES `tbd_dietas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbd_objetivos_dietas`
--

LOCK TABLES `tbd_objetivos_dietas` WRITE;
/*!40000 ALTER TABLE `tbd_objetivos_dietas` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbd_objetivos_dietas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`emilio`@`%`*/ /*!50003 TRIGGER `tbd_objetivo_dieta_AFTER_INSERT` AFTER INSERT ON `tbd_objetivos_dietas` FOR EACH ROW BEGIN
	-- Declaración de variables
    DECLARE v_estatus varchar(20) default 'Activo';
    
    IF not new.estatus = b'1' then
        set v_estatus = "Inactiva";
    end if;

    -- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbd_objetivos_dietas",
        CONCAT_WS(" ","Se ha insertado un nuevo objetivo de dieta con el id",NEW.Dieta_id, "\n los siguientes datos: ",
        "OBJETIVO = ", NEW.objetivo, "\n ",
        "ESTATUS = ", v_estatus, "\n ",
        "Fecha registro = ", new.fecha_registro, "\n ",
        "Fecha Actualización = ", NEW.fecha_actualizacion ),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`emilio`@`%`*/ /*!50003 TRIGGER `tbd_objetivo_dieta_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_objetivos_dietas` FOR EACH ROW BEGIN
	set new.Fecha_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`emilio`@`%`*/ /*!50003 TRIGGER `tbd_objetivo_dieta_AFTER_UPDATE` AFTER UPDATE ON `tbd_objetivos_dietas` FOR EACH ROW BEGIN
	DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
    DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Inactivo'; 
    
    IF not NEW.estatus then
        set v_estatus_old = "Activo";
    end if;
    
    IF  not old.estatus then
        set v_estatus_new = "Activo";
    end if;

	insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Update' ,
		'tbd_objetivos_dietas',
		concat_ws(" ","Se ha modificado un objetivo de dieta con el id",NEW.Dieta_id, "\n los siguientes datos: ",
        "OBJETIVO = ", old.objetivo, ' - ', NEW.objetivo, "\n "
        "ESTATUS = ", v_estatus_old, ' - ', v_estatus_new),
	DEFAULT,
	DEFAULT);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`emilio`@`%`*/ /*!50003 TRIGGER `tbd_objetivo_dieta_BEFORE_DELETE` BEFORE DELETE ON `tbd_objetivos_dietas` FOR EACH ROW BEGIN
	DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    IF  not OLD.estatus then
        set v_estatus = "Inactiva";
    end if; 
    insert into tbi_bitacora values(
		DEFAULT,current_user(),
		'Delete' ,
		'tbd_objetivos_dietas',
		CONCAT_WS(" ","Se ha eliminado un objetivo de dieta con el id",old.Dieta_id, "\n los siguientes datos: ",
        "OBJETIVO = ", old.objetivo, "\n ",
        "ESTATUS = ", v_estatus),
	DEFAULT,
	DEFAULT );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbd_opiniones_clientes`
--

DROP TABLE IF EXISTS `tbd_opiniones_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_opiniones_clientes` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `usuario_id` int unsigned NOT NULL,
  `descripcion` text NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `respuesta` text,
  `estatus` enum('Cancelado','Registrado','Abierto','Atendida') NOT NULL DEFAULT 'Atendida',
  `registro_fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `registro_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Atencion_personal` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `usuario_id_idx` (`usuario_id`),
  KEY `Atencion_personal_idx` (`Atencion_personal`),
  CONSTRAINT `Atencion_personal` FOREIGN KEY (`Atencion_personal`) REFERENCES `tbb_personas` (`ID`),
  CONSTRAINT `usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `tbb_usuarios` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbd_opiniones_clientes`
--

LOCK TABLES `tbd_opiniones_clientes` WRITE;
/*!40000 ALTER TABLE `tbd_opiniones_clientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbd_opiniones_clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbd_preguntas`
--

DROP TABLE IF EXISTS `tbd_preguntas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_preguntas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pregunta` text NOT NULL,
  `respuesta` text NOT NULL,
  `categoria` varchar(255) NOT NULL,
  `persona_id` int unsigned NOT NULL,
  `estatus` enum('Atendida','Registrada','Cancelada','Pendiente') NOT NULL DEFAULT 'Atendida',
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `persona_id_idx` (`persona_id`),
  CONSTRAINT `persona_id` FOREIGN KEY (`persona_id`) REFERENCES `tbb_personas` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbd_preguntas`
--

LOCK TABLES `tbd_preguntas` WRITE;
/*!40000 ALTER TABLE `tbd_preguntas` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbd_preguntas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbd_programas_saludables`
--

DROP TABLE IF EXISTS `tbd_programas_saludables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_programas_saludables` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(250) NOT NULL,
  `Usuario_ID` int unsigned NOT NULL,
  `Instructor_ID` int unsigned NOT NULL,
  `Fecha_Creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Estatus` enum('Registrado','Sugerido','Aprobado por el Médico','Aprobado por el Usuario','Rechazado por el Médico','Rechazado por el Usuario','Terminado','Suspendido','Cancelado') NOT NULL DEFAULT 'Registrado',
  `Duracion` varchar(80) NOT NULL,
  `Porcentaje_Avance` decimal(5,2) NOT NULL DEFAULT '0.00',
  `Fecha_Ultima_Actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbd_programas_saludables`
--

LOCK TABLES `tbd_programas_saludables` WRITE;
/*!40000 ALTER TABLE `tbd_programas_saludables` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbd_programas_saludables` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`morales`@`%`*/ /*!50003 TRIGGER `tbd_programas_saludables_AFTER_INSERT` AFTER INSERT ON `tbd_programas_saludables` FOR EACH ROW BEGIN
INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbd_programas_saludables",
        CONCAT_WS(" ","Se ha insertado una nueva relación de PROGRAMAS SALUDABLES con el ID: ",NEW.ID, 
        "con los siguientes datos: ",
        "NOMBRE = ", NEW.Nombre,
        "USUARIO ID = ", new.Usuario_ID,
        "INSTRUCTOR ID = ",  NEW.Instructor_ID,
        "FECHA DE CREACIÓN = ", NEW.Fecha_Creacion,
		"ESTATUS = ", NEW.Estatus,
        "DURACIÓN = ", NEW.Duracion, 
        "PORCENTAJE DE AVANCE = ", NEW.Porcentaje_Avance,
        "FECHA DE ULTIMA ACTUALIZACIÓN = ", NEW.Fecha_Ultima_Actualizacion),
        NOW(),
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`morales`@`%`*/ /*!50003 TRIGGER `tbd_programas_saludables_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_programas_saludables` FOR EACH ROW BEGIN
set new.fecha_ultima_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`morales`@`%`*/ /*!50003 TRIGGER `tbd_programas_saludables_AFTER_UPDATE` AFTER UPDATE ON `tbd_programas_saludables` FOR EACH ROW BEGIN
 INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Update",
        "tbd_programas_saludables",
        CONCAT_WS(" ","Se han actualizado los datos de la relación PROGRAMAS SALUDABLES con el ID: ",NEW.ID,
        "con los siguientes datos:",
        "NOMBRE = ", OLD.nombre, "cambio a", NEW.nombre,
        "USUARIO ID = ", old.Usuario_ID, "cambio a", NEW.Usuario_ID,
        "INSTRUCTOR ID =",OLD.Instructor_ID,"cambio a", NEW.Instructor_ID,
        "FECHA DE CREACIÓN = ", OLD.fecha_creacion, "cambio a", NEW.fecha_creacion,
        "ESTATUS = ", OLD.estatus, "cambio a", NEW.estatus,
        "DURACIÓN = ", OLD.duracion, "cambio a", NEW.duracion,
        "PORCENTAJE DE AVANCE = ", OLD.porcentaje_avance, "cambio a", NEW.porcentaje_avance,
        "FECHA DE ULTIMA ACTUALIZACIÓN = ", OLD.fecha_ultima_actualizacion, "cambio a", NEW.fecha_ultima_actualizacion),
        NOW(),
        DEFAULT       
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`morales`@`%`*/ /*!50003 TRIGGER `tbd_programas_saludables_AFTER_DELETE` AFTER DELETE ON `tbd_programas_saludables` FOR EACH ROW BEGIN
INSERT INTO tbi_bitacora VALUES(
		DEFAULT,
        USER(),
        "Delete",
        "tbd_programas_saludables",
        CONCAT_WS(" ","Se ha eliminado una relación en PROGRAMAS SALUDABLES con el ID: ", OLD.ID),
        now(),
        DEFAULT
    );
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbd_rutinas`
--

DROP TABLE IF EXISTS `tbd_rutinas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
  KEY `fk_programa_saludable_idx` (`Programa_Saludable_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbd_rutinas`
--

LOCK TABLES `tbd_rutinas` WRITE;
/*!40000 ALTER TABLE `tbd_rutinas` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbd_rutinas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`marinho`@`%`*/ /*!50003 TRIGGER `tbd_rutinas_AFTER_INSERT` AFTER INSERT ON `tbd_rutinas` FOR EACH ROW BEGIN
-- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbd_rutinas",
        CONCAT_WS(" ","Se ha insertado una nueva RUTINA con los siguientes datos:",
		" Nombre =", new.Nombre,
        " Programa_Saludable_ID =", new.Programa_Saludable_ID,
        " Fecha Registro =", new.Fecha_Registro,
        " Fecha Actualizacion =", new.Fecha_Actualizacion, 
		" Tiempo Aproximado =", new.Tiempo_Aproximado, 
        " Estatus =", new.estatus,
        " Resultados Esperados =", new.Resultados_Esperados),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`marinho`@`%`*/ /*!50003 TRIGGER `tbd_rutinas_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_rutinas` FOR EACH ROW BEGIN
	set new.Fecha_Actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`marinho`@`%`*/ /*!50003 TRIGGER `tbd_rutinas_AFTER_UPDATE` AFTER UPDATE ON `tbd_rutinas` FOR EACH ROW BEGIN
-- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Update",
        "tbd_rutinas",
        CONCAT_WS(" ","Se ha actualizado una RUTINA con los siguientes datos:",
		" Nombre =", old.Nombre, '-', new.Nombre,
        " Programa_Saludable_ID =", old.Programa_Saludable_ID, '-', new.Programa_Saludable_ID,
        " Fecha Registro =", old.Fecha_Registro, '-', new.Fecha_Registro,
        " Fecha Actualizacion =", old.Fecha_Actualizacion, '-', new.Fecha_Actualizacion, 
		" Tiempo Aproximado =", old.Tiempo_Aproximado, '-', new.Tiempo_Aproximado, 
        " Estatus =",  old.estatus, '-', new.estatus,
        " Resultados Esperados =", old.Resultados_Esperados, '-', new.Resultados_Esperados),
        DEFAULT,
        DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`marinho`@`%`*/ /*!50003 TRIGGER `tbd_rutinas_AFTER_DELETE` AFTER DELETE ON `tbd_rutinas` FOR EACH ROW BEGIN
DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
 INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Delete",
        "tbd_rutinas",
        CONCAT_WS(" ","Se ha eliminado una RUTINA con los siguientes datos:",
        " Nombre =", old.Nombre,
        " Programa_Saludable_ID =", old.Programa_Saludable_ID,
        " Fecha Registro =", old.Fecha_Registro,
        " Fecha Actualizacion =", old.Fecha_Actualizacion, 
		" Tiempo Aproximado =", old.Tiempo_Aproximado, 
        " Estatus =", old.estatus,
        " Resultados Esperados =", old.Resultados_Esperados),
        DEFAULT,
        DEFAULT
	);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbd_servicios_al_cliente`
--

DROP TABLE IF EXISTS `tbd_servicios_al_cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_servicios_al_cliente` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_persona` int unsigned NOT NULL,
  `id_empleado` int unsigned NOT NULL,
  `tipo_servicio` enum('Consulta','reclamo','Sugerencia') NOT NULL,
  `descripcion` text NOT NULL,
  `comentarios` text,
  `estatus` bit(1) DEFAULT b'1',
  `fecha_registro` date NOT NULL,
  `fecha_actualizacion` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_persona` (`id_persona`),
  KEY `id_empleado` (`id_empleado`),
  CONSTRAINT `tbd_servicios_al_cliente_ibfk_1` FOREIGN KEY (`id_persona`) REFERENCES `tbb_personas` (`ID`),
  CONSTRAINT `tbd_servicios_al_cliente_ibfk_2` FOREIGN KEY (`id_empleado`) REFERENCES `tbb_personas` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbd_servicios_al_cliente`
--

LOCK TABLES `tbd_servicios_al_cliente` WRITE;
/*!40000 ALTER TABLE `tbd_servicios_al_cliente` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbd_servicios_al_cliente` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`adan`@`%`*/ /*!50003 TRIGGER `tbd_servicios_al_cliente_AFTER_INSERT` AFTER INSERT ON `tbd_servicios_al_cliente` FOR EACH ROW BEGIN
 DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    IF NOT new.estatus = b'1' THEN
        SET v_estatus = 'Inactivo';
    END IF;
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT, -- ID
        current_user(), -- Usuario
        "Create", -- Operación
        "tbd_servicios_al_cliente", -- Tabla
        CONCAT_WS(" ", "Se ha insertado un nuevo servicio al cliente con los siguientes datos", -- Desde aquí
        "ID de la persona: ", new.id_persona,
        "ID del empleado: ", new.id_empleado, 
        "Tipo de Servicio: ", new.tipo_servicio,
        "Descripción: ", new.descripcion,
        "Comentarios: ", new.comentarios,
        "Fecha Registro: ", new.fecha_registro,
        "Fecha Actualización: ", new.fecha_actualizacion,
        "Estatus: ", v_estatus ), -- Hasta aquí -> Descripción 
        DEFAULT, -- Fecha registro 
        default -- Estatus
    );

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`adan`@`%`*/ /*!50003 TRIGGER `tbd_servicios_al_cliente_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_servicios_al_cliente` FOR EACH ROW BEGIN
SET new.fecha_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`adan`@`%`*/ /*!50003 TRIGGER `tbd_servicios_al_cliente_AFTER_UPDATE` AFTER UPDATE ON `tbd_servicios_al_cliente` FOR EACH ROW BEGIN
DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Activo';

-- Validaciones para las etiquetas del estatus

IF NOT old.estatus THEN
SET v_estatus_old = 'Inactivo';
END IF;

IF NOT new.estatus THEN
SET v_estatus_new = 'Inactivo';
END IF;

INSERT INTO tbi_bitacora VALUES(
DEFAULT, -- ID
current_user(), -- Usuario
'Update', -- Operación 
'tbd_servicios_al_cliente', -- Tabla
CONCAT_WS(' ','Se ha modificado Servicio al cliente prestado con los siguientes datos:', -- Desde Aquí
'ID de quien solicitó el servicio: ', old.id_persona, ' a pasado a: ', new.id_persona, ' - ',-- Id persona (Cliente)
'Tipo de servicio: ', old.tipo_servicio, ' a pasado a: ', new.tipo_servicio, ' - ',-- Tipo de servicio
'Descripción: ', old.descripcion,' a pasado a: ',new.descripcion,' - ', -- Descripción
'comentarios: ', old.comentarios,' a pasado a: ',new.comentarios,' - ', -- Comentarios
'Fecha actualización: ', old.fecha_actualizacion,' a pasado a: ',new.fecha_actualizacion,' - ', -- Fecha de Actualización
'Estatus: ', v_estatus_new 
), --   Hasta Aquí -> Descripción
DEFAULT, -- Fecha Registro
default -- Estatus
);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`adan`@`%`*/ /*!50003 TRIGGER `tbd_servicios_al_cliente_AFTER_DELETE` AFTER DELETE ON `tbd_servicios_al_cliente` FOR EACH ROW BEGIN


DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';

IF not OLD.estatus then 
set v_estatus = 'Inactiva';
END IF;

INSERT INTO tbi_bitacora VALUES(
default, -- ID 
current_user(), -- Usuario
'Delete', -- Operación 
'tbd_servicios_al_cliente', -- Tabla
CONCAT_WS(" ", "Se ha eliminado un rol de usuario con los siguientes dato: ",' - ', -- Desde Aquí
'ID de quien solicitó el servicio: ', old.id_persona, -- Id persona (quien solicitó el servicio)
'Tipo de servicio: ', old.tipo_servicio,' - ',-- Tipo de servicio
'Descripción: ', old.descripcion,' - ', -- Descripción
'comentarios: ', old.comentarios,' - ', -- Comentarios
'Fecha actualización: ', old.fecha_actualizacion,' - ', -- Fecha de Actualización
'Estatus: ', v_estatus), -- Hasta aquí -> Descripción
default, -- Fecha Registro
b'0' -- Estatus
);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbd_usuarios_roles`
--

DROP TABLE IF EXISTS `tbd_usuarios_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_usuarios_roles` (
  `Usuario_ID` int unsigned NOT NULL,
  `Rol_ID` int unsigned NOT NULL,
  `Estatus` bit(1) DEFAULT b'1',
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`Usuario_ID`,`Rol_ID`),
  KEY `Rol_ID` (`Rol_ID`),
  CONSTRAINT `tbd_usuarios_roles_ibfk_1` FOREIGN KEY (`Usuario_ID`) REFERENCES `tbb_usuarios` (`ID`),
  CONSTRAINT `tbd_usuarios_roles_ibfk_2` FOREIGN KEY (`Rol_ID`) REFERENCES `tbc_roles` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbd_usuarios_roles`
--

LOCK TABLES `tbd_usuarios_roles` WRITE;
/*!40000 ALTER TABLE `tbd_usuarios_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbd_usuarios_roles` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbd_usuarios_roles_AFTER_INSERT` AFTER INSERT ON `tbd_usuarios_roles` FOR EACH ROW BEGIN
	DECLARE v_email_usuario VARCHAR(60) DEFAULT (SELECT correo_electronico FROM 
    tbb_usuarios WHERE id = new.usuario_id);
    DECLARE v_nombre_rol VARCHAR(50) DEFAULT (SELECT nombre FROM 
    tbc_roles WHERE id = new.rol_id);
    DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    -- Validamos el estatus para asignarle su valor textual
    IF NOT new.estatus THEN
     SET v_estatus= "Inactivo";
	END IF;
    
    
INSERT INTO tbi_bitacora VALUES
    (DEFAULT,
    current_user(), 
    'Create', 
    'tbd_usuarios_roles', 
    CONCAT_WS(' ','Se le ha asignado el ROL de :',
    v_nombre_rol,  ' al USUARIO con CORREO ELECTRÓNICO: ', v_email_usuario, 
    'y el ESTATUS: ', v_estatus),DEFAULT, DEFAULT);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbd_usuarios_roles_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_usuarios_roles` FOR EACH ROW BEGIN
SET new.fecha_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbd_usuarios_roles_AFTER_UPDATE` AFTER UPDATE ON `tbd_usuarios_roles` FOR EACH ROW BEGIN
	DECLARE v_email_usuario VARCHAR(60) DEFAULT (SELECT correo_electronico FROM 
    tbb_usuarios WHERE id = old.usuario_id);
    DECLARE v_nombre_rol_old VARCHAR(50) DEFAULT (SELECT nombre FROM 
    tbc_roles WHERE id = old.rol_id);
    DECLARE v_nombre_rol_new VARCHAR(50) DEFAULT (SELECT nombre FROM 
    tbc_roles WHERE id = new.rol_id);
    DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    -- Validamos el estatus para asignarle su valor textual
    IF NOT old.estatus THEN
     SET v_estatus= "Inactivo";
	END IF;
    
    
INSERT INTO tbi_bitacora VALUES
    (DEFAULT,
    current_user(), 
    'Update', 
    'tbd_usuarios_roles', 
    CONCAT_WS(' ','Se le actualizado el ROL de :',
    v_nombre_rol_old, ' a: ', v_nombre_rol_new,  ' al USUARIO con CORREO ELECTRÓNICO: ', v_email_usuario, 
    'y el ESTATUS: ', v_estatus),DEFAULT, DEFAULT);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tbd_usuarios_roles_AFTER_DELETE` AFTER DELETE ON `tbd_usuarios_roles` FOR EACH ROW BEGIN
	DECLARE v_email_usuario VARCHAR(60) DEFAULT (SELECT correo_electronico FROM 
    tbb_usuarios WHERE id = old.usuario_id);
    DECLARE v_nombre_rol VARCHAR(50) DEFAULT (SELECT nombre FROM 
    tbc_roles WHERE id = old.rol_id);
    DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    -- Verificamos el estatus del rol , para ubicar el valor en la descripción 
    -- de la bitácora
    IF NOT old.estatus THEN 
      SET v_estatus = 'Inactivo';
	END IF; 

INSERT INTO tbi_bitacora VALUES
    (DEFAULT,
    current_user(), 
    'Delete', 
    'tbd_usuarios_roles', 
    CONCAT_WS(' ','Se ha eliminado un rol de usuario: ',v_nombre_rol, ' al usuario con correo electrónico:', v_email_usuario, '.'),
    DEFAULT, DEFAULT);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbd_valoraciones_nutricionales`
--

DROP TABLE IF EXISTS `tbd_valoraciones_nutricionales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbd_valoraciones_nutricionales` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_miembro` int NOT NULL,
  `id_indicador_nutricional` int NOT NULL,
  `id_pregunta_nutricional` int NOT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT NULL,
  `valor` text,
  `comentarios` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbd_valoraciones_nutricionales`
--

LOCK TABLES `tbd_valoraciones_nutricionales` WRITE;
/*!40000 ALTER TABLE `tbd_valoraciones_nutricionales` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbd_valoraciones_nutricionales` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`adalid`@`%`*/ /*!50003 TRIGGER `tbd_valoracion_nutricional_AFTER_INSERT` AFTER INSERT ON `tbd_valoraciones_nutricionales` FOR EACH ROW BEGIN
	INSERT INTO tbi_bitacora VALUES(
	DEFAULT,
	USER(),
	"Create"
	"valoracion_nutricional",
	CONCAT_WS("","Se ha registrado una nueva evaluación nutricional con los siguientes datos: ",
    "ID =", NEW.id,
    "ID_MIEMBRO", NEW.id_miembro,
    "ID_INDICADOR_NUTRICIONAL =",NEW.id_indicador_nutricional,
    "ID_PREGUNTA_NIUTRICIOMAL =",NEW.id_pregunta_nutricional,
    "FECHA_REGISTRO =", new.fecha_registro,
	"VALOR =",NEW.valor,
	"COMENTARIOS =",new.comentarios),
	DEFAULT,
	DEFAULT
);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`adalid`@`%`*/ /*!50003 TRIGGER `tbd_valoracion_nutricional_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_valoraciones_nutricionales` FOR EACH ROW BEGIN
	set new.fecha_actualizacion = current_timestamp();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`adalid`@`%`*/ /*!50003 TRIGGER `tbd_valoracion_nutricional_AFTER_UPDATE` AFTER UPDATE ON `tbd_valoraciones_nutricionales` FOR EACH ROW BEGIN
	insert into tbi_bitacora values(
	DEFAULT,
	current_user(),
	'Update'
	"valoracion_nutricional",
	CONCAT_WS(" ","Se ha modificado una nueva evaluación nutricional con los siguientes datos:",
	"ID =",NEW.id,
	"ID_MIEMBRO = ",old.id_miembro,"--",NEW.id_miembro,
	"ID_INDICADOR_NUTRTCIONAL =", old.id_indicador_nutricional,"--",new.id_Indicador_nutricional,
	"ID_PREGUNTA_NUTRICIONAL =",old.id_pregunta_nutricional,"--",new.id_pregunta_nutricional,
	"VALOR = ", old.valor,"--",NEW.valor,
	"COMENTARIOS =", old.comentarios,"--",NEW.comentarios),
	DEFAULT,
	DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`adalid`@`%`*/ /*!50003 TRIGGER `tbd_valoracion_nutricional_BEFORE_DELETE` BEFORE DELETE ON `tbd_valoraciones_nutricionales` FOR EACH ROW BEGIN
	insert into tbb_bitacora values(
	DEFAULT,
	current_user(),
	"Delete"
	"valoracion_nutricional",
	CONCAT_WS(" ","Se ha eliminado una valoracion nutricional con los siguientes datos：",
	"ID = ", old.id,
	"ID_MIEMBRO = ",old.id_miembro,
	"ID_INDICADOR_NUTRICIONAL = ", old.id_indicador_nutricional,
    "ID_PREGUNTA_NUTRICIONAL = ", old.id_pregunta_nutricional,
    "VALOR = ", old.valor,
	"COMENTARIOS =",old.comentarios),
	DEFAULT,
	DEFAULT
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbi_bitacora`
--

DROP TABLE IF EXISTS `tbi_bitacora`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbi_bitacora` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Usuario` varchar(50) NOT NULL,
  `Operacion` enum('Create','Read','Update','Delete') NOT NULL,
  `Tabla` varchar(50) NOT NULL,
  `Descripcion` text NOT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Estatus` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `id` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbi_bitacora`
--

LOCK TABLES `tbi_bitacora` WRITE;
/*!40000 ALTER TABLE `tbi_bitacora` DISABLE KEYS */;
INSERT INTO `tbi_bitacora` VALUES (1,'amisadai@%','Delete','tbc_puestos','Se ha eliminado un puesto con los siguientes datos: NOMBRE = Gerente DESCRIPCIÓN = Empleado responsable de la Sucursal del Gimnasio. SALARIO = 22300.00 REQUISITOS = Carrera Universitaria, Habilidades Informática y Trabajo en Equipo. ESTATUS = Activo FECHA REGISTRO = 2024-07-12 15:33:35 FECHA ACTUALIZACION =','2024-07-16 13:22:50',_binary ''),(2,'amisadai@%','Delete','tbc_puestos','Se ha eliminado un puesto con los siguientes datos: NOMBRE = Entrenador DESCRIPCIÓN = Empleado responsable de acompañar al cliente en sus programas saludables SALARIO = 12500.00 REQUISITOS = Experiencia en Couching, Desempeño Físico y Primeros Auxilios ESTATUS = Activo FECHA REGISTRO = 2024-07-12 15:33:35 FECHA ACTUALIZACION =','2024-07-16 13:22:50',_binary ''),(3,'amisadai@%','Delete','tbc_puestos','Se ha eliminado un puesto con los siguientes datos: NOMBRE = Nutriologo DESCRIPCIÓN = Empleado responsable en dietas \n      y seguimiento alimienticio de los clientes SALARIO = 16400.00 REQUISITOS = Carrera Profesional en \n      Mediciona o Nutrición. ESTATUS = Activo FECHA REGISTRO = 2024-07-12 15:33:35 FECHA ACTUALIZACION =','2024-07-16 13:22:50',_binary ''),(4,'amisadai@%','Delete','tbc_puestos','Se ha eliminado un puesto con los siguientes datos: NOMBRE = Recepcionista DESCRIPCIÓN = Empleado responsable de la atención a los clientes del gimnasio,\n      registros de entradas y salidas  SALARIO = 6300.00 REQUISITOS = Bachillerato, Habilidades Informática. ESTATUS = Activo FECHA REGISTRO = 2024-07-12 15:33:35 FECHA ACTUALIZACION =','2024-07-16 13:22:50',_binary ''),(5,'amisadai@%','Delete','tbc_puestos','Se ha eliminado un puesto con los siguientes datos: NOMBRE = Técnico en Mantenimiento DESCRIPCIÓN = Empleado responsable de mantener en funcionamiento el\n      equipamiento de la sucursal. SALARIO = 10500.00 REQUISITOS = Bachillerato, Mecánica y Electrónica básica. ESTATUS = Activo FECHA REGISTRO = 2024-07-12 15:33:35 FECHA ACTUALIZACION =','2024-07-16 13:22:50',_binary ''),(6,'amisadai@10.10.60.9','Delete','tbb_personas','Se ha eliminado una persona con el ID:  1','2024-07-16 13:22:50',_binary ''),(7,'amisadai@10.10.60.9','Delete','tbb_personas','Se ha eliminado una persona con el ID:  3','2024-07-16 13:22:50',_binary ''),(8,'amisadai@10.10.60.9','Delete','tbb_personas','Se ha eliminado una persona con el ID:  4','2024-07-16 13:22:50',_binary ''),(9,'amisadai@10.10.60.9','Delete','tbb_personas','Se ha eliminado una persona con el ID:  5','2024-07-16 13:22:50',_binary ''),(10,'amisadai@10.10.60.9','Create','tbc_puestos','Se ha insertado una nuevo puesto con los siguientes datos:  NOMBRE =  Gerente DESCRIPCIÓN =  Empleado responsable de la Sucursal del Gimnasio. SALARIO =  20000.00 REQUISITOS =  Carrera Universitaria, Habilidades Informática y Trabajo en Equipo. ESTATUS =  Activo FECHA REGISTRO =  2024-07-16 13:23:04 FECHA_ACTUALIZACION = ','2024-07-16 13:23:04',_binary ''),(11,'amisadai@10.10.60.9','Create','tbc_puestos','Se ha insertado una nuevo puesto con los siguientes datos:  NOMBRE =  Entrenador DESCRIPCIÓN =  Empleado responsable de acompañar al cliente en sus programas saludables SALARIO =  12500.00 REQUISITOS =  Experiencia en Couching, Desempeño Físico y Primeros Auxilios ESTATUS =  Activo FECHA REGISTRO =  2024-07-16 13:23:04 FECHA_ACTUALIZACION = ','2024-07-16 13:23:04',_binary ''),(12,'amisadai@10.10.60.9','Create','tbc_puestos','Se ha insertado una nuevo puesto con los siguientes datos:  NOMBRE =  Nutriologo DESCRIPCIÓN =  Empleado responsable en dietas \n      y seguimiento alimienticio de los clientes SALARIO =  16400.00 REQUISITOS =  Carrera Profesional en \n      Mediciona o Nutrición. ESTATUS =  Activo FECHA REGISTRO =  2024-07-16 13:23:04 FECHA_ACTUALIZACION = ','2024-07-16 13:23:04',_binary ''),(13,'amisadai@10.10.60.9','Create','tbc_puestos','Se ha insertado una nuevo puesto con los siguientes datos:  NOMBRE =  Recepcionista DESCRIPCIÓN =  Empleado responsable de la atención a los clientes del gimnasio,\n      registros de entradas y salidas  SALARIO =  6300.00 REQUISITOS =  Bachillerato, Habilidades Informática. ESTATUS =  Activo FECHA REGISTRO =  2024-07-16 13:23:04 FECHA_ACTUALIZACION = ','2024-07-16 13:23:04',_binary ''),(14,'amisadai@10.10.60.9','Create','tbc_puestos','Se ha insertado una nuevo puesto con los siguientes datos:  NOMBRE =  Técnico de Mantenimiento DESCRIPCIÓN =  Empleado responsable de mantener en funcionamiento el\n      equipamiento de la sucursal. SALARIO =  10500.00 REQUISITOS =  Bachillerato, Mecánica y Electrónica básica. ESTATUS =  Activo FECHA REGISTRO =  2024-07-16 13:23:04 FECHA_ACTUALIZACION = ','2024-07-16 13:23:04',_binary ''),(15,'amisadai@10.10.60.9','Create','tbc_puestos','Se ha insertado una nuevo puesto con los siguientes datos:  NOMBRE =  Instructor DESCRIPCIÓN =  Especialista en Ejercicios y/o Disciplinas Deportivas SALARIO =  8500.00 REQUISITOS =  Bachillerato, Certificaciones ESTATUS =  Activo FECHA REGISTRO =  2024-07-16 13:23:04 FECHA_ACTUALIZACION = ','2024-07-16 13:23:04',_binary ''),(16,'amisadai@%','Update','tbc_puestos','Se ha modificado un puesto de usuario con los siguientes datos:, NOMBRE =, Gerente,  - , Gerente, DESCRIPCIÓN =, Empleado responsable de la Sucursal del Gimnasio.,  - , Empleado responsable de la Sucursal del Gimnasio., SALARIO =, 20000.00,  - , 22300.00, REQUISITOS =, Carrera Universitaria, Habilidades Informática y Trabajo en Equipo.,  - , Carrera Universitaria, Habilidades Informática y Trabajo en Equipo., ESTATUS =, Activo,  - , Activo, FECHA REGISTRO =, 2024-07-16 13:23:04,  - , 2024-07-16 13:23:04, FECHA ACTUALIZACION =,  - , 2024-07-16 13:23:04','2024-07-16 13:23:04',_binary ''),(17,'amisadai@%','Update','tbc_puestos','Se ha modificado un puesto de usuario con los siguientes datos:, NOMBRE =, Técnico de Mantenimiento,  - , Técnico en Mantenimiento, DESCRIPCIÓN =, Empleado responsable de mantener en funcionamiento el\n      equipamiento de la sucursal.,  - , Empleado responsable de mantener en funcionamiento el\n      equipamiento de la sucursal., SALARIO =, 10500.00,  - , 10500.00, REQUISITOS =, Bachillerato, Mecánica y Electrónica básica.,  - , Bachillerato, Mecánica y Electrónica básica., ESTATUS =, Activo,  - , Activo, FECHA REGISTRO =, 2024-07-16 13:23:04,  - , 2024-07-16 13:23:04, FECHA ACTUALIZACION =,  - , 2024-07-16 13:23:04','2024-07-16 13:23:04',_binary ''),(18,'amisadai@%','Delete','tbc_puestos','Se ha eliminado un puesto con los siguientes datos: NOMBRE = Instructor DESCRIPCIÓN = Especialista en Ejercicios y/o Disciplinas Deportivas SALARIO = 8500.00 REQUISITOS = Bachillerato, Certificaciones ESTATUS = Activo FECHA REGISTRO = 2024-07-16 13:23:04 FECHA ACTUALIZACION =','2024-07-16 13:23:04',_binary '');
/*!40000 ALTER TABLE `tbi_bitacora` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'gimnasio_9b_idgs'
--

--
-- Dumping routines for database 'gimnasio_9b_idgs'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_genera_decripcion_dieta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`emilio`@`%` FUNCTION `fn_genera_decripcion_dieta`(v_nombre_dieta VARCHAR(50)) RETURNS text CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	DECLARE v_descripcion TEXT;
    
    SET v_descripcion = 
		CASE v_nombre_dieta 
			WHEN "Dieta omnivora" THEN "Incluye una variedad de alimentos tanto de origen animal como vegetal. Esto significa que los omnívoros pueden consumir carne, pescado, aves, frutas, verduras, granos, legumbres y lácteos."
            WHEN "Dieta vegetariana" THEN "Esta dieta puede ayudarte a prevenir enfermedades, reducir el riesgo de cáncer y mejorar tu salud. Se basa en alimentos de origen vegetal y excluye la carne."
            WHEN "Dieta mediterránea" THEN "Es una alimentación equilibrada, flexible y saludable que se remonta a la década de 1950 y que se asocia a una mayor longevidad y una menor mortalidad. Incluye frutas, verduras, legumbres, pescado y aceite de oliva."
            WHEN "Dieta modificada en calorías" THEN "Esta dieta se basa en restringir el número de calorías diarias, limitando su consumo a un número inferior al que el cuerpo necesita en una jornada."
            WHEN "Dieta modificada en fibra" THEN "La dieta alta en fibra es indicada como medida preventiva del cáncer de colon, diabetes, enfermedades cardiovasculares, obesidad e hiperlipidemias. Se recomienda: 20 a 35 g al día; de los cuales 1/3 de fibra soluble y 2/3 de fibra insoluble."
            WHEN "Dieta modificada en proteína" THEN "Las dietas altas en proteínas buscan lograr un balance positivo de nitrógeno en pacientes catabólicos o con pérdida de proteínas por orina o pérdida de masa muscular. Las dietas bajas en proteína buscan lograr un balance positivo o en equilibrio."
            WHEN "Dieta libre de gluten" THEN "Esta dieta excluye el gluten, una proteína encontrada en el trigo, la cebada y el centeno, que puede causar problemas de salud en personas con enfermedad celíaca o sensibilidad al gluten."
            WHEN "Dieta DASH" THEN "Esta dieta es un plan de alimentación saludable que ayuda a bajar la presión arterial y el colesterol. Se basa en alimentos ricos en calcio, potasio, magnesio y fibra."
            WHEN "Dieta baja en colesterol" THEN "Esta dieta se enfoca en reducir la ingesta de alimentos ricos en colesterol y grasas saturadas para mejorar la salud del corazón."
            WHEN "Dieta baja en grasas" THEN "Esta dieta se basa en reducir la ingesta de alimentos ricos en grasas, como las carnes grasas, los lácteos enteros, los aceites y las frituras. La idea detrás de esta dieta es favorecer la pérdida de peso y reducir el riesgo de enfermedades del corazón."
            ELSE "La dieta no exixste"
		END;
RETURN v_descripcion;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_genera_detalle_dieta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`emilio`@`%` FUNCTION `fn_genera_detalle_dieta`(v_cuantos INT) RETURNS text CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	DECLARE i INT default 1;
	DECLARE v_restricciones TEXT;
    
    WHILE i <= v_cuantos DO
		SET v_restricciones =concat_ws("- ", v_restricciones, ELT(fn_numero_aleatorio(1,21), "Limitar el consumo de alimentos procesados.",
																									"Evitar la ingesta desproporcionada de carne por encima de los vegetales.",
																									"Moderar el consumo de carne en la variante flexitariana de esta dieta.",
																									"Excluir la carne de vaca, ave y pescado, y los huevos.",
																									"Evitar alimentos que contienen gelatina, un agente de espesamiento derivado del colágeno animal.",
																									"Limitar el consumo de alimentos procesados, azúcares añadidos, carnes rojas, grasas saturadas y alimentos altos en sodio.",
																									"Restringir las calorías en forma de alcohol.",
																									"Reducir la cantidad total de calorías que se consume o bebe en un día.",
																									"Evitar las pérdidas mayores de 500 g. de peso a la semana.",
																									"Evitar frutas y verduras crudas.",
																									"Evitar el trigo integral y los productos de grano integral.",
																									"Retirar todos aquellos alimentos que contengan proteínas de alto valor biológico (PAVB), en general, proteínas de origen animal.",
																									"Restringir las legumbres y los frutos secos ya que contienen una gran cantidad de proteínas.",
																									"Evitar todos los alimentos y bebidas que contengan trigo, centeno y cebada.",
																									"Evitar alimentos con demasiada sal.",
																									"Reducir la cantidad que se consume de alimentos con sal agregada (sodio) y agregar sal a las comidas.",
																									"Reducir el consumo de alcohol, bebidas azucaradas, alimentos con alto contenido de grasas saturadas.",
																									"Consumir menos de 300 mg de colesterol.",
																									"Limitar la grasa monoinsaturada a un 15-20% de la dieta.",
																									"Comer solo alimentos con 0 gramos de grasa.",
																									"No usar ningún tipo de grasa (como manteca, margarina o aceite) para preparar alimentos."));
		set i = i+1;
    END WHILE;
RETURN v_restricciones;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_genera_nombre_dieta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`emilio`@`%` FUNCTION `fn_genera_nombre_dieta`() RETURNS varchar(50) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	DECLARE v_nombre VARCHAR(50);
    
    SET v_nombre = ELT(fn_numero_aleatorio(1,10),"Dieta omnivora", "Dieta vegetariana", "Dieta mediterránea", "Dieta modificada en calorías", "Dieta modificada en fibra", 
													    "Dieta modificada en proteína", "Dieta libre de gluten", "Dieta DASH", "Dieta baja en colesterol", "Dieta baja en grasas");
RETURN v_nombre;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_genera_objetivos_dieta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`emilio`@`%` FUNCTION `fn_genera_objetivos_dieta`(v_cuantos INT) RETURNS text CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	DECLARE i INT default 1;
	DECLARE v_objetivo TEXT;
    
    WHILE i <= v_cuantos DO
		SET v_objetivo =concat_ws("- ", v_objetivo, ELT(fn_numero_aleatorio(1,37), "Permitir la flexibilidad y adaptabilidad a las preferencias personales y necesidades nutricionales.",
																	  "Proporcionar antioxidantes, fibra y otras sustancias que pueden ayudar a prevenir enfermedades crónicas.",
                                                                      "Ofrecer una amplia gama de vitaminas, minerales, proteínas, grasas y carbohidratos.",
                                                                      "Proporcionar una variedad de nutrientes esenciales para una buena salud.",
                                                                      "Bajar la presión arterial.",
                                                                      "Reducir el riesgo de cardiopatía.",
                                                                      "Reducir la posibilidad de desarrollar obesidad.",
                                                                      "Reducir la inflamación y aumentar la sensibilidad a la insulina.",
                                                                      "Mejorar la salud cardiovascular.",
                                                                      "Prevenir enfermedades crónicas que acortan la vida.",
                                                                      "Aumentar la vitalidad.",
                                                                      "Lograr un balance energético positivo.",
                                                                      "Aumentar de peso.",
                                                                      "Mantener el peso en condiciones hipermetabólicas.",
                                                                      "Ayudar a pacientes con déficit de peso corporal del 20% o más.",
                                                                      "Normalizar las deposiciones.",
                                                                      "Mantener la salud intestinal.",
                                                                      "Reducir los niveles de colesterol.",
                                                                      "Ayudar a controlar los niveles de azúcar en la sangre.",
                                                                      "Ayudar a lograr un peso saludable.",
                                                                      "Proporcionar una variedad de nutrientes esenciales para una buena salud.",
                                                                      "Ofrecer una amplia gama de vitaminas, minerales, proteínas, grasas y carbohidratos.",
                                                                      "Proporcionar antioxidantes, fibra y otras sustancias que pueden ayudar a prevenir enfermedades crónicas",
                                                                      "Permitir la flexibilidad y adaptabilidad a las preferencias personales y necesidades nutricionales.",
                                                                      "Tratamiento de la enfermedad celíaca, la sensibilidad no-celíaca al gluten y de la alergia al trigo.",
                                                                      "Mejorar la salud intestinal.",
                                                                      "Reducir los síntomas de la enfermedad celíaca y la sensibilidad al gluten.",
                                                                      "Reducir la presión arterial alta.",
                                                                      "Reducir el riesgo de enfermedades del corazón, insuficiencia cardíaca y accidentes cerebrovasculares.",
                                                                      "Ayudar a prevenir o controlar la diabetes tipo 2.",
                                                                      "Mejorar los niveles de colesterol.",
                                                                      "Reducir las probabilidades de cálculos renales.",
                                                                      "Reducir el riesgo de enfermedades del corazón.",
                                                                      "Reducir el riesgo de enfermedad cardiovascular.",
                                                                      "Reducir el consumo de alimentos procesados.",
                                                                      "Aumentar la cantidad de colesterol bueno.",
                                                                      "Prevenir la obesidad."));
		set i = i+1;
    END WHILE;
RETURN v_objetivo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_numero_aleatorio` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`emilio`@`%` FUNCTION `fn_numero_aleatorio`(v_limite_inferior int, v_limite_superior int) RETURNS int
    DETERMINISTIC
BEGIN	
	declare v_numero_generado INT 
    default floor(Rand()* (v_limite_superior - v_limite_inferior + 1) + v_limite_inferior);
    SET @numero_generado = v_numero_generado;
RETURN v_numero_generado;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_estatus_bd` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estatus_bd`(v_password VARCHAR(20))
BEGIN  
	
    IF v_password = "xYz$123" THEN
	-- Subquery / Subconsultas
    
	(SELECT "TABLAS CATALOGO" as Tabla, "--------------------" as TotalRegistros, 
    "--------------" as TipoTabla, "--------------" as Jerarquia, "--------------" as UDN_Owner, "--------------"  as UDN_Editors,  "--------------" as UDN_Readers)
    -- Suri
    UNION
     (SELECT "tbc_ejercicios" as Tabla, 
    (SELECT COUNT(*) FROM  tbc_ejercicios) as TotalRegistros, "Tabla Fuerte", "Genérica", "Training", "Training", "Training, Clientes"  )
    -- Aldair
    UNION
    (SELECT "tbc_indicadores_nutricionales" as Tabla,   
    (SELECT COUNT(*) FROM  tbc_indicadores_nutricionales) as TotalRegistros, "Tabla Fuerte", "Genérica", "Nutricion", "Nutrucion", "Nutricon, Clientes")
    -- Hugo	
     UNION
	(SELECT "tbc_membresias" as Tabla, 
    (SELECT COUNT(*) FROM  tbc_membresias) as TotalRegistros, "Tabla Fuerte", "Generica", "Membresias", "Membresias", "Membresias, Nutrición, Marketing, Clientes"  )
    -- Amisadai
	UNION
    (SELECT "tbc_puestos" as Tabla,   
    (SELECT COUNT(*) FROM  tbc_puestos) as TotalRegistros, "Tabla Fuerte", "Genérica", "Recursos Humanos", "Recursos Humanos", "Todos")
    -- Prof. Marco
    UNION
    (SELECT "tbc_roles" as Tabla,   
    (SELECT COUNT(*) FROM  tbc_roles) as TotalRegistros, "Tabla Fuerte", "Genérica", "Gerencia", "Gerencia", "Todos")
	-- Valencia
    UNION
    (SELECT "tbc_sucursales" as Tabla,   
    (SELECT COUNT(*) FROM  tbc_sucursales) as TotalRegistros, "Tabla Fuerte", "Genérica", "Recursos Materiales", "Recursos Materiales", "Todos")
    UNION
    (SELECT "TABLAS BASE" as Tabla, "--------------------" as TotalRegistros
    , "--------------" as TipoTabla, "--------------" as Jerarquia, "--------------" as UDN_Owner, "--------------"  as UDN_Editors,  "--------------" as UDN_Readers)
    UNION
    (SELECT "tbb_areas" as Tabla, 
    (SELECT COUNT(*) FROM  tbb_areas) as TotalRegistros, "Tabla Fuerte", "Genérica", "", "", "")
	UNION
    (SELECT "tbb_empleados" as Tabla, 
    (SELECT COUNT(*) FROM  tbb_empleados) as TotalRegistros, "Tabla Débil", "Genérica", "", "", "")
	UNION
    -- Jorge
    (SELECT "tbb_instructores" as Tabla, 
    (SELECT COUNT(*) FROM  tbb_instructores) as TotalRegistros, "Tabla Débil", "Subentidad", "Training", "Training", "Clientes"  )
    -- Valencia
    UNION
    (SELECT "tbb_instalaciones" as Tabla, 
    (SELECT COUNT(*) FROM  tbb_instalaciones) as TotalRegistros, "Tabla Débil", "Genérica", "Recursos Materiales","Recursos Materiales",  "Todos "  )
	-- Prof. Marco
	UNION
    (SELECT "tbb_usuarios" as Tabla, 
    (SELECT COUNT(*) FROM  tbb_usuarios) as TotalRegistros, "Tabla Débil", "Subentidad", "Gerencia", "Todos", "Todos"  )
	-- Zahid
    UNION 
   (SELECT "tbb_mantenimientos" as Tabla, 
    (SELECT COUNT(*) FROM  tbb_mantenimientos) as TotalRegistros, "Tabla Débil", "Genérica", "Recursos Materiales", "Recursos Materiales", "Recursos Materiales, Clientes")
    -- Max
    UNION
	(SELECT "tbb_miembros" as Tabla, 
    (SELECT COUNT(*) FROM  tbb_miembros) as TotalRegistros, "Tabla Débil", "Generica", "Membresias", "Membresias", "Membresias, Nutrición"  )
    -- Iram
	UNION
    (SELECT "tbb_personas" as Tabla, 
    (SELECT COUNT(*) FROM  tbb_personas) as TotalRegistros, "Tabla Fuerte", "Superentidad", "Recursos Humanos", "Clientes, Recursos Humanos, Training", "Todos")
    -- Edgar
	UNION
    (SELECT "tbb_pedidos" as Tabla, 
    (SELECT COUNT(*) FROM  tbb_pedidos) as TotalRegistros, "Tabla Débil", "Genérica", "Marketing", "Marketing, Clientes", "Recursos Materiales, Clientes")
    -- Amelí
	UNION
    (SELECT "tbb_preguntas_nutricionales" as Tabla, 
    (SELECT COUNT(*) FROM  tbb_preguntas_nutricionales) as TotalRegistros, "Tabla Débil", "Genérica", "Nutrición", "Nutrición", "Clientes, Training"  )
    -- OSiel
    UNION 
    (SELECT "tbb_prestamos" as Tabla, 
    (SELECT COUNT(*) FROM  tbb_prestamos) as TotalRegistros, "Tabla Débil", "Genérica", "Membresías", "Membresías, Recursos Materiales", "Membresías, Recursos Materiales, Clientes"  )
    
   UNION
    (SELECT "tbb_productos" as Tabla, 
    (SELECT COUNT(*) FROM  tbb_productos) as TotalRegistros, "Tabla Fuerte", "Genérica", "Marketing", "Marketing", "Clientes, Recursos Materiales")

    UNION
    
    (SELECT "tbb_promociones" as Tabla, 
    (SELECT COUNT(*) FROM  tbb_promociones) as TotalRegistros, "Tabla Débil", "Genérica", "Marketing", "Marketing", "Membresias, Clientes")
    UNION
   
    
    (SELECT "tbb_transacciones" as Tabla, 
    (SELECT COUNT(*) FROM  tbb_transacciones) as TotalRegistros, "Tabla Débil", "Genérica", "Membresías", "Membresías", "Membresías, Clientes"  )
    
    UNION
    (SELECT "TABLAS DERIVADAS" as Tabla, "--------------------" as TotalRegistros,
    "--------------" as TipoTabla, "--------------" as Jerarquia, "--------------" as UDN_Owner, "--------------"  as UDN_Editors,  "--------------" as UDN_Readers)
    UNION
	(SELECT "tbd_adeudos" as Tabla, 
    (SELECT COUNT(*) FROM  tbd_adeudos) as TotalRegistros, "Tabla Fuerte", "Generica", "Recursos Materiales", "Recursos Materiales", "Clientes, Training")
    UNION
	(SELECT "tbd_detalles_dietas" as Tabla, 
	(SELECT COUNT(*) FROM  tbd_detalles_dietas) as TotalRegistros, "Tabla Derivada", "Genérica", "Nutrición", "Nutrición", "Nutrición, Training, Clientes")
    UNION
    (SELECT "tbd_detalles_productos" as Tabla, 
    (SELECT COUNT(*) FROM  tbd_detalles_productos) as TotalRegistros, "Tabla Débil", "Genérica", "Marketing", "Marketing", "Clientes")
	UNION
    (SELECT "tbd_dietas" as Tabla, 
    (SELECT COUNT(*) FROM  tbd_dietas) as TotalRegistros, "Tabla Derivada", "Genérica", "Nutrición", "Nutrición", "Nutrición, Training, Clientes")
     UNION
    (SELECT "tbd_ejercicios_rutinas" as Tabla, 
    (SELECT COUNT(*) FROM  tbd_ejercicios_rutinas) as TotalRegistros, "Tabla Derivada", "Genérica", "Training", "Training", "Training, Clientes")
    UNION
    (SELECT "tbd_evaluaciones_servicios" as Tabla, 
    (SELECT COUNT(*) FROM  tbd_evaluaciones_servicios) as TotalRegistros, "Tabla Derivada", "Genérica", "Marketing", "Clientes", "Todos, Clientes")
    UNION
	(SELECT "tbd_objetivos_dietas" as Tabla, 
	(SELECT COUNT(*) FROM  tbd_objetivos_dietas) as TotalRegistros, "Tabla Derivada", "Genérica", "Nutrición", "Nutrición", "Nutrición, Training, Clientes")
    UNION
    (SELECT "tbd_opiniones_clientes" as Tabla, 
    (SELECT COUNT(*) FROM  tbd_opiniones_clientes) as TotalRegistros, "Tabla Derivada", "Genérica", "Marketing", "Clientes", "Marketing, Clientes")
    UNION
	(SELECT "tbd_preguntas" as Tabla, 
    (SELECT COUNT(*) FROM  tbd_preguntas) as TotalRegistros, "Tabla Derivada", "Genérica", "Marketing", "Marketing", "Marketing, Clientes")
    UNION
     (SELECT "tbd_programas_saludables" as Tabla, 
    (SELECT COUNT(*) FROM  tbd_programas_saludables) as TotalRegistros, "Tabla Derivada", "Genérica", "Training", "Training, Nutrición", "Training, Clientes, Nutrición")
    UNION
    (SELECT "tbd_rutinas" as Tabla,   
    (SELECT COUNT(*) FROM  tbd_rutinas) as TotalRegistros, "Tabla Derivada", "Genérica", "Training", "Training", "Training, Clientes, Nutrición")
    union
    (SELECT "tbd_usuarios_roles" as Tabla, 
    (SELECT COUNT(*) FROM  tbd_usuarios_roles) as TotalRegistros, "Tabla Derivada", "Genérica", "Gerencia", "-", "-")
    UNION
    (SELECT "tbd_valoraciones_nutricionales" as Tabla,   
    (SELECT COUNT(*) FROM  tbd_valoraciones_nutricionales) as TotalRegistros, "Tabla Derivada", "Genérica", "Nutrición", "Nutrición, Training", "Clientes, Nutrición, Training ")
    UNION
   
   
   
    
    (SELECT "TABLAS ISLA" as Tabla, "--------------------" as TotalRegistros,
    "--------------" as TipoTabla, "--------------" as Jerarquia, "--------------" as UDN_Owner, "--------------"  as UDN_Editors,  "--------------" as UDN_Readers)
    UNION
    (SELECT "tbi_bitacora" as Tabla, 
    (SELECT COUNT(*) FROM  tbi_bitacora) as TotalRegistros, "Tabla Isla", "Genérica", "Dirección General", "-", "-");
    
    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    
    END IF;
		

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_inserta_usuarios_m` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_inserta_usuarios_m`(v_cuantos int, v_tipo varchar(15))
    DETERMINISTIC
BEGIN
	DECLARE i INT default 1;
    DECLARE v_aleatorio BIT default b'0';
    DECLARE v_estatus_conexion varchar(50) DEFAULT NULL;
    DECLARE v_id_persona INT;
    
    IF v_tipo IS NULL THEN
		SET v_aleatorio = b'1';
    END IF;
    
    WHILE i <= v_cuantos DO
		START TRANSACTION;
		-- SELECT concat("Entrando en el ciclo #", i) as MensajeError;
		IF v_aleatorio = b'1' THEN
			SET v_tipo = null;
			SET v_estatus_conexion = NULL;
		END IF;
		
		call sp_insertar_personas(1);
		set v_id_persona = last_insert_id();
		
		-- En caso de que no se diga que tipo de empleado creamos, se elige uno aleatorio
		if v_tipo IS NULL THEN
			set v_tipo = ELT(fn_numero_aleatorio_rangos_m(1,4), "Empleado","Visitante","Miembro", "Instructor");
		END IF;
		
		-- En caso de que no se diga la ultima conexión, se elige uno aleatorio
		if v_estatus_conexion IS NULL THEN
			set v_estatus_conexion = ELT(fn_numero_aleatorio_rangos_m(1,3), "Online","Offline","Banned");
		END IF;
		
		-- Ya que se tiene todos los datos del trabajador insertar en la subentidad
		INSERT INTO usuarios VALUES(v_id_persona,
									 v_id_persona,
									 default,
									 v_tipo,
									 v_estatus_conexion,
									 fn_genera_fecha_registro_m( (SELECT fecha_registro FROM personas WHERE id= v_id_persona), CURDATE(), "08:00:00", "20:00:00"));
		set i = i+1;
        COMMIT;
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_limpiar_bd` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_limpiar_bd`(v_password varchar(10))
    DETERMINISTIC
BEGIN
	IF v_password = "xYz$123" THEN
	
    -- Eliminamos los datos de las tablas débiles
    delete FROM tbd_ejercicios_rutinas;
	ALTER TABLE tbd_ejercicios_rutinas auto_increment = 1;
    DELETE FROM tbd_usuarios_roles;
    DELETE FROM tbb_pedidos;
	ALTER TABLE tbb_pedidos AUTO_INCREMENT=1;
    DELETE FROM tbb_promociones;
	ALTER TABLE tbb_promociones AUTO_INCREMENT=1;
    DELETE FROM tbb_miembros;
    ALTER TABLE tbb_miembros AUTO_INCREMENT=1;
    delete FROM tbd_objetivos_dietas;
	delete FROM tbd_detalles_dietas;
    delete FROM tbd_dietas;
	ALTER TABLE tbd_dietas auto_increment = 1;
	DELETE FROM tbd_programas_saludables;
	ALTER TABLE tbd_programas_saludables auto_increment = 1;
    DELETE FROM tbd_rutinas;
    ALTER TABLE tbd_rutinas AUTO_INCREMENT=1;
    DELETE FROM tbb_transacciones;
    ALTER TABLE tbb_transacciones AUTO_INCREMENT=1;
	DELETE FROM tbd_horarios;
    ALTER TABLE tbd_horarios AUTO_INCREMENT=1;
	DELETE FROM tbd_adeudos;
    ALTER TABLE tbd_adeudos AUTO_INCREMENT=1;
	DELETE FROM tbb_instructores;
    ALTER TABLE tbb_instructores AUTO_INCREMENT=1;
    DELETE FROM tbb_empleados;
	ALTER TABLE tbb_empleados AUTO_INCREMENT=1;
    
    
    -- Eliminamos los datos de las tablas fuertes
	DELETE FROM tbb_areas;
	ALTER TABLE tbb_areas AUTO_INCREMENT=1;
    DELETE FROM tbb_prestamos;
	ALTER TABLE tbb_prestamos AUTO_INCREMENT=1;
    DELETE FROM tbb_usuarios;
    ALTER TABLE tbb_usuarios AUTO_INCREMENT=1;
    DELETE FROM tbc_roles;
    ALTER TABLE tbc_roles AUTO_INCREMENT=1;
    DELETE FROM tbi_bitacora;
	ALTER TABLE tbi_bitacora AUTO_INCREMENT=1;
    DELETE FROM tbc_indicadores_nutricionales;
	ALTER TABLE tbc_indicadores_nutricionales AUTO_INCREMENT=1;
	DELETE FROM tbc_puestos;
	ALTER TABLE tbc_puestos AUTO_INCREMENT=1;
    DELETE FROM tbb_personas;
	ALTER TABLE tbb_personas AUTO_INCREMENT=1;
    DELETE FROM tbc_sucursales;
	ALTER TABLE tbc_sucursales AUTO_INCREMENT=1;

    
    
   
    
    DELETE FROM tbd_valoraciones_nutricionales;
	ALTER TABLE tbd_valoraciones_nutricionales AUTO_INCREMENT=1;
    
    -- PRODUCTOS
    DELETE FROM tbb_productos ;
	ALTER TABLE tbb_productos AUTO_INCREMENT=1; 
    
    -- DETALLE PRODUCTOS
    DELETE FROM tbd_detalles_productos ;
	ALTER TABLE tbd_detalles_productos AUTO_INCREMENT=1;

    -- Membresias
    DELETE FROM tbc_membresias ;
	ALTER TABLE tbc_membresias AUTO_INCREMENT=1;
    
    
    
    -- EVALUACION SERVICIO
	DELETE FROM tbd_evaluaciones_servicios;
	ALTER TABLE tbd_evaluaciones_servicios AUTO_INCREMENT=1;
    
    -- PREGUNTAS NUTRICIONALES
	DELETE FROM tbb_preguntas_nutricionales;
	ALTER TABLE tbb_preguntas_nutricionales AUTO_INCREMENT=1;
    
     --  MANTENIMIENTOS
	DELETE FROM tbb_mantenimientos;
	ALTER TABLE tbb_mantenimientos AUTO_INCREMENT=1;
    
        -- OPINION CLIENTE
	
    
    -- ejercicios --
	DELETE FROM tbc_ejercicios;
	ALTER TABLE tbc_ejercicios AUTO_INCREMENT=1;
    	ELSE
		SELECT "La contraseña es incorrecta" AS Mensaje;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_adeudos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`YairS`@`%` PROCEDURE `sp_poblar_adeudos`()
BEGIN
if v_password = "abc123" then
INSERT INTO tbd_adeudo VALUES (DEFAULT, "Training", "Yair Salazar", "Maltrato equipo", DEFAULT, DEFAULT, DEFAULT, "X", "Producto");
INSERT INTO tbd_adeudo VALUES (DEFAULT, "Training", "Marco Perez", "Perdio equipo", DEFAULT, DEFAULT, DEFAULT, "X", "Producto");
INSERT INTO tbd_adeudo VALUES (DEFAULT, "Training", "Luz Reyes", "Descompuso equipo", DEFAULT, DEFAULT, DEFAULT, "X", "Producto");
INSERT INTO tbd_adeudo VALUES (DEFAULT, "Training", "Juan Hernandez", "Perdio equipo", DEFAULT, DEFAULT, DEFAULT, "X", "Producto");


UPDATE tbd_adeudo SET detalle = "Producto", estatus = "Activo" WHERE id=1;

DELETE FROM tbd_adeudo WHERE cliente = "Yair Salazar";

ELSE
SELECT "La contraseña es incorrecta" AS ErrorMessage;

END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_areas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`carlos`@`%` PROCEDURE `sp_poblar_areas`(v_password varchar(10))
BEGIN

if v_password = 'char123' then

    INSERT INTO tbb_areas VALUES
    (Default, 'Training', "Departamento encargado de coordinar a los entrenadores y la atención a sus clientes.", 1, default, '2020-08-10 08:00:00',null),
	(Default, 'Marketing',null,1, default,  '2020-08-10 08:00:00',null),
	(Default, 'Nutricion',null,1, default,  '2020-08-10 08:00:00',null),
	(Default, 'Recursos Humanos',null,1, default,  '2020-08-10 08:00:00',null),
	(Default, 'Recursos Materiales',null,1, default,  '2020-08-10 08:00:00',null),
	(Default, 'Miembros',null, 1,default, '2020-08-10 08:00:00', null),
    (Default, 'Vigilancia',null, 1,default, '2020-08-10 08:00:00', null),
    (Default, 'Training', "Departamento encargado de coordinar a los entrenadores y la atención a sus clientes.", 2, default, '2022-01-08 09:00:00',null),
    (Default, 'Recursos Materiales',null,2, default,  '2022-01-08 09:00:00',null),
    (Default, 'Training', "Departamento encargado de coordinar a los entrenadores y la atención a sus clientes.", 3, default, '2023-02-05 08:10:00',null);

		update tbb_areas set Nombre = 'Membresias' where id = 6;
        update tbb_areas set Descripcion = 'Departamento encargado de promover los servicios y productos ofertados por al Gimnasio, así como el manejo
        de manejo de promociones.' where id = 2;
        
        delete from tbb_areas where id = 7;
		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_catalogos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_catalogos`(v_password VARCHAR(20))
BEGIN  
	
    IF v_password = "xYz$123" THEN
		CALL sp_poblar_roles(v_password);
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_detalles_productos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`luz`@`%` PROCEDURE `sp_poblar_detalles_productos`(v_password varchar(10))
BEGIN
if v_password = "xYz$123" then
INSERT into tbd_detalles_productos values 
(default, 1,"Producto elaborado especificamente para venta en gimnasio" "30", null, '2024-06-21',default ),
 (default, 2,"Producto elaborado especificamente para venta en gimnasio" "30", null, '2024-06-21',default ),
(default, 2,"Producto elaborado especificamente para venta en gimnasio" "5", null, '2024-06-21',default ),
(default, 3,"Producto elaborado especificamente para venta en gimnasio" "20", null, '2024-06-21',default ),
(default, 4,"Producto elaborado especificamente para venta en gimnasio" "50", null, '2024-06-21',default ),
 (default, 5,"Producto elaborado especificamente para venta en gimnasio" "250", null, '2024-06-21',default ),
 (default, 6,"Producto elaborado especificamente para venta en gimnasio" "90", null, '2024-06-21',default );


update tbd_detalles_productos set valor = "300"  where id=2;
update tbd_detalles_productos set estatus = b'1' where id=4;

delete from tbd_detalles_productos where producto_id= 5;
else
select "La contraseña es incorrecta, no puedo mostrarte el estatus de la Base de datos" as ErrorMessage;

end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_dietas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`emilio`@`%` PROCEDURE `sp_poblar_dietas`(v_password VARCHAR(20), v_cuantos int)
    DETERMINISTIC
BEGIN
	-- Declaración de variables
    DECLARE i INT default 1;
    DECLARE v_nombre VARCHAR(30);
    DECLARE v_dieta_id int default 0;
    DECLARE v_detalle_dieta_id int default 0;
    DECLARE v_objetivo_dieta_id int default 0;
	DECLARE v_descripcion TEXT;
    
	IF v_password = "abcde" THEN
		while i <= v_cuantos do
			-- Generando el nombre de la dieta
			SET v_nombre = fn_genera_nombre_dieta();
			
			-- Insertar los datos en la tabla de dietas
			INSERT INTO tbd_dietas (nombre, descripcion) values (v_nombre, fn_genera_decripcion_dieta(v_nombre));
			set v_dieta_id = last_insert_id();
			
			-- Insertar los datos en la tabla de detalle dieta
			insert into tbd_detalles_dietas (Dieta_id, Detalle) values(v_dieta_id, fn_genera_detalle_dieta(fn_numero_aleatorio(1,4)));
			set v_detalle_dieta_id= last_insert_id();
			
			-- Insertar los datos en la tabla de objetivo dieta
			insert into tbd_objetivos_dietas (Dieta_id, objetivo) values(v_dieta_id, fn_genera_objetivos_dieta(fn_numero_aleatorio(1,6)));
			set v_objetivo_dieta_id= last_insert_id();
			
			-- Actualizamos los datos en la tabla de dietas
			UPDATE tbd_dietas SET Objetivo=v_objetivo_dieta_id, detalle=v_detalle_dieta_id  WHERE id=v_dieta_id;
			set i = i+1;
		END WHILE;
        
        DELETE FROM tbd_objetivos_dietas WHERE Dieta_id=1;
        DELETE FROM tbd_detalles_dietas WHERE Dieta_id=1;
		DELETE FROM tbd_dietas WHERE id=1;
		-- Reemplaza con el nombre real de la dieta a eliminar.

    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_ejercicios` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`suri`@`%` PROCEDURE `sp_poblar_ejercicios`(v_password varchar(50))
BEGIN

-- Corregido por Marco RH - Menos 2 Firmas

IF v_password = "xYz$123" THEN
	  INSERT INTO tbc_ejercicios VALUES 
        (DEFAULT, "Peso Muerto", " consiste esencialmente en extender la cadera y los músculos que la rodean, también incluye todos los ejercicios de musculación que requieren una cierta estabilidad del torso,
        esto incluye levantar una carga desde el suelo o desde la rodilla.", null, "Aerobico",default,'Basico',default,null, 'calentar','No hacer mal la fuerza'), 
		 (DEFAULT, "Planchas", " consiste esencialmente en extender la cadera y los músculos que la rodean, también incluye todos los ejercicios de musculación que requieren una cierta estabilidad del torso,
        esto incluye levantar una carga desde el suelo o desde la rodilla.", null, "Fuerza",default,'Intermedio',default,null, 'calentar','No hacer mal la fuerza'), 
        (DEFAULT, "Prensas", " consiste esencialmente en extender la cadera y los músculos que la rodean, también incluye todos los ejercicios de musculación que requieren una cierta estabilidad del torso,
        esto incluye levantar una carga desde el suelo o desde la rodilla.", null, "Fuerza",default,'Intermedio',default,null, 'calentar','No hacer mal la fuerza'), 
         (DEFAULT, "Pesas", " consiste esencialmente en extender la cadera y los músculos que la rodean, también incluye todos los ejercicios de musculación que requieren una cierta estabilidad del torso,
        esto incluye levantar una carga desde el suelo o desde la rodilla.", null, "Fuerza",default,'Avanzado',default,null, 'calentar','No hacer mal la fuerza'), 
         (DEFAULT, "Biceps", " consiste esencialmente en extender la cadera y los músculos que la rodean, también incluye todos los ejercicios de musculación que requieren una cierta estabilidad del torso,
        esto incluye levantar una carga desde el suelo o desde la rodilla.", null, "Aerobico",default,'Avanzado',default,null, 'calentar','No hacer mal la fuerza');
        
		UPDATE tbc_ejercicios SET nombre= "Peso Muerto" WHERE nombre="Remo";
        UPDATE tbc_ejercicios SET tipo= "Aeróbico" WHERE nombre="Prensas";
        UPDATE tbc_ejercicios SET Dificultad= "Básico" WHERE nombre="Biceps";
        
        DELETE FROM tbc_ejercicios WHERE nombre="Pesas";

    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_ejercicios_rutinas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`marinho`@`%` PROCEDURE `sp_poblar_ejercicios_rutinas`(v_password VARCHAR(20))
BEGIN
IF v_password = "qwerty" THEN
	insert into tbd_ejercicios_rutinas values (1, 1, "12", "Repeticiones", "Sin observaciones por el momento","2022-01-01 00:00:24", default, default);
	insert into tbd_ejercicios_rutinas values (2, 2, "15", "Repeticiones", "Realizar hasta el fallo muscular","2022-01-01 00:00:24", default, default);
	insert into tbd_ejercicios_rutinas values (3, 3, "20", "Repeticiones", "Evitar si tiene alguna lesion","2022-01-01 00:00:24", default, default);
	insert into tbd_ejercicios_rutinas values (1, 2, "40", "Repeticiones", "Sin observaciones por el momento","2022-01-01 00:00:24", default, default);
	insert into tbd_ejercicios_rutinas values (5, 5, "30", "Repeticiones", "Sin observaciones por el momento","2022-01-01 00:00:24", default, default);

	UPDATE tbd_ejercicios_rutinas SET Tipo = "Tiempo" where Ejercicio_ID = 5 and Rutina_ID = 5;

	DELETE FROM tbd_ejercicios_rutinas WHERE Ejercicio_ID = 1 and Rutina_ID = 2;
    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_empleados` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`daniel`@`%` PROCEDURE `sp_poblar_empleados`(v_password varchar(10))
BEGIN

if v_password = '1234' then

    -- INSERTAMOS A LOS EMPLEADOS DE LA SUCURSAL DE XICOTEPEC
    INSERT INTO tbb_empleados VALUES
		(DEFAULT,4,'2021-05-25 16:05:16', 1,3,'XIC-016',DEFAULT, NULL, DEFAULT),
		(DEFAULT,1,'2021-05-25 16:05:16', 2,1,'XIC-052',DEFAULT, NULL, DEFAULT),
        (DEFAULT,8,'2021-05-25 16:05:16', 2,4,'HUA-001',DEFAULT, NULL, DEFAULT),
        (DEFAULT,1,'2021-05-25 16:05:16', 4,5,'JNG-003',DEFAULT, NULL, DEFAULT);
    
    -- UPDATE
    
    -- DELETE
    
    else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_evaluaciones_servicios` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`lorena`@`%` PROCEDURE `sp_poblar_evaluaciones_servicios`(v_password VARCHAR(20))
BEGIN  
	
    IF v_password = "lolos" THEN
		
		INSERT INTO tbd_evaluaciones_servicios (usuario, servicio, calificacion, criterio, fecha_registro, estatus) VALUES 
        ('Lorena', 'Servicio de nutrición', 5, 'Excelente servicio y asesoramiento', NOW(), 1),
        ('Daniela', 'Horarios y Precios', 4, 'Buenos precios y horarios flexibles', NOW(), 1),
        ('Carlos', 'Comunidad', 3, 'Buena comunidad pero puede mejorar', NOW(), 1),
        ('Edgar', 'Programas de entrenamiento', 5, 'Programas muy efectivos y bien estructurados', NOW(), 1),
        ('Dulce', 'Servicio de nutrición', 2, 'Podrían mejorar en la atención', NOW(), 1),
        ('Eliezer', 'Horarios y Precios', 3, 'Horarios decentes pero precios algo elevados', NOW(), 1),
        ('Abel', 'Comunidad', 4, 'Buena interacción y apoyo entre miembros', NOW(), 1),
        ('Ameli', 'Programas de entrenamiento', 4, 'Muy buenos entrenadores y programas', NOW(), 1);
        
        -- Actualiza la calificación y el criterio de un usuario específico
        UPDATE tbd_evaluaciones_servicios SET calificacion = 1, criterio = 'No me gustó el servicio' WHERE usuario = 'Dulce';
        
        -- Desactiva una evaluación específica
        UPDATE tbd_evaluaciones_servicios SET estatus = b'0' WHERE usuario = 'Carlos';
        
        -- Elimina una evaluación específica
        DELETE FROM tbd_evaluaciones_servicios WHERE usuario = 'Daniela';
        
    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    
    END IF;
		

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_horarios` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`alejandro`@`%` PROCEDURE `sp_poblar_horarios`(v_password VARCHAR(20))
BEGIN
	IF v_password = "xYz$123" THEN

		INSERT INTO Horario VALUES
		(DEFAULT, 1, 'Turno mañana', '2024-06-18 08:00:00', '2024-06-18 16:00:00', DEFAULT, 'Activo', 101, 1, 1001),
		(DEFAULT, 2, 'Turno tarde', '2024-06-18 14:00:00', '2024-06-18 22:00:00', DEFAULT, 'Activo', 102, 2, 1002),
		(DEFAULT, 3, 'Turno noche', '2024-06-18 22:00:00', '2024-06-19 06:00:00', DEFAULT, 'Inactivo', 103, 1, 1003);
	ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_indicador_nutricional` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`aldair`@`%` PROCEDURE `sp_poblar_indicador_nutricional`(v_password VARCHAR(20))
    DETERMINISTIC
BEGIN
	IF v_password = "abcde" THEN
      INSERT INTO tbc_indicador_nutricional VALUES (DEFAULT, "Vitamina C","vitamina", "Vitamina esencial para la reparacion de tejidos y funcion inmune", "activo",  "Encontrada en citricos", DEFAULT, DEFAULT),
									(DEFAULT, "Calcio","mineral", "Mineral necesario para la formacion de huesos y dientes", "inactivo", "Presente en productos lacteos", DEFAULT, DEFAULT),
									(DEFAULT, "Proteina","macronutriente", "Macronutriente escencial para la construccion muscular", "pendiente", "Importante para deportistas", DEFAULT, DEFAULT),
									(DEFAULT, "Fibra Dietetica","fibra", "Importante para la salud digestiva","activo", "Encontrada en frutas y vegetables", DEFAULT, DEFAULT),
									(DEFAULT, "Vitamina D","vitamina", "Ayuda al cuerpo a absorber el calcio", "pendiente", "Encontrada en pescado y la leche",DEFAULT, DEFAULT);
        
      UPDATE tbc_indicador_nutricional SET Descripcion= "Alta en omega" WHERE id=2;
      -- Agrega más sentencias UPDATE aquí según sea necesario.
      
      DELETE FROM tbc_indicador_nutricional WHERE Nombre="Vitamina D";
      -- Reemplaza con el nombre real de la dieta a eliminar.

    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_instructor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`jorge`@`%` PROCEDURE `sp_poblar_instructor`()
BEGIN

	  insert into tbd_instructor values 
	(1, '12', 'Entrenamiento personalizado','63', default, default, null,'10'),
	(2, '5', 'Entrenamiento funcional','3', default, default, null,'9'),
	(3, '5', 'Entrenamiento de fuerza y acondicionamiento','45', default, default, null,'8'),
	(4, '5', 'Entrenamiento cardiovascular','53', default, default, null,'7');


		UPDATE tbb_instructor SET nombre= "peso muerto" WHERE nombre="remo";
        UPDATE tbb_instructor SET tipo= "Aerobico" WHERE nombre="prensas";
        UPDATE tbb_instructor SET Dificultad= "Basico" WHERE nombre="biceps";
	
        DELETE FROM tbb_instructor WHERE nombre="pesas";

   

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_mantenimientos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`zahid`@`%` PROCEDURE `sp_poblar_mantenimientos`(v_password varchar(10))
BEGIN
if v_password = "Ramirez" then 
        insert into tbd_mantenimientos values
        (default, "Pesas", "02-02-02", "Es para ejercicios con peso alto","Supervisor", 10, default, default),
        (default, "Giyotina", "02-02-03", "Es para personas corriosas","Supervisor", 10, DEFAULT, default),
        (default, "Corredora", "02-02-04", "Es para principiantes","Supervisor", 10, DEFAULT, default),
        (default, "Disco giratorio", "02-02-05", "Maquina enfocada a personas discapacitadas","Supervisor", 10, DEFAULT, default);
        
        end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_membresias` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`hugo`@`%` PROCEDURE `sp_poblar_membresias`(v_password VARCHAR(20))
BEGIN
IF v_password = "hugo1234" THEN
      INSERT INTO tbc_membresias VALUES 
      (DEFAULT, "0001", "Individual", "Basicos",  "Anual","Nuevo", DEFAULT,DEFAULT, DEFAULT,DEFAULT,DEFAULT),
      (DEFAULT, "0002", "Familiar", "Basicos",  "Semestral","Plata", DEFAULT,DEFAULT, DEFAULT,DEFAULT,DEFAULT),
      (DEFAULT, "0003", "Individual", "Completa",  "Trimestral","Oro", DEFAULT,DEFAULT, DEFAULT,DEFAULT,DEFAULT),
      (DEFAULT, "0004", "Familiar", "Completa",  "Mensual","Diamante", DEFAULT,DEFAULT, DEFAULT,DEFAULT,DEFAULT),
      (DEFAULT, "0005", "Empresarial", "Coaching",  "Diaria","Nuevo", DEFAULT,DEFAULT, DEFAULT,DEFAULT,DEFAULT);
									
									
      UPDATE tbc_membresias SET Tipo_Plan= "Mensual" WHERE id=2;
      UPDATE tbc_membresias SET Nivel= "Diamante" WHERE id=3;
      -- Agrega más sentencias UPDATE aquí según sea necesario.
      
      DELETE FROM tbc_membresias WHERE Tipo ="Empresarial";
      -- Reemplaza con el nombre real de la dieta a eliminar.

    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_miembros` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`max`@`%` PROCEDURE `sp_poblar_miembros`( v_password varchar(50))
BEGIN
	
    IF v_password = "1234" THEN

    INSERT INTO tbb_miembros (ID,Membresia_ID, Usuario_ID, Tipo, Estatus, Antiguedad, Fecha_Registro,Fecha_Actualizacion) VALUES
        (default,1, 1, 'Frecuente', 1, '2 años', default,default),
        (default,2, 2, 'Ocasional', 0, '1 año',default,default ),
        (default,1, 1, 'Nuevo', 1, '6 meses',default,default),
        (default,2, 1, 'Esporádico', 0, '3 meses', default,default),
        (default,1, 1, 'Una sola visita', 1, '1 mes',default,default );
	
		update tbb_miembros set Tipo = 'Nuevo' where id = 4;
        update tbb_miembros set Fecha_Registro = '09-08-24' where id = 3;
        
        delete from tbb_miembros where id = 2;
		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_opiniones_clientes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dulce`@`localhost` PROCEDURE `sp_poblar_opiniones_clientes`(v_password VARCHAR(20))
BEGIN  
	
    IF v_password = "xYz$123" THEN
		
		INSERT INTO tbd_opiniones_clientes (id, usuario_id, descripcion, tipo, respuesta, estatus, registro_fecha, registro_actualizacion, Atencion_personal) VALUES
        (default, 1, 'Buena atención y equipo en buen estado', 'Opinión', NULL, 'Registrado', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 5),
        (default, 2, 'El personal es muy atento y profesional', 'Opinión', NULL, 'Registrado', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 5),
        (default, 3, 'Las instalaciones necesitan más mantenimiento', 'Queja', NULL, 'Registrado', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 3),
        (default, 4, 'Gran variedad de clases y horarios', 'Opinión', NULL, 'Registrado', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 4),
        (default, 5, 'Podrían mejorar el servicio de limpieza', 'Queja', NULL, 'Registrado', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 2);
        
        UPDATE tbd_opiniones_clientes SET estatus = 'Atendida' WHERE estatus = 'Registrado';
        
        DELETE FROM tbd_opiniones_clientes WHERE estatus = 'Cancelado';
        
    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el estatus de la Base de Datos" AS ErrorMessage;
    
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_pedidos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`edgar`@`%` PROCEDURE `sp_poblar_pedidos`(v_password varchar(10))
BEGIN
if v_password = "abc123" then 

        insert into tbb_pedidos values
        (default, 1, default, "02-02-02", null, default, 20, 50.25),
        (default, 2, default, "03-02-02", null, default, 40, 30.55),
        (default, 3, default, "04-02-02", null, default, 80, 45.20),
		(default, 4, default, "05-02-02", null, default, 12, 78.99);
        
        update tbb_pedidos set Tipo = 'Promoción' where id = 1;
        update tbb_pedidos set Costo_total = 50.55 where id = 3;
        
        delete from tbb_pedidos where id = 4;
        
		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_personas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`daniel`@`%` PROCEDURE `sp_poblar_personas`(v_password varchar(50))
BEGIN
	if v_password = "1234" then 
       INSERT INTO tbb_personas  VALUES 
       (DEFAULT,'Dr.', 'Angel', 'Ramirez', 'Rosas', '2024-06-18',NULL, 'M', 'AB+',b'1', default,default),
       (DEFAULT,'Lic.', 'Daniel', 'Viveros', 'Vazquez', '2003-05-13',NULL, 'M', 'A+',b'1', default,default),
       (DEFAULT,'Ing.', 'Luis', 'Maldonado', 'Vazquez', '2005-11-19',NULL, 'M', 'O+',b'1', default,default),
       (DEFAULT,NULL, 'Arturo', 'Cabrera', 'Solis', '2007-03-14',NULL, 'M', 'O+',b'1', default,default),
       (DEFAULT,'Mtra', 'Melisa', 'Perez', 'Carrasco', '2010-07-22',NULL, 'F', 'A-',b'1', default,default);
       
		update tbb_personas set Titulo_Cortesia = 'Sr' where id = 4;
        update tbb_personas set Nombre = 'Petronilo' where id = 3;
        
        delete from tbb_personas where id = 2;
		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_preguntasNutricionales` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ame`@`%` PROCEDURE `sp_poblar_preguntasNutricionales`(v_password varchar(20))
BEGIN
    IF v_password = "1234" THEN

    INSERT INTO tbd_preguntas_nutricionales VALUES
        (default,'¿Conoces la diferencia entre la nutrición y alimentación?', 1, 'No', default, null, default, null),
        (default,'¿Cuántas veces comes al día?', 1, '3 veces al dia', default, null, default, null),
        (default,'¿Crees que la salud y la nutrición están relacionadas?', 1, 'Si', default, null, default, null),
        (default,'¿Quién compra los alimentos en tu hogar?', 1, 'Mis padres', default, null, default, null),
        (default,'¿Cuántos litros de agua bebes al día?', 1, '2 litros de agua por dia', default, null, default, null); 
        
        update tbd_preguntas_nutricionales set Descripcion = 'si' where pregunta='¿Conoces la diferencia entre la nutrición y alimentación?';
        update tbd_preguntas_nutricionales set Descripcion = '2 veces al dia' where pregunta='¿Cuántas veces comes al día?';
        
        delete from tbd_preguntas_nutricionales where pregunta='¿Cuántos litros de agua bebes al día?';
         ELSE
		SELECT "La contraseña es incorrecta" AS ErrorMessage;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_prestamos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`osiel`@`%` PROCEDURE `sp_poblar_prestamos`(v_password varchar(50))
BEGIN
    IF v_password = '1234' THEN
        DELETE FROM tbb_prestamos;

        INSERT INTO tbb_prestamos (fecha_prestamo, fecha_devolucion, situacion, observaciones, estatus, fecha_registro, fecha_actualizacion)
        VALUES 
            ('2024-06-13 10:00:00', '2024-06-20 18:00:00', 'pendiente', 'Préstamo 1', 1, NOW(), NOW()),
            ('2024-06-14 11:00:00', '2024-06-21 19:00:00', 'devuelto', 'Préstamo 2', 1, NOW(), NOW()),
            ('2024-06-15 12:00:00', '2024-06-22 20:00:00', 'retrasado', 'Préstamo 3', 0, NOW(), NOW()),
            ('2024-06-16 13:00:00', '2024-06-23 21:00:00', 'pendiente', 'Préstamo 4', 1, NOW(), NOW()),
            ('2024-06-17 14:00:00', '2024-06-24 22:00:00', 'cancelado', 'Préstamo 5', 0, NOW(), NOW());

         UPDATE tbb_prestamos SET situacion= "retrasado" WHERE id=2;
      
         DELETE FROM tbb_prestamos WHERE situacion="cancelado";
            
    ELSE
        SELECT 'La contraseña es incorrecta. No se pueden poblar préstamos.' AS ErrorMessage;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_productos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`luz`@`%` PROCEDURE `sp_poblar_productos`(v_password varchar(10))
BEGIN
if v_password = "xYz$123" then
INSERT into tbb_productos values (default, "Proteina", "Ciel", "3366", "Productos especial de dieta","Grande", 200.50, null, null, '2024-06-21',default ),
(default, "Mancuernas", "Sport", "5264", "Mancuernas verdes","Mediano", 200.50, null, null, '2024-06-21',default),
(default, "Suplemento", "GAT sport", "2145", "Producto para masa muscular","Grande", 200.50, null, null, '2024-06-21',default ),
(default, "Toallas", "Insane ", "5742", "Color morado/ blanco /negro","Chico", 200.50, null, null, '2024-06-21',default ),
(default, "Muñequeras", "Tecnogym", "0254", "Muñequeras absorbentes","Mediano", 200.50, null, null, '2024-06-21',default ),
(default, "Tapete", "BH Fitness", "8844", "Tapete color rosa/blanco/verde","Grande", 200.50, null, null, '2024-06-21',default ),
(default, "Tés", "Tunturi", "8532", "Producto espcial de dieta","Grande", 200.50, null, null, '2024-06-21',default );


update tbb_productos set marca = "Sport Xico", estatus = b'1' where id=1;
update tbb_productos set estatus = b'1' where nombre="Suplemento";

delete from tbb_productos where codigo_barras= "8532";

else
select "La contraseña es incorrecta, no puedo mostrarte el estatus de la Base de datos" as ErrorMessage;

end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_programas_saludables` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`morales`@`%` PROCEDURE `sp_poblar_programas_saludables`(v_password VARCHAR(20))
    DETERMINISTIC
BEGIN
	IF v_password = "1234" THEN
insert into tbd_programas_saludables values (default, "Deficit Calorico", 1, 1, "2024-01-01", "Registrado", "40 dias", 60.00, null );
insert into tbd_programas_saludables values (default, "Mes sano", 2, 2, "2024-01-20", "Registrado", "30 dias", 70.00, null );
insert into tbd_programas_saludables values (default, "Bienestar MenteCuerpo", 3, 3, "2024-01-01", "Sugerido", "30 dias", 50.00, null );
insert into tbd_programas_saludables values (default, "Serenidad Salud y Bienestar", 4, 4, "2024-01-20", "Registrado", "30 dias", 40.00, null );
insert into tbd_programas_saludables values (default, "Vida equilibrada", 5, 5, "2024-01-01", "Registrado", "60 dias", 80.00, null );
        
UPDATE tbd_programas_saludables SET Estatus = "Suspendido" WHERE Usuario_ID = 2;
DELETE FROM tbd_programas_saludables WHERE Usuario_ID=4;

    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_promociones` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`edgar`@`%` PROCEDURE `sp_poblar_promociones`(v_password varchar(10))
BEGIN
if v_password = "abc123" then 

        insert into tbb_promociones values
        (default, 1, default, default, default, "20-06-24", null),
        (default, 2, default, default, default, "21-06-24", null),
        (default, 3, default, default, default, "22-06-24", null),
		(default, 4, default, default, default, "23-06-24", null);
        
        update tbb_promociones set Tipo = 'Miembro' where id = 1;
        update tbb_promociones set Aplicacion_en = 'Tienda virtual' where id = 3;
        
        delete from tbb_promociones where id = 4;
        
		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_puestos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`amisadai`@`%` PROCEDURE `sp_poblar_puestos`(v_password VARCHAR(20))
    DETERMINISTIC
BEGIN
IF v_password = "abc123" THEN
	  INSERT INTO tbc_puestos VALUES 
	  (DEFAULT, "Gerente","Empleado responsable de la Sucursal del Gimnasio.", 20000.00, 
      "Carrera Universitaria, Habilidades Informática y Trabajo en Equipo.", DEFAULT, DEFAULT, NULL),
      (DEFAULT, "Entrenador","Empleado responsable de acompañar al cliente en sus programas saludables",
      12500.00, "Experiencia en Couching, Desempeño Físico y Primeros Auxilios", DEFAULT, DEFAULT, NULL),
      (DEFAULT, "Nutriologo","Empleado responsable en dietas 
      y seguimiento alimienticio de los clientes", 16400.00, "Carrera Profesional en 
      Mediciona o Nutrición.", DEFAULT, DEFAULT, NULL),
      (DEFAULT, "Recepcionista","Empleado responsable de la atención a los clientes del gimnasio,
      registros de entradas y salidas ", 6300.00, "Bachillerato, Habilidades Informática.", DEFAULT, DEFAULT, NULL),
      (DEFAULT, "Técnico de Mantenimiento","Empleado responsable de mantener en funcionamiento el
      equipamiento de la sucursal.", 10500.00, 
      "Bachillerato, Mecánica y Electrónica básica.", DEFAULT, DEFAULT, NULL),
      (DEFAULT, "Instructor","Especialista en Ejercicios y/o Disciplinas Deportivas", 8500.00, 
      "Bachillerato, Certificaciones", DEFAULT, DEFAULT, NULL);
      
	   -- Pendiente de corregir Amisadai
	   UPDATE tbc_puestos SET salario= "22300.00" WHERE nombre="Gerente";
       UPDATE tbc_puestos SET nombre= "Técnico en Mantenimiento" WHERE nombre="Técnico de Mantenimiento";
       -- Pendiente de corregir Amisadai
       DELETE FROM tbc_puestos WHERE nombre="Instructor";

    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el estatus de la Base de Datos" AS ErrorMessage;
    
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_roles` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_roles`(v_password VARCHAR(20))
BEGIN  
	
    IF v_password = "xYz$123" THEN
		
		INSERT INTO tbc_roles VALUES (default, 'Admin', 'Usuario Administrador del Sistema que permitira 
        modificar datos críticos', default, default, null),
        (default, 'Gerente', 'Usuario de la Máxima Autoridad del Gimnasio, que le permitirá acceder a módulos para 
        el control y operacion de los servicios', default, default, null),
        (default, 'Entrenador', 'Usuario que tendra acceso a consultar la información de los programas de
        entrenamiento y evolución de los miembros y usuarios a su cargo', default, default, null),
        (default, 'Miembro', 'Usuario que ha pagado una membresía y que tendra acceso a servicios adicionales
        en el gimnasio', default, default, null),
        (default, 'Usuario', 'Cliente del Gimnasio, que podrá acceder al sistema a consulta su evolución y 
        desempeño en los programas saludables y rutinas de acondicionamiento físico.', default, default, null),
        (default, 'Empleado', 'Usuario con privilegios para el  consultar y usa de los recursos del gimnasio', 
        default, default, null), 
        (default, 'Ventas', 'Rol que permitirá registrar procesos de marketing en el contexto del gimnasio',
        default, default, null),
        (default, 'Proveedor', 'Usuario que permite registrar la entrega de productos y servicios que
        le ofrece al gimnasio', default, default, null),
        (default, 'Cliente Invitado', 'Usuario rol de usuario solo sera creado para testear los triggers 
        de borrado y registro en bitacora', default, default, null), 
        (default, 'Nutriologo', 'Usuario especialista en el diseño y seguimiento de dietas, trabajador del gimnasio',default, default, null);
        
        
        UPDATE tbc_roles SET nombre = 'Administrador' WHERE nombre = 'Admin';
        UPDATE tbc_roles set estatus = b'0' where nombre = 'Proveedor';
        
        DELETE FROM tbc_roles WHERE nombre= "Cliente Invitado";
        
    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    
    END IF;
		

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_roles_usuarios` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_roles_usuarios`(v_password VARCHAR(20))
BEGIN  
	
    IF v_password = "xYz$123" THEN
		
		INSERT INTO tbd_usuarios_roles (usuario_id, rol_id)
        VALUES 
        (1,4),(1,1), (2,3), (3,3), (5,3), (5,6);
		
        UPDATE tbd_usuarios_roles SET rol_id = 5 WHERE usuario_id =1 and rol_id= 4; 
        DELETE FROM tbd_usuarios_roles WHERE usuario_id=5 and rol_id=6;
        
    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    
    END IF;
		
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_rutinas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`marinho`@`%` PROCEDURE `sp_poblar_rutinas`(v_password VARCHAR(20))
BEGIN
IF v_password = "qwerty" THEN
	insert into tbd_rutinas values (default, "Tonificación muscular", 1, "2022-01-01 00:00:24", default, null, "Actual", "Aumentar masa muscular");
	insert into tbd_rutinas values (default, "Entrenamiento cardiovascular intensivo", 2, "2022-01-01 00:00:24", default, null, "Actual", "Bajar al IMC saludable");
	insert into tbd_rutinas values (default, "Entrenamiento para principiantes", 3, "2022-01-01 00:00:24", default, null, "Actual", "Aumentar IMC a saludable");
	insert into tbd_rutinas values (default, "Resistencia metabólica", 4, "2022-01-01 00:00:24", default, null, "Actual", "Definir musculo");
	insert into tbd_rutinas values (default, "Rutina de fuerza total", 5, "2022-01-01 00:00:24", default, null, "Actual", "Ponerse mamado");

	UPDATE tbd_rutinas SET Estatus = "Concluido" WHERE ID = 2;

	DELETE FROM tbd_rutinas WHERE ID=4;
    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_sucursales` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`valencia`@`%` PROCEDURE `sp_poblar_sucursales`(v_password varchar(10))
BEGIN

if v_password = 'xYz$123' then
	-- INSERT
    INSERT INTO tbc_sucursales VALUES
    (DEFAULT, "Xicotepec", "Calle Matamoros #125, Planta Alta", NULL, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
    "Lunes a Viernes 07:00 a 21:00, Sábados y Domingos de 11:00 a 23:00", DEFAULT, DEFAULT, NULL),
    (DEFAULT, "Huauchinango", "Calle 5 de Mayo #72", NULL, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
    "Lunes a Viernes 08:00 a 20:00, Sábados y Domingos de 12:00 a 20:00", DEFAULT, DEFAULT, NULL), 
    (DEFAULT, "Juan Galindo", "Avenida 1ro. de Mayo #205", NULL, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
    "Martes a Viernes 06:00 a 20:00, Sábados y Domingos de 08:00 a 20:00", DEFAULT, DEFAULT, NULL), 
    (DEFAULT, "Villa Ávila Camacho", "Calle Morelos #25", NULL, DEFAULT, DEFAULT, DEFAULT, DEFAULT,
    "Lunes a Viernes 10:00 a 21:00, Sábados y Domingos de 10:00 a 20:00", DEFAULT, DEFAULT, NULL);
    
    -- UPDATE
		update tbc_sucursales set direccion = 'Zaragoza, #208' where id = 1;
        update tbc_sucursales set horario_disponibilidad = 'Lunes a Viernes 06:00 a 21:00, 
        Sábados y Domingos de 13:00 a 21:00' where id = 2;
	-- DELETE
        delete from tbc_sucursales where id = 4;
        
		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_transaccion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`sebastian.marquez`@`%` PROCEDURE `sp_poblar_transaccion`(v_password VARCHAR(20))
BEGIN
	IF v_password = "1234" THEN
		INSERT INTO tbb_transaccion VALUES
		(DEFAULT, 1, 180.00, DEFAULT, DEFAULT, DEFAULT, 1),
		(DEFAULT, 2, 90.00, 0, DEFAULT, DEFAULT, 2),
		(DEFAULT, 1, 320.00, DEFAULT, DEFAULT, DEFAULT, 4),
		(DEFAULT, 2, 180.00, DEFAULT, DEFAULT, DEFAULT, 2),
		(DEFAULT, 2, 320.00, 0, DEFAULT, DEFAULT, 3);
        
        UPDATE tbb_transaccion SET Estatus=1 WHERE ID=2;
        UPDATE tbb_transaccion SET Estatus=1 WHERE ID=5;
        
        DELETE FROM tbb_transaccion WHERE ID=4;
    ELSE
		SELECT "La contraseña es incorrecta" AS ErrorMessage;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_usuarios` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_usuarios`(v_password VARCHAR(20))
BEGIN  
	IF v_password = "xYz$123" THEN
	  INSERT INTO tbb_usuarios VALUES 
        (DEFAULT, 1, "marco.rahe", "marco.rahe@hotmail.com", "qwerty123", "(+52) 764 100 17 25", 
        DEFAULT, DEFAULT, NULL),
        (DEFAULT, 2, "juan.perez", "j.perez@hotmail.com", "mipass", "(+52) 555 553 19 32", 
        DEFAULT, DEFAULT, NULL),
        (DEFAULT, 3, "patito25", "patricia.reyes@hospitalito.mx", "gest#2235", "(+52) 222 235 44 01", 
        DEFAULT, DEFAULT, NULL),
        (DEFAULT, 4, "liliana99", "lili.santamaria@privilegecare.com", "dasT8832", "(+52) 778 145 22 87", 
        DEFAULT, DEFAULT, NULL),
        (DEFAULT, 5, "hugo.vera", "solnanov_hugo@gmail.com", "12345", "(+52) 758 98 16 32", 
        DEFAULT, DEFAULT, NULL);
        
		UPDATE tbb_usuarios SET correo_electronico= "marco.rahe@gmail.com" WHERE nombre_usuario="marco.rahe";
        UPDATE tbb_usuarios SET estatus= "Bloqueado" WHERE nombre_usuario="hugo.vera";
        UPDATE tbb_usuarios SET estatus= "Suspendido" WHERE nombre_usuario="juan.perez";
        
        DELETE FROM tbb_usuarios WHERE nombre_usuario="liliana99";

    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    
    END IF;
		

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poblar_valoraciones_nutricionales` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adalid`@`%` PROCEDURE `sp_poblar_valoraciones_nutricionales`(v_password VARCHAR(20))
BEGIN
	IF v_password = "xYz$123" THEN
	  INSERT INTO tbd_valoracion_nutricional(id, id_miembro, id_indicador_nutricional, id_pregunta_nutricional, fecha_registro, valor, comentarios) VALUES 
        (
        default,
        1, 
        1, 
        1, 
        default, 
        "No he bajado ni aumentado de peso en 6 meses", 
        "Mi peso siempre es estable"
        ),
        (DEFAULT, 
        2, 
        2, 
        2, 
        default, 
        "Consumo alimentos dos veces al dia", 
        "No me da hambre por las mañanas"
        ),
        (DEFAULT, 
        5, 
        8, 
        9, 
        default, 
        "He sudido 6 kilos en dos semanas", 
        "Mi estatura no me ayuda con mi peso"
        ),
        (DEFAULT, 
        4, 
        7, 
        8, 
        default, 
        "Consumo azucares en exceso", 
        "Tengo problemas con mis riñones"
        );
        
        UPDATE tbd_valoracion_nutricional SET id_miembro = 3 WHERE id_miembro = 1;
        -- DELETE FROM tbd_valoracion_nutricional WHERE comentarios = "Mi peso siempre es estable";

    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_roles_usuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_roles_usuario`(v_correo_electronico VARCHAR(60))
BEGIN
   -- Verificamos si el usuario existe
   IF (SELECT COUNT(*) FROM tbb_usuarios WHERE correo_electronico = v_correo_electronico) >0 THEN
	 -- Verificamos si el usuario se encuentra Bloqueado
	 IF (SELECT estatus FROM tbb_usuarios WHERE correo_electronico = v_correo_electronico) = "Bloqueado"  THEN 
       SELECT CONCAT_WS(" ", "El usuario:", v_correo_electronico,"actualmente se encuentrá bloqueado del sistema.") as Mensaje;
	-- Verificamos si el usuario se encuentra Suspendido 
     ELSEIF (SELECT estatus FROM tbb_usuarios WHERE correo_electronico = v_correo_electronico) = "Suspendido"  THEN 
       SELECT CONCAT_WS(" ", "El usuario:", v_correo_electronico," ha sido suspendido del uso del sistema.") as Mensaje;
	 ELSE
		SELECT r.Nombre FROM 
        tbc_roles r 
        JOIN tbd_usuarios_roles ur ON ur.rol_id = r.id
        JOIN tbb_usuarios u ON ur.usuario_id = u.id
        WHERE u.correo_electronico=v_correo_electronico AND ur.estatus = TRUE;
	END IF;
	ELSE 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario especificado no existe';
   END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-16 14:25:29
