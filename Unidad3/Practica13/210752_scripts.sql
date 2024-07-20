-- PRACTICA 13: REVISION Y CORRECION DE LAS TABLAS 
-- Servicios al Cliente, Servicios Sucursales, Instalaciones, Equipamiento y Ejercicios


-- Elaborado por Amisadai Fernandez Reyes 
-- Grado y Grupo: 9°B
-- Programa Educativo: Ingenieria de Desarrollo y Gestion de Software
-- Fecha elaboracion: 19 de Junio de 2024

-- Tabla: Servicios al Cliente
-- a) Revision de la composicion de la tabla 
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- b)Cambios sugeridos
-- Fue crear procedimiento para la tabla  y modificar los triggers
-- c)Revision de la Poblacion Estatica(correcion en caso de que sea necesaria)
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_servicios_clientes`(v_password varchar(10))
BEGIN
if v_password = 'abc123' then

    INSERT INTO tbc_servicios_clientes VALUES
    (default, 1, "Consulta", "¿Cuál es el horario de las clases de spinning?", "Cliente interesado en horarios de clase.",default, default, default),
    (default, 3, "Sugerencia", "Sería genial tener una piscina en el gimnasio.", "Comentario positivo sobre la idea.",default, default, default),
    (default, 4, "Reclamo", "El dispensador de agua está vacío.", "Cliente insatisfecho, solicitó recarga urgente.",default, default, default),
    (default, 5, "Consulta", "¿Hay descuentos para grupos familiares?", "Cliente preguntando sobre descuentos.",default, default, default);
      
	update tbc_servicios_clientes set Tipo_Servicio = 'Sugerencia' where ID = 4;
	update tbc_servicios_clientes set Estatus = b'0' where ID = 3;
        
        delete from tbc_servicios_clientes where ID = 1;
		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END

-- d)Revision de 4 triggers(AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, AFTER DELETE)
-- AFTER INSERT
CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_INSERT` AFTER INSERT ON `tbc_servicios_clientes` FOR EACH ROW BEGIN
 DECLARE v_estatus varchar(20) default 'Activo';
	DECLARE v_nombre_persona varchar(60) default null;
    
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not NEW.estatus then
		set v_estatus = "Inactivo";
	end if;
    
    if new.persona_id is not null then
        -- En caso de tener el id del usuario debemos recuperar su nombre
        set v_nombre_persona = (SELECT CONCAT_WS(" ", p.titulo_cortesia, p.nombre, p.primer_apellido) FROM tbb_personas p WHERE id = NEW.persona_id);
    else
        SET v_nombre_persona = "Sin producto asignado";
    end if;
    
    
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        current_user(), 
        "Create", 
        "tbc_servicios_clientes", 
        CONCAT_WS(" ", "Se ha insertado un nuevo servicio al cliente con los siguientes datos",
        "ID de la persona: ", v_nombre_persona,
        "Tipo de Servicio: ", new.Tipo_Servicio,
        "Descripción: ", new.Descripcion,
        "Comentarios: ", new.Comentarios,
        "Estatus: ", v_estatus,
        "Fecha Registro: ", new.Fecha_Registro,
        "Fecha Actualización: ", new.Fecha_Actualizacion
		),
        DEFAULT,
        default
    );

END
-- BEFORE UPDATE 
CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_servicios_clientes` FOR EACH ROW BEGIN
SET new.fecha_actualizacion = current_timestamp();
END
-- AFTER UPDATE 
CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_UPDATE` AFTER UPDATE ON `tbc_servicios_clientes` FOR EACH ROW BEGIN
	
    declare v_estatus_old varchar(20) default 'Activo';
    declare v_estatus_new varchar(20) default 'Activo';
    DECLARE v_nombre_persona_old varchar(60) default null;
    DECLARE v_nombre_persona_new varchar(60) default null;
    
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not old.estatus then
		set v_estatus_old = "Inactivo";
	end if;
    if not NEW.estatus then
		set v_estatus_new = "Inactivo";
	end if;
    
    IF old.persona_id IS NOT NULL THEN 
		-- En caso de tener el id del usuario
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
DEFAULT,
current_user(), 
'Update', 
'tbc_servicios_clientes', 
CONCAT_WS(' ','Se ha modificado Servicio al cliente prestado con los siguientes datos:', 
'ID de quien solicitó el servicio: ', v_nombre_persona_old, v_nombre_persona_new,
'Tipo de servicio: ', old.Tipo_Servicio, ' a pasado a: ', new.Tipo_Servicio, ' - ',
'Descripción: ', old.Descripcion,' a pasado a: ',new.Descripcion,' - ', 
'comentarios: ', old.Comentarios,' a pasado a: ',new.Comentarios,' - ', 
'Fecha actualización: ', old.Fecha_Actualizacion,' a pasado a: ',new.Fecha_Actualizacion,' - ',
'Estatus: ', v_estatus_new 
), 
DEFAULT, 
default 
);

