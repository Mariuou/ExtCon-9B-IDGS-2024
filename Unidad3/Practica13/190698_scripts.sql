-- PRÁCTICA 13: REVISIÓN Y CORRECCIÓN DE LAS TABLAS:
-- Servicios al Cliente, Servicios Sucursales, Instalaciones, Equipamiento y Ejercicios

-- Elaborado por: Adán Salas Galván
-- Grado y Grupo: 9º B
-- Programa Educativo: Ingeniería de Desarrollo y Gestión de Software
-- Fecha elaboración: 19 de Julio de 2024

-- Tabla: Servicios al Cliente


-- a) Revisión de la composición de la tabla

CREATE TABLE `tbc_servicios_al_cliente` (
    `id` INT unsigned AUTO_INCREMENT PRIMARY KEY,
    `id_usuario` INT NOT NULL,
    `id_persona` INT NOT NULL,
    `tipo_servicio` ENUM('Servicio Individual','Servicio Grupal') NOT NULL,
    `descripcion` TEXT NOT NULL,
    `comentarios` TEXT,
    `estatus` bit default b'1',
	`fecha_registro` DATE NOT NULL,
	`fecha_actualizacion` DATE
);
-- b) Cambios sugeridos

CREATE TABLE `tbc_servicios_al_cliente` (
    `id` INT unsigned AUTO_INCREMENT PRIMARY KEY,
    `id_usuario` INT NOT NULL,
    `id_persona` INT NOT NULL,
    `tipo_servicio` ENUM('Servicio Individual','Servicio Grupal') NOT NULL, -- Tipo de servicio proporcionado, como Individual fuera de horario, Servicio Grupal fuera de horario
    `descripcion` TEXT NOT NULL,
    `comentarios` TEXT,
    `estatus` bit default b'1',
	`fecha_registro` DATE NOT NULL,
	`fecha_actualizacion` DATE
);

-- c) Revisión de la Población Estática (corrección en caso de ser necesaria)

  INSERT INTO tbc_servicios_al_cliente VALUES
        (default, 1, 15, 'Servicio Individual', 'Descripción del servicio individual 1', 'Comentarios del servicio 1', b'1', CURDATE(), NULL),
        (default, 2, 3, 'Servicio Grupal', 'Descripción del servicio grupal 1', 'Comentarios del servicio 2', b'1', CURDATE(), NULL),
        (default,1, 3, 'Servicio Individual', 'Descripción del servicio individual 2', 'Comentarios del servicio 3', b'1', CURDATE(), NULL),
        (default,4, 3, 'Servicio Grupal', 'Descripción del servicio grupal 2', 'Comentarios del servicio 4', b'1', CURDATE(), NULL),
        (default,5, 3, 'Servicio Individual', 'Descripción del servicio individual 3', 'Comentarios del servicio 5', b'1', CURDATE(), NULL),
        (default,6, 15, 'Servicio Grupal', 'Descripción del servicio grupal 3', 'Comentarios del servicio 6', b'1', CURDATE(), NULL),
        (default,7, 15, 'Servicio Individual', 'Descripción del servicio individual 4', 'Comentarios del servicio 7', b'1', CURDATE(), NULL),
        (default,8, 15, 'Servicio Grupal', 'Descripción del servicio grupal 4', 'Comentarios del servicio 8', b'1', CURDATE(), NULL),
        (default,9, 18, 'Servicio Individual', 'Descripción del servicio individual 5', 'Comentarios del servicio 9', b'1', CURDATE(), NULL),
        (default,10, 15, 'Servicio Grupal', 'Descripción del servicio grupal 5', 'Comentarios del servicio 10', b'1', CURDATE(), NULL);

-- d) Revisión de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, AFTER DELETE)

-- SERVICIO AL CLIENTE : AFTER INSERT

 DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    IF NOT new.estatus = b'1' THEN
        SET v_estatus = 'Inactivo';
    END IF;
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT, -- ID
        current_user(), -- Usuario
        "Create", -- Operación
        "tbc_servicios_al_cliente", -- Tabla
        CONCAT_WS(" ", "Se ha insertado un nuevo servicio al cliente con los siguientes datos", -- Desde aquí
        "ID de la persona: ", new.id_usuario,
        "ID del empleado: ", new.id_persona, 
        "Tipo de Servicio: ", new.tipo_servicio,
        "Descripción: ", new.descripcion,
        "Comentarios: ", new.comentarios,
        "Fecha Registro: ", new.fecha_registro,
        "Fecha Actualización: ", new.fecha_actualizacion,
        "Estatus: ", v_estatus ), -- Hasta aquí -> Descripción 
        DEFAULT, -- Fecha registro 
        default -- Estatus
    );


-- ------------------------------------------------------------------------------------------------------------------------------

-- SERVICIO AL CLIENTE : BEFORE UPDATE
BEGIN
SET new.fecha_actualizacion = current_timestamp();
END

-- ------------------------------------------------------------------------------------------------------------------------------

-- SERVICIO AL CLIENTE: AFTER UPDATE


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
'tbc_servicios_al_cliente', -- Tabla
CONCAT_WS(' ','Se ha modificado Servicio al cliente prestado con los siguientes datos:', -- Desde Aquí
'ID de quien solicitó el servicio: ', old.id_usuario, ' a pasado a: ', new.id_usuario, ' - ',-- Id usuario (Cliente)
'ID de quien prestó el servicio: ', old.id_persona, ' a pasado a: ', new.id_persona, ' - ',-- Id persona (Cliente)
'Tipo de servicio: ', old.tipo_servicio, ' a pasado a: ', new.tipo_servicio, ' - ',-- Tipo de servicio
'Descripción: ', old.descripcion,' a pasado a: ',new.descripcion,' - ', -- Descripción
'comentarios: ', old.comentarios,' a pasado a: ',new.comentarios,' - ', -- Comentarios
'Fecha actualización: ', old.fecha_actualizacion,' a pasado a: ',new.fecha_actualizacion,' - ', -- Fecha de Actualización
'Estatus: ', v_estatus_new 
), --   Hasta Aquí -> Descripción
DEFAULT, -- Fecha Registro
default -- Estatus
);
-- ------------------------------------------------------------------------------------------------------------------------------

-- SERVICIOS AL CLIENTE: BEFORE DELETE

 DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
  IF NOT OLD.estatus THEN
        SET v_estatus = 'Inactiva';
    END IF;

    INSERT INTO tbi_bitacora VALUES (
        DEFAULT, -- ID
        current_user(), -- Usuario
        'Delete', -- Operación
        'tbc_servicios_al_cliente', -- Tabla
        CONCAT_WS(" ", "Se ha eliminado un servicio al cliente con los siguientes datos:", -- Desde aquí
            "ID de quien solicitó el servicio: ", OLD.id_usuario,
            "ID de quien prestó el servicio: ", OLD.id_persona, 
            "Tipo de servicio: ", OLD.tipo_servicio,
            "Descripción: ", OLD.descripcion,
            "Comentarios: ", OLD.comentarios,
            "Estatus: ", v_estatus,
            "Fecha actualización: ", OLD.fecha_actualizacion
        ), -- Hasta aquí -> Descripción 
        DEFAULT, -- Fecha registro 
        b'0' -- Estatus
    );
-- e) Realizar una consulta join (en caso de que aplique) para comprobar la integridad de la información.
