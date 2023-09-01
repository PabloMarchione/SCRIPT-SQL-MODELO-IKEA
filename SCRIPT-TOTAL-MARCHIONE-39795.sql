CREATE SCHEMA ikea_model;
USE ikea_model;

#CREACION DE TABLAS

/* PRIMERO CREO LAS TABLAS, SIN LAS FK PORQUE ME VA A TIRAR ERROR SI NO EXISTE REFERENCIA*/
/* TAMPOCO LES AGREGO EL IF NOT EXIST PORQUE ES OBVIO QUE NO ESTAN */
CREATE TABLE clientes(  
    id_cliente INT NOT NULL auto_increment PRIMARY KEY,  
    nombre VARCHAR(30) NOT NULL,  
    apellido VARCHAR(30) NOT NULL,
    dni INT NOT NULL,
    direccion VARCHAR(150) NOT NULL UNIQUE,/*UNICO PARA PODER USARLO EN ENVIOS*/
    email VARCHAR(40) NOT NULL UNIQUE /*UNICO PARA PODER LINKEARLO CON UNA FK DE LA APP*/
); 

CREATE TABLE productos(  
    id_producto INT NOT NULL auto_increment PRIMARY KEY,  
    nombre VARCHAR(30) NOT NULL,  
    descripcion VARCHAR(255) NOT NULL,
    precio INT NOT NULL,
    id_estancia INT NOT NULL,
    id_stock INT NOT NULL
); 

CREATE TABLE empleados(  
    id_empleado INT NOT NULL auto_increment PRIMARY KEY,  
    nombre VARCHAR(30) NOT NULL,  
    apellido VARCHAR(30) NOT NULL,
    edad TINYINT NOT NULL,
    dni INT NOT NULL,
    id_recibo INT NOT NULL,
    id_sucursal INT NOT NULL,
    id_grupo INT NOT NULL
); 

CREATE TABLE recibos_de_sueldo(  
    id_recibo INT NOT NULL auto_increment PRIMARY KEY,  
    fecha_ingreso DATE NOT NULL,  
    periodo DATE NOT NULL,
    id_empleado INT NOT NULL,
    id_sueldo INT NOT NULL,
    sueldo_neto INT NOT NULL
); 

CREATE TABLE puestos(  
    id_puesto INT NOT NULL auto_increment PRIMARY KEY,  
    puesto VARCHAR(30) NOT NULL,  
    sueldo_bruto INT NOT NULL
); 

CREATE TABLE sueldos(  
    id_sueldo INT NOT NULL auto_increment PRIMARY KEY,  
    id_puesto INT NOT NULL,  
    aporte_sindical FLOAT NOT NULL,
    obra_social FLOAT NOT NULL,
    jubilacion FLOAT NOT NULL,
    presentismo FLOAT NOT NULL,
    antiguedad FLOAT NOT NULL DEFAULT(0), /* CERO PARA LOS NUEVOS, MENOR A UN "ANIO" */
    aguinaldo FLOAT /*PUEDE SER NULO*/
); 

CREATE TABLE sucursales(  
    id_sucursal INT NOT NULL auto_increment PRIMARY KEY,  
    locacion VARCHAR(150) NOT NULL,  
    id_grupo INT NOT NULL,
    id_stock INT NOT NULL,
    id_tipo_sucursal INT NOT NULL
); 

CREATE TABLE grupos_de_trabajo(  
    id_grupo INT NOT NULL auto_increment PRIMARY KEY,  
    listado VARCHAR(255) NOT NULL,  
    id_sucursal INT NOT NULL
); 

CREATE TABLE stocks(  
    id_stock INT NOT NULL auto_increment PRIMARY KEY,  
    id_producto INT NOT NULL,  
    cantidad INT NOT NULL,
    id_sucursal INT NOT NULL
); 

CREATE TABLE tipos_de_sucursales(  
    id_tipo_sucursal INT NOT NULL auto_increment PRIMARY KEY,  
    tipo VARCHAR(30) NOT NULL,  
    hace_envios CHAR(2) NOT NULL DEFAULT("si")
);

CREATE TABLE estancias(  
    id_estancia INT NOT NULL auto_increment PRIMARY KEY,  
    categoria VARCHAR(30) NOT NULL
);

