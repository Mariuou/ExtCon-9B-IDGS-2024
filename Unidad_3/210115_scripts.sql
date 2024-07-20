-- PRACTICA 13: REVISIÓN Y CORRECCIÓN DE TABLAS:
-- Servicio al Cliente, Servicios Sucursales, Instalaciones, Equipamiento, Ejercicios

-- Elaborado por: Ing. Mario Gutierrez Rosales
-- Grado y Grupo: 9° B
-- Programa Educativo: Ingeniería en Desarrollo y Gestion de Software
-- Fecha de Elaboración: 19 de Julio de 2024

-- Tabla: Servicios al Cliente
-- a) Revisión de la composición de la tabla
CREATE TABLE `tbc_servicios_clientes` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Persona_ID` int unsigned NOT NULL,
  `Tipo_Servicio` enum('Consulta','Reclamo','Sugerencia') NOT NULL DEFAULT 'Sugerencia',
  `Descripcion` text NOT NULL,
  `Comentarios` text,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_personas_id_4_idx` (`Persona_ID`),
  CONSTRAINT `fk_personas_id_4` FOREIGN KEY (`Persona_ID`) REFERENCES `tbb_personas` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- b) Cambios sugeridos: Atrapar la información del ID en una variable, sustituyendo por el nombre de la persona (Demostración en trigger AFTER_INSERT)
CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_INSERT` AFTER INSERT ON `tbc_servicios_clientes` FOR EACH ROW BEGIN
 DECLARE v_estatus varchar(20) default 'Activo';
	DECLARE v_nombre_persona varchar(60) default null;
    
    if not NEW.estatus then
		set v_estatus = "Inactivo";
	end if;
    
    if new.persona_id is not null then
        set v_nombre_persona = (SELECT CONCAT_WS(" ", p.titulo_cortesia, p.nombre, p.primer_apellido) FROM tbb_personas p WHERE id = NEW.persona_id);
    else
        SET v_nombre_persona = "Sin producto asignado";
    end if;
    
    INSERT INTO tbi_bitacora VALUES(
        default, 
        current_user(), 
        "Create",
        "tbc_servicios_clientes",
        CONCAT_WS(" ", "Se ha insertado un nuevo servicio al cliente con los siguientes datos",
        "ID de la persona: ", v_nombre_persona,
        "Tipo de Servicio: ", new.tipo_servicio,
        "Descripción: ", new.descripcion,
        "Comentarios: ", new.comentarios,
        "Fecha Registro: ", new.fecha_registro,
        "Fecha Actualización: ", new.fecha_actualizacion,
        "Estatus: ", v_estatus ), 
        default, 
        default 
    );
END

-- c) Revisión de la población estática: No cuenta con un procedimiento de población (Se procede a crear)
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_servicios_clientes`(v_password varchar(10))
BEGIN
if v_password = '1234' then

    INSERT INTO tbc_servicios_clientes VALUES
    (default, 1, "Reclamo", "Supervicion a entrenadores", "La atención de los entrenadores no es la adecuada",default, default, default),
    (default, 3, "Consulta", "Consulta con nutriologos", "El cliente desea tener mayor umero de consultas con el nutriologo",default, default, default),
    (default, 4, "Sugerencia", "Limpieza de equipos", "El cliente sugiere tener una mayor higiene al momento de limpiar los equipos",default, default, default),
    (default, 5, "Sugerencia", "Flexibilidad de horarios", "El cliente sugiere un horario de trabajo mas amplio",default, default, default);
      
	update tbc_servicios_clientes set Tipo_Servicio = 'Reclamo' where id = 4;
	update tbc_servicios_clientes set Estatus = b'0' where id = 2;
        
        delete from tbc_servicios_clientes where id = 1;
		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END

