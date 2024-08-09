-- --------------------- TABLA PRODUCTOS ----------------
CREATE DEFINER=`luz`@`%` PROCEDURE `sp_poblar_productos`(v_password varchar(10))
BEGIN
if v_password = "xYz$123" then
INSERT into tbb_productos values (default, "Proteina", "Ciel", "3366", "Productos especial de dieta","Grande", 200.50, null, null, '2024-06-21',default ),
(default, "Mancuernas", "Sport", "5264", "Mancuernas verdes","Mediano", 200.50, null, null, '2024-06-21',default),
(default, "Suplemento", "GAT sport", "2145", "Producto para masa muscular","Grande", 200.50, null, null, '2024-06-21',default ),
(default, "Toallas", "Insane ", "5742", "Color morado/ blanco /negro","Chico", 200.50, null, null, '2024-06-21',default ),
(default, "Muñequeras", "Tecnogym", "0254", "Muñequeras absorbentes","Mediano", 200.50, null, null, '2024-06-21',default ),
(default, "Tapete", "BH Fitness", "8844", "Tapete color rosa/blanco/verde","Grande", 200.50, null, null, '2024-06-21',default ),
(default, "Tés", "Tunturi", "8532", "Producto espcial de dieta","Grande", 200.50, null, null, '2024-06-21',default );


update tbb_productos set marca = "Sport Xico", estatus = b'1' where id=1;
update tbb_productos set estatus = b'1' where nombre="Suplemento";

delete from tbb_productos where codigo_barras= "8532";

else
select "La contraseña es incorrecta, no puedo mostrarte el estatus de la Base de datos" as ErrorMessage;

end if;
END

-- ---------------- TABLA DETALLES_PRODUCTOS ---------------------------
CREATE DEFINER=`luz`@`%` PROCEDURE `sp_poblar_detalles_productos`(v_password varchar(10))
BEGIN
if v_password = "xYz$123" then
INSERT into tbd_detalles_productos values 
(default, 1,"Producto elaborado especificamente para venta en gimnasio" "30", null, '2024-06-21',default ),
 (default, 2,"Producto elaborado especificamente para venta en gimnasio" "30", null, '2024-06-21',default ),
(default, 2,"Producto elaborado especificamente para venta en gimnasio" "5", null, '2024-06-21',default ),
(default, 3,"Producto elaborado especificamente para venta en gimnasio" "20", null, '2024-06-21',default ),
(default, 4,"Producto elaborado especificamente para venta en gimnasio" "50", null, '2024-06-21',default ),
 (default, 5,"Producto elaborado especificamente para venta en gimnasio" "250", null, '2024-06-21',default ),
 (default, 6,"Producto elaborado especificamente para venta en gimnasio" "90", null, '2024-06-21',default );


update tbd_detalles_productos set valor = "300"  where id=2;
update tbd_detalles_productos set estatus = b'1' where id=4;

delete from tbd_detalles_productos where producto_id= 5;
else
select "La contraseña es incorrecta, no puedo mostrarte el estatus de la Base de datos" as ErrorMessage;

end if;
END