CREATE TABLE facturas(  
    id_factura INT NOT NULL auto_increment PRIMARY KEY,  
    num_de_factura INT NOT NULL UNIQUE,
    fecha DATE NOT NULL,
    id_sucursal INT NOT NULL,
    id_empleado INT NOT NULL,
    id_producto INT NOT NULL,  
    cantidad INT NOT NULL,
    id_cliente INT NOT NULL,
    cuit INT NOT NULL DEFAULT(123456)
); 

CREATE TABLE proveedores(  
    id_proveedor INT NOT NULL auto_increment PRIMARY KEY,  
    nombre VARCHAR(30) NOT NULL,  
    cuit INT NOT NULL,
    iway CHAR(2) NOT NULL DEFAULT("si")
);

CREATE TABLE pedidos(  
    id_pedido INT NOT NULL auto_increment PRIMARY KEY,  
    id_producto INT NOT NULL,  
    cantidad INT NOT NULL,
    id_sucursal INT NOT NULL,
    id_proveedor INT NOT NULL
);

CREATE TABLE recibos_de_compra(  
    id_recibo INT NOT NULL auto_increment PRIMARY KEY,  
    num_de_recibo INT NOT NULL UNIQUE,
    fecha DATE NOT NULL,
    id_sucursal INT NOT NULL,
    id_producto INT NOT NULL,  
    cantidad INT NOT NULL,
    id_proveedor INT NOT NULL
); 

CREATE TABLE envios(  
    id_envio INT NOT NULL auto_increment PRIMARY KEY,  
    fecha_salida DATE NOT NULL,
    direccion varchar(150) NOT NULL,
    fecha_llegada DATE NOT NULL,
    id_factura INT NOT NULL
); 

CREATE TABLE apps_family(  
    id_app INT NOT NULL auto_increment PRIMARY KEY, 
    version_app FLOAT NOT NULL, /*LE PUSE ESTE NOMBRE PORQUE VERSION ME SALIA EN GRIS, COMO SI FUERA UNA OPCION DEL MYSQL*/
    id_cuenta_app INT NOT NULL
);

CREATE TABLE cuentas_app(  
    id_cuenta_app INT NOT NULL auto_increment PRIMARY KEY, 
    id_cliente INT NOT NULL,
    email VARCHAR(40) NOT NULL UNIQUE,
    id_beneficio INT NOT NULL
);

CREATE TABLE beneficios_app(  
    id_beneficio INT NOT NULL auto_increment PRIMARY KEY, 
    aplica_descuento CHAR(2) NOT NULL,
    acceso_a_eventos CHAR(2) NOT NULL, 
    regalos CHAR(2) NOT NULL
);



/* ACA EMPIEZA LA CREACION DE LAS FK */

ALTER TABLE productos                                               
ADD CONSTRAINT FK_producto_estancia FOREIGN KEY (id_estancia) 
REFERENCES estancias(id_estancia) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT FK_producto_stock FOREIGN KEY (id_stock) 
REFERENCES stocks(id_stock) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE empleados
ADD CONSTRAINT FK_empleado_recibo FOREIGN KEY (id_recibo) 
REFERENCES recibos_de_sueldo(id_recibo) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT FK_empleado_sucursal FOREIGN KEY (id_sucursal) 
REFERENCES sucursales(id_sucursal) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT FK_empleado_grupo FOREIGN KEY (id_grupo) 
REFERENCES grupos_de_trabajo(id_grupo) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE recibos_de_sueldo
ADD CONSTRAINT FK_recibo_sueldo FOREIGN KEY (id_sueldo) 
REFERENCES sueldos(id_sueldo) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE sueldos
ADD CONSTRAINT FK_puesto FOREIGN KEY (id_puesto) 
REFERENCES puestos(id_puesto) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE sucursales
ADD CONSTRAINT FK_sucursal_grupo FOREIGN KEY (id_grupo) 
REFERENCES grupos_de_trabajo(id_grupo) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT FK_sucursal_stock FOREIGN KEY (id_stock) 
REFERENCES stocks(id_stock) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT FK_sucursal_tipo FOREIGN KEY (id_tipo_sucursal) 
REFERENCES tipos_de_sucursales(id_tipo_sucursal) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE facturas
ADD CONSTRAINT FK_factura_sucursal FOREIGN KEY (id_sucursal) 
REFERENCES sucursales(id_sucursal) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT FK_factura_empleado FOREIGN KEY (id_empleado) 
REFERENCES empleados(id_empleado) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT FK_factura_producto FOREIGN KEY (id_producto) 
REFERENCES productos(id_producto) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT FK_factura_cliente FOREIGN KEY (id_cliente) 
REFERENCES clientes(id_cliente) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE pedidos
ADD CONSTRAINT FK_pedido_producto FOREIGN KEY (id_producto) 
REFERENCES productos(id_producto) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT FK_pedido_proveedor FOREIGN KEY (id_proveedor) 
REFERENCES proveedores(id_proveedor) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT FK_pedido_sucursal FOREIGN KEY (id_sucursal) 
REFERENCES sucursales(id_sucursal) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE recibos_de_compra
ADD CONSTRAINT FK_recibo_producto FOREIGN KEY (id_producto) 
REFERENCES productos(id_producto) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT FK_recibo_proveedor FOREIGN KEY (id_proveedor) 
REFERENCES proveedores(id_proveedor) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT FK_recibo_sucursal FOREIGN KEY (id_sucursal) 
REFERENCES sucursales(id_sucursal) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE envios
ADD CONSTRAINT FK_envio_factura FOREIGN KEY (id_factura) 
REFERENCES facturas(id_factura) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE apps_family
ADD CONSTRAINT FK_app_cuenta FOREIGN KEY (id_cuenta_app) 
REFERENCES cuentas_app(id_cuenta_app) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE cuentas_app
ADD CONSTRAINT FK_cuenta_app_cliente FOREIGN KEY (id_cliente) 
REFERENCES clientes(id_cliente) ON UPDATE CASCADE ON DELETE CASCADE,
ADD CONSTRAINT FK_cuenta_app_beneficio FOREIGN KEY (id_beneficio) 
REFERENCES beneficios_app(id_beneficio) ON UPDATE CASCADE ON DELETE CASCADE;