-- d) Revisión de los triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, AFTER DELETE):
-- Agregación del trigger AFTER UPDATE (No estaba creado)
CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_UPDATE` AFTER UPDATE ON `tbc_servicios_clientes` FOR EACH ROW BEGIN
	
    declare v_estatus_old varchar(20) default 'Activo';
    declare v_estatus_new varchar(20) default 'Activo';
    DECLARE v_nombre_persona_old varchar(60) default null;
    DECLARE v_nombre_persona_new varchar(60) default null;
    
    if not old.estatus then
		set v_estatus_old = "Inactivo";
	end if;
    if not NEW.estatus then
		set v_estatus_new = "Inactivo";
	end if;
    
    IF old.persona_id IS NOT NULL THEN 
		SET v_nombre_persona_old = (SELECT CONCAT_WS(" ", p.titulo_cortesia, p.nombre, p.primer_apellido) FROM tbb_personas p WHERE id = old.persona_id);
    else
		SET v_nombre_persona_old = "Sin usuario asignado.";
    END IF;
    
    IF new.persona_id IS NOT NULL THEN 
		SET v_nombre_persona_new = (SELECT CONCAT_WS(" ", p.titulo_cortesia, p.nombre, p.primer_apellido) FROM tbb_personas p WHERE id = NEW.persona_id);
    else
		SET v_nombre_persona_new = "Sin usuario asignado.";
    END IF;

INSERT INTO tbi_bitacora VALUES(
  default, 
  current_user(), 
  'Update', 
  'tbc_servicios_clientes', 
  CONCAT_WS(' ','Se ha modificado Servicio al cliente prestado con los siguientes datos:', 
  'ID de quien solicitó el servicio: ', v_nombre_persona_old, v_nombre_persona_new,
  'Tipo de servicio: ', old.tipo_servicio, ' a pasado a: ', new.tipo_servicio, ' - ',
  'Descripción: ', old.descripcion,' a pasado a: ',new.descripcion,' - ',
  'comentarios: ', old.comentarios,' a pasado a: ',new.comentarios,' - ', 
  'Fecha actualización: ', old.fecha_actualizacion,' a pasado a: ',new.fecha_actualizacion,' - ',
  'Estatus: ', v_estatus_new 
  ), 
  default, 
  default 
);
END

CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_DELETE` AFTER DELETE ON `tbc_servicios_clientes` FOR EACH ROW BEGIN
	declare v_estatus_old varchar(20) default 'Activo';
    DECLARE v_nombre_persona_old varchar(60) default null;
    
    if not old.estatus then
		set v_estatus_old = "Inactivo";
	  end if;

    if old.persona_id IS NOT NULL THEN 
		set v_nombre_persona_old = (SELECT CONCAT_WS(" ", p.titulo_cortesia, p.nombre, p.primer_apellido) FROM tbb_personas p WHERE id = old.persona_id);
    else
		set v_nombre_persona_old = "Sin usuario asignado.";
    end if;
 
INSERT INTO tbi_bitacora VALUES(
  default,  
  current_user(), 
  'Delete', 
  'tbc_servicios_clientes', 
  CONCAT_WS(" ", "Se ha eliminado un servicio de un cliente con los siguientes dato: ",' - ', 
  'ID de quien solicitó el servicio: ', v_nombre_persona_old,
  'Tipo de servicio: ', old.tipo_servicio,' - ',
  'Descripción: ', old.descripcion,' - ', 
  'comentarios: ', old.comentarios,' - ', 
  'Fecha actualización: ', old.fecha_actualizacion,' - ',
  'Estatus: ', v_estatus_old), 
  default, 
  b'0'
);
END
-- e) Realizar una consulta join



-- Tabla: Servicios Sucursales
-- a) Revisión de la composición de la tabla
CREATE TABLE `tbd_servicios_sucursales` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Sucursal_ID` int unsigned NOT NULL,
  `ServiciosCliente_ID` int unsigned NOT NULL,
  `Estatus` enum('Iniciada','Proceso','Concluida') DEFAULT 'Concluida',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- b) Cambios sugeridos: Atrapar la información del ID en una variable, sustituyendo por un campo de la tabla

-- c) Revisión de la población estática: No cuenta con procedimiento de población
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_servicios_sucursales`(v_password varchar(10))
BEGIN
if v_password = 'qwerty' then

    INSERT INTO tbd_servicios_sucursales VALUES
    (default,1, 2,"Proceso"),
    (default,2, 3,"Proceso"),
    (default,3, 4,"Iniciada");
    
	update tbd_servicios_sucursales set Estatus = 'Iniciada' where id = 2;
        
        delete from tbd_servicios_sucursales where id = 1;
		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END

