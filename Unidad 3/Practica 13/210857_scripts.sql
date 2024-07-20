-- PRACTICA 13: REVISION Y CORRECCION DE LAS TABLAS:
-- Servicios al Cliente, Servicios Sucursales, Instalaciones, Equipamiento y Ejercicios

-- Elaborado por: Maximiliano Amador Peña
-- Grado y Grupo: 9° B
-- Programa Educativo: Ingenierira de Desarrollo y Gestion de Software
-- Fecha elaboracion: 19 de Julio de 2024

-- Tabla de Servicios al Cliente
-- a) Revision de la composicion de la tabla
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


-- b) Cambios sugeridos
CREATE TABLE `tbd_servicios_al_cliente` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_persona` int unsigned NOT NULL,
  `id_empleado` int unsigned NOT NULL,
  `tipo_opinion` enum('Consulta','reclamo','Sugerencia') NOT NULL, -- cambio de nombre de campo
  `descripcion` text NOT NULL,
  `comentarios` text,
  `estatus` bit(1) DEFAULT b'1',
  `fecha_registro` date NOT NULL,
  `fecha_actualizacion` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_persona` (`id_persona`),
  KEY `id_empleado` (`id_empleado`),
  CONSTRAINT `tbd_servicios_al_cliente_ibfk_1` FOREIGN KEY (`id_persona`) REFERENCES `tbb_personas` (`ID`),
  CONSTRAINT `tbd_servicios_al_cliente_ibfk_2` FOREIGN KEY (`id_empleado`) REFERENCES `tbb_empleado` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- c) Revision de la poblacion estatica (correcion en caso de ser necesaria)
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_servicios_al_cliente`(v_password varchar(20))
BEGIN
	if v_password = "1234" then 
    insert into tbd_servicios_al_cliente values
    (default, 5, 1,"Consulta","Que servicios se brindan el las sucursales","Ningun comentario",default,default,default),
    (default, 3, 2,"Sugerencia","Que servicios se brindan el las sucursales","Ningun comentario",default,default,default),
    (default, 4, 4,"Reclamo","Que servicios se brindan el las sucursales","Ningun comentario",default,default,default),
    (default, 1, 3,"Consulta","Que servicios se brindan el las sucursales","Ningun comentario",default,default,default);
    
    UPDATE tbd_servicios_al_cliente SET tipo_opinion = "Reclamo" WHERE id=1;

	DELETE FROM tbd_servicios_al_cliente WHERE id=4;

	ELSE
	SELECT "La contraseña es incorrecta" AS ErrorMessage;

END IF;

END
-- d) Revision de los 4 triggers

  --AFTER INSERT
  CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_INSERT` AFTER INSERT ON `tbd_servicios_al_cliente` FOR EACH ROW BEGIN
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
        "Tipo de opinion: ", new.tipo_opinion,
        "Descripción: ", new.descripcion,
        "Comentarios: ", new.comentarios,
        "Fecha Registro: ", new.fecha_registro,
        "Fecha Actualización: ", new.fecha_actualizacion,
        "Estatus: ", v_estatus ), -- Hasta aquí -> Descripción 
        DEFAULT, -- Fecha registro 
        default -- Estatus
    );

END

  -- AFTER UPDATE 
  CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_UPDATE` AFTER UPDATE ON `tbd_servicios_al_cliente` FOR EACH ROW BEGIN
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
'Tipo de opinion: ', old.tipo_opinion, ' a pasado a: ', new.tipo_opinion, ' - ',-- Tipo de servicio
'Descripción: ', old.descripcion,' a pasado a: ',new.descripcion,' - ', -- Descripción
'comentarios: ', old.comentarios,' a pasado a: ',new.comentarios,' - ', -- Comentarios
'Fecha actualización: ', old.fecha_actualizacion,' a pasado a: ',new.fecha_actualizacion,' - ', -- Fecha de Actualización
'Estatus: ', v_estatus_new 
), --   Hasta Aquí -> Descripción
DEFAULT, -- Fecha Registro
default -- Estatus
);

END

  --AFTER DELETE
  CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_DELETE` AFTER DELETE ON `tbd_servicios_al_cliente` FOR EACH ROW BEGIN


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
'Tipo de opinion: ', old.tipo_opinion,' - ',-- Tipo de servicio
'Descripción: ', old.descripcion,' - ', -- Descripción
'comentarios: ', old.comentarios,' - ', -- Comentarios
'Fecha actualización: ', old.fecha_actualizacion,' - ', -- Fecha de Actualización
'Estatus: ', v_estatus), -- Hasta aquí -> Descripción
default, -- Fecha Registro
b'0' -- Estatus
);

