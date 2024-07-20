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

-- -------------------------AFYER UPDATE
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
                    DEFAULT, -- ID
                    current_user(), -- Usuario
                    "Update", -- Operación
                    "tbb_instalaciones", -- Tabla
                    CONCAT_WS(" ", "Se ha modificado una instalación existente con los siguientes datos", -- Desde aquí
                    "NOMBRE",old.Nombre, '---', new.Nombre,
                    "DESCRIPCION",old.Descripcion, '---',  new.Descripcion,
                    "TIPO",old.Tipo, '---',  new.Tipo,
                    "FECHA REGISTRO",old.Fecha_Registro, '---',  new.Fecha_Registro,
                    "ESTATUS",v_estatus_old,'---', v_estatus_new,
                    "FECHA ACTUALIZACION",old.Fecha_Actualizacion, '---',  new.Fecha_Actualizacion), -- Hasta aquí -> Descripción 
                    DEFAULT, -- Fecha registro 
                    default -- Estatus
                );

            END
-- --------------------------before update
        CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_instalaciones_BEFORE_DELETE` BEFORE DELETE ON `tbb_instalaciones` FOR EACH ROW BEGIN
            DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';

            -- Validaciones para las etiquetas del estatus

            IF NOT old.estatus THEN
            SET v_estatus_old = 'Inactivo';
            END IF;


            INSERT INTO tbi_bitacora VALUES(
                    DEFAULT, -- ID
                    current_user(), -- Usuario
                    "Delete", -- Operación
                    "tbb_instalaciones", -- Tabla
                    CONCAT_WS(" ", "Se ha eliminado una instalación con los siguientes datos", -- Desde aquí
                    "NOMBRE",old.Nombre,
                    "DESCRIPCION",old.Descripcion,
                    "TIPO",old.Tipo,
                    "FECHA REGISTRO",old.Fecha_Registro,
                    "ESTATUS",v_estatus_old,
                    "FECHA ACTUALIZACION",old.Fecha_Actualizacion), -- Hasta aquí -> Descripción 
                    DEFAULT, -- Fecha registro 
                    default -- Estatus
                );

            END

-- e) realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion 

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Tabla tbb_equipamientos
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
        (DEFAULT, 'Cardio', 'Cinta de correr', 'NordicTrack', 'Commercial 1750', NULL, '2021-09-15 09:00:00', DEFAULT, DEFAULT, 10),
        (DEFAULT, 'Pesas libres', 'Barra olímpica', 'Rogue', 'Ohio Bar', NULL, '2021-09-15 09:00:00', DEFAULT, DEFAULT, 15),
        (DEFAULT, 'Máquinas de Fuerza', 'Máquina de remo', 'Concept2', 'Model D', NULL, '2021-09-15 09:00:00', DEFAULT, DEFAULT, 5),
        (DEFAULT, 'Peso Corporal y Entrenamiento Funcional', 'Cuerdas de batalla', 'Onnit', '6m', NULL, '2021-09-15 09:00:00', DEFAULT, DEFAULT, 20),
        (DEFAULT, 'Estiramiento y Flexibilidad', 'Rueda de yoga', 'UpCircleSeven', 'Basic', NULL, '2021-09-15 09:00:00', DEFAULT, DEFAULT, 8);

        UPDATE tbb_equipamientos SET Area = 'Entrenamiento de Resistencia' WHERE ID = 2;
        UPDATE tbb_equipamientos SET Modelo = 'Pro 5000' WHERE ID = 1;
        
        DELETE FROM tbb_equipamientos WHERE ID = 5;
            else
            select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
        end if;
        END


-- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
-- --------------------AFTER INSERT
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

-- ------------------BEFORE UPDATE
    CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_equipamientos` FOR EACH ROW BEGIN
        set new.Fecha_Actualizacion = current_timestamp();
        END
    
