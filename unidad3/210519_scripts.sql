-- PRACTICA 13: REVISION Y CORRECION DE LAS TABLAS:
-- Servicios al cliente, servicios sucursales, instalaciones, equipamiento, ejercicios
-- Elaborado por: Ing. Edgar Pérez Garrido
-- Grado y Grupo: 9B
-- Programa Educativo: Ingenieria en Desarrollo y Gestion de Software
-- Fecha elaboracion: 19 de julio 2024

-- Tabla servicios al cliente
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

-- b) cambios sugeridos
-- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_servicios_clientes`(v_password varchar(10))
    BEGIN
    if v_password = '1234' then

    INSERT INTO tbc_servicios_clientes VALUES
    (default, 1, "Reclamo", "El aire acondicionado en la zona de cardio no está funcionando.", "Cliente muy molesto, solicitó solución urgente.",default, default, default),
    (default, 3, default, "Sería útil tener más clases de yoga por la mañana.", "Comentario positivo sobre las clases actuales.",default, default, default),
    (default, 4, default, "Excelente atención del entrenador personal.", "Cliente muy satisfecho con los resultados obtenidos.",default, default, default),
    (default, 5, default, "Las máquinas de pesas libres no se limpian regularmente.", "Cliente sugirió más toallas desinfectantes cerca de las máquinas.",default, default, default);
      
	update tbc_servicios_clientes set Tipo_Servicio = 'Reclamo' where id = 4;
	update tbc_servicios_clientes set Estatus = b'0' where id = 2;
        
        delete from tbc_servicios_clientes where id = 1;
		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
END
-- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
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
        DEFAULT, -- ID
        current_user(), -- Usuario
        "Create", -- Operación
        "tbc_servicios_clientes", -- Tabla
        CONCAT_WS(" ", "Se ha insertado un nuevo servicio al cliente con los siguientes datos", -- Desde aquí
        "ID de la persona: ", v_nombre_persona,
        "Tipo de Servicio: ", new.tipo_servicio,
        "Descripción: ", new.descripcion,
        "Comentarios: ", new.comentarios,
        "Fecha Registro: ", new.fecha_registro,
        "Fecha Actualización: ", new.fecha_actualizacion,
        "Estatus: ", v_estatus ), -- Hasta aquí -> Descripción 
        DEFAULT, -- Fecha registro 
        default -- Estatus
    );
END
-- -----------------------------------------------------------------------------------------------------
CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_servicios_clientes` FOR EACH ROW BEGIN
    SET new.fecha_actualizacion = current_timestamp();
END
-- -----------------------------------------------------------------------------------------------------
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
		-- En caso de tener el id del usuario
		SET v_nombre_persona_new = (SELECT CONCAT_WS(" ", p.titulo_cortesia, p.nombre, p.primer_apellido) FROM tbb_personas p WHERE id = NEW.persona_id);
    else
		SET v_nombre_persona_new = "Sin usuario asignado.";
    END IF;

    INSERT INTO tbi_bitacora VALUES(
    DEFAULT, -- ID
    current_user(), -- Usuario
    'Update', -- Operación 
    'tbc_servicios_clientes', -- Tabla
    CONCAT_WS(' ','Se ha modificado Servicio al cliente prestado con los siguientes datos:', -- Desde Aquí
    'ID de quien solicitó el servicio: ', v_nombre_persona_old, v_nombre_persona_new,
    'Tipo de servicio: ', old.tipo_servicio, ' a pasado a: ', new.tipo_servicio, ' - ',-- Tipo de servicio
    'Descripción: ', old.descripcion,' a pasado a: ',new.descripcion,' - ', -- Descripción
    'comentarios: ', old.comentarios,' a pasado a: ',new.comentarios,' - ', -- Comentarios
    'Fecha actualización: ', old.fecha_actualizacion,' a pasado a: ',new.fecha_actualizacion,' - ', -- Fecha de Actualización
    'Estatus: ', v_estatus_new 
    ), --   Hasta Aquí -> Descripción
    DEFAULT, -- Fecha Registro
    default -- Estatus
    );

    END
-- -----------------------------------------------------------------------------------------------------
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
    default, -- ID 
    current_user(), -- Usuario
    'Delete', -- Operación 
    'tbc_servicios_clientes', -- Tabla
    CONCAT_WS(" ", "Se ha eliminado un servicio de un cliente con los siguientes dato: ",' - ', -- Desde Aquí
    'ID de quien solicitó el servicio: ', v_nombre_persona_old,
    'Tipo de servicio: ', old.tipo_servicio,' - ',-- Tipo de servicio
    'Descripción: ', old.descripcion,' - ', -- Descripción
    'comentarios: ', old.comentarios,' - ', -- Comentarios
    'Fecha actualización: ', old.fecha_actualizacion,' - ', -- Fecha de Actualización
    'Estatus: ', v_estatus_old), -- Hasta aquí -> Descripción
    default, -- Fecha Registro
    b'0' -- Estatus
    );

    END
-- e) realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion

-- Tabla servicios sucursales
-- a) Revision de la composicion de la tabla
-- b) cambios sugeridos
-- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
-- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
-- e) realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion 

-- Tabla instalaciones
-- a) Revision de la composicion de la tabla
-- b) cambios sugeridos
-- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
-- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
-- e) realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion 

-- Tabla equipamiento
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

-- b) cambios sugeridos
-- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_equipamientos`(v_password varchar(10))
    BEGIN

    if v_password = '1234' then

    INSERT INTO tbb_equipamientos VALUES
    (Default, 'Cardio', "Bicicleta estática", "Schwinn 170 Upright Bike.", "MDL-123", null, '2020-08-10 08:00:00', default, default, default),
    (Default, 'Pesas libres', "Mancuernas", "Bowflex SelectTech 552 Dumbbells.", "MDL-123", null, '2020-08-10 08:00:00', default, default, default),
    (Default, 'Máquinas de Fuerza', "Prensa de piernas", "Body-Solid Leg Press & Hack Squat GLPH1100.", "MDL-123", null, '2020-08-10 08:00:00', default, default, default),
    (Default, 'Peso Corporal y Entrenamiento Funcional', "Barras paralelas", "Lebert Equalizer Bars.", "MDL-123", null, '2020-08-10 08:00:00', default, default, default),
    (Default, 'Estiramiento y Flexibilidad', "Barras de estiramiento", "ProStretch Plus Calf Stretcher.", "MDL-123", null, '2020-08-10 08:00:00', default, default, default);
	
		update tbb_equipamientos set Area = 'Entrenamiento de Alta Intensidad' where id = 3;
        update tbb_equipamientos set Modelo = 'MDL-321' where id = 2;
        
        delete from tbb_equipamientos where id = 5;
		else
		select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
	end if;
    END
-- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
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
-- ----------------------------------------------------------------------------------------------------
CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_equipamientos` FOR EACH ROW BEGIN
	set new.Fecha_Actualizacion = current_timestamp();
    END
-- ----------------------------------------------------------------------------------------------------
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
-- --------------------------------------------------------------------------------------------------------
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
-- e) realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion 

-- Tabla ejercicios
-- a) Revision de la composicion de la tabla
-- b) cambios sugeridos
-- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
-- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
-- e) realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion 