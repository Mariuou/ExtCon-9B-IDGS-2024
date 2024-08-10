-- Procedimiento de población de Rutinas
-- Campos de llaves foraneas de acuerdo al procedimiento del que se depende 
CREATE DEFINER=`marinho`@`%` PROCEDURE `sp_poblar_rutinas`(v_password VARCHAR(20))
BEGIN
IF v_password = "qwerty" THEN
	insert into tbd_rutinas values (default, "Tonificación muscular", 1, "2022-01-01 00:00:24", default, "15:00", "Actual", "Aumentar masa muscular");
	insert into tbd_rutinas values (default, "Entrenamiento cardiovascular intensivo", 2, "2022-01-01 00:00:24", default, "20:00", "Actual", "Bajar al IMC saludable");
	insert into tbd_rutinas values (default, "Entrenamiento para principiantes", 3, "2022-01-01 00:00:24", default, "10:00", "Actual", "Aumentar IMC a saludable");
	insert into tbd_rutinas values (default, "Resistencia metabólica", 1, "2022-01-01 00:00:24", default, "15:00", "Actual", "Definir musculo");
	insert into tbd_rutinas values (default, "Rutina de fuerza total", 5, "2022-01-01 00:00:24", default, "25:00", "Actual", "Ponerse mamado");

	UPDATE tbd_rutinas SET Estatus = "Concluido" WHERE ID = 2;

	DELETE FROM tbd_rutinas WHERE ID=4;
    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    END IF;
END

-- Procedimiento de población de Ejercicios - Rutinas
-- Campos de llaves foraneas de acuerdo al procedimiento del que se depende
CREATE DEFINER=`marinho`@`%` PROCEDURE `sp_poblar_ejercicios_rutinas`(v_password VARCHAR(20))
BEGIN
IF v_password = "qwerty" THEN
	insert into tbd_ejercicios_rutinas values (1, 1, "12", "Repeticiones", "Sin observaciones por el momento","2022-01-01 00:00:24", default, default);
	insert into tbd_ejercicios_rutinas values (2, 2, "15", "Repeticiones", "Realizar hasta el fallo muscular","2022-01-01 00:00:24", default, default);
	insert into tbd_ejercicios_rutinas values (3, 3, "20", "Repeticiones", "Evitar si tiene alguna lesion","2022-01-01 00:00:24", default, default);
	insert into tbd_ejercicios_rutinas values (1, 2, "40", "Repeticiones", "Sin observaciones por el momento","2022-01-01 00:00:24", default, default);
	insert into tbd_ejercicios_rutinas values (5, 5, "30", "Repeticiones", "Sin observaciones por el momento","2022-01-01 00:00:24", default, default);

	UPDATE tbd_ejercicios_rutinas SET Tipo = "Tiempo" where Ejercicio_ID = 5 and Rutina_ID = 5;

	DELETE FROM tbd_ejercicios_rutinas WHERE Ejercicio_ID = 1 and Rutina_ID = 2;
    ELSE 
      SELECT "La contraseña es incorrecta, no puedo mostrarte el 
      estatus de la Base de Datos" AS ErrorMessage;
    END IF;
END