-- -------------------------AFTER UPDATE
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
    -- ----------------------------BEFORE DELETE--
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
-- NO APLICA

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
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
-- NINGUNO POR EL MOMENTO

-- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
    CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_instalaciones`(v_password varchar(10))
        BEGIN

        if v_password = '1234' then

        INSERT INTO tbb_instalaciones VALUES
        (DEFAULT, 'Swimming Pool', "Piscina olímpica para natación y ejercicios acuáticos", "Área de Natación", '2021-09-15 09:00:00', DEFAULT, DEFAULT, 'Exelente servicio', 2, "Todos los días de 6:00am a 10:00pm", NULL, NULL),
        (DEFAULT, 'Sauna Room', "Sala de sauna para relajación y desintoxicación", "Área de Sauna", '2021-09-15 09:00:00', DEFAULT, DEFAULT, 'Buen servicio', 2, "Lunes a Viernes de 10:00am a 8:00pm", NULL, NULL),
        (DEFAULT, 'Boxing Ring', "Ring de boxeo para entrenamiento y competencias", "Área de Boxeo", '2021-09-15 09:00:00', DEFAULT, DEFAULT, 'Servicio Regular', 3, "Lunes a Viernes de 8:00am a 8:00pm", NULL, NULL),
        (DEFAULT, 'Pilates Studio', "Sala equipada para clases de pilates", "Área de Pilates", '2021-09-15 09:00:00', DEFAULT, DEFAULT, 'Buen servicio', 3, "Lunes a Sábado de 8:00am a 6:00pm", NULL, NULL),
        (DEFAULT, 'Weightlifting Area', "Zona con equipo de levantamiento de pesas", "Área de Levantamiento de Pesas", '2021-09-15 09:00:00', DEFAULT, DEFAULT, 'Puede mejorar el servicio', 3, "Lunes a Viernes de 8:00am a 8:00pm", NULL, NULL);

        UPDATE tbb_instalaciones SET Nombre = 'Advanced Yoga Studio' WHERE ID = 3;
        UPDATE tbb_instalaciones SET Descripcion = 'Sala de sauna con tecnología de infrarrojos para relajación y desintoxicación' WHERE ID = 2;
        
        DELETE FROM tbb_instalaciones WHERE ID = 5;
                else
                select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
            end if;
        END

-- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
-- ------------------------ AFTER INSERT
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

-- -------------------- BEFORE UPDATE
    CREATE DEFINER=`valencia`@`%` TRIGGER `tbd_instalacion_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_instalaciones` FOR EACH ROW BEGIN
        set new.Fecha_Actualizacion = current_timestamp();
    END

-- ---------------AFTER UPDATE
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
                DEFAULT, -- ID
                current_user(), -- Usuario
                "Update", -- Operación
                "tbb_instalaciones", -- Tabla
                CONCAT_WS(" ", "Se ha modificado una instalación existente con los siguientes datos", -- Desde aquí
                "NOMBRE",old.Nombre, '---', new.Nombre,
                "DESCRIPCION",old.Descripcion, '---',  new.Descripcion,
                "TIPO",old.Tipo, '---',  new.Tipo,
                "FECHA REGISTRO",old.Fecha_Registro, '---',  new.Fecha_Registro,
                "ESTATUS",v_estatus_old,'---', v_estatus_new,
                "FECHA ACTUALIZACION",old.Fecha_Actualizacion, '---',  new.Fecha_Actualizacion), -- Hasta aquí -> Descripción 
                DEFAULT, -- Fecha registro 
                default -- Estatus
            );

        END

-- ----------------- BEFORE UPDATE
    CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_instalaciones_BEFORE_DELETE` BEFORE DELETE ON `tbb_instalaciones` FOR EACH ROW BEGIN
        DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';

        -- Validaciones para las etiquetas del estatus

        IF NOT old.estatus THEN
        SET v_estatus_old = 'Inactivo';
        END IF;


        INSERT INTO tbi_bitacora VALUES(
                DEFAULT, -- ID
                current_user(), -- Usuario
                "Delete", -- Operación
                "tbb_instalaciones", -- Tabla
                CONCAT_WS(" ", "Se ha eliminado una instalación con los siguientes datos", -- Desde aquí
                "NOMBRE",old.Nombre,
                "DESCRIPCION",old.Descripcion,
                "TIPO",old.Tipo,
                "FECHA REGISTRO",old.Fecha_Registro,
                "ESTATUS",v_estatus_old,
                "FECHA ACTUALIZACION",old.Fecha_Actualizacion), -- Hasta aquí -> Descripción 
                DEFAULT, -- Fecha registro 
                default -- Estatus
            );

        END

