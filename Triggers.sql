

DELIMITER $$

CREATE TRIGGER AlertaBajaExistencia
AFTER UPDATE ON Producto
FOR EACH ROW
BEGIN
    IF NEW.Existencia < 10 AND OLD.Existencia >= 10 THEN
        INSERT INTO AuditoriaProducto (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Alerta Baja Existencia', 'Existencia', OLD.Existencia, NEW.Existencia, @id_empleado_sesion);
    END IF;
END$$

CREATE TRIGGER VerificarVentaProducto
BEFORE INSERT ON DetalleVenta
FOR EACH ROW
BEGIN
    DECLARE existencia INT;
    SELECT Existencia INTO existencia FROM Producto WHERE idProducto = NEW.idProducto;
    IF existencia < NEW.Cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay suficiente stock del producto para completar la venta.';
    END IF;
END$$

CREATE TRIGGER ProductoUpdateAuditoria
AFTER UPDATE ON Producto
FOR EACH ROW
BEGIN
    IF NOT (NEW.Nombre <=> OLD.Nombre) THEN
        INSERT INTO AuditoriaProducto (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion Nombre', 'Nombre', OLD.Nombre, NEW.Nombre, @id_empleado_sesion);
    END IF;
    IF NOT (NEW.CodigoBarra <=> OLD.CodigoBarra) THEN
        INSERT INTO AuditoriaProducto (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion CodigoBarra', 'CodigoBarra', OLD.CodigoBarra, NEW.CodigoBarra, @id_empleado_sesion);
    END IF;
    IF NOT (NEW.Existencia <=> OLD.Existencia) THEN
        INSERT INTO AuditoriaProducto (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion Existencia', 'Existencia', OLD.Existencia, NEW.Existencia, @id_empleado_sesion);
    END IF;
    IF NOT (NEW.PrecioCompra <=> OLD.PrecioCompra) THEN
        INSERT INTO AuditoriaProducto (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion PrecioCompra', 'PrecioCompra', OLD.PrecioCompra, NEW.PrecioCompra, @id_empleado_sesion);
    END IF;
    IF NOT (NEW.PrecioVenta <=> OLD.PrecioVenta) THEN
        INSERT INTO AuditoriaProducto (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion PrecioVenta', 'PrecioVenta', OLD.PrecioVenta, NEW.PrecioVenta, @id_empleado_sesion);
    END IF;
    IF NOT (NEW.idCategoria <=> OLD.idCategoria) THEN
        INSERT INTO AuditoriaProducto (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion Categoria', 'idCategoria', OLD.idCategoria, NEW.idCategoria, @id_empleado_sesion);
    END IF;
END$$

CREATE TRIGGER ProductoInsertAuditoria
AFTER INSERT ON Producto
FOR EACH ROW
BEGIN
    INSERT INTO AuditoriaProducto (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
    VALUES ('Creacion', 'Nombre', NULL, NEW.Nombre, @id_empleado_sesion);
END$$

CREATE TRIGGER PersonaUpdateAuditoria
AFTER UPDATE ON Persona
FOR EACH ROW
BEGIN
    IF NOT (NEW.Nombre <=> OLD.Nombre) THEN
        INSERT INTO AuditoriaPersona (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion Nombre', 'Nombre', OLD.Nombre, NEW.Nombre, @id_empleado_sesion);
    END IF;
    IF NOT (NEW.ApellidoPaterno <=> OLD.ApellidoPaterno) THEN
        INSERT INTO AuditoriaPersona (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion ApellidoPaterno', 'ApellidoPaterno', OLD.ApellidoPaterno, NEW.ApellidoPaterno, @id_empleado_sesion);
    END IF;
    IF NOT (NEW.ApellidoMaterno <=> OLD.ApellidoMaterno) THEN
        INSERT INTO AuditoriaPersona (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion ApellidoMaterno', 'ApellidoMaterno', OLD.ApellidoMaterno, NEW.ApellidoMaterno, @id_empleado_sesion);
    END IF;
    IF NOT (NEW.Telefono <=> OLD.Telefono) THEN
        INSERT INTO AuditoriaPersona (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion Telefono', 'Telefono', OLD.Telefono, NEW.Telefono, @id_empleado_sesion);
    END IF;
    IF NOT (NEW.Email <=> OLD.Email) THEN
        INSERT INTO AuditoriaPersona (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion Email', 'Email', OLD.Email, NEW.Email, @id_empleado_sesion);
    END IF;
    IF NOT (NEW.Edad <=> OLD.Edad) THEN
        INSERT INTO AuditoriaPersona (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion Edad', 'Edad', OLD.Edad, NEW.Edad, @id_empleado_sesion);
    END IF;
    IF NOT (NEW.Sexo <=> OLD.Sexo) THEN
        INSERT INTO AuditoriaPersona (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion Sexo', 'Sexo', OLD.Sexo, NEW.Sexo, @id_empleado_sesion);
    END IF;
    IF NOT (NEW.Estatus <=> OLD.Estatus) THEN
        INSERT INTO AuditoriaPersona (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Modificacion Estatus', 'Estatus', OLD.Estatus, NEW.Estatus, @id_empleado_sesion);
    END IF;
END$$

CREATE TRIGGER PersonaInsertAuditoria
AFTER INSERT ON Persona
FOR EACH ROW
BEGIN
    INSERT INTO AuditoriaPersona (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
    VALUES ('Creacion', 'Nombre', NULL, NEW.Nombre, @id_empleado_sesion);
END$$

CREATE TRIGGER VentaCantidadBefore
BEFORE INSERT ON DetalleVenta
FOR EACH ROW
BEGIN
    DECLARE stockDisponible INT;
    SELECT Existencia INTO stockDisponible FROM Producto WHERE idProducto = NEW.idProducto;
    IF NEW.Cantidad > stockDisponible THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede vender más de lo disponible en stock.';
    END IF;
END$$

CREATE TRIGGER ProcesarVentaAlEnviar
AFTER UPDATE ON Pedido
FOR EACH ROW
BEGIN
    IF NEW.Estatus = 'Atendido' AND OLD.Estatus <> 'Atendido' THEN
        CALL ProcesarVentaDePedido(NEW.idPedido);
    END IF;
END$$

CREATE TRIGGER AuditoriaLogin
AFTER INSERT ON Persona
FOR EACH ROW
BEGIN
    -- Ejemplo: registrar creación de login en auditoría
    INSERT INTO AuditoriaPersona (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
    VALUES ('LoginCreado', 'Usuario', NULL, NEW.Usuario, NEW.idPersona);
END$$

CREATE TRIGGER ActualizarFinanzasEnVentas
AFTER INSERT ON Venta
FOR EACH ROW
BEGIN
    INSERT INTO Finanzas (idVenta, TotalVenta, TotalInvertido)
    VALUES (NEW.idVenta, NEW.MontoTotal, 
        (SELECT SUM(PrecioCompra * Cantidad) 
         FROM DetalleVenta 
         WHERE idVenta = NEW.idVenta));
END$$

DELIMITER ;
