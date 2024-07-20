-- PRACTICA 13: REVISION Y CORRECION DE LAS TABLAS:
-- Servicios al cliente, servicios sucursales, instalaciones, equipamiento, ejercicios
-- Elaborado por: Sebastián Márquez García
-- Grado y Grupo: 9° "B"
-- Programa Educativo: Ingenieria en Desarrollo y Gestion de Software
-- Fecha elaboracion: 19 de julio 2024

-- Tabla servicios al cliente
    -- a) Revision de la composicion de la tabla
    CREATE TABLE `tbc_servicios_clientes` (
    `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Persona_ID` INT UNSIGNED NOT NULL,
    `Tipo_Servicio` ENUM('Consulta','Reclamo','Sugerencia') NOT NULL DEFAULT 'Sugerencia',
    `Descripcion` TEXT NOT NULL,
    `Comentarios` TEXT,
    `Estatus` BIT(1) NOT NULL DEFAULT b'1',
    `Fecha_Registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `Fecha_Actualizacion` DATETIME DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `fk_personas_id_4_idx` (`Persona_ID`),
    CONSTRAINT `fk_personas_id_4` FOREIGN KEY (`Persona_ID`) REFERENCES `tbb_personas` (`ID`)
        )

    -- b) cambios sugeridos
    -- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
    CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_servicios_clientes`(v_password VARCHAR(10))
        BEGIN
        IF v_password = '1234' THEN

        INSERT INTO tbc_servicios_clientes VALUES
        (DEFAULT, 1, "Reclamo", "El aire acondicionado en la zona de cardio no está funcionando.", "Cliente muy molesto, solicitó solución urgente.",DEFAULT, DEFAULT, DEFAULT),
        (DEFAULT, 3, DEFAULT, "Sería útil tener más clases de yoga por la mañana.", "Comentario positivo sobre las clases actuales.",DEFAULT, DEFAULT, DEFAULT),
        (DEFAULT, 4, DEFAULT, "Excelente atención del entrenador personal.", "Cliente muy satisfecho con los resultados obtenidos.",DEFAULT, DEFAULT, DEFAULT),
        (DEFAULT, 5, DEFAULT, "Las máquinas de pesas libres no se limpian regularmente.", "Cliente sugirió más toallas desinfectantes cerca de las máquinas.",DEFAULT, DEFAULT, DEFAULT);
        
        UPDATE tbc_servicios_clientes SET Tipo_Servicio = 'Reclamo' WHERE id = 4;
        UPDATE tbc_servicios_clientes SET Estatus = b'0' WHERE id = 2;
            
            DELETE FROM tbc_servicios_clientes WHERE id = 1;
            ELSE
            SELECT "La contraseña es incorrecta, no puedo insertar registros de la BD" AS Mensaje;
        END IF;
        END

    -- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
    CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_INSERT` AFTER INSERT ON `tbc_servicios_clientes` FOR EACH ROW BEGIN
    DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
        DECLARE v_nombre_persona VARCHAR(60) DEFAULT null;
        
        -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
        IF NOT NEW.estatus THEN
            SET v_estatus = "Inactivo";
        END IF;
        
        IF NEW.persona_id is NOT null THEN
            -- En caso de tener el id del usuario debemos recuperar su nombre
            SET v_nombre_persona = (SELECT CONCAT_WS(" ", p.titulo_cortesia, p.nombre, p.primer_apellido) FROM tbb_personas p WHERE id = NEW.persona_id);
        ELSE
            SET v_nombre_persona = "Sin producto asignado";
        END IF;
        
        
        INSERT INTO tbi_bitacora VALUES(
            DEFAULT, -- ID
            current_user(), -- Usuario
            "Create", -- Operación
            "tbc_servicios_clientes", -- Tabla
            CONCAT_WS(" ", "Se ha insertado un nuevo servicio al cliente con los siguientes datos", -- Desde aquí
            "ID de la persona: ", v_nombre_persona,
            "Tipo de Servicio: ", NEW.tipo_servicio,
            "Descripción: ", NEW.descripcion,
            "Comentarios: ", NEW.comentarios,
            "Fecha Registro: ", NEW.fecha_registro,
            "Fecha Actualización: ", NEW.fecha_actualizacion,
            "Estatus: ", v_estatus ), -- Hasta aquí -> Descripción 
            DEFAULT, -- Fecha registro 
            DEFAULT -- Estatus
        );
        END
    -- -----------------------------------------------------------------------------------------------------
    CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_servicios_clientes` FOR EACH ROW BEGIN
        SET NEW.fecha_actualizacion = CURRENT_TIMESTAMP();
    END
    -- -----------------------------------------------------------------------------------------------------
    CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_UPDATE` AFTER UPDATE ON `tbc_servicios_clientes` FOR EACH ROW BEGIN
        
        DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
        DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Activo';
        DECLARE v_nombre_persona_old VARCHAR(60) DEFAULT null;
        DECLARE v_nombre_persona_new VARCHAR(60) DEFAULT null;
        
        -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
        IF NOT OLD.estatus THEN
            SET v_estatus_old = "Inactivo";
        END IF;
        IF NOT NEW.estatus THEN
            SET v_estatus_new = "Inactivo";
        END IF;
        
        IF OLD.persona_id IS NOT NULL THEN 
            -- En caso de tener el id del usuario
            SET v_nombre_persona_old = (SELECT CONCAT_WS(" ", p.titulo_cortesia, p.nombre, p.primer_apellido) FROM tbb_personas p WHERE id = OLD.persona_id);
        ELSE
            SET v_nombre_persona_old = "Sin usuario asignado.";
        END IF;
        
        IF NEW.persona_id IS NOT NULL THEN 
            -- En caso de tener el id del usuario
            SET v_nombre_persona_new = (SELECT CONCAT_WS(" ", p.titulo_cortesia, p.nombre, p.primer_apellido) FROM tbb_personas p WHERE id = NEW.persona_id);
        ELSE
            SET v_nombre_persona_new = "Sin usuario asignado.";
        END IF;

        INSERT INTO tbi_bitacora VALUES(
        DEFAULT, -- ID
        current_user(), -- Usuario
        'UPDATE', -- Operación 
        'tbc_servicios_clientes', -- Tabla
        CONCAT_WS(' ','Se ha modificado Servicio al cliente prestado con los siguientes datos:', -- Desde Aquí
        'ID de quien solicitó el servicio: ', v_nombre_persona_old, v_nombre_persona_new,
        'Tipo de servicio: ', OLD.tipo_servicio, ' a pasado a: ', NEW.tipo_servicio, ' - ',-- Tipo de servicio
        'Descripción: ', OLD.descripcion,' a pasado a: ',NEW.descripcion,' - ', -- Descripción
        'comentarios: ', OLD.comentarios,' a pasado a: ',NEW.comentarios,' - ', -- Comentarios
        'Fecha actualización: ', OLD.fecha_actualizacion,' a pasado a: ',NEW.fecha_actualizacion,' - ', -- Fecha de Actualización
        'Estatus: ', v_estatus_new 
        ), --   Hasta Aquí -> Descripción
        DEFAULT, -- Fecha Registro
        DEFAULT -- Estatus
        );

    END
    -- -----------------------------------------------------------------------------------------------------
    CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_DELETE` AFTER DELETE ON `tbc_servicios_clientes` FOR EACH ROW BEGIN


        DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
        DECLARE v_nombre_persona_old VARCHAR(60) DEFAULT null;
        
        -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
        IF NOT OLD.estatus THEN
            SET v_estatus_old = "Inactivo";
        END IF;
        
        IF OLD.persona_id IS NOT NULL THEN 
            -- En caso de tener el id del usuario
            SET v_nombre_persona_old = (SELECT CONCAT_WS(" ", p.titulo_cortesia, p.nombre, p.primer_apellido) FROM tbb_personas p WHERE id = OLD.persona_id);
        ELSE
            SET v_nombre_persona_old = "Sin usuario asignado.";
        END IF;
    

        INSERT INTO tbi_bitacora VALUES(
        DEFAULT, -- ID 
        current_user(), -- Usuario
        'DELETE', -- Operación 
        'tbc_servicios_clientes', -- Tabla
        CONCAT_WS(" ", "Se ha eliminado un servicio de un cliente con los siguientes dato: ",' - ', -- Desde Aquí
        'ID de quien solicitó el servicio: ', v_nombre_persona_old,
        'Tipo de servicio: ', OLD.tipo_servicio,' - ',-- Tipo de servicio
        'Descripción: ', OLD.descripcion,' - ', -- Descripción
        'comentarios: ', OLD.comentarios,' - ', -- Comentarios
        'Fecha actualización: ', OLD.fecha_actualizacion,' - ', -- Fecha de Actualización
        'Estatus: ', v_estatus_old), -- Hasta aquí -> Descripción
        DEFAULT, -- Fecha Registro
        b'0' -- Estatus
        );

    END
    -- e) realizar una consulta JOIN (en caso de que aplique) para comprobar la integridad de la informacion
    SELECT sc.Tipo_Servicio, p.Nombre
    FROM tbc_servicios_clientes sc
    JOIN tbb_personas p 
        ON p.id = sc.id
    ORDER BY sc.Tipo_Servicio;

