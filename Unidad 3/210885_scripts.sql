-- PRACTICA 13: REVISIÓN Y CORRECCIÓN DE LAS TABLAS:
-- SERVICIOS AL CLIENTE, SERVICIOS SUCURSALES, INSTALACIONES, EQUIPAMIENTO Y EJERCICIOS

-- ELABORADO POR: Maria Lorena Ascencion Andres
--GRADO Y GRUPO: 9°'B'
--PROGRAMA EDUCATIVO: Ingeniería en Desarrollo y Gestión de Software
-- FECHA ELABORACIÓN: 19 de julio de 2024

-- ------------TABLA: tbc_servicios_clientes
-- a) Revision de la composición de la tabla
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

-- b) Cambios sugeridos
-- Ninguno, por el momento

-- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_servicios_clientes`(v_password varchar(10))
    BEGIN
    if v_password = '1234' then

    INSERT INTO tbc_servicios_clientes VALUES
        (default, 2, 'Consulta', '¿Cuáles son los horarios de las clases de spinning?', 'Cliente interesado en unirse a las clases.', default, default, default),
        (default, 3, 'Reclamo', 'El dispensador de agua está vacío.', 'Cliente molesto, sugirió verificarlo regularmente.', default, default, default),
        (default, 1, 'Sugerencia', 'Sería genial tener música en vivo los fines de semana.', 'Comentario positivo sobre la atmósfera del gimnasio.', default, default, default),
        (default, 4, 'Reclamo', 'Los vestuarios están sucios.', 'Cliente solicitó una limpieza más frecuente.', default, default, default);

        UPDATE tbc_servicios_clientes SET Tipo_Servicio = 'Consulta' WHERE ID = 3;
        UPDATE tbc_servicios_clientes SET Estatus = b'0' WHERE ID = 1;

        DELETE FROM tbc_servicios_clientes WHERE ID = 2;
        else
        select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
    end if;
    END

-- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
-- -------------AFTER INSERT
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
    -- ----------------------------------------BEFORE UPDATE
CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_servicios_clientes` FOR EACH ROW BEGIN
    SET new.fecha_actualizacion = current_timestamp();
    END
    -- ----------------------------------------AFTER UPDATE
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
    -- ------------------------------------AFTER DELETE
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
-- NO APLICA 

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Tabla: tbd_servicios_sucursales
    -- a) Revision de la composicion de la tabla
    CREATE TABLE `tbd_servicios_sucursales` (
    `ID` int unsigned NOT NULL AUTO_INCREMENT,
    `Sucursal_ID` int unsigned NOT NULL,
    `ServiciosCliente_ID` int unsigned NOT NULL,
    `Estatus` enum('Iniciada','Proceso','Concluida') DEFAULT 'Concluida',
    PRIMARY KEY (`ID`)
        ) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
    
-- b) Cambios sugeridos
-- Ninguno, por el momento

-- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
    CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_servicios_sucursales`(v_password varchar(10))
        BEGIN
        if v_password = '1234' then

        INSERT INTO tbd_servicios_sucursales VALUES
        (default, 1, 3, 'Iniciada'),
        (default, 2, 1, 'Proceso'),
        (default, 3, 2, default);

        UPDATE tbd_servicios_sucursales SET Estatus = 'Proceso' WHERE ID = 3;
        
        DELETE FROM tbd_servicios_sucursales WHERE ID = 2;
                else
                select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
            end if;
        END


-- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
-- ------------------------------- AFTER INSERT
    CREATE DEFINER=`root`@`localhost` TRIGGER `tbd_servicios_sucursales_AFTER_INSERT` AFTER INSERT ON `tbd_servicios_sucursales` FOR EACH ROW BEGIN
        DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
            
            IF NOT new.estatus = b'1' THEN
                SET v_estatus = 'Inactivo';
            END IF;
            INSERT INTO tbi_bitacora VALUES(
                DEFAULT, -- ID
                current_user(), -- Usuario
                "Create", -- Operación
                "tbd_servicios_sucursales", -- Tabla
                CONCAT_WS(" ", "Se ha insertado un nuevo servicio respecto a la sucursal con los siguientes datos", -- Desde aquí
                "ID SUCURSAL", new.Sucursal_ID,
                "ID SERVICIOS CLIENTES", new.ServiciosCliente_ID,
                "ESTATUS", v_estatus), -- Hasta aquí -> Descripción 
                DEFAULT, -- Fecha registro 
                default -- Estatus
            );

        END
-- ---------------------------AFTER UPDATE
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
                DEFAULT, -- ID
                current_user(), -- Usuario
                "Update", -- Operación
                "tbd_servicios_sucursales", -- Tabla
                CONCAT_WS(" ", "Se ha modificado un servicio respecto a la sucursal con los siguientes datos", -- Desde aquí
                "ID SUCURSAL", old.Sucursal_ID, '---', new.Sucursal_ID,
                "ID SERVICIOS CLIENTES", old.ServiciosCliente_ID, '---',  new.ServiciosCliente_ID,
                "ESTATUS", v_estatus_old, '---',  v_estatus_new), -- Hasta aquí -> Descripción 
                DEFAULT, -- Fecha registro 
                default -- Estatus
            );

        END
-- ------------------------------------------BEFORE UPDATE
    CREATE DEFINER=`root`@`localhost` TRIGGER `tbd_servicios_sucursales_BEFORE_DELETE` BEFORE DELETE ON `tbd_servicios_sucursales` FOR EACH ROW BEGIN
        DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';

        -- Validaciones para las etiquetas del estatus

        IF NOT old.estatus THEN
        SET v_estatus_old = 'Inactivo';
        END IF;


            INSERT INTO tbi_bitacora VALUES(
                DEFAULT, -- ID
                current_user(), -- Usuario
                "Delete", -- Operación
                "tbd_servicios_sucursales", -- Tabla
                CONCAT_WS(" ", "Se ha eliminado un servicio respecto a la sucursal con los siguientes datos", -- Desde aquí
                "ID SUCURSAL", old.Sucursal_ID,
                "ID SERVICIOS CLIENTES", old.ServiciosCliente_ID,
                "ESTATUS", v_estatus_old), -- Hasta aquí -> Descripción 
                DEFAULT, -- Fecha registro 
                default -- Estatus
            );

        END
-- e) realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion

-- ConsuLta la persona, su tipo de servicio, y la sucursal en la que lo hace.
    select concat_ws(" ", nullif(p.titulo_cortesia,''),
    p. nombre, p.primer_apellido, p.segundo_apellido) as NombrePersona,
    sc.Tipo_Servicio as TipoServicio, s.nombre as NombreSucursal
    from tbd_servicios_sucursales ss
    join tbb_personas p on ss.id = p.id
    join tbc_servicios_clientes sc on sc.id = ss.ServiciosCliente_ID
    join tbc_sucursales s on s.id = ss.sucursal_ID;

-- ---------------------------------------------------------------------------------------------------------
-- Tabla: tbb_instalaciones
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
            ) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- b) cambios sugeridos
-- NINGUNO


-- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
        CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_instalaciones`(v_password varchar(10))
            BEGIN

            if v_password = '1234' then

        INSERT INTO tbb_instalaciones VALUES
        (DEFAULT, 'Yoga Studio', 'Sala dedicada para clases de yoga y meditación', 'Área de Yoga', '2021-09-15 09:00:00', DEFAULT, DEFAULT, 'Buen servicio', 2, 'Lunes a Sábado de 9:00am a 7:00pm', NULL, NULL),
        (DEFAULT, 'Swimming Pool', 'Piscina olímpica para natación y ejercicios acuáticos', 'Área de Natación', '2021-09-15 09:00:00', DEFAULT, DEFAULT, 'Exelente servicio', 2, 'Todos los días de 6:00am a 10:00pm', NULL, NULL),
        (DEFAULT, 'Sauna Room', 'Sala de sauna para relajación y desintoxicación', 'Área de Sauna', '2021-09-15 09:00:00', DEFAULT, DEFAULT, 'Puede mejorar el servicio', 3, 'Lunes a Viernes de 10:00am a 8:00pm', NULL, NULL),
        (DEFAULT, 'Boxing Ring', 'Ring de boxeo para entrenamiento y competencias', 'Área de Boxeo', '2021-09-15 09:00:00', DEFAULT, DEFAULT, 'Servicio Regular', 3, 'Lunes a Viernes de 8:00am a 8:00pm', NULL, NULL),
        (DEFAULT, 'Pilates Studio', 'Sala equipada para clases de pilates', 'Área de Pilates', '2021-09-15 09:00:00', DEFAULT, DEFAULT, 'Buen servicio', 3, 'Lunes a Sábado de 8:00am a 6:00pm', NULL, NULL);

        UPDATE tbb_instalaciones SET Nombre = 'Advanced Yoga Studio' WHERE ID = 1;
        UPDATE tbb_instalaciones SET Descripcion = 'Piscina semi-olímpica para natación y ejercicios acuáticos' WHERE ID = 2;
        
        DELETE FROM tbb_instalaciones WHERE ID = 4;
                    else
                    select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
                end if;
            END

-- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
-- ---------------------------- AFTER INSERT
        CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_instalaciones_AFTER_INSERT` AFTER INSERT ON `tbb_instalaciones` FOR EACH ROW BEGIN
            DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
                
                IF NOT new.estatus = b'1' THEN
                    SET v_estatus = 'Inactivo';
                END IF;
                INSERT INTO tbi_bitacora VALUES(
                    DEFAULT, -- ID
                    current_user(), -- Usuario
                    "Create", -- Operación
                    "tbb_instalaciones", -- Tabla
                    CONCAT_WS(" ", "Se ha insertado una nueva instalació con los siguientes datos", -- Desde aquí
                    "NOMBRE", new.Nombre,
                    "DESCRIPCION", new.Descripcion,
                    "TIPO", new.Tipo,
                    "FECHA REGISTRO", new.Fecha_Registro,
                    "ESTATUS", v_estatus,
                    "FECHA ACTUALIZACION", new.Fecha_Actualizacion), -- Hasta aquí -> Descripción 
                    DEFAULT, -- Fecha registro 
                    default -- Estatus
                );

            END
-- ----------------------------------- BEFORE UPDATE
        CREATE DEFINER=`valencia`@`%` TRIGGER `tbd_instalacion_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_instalaciones` FOR EACH ROW BEGIN
                set new.Fecha_Actualizacion = current_timestamp();
            END