END
-- AFTER DELETE 
CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_DELETE` AFTER DELETE ON `tbc_servicios_clientes` FOR EACH ROW BEGIN


	declare v_estatus_old varchar(20) default 'Activo';
    DECLARE v_nombre_persona_old varchar(60) default null;
    
    -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
    if not old.estatus then
		set v_estatus_old = "Inactivo";
	end if;
    
    IF old.persona_id IS NOT NULL THEN 
		-- En caso de tener el id del usuario
		SET v_nombre_persona_old = (SELECT CONCAT_WS(" ", p.titulo_cortesia, p.nombre, p.primer_apellido) FROM tbb_personas p WHERE id = old.persona_id);
    else
		SET v_nombre_persona_old = "Sin usuario asignado.";
    END IF;
 

INSERT INTO tbi_bitacora VALUES(
default,  
current_user(), 
'Delete', 
'tbc_servicios_clientes',
CONCAT_WS(" ", "Se ha eliminado un servicio de un cliente con los siguientes dato: ",' - ', 
'ID de quien solicitó el servicio: ', v_nombre_persona_old,
'Tipo de servicio: ', old.Tipo_Servicio,' - ',
'Descripción: ', old.Descripcion,' - ', 
'comentarios: ', old.Comentarios,' - ', 
'Fecha actualización: ', old.Fecha_Actualizacion,' - ', 
'Estatus: ', v_estatus_old), 
default,
b'0'
);

END
-- e)Realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion.
select sc.Tipo_Servicio, p.Nombre
From tbc_servicios_clientes sc
join tbb_personas p on p.id = sc.id
order by sc.Tipo_Servicio;

-- Tabla: Servicios Sucursales
-- a) Revision de la composicion de la tabla 
CREATE TABLE `tbd_servicios_sucursales` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Sucursal_ID` int unsigned NOT NULL,
  `ServiciosCliente_ID` int unsigned NOT NULL,
  `Estatus` enum('Iniciada','Proceso','Concluida') DEFAULT 'Concluida',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- b)Cambios sugeridos
-- Modificar las llaves foraneas y los tiggers e incluso el proc. de poblar