#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#CREACION DE INSERTS EN ORDEN

# X = veo la tabla, veo de nuevo que haya impactado
# No hace falta especificar los parametros al insert porque inserto en todos en el mismo orden

#X
#SELECT * FROM ikea_model.stocks;
INSERT INTO stocks 
VALUES 
(1, 1, 23, 1),
(2, 2, 4, 2),
(3, 3, 33, 3),
(4, 4, 100,4),
(5, 5, 50, 5);

#X
#SELECT * FROM ikea_model.estancias;
INSERT INTO estancias 
VALUES 
(1, "dormitorio"),
(2, "salon"),
(3, "jardin"),
(4, "cocina"),
(5, "comedor"),
(6, "infantil"),
(7, "baño"),
(8, "oficina"),
(9, "living"),
(10, "lavadero");

#X
#SELECT * FROM ikea_model.productos;
INSERT INTO productos 
VALUES 
(1,"mesa","cedro",202,1,1),
(2,"silla","cahoba",44,2,2),
(3,"sillon","roble",377,3,3),
(4,"escritorio","pino",120,4,4),
(5,"comoda","fresno",37,5,5);

#X
#SELECT * FROM ikea_model.puestos;
INSERT INTO puestos
VALUES
(1,"gerente",888),
(2,"encargado",603),
(3,"repositor",532),
(4,"administrativo",568),
(5,"ensamblador",600);

#X
#SELECT * FROM ikea_model.sueldos;
INSERT INTO sueldos
VALUES
(1,1,0,0,0,0,0,0),
(2,2,0,0,0,0,0,0),
(3,3,0,0,0,0,0,0),
(4,4,0,0,0,0,0,0),
(5,5,0,0,0,0,0,0);

#X
#SELECT * FROM ikea_model.tipos_de_sucursales;
INSERT INTO tipos_de_sucursales
VALUES
(1,"general","si"),
(2,"urbana","si"),
(3,"espacio-ikea","no"),
(4,"espacio-ikea","no"),
(5,"espacio-ikea","no");

#X
#SELECT * FROM ikea_model.recibos_de_sueldo;
INSERT INTO recibos_de_sueldo 
VALUES 
(1, '2014-06-26', '2023-04-01', 1, 1, 1028),
(2, '2016-05-11', '2023-04-01', 2, 2, 529),
(3, '2015-03-23', '2023-04-01', 3, 3, 1174),
(4, '2021-05-31', '2023-04-01', 4, 4, 854),
(5, '2013-01-23', '2023-04-01', 5, 5, 661);

