DROP DATABASE IF EXISTS kmart;

CREATE DATABASE kmart;
USE kmart;

CREATE TABLE `products`(
id_producto       INT NOT NULL AUTO_INCREMENT ,
nombre_producto   VARCHAR (100) DEFAULT "producto x",
precio            FLOAT (10,2) DEFAULT 100.00,
`nombre_cliente`  VARCHAR (200) DEFAULT "cliente x",
PRIMARY KEY (id_producto)
);

-- DML INSERT
/*INSERT INTO tbl_name (a,b,c)
    VALUES
    (1,2,3), 
    (4,5,6), 
    (7,8,9);
    */

    
INSERT INTO `kmart`.`products` 
(
id_producto
, nombre_producto
, precio
, `nombre_cliente` 
) VALUES
(100,'tita',1, 'Marcelo');

INSERT INTO `kmart`.`products` 
(
id_producto
, nombre_producto
, precio
, `nombre_cliente` 
) VALUES
(NULL,'tita',1, 'Marcelo');

INSERT INTO `kmart`.`products` 
( nombre_producto
, precio
, `nombre_cliente` )
VALUE
('oreo',10,'Emma');



INSERT INTO `kmart`.`products` 
( nombre_producto
, `nombre_cliente` )
VALUE
('arroz con leche','Maximo');

INSERT INTO `kmart`.`products` 
( nombre_producto
, precio
, `nombre_cliente` )
VALUE
('papas fritas',DEFAULT,DEFAULT);

SELECT * 
FROM products;

-- BULK INSERT
-- tarea cargar toda la base de datos

-- UPDATE
SELECT *
FROM `kmart`.`products`  AS p
WHERE
p.precio <=10
ORDER BY p.precio
;

-- Hacer quiero que un cliente con sus compras se actualice sumandole un 10%

