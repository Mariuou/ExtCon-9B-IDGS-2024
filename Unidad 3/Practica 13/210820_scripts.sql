-- PRACTICA 13: REVISION Y CORRECION DE LAS TABLAS:
-- Servicios al cliente, servicios sucursales, instalaciones, equipamiento, ejercicios
-- Elaborado por: Ing. Aldair Amador Ibarra
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

    CREATE TABLE `tbd_servicios_sucursales` (
    `ID` int unsigned NOT NULL AUTO_INCREMENT,
    `Sucursal_ID` int unsigned NOT NULL,
    `ServiciosCliente_ID` int unsigned NOT NULL,
    `Estatus` enum('Iniciada','Proceso','Concluida') DEFAULT 'Concluida',
    PRIMARY KEY (`ID`)
        ) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
        

    -- b) cambios sugeridos
    -- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)

    CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_servicios_sucursales`(v_password varchar(10))
        BEGIN
        if v_password = '1234' then

            INSERT INTO tbd_servicios_sucursales VALUES
            (default,1, 2,"Proceso"),
            (default,2, 3,default),
            (default,3, 4,"Iniciada");
            
            update tbd_servicios_sucursales set Estatus = 'Iniciada' where id = 2;
                
                delete from tbd_servicios_sucursales where id = 1;
                else
                select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
            end if;
        END


    -- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)

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


    -- ------------------------------------------------------------------------------------------------------


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


    -- ------------------------------------------------------------------------------------------------------


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

    -- ----------------------------------------------------------------

    -- Consutar la persona, su tipo de servicio, y la sucurssal en la que lo hace.
    select concat_ws(" ", nullif(p.titulo_cortesia,''),
    p. nombre, p.primer_apellido, p.segundo_apellido) as NombrePersona,
    sc.Tipo_Servicio as TipoServicio, s.nombre as NombreSucursal
    from tbd_servicios_sucursales ss
    join tbb_personas p on ss.id = p.id
    join tbc_servicios_clientes sc on sc.id = ss.ServiciosCliente_ID
    join tbc_sucursales s on s.id = ss.sucursal_ID;

    -- -------------------------------------------------------------



    -- Consutar la persona, su tipo de servicio, y la sucurssal en la que lo hace.

    select concat_ws(" ", nullif(p.titulo_cortesia,''),
    p. nombre, p.primer_apellido, p.segundo_apellido) as NombrePersona,
    sc.Tipo_Servicio as TipoServicio, s.nombre as NombreSucursal
    from tbd_servicios_sucursales ss
    join tbb_personas p on ss.id = p.id
    join tbc_servicios_clientes sc on sc.id = ss.ServiciosCliente_ID
    join tbc_sucursales s on s.id = ss.sucursal_ID;


    -- Tabla instalaciones
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
        -- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)

        CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_instalaciones`(v_password varchar(10))
            BEGIN

            if v_password = '1234' then

                INSERT INTO tbb_instalaciones VALUES
                (Default, 'Cardio Zone', "Zona con equipos de cardio para mejorar la resistencia cardiovascular", "Área de Cardio", '2020-08-10 08:00:00', default, default, default,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
                (Default, 'Strength Area', "Zona con pesas libres para el entrenamiento de fuerza", "Área de Pesas Libres",'2020-08-10 08:00:00', default, default, default,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
                (Default, 'Flexibility Corner', "Espacio para ejercicios de estiramiento y flexibilidad", "Área de Estiramiento", '2020-08-10 08:00:00', default, default, default,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
                (Default, 'Group Class Studio', "Sala para clases grupales variadas", "Área de Clases Grupales", '2020-08-10 08:00:00', default, default, default,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null),
                (Default, 'HIIT Zone', "Zona para entrenamientos de alta intensidad", "Área de Entrenamiento HIIT", '2020-08-10 08:00:00', default, default, default,1,"Lunes a Viernes de 8:00am a 8:00pm", null, null);
                
                    update tbb_instalaciones set Nombre = 'Personal Training' where id = 4;
                    update tbb_instalaciones set Descripcion = 'Espacio dedicado a entrenamientos personalizados' where id = 2;
                    
                    delete from tbb_instalaciones where id = 5;
                    else
                    select "La contraseña es incorrecta, no puedo insertar registros de la BD" as Mensaje;
                end if;
            END


        -- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
        
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


        -- -------------------------------------------------------------------------------------------------------------


        CREATE DEFINER=`valencia`@`%` TRIGGER `tbd_instalacion_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_instalaciones` FOR EACH ROW BEGIN
                set new.Fecha_Actualizacion = current_timestamp();
            END
        -- -------------------------------------------------------------------------------------------------------------


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


        -- -------------------------------------------------------------------------------------------------------------


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


    -- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)


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


    -- --------------------------------------------------------------------------------------------

    
    CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_ejercicios` FOR EACH ROW BEGIN
    SET NEW.Fecha_Actualizacion = current_timestamp();
    END


    -- --------------------------------------------------------------------------------------------


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


    -- --------------------------------------------------------------------------------------------


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