-- Tabla servicios sucursales
    -- a) Revision de la composicion de la tabla
    CREATE TABLE `tbd_servicios_sucursales` (
        `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
        `Sucursal_ID` INT UNSIGNED NOT NULL,
        `ServiciosCliente_ID` INT UNSIGNED NOT NULL,
        `Estatus` ENUM('Iniciada','Proceso','Concluida') DEFAULT 'Concluida',
        PRIMARY KEY (`ID`)
    )
    -- b) cambios sugeridos
    -- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
    CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_servicios_sucursales`(v_password VARCHAR(10))
        BEGIN
        IF v_password = '1234' THEN

            INSERT INTO tbd_servicios_sucursales VALUES
            (DEFAULT,1, 2,"Proceso"),
            (DEFAULT,2, 3,DEFAULT),
            (DEFAULT,3, 4,"Iniciada");
            
            UPDATE tbd_servicios_sucursales SET Estatus = 'Iniciada' WHERE id = 2;
                
            DELETE FROM tbd_servicios_sucursales WHERE id = 1;
        ELSE
            SELECT "La contraseña es incorrecta, no puedo insertar registros de la BD" AS Mensaje;
        END IF;
    END
    -- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
    CREATE DEFINER=`root`@`localhost` TRIGGER `tbd_servicios_sucursales_AFTER_INSERT` AFTER INSERT ON `tbd_servicios_sucursales` FOR EACH ROW BEGIN
        DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
            
        IF NOT NEW.estatus = b'1' THEN
            SET v_estatus = 'Inactivo';
        END IF;
        INSERT INTO tbi_bitacora VALUES(
            DEFAULT, -- ID
            current_user(), -- Usuario
            "Create", -- Operación
            "tbd_servicios_sucursales", -- Tabla
            CONCAT_WS(" ", "Se ha insertado un nuevo servicio respecto a la sucursal con los siguientes datos", -- Desde aquí
            "ID SUCURSAL", NEW.Sucursal_ID,
            "ID SERVICIOS CLIENTES", NEW.ServiciosCliente_ID,
            "ESTATUS", v_estatus), -- Hasta aquí -> Descripción 
            DEFAULT, -- Fecha registro 
            DEFAULT -- Estatus
        );

    END
    -- ------------------------------------------------------------------------------------------------------
    CREATE DEFINER=`root`@`localhost` TRIGGER `tbd_servicios_sucursales_AFTER_UPDATE` AFTER UPDATE ON `tbd_servicios_sucursales` FOR EACH ROW BEGIN
        DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
        DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Activo';

        -- Validaciones para las etiquetas del estatus

        IF NOT OLD.estatus THEN
            SET v_estatus_old = 'Inactivo';
        END IF;

        IF NOT NEW.estatus THEN
            SET v_estatus_new = 'Inactivo';
        END IF;

        INSERT INTO tbi_bitacora VALUES(
            DEFAULT, -- ID
            current_user(), -- Usuario
            "UPDATE", -- Operación
            "tbd_servicios_sucursales", -- Tabla
            CONCAT_WS(" ", "Se ha modificado un servicio respecto a la sucursal con los siguientes datos", -- Desde aquí
            "ID SUCURSAL", OLD.Sucursal_ID, '---', NEW.Sucursal_ID,
            "ID SERVICIOS CLIENTES", OLD.ServiciosCliente_ID, '---',  NEW.ServiciosCliente_ID,
            "ESTATUS", v_estatus_old, '---',  v_estatus_new), -- Hasta aquí -> Descripción 
            DEFAULT, -- Fecha registro 
            DEFAULT -- Estatus
        );

    END
    -- ------------------------------------------------------------------------------------------------------
    CREATE DEFINER=`root`@`localhost` TRIGGER `tbd_servicios_sucursales_BEFORE_DELETE` BEFORE DELETE ON `tbd_servicios_sucursales` FOR EACH ROW BEGIN
        DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';

        -- Validaciones para las etiquetas del estatus

        IF NOT OLD.estatus THEN
            SET v_estatus_old = 'Inactivo';
        END IF;


        INSERT INTO tbi_bitacora VALUES(
            DEFAULT, -- ID
            current_user(), -- Usuario
            "DELETE", -- Operación
            "tbd_servicios_sucursales", -- Tabla
            CONCAT_WS(" ", "Se ha eliminado un servicio respecto a la sucursal con los siguientes datos", -- Desde aquí
            "ID SUCURSAL", OLD.Sucursal_ID,
            "ID SERVICIOS CLIENTES", OLD.ServiciosCliente_ID,
            "ESTATUS", v_estatus_old), -- Hasta aquí -> Descripción 
            DEFAULT, -- Fecha registro 
            DEFAULT -- Estatus
        );

    END
    -- e) realizar una consulta JOIN (en caso de que aplique) para comprobar la integridad de la informacion 
    SELECT concat_ws(" ", nullif(p.titulo_cortesia,''),
    p. nombre, p.primer_apellido, p.segundo_apellido) AS NombrePersona,
    sc.Tipo_Servicio AS TipoServicio, s.nombre AS NombreSucursal
    FROM tbd_servicios_sucursales ss
    FROM tbb_personas p 
        ON ss.id = p.id
    FROM tbc_servicios_clientes sc 
        ON sc.id = ss.ServiciosCliente_ID
    FROM tbc_sucursales s 
        ON s.id = ss.sucursal_ID;

