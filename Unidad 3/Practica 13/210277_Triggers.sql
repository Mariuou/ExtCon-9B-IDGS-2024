-- --------------- TABLA PRODUCTOS ----------------------------
CREATE DEFINER=`luz`@`%` TRIGGER `tbb_productos_AFTER_INSERT` AFTER INSERT ON `tbb_productos` FOR EACH ROW BEGIN
DECLARE v_estatus varchar(20) default 'Activo';
if not new.estatus then
set v_estatus = 'Inactivo';
end if;
insert into tbi_bitacora values
(default,
current_user(),
'Create',
'tbb_productos',
concat_ws(' ', 'Se ha creado el nuevo producto con los
siguientes datos:',
'ID: ', new.id, ' NOMBRE: ', new.nombre, 'MARCA:
',new.marca,
'CODIGO_BARRAS: ', new.codigo_barras, 'DESCRIPCION: ',
new.descripcion, 'PRESENTACIÓN : ',new.presentacion,
'PRECIO_ACTUAL: ', new.precio_actual, 'FOTOGRAFÍA: ',
new.fotografia, 'ESTATUS: ',new.estatus,
'ESTATUS: ',v_estatus ,
"FECHA REGISTRO:", new.Fecha_Registro, 
"FECHA ACTUALIZACION", new.Fecha_Actualizacion), default, default
);
END

-- -------------------------------------------------------------------
CREATE DEFINER=`luz`@`%` TRIGGER `tbb_productos_BEFORE_UPDATE` BEFORE UPDATE ON `tbb_productos` FOR EACH ROW BEGIN
SET NEW.Fecha_actualizacion = current_timestamp();
END

-- -----------------------------------------------------------------------------

CREATE DEFINER=`luz`@`%` TRIGGER `tbb_productos_AFTER_UPDATE` AFTER UPDATE ON `tbb_productos` FOR EACH ROW BEGIN
DECLARE v_estatus_old varchar(20) default 'Activo';
declare v_estatus_new varchar(20) default 'Activo';
if not old.estatus then
set v_estatus_old = 'Inactivo';
end if;
if not new.estatus then
set v_estatus_new = 'Inactivo';
end if;
insert into tbi_bitacora values
(default,
current_user(),
'Update',
'tbb_productos',
concat_ws(' ', 'Se ha editado el producto con los siguientes
datos:',
'ID: ', old.id, ' NOMBRE: ', old.nombre, 'MARCA:
',old.marca,
'CODIGO_BARRAS: ', old.codigo_barras, 'DESCRIPCION: ',
old.descripcion, 'PRESENTACIÓN : ',old.presentacion,
'PRECIO_ACTUAL: ', old.precio_actual, 'FOTOGRAFÍA: ',
old.fotografia, 'ESTATUS: ',old.estatus,
'ESTATUS: ',v_estatus_old, '-', v_estatus_new ,
 "FECHA REGISTRO:", old.Fecha_Registro, 
"FECHA ACTUALIZACION", old.Fecha_Actualizacion),default,
default
);
END

-- -------------------------------------------------------------------------------------------------
CREATE DEFINER=`luz`@`%` TRIGGER `tbb_productos_BEFORE_DELETE` BEFORE DELETE ON `tbb_productos` FOR EACH ROW BEGIN
DECLARE v_estatus varchar(20) default 'Activo';
if NOT OLD.estatus then
set v_estatus = 'Inactivo';
end if;
insert into tbi_bitacora values
(default,
current_user(),
'Delete',
'tbb_productos',
concat_ws(' ', 'Se ha eliminado el producto con los
siguientes datos:',
'ID: ', old.id, ' NOMBRE: ', old.nombre, 'MARCA:
',old.marca,
'CODIGO_BARRAS: ', old.codigo_barras, 'DESCRIPCION: ',
old.descripcion, 'PRESENTACIÓN : ',old.presentacion,
'PRECIO_ACTUAL: ', old.precio_actual, 'FOTOGRAFÍA: ',
old.fotografia, 'ESTATUS: ',old.estatus,
'ESTATUS: ',v_estatus ,
"FECHA REGISTRO:", old.Fecha_Registro, 
"FECHA ACTUALIZACION", old.Fecha_Actualizacion), default, default
);
END



