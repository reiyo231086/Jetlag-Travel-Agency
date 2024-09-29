use jetlag_travel_agency;

-- VISTAS
-- vista de clientes que hicieron una reserva y no pagaron nada
CREATE VIEW vista_clientes_sin_pagos AS
SELECT 
    c.id_cliente,
    c.nombre,
    c.apellido,
    r.id_reserva,
    r.monto_total,
    r.monto_abonado,
    r.estado
FROM 
    cliente c
JOIN 
    reserva r ON c.id_cliente = r.id_cliente
WHERE 
    r.monto_abonado < 1 ;

-- clientes que hcieron reserva, pagaron una seña y no pagaron el total 
CREATE VIEW vista_clientes_con_seña AS
SELECT 
    c.id_cliente,
    c.nombre,
    c.apellido,
    r.id_reserva,
    r.monto_total,
    r.monto_abonado
FROM 
    cliente c
JOIN 
    reserva r ON c.id_cliente = r.id_cliente
WHERE 
    r.monto_abonado > 0 AND 
    r.monto_abonado < r.monto_total AND 
    r.estado = 'Seña Pagada';  
    
    -- vista con los porvedores que mas le compramos
    
CREATE VIEW proveedores_mas_comprados AS
SELECT p.id_proveedor, p.nombre, COUNT(c.id_compra) AS total_compras
FROM compra c
JOIN proveedor p ON c.id_proveedor = p.id_proveedor
GROUP BY p.id_proveedor, p.nombre
ORDER BY total_compras DESC;
    
    
    
    -- FUNCIONES 
    
    -- funcion para ver las ventas totales del vendedor
DELIMITER //

 
CREATE FUNCTION ventas_totales_vendedor(vendedor_legajo INT) 
RETURNS DECIMAL(10, 2) 
DETERMINISTIC
BEGIN
    DECLARE total_ventas DECIMAL(10, 2); 
    
    SELECT SUM(monto_pago) INTO total_ventas
    FROM venta
    WHERE nro_legajo = vendedor_legajo; 
    
    RETURN IFNULL(total_ventas, 0); -- Retorna 0 si no hay ventas
END //

DELIMITER ;ventas_totales_vendedor

SELECT ventas_totales_vendedor(4);  

-- en base a eso le voy a pagar la comision 

DELIMITER //

CREATE FUNCTION calcular_comision_por_empleado(vendedor_legajo INT, mes INT, anio INT) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_comision DECIMAL(10, 2);

    SELECT IFNULL(SUM(monto_pago) * 0.10, 0) INTO total_comision  
    FROM venta
    WHERE nro_legajo = vendedor_legajo 
      AND MONTH(fecha_pago) = mes 
      AND YEAR(fecha_pago) = anio;

    RETURN total_comision;
END //

DELIMITER ;

-- llamo a la funcion 

SELECT v.nro_legajo, 
       v.nombre, 
       v.apellido, 
       calcular_comision_por_empleado(v.nro_legajo, 9, 2024) AS comision
FROM vendedor v;

-- PROCEDIMIENTO 
-- 1 quiero que si tengo una reserva en estado cancelado se pueda reactivar y si cambia el monto poder cambairlo 

DELIMITER //

CREATE PROCEDURE reactivar_y_actualizar_reserva(
    IN p_id_reserva INT,
    IN p_nueva_fecha DATETIME,
    IN p_nuevo_estado VARCHAR(50),
    IN p_nuevo_monto_total DECIMAL(10,2),
    IN p_nuevo_monto_abonado DECIMAL(10,2)
)
BEGIN
    -- Actualizar la tabla reserva
    UPDATE reserva
    SET 
        fecha_reserva = p_nueva_fecha, 
        estado = p_nuevo_estado,
        monto_total = p_nuevo_monto_total,  -- Asegúrate de que esta columna exista
        monto_abonado = p_nuevo_monto_abonado  -- Asegúrate de que esta columna exista
    WHERE id_reserva = p_id_reserva AND estado = 'Cancelado';

    -- Actualizo la tabla venta
    UPDATE venta
    SET monto_pago = p_nuevo_monto_total
    WHERE id_reserva = p_id_reserva;
END //

DELIMITER ;

-- Procedimiento que actulice el monto abonado por el cliente 
DROP PROCEDURE IF EXISTS actualizar_monto_abonado;

DELIMITER $$

CREATE PROCEDURE actualizar_monto_abonado(
    IN p_id_reserva INT,
    IN p_monto_abonado DECIMAL(10,2)
)
BEGIN
    -- Actualizar el monto abonado de la reserva, asegurando que no supere el monto total
    UPDATE reserva
    SET monto_abonado = LEAST(monto_abonado + p_monto_abonado, monto_total)
    WHERE id_reserva = p_id_reserva;
END $$

DELIMITER ;


-- procedimiento para cambiar el estado de mi reserva 
DELIMITER $$

CREATE PROCEDURE cambiar_estado_reserva(
    IN p_id_reserva INT,
    IN p_nuevo_estado VARCHAR(50)
)
BEGIN
    -- Actualizar el estado de la reserva
    UPDATE reserva
    SET estado = p_nuevo_estado
    WHERE id_reserva = p_id_reserva;
END $$

DELIMITER ;

-- triggers
-- quiero que cuando una reserva pase a estado total pagado automaticamete cuenta en la tabla venta 
DELIMITER $$

CREATE TRIGGER after_update_reserva
AFTER UPDATE ON reserva
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Total Pagado' AND OLD.estado <> 'Total Pagado' THEN
        INSERT INTO venta (id_reserva, monto_pago, fecha_pago, tipo_venta)
        VALUES (NEW.id_reserva, NEW.monto_total, NOW(), 'Pago Completo');
    END IF;
END $$

DELIMITER ;


SHOW TRIGGERS;