#X
#SELECT * FROM ikea_model.grupos_de_trabajo;
INSERT INTO grupos_de_trabajo
VALUES
(1,"a",1),
(2,"b",2),
(3,"c",3),
(4,"d",4),
(5,"e",5);

#X
#SELECT * FROM ikea_model.sucursales;
INSERT INTO sucursales
VALUES
(1,"61 Bobwhite Parkway",1,1,2),
(2,"77 David Avenue",2,2,1),
(3,"046 Westridge Road",3,3,1),
(4,"8022 Ryan Street",4,4,4),
(5,"123 Fake Street",4,4,5),
(6,"5177 Hintze Court",5,5,3);

#X
#SELECT * FROM ikea_model.empleados;
INSERT INTO empleados
VALUES
(1,"Heath","Lamdin",18,20241608,1,1,1),
(2,"Randie","Lammenga",50,74951080,2,2,2),
(3,"Jerome","Daudray",39,13658213,3,3,3),
(4,"Frazer","Hammerson",25,56167886,4,4,4),
(5,"Tani","Sabin",22,63654599,5,5,5);

#X
#SELECT * FROM ikea_model.clientes;
INSERT INTO clientes
VALUES
(1,"Chelsie","Rubery",41813618,"589 Mitchell Street","crubery0@topsy.com"),
(2,"Dame","Marcroft",44700310,"96403 Browning Place","dmarcroft1@mit.edu"),
(3,"Maje","Risebarer",74987647,"07699 Waubesa Lane","mrisebarer2@msu.edu"),
(4,"Laurene","Marle",35042531,"04 Moose Street","lmarle3@ning.com"),
(5,"Mala","Emblen",71399460,"5320 Warbler Park","memblen4@bigcartel.com");

#X
#SELECT * FROM ikea_model.facturas;
INSERT INTO facturas 
VALUES 
(1, 1, '2021-07-01', 1, 1, 1, 8, 1, DEFAULT),
(2, 2, '2013-08-05', 2, 2, 2, 1, 2, DEFAULT),
(3, 3, '2015-04-11', 3, 3, 3, 10, 3, DEFAULT),
(4, 4, '2019-08-01', 4, 4, 4, 7, 4, DEFAULT),
(5, 5, '2014-05-09', 5, 5, 5, 8, 5, DEFAULT),
(6, 6, '2023-06-05', 1, 3, 2, 20, 2, DEFAULT);

#X
#SELECT * FROM ikea_model.proveedores;
INSERT INTO proveedores
VALUES
(1,"Nitzsche Group",213456817,"si"),
(2,"Watsica-Keebler",213456860,"si"),
(3,"Larson-Stroman",213456799,"si"),
(4,"Hagenes-Lehner",213456870,"si"),
(5,"Hermiston Inc",213456796,"si");

#X
#SELECT * FROM ikea_model.pedidos;
INSERT INTO pedidos
VALUES
(1,1,89,1,1),
(2,2,99,2,2),
(3,3,11,3,3),
(4,4,82,4,4),
(5,5,26,5,5);

#X
#SELECT * FROM ikea_model.recibos_de_compra;
INSERT INTO recibos_de_compra
VALUES
(1,1,"2021-04-18",1,1,62,1),
(2,2,"2014-04-17",2,2,69,2),
(3,3,"2021-07-25",3,3,25,3),
(4,4,"2013-09-16",4,4,44,4),
(5,5,"2013-08-14",5,5,6,5);

#X
#SELECT * FROM ikea_model.envios;
INSERT INTO envios
VALUES
(1,"2021-11-08","9 Nancy Point","2021-11-11",1),
(2,"2020-04-18","5600 Dixon Alley","2020-04-21",2),
(3,"2013-01-18","8 Merchant Drive","2013-01-21",3),
(4,"2011-11-16","13 Twin Pines Circle","2011-11-19",4),
(5,"2021-06-18","86445 Dayton Hill","2021-06-21",5);

#X
#SELECT * FROM ikea_model.beneficios_app;
INSERT INTO beneficios_app
VALUES
(1,"si","no","no"),
(2,"no","si","no"),
(3,"no","no","si"),
(4,"si","si","no"),
(5,"si","no","si"),
(6,"no","si","si"),
(7,"si","si","si");

#X
#SELECT * FROM ikea_model.cuentas_app;
INSERT INTO cuentas_app
VALUES
(1,1,"cducaen0@hao123.com",1),
(2,2,"mkrzysztofiak1@xrea.com",2),
(3,3,"dsottell2@friendfeed.com",3),
(4,4,"sduker3@domainmarket.com",4),
(5,5,"ahassall4@hugedomains.com",5);