END

-- e) Realizar una consulta join(en caso de que aplique) para comprobar la integridad de la informacion


-- Tabla de Servicios Sucursales
-- a) Revision de la composicion de la tabla
CREATE TABLE sucursales_servicios(
ID int unsigned primary key  auto_increment,
sucursal_id int unsigned ,
servicio_id int unsigned ,
estatus enum('Disponible','No disponible')
);

-- b) Cambios sugeridos
CREATE TABLE sucursales_servicios(
ID int unsigned primary key  auto_increment,
sucursal_id int unsigned ,
servicio_id int unsigned ,
estatus enum('Disponible','No disponible')
);

-- c) Revision de la poblacion estatica (correcion en caso de ser necesaria)
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_servicios_sucursales`(v_password varchar(10))
BEGIN
if v_password = '1234' then

    INSERT INTO tbd_servicios_sucursales VALUES
    (default,1, 2,DEFAULT),
    (default,2, 3,default),
    (default,3, 4,default);
    
	update tbd_servicios_sucursales set Estatus = 'Iniciada' where id = 2;
        
        delete from tbd_servicios_sucursales where id = 1;
		else
		select "La contraseña es incorrecta" as Mensaje;
	end if;
END
-- d) Revision de los 4 triggers
    --AFTER INSERT
CREATE DEFINER=`root`@`localhost` TRIGGER `sucursales_servicios_AFTER_INSERT` AFTER INSERT ON `sucursales_servicios` FOR EACH ROW BEGIN
DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    IF NOT new.estatus = b'1' THEN
        SET v_estatus = 'Inactivo';
    END IF;
INSERT INTO bitacora VALUES(
		DEFAULT,
        USER(),
        "Create",
        "sucursales_servicios",
        CONCAT_WS(" ","Se ha insertado un nuevo registro 
        con los siguientes datos:  SUCURSAL_ID = ", NEW.sucursal_id,
        "SERVICIO_ID =", NEW.servicio_id,
        "ESTATUS =", NEW.estatus),
        NOW(),
        DEFAULT
    );
END
    --AFTER UPDATE
CREATE DEFINER=`root`@`localhost` TRIGGER `sucursales_servicios_AFTER_UPDATE` AFTER UPDATE ON `sucursales_servicios` FOR EACH ROW BEGIN
DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Activo';

-- Validaciones para las etiquetas del estatus

IF NOT old.estatus THEN
SET v_estatus_old = 'Inactivo';
END IF;

IF NOT new.estatus THEN
SET v_estatus_new = 'Inactivo';
END IF;
INSERT INTO bitacora VALUES(
		DEFAULT,
        USER(),
        "update",
        "sucursales_servicios",
        CONCAT_WS("Se ha actualizado un nuevo registro 
        con los siguientes datos:  SUCURSAL_ID = ",OLD.sucursal_id," cambio a ", NEW.sucursal_id,
        "SERVICIO_ID =",OLD.servicio_id," cambio a ", NEW.servicio_id,
        "ESTATUS =",OLD.estatus," cambio a ", NEW.estatus),
        NOW(),
        DEFAULT
    );
END
    --AFTER DELETE
    CREATE DEFINER=`root`@`localhost` TRIGGER `sucursales_servicios_AFTER_DELETE` AFTER DELETE ON `sucursales_servicios` FOR EACH ROW BEGIN
INSERT INTO bitacora VALUES(
		DEFAULT,
        USER(),
        "Delete",
        "sucursales_servicios",
        CONCAT_WS("Se ha eliminado una registro : ", OLD.servicio_id),
        now(),
        DEFAULT
    );
END
-- e) Realizar una consulta join(en caso de que aplique) para comprobar la integridad de la informacion


-- Tabla Instalaciones
-- a) Revision de la composicion de la tabla
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

-- b) Cambios sugeridos
    --Ninguno

-- c) Revision de la poblacion estatica (correcion en caso de ser necesaria)
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_instalaciones`(v_password varchar(20))
BEGIN

