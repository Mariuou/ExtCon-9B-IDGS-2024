-- PRÁCTICA 13: REVISIÓN Y CORRECCIÓN DE LAS TABLAS:
-- Servicios al Cliente, Servicios Sucursales, Instalaciones, Equipamiento y Ejercicios

-- Elaborado por: Dulce Esmeralda Hernández Juárez 210542
-- Grado y Grupo: 9° B
-- Programa Educativo: Ingeniería de Desarrollo y Gestión de Software
-- Fecha elaboración: 19 de Julio de 2024

-- Tabla: Servicios al Cliente
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

    -- b) cambios sugeridos: 



    -- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
   CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_servicios_clientes`(v_password varchar(10))
BEGIN
    IF v_password = '1234' THEN

        INSERT INTO tbc_servicios_clientes VALUES
        (DEFAULT, 2, "Sugerencia", "Añadir más ventiladores en la sala de pesas.", "Cliente sugiere mejorar la ventilación en la sala de pesas.", DEFAULT, DEFAULT, DEFAULT),
        (DEFAULT, 1, DEFAULT, "El horario de apertura es demasiado temprano.", "Comentario sobre la apertura temprana del gimnasio.", DEFAULT, DEFAULT, DEFAULT),
        (DEFAULT, 3, DEFAULT, "Los entrenadores podrían ofrecer más consejos personalizados.", "Cliente agradecido pero sugiere más asesoramiento personal.", DEFAULT, DEFAULT, DEFAULT),
        (DEFAULT, 4, DEFAULT, "El servicio de atención al cliente ha sido excepcional.", "Cliente satisfecho con el servicio recibido.", DEFAULT, DEFAULT, DEFAULT);

        UPDATE tbc_servicios_clientes SET Tipo_Servicio = 'Sugerencia' WHERE id = 3;
        UPDATE tbc_servicios_clientes SET Estatus = b'1' WHERE id = 2;
            
        DELETE FROM tbc_servicios_clientes WHERE id = 1;
    ELSE
        SELECT "La contraseña es incorrecta, no puedo insertar registros de la BD" AS Mensaje;
    END IF;
END

    -- d) Revision de los 4 triggers 
    -- CREATE
    CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_INSERT` AFTER INSERT ON `tbc_servicios_clientes` FOR EACH ROW BEGIN
    DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
        declare v_nombre_persona varchar(60) default null;
        if not NEW.estatus then
            set v_estatus = "Inactivo";
        end if;
        if new.persona_id is not null then
            set v_nombre_persona = (select CONCAT_WS(" ", p.titulo_cortesia, p.nombre, p.primer_apellido) FROM tbb_personas p WHERE id = NEW.persona_id);
        else
            SET v_nombre_persona = "Sin producto asignado";
        end if;
        
        
        insert into tbi_bitacora values(
            default, 
            current_user(), 
            "Create",
            "tbc_servicios_clientes", 
            CONCAT_WS(" ", "Se ha insertado un nuevo servicio al cliente con los siguientes datos", -- Desde aquí
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
        end
    -- -----------------------------------------------------------------------------------------------------
    CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_servicios_clientes` FOR EACH ROW BEGIN
        SET new.fecha_actualizacion = current_timestamp();
        END
    -- -----------------------------------------------------------------------------------------------------
    -- UPDATE
    CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_UPDATE` AFTER UPDATE ON `tbc_servicios_clientes` FOR EACH ROW BEGIN
        
        declare v_estatus_old varchar(20) default 'Activo';
        declare v_estatus_new varchar(20) default 'Activo';
        declare v_nombre_persona_old varchar(60) default null;
        declare v_nombre_persona_new varchar(60) default null;
        
        if not old.estatus then
            set v_estatus_old = "Inactivo";
        end if;
        if not NEW.estatus then
            set v_estatus_new = "Inactivo";
        end if;
        
        if old.persona_id is not null then 
            set v_nombre_persona_old = (select CONCAT_WS(" ", p.titulo_cortesia, p.nombre, p.primer_apellido) FROM tbb_personas p WHERE id = old.persona_id);
        else
            set v_nombre_persona_old = "Sin usuario asignado.";
        end if;
        
        if new.persona_id is not null then
            set v_nombre_persona_new = (SELECT CONCAT_WS(" ", p.titulo_cortesia, p.nombre, p.primer_apellido) FROM tbb_personas p WHERE id = NEW.persona_id);
        else
            set v_nombre_persona_new = "Sin usuario asignado.";
        end if;

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
        default,
        default 
        );

        end
    -- -----------------------------------------------------------------------------------------------------
  -- DELETE 
    CREATE DEFINER=`adan`@`%` TRIGGER `tbd_servicios_al_cliente_AFTER_DELETE` AFTER DELETE ON `tbc_servicios_clientes` FOR EACH ROW BEGIN


        declare v_estatus_old varchar(20) default 'Activo';
        declare v_nombre_persona_old varchar(60) default null;
        
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

        end
    -- e) realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion:
    -- JOIN entre tbc_servicios_clientes y tbb_personas para asegurar que todas las referencias de Persona_ID sean válidas
            SELECT 
            sc.ID, 
            p.nombre AS Persona_Nombre,
            sc.Tipo_Servicio,
            sc.Descripcion,
            sc.Comentarios,
            sc.Estatus,
            sc.Fecha_Registro,
            sc.Fecha_Actualizacion
        FROM 
            tbc_servicios_clientes sc
        JOIN 
            tbb_personas p ON sc.Persona_ID = p.ID
        WHERE 
            sc.Estatus = b'1';  