#X
#SELECT * FROM ikea_model.apps_family;
INSERT INTO apps_family
VALUES
(1,1.0,1),
(2,1.68,2),
(3,1.87,3),
(4,1.61,4),
(5,1.81,5);


#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#CREACION DE VIEWS

# Miro la tabla
#SELECT * FROM ikea_model.productos;

CREATE VIEW Ofertas_del_mes AS     # De aca podria salir publicidad
SELECT nombre, descripcion, precio #Antes de crearla, ejecuto desde aca para ver como queda
FROM productos
WHERE precio <= 330
ORDER BY precio ASC;

#SELECT * FROM Ofertas_del_mes; #TEST
/*////////////////////////////////////////////////////////////////////////////////////////*/
# Miro la tabla
#SELECT * FROM ikea_model.facturas;
#SELECT * FROM ikea_model.empleados;

CREATE VIEW rendimientos_de_empleados AS  # Para bonos y/o sanciones
SELECT F.cantidad, E.nombre
FROM facturas F
INNER JOIN empleados E
ON F.id_empleado = E.id_empleado
ORDER BY cantidad DESC;

#SELECT * FROM rendimientos_de_empleados;
/*////////////////////////////////////////////////////////////////////////////////////////*/

#SELECT * FROM ikea_model.sucursales;
#SELECT * FROM ikea_model.facturas;

CREATE VIEW rendimientos_de_sucursales AS  # Lo mismo pero para ver que sucursal vende mas
SELECT F.cantidad, S.locacion, S.id_sucursal
FROM facturas F
INNER JOIN sucursales S
ON F.id_sucursal = S.id_sucursal
ORDER BY cantidad DESC;

#SELECT * FROM rendimientos_de_sucursales;
/*////////////////////////////////////////////////////////////////////////////////////////*/

#SELECT * FROM ikea_model.sucursales;
#SELECT * FROM ikea_model.stocks;
#SELECT * FROM ikea_model.tipos_de_sucursales;

CREATE VIEW stocks_bajos AS  # Para ver que sucursal tiene stock bajo y de que tipo es
SELECT ST.cantidad, S.locacion, TP.tipo
FROM stocks ST
INNER JOIN sucursales S
ON ST.id_sucursal = S.id_sucursal
INNER JOIN tipos_de_sucursales TP#TRIPLE JOIN!!! x_X (se me muere el hamster de la capocha)
ON S.id_tipo_sucursal = TP.id_tipo_sucursal 
WHERE ST.cantidad < 45
ORDER BY ST.cantidad ASC;

#SELECT * FROM stocks_bajos;
/*////////////////////////////////////////////////////////////////////////////////////////*/

#SELECT * FROM ikea_model.productos;
#SELECT * FROM ikea_model.facturas;

CREATE VIEW mas_vendido_all_time AS   #El producto estelar
SELECT F.cantidad, P.nombre
FROM facturas F
INNER JOIN productos P
ON F.id_producto = P.id_producto
WHERE F.cantidad = (SELECT MAX(F.cantidad)	#No estoy tan seguro de que funcione aca
FROM facturas)
ORDER BY F.cantidad DESC 
LIMIT 1; # Porque ordenarlo de manera descendente y con limite 1 siempre trae el maximo no?

#SELECT * FROM mas_vendido_all_time;
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#CREACION DE FUNCIONES

#SELECT * FROM ikea_model.recibos_de_sueldo;

DELIMITER $$
CREATE FUNCTION `masa_de_sueldos` ()
RETURNS INT 
READS SQL DATA
NOT DETERMINISTIC
BEGIN
	DECLARE total INT;
    SET total = 
    (SELECT SUM(sueldo_neto) FROM recibos_de_sueldo);
RETURN total;
END$$

#SELECT masa_de_sueldos() AS total_de_sueldos;

/*////////////////////////////////////////////////////////////////////////////////////////*/

#SELECT * FROM ikea_model.clientes;
#SELECT * FROM ikea_model.cuentas_app;

DELIMITER $$
CREATE FUNCTION `clientes_sin_app` () #Para proyeccion de la app
RETURNS INT 
READS SQL DATA
NOT DETERMINISTIC
BEGIN
	DECLARE total INT;
    SET total = 
    (SELECT COUNT(id_cliente) FROM clientes) -
    (SELECT COUNT(id_cuenta_app) FROM cuentas_app);
