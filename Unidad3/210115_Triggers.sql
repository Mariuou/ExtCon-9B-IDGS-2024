-- Triggers de la tabla: tbd_rutinas (4):
-- AFTER INSERT
CREATE DEFINER=`marinho`@`%` TRIGGER `tbd_rutinas_AFTER_INSERT` AFTER INSERT ON `tbd_rutinas` FOR EACH ROW BEGIN
DECLARE v_nombre_ps VARCHAR(100) DEFAULT (SELECT Nombre FROM tbd_programas_saludables WHERE id = new.Programa_Saludable_ID);
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbd_rutinas",
        CONCAT_WS(" ","Se ha insertado una nueva RUTINA con los siguientes datos:",
		" Nombre =", new.Nombre,
        " Programa_Saludable_ID =", v_nombre_ps,
        " Fecha Registro =", new.Fecha_Registro,
        " Fecha Actualizacion =", new.Fecha_Actualizacion, 
		" Tiempo Aproximado =", new.Tiempo_Aproximado, 
        " Estatus =", new.estatus,
        " Resultados Esperados =", new.Resultados_Esperados),
        DEFAULT,
        DEFAULT
    );
END

-- BEFORE UPDATE
CREATE DEFINER=`marinho`@`%` TRIGGER `tbd_rutinas_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_rutinas` FOR EACH ROW BEGIN
	set new.Fecha_Actualizacion = current_timestamp();
END

-- AFTER UPDATE
CREATE DEFINER=`marinho`@`%` TRIGGER `tbd_rutinas_AFTER_UPDATE` AFTER UPDATE ON `tbd_rutinas` FOR EACH ROW BEGIN
DECLARE v_nombre_ps_old VARCHAR(100) DEFAULT (SELECT Nombre FROM tbd_programas_saludables WHERE id = old.Programa_Saludable_ID);
DECLARE v_nombre_ps_new VARCHAR(100) DEFAULT (SELECT Nombre FROM tbd_programas_saludables WHERE id = new.Programa_Saludable_ID);
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Update",
        "tbd_rutinas",
        CONCAT_WS(" ","Se ha actualizado una RUTINA con los siguientes datos:",
		" Nombre =", old.Nombre, '-', new.Nombre,
        " Programa_Saludable_ID =", v_nombre_ps_old, '-', v_nombre_ps_new,
        " Fecha Registro =", old.Fecha_Registro, '-', new.Fecha_Registro,
        " Fecha Actualizacion =", old.Fecha_Actualizacion, '-', new.Fecha_Actualizacion, 
		" Tiempo Aproximado =", old.Tiempo_Aproximado, '-', new.Tiempo_Aproximado, 
        " Estatus =",  old.estatus, '-', new.estatus,
        " Resultados Esperados =", old.Resultados_Esperados, '-', new.Resultados_Esperados),
        DEFAULT,
        DEFAULT
    );
END

-- AFTER DELETE
CREATE DEFINER=`marinho`@`%` TRIGGER `tbd_rutinas_AFTER_DELETE` AFTER DELETE ON `tbd_rutinas` FOR EACH ROW BEGIN
DECLARE v_nombre_ps_old VARCHAR(100) DEFAULT (SELECT Nombre FROM tbd_programas_saludables WHERE id = old.Programa_Saludable_ID);
INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Delete",
        "tbd_rutinas",
        CONCAT_WS(" ","Se ha eliminado una RUTINA con los siguientes datos:",
        " Nombre =", old.Nombre,
        " Programa_Saludable_ID =", v_nombre_ps_old,
        " Fecha Registro =", old.Fecha_Registro,
        " Fecha Actualizacion =", old.Fecha_Actualizacion, 
		" Tiempo Aproximado =", old.Tiempo_Aproximado, 
        " Estatus =", old.estatus,
        " Resultados Esperados =", old.Resultados_Esperados),
        DEFAULT,
        DEFAULT
	);
END