-- ****************************
-- ****************************
-- ****************************
-- ****************************
-- ****************************
-- ****************************
-- ****************************

--    Tabla servicios sucursales
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
    IF v_password = '1234' THEN
        -- Actualización antes de la inserción
        UPDATE tbd_servicios_sucursales
        SET Estatus = 'Iniciada'
        WHERE id = 2;
        
        -- Eliminación antes de la inserción
        DELETE FROM tbd_servicios_sucursales
        WHERE id = 1;

        -- Inserción de nuevos registros
        INSERT INTO tbd_servicios_sucursales (id, sucursal_id, servicio_id, estatus) VALUES
            (DEFAULT, 1, 2, 'Proceso'),
            (DEFAULT, 2, 3, DEFAULT),
            (DEFAULT, 3, 4, 'Iniciada');
    ELSE
        -- Mensaje de error si la contraseña es incorrecta
        SELECT "La contraseña es incorrecta, no puedo insertar registros de la BD" AS Mensaje;
    END IF;
END
    -- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
CREATE DEFINER=`root`@`localhost` TRIGGER `tbd_servicios_sucursales_AFTER_INSERT` 
AFTER INSERT ON `tbd_servicios_sucursales` 
FOR EACH ROW 
BEGIN
    DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';

    -- Determinamos el estatus basado en el valor de NEW.estatus
    IF NOT NEW.estatus = b'1' THEN
        SET v_estatus = 'Inactivo';
    END IF;

    -- Inserción en la bitácora después de determinar el estatus
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT, 
        current_user(), 
        'Create', 
        'tbd_servicios_sucursales',  
        CONCAT_WS(" ", 'Se ha insertado un nuevo servicio respecto a la sucursal con los siguientes datos:', 
            'ID SUCURSAL:', NEW.Sucursal_ID,
            'ID SERVICIOS CLIENTES:', NEW.ServiciosCliente_ID,
            'ESTATUS:', v_estatus),   
        DEFAULT,   
        DEFAULT  
    );

END

    -- ------------------------------------------------------------------------------------------------------
  CREATE DEFINER=`root`@`localhost` TRIGGER `tbd_servicios_sucursales_AFTER_UPDATE` 