-- d) Revisión de los triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, AFTER DELETE): Actualizacion de cambios sugeridos
CREATE DEFINER=`root`@`localhost` TRIGGER `tbd_servicios_sucursales_AFTER_INSERT` AFTER INSERT ON `tbd_servicios_sucursales` FOR EACH ROW BEGIN
DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
DECLARE v_nombre_sucursal VARCHAR(100) DEFAULT (SELECT Nombre FROM tbc_sucursales WHERE id = new.Sucursal_ID);
DECLARE v_nombre_servicioCliente VARCHAR(100) DEFAULT (SELECT Tipo_Servicio FROM tbc_servicios_clientes WHERE id = new.ServiciosCliente_ID);

    IF NOT new.estatus = b'1' THEN
        SET v_estatus = 'Inactivo';
    END IF;
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT, 
        current_user(), 
        "Create", 
        "tbd_servicios_sucursales", 
        CONCAT_WS(" ", "Se ha insertado un nuevo servicio respecto a la sucursal con los siguientes datos", 
        "ID SUCURSAL", v_nombre_sucursal,
        "ID SERVICIOS CLIENTES", v_nombre_servicioCliente,
        "ESTATUS", v_estatus), 
        DEFAULT, 
        default 
    );
END 

CREATE DEFINER=`root`@`localhost` TRIGGER `tbd_servicios_sucursales_AFTER_UPDATE` AFTER UPDATE ON `tbd_servicios_sucursales` FOR EACH ROW BEGIN
DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Activo';

DECLARE v_nombre_sucursal_old VARCHAR(100) DEFAULT (SELECT Nombre FROM tbc_sucursales WHERE id = old.Sucursal_ID);
DECLARE v_nombre_servicioCliente_old VARCHAR(100) DEFAULT (SELECT Tipo_Servicio FROM tbc_servicios_clientes WHERE id = old.ServiciosCliente_ID);

DECLARE v_nombre_sucursal_new VARCHAR(100) DEFAULT (SELECT Nombre FROM tbc_sucursales WHERE id = new.Sucursal_ID);
DECLARE v_nombre_servicioCliente_new VARCHAR(100) DEFAULT (SELECT Tipo_Servicio FROM tbc_servicios_clientes WHERE id = new.ServiciosCliente_ID);

IF NOT old.estatus THEN
SET v_estatus_old = 'Inactivo';
END IF;

IF NOT new.estatus THEN
SET v_estatus_new = 'Inactivo';
END IF;

    INSERT INTO tbi_bitacora VALUES(
        DEFAULT, 
        current_user(), 
        "Update", 
        "tbd_servicios_sucursales",
        CONCAT_WS(" ", "Se ha modificado un servicio respecto a la sucursal con los siguientes datos", 
        "ID SUCURSAL", v_nombre_sucursal_old, '-', v_nombre_sucursal_new,
        "ID SERVICIOS CLIENTES", v_nombre_servicioCliente_old, '-',  v_nombre_servicioCliente_new,
        "ESTATUS", v_estatus_old, '-',  v_estatus_new), 
        DEFAULT, 
        default	
    );
END

CREATE DEFINER=`root`@`localhost` TRIGGER `tbd_servicios_sucursales_BEFORE_DELETE` BEFORE DELETE ON `tbd_servicios_sucursales` FOR EACH ROW BEGIN
DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
DECLARE v_nombre_sucursal_old VARCHAR(100) DEFAULT (SELECT Nombre FROM tbc_sucursales WHERE id = old.Sucursal_ID);
DECLARE v_nombre_servicioCliente_old VARCHAR(100) DEFAULT (SELECT Tipo_Servicio FROM tbc_servicios_clientes WHERE id = old.ServiciosCliente_ID);

IF NOT old.estatus THEN
SET v_estatus_old = 'Inactivo';
END IF;
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT, 
        current_user(), 
        "Delete", 
        "tbd_servicios_sucursales",
        CONCAT_WS(" ", "Se ha eliminado un servicio respecto a la sucursal con los siguientes datos", 
        "ID SUCURSAL", v_nombre_sucursal_old,
        "ID SERVICIOS CLIENTES", v_nombre_servicioCliente_old,
        "ESTATUS", v_estatus_old), 
        DEFAULT,  
        default 
    );
