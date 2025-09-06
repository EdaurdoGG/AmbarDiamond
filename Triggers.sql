DELIMITER $$

-- TRIGGER: Auditoría y alerta baja existencia de Producto
CREATE TRIGGER ProductoAfterUpdate
AFTER UPDATE ON Producto
FOR EACH ROW
BEGIN
    DECLARE v_idEmpleado INT DEFAULT @id_empleado_sesion;

    -- Auditoría por cambios en columnas importantes
    IF NOT (NEW.Nombre <=> OLD.Nombre) THEN
        INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion', 'Nombre', OLD.Nombre, NEW.Nombre, v_idEmpleado);
    END IF;
    IF NOT (NEW.CodigoBarra <=> OLD.CodigoBarra) THEN
        INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion', 'CodigoBarra', OLD.CodigoBarra, NEW.CodigoBarra, v_idEmpleado);
    END IF;
    IF NOT (NEW.Existencia <=> OLD.Existencia) THEN
        INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion', 'Existencia', OLD.Existencia, NEW.Existencia, v_idEmpleado);

        -- Alerta de baja existencia (<10)
        IF NEW.Existencia < 10 AND OLD.Existencia >= 10 THEN
            INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
            VALUES ('Alerta Baja Existencia', 'Existencia', OLD.Existencia, NEW.Existencia, v_idEmpleado);
        END IF;
    END IF;
    IF NOT (NEW.PrecioCompra <=> OLD.PrecioCompra) THEN
        INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion', 'PrecioCompra', OLD.PrecioCompra, NEW.PrecioCompra, v_idEmpleado);
    END IF;
    IF NOT (NEW.PrecioVenta <=> OLD.PrecioVenta) THEN
        INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion', 'PrecioVenta', OLD.PrecioVenta, NEW.PrecioVenta, v_idEmpleado);
    END IF;
    IF NOT (NEW.idCategoria <=> OLD.idCategoria) THEN
        INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion', 'idCategoria', OLD.idCategoria, NEW.idCategoria, v_idEmpleado);
    END IF;
END $$

-- TRIGGER: Auditoría al insertar un Producto
CREATE TRIGGER ProductoAfterInsert
AFTER INSERT ON Producto
FOR EACH ROW
BEGIN
    INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
    VALUES ('Creacion', 'Nombre', NULL, NEW.Nombre, @id_empleado_sesion);
END $$

-- TRIGGER: Auditoría al actualizar Persona
CREATE TRIGGER PersonaAfterUpdate
AFTER UPDATE ON Persona
FOR EACH ROW
BEGIN
    DECLARE v_idEmpleado INT DEFAULT @id_empleado_sesion;

    IF NOT (NEW.Nombre <=> OLD.Nombre) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion', 'Nombre', OLD.Nombre, NEW.Nombre, v_idEmpleado);
    END IF;
    IF NOT (NEW.ApellidoPaterno <=> OLD.ApellidoPaterno) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion', 'ApellidoPaterno', OLD.ApellidoPaterno, NEW.ApellidoPaterno, v_idEmpleado);
    END IF;
    IF NOT (NEW.ApellidoMaterno <=> OLD.ApellidoMaterno) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion', 'ApellidoMaterno', OLD.ApellidoMaterno, NEW.ApellidoMaterno, v_idEmpleado);
    END IF;
    IF NOT (NEW.Telefono <=> OLD.Telefono) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion', 'Telefono', OLD.Telefono, NEW.Telefono, v_idEmpleado);
    END IF;
    IF NOT (NEW.Email <=> OLD.Email) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion', 'Email', OLD.Email, NEW.Email, v_idEmpleado);
    END IF;
    IF NOT (NEW.Edad <=> OLD.Edad) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion', 'Edad', OLD.Edad, NEW.Edad, v_idEmpleado);
    END IF;
    IF NOT (NEW.Sexo <=> OLD.Sexo) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion', 'Sexo', OLD.Sexo, NEW.Sexo, v_idEmpleado);
    END IF;
    IF NOT (NEW.Estatus <=> OLD.Estatus) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion', 'Estatus', OLD.Estatus, NEW.Estatus, v_idEmpleado);
    END IF;
END $$

-- TRIGGER: Auditoría al insertar Persona
CREATE TRIGGER PersonaAfterInsert
AFTER INSERT ON Persona
FOR EACH ROW
BEGIN
    INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
    VALUES ('Creacion', 'Nombre', NULL, NEW.Nombre, @id_empleado_sesion);
END $$

-- TRIGGER: Control de stock antes de insertar DetalleVenta
CREATE TRIGGER DetalleVentaBeforeInsert
BEFORE INSERT ON DetalleVenta
FOR EACH ROW
BEGIN
    DECLARE stockDisponible INT;
    SELECT Existencia INTO stockDisponible FROM Producto WHERE idProducto = NEW.idProducto;
    IF NEW.Cantidad > stockDisponible THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede vender más de lo disponible en stock.';
    END IF;
END $$

-- TRIGGER: Procesar venta automáticamente al atender pedido
CREATE TRIGGER PedidoAfterUpdate
AFTER UPDATE ON Pedido
FOR EACH ROW
BEGIN
    IF NEW.Estatus = 'Atendido' AND OLD.Estatus <> 'Atendido' THEN
        CALL ProcesarVentaPedido(NEW.idPedido);
    END IF;
END $$

-- TRIGGER: Actualizar Finanzas automáticamente tras venta
CREATE TRIGGER VentaAfterInsert
AFTER INSERT ON Venta
FOR EACH ROW
BEGIN
    INSERT INTO Finanzas (idVenta, TotalVenta, TotalInvertido)
    VALUES (NEW.idVenta, NEW.MontoTotal, 
        (SELECT IFNULL(SUM(PrecioUnitario * Cantidad),0) 
         FROM DetalleVenta 
         WHERE idVenta = NEW.idVenta));
END $$

-- Auditoría al crear una devolución
CREATE TRIGGER DevolucionAfterInsert
AFTER INSERT ON Devolucion
FOR EACH ROW
BEGIN
    -- Registrar en la auditoría que se creó una devolución
    INSERT INTO AuditoriaDevolucion(Movimiento,ColumnaAfectada,DatoAnterior,DatoNuevo,idPersona)
    VALUES ('Creacion Devolucion','Motivo',NULL,NEW.Motivo,@id_empleado_sesion );
END $$

DELIMITER ;