AFTER UPDATE ON `tbd_servicios_sucursales` 
FOR EACH ROW 
BEGIN
    DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
    DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Activo';

    -- Validaciones para las etiquetas del estatus
    IF NOT OLD.estatus THEN
        SET v_estatus_old = 'Inactivo';
    END IF;

    IF NOT NEW.estatus THEN
        SET v_estatus_new = 'Inactivo';
    END IF;

    -- Inserción en la bitácora después de determinar los estatus
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,  
        current_user(),  
        'Update', 
        'tbd_servicios_sucursales', 
        CONCAT_WS(' ', 'Se ha modificado un servicio respecto a la sucursal con los siguientes datos:', 
            'ID SUCURSAL:', OLD.Sucursal_ID, '---', NEW.Sucursal_ID,
            'ID SERVICIOS CLIENTES:', OLD.ServiciosCliente_ID, '---', NEW.ServiciosCliente_ID,
            'ESTATUS ANTERIOR:', v_estatus_old, '---', 'ESTATUS NUEVO:', v_estatus_new), 
        DEFAULT, 
        DEFAULT  
    );

END

    -- ------------------------------------------------------------------------------------------------------
  CREATE DEFINER=`root`@`localhost` TRIGGER `tbd_servicios_sucursales_BEFORE_DELETE` 
BEFORE DELETE ON `tbd_servicios_sucursales` 
FOR EACH ROW 
BEGIN
    DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';

    -- Validaciones para las etiquetas del estatus
    IF NOT OLD.estatus THEN
        SET v_estatus_old = 'Inactivo';
    END IF;

    -- Inserción en la bitácora antes de eliminar el registro
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT, 
        current_user(), 
        'Delete', 
        'tbd_servicios_sucursales',  
        CONCAT_WS(' ', 'Se ha eliminado un servicio respecto a la sucursal con los siguientes datos:', 
            'ID SUCURSAL:', OLD.Sucursal_ID,
            'ID SERVICIOS CLIENTES:', OLD.ServiciosCliente_ID,
            'ESTATUS:', v_estatus_old),  
        DEFAULT,   
        DEFAULT  
    );

END

    -- e) realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion 
    -- Esta consulta muestra los registros en tbd_servicios_sucursales que no tienen una entrada correspondiente en tbi_bitacora:
    SELECT 
    s.ID AS Servicio_ID,
    s.Sucursal_ID,
    s.ServiciosCliente_ID,
    s.estatus AS Servicio_Estatus
FROM 
    tbd_servicios_sucursales s
LEFT JOIN 
    tbi_bitacora b ON s.ID = b.ID AND b.Tabla = 'tbd_servicios_sucursales'
WHERE 
    b.ID IS NULL
ORDER BY 
    s.ID;
-- ****************************
-- ****************************
-- ****************************
-- ****************************
-- ****************************
-- ****************************
-- ****************************
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
    -- Verificación de la contraseña
    IF v_password = '1234' THEN

        -- Realizar actualizaciones antes de la inserción
        UPDATE tbb_instalaciones SET Nombre = 'Entrenamiento Personalizado' WHERE id = 3;
        UPDATE tbb_instalaciones SET Descripcion = 'Zona especializada en sesiones de entrenamiento individualizadas' WHERE id = 1;

        -- Insertar nuevos registros
        INSERT INTO tbb_instalaciones VALUES
            (Default, 'Zona de Cardio', 'Espacio con equipos para mejorar la resistencia cardiovascular', 'Área de Cardio', '2021-01-15 09:00:00', default, default, default, 1, 'Lunes a Viernes de 9:00am a 9:00pm', null, null),
            (Default, 'Área de Fuerza', 'Zona equipada con pesas libres y máquinas de fuerza', 'Área de Pesas', '2021-01-15 09:00:00', default, default, default, 1, 'Lunes a Viernes de 9:00am a 9:00pm', null, null),
            (Default, 'Rincón de Flexibilidad', 'Área dedicada a estiramientos y ejercicios de flexibilidad', 'Área de Estiramiento', '2021-01-15 09:00:00', default, default, default, 1, 'Lunes a Viernes de 9:00am a 9:00pm', null, null),
            (Default, 'Estudio de Clases Grupales', 'Espacio para clases grupales de diversas disciplinas', 'Área de Clases Grupales', '2021-01-15 09:00:00', default, default, default, 1, 'Lunes a Viernes de 9:00am a 9:00pm', null, null),
            (Default, 'Zona de HIIT', 'Área para entrenamientos de alta intensidad', 'Área de HIIT', '2021-01-15 09:00:00', default, default, default, 1, 'Lunes a Viernes de 9:00am a 9:00pm', null, null);

        -- Eliminar un registro después de la inserción
        DELETE FROM tbb_instalaciones WHERE id = 4;

    ELSE
        -- Mensaje en caso de contraseña incorrecta
        SELECT 'La contraseña es incorrecta, no puedo insertar registros de la BD' AS Mensaje;
    END IF;