-- e) realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion 
-- NO Aplica

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Tabla: tbc_servicios
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
    ) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- b) cambios sugeridos

-- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
    CREATE DEFINER=`suri`@`%` PROCEDURE `sp_poblar_ejercicios`(v_password varchar(50))
        BEGIN

        

        IF v_password = "xYz$123" THEN
           
       
        INSERT INTO tbc_ejercicios VALUES 
            (DEFAULT, "Sentadillas", "Ejercicio para fortalecer los músculos de las piernas y glúteos.", NULL, "Fuerza", DEFAULT, 'Basico', DEFAULT, NULL, "Realizar con la espalda recta", "Evitar si tienes problemas de rodillas"),
            (DEFAULT, "Flexiones", "Ejercicio para fortalecer los músculos del pecho y brazos.", NULL, "Fuerza", DEFAULT, 'Intermedio', DEFAULT, NULL, "Mantener el cuerpo en línea recta", "No recomendable para personas con problemas de muñeca"),
            (DEFAULT, "Correr", "Ejercicio aeróbico para mejorar la resistencia cardiovascular.", NULL, "Aerobico", DEFAULT, 'Basico', DEFAULT, NULL, "Usar calzado adecuado", "Evitar terrenos irregulares"),
            (DEFAULT, "Estiramientos", "Ejercicios para mejorar la flexibilidad y prevenir lesiones.", NULL, "Flexibilidad", DEFAULT, 'Basico', DEFAULT, NULL, "Mantener cada estiramiento por 30 segundos", "No forzar más allá del punto de comodidad"),
            (DEFAULT, "Plancha", "Ejercicio isométrico para fortalecer el core.", NULL, "Fuerza", DEFAULT, 'Avanzado', DEFAULT, NULL, "Mantener el cuerpo en línea recta", "No recomendable para personas con problemas de espalda");

        
        UPDATE tbc_ejercicios SET Descripcion = 'Ejercicio básico para fortalecer piernas' WHERE Nombre = "Sentadillas";
        UPDATE tbc_ejercicios SET Tipo = 'Resistencia' WHERE Nombre = "Flexiones";
        UPDATE tbc_ejercicios SET Dificultad = 'Intermedio' WHERE Nombre = "Correr";

        -- Eliminar un registro de la tabla tbc_ejercicios
        DELETE FROM tbc_ejercicios WHERE Nombre = "Plancha";


            ELSE 
            SELECT "La contraseña es incorrecta, no puedo mostrarte el 
            estatus de la Base de Datos" AS ErrorMessage;
            
            END IF;

    END
-- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
-- -------------------------AFTER INSERT
    CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_AFTER_INSERT` AFTER INSERT ON `tbc_ejercicios` FOR EACH ROW BEGIN
        
        DECLARE v_estatus varchar(20) default 'Activo';
        
        
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

-- -------------BEFORE UPDAYE
    CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_ejercicios` FOR EACH ROW BEGIN
    SET NEW.Fecha_Actualizacion = current_timestamp();
    END

-- ----------- AFTER UODATE
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
    
-- ---------------------------BEFORE DELETE
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

-- e) realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion 
-- NO APLICA