-- Consutar la persona, su tipo de servicio, y la sucurssal en la que lo hace.
    SELECT concat_ws(" ", nullif(p.titulo_cortesia,''),
    p. nombre, p.primer_apellido, p.segundo_apellido) AS NombrePersona,
    sc.Tipo_Servicio AS TipoServicio, s.nombre AS NombreSucursal
    FROM tbd_servicios_sucursales ss
    JOIN tbb_personas p ON ss.id = p.id
    JOIN tbc_servicios_clientes sc ON sc.id = ss.ServiciosCliente_ID
    JOIN tbc_sucursales s ON s.id = ss.sucursal_ID;

-- Tabla instalaciones
    -- a) Revision de la composicion de la tabla
    CREATE TABLE `tbb_instalaciones` (
        `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
        `Nombre` VARCHAR(100) NOT NULL,
        `Descripcion` TEXT NOT NULL,
        `Tipo` VARCHAR(100) NOT NULL,
        `Fecha_Registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `Estatus` BIT(1) NOT NULL DEFAULT b'1',
        `Fecha_Actualizacion` DATETIME DEFAULT CURRENT_TIMESTAMP,
        `Calificacion` ENUM('Exelente servicio','Buen servicio','Servicio Regular','Puede mejorar el servicio') NOT NULL DEFAULT 'Buen servicio',
        `Sucursal_ID` INT UNSIGNED NOT NULL,
        `Horario_Disponibilidad` VARCHAR(100) NOT NULL,
        `Servicio` VARCHAR(100) DEFAULT NULL,
        `Observaciones` TEXT,
        PRIMARY KEY (`ID`),
        KEY `fk_sucursal_id_3_idx` (`Sucursal_ID`),
        CONSTRAINT `fk_sucursal_id_3` FOREIGN KEY (`Sucursal_ID`) REFERENCES `tbc_sucursales` (`ID`))
    -- b) cambios sugeridos
    -- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
    CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_instalaciones`(v_password VARCHAR(10))
        BEGIN

        IF v_password = '1234' THEN

            INSERT INTO tbb_instalaciones VALUES
            (DEFAULT, 'Cardio Zone', "Zona con equipos de cardio para mejorar la resistencia cardiovascular", "Área de Cardio", '2020-08-10 08:00:00', DEFAULT, DEFAULT, DEFAULT,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
            (DEFAULT, 'Strength Area', "Zona con pesas libres para el entrenamiento de fuerza", "Área de Pesas Libres",'2020-08-10 08:00:00', DEFAULT, DEFAULT, DEFAULT,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
            (DEFAULT, 'Flexibility Corner', "Espacio para ejercicios de estiramiento y flexibilidad", "Área de Estiramiento", '2020-08-10 08:00:00', DEFAULT, DEFAULT, DEFAULT,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
            (DEFAULT, 'Group Class Studio', "Sala para clases grupales variadas", "Área de Clases Grupales", '2020-08-10 08:00:00', DEFAULT, DEFAULT, DEFAULT,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
            (DEFAULT, 'HIIT Zone', "Zona para entrenamientos de alta intensidad", "Área de Entrenamiento HIIT", '2020-08-10 08:00:00', DEFAULT, DEFAULT, DEFAULT,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null);
            
            UPDATE tbb_instalaciones SET Nombre = 'Personal Training' WHERE id = 4;
            UPDATE tbb_instalaciones SET Descripcion = 'Espacio dedicado a entrenamientos personalizados' WHERE id = 2;
            
            DELETE FROM tbb_instalaciones WHERE id = 5;
        ELSE
            SELECT "La contraseña es incorrecta, no puedo insertar registros de la BD" AS Mensaje;
        END IF;
    END
    -- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
    CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_instalaciones_AFTER_INSERT` AFTER INSERT ON `tbb_instalaciones` FOR EACH ROW BEGIN
        DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
            
            IF NOT NEW.estatus = b'1' THEN
                SET v_estatus = 'Inactivo';
            END IF;
            INSERT INTO tbi_bitacora VALUES(
                DEFAULT, -- ID
                current_user(), -- Usuario
                "Create", -- Operación
                "tbb_instalaciones", -- Tabla
                CONCAT_WS(" ", "Se ha insertado una nueva instalació con los siguientes datos", -- Desde aquí
                "NOMBRE", NEW.Nombre,
                "DESCRIPCION", NEW.Descripcion,
                "TIPO", NEW.Tipo,
                "FECHA REGISTRO", NEW.Fecha_Registro,
                "ESTATUS", v_estatus,
                "FECHA ACTUALIZACION", NEW.Fecha_Actualizacion), -- Hasta aquí -> Descripción 
                DEFAULT, -- Fecha registro 
                DEFAULT -- Estatus
            );

        END
        -- -------------------------------------------------------------------------------------------------------------
        CREATE DEFINER=`valencia`@`%` TRIGGER `tbd_instalacion_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_instalaciones` FOR EACH ROW BEGIN
            SET NEW.Fecha_Actualizacion = CURRENT_TIMESTAMP();
        END
        -- -------------------------------------------------------------------------------------------------------------
        CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_instalaciones_AFTER_UPDATE` AFTER UPDATE ON `tbb_instalaciones` FOR EACH ROW BEGIN
            DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
            DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Activo';

            -- Validaciones para las etiquetas del estatus

            IF NOT OLD.estatus THEN
                SET v_estatus_old = 'Inactivo';
            END IF;

            IF NOT NEW.estatus THEN
                SET v_estatus_new = 'Inactivo';
            END IF;

            INSERT INTO tbi_bitacora VALUES(
                DEFAULT, -- ID
                current_user(), -- Usuario
                "UPDATE", -- Operación
                "tbb_instalaciones", -- Tabla
                CONCAT_WS(" ", "Se ha modificado una instalación existente con los siguientes datos", -- Desde aquí
                "NOMBRE",OLD.Nombre, '---', NEW.Nombre,
                "DESCRIPCION",OLD.Descripcion, '---',  NEW.Descripcion,
                "TIPO",OLD.Tipo, '---',  NEW.Tipo,
                "FECHA REGISTRO",OLD.Fecha_Registro, '---',  NEW.Fecha_Registro,
                "ESTATUS",v_estatus_old,'---', v_estatus_new,
                "FECHA ACTUALIZACION",OLD.Fecha_Actualizacion, '---',  NEW.Fecha_Actualizacion), -- Hasta aquí -> Descripción 
                DEFAULT, -- Fecha registro 
                DEFAULT -- Estatus
            );

        END
        -- -------------------------------------------------------------------------------------------------------------
        CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_instalaciones_BEFORE_DELETE` BEFORE DELETE ON `tbb_instalaciones` FOR EACH ROW BEGIN
            DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';

            -- Validaciones para las etiquetas del estatus
            IF NOT OLD.estatus THEN
                SET v_estatus_old = 'Inactivo';
            END IF;


            INSERT INTO tbi_bitacora VALUES(
                DEFAULT, -- ID
                current_user(), -- Usuario
                "DELETE", -- Operación
                "tbb_instalaciones", -- Tabla
                CONCAT_WS(" ", "Se ha eliminado una instalación con los siguientes datos", -- Desde aquí
                "NOMBRE",OLD.Nombre,
                "DESCRIPCION",OLD.Descripcion,
                "TIPO",OLD.Tipo,
                "FECHA REGISTRO",OLD.Fecha_Registro,
                "ESTATUS",v_estatus_old,
                "FECHA ACTUALIZACION",OLD.Fecha_Actualizacion), -- Hasta aquí -> Descripción 
                DEFAULT, -- Fecha registro 
                DEFAULT -- Estatus
            );

        END
    -- e) realizar una consulta JOIN (en caso de que aplique) para comprobar la integridad de la informacion 
    SELECT i.Nombre, i.Descripcion, s.Nombre, s.Direccion FROM tbb_instalaciones i
    JOIN tbc_sucursales s
	    ON i.Sucursal_ID=s.ID;