END

-- e) Realizar una consulta join



-- Tabla: Instalaciones
-- a) Revisión de la composición de la tabla
CREATE TABLE `tbb_instalaciones` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) NOT NULL,
  `Descripcion` text NOT NULL,
  `Tipo` varchar(100) NOT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Fecha_Actualizacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `Calificacion` enum('Exelente servicio','Buen servicio','Servicio Regular','Puede mejorar el servicio') NOT NULL DEFAULT 'Buen servicio',
  `Sucursal_ID` int unsigned NOT NULL,
  `Horario_Disponibilidad` varchar(100) NOT NULL,
  `Servicio` varchar(100) DEFAULT NULL,
  `Observaciones` text,
  PRIMARY KEY (`ID`),
  KEY `fk_sucursal_id_3_idx` (`Sucursal_ID`),
  CONSTRAINT `fk_sucursal_id_3` FOREIGN KEY (`Sucursal_ID`) REFERENCES `tbc_sucursales` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- b) Cambios sugeridos: Atrapar la información del ID en una variable, sustituyendo por un campo de la tabla

-- c) Revisión de la población estática: No cuenta con un procedimiento de población 
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_instalaciones`(v_password varchar(10))
BEGIN

if v_password = 'qwerty' then

    INSERT INTO tbb_instalaciones VALUES
    (Default, 'Zona de relajacion', "Zona con areas de masaje para la recuperación muscular", "Recuperación", '2020-08-10 08:00:00', default, default, default,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
    (Default, 'Baños de vapor', "Zona de duchas despues del entrenamiento", "Recuperación",'2020-08-10 08:00:00', default, default, default,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
    (Default, 'Yoga', "Espacio para ejercicios de yoga", "Ejercicios de estiramiento", '2020-08-10 08:00:00', default, default, default,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
    (Default, 'Pilates', "Espacio para ejercicios de pilates", "Ejercicios de tinificación", '2020-08-10 08:00:00', default, default, default,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
    (Default, 'Cardio', "Espacio con equipo enfocado a cardio", "Ejercicicos de rendimiento", '2020-08-10 08:00:00', default, default, default,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null);
    
		update tbb_instalaciones set Nombre = 'Zona de pilates' where id = 4;        
        delete from tbb_instalaciones where id = 5;
		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END

-- d) Revisión de los triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, AFTER DELETE): Los triggers funcionan correctamente

-- e) Realizar una consulta join



-- Tabla: Equipamiento
-- a) Revisión de la composición de la tabla
CREATE TABLE `tbb_equipamientos` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Area` varchar(100) NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Marca` varchar(100) NOT NULL,
  `Modelo` varchar(100) NOT NULL,
  `Foto` varchar(100) DEFAULT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Fecha_Actualizacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `Estatus` bit(1) NOT NULL DEFAULT b'1',
  `Total_Existencias` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- b) Cambios sugeridos: Sin cambios a sugerir

-- c) Revisión de la población estática: No cuenta con un procedimiento de población (No cuenta con procedimiento de población)
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_equipamientos`(v_password varchar(10))
BEGIN
if v_password = 'qwerty' then
    INSERT INTO tbb_equipamientos VALUES
    (Default, 'Cardio', "Bicicleta estática", "Schwinn 170 Upright Bike.", "Mgr-123", null, '2020-08-10 08:00:00', default, default, default),
    (Default, 'Pilates', "Mancuernas", "Bowflex SelectTech 552 Dumbbells.", "Mgr-123", null, '2020-08-10 08:00:00', default, default, default),
    (Default, 'Yoga', "Prensa de piernas", "Body-Solid Leg Press & Hack Squat GLPH1100.", "Mgr-123", null, '2020-08-10 08:00:00', default, default, default),
    (Default, 'Olimpico', "Barras paralelas", "Lebert Equalizer Bars.", "Mgr-123", null, '2020-08-10 08:00:00', default, default, default),
    (Default, 'Estiramiento y Flexibilidad', "Barras de estiramiento", "ProStretch Plus Calf Stretcher.", "MDL-123", null, '2020-08-10 08:00:00', default, default, default);
	
		update tbb_equipamientos set Area = 'Yoga post-parto' where id = 3;        
        delete from tbb_equipamientos where id = 5;
		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END

