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


-- c) Revisión de la población estática: No cuenta con un procedimiento de poblarción (Se procede a crear)
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

-- b) Cambios sugeridos

-- c) Revisión de la población estática: No cuenta con un procedimiento de poblarción 

-- d) Revisión de los triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, AFTER DELETE):

-- e) Realizar una consulta join


-- Tabla: Instalaciones
-- a) Revisión de la composición de la tabla

-- b) Cambios sugeridos

-- c) Revisión de la población estática: No cuenta con un procedimiento de poblarción 

-- d) Revisión de los triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, AFTER DELETE):

-- e) Realizar una consulta join


-- Tabla: Equipamiento
-- a) Revisión de la composición de la tabla

-- b) Cambios sugeridos

-- c) Revisión de la población estática: No cuenta con un procedimiento de poblarción 

-- d) Revisión de los triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, AFTER DELETE):

-- e) Realizar una consulta join


-- Tabla: Ejercicios
-- a) Revisión de la composición de la tabla

-- b) Cambios sugeridos

-- c) Revisión de la población estática: No cuenta con un procedimiento de poblarción 

-- d) Revisión de los triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, AFTER DELETE):

-- e) Realizar una consulta join