-- Tabla equipamiento
    -- a) Revision de la composicion de la tabla
    CREATE TABLE `tbb_equipamientos` (
        `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
        `Area` VARCHAR(100) NOT NULL,
        `Nombre` VARCHAR(100) NOT NULL,
        `Marca` VARCHAR(100) NOT NULL,
        `Modelo` VARCHAR(100) NOT NULL,
        `Foto` VARCHAR(100) DEFAULT NULL,
        `Fecha_Registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `Fecha_Actualizacion` DATETIME DEFAULT CURRENT_TIMESTAMP,
        `Estatus` BIT(1) NOT NULL DEFAULT b'1',
        `Total_Existencias` INT NOT NULL DEFAULT '0',
        PRIMARY KEY (`ID`)
    )

    -- b) cambios sugeridos
    -- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
    CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_equipamientos`(v_password VARCHAR(10))
        BEGIN

        IF v_password = '1234' THEN

            INSERT INTO tbb_equipamientos VALUES
            (DEFAULT, 'Cardio', "Bicicleta estática", "Schwinn 170 Upright Bike.", "MDL-123", null, '2020-08-10 08:00:00', DEFAULT, DEFAULT, DEFAULT),
            (DEFAULT, 'Pesas libres', "Mancuernas", "Bowflex SelectTech 552 Dumbbells.", "MDL-123", null, '2020-08-10 08:00:00', DEFAULT, DEFAULT, DEFAULT),
            (DEFAULT, 'Máquinas de Fuerza', "Prensa de piernas", "Body-Solid Leg Press & Hack Squat GLPH1100.", "MDL-123", null, '2020-08-10 08:00:00', DEFAULT, DEFAULT, DEFAULT),
            (DEFAULT, 'Peso Corporal y Entrenamiento Funcional', "Barras paralelas", "Lebert Equalizer Bars.", "MDL-123", null, '2020-08-10 08:00:00', DEFAULT, DEFAULT, DEFAULT),
            (DEFAULT, 'Estiramiento y Flexibilidad', "Barras de estiramiento", "ProStretch Plus Calf Stretcher.", "MDL-123", null, '2020-08-10 08:00:00', DEFAULT, DEFAULT, DEFAULT);
            
            UPDATE tbb_equipamientos SET Area = 'Entrenamiento de Alta Intensidad' WHERE id = 3;
            UPDATE tbb_equipamientos SET Modelo = 'MDL-321' WHERE id = 2;
            
            DELETE FROM tbb_equipamientos WHERE id = 5;
        ELSE
            SELECT "La contraseña es incorrecta, no puedo insertar registros de la BD" AS Mensaje;
        END IF;
    END
    -- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
    CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_AFTER_INSERT` AFTER INSERT ON `tbb_equipamientos` FOR EACH ROW BEGIN
        
        DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
        
        -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
        IF NOT NEW.estatus THEN
            SET v_estatus = "Inactivo";
        END IF;
        
        -- Insertar en la bitacora
        INSERT INTO tbi_bitacora VALUES(
            DEFAULT,
            USER(),
            "Create",
            "tbb_equipamientos",
            CONCAT_WS(" ","Se ha insertado un nuevo equipo con los siguientes datos: ",
            "AREA = ", NEW.Area,
            "NOMBRE = ", NEW.Nombre,
            "MARCA = ", NEW.Marca,
            "MODELO = ", NEW.Modelo,
            "FOTO = ", NEW.Foto,
            "FECHA REGISTRO = ", NEW.Fecha_Registro,
            "FECHA ACTUALIZACION = ", NEW.Fecha_Actualizacion,
            "ESTATUS = ", v_estatus,
            "TOTAL EXISTENCIAS = ", NEW.Total_Existencias),
            DEFAULT,
            DEFAULT  
        );
    END
    -- ----------------------------------------------------------------------------------------------------
    CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_equipamientos` FOR EACH ROW BEGIN
        SET NEW.Fecha_Actualizacion = CURRENT_TIMESTAMP();
        END
    -- ----------------------------------------------------------------------------------------------------
    CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_AFTER_UPDATE` AFTER UPDATE ON `tbb_equipamientos` FOR EACH ROW BEGIN
        DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
        DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Activo';
        
        -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
        IF NOT OLD.estatus THEN
            SET v_estatus_old = "Inactivo";
        END IF;
        IF NOT NEW.estatus THEN
            SET v_estatus_new = "Inactivo";
        END IF;
        
        -- Insertar en la bitacora
        INSERT INTO tbi_bitacora VALUES(
            DEFAULT,
            USER(),
            "UPDATE",
            "tbb_equipamientos",
            CONCAT_WS(" ","Se ha modificado un equipo existente con los siguientes datos: ",
            "AREA = ",OLD.Area, '---', NEW.Area,
            "NOMBRE = ",OLD.Nombre, '---',  NEW.Nombre,
            "MARCA = ",OLD.Marca, '---',  NEW.Marca,
            "MODELO = ",OLD.Modelo, '---',  NEW.Modelo,
            "FOTO = ",OLD.Foto, '---',  NEW.Foto,
            "FECHA REGISTRO = ",OLD.Fecha_Registro, '---',  NEW.Fecha_Registro,
            "FECHA ACTUALIZACION = ",OLD.Fecha_Actualizacion, '---',  NEW.Fecha_Actualizacion,
            "ESTATUS = ",v_estatus_old, '---',  v_estatus_new,
            "TOTAL EXISTENCIAS = ",OLD.Total_Existencias, '---',  NEW.Total_Existencias),
            DEFAULT,
            DEFAULT  
        );
        END
    -- --------------------------------------------------------------------------------------------------------
    CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_BEFORE_DELETE` BEFORE DELETE ON `tbb_equipamientos` FOR EACH ROW BEGIN
        DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
        
        -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
        IF NOT OLD.estatus THEN
            SET v_estatus_old = "Inactivo";
        END IF;
        
        -- Insertar en la bitacora
        INSERT INTO tbi_bitacora VALUES(
            DEFAULT,
            USER(),
            "DELETE",
            "tbb_equipamientos",
            CONCAT_WS(" ","Se ha eliminado un equipo existente con los siguientes datos: ",
            "AREA = ",OLD.Area,
            "NOMBRE = ",OLD.Nombre,
            "MARCA = ",OLD.Marca,
            "MODELO = ",OLD.Modelo,
            "FOTO = ",OLD.Foto,
            "FECHA REGISTRO = ",OLD.Fecha_Registro,
            "FECHA ACTUALIZACION = ",OLD.Fecha_Actualizacion,
            "ESTATUS = ",v_estatus_old,
            "TOTAL EXISTENCIAS = ",OLD.Total_Existencias),
            DEFAULT,
            DEFAULT  
        );
    END
    -- e) realizar una consulta JOIN (en caso de que aplique) para comprobar la integridad de la informacion 


-- Tabla ejercicios
    -- a) Revision de la composicion de la tabla
    CREATE TABLE `tbc_ejercicios` (
        `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
        `Nombre` VARCHAR(100) NOT NULL,
        `Descripcion` TEXT,
        `Video` VARCHAR(100) DEFAULT NULL,
        `Tipo` ENUM('Aerobico','Resistencia','Fuerza','Flexibilidad') NOT NULL,
        `Estatus` BIT(1) NOT NULL DEFAULT b'1',
        `Dificultad` ENUM('Basico','Avanzado','Intermedio') NOT NULL,
        `Fecha_Registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `Fecha_Actualizacion` DATETIME DEFAULT NULL,
        `Recomendaciones` TEXT,
        `Restricciones` TEXT,
        PRIMARY KEY (`ID`)
    )

    -- b) cambios sugeridos
    -- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
    CREATE DEFINER=`suri`@`%` PROCEDURE `sp_poblar_ejercicios`(v_password VARCHAR(50))
        BEGIN

        -- Corregido por Marco RH - Menos 2 Firmas

        IF v_password = "xYz$123" THEN
            INSERT INTO tbc_ejercicios VALUES 
                (DEFAULT, "Peso Muerto", " consiste esencialmente en extender la cadera y los músculos que la rodean, también incluye todos los ejercicios de musculación que requieren una cierta estabilidad del torso,
                esto incluye levantar una carga desde el suelo o desde la rodilla.", null, "Aerobico",DEFAULT,'Basico',DEFAULT,null, 'calentar','No hacer mal la fuerza'), 
                (DEFAULT, "Planchas", " consiste esencialmente en extender la cadera y los músculos que la rodean, también incluye todos los ejercicios de musculación que requieren una cierta estabilidad del torso,
                esto incluye levantar una carga desde el suelo o desde la rodilla.", null, "Fuerza",DEFAULT,'Intermedio',DEFAULT,null, 'calentar','No hacer mal la fuerza'), 
                (DEFAULT, "Prensas", " consiste esencialmente en extender la cadera y los músculos que la rodean, también incluye todos los ejercicios de musculación que requieren una cierta estabilidad del torso,
                esto incluye levantar una carga desde el suelo o desde la rodilla.", null, "Fuerza",DEFAULT,'Intermedio',DEFAULT,null, 'calentar','No hacer mal la fuerza'), 
                (DEFAULT, "Pesas", " consiste esencialmente en extender la cadera y los músculos que la rodean, también incluye todos los ejercicios de musculación que requieren una cierta estabilidad del torso,
                esto incluye levantar una carga desde el suelo o desde la rodilla.", null, "Fuerza",DEFAULT,'Avanzado',DEFAULT,null, 'calentar','No hacer mal la fuerza'), 
                (DEFAULT, "Biceps", " consiste esencialmente en extender la cadera y los músculos que la rodean, también incluye todos los ejercicios de musculación que requieren una cierta estabilidad del torso,
                esto incluye levantar una carga desde el suelo o desde la rodilla.", null, "Aerobico",DEFAULT,'Avanzado',DEFAULT,null, 'calentar','No hacer mal la fuerza');
                
            UPDATE tbc_ejercicios SET nombre= "Peso Muerto" WHERE nombre="Remo";
            UPDATE tbc_ejercicios SET tipo= "Aeróbico" WHERE nombre="Prensas";
            UPDATE tbc_ejercicios SET Dificultad= "Básico" WHERE nombre="Biceps";
            
            DELETE FROM tbc_ejercicios WHERE nombre="Pesas";

        ELSE 
            SELECT "La contraseña es incorrecta, no puedo mostrarte el 
            estatus de la Base de Datos" AS ErrorMessage;
        END IF;
    END
    -- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
    CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_AFTER_INSERT` AFTER INSERT ON `tbc_ejercicios` FOR EACH ROW BEGIN
        
        DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
        
        -- verificamos si el estatus del rol, para ubicar el valor en la descripcion de la bitacora
        IF NOT NEW.estatus THEN
            SET v_estatus = "Inactivo";
        END IF;
        
        
        -- Insertar en la bitacora
        INSERT INTO tbi_bitacora VALUES(
            DEFAULT,
            USER(),
            "Create",
            "tbc_ejercicios",
            CONCAT_WS(" ","Se ha insertado un nuevo ejercicio con los siguientes datos: ",
            "NOMBRE = ", NEW.Nombre,
            "DESCRIPCION = ", NEW.Descripcion,
            "VIDEO = ", NEW.Video, 
            "TIPO = ", NEW.Tipo,
            "ESTATUS = ", v_estatus,
            "DIFICULTAD = ", NEW.Dificultad,
            "FECHA REGISTRO = ", NEW.Fecha_Registro,
            "FECHA ACTUALIZACION = ", NEW.Fecha_Actualizacion,
            "RECOMENDACIONES = ", NEW.Recomendaciones,
            "RESTRICCIONES = ", NEW.Restricciones),
            DEFAULT,
            DEFAULT  
        );
    END
    -- --------------------------------------------------------------------------------------------
    CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_ejercicios` FOR EACH ROW BEGIN
    SET NEW.Fecha_Actualizacion = CURRENT_TIMESTAMP();
    END
    -- --------------------------------------------------------------------------------------------
    CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_AFTER_UPDATE` AFTER UPDATE ON `tbc_ejercicios` FOR EACH ROW BEGIN
        DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
        DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Activo';

        IF NOT OLD.estatus THEN
        SET v_estatus_old = 'Inactivo';
        END IF;

        IF NOT NEW.estatus THEN
            SET v_estatus_new = 'Inactivo';
        END IF;


        -- Insertar en la bitacora
        INSERT INTO tbi_bitacora VALUES(
            DEFAULT,
            USER(),
            "UPDATE",
            "tbc_ejercicios",
            CONCAT_WS(" ","Se ha modificado un ejercicio existente con los siguientes datos: ",
            "NOMBRE = ", OLD.Nombre, '---', NEW.Nombre,
            "DESCRIPCION = ", OLD.Descripcion, '---', NEW.Descripcion,
            "VIDEO = ",OLD.Video, '---', NEW.Video, 
            "TIPO = ",OLD.Tipo, '---', NEW.Tipo,
            "ESTATUS = ",v_estatus_old, '---', v_estatus_new,
            "DIFICULTAD = ",OLD.Dificultad, '---', NEW.Dificultad,
            "FECHA REGISTRO = ",OLD.Fecha_Registro, '---', NEW.Fecha_Registro,
            "FECHA ACTUALIZACION = ",OLD.Fecha_Actualizacion, '---', NEW.Fecha_Actualizacion,
            "RECOMENDACIONES = ",OLD.Recomendaciones, '---', NEW.Recomendaciones,
            "RESTRICCIONES = ",OLD.Restricciones, '---', NEW.Restricciones),
            DEFAULT,
            DEFAULT  
        );
    END
    -- --------------------------------------------------------------------------------------------
    CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_BEFORE_DELETE` BEFORE DELETE ON `tbc_ejercicios` FOR EACH ROW BEGIN
    DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';

        IF NOT OLD.estatus THEN
            SET v_estatus_old = 'Inactivo';
        END IF;


        -- Insertar en la bitacora
        INSERT INTO tbi_bitacora VALUES(
            DEFAULT,
            USER(),
            "DELETE",
            "tbc_ejercicios",
            CONCAT_WS(" ","Se ha eliminado un ejercicio existente con los siguientes datos: ",
            "NOMBRE = ", OLD.Nombre,
            "DESCRIPCION = ", OLD.Descripcion,
            "VIDEO = ",OLD.Video,
            "TIPO = ",OLD.Tipo,
            "ESTATUS = ",v_estatus_old,
            "DIFICULTAD = ",OLD.Dificultad,
            "FECHA REGISTRO = ",OLD.Fecha_Registro,
            "FECHA ACTUALIZACION = ",OLD.Fecha_Actualizacion,
            "RECOMENDACIONES = ",OLD.Recomendaciones,
            "RESTRICCIONES = ",OLD.Restricciones),
            DEFAULT,
            DEFAULT  
        );
    END

    -- e) realizar una consulta JOIN (en caso de que aplique) para comprobar la integridad de la informacion 