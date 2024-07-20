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


-- sin ideas :(

    -- c) Revision de la poblacion estatica (correccion en caso de ser necesaria)
    CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_poblar_servicios_clientes`(v_password varchar(10))
        BEGIN
        if v_password = '1234' then

        insert into tbc_servicios_clientes values
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
        end
    -- d) Revision de los 4 triggers (AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE)
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
        CONCAT_WS(' ','Se ha modificado Servicio al cliente prestado con los siguientes datos:', -- Desde Aquí
        'ID de quien solicitó el servicio: ', v_nombre_persona_old, v_nombre_persona_new,
        'Tipo de servicio: ', old.tipo_servicio, ' a pasado a: ', new.tipo_servicio, ' - ',-- Tipo de servicio
        'Descripción: ', old.descripcion,' a pasado a: ',new.descripcion,' - ', -- Descripción
        'comentarios: ', old.comentarios,' a pasado a: ',new.comentarios,' - ', -- Comentarios
        'Fecha actualización: ', old.fecha_actualizacion,' a pasado a: ',new.fecha_actualizacion,' - ', -- Fecha de Actualización
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
            sc.Estatus = b'1';  -- Ajusta la condición según sea necesario