if v_password = '1234' then

    INSERT INTO tbb_instalaciones VALUES
    (Default,  "Zona de mancuernas", "Ejercicio", '2020-08-10 08:00:00', default, default, default,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
    (Default,  "Zona de cardio", "Ejercicio",'2020-08-10 08:00:00', default, default, default,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
    (Default,  "Zona de yoga", "Ejercicio", '2020-08-10 08:00:00', default, default, default,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
    (Default,  "Zona de boxeo", "Ejercicio", '2020-08-10 08:00:00', default, default, default,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
    (Default,  "Zona de baños", "Baños", '2020-08-10 08:00:00', default, default, default,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null);
    
		update tbb_instalaciones set Nombre = 'Personal Training' where id = 4;
        update tbb_instalaciones set Descripcion = 'Zona de recepcion' where id = 2;
        
        delete from tbb_instalaciones where id = 5;
		else
		select "La contraseña es incorrecta" as Mensaje;
	end if;
END

-- d) Revision de los 4 triggers

    --AFTER INSTER
CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_instalaciones_AFTER_INSERT` AFTER INSERT ON `tbb_instalaciones` FOR EACH ROW BEGIN
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
        CONCAT_WS(" ","Se ha insertado una nueva instalacion con los datos: ",
            "ID = ", NEW.id,
            "DESCRIPCION = ", NEW.descripcion,
            "TIPO = ", NEW.tipo,
            "FECHA_REGISTRO = ", NEW.fecha_registro,
            "FECHA_ACTUALIZACION = ", NEW.fecha_actualizacion,
            "CALIFICACION = ", NEW.calificacion,
            "ID_SUCURSAL = ", NEW.id_sucursal,
            "HORARIO_DISPONIBILIDAD = ", NEW.horario_disponibilidad,
            "SERVICIO = ", NEW.servicio,
            "OBSERVACIONES = ", NEW.observaciones,
            "ESTATUS = ", v_estatus),
        DEFAULT,
        DEFAULT
    );
END
    --BEFORE UPDATE
CREATE DEFINER=`valencia`@`%` TRIGGER `tbd_instalacion_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_instalaciones` FOR EACH ROW BEGIN
	set new.Fecha_Actualizacion = current_timestamp();
END
    --AFTER UPDATE
CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_instalaciones_AFTER_UPDATE` AFTER UPDATE ON `tbb_instalaciones` FOR EACH ROW BEGIN
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
        "Create",
        "evaluacionServicio",
        CONCAT_WS(" ","Se ha insertado una nueva instalacion con los datos: ",
            "ID = ",OLD.id, NEW.id,
            "DESCRIPCION = ",OLD.descripcion, NEW.descripcion,
            "TIPO = ",OLD.tipo, NEW.tipo,
            "FECHA_REGISTRO = ",OLD.fecha_registro, NEW.fecha_registro,
            "FECHA_ACTUALIZACION = ",OLD.fecha_actualizacion, NEW.fecha_actualizacion,
            "CALIFICACION = ",OLD.calificacion, NEW.calificacion,
            "ID_SUCURSAL = ",OLD.id_sucursal, NEW.id_sucursal,
            "HORARIO_DISPONIBILIDAD = ",OLD.horario_disponibilidad, NEW.horario_disponibilidad,
            "SERVICIO = ",OLD.servicio, NEW.servicio,
            "OBSERVACIONES = ",OLD.observaciones, NEW.observaciones,
            "ESTATUS = ",v_estatus_old, v_estatus),
        DEFAULT,
        DEFAULT
    );
END
    --BEFORE DELETE
CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_instalaciones_BEFORE_DELETE` BEFORE DELETE ON `tbb_instalaciones` FOR EACH ROW BEGIN
DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    IF  not OLD.estatus then
        set v_estatus = "Inactiva";
    end if;
    
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "evaluacionServicio",
        CONCAT_WS(" ","Se ha insertado una nueva instalacion con los datos: ",
            "ID = ",OLD.id, 
            "DESCRIPCION = ",OLD.descripcion,
            "TIPO = ",OLD.tipo, 
            "FECHA_REGISTRO = ",OLD.fecha_registro, 
            "FECHA_ACTUALIZACION = ",OLD.fecha_actualizacion, 
            "CALIFICACION = ",OLD.calificacion,
            "ID_SUCURSAL = ",OLD.id_sucursal, 
            "HORARIO_DISPONIBILIDAD = ",OLD.horario_disponibilidad, 
            "SERVICIO = ",OLD.servicio, 
            "OBSERVACIONES = ",OLD.observaciones,
            "ESTATUS = ",v_estatus_old),
        DEFAULT,
        DEFAULT
    );
END
-- e) Realizar una consulta join(en caso de que aplique) para comprobar la integridad de la informacion


-- Tabla de Equipamiento
-- a) Revision de la composicion de la tabla
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- b) Cambios sugeridos
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- c) Revision de la poblacion estatica (correcion en caso de ser necesaria)
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_equipamientos`(v_password varchar(10))
BEGIN

if v_password = '1234' then

    INSERT INTO tbb_equipamientos VALUES
    (Default, 'Cardio', "Bicicleta estática", "Schwinn 170 Upright Bike.", "MDL-123", null, '2020-08-10 08:00:00', default, default, default),
    (Default, 'Pesas libres', "Mancuernas", "Bowflex SelectTech 552 Dumbbells.", "MDL-123", null, '2020-08-10 08:00:00', default, default, default),
    (Default, 'Máquinas de Fuerza', "Prensa de piernas", "Body-Solid Leg Press & Hack Squat GLPH1100.", "MDL-123", null, '2020-08-10 08:00:00', default, default, default),
    (Default, 'Mancuernas', "Barras paralelas", "Lebert Equalizer Bars.", "MDL-123", null, '2020-08-10 08:00:00', default, default, default),
    (Default, 'Barras laterales', "Barras de estiramiento", "ProStretch Plus Calf Stretcher.", "MDL-123", null, '2020-08-10 08:00:00', default, default, default);
	
		update tbb_equipamientos set Area = 'Pesas ruasas' where id = 3;
        update tbb_equipamientos set Modelo = 'AMSO' where id = 2;
        
        delete from tbb_equipamientos where id = 5;
		else
		select "La contraseña es incorrecta" as Mensaje;
	end if;
END
-- d) Revision de los 4 triggers
    --after insert
    CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_AFTER_INSERT` AFTER INSERT ON `tbb_equipamientos` FOR EACH ROW BEGIN
	
    DECLARE v_estatus varchar(20) default 'Activo';
    
    if not NEW.estatus then
		set v_estatus = "Inactivo";
	end if;
    
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
  --before update
  CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_equipamientos` FOR EACH ROW BEGIN
	set new.Fecha_Actualizacion = current_timestamp();
END
  --after update
CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_AFTER_UPDATE` AFTER UPDATE ON `tbb_equipamientos` FOR EACH ROW BEGIN
	declare v_estatus_old varchar(20) default 'Activo';
    declare v_estatus_new varchar(20) default 'Activo';
    
    if not old.estatus then
		set v_estatus_old = "Inactivo";
	end if;
    if not NEW.estatus then
		set v_estatus_new = "Inactivo";
	end if;
    
   
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
  -- before delete
  CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_BEFORE_DELETE` BEFORE DELETE ON `tbb_equipamientos` FOR EACH ROW BEGIN
	declare v_estatus_old varchar(20) default 'Activo';
    

    if not old.estatus then
		set v_estatus_old = "Inactivo";
	end if;
    

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
-- e) Realizar una consulta join(en caso de que aplique) para comprobar la integridad de la informacion