END

        -- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
       CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_instalaciones_AFTER_INSERT`
AFTER INSERT ON `tbb_instalaciones`
FOR EACH ROW
BEGIN
    DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';

    -- Determinar el estatus basado en el valor del nuevo registro
    IF NOT NEW.estatus THEN
        SET v_estatus = 'Inactivo';
    END IF;

    -- Insertar en la bitácora con la información del nuevo registro
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT, 
        current_user(), 
        'Create', 
        'tbb_instalaciones', 
        CONCAT_WS(' ', 
            'Se ha insertado una nueva instalación con los siguientes datos:',
            'NOMBRE:', NEW.Nombre,
            'DESCRIPCIÓN:', NEW.Descripcion,
            'TIPO:', NEW.Tipo,
            'FECHA REGISTRO:', NEW.Fecha_Registro,
            'ESTATUS:', v_estatus,
            'FECHA ACTUALIZACIÓN:', NEW.Fecha_Actualizacion), 
        DEFAULT,
        DEFAULT 
    );

END

        -- -------------------------------------------------------------------------------------------------------------
        CREATE DEFINER=`valencia`@`%` TRIGGER `tbd_instalacion_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_instalaciones` FOR EACH ROW BEGIN
                set new.Fecha_Actualizacion = current_timestamp();
            END
        -- -------------------------------------------------------------------------------------------------------------
       CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_instalaciones_AFTER_UPDATE`
AFTER UPDATE ON `tbb_instalaciones`
FOR EACH ROW
BEGIN
    DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
    DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Activo';

    -- Determinar el estatus antiguo y nuevo
    IF NOT OLD.estatus THEN
        SET v_estatus_old = 'Inactivo';
    END IF;

    IF NOT NEW.estatus THEN
        SET v_estatus_new = 'Inactivo';
    END IF;

    -- Insertar en la bitácora con la información de la actualización
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT, 
        CURRENT_USER(), 
        'Update', 
        'tbb_instalaciones', 
        CONCAT_WS(' ',
            'Se ha modificado una instalación existente con los siguientes datos:',
            'NOMBRE:', OLD.Nombre, '---', NEW.Nombre,
            'DESCRIPCIÓN:', OLD.Descripcion, '---', NEW.Descripcion,
            'TIPO:', OLD.Tipo, '---', NEW.Tipo,
            'FECHA REGISTRO:', OLD.Fecha_Registro, '---', NEW.Fecha_Registro,
            'ESTATUS:', v_estatus_old, '---', v_estatus_new,
            'FECHA ACTUALIZACIÓN:', OLD.Fecha_Actualizacion, '---', NEW.Fecha_Actualizacion
        ), 
        DEFAULT, 
        DEFAULT 
    );