RETURN total;
END$$

#SELECT clientes_sin_app() AS clientes_a_capturar;
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#CREACION DE STORED PROCEDURES

#SELECT * FROM ikea_model.empleados; #Tablas para info
#SELECT * FROM ikea_model.recibos_de_sueldo;
#SELECT * FROM ikea_model.sueldos;
DELIMITER $$
CREATE PROCEDURE `calcular_aporteOS`(IN idrecibo INT)
BEGIN
	SET @x = (SELECT sueldo_neto FROM recibos_de_sueldo #Creo una variable para obtener el
	WHERE id_recibo = idrecibo);						#sueldo neto sin hacerla tan larga
    
	UPDATE sueldos
	SET obra_social = (@x * 0.35)	#Hago el calculo y lo grabo en la fila
	WHERE id_sueldo = idrecibo;		#donde el numero del sueldo es = al ingresado por parametro
    
    SELECT * FROM ikea_model.sueldos; #Muestro la tabla para ver los cambios
END $$

#CALL calcular_aporteOS(5); #Llamo al SP y le paso un parametro
/*///////////////////////////////////////////////////////////////////////////////////////*/

#SELECT * FROM productos;
#SELECT * FROM stocks;

DELIMITER $$
CREATE PROCEDURE `buscar_producto`(IN nombreproducto VARCHAR(30))
BEGIN
	IF nombreproducto IN (SELECT nombre FROM productos) THEN
		SELECT nombreproducto AS Resultado, SUM(S.cantidad) AS Unidades 
        FROM productos P
        INNER JOIN stocks S
        WHERE P.id_stock = S.id_stock
        ORDER BY S.cantidad DESC;
    ELSE 
		SET @mensaje = "No se encontro el producto";
        SELECT @mensaje;
	END IF;
END$$

#CALL buscar_producto("mesa"); #Llamo al SP y le paso un parametro

#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#CREACION DE TRIGGERS

#USE ikea_model;
#SELECT * FROM ikea_model.productos;    #SELECCIONO LA TABLA PARA CREAR UNA CON LOS MISMOS CAMPOS

CREATE TABLE bitacora_productos (							#CREO LA TABLA BITACORA
    id_bitacora_producto INT AUTO_INCREMENT PRIMARY KEY,
    id_anterior INT NOT NULL,                               #ME INTERESA MUCHO SABER SI CAMBIA EL ID
    id_actual INT NOT NULL,									#PORQUE DESPUES NO PODRIA TRACKEAR QUE O QUIEN CAMBIO
    nombre VARCHAR(30) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    precio INT NOT NULL,
    id_estancia INT NOT NULL,
    id_stock INT NOT NULL,
    modificado_el DATETIME DEFAULT NULL,
    emisor VARCHAR(30) NOT NULL
);

DELIMITER $$
CREATE TRIGGER TRG_bitacora_productos             #CREO EL TRIGGER
    BEFORE UPDATE ON productos
    FOR EACH ROW 
	INSERT INTO bitacora_productos VALUES(
        NULL,
		OLD.id_producto,
        NEW.id_producto,
		OLD.nombre,
		OLD.descripcion,
		OLD.precio,
		OLD.id_estancia,
		OLD.id_stock,
		NOW(),
		(SELECT SESSION_USER()));
$$

#SELECT * FROM ikea_model.bitacora_productos;		#ME FIJO QUE ESTE TODO OK

/*UPDATE `ikea_model`.`productos` SET   #MODIFICO UN VALOR PARA VER SI FUNCIONA
`id_producto` = '1', 
`nombre` = 'ttt', 
`descripcion` = 'asdasd', 
`precio` = '1', 
`id_estancia` = '5', 
`id_stock` = '5' WHERE (`id_producto` = '1');*/
/*(1,"mesa","cedro",202,1,1),*/ #Valor original
#SELECT * FROM ikea_model.bitacora_productos; #VUELVO A VER LA BITACORA A VER SI IMPACTO EL CAMBIO
#DROP TRIGGER `TRG_bitacora_productos`;
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#USE ikea_model;

#SELECT * FROM ikea_model.clientes;   #SELECCIONO LA TABLA PARA CREAR UNA CON LOS MISMOS CAMPOS