-- c)Revision de la Poblacion Estatica(correcion en caso de que sea necesaria)
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_servicios_sucursales`(v_password varchar(10))
BEGIN
if v_password = 'abc123' then

    INSERT INTO tbd_servicios_sucursales VALUES
    (default,1, 4,"Iniciada"),
    (default,2, 5,default),
    (default,3, 6,"Proceso");
    
	update tbd_servicios_sucursales set Estatus = 'Concluida' where id = 2;
        
        delete from tbd_servicios_sucursales where id = 2;
		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END

-- d)Revision de 4 triggers(AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, AFTER DELETE)
-- AFTER INSERT
CREATE DEFINER=`root`@`localhost` TRIGGER `tbd_servicios_sucursales_AFTER_INSERT` AFTER INSERT ON `tbd_servicios_sucursales` FOR EACH ROW BEGIN
DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    IF NOT new.estatus = b'1' THEN
        SET v_estatus = 'Inactivo';
    END IF;
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT, 
        current_user(), 
        "Create", 
        "tbd_servicios_sucursales", 
        CONCAT_WS(" ", "Se ha insertado un nuevo servicio respecto a la sucursal con los siguientes datos", -- Desde aquí
        "ID SUCURSAL", new.Sucursal_ID,
        "ID SERVICIOS CLIENTES", new.ServiciosCliente_ID,
        "ESTATUS", v_estatus), 
        DEFAULT, 
        default 
    );

END
-- BEFORE UPDATE
CREATE DEFINER = CURRENT_USER TRIGGER `gimnasio_9b_idgs_210752`.`tbd_servicios_sucursales_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_servicios_sucursales` FOR EACH ROW
BEGIN
SET new.Fecha_Actualizacion = current_timestamp();
END

-- AFTER UPDATE
CREATE DEFINER=`root`@`localhost` TRIGGER `tbd_servicios_sucursales_AFTER_UPDATE` AFTER UPDATE ON `tbd_servicios_sucursales` FOR EACH ROW BEGIN
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
        DEFAULT, 
        current_user(), 
        "Update", 
        "tbd_servicios_sucursales", 
        CONCAT_WS(" ", "Se ha modificado un servicio respecto a la sucursal con los siguientes datos", -- Desde aquí
        "ID SUCURSAL", old.Sucursal_ID, '---', new.Sucursal_ID,
        "ID SERVICIOS CLIENTES", old.ServiciosCliente_ID, '---',  new.ServiciosCliente_ID,
        "ESTATUS", v_estatus_old, '---',  v_estatus_new), 
        DEFAULT, 
        default 
    );

END

-- AFTER DELETE
CREATE DEFINER=`root`@`localhost` TRIGGER `tbd_servicios_sucursales_BEFORE_DELETE` BEFORE DELETE ON `tbd_servicios_sucursales` FOR EACH ROW BEGIN
DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';

IF NOT old.estatus THEN
SET v_estatus_old = 'Inactivo';
END IF;


    INSERT INTO tbi_bitacora VALUES(
        DEFAULT, 
        current_user(), 
        "Delete", 
        "tbd_servicios_sucursales", 
        CONCAT_WS(" ", "Se ha eliminado un servicio respecto a la sucursal con los siguientes datos", 
        "ID SUCURSAL", old.Sucursal_ID,
        "ID SERVICIOS CLIENTES", old.ServiciosCliente_ID,
        "ESTATUS", v_estatus_old), 
        DEFAULT,
        default 
    );

END
-- e)Realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion.
select concat_ws(" ", nullif(p.titulo_cortesia,''),
p. nombre, p.primer_apellido, p.segundo_apellido) as NombrePersona,
sc.Tipo_Servicio as TipoServicio, s.nombre as NombreSucursal
from tbd_servicios_sucursales ss
join tbb_personas p on ss.id = p.id
join tbc_servicios_clientes sc on sc.id = ss.ServiciosCliente_ID
join tbc_sucursales s on s.id = ss.sucursal_ID;

-- Tabla: Instalaciones
-- a) Revision de la composicion de la tabla 
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

-- b)Cambios sugeridos
-- modificar casi todos los datos de poblar y los triggers
-- c)Revision de la Poblacion Estatica(correcion en caso de que sea necesaria)
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_instalaciones`(v_password varchar(10))
BEGIN

if v_password = 'abc123' then

    INSERT INTO tbb_instalaciones VALUES
     (Default,'Spa Zone', 'Zona de relajación con servicios de spa', 'Área de Spa', '2020-08-10 08:00:00', default, default, default, 1, 'Lunes a Viernes de 9:00am a 7:00pm', null, null),
    (Default,'Cycling Studio', 'Área equipada para clases de ciclismo en grupo', 'Estudio de Ciclismo', '2020-08-10 08:00:00', default, default, default, 1, 'Lunes a Viernes de 6:00am a 9:00pm', null, null),
    (Default,'Swimming Pool', 'Piscina para natación y ejercicios acuáticos', 'Área de Natación', '2020-08-10 08:00:00', default, default, default, 1, 'Lunes a Domingo de 7:00am a 8:00pm', null, null),
    (Default,'Yoga Studio', 'Estudio para clases de yoga y meditación', 'Estudio de Yoga', '2020-08-10 08:00:00', default, default, default, 1, 'Lunes a Domingo de 6:00am a 8:00pm', null, null),
    (Default,'CrossFit Area', 'Zona para entrenamientos de alta intensidad estilo CrossFit', 'Área de CrossFit', '2020-08-10 08:00:00', default, default, default, 1, 'Lunes a Domingo de 5:00am a 10:00pm', null, null);
		UPDATE tbb_instalaciones
		SET Nombre = 'Personal Training Studio'
		WHERE ID = 4;

		UPDATE tbb_instalaciones
		SET Descripcion = 'Área equipada para entrenamientos personalizados con entrenadores'
		WHERE ID = 2;

        
       DELETE FROM tbb_instalaciones
		WHERE ID = 5;

		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END