END

        -- -------------------------------------------------------------------------------------------------------------
      CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_instalaciones_BEFORE_DELETE`
BEFORE DELETE ON `tbb_instalaciones`
FOR EACH ROW
BEGIN
    DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';

    -- Determinar el estatus antiguo del registro
    IF NOT OLD.estatus THEN
        SET v_estatus_old = 'Inactivo';
    END IF;

    -- Insertar en la bitácora con la información del registro a eliminar
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT, 
        CURRENT_USER(),  
        'Delete',
        'tbb_instalaciones',  
        CONCAT_WS(' ',
            'Se ha eliminado una instalación con los siguientes datos:',
            'NOMBRE:', OLD.Nombre,
            'DESCRIPCIÓN:', OLD.Descripcion,
            'TIPO:', OLD.Tipo,
            'FECHA REGISTRO:', OLD.Fecha_Registro,
            'ESTATUS:', v_estatus_old,
            'FECHA ACTUALIZACIÓN:', OLD.Fecha_Actualizacion
        ),  
        DEFAULT, 
        DEFAULT 
    );

END

        -- e) realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion 
        -- Consulta para Verificar Registros Insertados
        SELECT 
    i.ID AS Instalacion_ID,
    i.Nombre AS Instalacion_Nombre,
    i.Descripcion AS Instalacion_Descripcion,
    i.Tipo AS Instalacion_Tipo,
    i.Fecha_Registro AS Instalacion_Fecha_Registro,
    i.Estatus AS Instalacion_Estatus,
    i.Fecha_Actualizacion AS Instalacion_Fecha_Actualizacion,
    b.Operacion AS Bitacora_Operacion,
    b.Descripcion AS Bitacora_Descripcion
FROM 
    tbb_instalaciones i
JOIN 
    tbi_bitacora b
ON 
    i.ID = b.ID 
WHERE 
    b.Operacion = 'Create' 
    AND b.Tabla = 'tbb_instalaciones';
-- ****************************
-- ****************************
-- ****************************
-- ****************************
-- ****************************
-- ****************************
-- ****************************
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
    -- Verifica la contraseña antes de realizar cualquier acción
    IF v_password = '1234' THEN

        -- Inserta nuevos registros en la tabla de equipamientos
        INSERT INTO tbb_equipamientos (
            ID, Categoria, Nombre, Descripcion, Modelo, Fecha_Compra, Fecha_Registro, Fecha_Actualizacion, Status, Ubicacion
        ) VALUES
        (
            Default, 'Cardio', 'Cinta de Correr', 'Cinta de correr con inclinación ajustable.', 'MDL-456', null, '2021-01-15 09:00:00', default, default, default
        ),
        (
            Default, 'Pesas libres', 'Kettlebell', 'Kettlebell ajustable con peso variable.', 'MDL-789', null, '2021-02-20 10:30:00', default, default, default
        ),
        (
            Default, 'Máquinas de Fuerza', 'Máquina de Remo', 'Máquina de remo con resistencia ajustable.', 'MDL-654', null, '2021-03-25 11:45:00', default, default, default
        ),
        (
            Default, 'Peso Corporal y Entrenamiento Funcional', 'Rueda de Abdominales', 'Rueda para ejercicios de abdomen y core.', 'MDL-321', null, '2021-04-30 12:00:00', default, default, default
        ),
        (
            Default, 'Estiramiento y Flexibilidad', 'Colchoneta de Yoga', 'Colchoneta de alta densidad para yoga y estiramientos.', 'MDL-987', null, '2021-05-15 08:30:00', default, default, default
        );

        -- Actualiza los registros existentes
        UPDATE tbb_equipamientos 
        SET Categoria = 'Cardio Avanzado' 
        WHERE ID = 3;

        UPDATE tbb_equipamientos 
        SET Descripcion = 'Bicicleta reclinada con soporte lumbar.' 
        WHERE ID = 2;

        -- Elimina un registro específico
        DELETE FROM tbb_equipamientos 
        WHERE ID = 5;

    ELSE
        -- Mensaje de error si la contraseña es incorrecta
        SELECT 'La contraseña es incorrecta, no puedo insertar registros de la BD' AS Mensaje;
    END IF;
END


    -- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
   CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_AFTER_INSERT` 
AFTER INSERT ON `tbb_equipamientos` 
FOR EACH ROW 
BEGIN
    -- Declaramos una variable para el estatus
    DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';
    
    -- Evaluamos el estatus de la nueva entrada
    IF NOT NEW.estatus THEN
        SET v_estatus = 'Inactivo';
    END IF;
    
    -- Preparamos el mensaje para la bitácora
    SET @mensaje = CONCAT_WS(' ',
        'Se ha insertado un nuevo equipo con los siguientes datos:',
        'AREA = ', NEW.Area,
        'NOMBRE = ', NEW.Nombre,
        'MARCA = ', NEW.Marca,
        'MODELO = ', NEW.Modelo,
        'FOTO = ', NEW.Foto,
        'FECHA REGISTRO = ', NEW.Fecha_Registro,
        'FECHA ACTUALIZACION = ', NEW.Fecha_Actualizacion,
        'ESTATUS = ', v_estatus,
        'TOTAL EXISTENCIAS = ', NEW.Total_Existencias
    );
    
    -- Insertamos el registro en la bitácora
    INSERT INTO tbi_bitacora (
        ID,
        Usuario,
        Operacion,
        Tabla,
        Descripcion,
        Fecha_Registro,
        Estatus
    ) VALUES (
        DEFAULT,
        USER(),
        'Create',
        'tbb_equipamientos',
        @mensaje,
        DEFAULT,
        DEFAULT
    );