CREATE TABLE bitacora_clientes (                     #CREO LA TABLA BITACORA
    id_bitacora_cliente INT AUTO_INCREMENT PRIMARY KEY,
    id_anterior INT NOT NULL,         #ME INTERESA MUCHO SABER SI CAMBIA EL ID
    id_actual INT NOT NULL,			  #PORQUE DESPUES NO PODRIA TRACKEAR QUE O QUIEN CAMBIO
    nombre VARCHAR(30) NOT NULL,
    apellido VARCHAR(30) NOT NULL,
    dni INT NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    email VARCHAR(40) NOT NULL,
    modificado_el DATETIME DEFAULT NULL,
    emisor VARCHAR(30) NOT NULL
);

DELIMITER $$
CREATE TRIGGER TRG_bitacora_clientes
    BEFORE UPDATE ON clientes
    FOR EACH ROW 
	INSERT INTO bitacora_clientes VALUES(
        NULL,
		OLD.id_cliente,
        NEW.id_cliente,
		OLD.nombre,
		OLD.apellido,
		OLD.dni,
		OLD.direccion,
		OLD.email,
		NOW(),
		(SELECT SESSION_USER()));
$$

#SELECT * FROM ikea_model.bitacora_clientes;		#ME FIJO QUE ESTE TODO OK

/*UPDATE `ikea_model`.`clientes` SET 				#MODIFICO UN VALOR PARA VER SI FUNCIONA
`id_cliente` = '6', 
`nombre` = 'juanito', 
`apellido` = 'perez', 
`dni` = '99', 
`direccion` = 'Calle falsa 123', 
`email` = 'juanito@sarasa.com' WHERE (`id_cliente` = '1');*/

#SELECT * FROM ikea_model.bitacora_clientes;		#VUELVO A VER LA BITACORA A VER SI IMPACTO EL CAMBIO
#DROP TRIGGER `TRG_bitacora_productos`;

#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#CREACION DE USERS
/*
USE Mysql;
SHOW tables;
SELECT * FROM USER;

CREATE USER pepe@localhost IDENTIFIED BY 'Reloj33'; #CREO LOS USUARIOS
CREATE USER tito@localhost IDENTIFIED BY '1Escudo';

GRANT SELECT ON ikea_model.* TO pepe@localhost;					#DOY LOS PERMISOS
GRANT SELECT, INSERT, UPDATE ON ikea_model.* TO tito@localhost;

SHOW GRANTS FOR pepe@localhost;	#CHEQUEO LOS CAMBIOS
SHOW GRANTS FOR tito@localhost;
*/
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
#CREACION DE TCL
USE ikea_model;
SELECT @@AUTOCOMMIT;		#VEO LA CONFIG	
SET AUTOCOMMIT = 0;			#LA APAGO

SELECCION DE TABLAS PARA EL DESAFIO
SELECT * FROM puestos;
SELECT * FROM tipos_de_sucursales;

#1 DELETE
START TRANSACTION; 
DELETE FROM puestos
WHERE id_puesto = 3;
SELECT * FROM puestos; #VEO EL CAMBIO
ROLLBACK			   #LO RESTAURO
SELECT * FROM puestos; #CHEQUEO
COMMIT


#2 INSERT
SELECT * FROM tipos_de_sucursales;
START TRANSACTION; 				#INICIO TRANSACCION
INSERT INTO tipos_de_sucursales
VALUES
(40,"QQQ","no"),
(41,"QQQ","no"),
(42,"QQQ","no"),
(43,"QQQ","no");
SAVEPOINT BLOQUE_1;	#PRIMER SAVE
INSERT INTO tipos_de_sucursales
VALUES
(50,"QQQ","no"),
(51,"QQQ","no"),
(52,"QQQ","no"),
(53,"QQQ","no");
SAVEPOINT BLOQUE_2;		#SEGUNDO SAVE
SELECT * FROM tipos_de_sucursales; #VEO LOS CAMBIOS
ROLLBACK TO BLOQUE_1 		#ELIMINO LO DEL SAVE 2
SELECT * FROM tipos_de_sucursales; #VEO LOS CAMBIOS DEL ROLLBACK
RELEASE SAVEPOINT BLOQUE_1 #ELIMINO EL SAVEPOINT
ROLLBACK 					#DESHAGO TODO
SELECT * FROM tipos_de_sucursales; #CHEQUEO
*/
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#GENERACION DE INFORMES