-- d) Revisión de los triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, AFTER DELETE): Incompletos / No funcionan
CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_AFTER_INSERT` AFTER INSERT ON `tbb_equipamientos` FOR EACH ROW BEGIN
	
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
        "tbb_equipamientos",
        CONCAT_WS(" ","Se ha insertado un nuevo equipo con los siguientes datos: ",
        "AREA = ", new.Area,
        "NOMBRE = ", new.Nombre,
        "MARCA = ", new.Marca,
        "MODELO = ", new.Modelo,
        "FOTO = ", new.Foto,
        "FECHA REGISTRO = ", new.Fecha_Registro,
        "FECHA ACTUALIZACION = ", new.Fecha_Actualizacion,
        "ESTATUS = ", v_estatus,
        "TOTAL EXISTENCIAS = ", new.Total_Existencias),
        DEFAULT,
		DEFAULT  
    );
END

CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_equipamientos` FOR EACH ROW BEGIN
	set new.Fecha_Actualizacion = current_timestamp();
END

CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_AFTER_UPDATE` AFTER UPDATE ON `tbb_equipamientos` FOR EACH ROW BEGIN
	declare v_estatus_old varchar(20) default 'Activo';
    declare v_estatus_new varchar(20) default 'Activo';
    
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not old.estatus then
		set v_estatus_old = "Inactivo";
	end if;
    if not NEW.estatus then
		set v_estatus_new = "Inactivo";
	end if;
    
    -- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Update",
        "tbb_equipamientos",
        CONCAT_WS(" ","Se ha modificado un equipo existente con los siguientes datos: ",
        "AREA = ",old.Area, '---', new.Area,
        "NOMBRE = ",old.Nombre, '---',  new.Nombre,
        "MARCA = ",old.Marca, '---',  new.Marca,
        "MODELO = ",old.Modelo, '---',  new.Modelo,
        "FOTO = ",old.Foto, '---',  new.Foto,
        "FECHA REGISTRO = ",old.Fecha_Registro, '---',  new.Fecha_Registro,
        "FECHA ACTUALIZACION = ",old.Fecha_Actualizacion, '---',  new.Fecha_Actualizacion,
        "ESTATUS = ",v_estatus_old, '---',  v_estatus_new,
        "TOTAL EXISTENCIAS = ",old.Total_Existencias, '---',  new.Total_Existencias),
        DEFAULT,
		DEFAULT  
    );
END

CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_BEFORE_DELETE` BEFORE DELETE ON `tbb_equipamientos` FOR EACH ROW BEGIN
	declare v_estatus_old varchar(20) default 'Activo';
    
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not old.estatus then
		set v_estatus_old = "Inactivo";
	end if;
    
    -- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Delete",
        "tbb_equipamientos",
        CONCAT_WS(" ","Se ha eliminado un equipo existente con los siguientes datos: ",
        "AREA = ",old.Area,
        "NOMBRE = ",old.Nombre,
        "MARCA = ",old.Marca,
        "MODELO = ",old.Modelo,
        "FOTO = ",old.Foto,
        "FECHA REGISTRO = ",old.Fecha_Registro,
        "FECHA ACTUALIZACION = ",old.Fecha_Actualizacion,
        "ESTATUS = ",v_estatus_old,
        "TOTAL EXISTENCIAS = ",old.Total_Existencias),
        DEFAULT,
		DEFAULT  
    );
END

-- e) Realizar una consulta join



-- Tabla: Ejercicios
-- a) Revisión de la composición de la tabla
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

-- b) Cambios sugeridos: Ninguno

-- c) Revisión de la población estática: No cuenta con un procedimiento de poblarción: El procedimiento funciona correctamente

-- d) Revisión de los triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, AFTER DELETE): Los troggres funcionan correctamente

-- e) Realizar una consulta join