END

    -- ----------------------------------------------------------------------------------------------------
    CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_equipamientos` FOR EACH ROW BEGIN
        set new.Fecha_Actualizacion = current_timestamp();
        END
    -- ----------------------------------------------------------------------------------------------------
   CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_AFTER_UPDATE` 
AFTER UPDATE ON `tbb_equipamientos` 
FOR EACH ROW 
BEGIN
    -- Declaramos variables para los estatus antiguo y nuevo
    DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
    DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Activo';
    
    -- Evaluamos el estatus antiguo y nuevo
    IF NOT OLD.estatus THEN
        SET v_estatus_old = 'Inactivo';
    END IF;

    IF NOT NEW.estatus THEN
        SET v_estatus_new = 'Inactivo';
    END IF;
    
    -- Construimos el mensaje para la bitácora
    SET @mensaje = CONCAT_WS(' ',
        'Se ha modificado un equipo existente con los siguientes datos:',
        'AREA = ', OLD.Area, ' --- ', NEW.Area,
        'NOMBRE = ', OLD.Nombre, ' --- ', NEW.Nombre,
        'MARCA = ', OLD.Marca, ' --- ', NEW.Marca,
        'MODELO = ', OLD.Modelo, ' --- ', NEW.Modelo,
        'FOTO = ', OLD.Foto, ' --- ', NEW.Foto,
        'FECHA REGISTRO = ', OLD.Fecha_Registro, ' --- ', NEW.Fecha_Registro,
        'FECHA ACTUALIZACION = ', OLD.Fecha_Actualizacion, ' --- ', NEW.Fecha_Actualizacion,
        'ESTATUS = ', v_estatus_old, ' --- ', v_estatus_new,
        'TOTAL EXISTENCIAS = ', OLD.Total_Existencias, ' --- ', NEW.Total_Existencias
    );
    
    -- Insertamos el registro en la bitácora
    INSERT INTO tbi_bitacora (
        ID,
        Usuario,
        Operacion,
        Tabla,
        Descripcion,
        Fecha_Registro,
        Estatus
    ) VALUES (
        DEFAULT,
        USER(),
        'Update',
        'tbb_equipamientos',
        @mensaje,
        DEFAULT,
        DEFAULT
    );
END

    -- --------------------------------------------------------------------------------------------------------
   CREATE DEFINER=`root`@`localhost` TRIGGER `tbb_equipamientos_BEFORE_DELETE` 
BEFORE DELETE ON `tbb_equipamientos` 
FOR EACH ROW 
BEGIN
    -- Declaramos la variable para el estatus antiguo
    DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';

    -- Verificamos y ajustamos el estatus
    IF NOT OLD.estatus THEN
        SET v_estatus_old = 'Inactivo';
    END IF;
    
    -- Preparar el mensaje para la bitácora
    SET @mensaje = CONCAT_WS(' ',
        'Se ha eliminado un equipo existente con los siguientes datos:',
        'AREA = ', OLD.Area,
        'NOMBRE = ', OLD.Nombre,
        'MARCA = ', OLD.Marca,
        'MODELO = ', OLD.Modelo,
        'FOTO = ', OLD.Foto,
        'FECHA REGISTRO = ', OLD.Fecha_Registro,
        'FECHA ACTUALIZACION = ', OLD.Fecha_Actualizacion,
        'ESTATUS = ', v_estatus_old,
        'TOTAL EXISTENCIAS = ', OLD.Total_Existencias
    );
    
    -- Insertar el registro en la bitácora
    INSERT INTO tbi_bitacora (
        ID,
        Usuario,
        Operacion,
        Tabla,
        Descripcion,
        Fecha_Registro,
        Estatus
    ) VALUES (
        DEFAULT,
        USER(),
        'Delete',
        'tbb_equipamientos',
        @mensaje,
        DEFAULT,
        DEFAULT
    );