-- Tabla de Ejercicios
-- a) Revision de la composicion de la tabla
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

-- b) Cambios sugeridos
        -- Ninguno

-- c) Revision de la poblacion estatica (correcion en caso de ser necesaria)
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

END
-- d) Revision de los 4 triggers
        --AFTER INSERT
    CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_AFTER_INSERT` AFTER INSERT ON `tbc_ejercicios` FOR EACH ROW BEGIN
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
END
        --BEFORE UPDATE
CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_ejercicios` FOR EACH ROW BEGIN
SET NEW.Fecha_actualizacion = current_timestamp();
END
        --AFTER UPDATE
CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_AFTER_UPDATE` AFTER UPDATE ON `tbc_ejercicios` FOR EACH ROW BEGIN
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
END
        --BEFORE DELETE
CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_BEFORE_DELETE` BEFORE DELETE ON `tbc_ejercicios` FOR EACH ROW BEGIN
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
END
-- e) Realizar una consulta join(en caso de que aplique) para comprobar la integridad de la informacion
SELECT 
  e.ID AS Ejercicio_ID,
  e.Nombre AS Nombre_Ejercicio,
  e.Descripcion AS Descripcion_Ejercicio,
  e.Video,
  e.Tipo,
  e.Estatus,
  e.Dificultad,
  e.Fecha_Registro,
  e.Fecha_Actualizacion,
  e.Recomendaciones,
  e.Restricciones,
  c.ID AS Categoria_ID,
  c.Nombre AS Nombre_Categoria,
  c.Descripcion AS Descripcion_Categoria
FROM 
  tbc_ejercicios e
JOIN 
  tbc_ejercicios_categorias ec ON e.ID = ec.Ejercicio_ID
JOIN 
  tbc_categorias c ON ec.Categoria_ID = c.ID;