-- d)Revision de 4 triggers(AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, AFTER DELETE)
-- AFTER INSERT
CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_instalaciones_AFTER_INSERT` AFTER INSERT ON `tbb_instalaciones` FOR EACH ROW BEGIN
 DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    IF NOT new.estatus = b'1' THEN
        SET v_estatus = 'Inactivo';
    END IF;
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT, 
        current_user(), 
        "Create", 
        "tbb_instalaciones", 
        CONCAT_WS(" ", "Se ha insertado una nueva instalació con los siguientes datos", 
        "NOMBRE", new.Nombre,
        "DESCRIPCION", new.Descripcion,
        "TIPO", new.Tipo,
        "FECHA REGISTRO", new.Fecha_Registro,
        "ESTATUS", v_estatus,
        "FECHA ACTUALIZACION", new.Fecha_Actualizacion), 
        DEFAULT, 
        default 
    );

END
-- BEFORE UPDATE
CREATE DEFINER=`valencia`@`%` TRIGGER `tbd_instalacion_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_instalaciones` FOR EACH ROW BEGIN
	set new.Fecha_Actualizacion = current_timestamp();
END
-- AFTER UPDATE
CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_instalaciones_AFTER_UPDATE` AFTER UPDATE ON `tbb_instalaciones` FOR EACH ROW BEGIN
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
        DEFAULT,
        current_user(), 
        "Update", 
        "tbb_instalaciones",
        CONCAT_WS(" ", "Se ha modificado una instalación existente con los siguientes datos", 
        "NOMBRE",old.Nombre, '---', new.Nombre,
        "DESCRIPCION",old.Descripcion, '---',  new.Descripcion,
        "TIPO",old.Tipo, '---',  new.Tipo,
        "FECHA REGISTRO",old.Fecha_Registro, '---',  new.Fecha_Registro,
        "ESTATUS",v_estatus_old,'---', v_estatus_new,
        "FECHA ACTUALIZACION",old.Fecha_Actualizacion, '---',  new.Fecha_Actualizacion),  
        DEFAULT, 
        default 
    );

END
-- AFTER DELETE
CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_instalaciones_BEFORE_DELETE` BEFORE DELETE ON `tbb_instalaciones` FOR EACH ROW BEGIN
DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';

-- Validaciones para las etiquetas del estatus

IF NOT old.estatus THEN
SET v_estatus_old = 'Inactivo';
END IF;


   INSERT INTO tbi_bitacora VALUES(
        DEFAULT, 
        current_user(), 
        "Delete", 
        "tbb_instalaciones", 
        CONCAT_WS(" ", "Se ha eliminado una instalación con los siguientes datos", 
        "NOMBRE",old.Nombre,
        "DESCRIPCION",old.Descripcion,
        "TIPO",old.Tipo,
        "FECHA REGISTRO",old.Fecha_Registro,
        "ESTATUS",v_estatus_old,
        "FECHA ACTUALIZACION",old.Fecha_Actualizacion),  
        DEFAULT, 
        default
    );

END
-- e)Realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion.


-- Tabla: Equipamientos
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- b)Cambios sugeridos
--- modificar los triggers y datos
-- c)Revision de la Poblacion Estatica(correcion en caso de que sea necesaria)
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_equipamientos`(v_password varchar(10))
BEGIN