END

    -- e) realizar una consulta join (en caso de que aplique) para comprobar la integridad de la informacion 
    

-- ****************************
-- ****************************
-- ****************************
-- ****************************
-- ****************************
-- ****************************
-- ****************************

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

    -- Verificar la contraseña
    IF v_password = "xYz$123" THEN

        -- Insertar nuevos registros en la tabla tbc_ejercicios
        INSERT INTO tbc_ejercicios 
            (id, nombre, descripcion, imagen, tipo, fecha_creacion, dificultad, fecha_modificacion, comentarios, preparacion, recomendaciones) 
        VALUES 
            (DEFAULT, "Dominadas", "Ejercicio de tracción en barra fija que trabaja principalmente la espalda y los bíceps. Ideal para aumentar la fuerza en la parte superior del cuerpo.", null, "Fuerza", default, 'Avanzado', default, null, 'calentar', 'Evitar balanceo excesivo'),
            (DEFAULT, "Abdominales", "Ejercicio que fortalece los músculos del abdomen, mejorando la estabilidad del core y la postura. Incluye variaciones como crunches y leg raises.", null, "Fuerza", default, 'Intermedio', default, null, 'calentar', 'Mantener la espalda baja pegada al suelo'),
            (DEFAULT, "Sentadillas", "Ejercicio fundamental para el desarrollo de la fuerza en las piernas y los glúteos. Se realiza flexionando y extendiendo las rodillas con una carga o sin ella.", null, "Fuerza", default, 'Básico', default, null, 'calentar', 'Mantener la espalda recta'),
            (DEFAULT, "Flexiones", "Ejercicio de empuje que trabaja el pecho, los tríceps y los hombros. Puede realizarse en diversas variaciones para aumentar la dificultad.", null, "Fuerza", default, 'Intermedio', default, null, 'calentar', 'No hundir la cadera'),
            (DEFAULT, "Burpees", "Ejercicio de alta intensidad que combina una sentadilla, un salto y una flexión. Ideal para entrenamiento cardiovascular y de fuerza total.", null, "Cardio", default, 'Avanzado', default, null, 'calentar', 'Realizar movimientos fluidos');

        -- Actualizar registros existentes
        UPDATE tbc_ejercicios 
        SET nombre = "Dominadas" 
        WHERE nombre = "Pull-ups";

        UPDATE tbc_ejercicios 
        SET tipo = "Cardio" 
        WHERE nombre = "Burpees";

        UPDATE tbc_ejercicios 
        SET dificultad = "Intermedio" 
        WHERE nombre = "Sentadillas";

        -- Eliminar un registro
        DELETE FROM tbc_ejercicios 
        WHERE nombre = "Flexiones";

    ELSE 
        -- Mensaje en caso de contraseña incorrecta
        SELECT "La contraseña es incorrecta, no puedo realizar las operaciones solicitadas." AS ErrorMessage;

    END IF;

