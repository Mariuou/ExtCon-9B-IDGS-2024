-- PRACTICA 13: REVISION Y CORRECCION DE LAS TABLAS:
--Servicios al cliente, Servicio Sucursales, Instalaciones, Equipamientos y Ejercicios.

--Elaborado por: Suri Jazmin Peña Lira.
--Grado y Grupo: 9°B
--Programa Educativo: Ingenieria de Desarrollo de Software.
--Fecha elaboracion: 19 de Julio del 2024.

-- SERVICIOS AL CLIENTE 
-- a) Revision de la composicion de la tabla.
CREATE TABLE `tbc_servicios_al_cliente` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


-- b) Correccion de la tabla.CREATE TABLE `tbc_servicios_al_cliente` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_persona` int unsigned NOT NULL,
  `id_empleado` int unsigned NOT NULL,
  `tipo_servicio` enum('Consulta','Reclamo','Sugerencia') NOT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

-- c)Revicion de la Poblacion Estatica (Correccion en caso de ser necesarios)
   CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_servicios_clientes`(v_password varchar(10))
BEGIN
        if v_password = '1234' then

        INSERT INTO tbc_servicios_clientes VALUES
	(1, 2, 'Consulta', 'Descripción de consulta 1', 'Comentarios 1', DEFAULT, DEFAULT, NULL), 
    (3, 4, 'Reclamo', 'Descripción de reclamo 2', 'Comentarios 2', DEFAULT, DEFAULT, NULL), 
    (5, 6, 'Sugerencia', 'Descripción de sugerencia 3', 'Comentarios 3', DEFAULT, DEFAULT, NULL), 
    (7, 8, 'Consulta', 'Descripción de consulta 4', 'Comentarios 4', DEFAULT, DEFAULT, NULL), 
    (9, 10, 'Reclamo', 'Descripción de reclamo 5', 'Comentarios 5', DEFAULT, DEFAULT, NULL);
        
        update tbc_servicios_clientes set Tipo_Servicio = 'Reclamo' where id = 4;
        update tbc_servicios_clientes set Estatus = b'0' where id = 2;
            
            delete from tbc_servicios_clientes where id = 1;
            else
            select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
        end if;
        END

-- d)Revision de los 4 triggers

-- AFTER INSERT
CREATE DEFINER=`adan`@`%` TRIGGER `tbc_servicios_al_cliente_AFTER_INSERT` AFTER INSERT ON `tbc_servicios_clientes` FOR EACH ROW BEGIN
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
        "Tipo de Servicio: ", new.tipo_servicio,
        "Descripción: ", new.descripcion,
        "Comentarios: ", new.comentarios,
        "Fecha Registro: ", new.fecha_registro,
        "Fecha Actualización: ", new.fecha_actualizacion,
        "Estatus: ", v_estatus ), 
        DEFAULT, 
        default 
    );

END

-- ------------------------BEFORE UPDATE-----------------------------
CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_servicios_al_cliente` FOR EACH ROW BEGIN
SET new.fecha_actualizacion = current_timestamp();
END

-- ------------------------AFTER UPDATE-----------------------------
CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_UPDATE` AFTER UPDATE ON `tbc_servicios_al_cliente` FOR EACH ROW BEGIN
	
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
DEFAULT, 
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
DEFAULT, 
default 
);

END
-- ------------------------AFTER DELETE-----------------------------
CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_DELETE` AFTER DELETE ON `tbc_servicios_al_cliente` FOR EACH ROW BEGIN


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
'Tipo de servicio: ', old.tipo_servicio,' - ',
'Descripción: ', old.descripcion,' - ', 
'comentarios: ', old.comentarios,' - ', 
'Fecha actualización: ', old.fecha_actualizacion,' - ', 
'Estatus: ', v_estatus_old),
default, 
b'0'
);

END

--e) realizar consultas con joins para verificar la integridad de los datos.

-- SERVICIOS SUCURSALES




-- INSTALACIONES

-- EQUIPAMINETOS

-- EJERCISIOS