if v_password = 'abc123' then

    INSERT INTO tbb_equipamientos VALUES
        (Default,'Cardio', 'Cinta de correr', 'NordicTrack Commercial 1750', 'NTL-191', null, '2020-08-10 08:00:00', default, default, default),
         (Default,'Pesas libres', 'Pesas rusas', 'Kettlebell',  'KBL-234', null, '2020-08-10 08:00:00', default, default, default),
         (Default,'Máquinas de Fuerza', 'Máquina de remo', 'Concept2 Model D',  'C2-456', null, '2020-08-10 08:00:00', default, default, default),
         (Default,'Peso Corporal y Entrenamiento Funcional', 'Cuerdas de batalla', 'Battle Ropes',  'BR-789', null, '2020-08-10 08:00:00', default, default, default),
         (Default,'Estiramiento y Flexibilidad', 'Rodillo de espuma', 'Foam Roller', 'FR-012', null, '2020-08-10 08:00:00', default, default, default);

    -- Actualizaciones
    UPDATE tbb_equipamientos
    SET Area = 'Entrenamiento de Alta Intensidad'
    WHERE ID = 3;

    UPDATE tbb_equipamientos
    SET Modelo = 'MDL-321'
    WHERE ID = 2;

    -- Eliminación
    DELETE FROM tbb_equipamientos
    WHERE ID = 5;
		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END
-- d)Revision de 4 triggers(AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, AFTER DELETE)
-- AFTER INSERT
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
-- BEFORE UPDATE
CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_equipamientos` FOR EACH ROW BEGIN
	set new.Fecha_Actualizacion = current_timestamp();
END
-- AFTER UPDATE
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
-- AFTER DELETE
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

-- e)Realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion.

SELECT 
    e.ID AS Equipamiento_ID,
    e.Nombre AS Equipamiento_Nombre,
    e.Area AS Equipamiento_Area,
    i.ID AS Instalacion_ID,
    i.Nombre AS Instalacion_Nombre
FROM 
    tbb_equipamientos e
LEFT JOIN 
    tbb_instalaciones i ON e.Area = i.Tipo
WHERE 
    i.ID IS NULL;


-- Tabla: Ejercicios
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

-- b)Cambios sugeridos
-- modificar los datos para poblar , los trigggers 
-- c)Revision de la Poblacion Estatica(correcion en caso de que sea necesaria)
CREATE DEFINER=`suri`@`%` PROCEDURE `sp_poblar_ejercicios`(v_password varchar(50))
BEGIN

-- Corregido por Marco RH - Menos 2 Firmas

IF v_password = "xYz$123" THEN
	  INSERT INTO tbc_ejercicios VALUES 
        (DEFAULT, "Sentadillas", "Ejercicio compuesto que trabaja principalmente los músculos de las piernas y glúteos, ayudando a mejorar la fuerza y estabilidad del core.", null, "Fuerza", default, 'Basico', default, null, 'Mantener la espalda recta', 'Evitar bajar demasiado rápido'), 
        (DEFAULT, "Flexiones", "Ejercicio que involucra principalmente el pecho, los hombros y los tríceps, contribuyendo al desarrollo de la fuerza del torso superior.", null, "Fuerza", default, 'Intermedio', default, null, 'Mantener el cuerpo alineado', 'Evitar arquear la espalda'), 
        (DEFAULT, "Saltos de Tijera", "Ejercicio aeróbico que mejora la resistencia cardiovascular y la coordinación, involucrando múltiples grupos musculares.", null, "Aerobico", default, 'Basico', default, null, 'Aterrizar suavemente', 'Evitar estirar demasiado las piernas'), 
        (DEFAULT, "Press de Banca", "Ejercicio de fuerza que trabaja principalmente el pecho, los hombros y los tríceps, utilizando una barra con peso.", null, "Fuerza", default, 'Avanzado', default, null, 'Usar un observador', 'Evitar bloquear los codos'), 
        (DEFAULT, "Curl de Bíceps", "Ejercicio de aislamiento que se enfoca en los músculos del bíceps, ayudando a aumentar la masa muscular y la fuerza en los brazos.", null, "Fuerza", default, 'Intermedio', default, null, 'Mantener los codos pegados al cuerpo', 'Evitar balancear el cuerpo');

    -- Actualizar
    UPDATE tbc_ejercicios
    SET Nombre = "Peso Muerto"
    WHERE Nombre = "Remo";

    UPDATE tbc_ejercicios
    SET Tipo = "Aeróbico"
    WHERE Nombre = "Prensas";

    UPDATE tbc_ejercicios
    SET Dificultad = "Básico"
    WHERE Nombre = "Curl de Bíceps";

    -- Eliminar
    DELETE FROM tbc_ejercicios
    WHERE Nombre = "Press de Banca";

    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    
    END IF;

END
-- d)Revision de 4 triggers(AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, AFTER DELETE)
-- AFTER INSERT
CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_AFTER_INSERT` AFTER INSERT ON `tbc_ejercicios` FOR EACH ROW BEGIN
	
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
        "tbc_ejercicios",
        CONCAT_WS(" ","Se ha insertado un nuevo ejercicio con los siguientes datos: ",
        "NOMBRE = ", new.Nombre,
		"DESCRIPCION = ", new.Descripcion,
        "VIDEO = ", new.Video, 
        "TIPO = ", new.Tipo,
        "ESTATUS = ", v_estatus,
        "DIFICULTAD = ", new.Dificultad,
        "FECHA REGISTRO = ", new.Fecha_Registro,
        "FECHA ACTUALIZACION = ", new.Fecha_Actualizacion,
        "RECOMENDACIONES = ", new.Recomendaciones,
        "RESTRICCIONES = ", new.Restricciones),
        DEFAULT,
		DEFAULT  
    );
END
-- BEFORE UPDATE
CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_ejercicios` FOR EACH ROW BEGIN
SET NEW.Fecha_Actualizacion = current_timestamp();
END
-- AFTER UPDATE
CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_AFTER_UPDATE` AFTER UPDATE ON `tbc_ejercicios` FOR EACH ROW BEGIN
DECLARE v_estatus_old varchar(20) default 'Activo';
declare v_estatus_new varchar(20) default 'Activo';

if not old.estatus then
set v_estatus_old = 'Inactivo';
end if;

if not new.estatus then
set v_estatus_new = 'Inactivo';
end if;


-- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Update",
        "tbc_ejercicios",
        CONCAT_WS(" ","Se ha modificado un ejercicio existente con los siguientes datos: ",
        "NOMBRE = ", old.Nombre, '---', new.Nombre,
		"DESCRIPCION = ", old.Descripcion, '---', new.Descripcion,
        "VIDEO = ",old.Video, '---', new.Video, 
        "TIPO = ",old.Tipo, '---', new.Tipo,
        "ESTATUS = ",v_estatus_old, '---', v_estatus_new,
        "DIFICULTAD = ",old.Dificultad, '---', new.Dificultad,
        "FECHA REGISTRO = ",old.Fecha_Registro, '---', new.Fecha_Registro,
        "FECHA ACTUALIZACION = ",old.Fecha_Actualizacion, '---', new.Fecha_Actualizacion,
        "RECOMENDACIONES = ",old.Recomendaciones, '---', new.Recomendaciones,
        "RESTRICCIONES = ",old.Restricciones, '---', new.Restricciones),
        DEFAULT,
		DEFAULT  
    );
END
-- AFTER DELETE
CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_BEFORE_DELETE` BEFORE DELETE ON `tbc_ejercicios` FOR EACH ROW BEGIN
DECLARE v_estatus_old varchar(20) default 'Activo';

if NOT OLD.estatus then
set v_estatus_old = 'Inactivo';
end if;


-- Insertar en la bitacora
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Delete",
        "tbc_ejercicios",
        CONCAT_WS(" ","Se ha eliminado un ejercicio existente con los siguientes datos: ",
        "NOMBRE = ", old.Nombre,
		"DESCRIPCION = ", old.Descripcion,
        "VIDEO = ",old.Video,
        "TIPO = ",old.Tipo,
        "ESTATUS = ",v_estatus_old,
        "DIFICULTAD = ",old.Dificultad,
        "FECHA REGISTRO = ",old.Fecha_Registro,
        "FECHA ACTUALIZACION = ",old.Fecha_Actualizacion,
        "RECOMENDACIONES = ",old.Recomendaciones,
        "RESTRICCIONES = ",old.Restricciones),
        DEFAULT,
		DEFAULT  
    );
END

-- e)Realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion.