END

    -- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
   CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_AFTER_INSERT` AFTER INSERT ON `tbc_ejercicios` FOR EACH ROW 
BEGIN
    DECLARE v_estatus VARCHAR(20) DEFAULT 'Activo';

    -- Determinar el estatus para la bitácora
    IF NOT NEW.estatus THEN
        SET v_estatus = 'Inactivo';
    END IF;

    -- Generar el mensaje para la bitácora
    SET @mensaje = CONCAT_WS(' ',
        'Se ha insertado un nuevo ejercicio con los siguientes datos:',
        'NOMBRE = ', NEW.Nombre,
        'DESCRIPCION = ', NEW.Descripcion,
        'VIDEO = ', NEW.Video,
        'TIPO = ', NEW.Tipo,
        'ESTATUS = ', v_estatus,
        'DIFICULTAD = ', NEW.Dificultad,
        'FECHA REGISTRO = ', NEW.Fecha_Registro,
        'FECHA ACTUALIZACION = ', NEW.Fecha_Actualizacion,
        'RECOMENDACIONES = ', NEW.Recomendaciones,
        'RESTRICCIONES = ', NEW.Restricciones
    );

    -- Insertar en la bitácora
    INSERT INTO tbi_bitacora 
    VALUES (
        DEFAULT, 
        USER(), 
        'Create', 
        'tbc_ejercicios', 
        @mensaje, 
        DEFAULT, 
        DEFAULT 
    );
END

    -- --------------------------------------------------------------------------------------------
    CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_BEFORE_UPDATE` BEFORE UPDATE ON `tbc_ejercicios` FOR EACH ROW BEGIN
    SET NEW.Fecha_Actualizacion = current_timestamp();
    END
    -- --------------------------------------------------------------------------------------------
   CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_AFTER_UPDATE` AFTER UPDATE ON `tbc_ejercicios` FOR EACH ROW 
BEGIN
    DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';
    DECLARE v_estatus_new VARCHAR(20) DEFAULT 'Activo';

    -- Determinar el estatus anterior y nuevo
    IF NOT OLD.estatus THEN
        SET v_estatus_old = 'Inactivo';
    END IF;

    IF NOT NEW.estatus THEN
        SET v_estatus_new = 'Inactivo';
    END IF;

    -- Crear la descripción para la bitácora
    SET @descripcion = CONCAT_WS(' ',
        'Se ha modificado un ejercicio existente con los siguientes datos:',
        'NOMBRE = ', OLD.Nombre, '---', NEW.Nombre,
        'DESCRIPCION = ', OLD.Descripcion, '---', NEW.Descripcion,
        'VIDEO = ', OLD.Video, '---', NEW.Video,
        'TIPO = ', OLD.Tipo, '---', NEW.Tipo,
        'ESTATUS = ', v_estatus_old, '---', v_estatus_new,
        'DIFICULTAD = ', OLD.Dificultad, '---', NEW.Dificultad,
        'FECHA REGISTRO = ', OLD.Fecha_Registro, '---', NEW.Fecha_Registro,
        'FECHA ACTUALIZACION = ', OLD.Fecha_Actualizacion, '---', NEW.Fecha_Actualizacion,
        'RECOMENDACIONES = ', OLD.Recomendaciones, '---', NEW.Recomendaciones,
        'RESTRICCIONES = ', OLD.Restricciones, '---', NEW.Restricciones
    );

    -- Insertar en la bitácora
    INSERT INTO tbi_bitacora 
    VALUES (
        DEFAULT, 
        USER(), 
        'Update', 
        'tbc_ejercicios', 
        @descripcion, 
        DEFAULT, 
        DEFAULT 
    );
END

    -- --------------------------------------------------------------------------------------------
   CREATE DEFINER=`suri`@`%` TRIGGER `tbc_ejercicios_BEFORE_DELETE` BEFORE DELETE ON `tbc_ejercicios` FOR EACH ROW 
BEGIN
    DECLARE v_estatus_old VARCHAR(20) DEFAULT 'Activo';

    -- Determinar el estatus anterior
    IF NOT OLD.estatus THEN
        SET v_estatus_old = 'Inactivo';
    END IF;

    -- Preparar la descripción para la bitácora
    SET @descripcion = CONCAT_WS(' ',
        'Se ha eliminado un ejercicio existente con los siguientes datos:',
        'NOMBRE = ', OLD.Nombre,
        'DESCRIPCION = ', OLD.Descripcion,
        'VIDEO = ', OLD.Video,
        'TIPO = ', OLD.Tipo,
        'ESTATUS = ', v_estatus_old,
        'DIFICULTAD = ', OLD.Dificultad,
        'FECHA REGISTRO = ', OLD.Fecha_Registro,
        'FECHA ACTUALIZACION = ', OLD.Fecha_Actualizacion,
        'RECOMENDACIONES = ', OLD.Recomendaciones,
        'RESTRICCIONES = ', OLD.Restricciones
    );

    -- Insertar en la bitácora
    INSERT INTO tbi_bitacora 
    VALUES (
        DEFAULT, 
        USER(), 
        'Delete', 
        'tbc_ejercicios', 
        @descripcion,
        DEFAULT,
        DEFAULT 
    );
END