-- --------------- TABLA DETALLES PRODUCTOS -------------------

CREATE DEFINER=`luz`@`%` TRIGGER `tbd_detalles_productos_AFTER_INSERT` AFTER INSERT ON `tbd_detalles_productos` FOR EACH ROW BEGIN
DECLARE v_estatus varchar(20) default 'Activo';
if not new.estatus then
set v_estatus = 'Inactivo';
end if;
insert into tbi_bitacora values
(default,
current_user(),
'Create',
'tbd_detalles_productos',
concat_ws(' ', 'Se han insertado los dettales de un nuevo producto con los
siguientes datos:',
'ID: ', new.id, 
' ID PRODUCTO: ', new.producto_id, 
'DESCRIPCIÓN:',new.descripcion,
'VALOR: ', new.valor, 
'ESTATUS: ',new.estatus,
'ESTATUS: ',v_estatus,
"FECHA REGISTRO:", new.Fecha_Registro, 
"FECHA ACTUALIZACION", new.Fecha_Actualizacion), default, default
);
END

-- ----------------------------------------------------------------------------------------------
CREATE DEFINER=`luz`@`%` TRIGGER `tbd_detalles_productos_BEFORE_UPDATE` BEFORE UPDATE ON `tbd_detalles_productos` FOR EACH ROW BEGIN
SET NEW.Fecha_actualizacion = current_timestamp();
END

-- ----------------------------------------------------------------------------------------
CREATE DEFINER=`luz`@`%` TRIGGER `tbd_detalles_productos_AFTER_UPDATE` AFTER UPDATE ON `tbd_detalles_productos` FOR EACH ROW BEGIN
DECLARE v_estatus_old varchar(20) default 'Activo';
declare v_estatus_new varchar(20) default 'Activo';
if not old.estatus then
set v_estatus_old = 'Inactivo';
end if;
if not new.estatus then
set v_estatus_new = 'Inactivo';
end if;
insert into tbi_bitacora values
(default,
current_user(),
'Update',
'tbd_detalles_productos',
concat_ws(' ', 'Se han editado los detalles de un nuevo producto con los
siguientes datos:',
'ID: ', old.id, 
'ID PRODUCTO: ', old.producto_id, 
'DESCRIPCIÓN:',old.descripcion,
'VALOR: ', old.valor, 
'ESTATUS: ',old.estatus,
'ESTATUS: ',v_estatus_old, '-', v_estatus_new ,
"FECHA REGISTRO:", old.Fecha_Registro, 
"FECHA ACTUALIZACION", old.Fecha_Actualizacion), default, default
);
END

-- --------------------------------------------------------------------------------------------------
CREATE DEFINER=`luz`@`%` TRIGGER `tbd_detalles_productos_BEFORE_DELETE` BEFORE DELETE ON `tbd_detalles_productos` FOR EACH ROW BEGIN
DECLARE v_estatus varchar(20) default 'Activo';
if NOT OLD.estatus then
set v_estatus = 'Inactivo';
end if;
insert into tbi_bitacora values
(default,
current_user(),
'Delete',
'tbd_detalles_productos',
concat_ws(' ', 'Se han eliminado los detalles de un nuevo producto con los
siguientes datos:',
'ID: ', old.id, 
'ID PRODUCTO: ', old.producto_id, 
'DESCRIPCIÓN:',old.descripcion,
'VALOR: ', old.valor, 
'ESTATUS: ',old.estatus,
'ESTATUS: ',v_estatus ,
"FECHA REGISTRO:", old.Fecha_Registro, 
"FECHA ACTUALIZACION", old.Fecha_Actualizacion), default, default
);
END