#FACTURACION DEL DIA ANTERIOR------------------SIMPLONA
/*
SELECT * FROM FACTURAS
WHERE fecha=CURDATE()-1 #ayer
ORDER BY num_de_factura ASC; 
*/
#EN FORMA DE EVENTO PARA NO TENER QUE EJECUTAR UNA QUERY

#SET GLOBAL event_scheduler = ON;                    #CONFIG DE EVENTOS ACTIVOS
#SHOW EVENTS FROM ikea_model;						#---
#SHOW PROCESSLIST;									#--
#DROP EVENT IF EXISTS event_informe_facturacion;		#-

/*
CREATE EVENT event_informe_facturacion					#PRUEBA 1, EL EVENTO CREA SIEMPRE FACTURAS DE "AYER"
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 MINUTE	#ASI LO PUEDEN PROBAR PARA CORREGIR
ON COMPLETION PRESERVE									#PARA QUE NO SE ELIMINE SOLO AL TERMINAR
DO INSERT INTO facturas 
VALUES 
(99, 99, CURDATE()-1, 1, 3, 2, 20, 3, DEFAULT),
(100, 100, CURDATE()-1, 3, 4, 3, 5, 2, DEFAULT),
(101, 101, CURDATE()-1, 5, 3, 1, 77, 5, DEFAULT);
*/
/*
SELECT CURRENT_TIMESTAMP;						#PRUEBAS DE FECHA Y BORRADO DE FACTURAS INSERTADAS
SELECT CURDATE();
DELETE FROM facturas WHERE id_factura >=99;
*/

/*
DROP VIEW IF EXISTS informe_diario;				#PRUEBA DE CREACION DE UNA VISTA PARA EL INFORME CON LAS COLUMNNAS RELEVANTES
CREATE VIEW informe_diario AS
SELECT num_de_factura AS Factura_Nº, id_sucursal AS Sucursal, id_producto AS Producto, cantidad AS Unidades
FROM facturas
WHERE fecha=CURDATE()-1
ORDER BY num_de_factura ASC;
SELECT * FROM informe_diario;					#TESTEO DE VISTA
*/

/*
#CREACION DE UN SP PARA QUE EJECUTE EL EVENTO Y HAGA TODO
DELIMITER $$									
CREATE PROCEDURE `sp_informe_diario`()
BEGIN
	DELETE FROM facturas WHERE id_factura >=99;				#ELIMINA LAS INSERTADAS PARA LA PRUEBA, ASI SE PUEDE VOLVER A LLAMAR EL SP
    DROP VIEW IF EXISTS vw_informe_diario;					#BORRA LA VISTA VIEJA PARA HACER UNA ACTUALIZADA
	INSERT INTO facturas 									#AGREGA REGISTROS
	VALUES 
	(99, 99, CURDATE()-1, 1, 3, 2, 20, 3, DEFAULT),
	(100, 100, CURDATE()-1, 3, 4, 3, 5, 2, DEFAULT),
	(101, 101, CURDATE()-1, 5, 3, 1, 77, 5, DEFAULT);

	CREATE VIEW vw_informe_diario AS	
	SELECT num_de_factura AS Factura_Nº, id_sucursal AS Sucursal, id_producto AS Producto, cantidad AS Unidades
	FROM facturas
	WHERE fecha=CURDATE()-1
	ORDER BY num_de_factura ASC;
    
    SELECT * FROM vw_informe_diario;
END$$
#DROP PROCEDURE IF EXISTS sp_informe_diario;	
#CALL sp_informe_diario();
*/

/*
#AHORA INTENTO ACOPLAR TODO LO ANTERIOR
#SELECT * FROM facturas;
#DELETE FROM facturas WHERE id_factura >=99;
#DROP EVENT IF EXISTS event_informe_facturacion;
DELIMITER $$															
CREATE EVENT event_informe_facturacion									#NO LO PUDE HACER ANDAR
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 MINUTE					#NUNCA EJECUTA EL SELECT
ON COMPLETION PRESERVE													#YA SEA AL FINAL DEL EVENTO O AL FINAL DEL SP
DO 
BEGIN																	    #                #
	CALL sp_informe_diario();
	SELECT * FROM vw_informe_diario;									#-------------------------
END$$	
*/

#AL FINAL ME QUEDO CON EL SP :(
#CALL sp_informe_diario();																		