-- Triggers de la tabla: tbd_ejercicios_rutinas (4):
-- AFTER INSERT
CREATE DEFINER=`marinho`@`%` TRIGGER `tbd_ejercicios_rutinas_AFTER_INSERT` AFTER INSERT ON `tbd_ejercicios_rutinas` FOR EACH ROW BEGIN
DECLARE v_nombre_rutina VARCHAR(100) DEFAULT (SELECT Nombre FROM tbd_rutinas WHERE id = new.Rutina_ID);
DECLARE v_nombre_ejercicio VARCHAR(100) DEFAULT (SELECT Nombre FROM tbc_ejercicios WHERE id = new.Ejercicio_ID);
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Create",
        "tbd_ejercicios_rutinas",
        CONCAT_WS(" ","Se ha insertado una nueva RUTINA-EJERCICIOS con los siguientes datos:",
		" N.Ejercicio =", v_nombre_ejercicio,
        " N.Rutina =", v_nombre_rutina,
        " Cantidad =", new.Cantidad,
        " Tipo =", new.Tipo,
        " Observaciones =", new.Observaciones, 
		" Fecha Registro =", new.Fecha_Registro, 
        " Fecha Actualizacion =", new.Fecha_Actualizacion,
        " Estatus =", new.Estatus),
        DEFAULT,
        DEFAULT
    );
END

-- BEFORE UPDATE
CREATE DEFINER=`marinho`@`%` TRIGGER `tbd_ejercicios_rutinas_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_ejercicios_rutinas` FOR EACH ROW BEGIN
	set new.Fecha_Actualizacion = current_timestamp();
END

-- AFTER UPDATE
CREATE DEFINER=`marinho`@`%` TRIGGER `tbd_ejercicios_rutinas_AFTER_UPDATE` AFTER UPDATE ON `tbd_ejercicios_rutinas` FOR EACH ROW BEGIN
    DECLARE v_nombre_ejercicio_old VARCHAR(100) DEFAULT (SELECT Nombre FROM tbc_ejercicios WHERE id = old.Ejercicio_ID);
    DECLARE v_nombre_ejercicio_new VARCHAR(100) DEFAULT (SELECT Nombre FROM tbc_ejercicios WHERE id = new.Ejercicio_ID);
    DECLARE v_nombre_rutina_old VARCHAR(100) DEFAULT (SELECT Nombre FROM tbd_rutinas WHERE id = old.Rutina_ID);
    DECLARE v_nombre_rutina_new VARCHAR(100) DEFAULT (SELECT Nombre FROM tbd_rutinas WHERE id = new.Rutina_ID);
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Update",
        "tbd_ejercicios_rutinas",
        CONCAT_WS(" ","Se ha actualizado una RUTINA-EJERCICIOS con los siguientes datos:",
		" N.Ejercicio =", v_nombre_ejercicio_old, "al Nombre", v_nombre_ejercicio_new,
        " N.Rutina =", v_nombre_rutina_old, "al Nombre", v_nombre_rutina_new,
        " Cantidad =", old.Cantidad, " - ", new.Cantidad,
        " Tipo =", old.Tipo, " - ", new.Tipo,
        " Observaciones =", old.Observaciones, " - ", new.Observaciones,
		" Fecha Registro =", old.Fecha_Registro, " - ", new.Fecha_Registro,
        " Fecha Actualizacion =", old.Fecha_Actualizacion, " - ", new.Fecha_Actualizacion,
        " Estatus =", old.Estatus, " - ", new.Estatus),
        DEFAULT,
        DEFAULT
    );
END

-- AFTER DELETE
CREATE DEFINER=`marinho`@`%` TRIGGER `tbd_ejercicios_rutinas_AFTER_DELETE` AFTER DELETE ON `tbd_ejercicios_rutinas` FOR EACH ROW BEGIN
	DECLARE v_nombre_ejercicio_old VARCHAR(100) DEFAULT (SELECT Nombre FROM tbc_ejercicios WHERE id = old.Ejercicio_ID);
    DECLARE v_nombre_rutina_old VARCHAR(100) DEFAULT (SELECT Nombre FROM tbd_rutinas WHERE id = old.Rutina_ID);
    INSERT INTO tbi_bitacora VALUES(
        DEFAULT,
        USER(),
        "Delete",
        "tbd_ejercicios_rutinas",
        CONCAT_WS(" ","Se ha eliminado una nueva RUTINA-EJERCICIOS con los siguientes datos:",
		" N.Ejercicio =", v_nombre_ejercicio_old,
        " N.Rutina =", v_nombre_rutina_old,
        " Cantidad =", old.Cantidad,
        " Tipo =", old.Tipo,
        " Observaciones =", old.Observaciones, 
		" Fecha Registro =", old.Fecha_Registro, 
        " Fecha Actualizacion =", old.Fecha_Actualizacion,
        " Estatus =", old.Estatus),
        DEFAULT,
        DEFAULT
    );
END