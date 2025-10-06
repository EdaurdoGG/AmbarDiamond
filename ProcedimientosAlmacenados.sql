DELIMITER $$

-- 1. Agregar Persona
CREATE PROCEDURE AgregarPersona(
    IN p_Nombre VARCHAR(100),
    IN p_ApellidoPaterno VARCHAR(100),
    IN p_ApellidoMaterno VARCHAR(100),
    IN p_Telefono VARCHAR(15),
    IN p_Email VARCHAR(150),
    IN p_Edad INT,
    IN p_Sexo VARCHAR(10),
    IN p_Usuario VARCHAR(50),
    IN p_Contrasena VARCHAR(255)
)
BEGIN
    INSERT INTO Persona (Nombre, ApellidoPaterno, ApellidoMaterno, Telefono, Email, Edad, Sexo, Estatus, Usuario, Contrasena, idRol)
    VALUES (p_Nombre, p_ApellidoPaterno, p_ApellidoMaterno, p_Telefono, p_Email, p_Edad, p_Sexo, 'Activo', p_Usuario, p_Contrasena, 3);
END $$

-- 2. Actualizar Persona
CREATE PROCEDURE ActualizarPersonaCompleto(
    IN p_idPersona INT,
    IN p_Nombre VARCHAR(100),
    IN p_ApellidoPaterno VARCHAR(100),
    IN p_ApellidoMaterno VARCHAR(100),
    IN p_Telefono VARCHAR(15),
    IN p_Email VARCHAR(150),
    IN p_Edad INT,
    IN p_Sexo VARCHAR(10),
    IN p_Estatus VARCHAR(10),
    IN p_Usuario VARCHAR(50),
    IN p_Contrasena VARCHAR(255),
    IN p_idRol INT
)
BEGIN
    UPDATE Persona
    SET Nombre = p_Nombre,
        ApellidoPaterno = p_ApellidoPaterno,
        ApellidoMaterno = p_ApellidoMaterno,
        Telefono = p_Telefono,
        Email = p_Email,
        Edad = p_Edad,
        Sexo = p_Sexo,
        Estatus = p_Estatus,
        Usuario = p_Usuario,
        Contrasena = p_Contrasena,
        idRol = p_idRol
    WHERE idPersona = p_idPersona;
END $$

-- 3. Eliminar Persona
CREATE PROCEDURE EliminarPersona(IN p_idPersona INT)
BEGIN
    UPDATE Persona SET Estatus = 'Inactivo' WHERE idPersona = p_idPersona;
END $$

-- 4. Recuperar Persona
CREATE PROCEDURE RecuperarPersona(IN p_idPersona INT)
BEGIN
    UPDATE Persona SET Estatus = 'Activo' WHERE idPersona = p_idPersona;
END $$

-- 5. Cambiar Contraseña
CREATE PROCEDURE CambiarContrasena(IN p_idPersona INT, IN p_NuevaContrasena VARCHAR(255))
BEGIN
    UPDATE Persona SET Contrasena = p_NuevaContrasena WHERE idPersona = p_idPersona;
END $$

-- 6. Agregar Producto
CREATE PROCEDURE AgregarProducto(
    IN p_Nombre VARCHAR(150),
    IN p_PrecioCompra DECIMAL(10,2),
    IN p_PrecioVenta DECIMAL(10,2),
    IN p_CodigoBarra VARCHAR(100),
    IN p_Existencia INT,
    IN p_idCategoria INT,
    IN p_Imagen VARCHAR(255)
)
BEGIN
    INSERT INTO Producto (Nombre, PrecioCompra, PrecioVenta, CodigoBarra, Existencia, idCategoria, Imagen)
    VALUES (p_Nombre, p_PrecioCompra, p_PrecioVenta, p_CodigoBarra, p_Existencia, p_idCategoria, p_Imagen);
END $$

-- 7. Actualizar Producto
CREATE PROCEDURE ActualizarProductoCompleto(
    IN p_idProducto INT,
    IN p_Nombre VARCHAR(150),
    IN p_PrecioCompra DECIMAL(10,2),
    IN p_PrecioVenta DECIMAL(10,2),
    IN p_CodigoBarra VARCHAR(100),
    IN p_Existencia INT,
    IN p_idCategoria INT,
    IN p_Imagen VARCHAR(255)
)
BEGIN
    UPDATE Producto
    SET Nombre = p_Nombre,
        PrecioCompra = p_PrecioCompra,
        PrecioVenta = p_PrecioVenta,
        CodigoBarra = p_CodigoBarra,
        Existencia = p_Existencia,
        idCategoria = p_idCategoria,
        Imagen = p_Imagen
    WHERE idProducto = p_idProducto;
END $$

-- 8. Eliminar Producto
CREATE PROCEDURE EliminarProducto(IN p_idProducto INT)
BEGIN
    DELETE FROM Producto WHERE idProducto = p_idProducto;
END $$

-- 9. Buscar Producto por Código
CREATE PROCEDURE BuscarProductoPorCodigoBarra(IN p_CodigoBarra VARCHAR(100))
BEGIN
    SELECT * FROM Producto WHERE CodigoBarra = p_CodigoBarra;
END $$

-- 10. Buscar Producto por Nombre
CREATE PROCEDURE BuscarProductoPorNombre(IN p_Nombre VARCHAR(150))
BEGIN
    SELECT * FROM Producto WHERE Nombre LIKE CONCAT('%', p_Nombre, '%');
END $$

-- 11. Agregar al Carrito
CREATE PROCEDURE AgregarAlCarrito(IN p_idPersona INT, IN p_idProducto INT)
BEGIN
    DECLARE v_idCarrito INT;
    DECLARE v_Precio DECIMAL(10,2);
    DECLARE v_idDetalleCarrito INT;
    DECLARE v_CantidadActual INT;

    SELECT idCarrito INTO v_idCarrito FROM Carrito WHERE idPersona = p_idPersona LIMIT 1;
    IF v_idCarrito IS NULL THEN
        INSERT INTO Carrito (idPersona) VALUES (p_idPersona);
        SET v_idCarrito = LAST_INSERT_ID();
    END IF;

    SELECT PrecioVenta INTO v_Precio FROM Producto WHERE idProducto = p_idProducto;

    SELECT idDetalleCarrito, Cantidad INTO v_idDetalleCarrito, v_CantidadActual
    FROM DetalleCarrito WHERE idCarrito = v_idCarrito AND idProducto = p_idProducto LIMIT 1;

    IF v_idDetalleCarrito IS NOT NULL THEN
        UPDATE DetalleCarrito
        SET Cantidad = v_CantidadActual + 1,
            Total = v_Precio * (v_CantidadActual + 1)
        WHERE idDetalleCarrito = v_idDetalleCarrito;
    ELSE
        INSERT INTO DetalleCarrito (idCarrito, idProducto, Cantidad, PrecioUnitario, Total)
        VALUES (v_idCarrito, p_idProducto, 1, v_Precio, v_Precio);
    END IF;
END $$

-- 12. Restar cantidad en carrito
CREATE PROCEDURE RestarCantidadCarrito(IN p_idDetalleCarrito INT, IN p_Cantidad INT)
BEGIN
    DECLARE v_CantidadActual INT;
    SELECT Cantidad INTO v_CantidadActual FROM DetalleCarrito WHERE idDetalleCarrito = p_idDetalleCarrito;

    IF v_CantidadActual > p_Cantidad THEN
        UPDATE DetalleCarrito
        SET Cantidad = Cantidad - p_Cantidad,
            Total = PrecioUnitario * (Cantidad - p_Cantidad)
        WHERE idDetalleCarrito = p_idDetalleCarrito;
    ELSE
        DELETE FROM DetalleCarrito WHERE idDetalleCarrito = p_idDetalleCarrito;
    END IF;
END $$

-- 13. Sumar cantidad en carrito
CREATE PROCEDURE SumarCantidadCarrito(IN p_idDetalleCarrito INT, IN p_Cantidad INT)
BEGIN
    DECLARE v_Existencia INT;
    DECLARE v_CantidadActual INT;

    SELECT p.Existencia, dc.Cantidad INTO v_Existencia, v_CantidadActual
    FROM DetalleCarrito dc JOIN Producto p ON dc.idProducto = p.idProducto
    WHERE dc.idDetalleCarrito = p_idDetalleCarrito;

    IF v_CantidadActual + p_Cantidad <= v_Existencia THEN
        UPDATE DetalleCarrito
        SET Cantidad = Cantidad + p_Cantidad,
            Total = PrecioUnitario * (Cantidad + p_Cantidad)
        WHERE idDetalleCarrito = p_idDetalleCarrito;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock disponible.';
    END IF;
END $$

-- 14. Obtener carrito por persona
CREATE PROCEDURE ObtenerCarritoPorPersona(IN p_idPersona INT)
BEGIN
    SELECT c.idCarrito, dc.idDetalleCarrito, p.Nombre AS Producto,
           dc.Cantidad, dc.PrecioUnitario, dc.Total
    FROM Carrito c
    JOIN DetalleCarrito dc ON c.idCarrito = dc.idCarrito
    JOIN Producto p ON dc.idProducto = p.idProducto
    WHERE c.idPersona = p_idPersona;
END $$

-- 15. Registrar pedido
CREATE PROCEDURE RegistrarPedido(IN p_idPersona INT)
BEGIN
    DECLARE v_idCarrito INT;
    DECLARE v_idPedido INT;

    SELECT idCarrito INTO v_idCarrito FROM Carrito WHERE idPersona = p_idPersona LIMIT 1;

    INSERT INTO Pedido (idPersona, Estatus) VALUES (p_idPersona, 'Pendiente');
    SET v_idPedido = LAST_INSERT_ID();

    INSERT INTO DetallePedido (idPedido, idProducto, Cantidad, PrecioUnitario, Total)
    SELECT v_idPedido, idProducto, Cantidad, PrecioUnitario, Total
    FROM DetalleCarrito
    WHERE idCarrito = v_idCarrito;

    DELETE FROM DetalleCarrito WHERE idCarrito = v_idCarrito;
END $$

-- 16. Cambiar pedido a cancelado
CREATE PROCEDURE CambiarPedidoACancelado(IN p_idPedido INT)
BEGIN
    UPDATE Pedido SET Estatus = 'Cancelado' WHERE idPedido = p_idPedido;
END $$

-- 17. Procesar venta normal
CREATE PROCEDURE ProcesarVentaNormal(IN p_idPersona INT, IN p_TipoPago VARCHAR(10))
BEGIN
    DECLARE v_idCarrito INT;
    DECLARE v_Subtotal DECIMAL(10,2);
    DECLARE v_IVA DECIMAL(10,2);
    DECLARE v_Total DECIMAL(10,2);

    SELECT idCarrito INTO v_idCarrito FROM Carrito WHERE idPersona = p_idPersona LIMIT 1;

    SELECT SUM(Total), SUM(Total * 0.16) INTO v_Subtotal, v_IVA FROM DetalleCarrito WHERE idCarrito = v_idCarrito;
    SET v_Total = v_Subtotal + v_IVA;

    INSERT INTO Venta (Subtotal, IVA, MontoTotal, TipoPago, Estatus, idPersona)
    VALUES (v_Subtotal, v_IVA, v_Total, p_TipoPago, 'Activa', p_idPersona);

    INSERT INTO DetalleVenta (idVenta, idProducto, Cantidad, PrecioUnitario, IVA, Total)
    SELECT LAST_INSERT_ID(), idProducto, Cantidad, PrecioUnitario, Total * 0.16, Total
    FROM DetalleCarrito WHERE idCarrito = v_idCarrito;

    UPDATE Producto p JOIN DetalleCarrito dc ON p.idProducto = dc.idProducto
    SET p.Existencia = p.Existencia - dc.Cantidad
    WHERE dc.idCarrito = v_idCarrito;

    DELETE FROM DetalleCarrito WHERE idCarrito = v_idCarrito;
END $$

-- 18. Devolver producto individual
CREATE PROCEDURE DevolverProductoIndividual(
    IN p_idVenta INT, IN p_idDetalleVenta INT, IN p_CantidadDevuelta INT,
    IN p_Motivo VARCHAR(200), IN p_idPersona INT
)
BEGIN
    DECLARE v_CantidadActual INT;
    DECLARE v_PrecioUnitario DECIMAL(10,2);

    SELECT Cantidad, PrecioUnitario INTO v_CantidadActual, v_PrecioUnitario
    FROM DetalleVenta
    WHERE idDetalleVenta = p_idDetalleVenta AND idVenta = p_idVenta;

    IF p_CantidadDevuelta > v_CantidadActual THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cantidad a devolver excede la cantidad vendida.';
    END IF;

    INSERT INTO Devolucion (Motivo, idPersona) VALUES (p_Motivo, p_idPersona);

    INSERT INTO DetalleDevolucion (idDevolucion, idVenta, idDetalleVenta, CantidadDevuelta, TotalDevuelto)
    VALUES (LAST_INSERT_ID(), p_idVenta, p_idDetalleVenta, p_CantidadDevuelta, v_PrecioUnitario * p_CantidadDevuelta);

    UPDATE Producto p JOIN DetalleVenta dv ON p.idProducto = dv.idProducto
    SET p.Existencia = p.Existencia + p_CantidadDevuelta
    WHERE dv.idDetalleVenta = p_idDetalleVenta;

    IF v_CantidadActual - p_CantidadDevuelta > 0 THEN
        UPDATE DetalleVenta
        SET Cantidad = Cantidad - p_CantidadDevuelta,
            Total = (Cantidad - p_CantidadDevuelta) * PrecioUnitario,
            IVA = ((Cantidad - p_CantidadDevuelta) * PrecioUnitario) * 0.16
        WHERE idDetalleVenta = p_idDetalleVenta;
    ELSE
        DELETE FROM DetalleVenta WHERE idDetalleVenta = p_idDetalleVenta;
    END IF;

    UPDATE Venta v JOIN (SELECT idVenta, IFNULL(SUM(Total),0) AS Subtotal, IFNULL(SUM(Total*0.16),0) AS IVA
                         FROM DetalleVenta WHERE idVenta = p_idVenta GROUP BY idVenta) dv_totales
    ON v.idVenta = dv_totales.idVenta
    SET v.Subtotal = dv_totales.Subtotal,
        v.IVA = dv_totales.IVA,
        v.MontoTotal = dv_totales.Subtotal + dv_totales.IVA
    WHERE v.idVenta = p_idVenta;

    INSERT INTO AuditoriaProducto (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
    VALUES ('Devolucion', 'Existencia', v_CantidadActual, v_CantidadActual - p_CantidadDevuelta, p_idPersona);
END $$

-- 19. Devolver venta completa
CREATE PROCEDURE DevolverVentaCompleta(
    IN p_idVenta INT, IN p_Motivo VARCHAR(200), IN p_idPersona INT
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_idDetalleVenta INT;
    DECLARE v_idProducto INT;
    DECLARE v_Cantidad INT;
    DECLARE v_PrecioUnitario DECIMAL(10,2);
    DECLARE v_idDevolucion INT;

    DECLARE cur CURSOR FOR
        SELECT idDetalleVenta, idProducto, Cantidad, PrecioUnitario
        FROM DetalleVenta
        WHERE idVenta = p_idVenta;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    INSERT INTO Devolucion (Motivo, idPersona) VALUES (p_Motivo, p_idPersona);
    SET v_idDevolucion = LAST_INSERT_ID();

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_idDetalleVenta, v_idProducto, v_Cantidad, v_PrecioUnitario;
        IF done THEN LEAVE read_loop; END IF;

        INSERT INTO DetalleDevolucion (idDevolucion, idVenta, idDetalleVenta, CantidadDevuelta, TotalDevuelto)
        VALUES (v_idDevolucion, p_idVenta, v_idDetalleVenta, v_Cantidad, v_Cantidad * v_PrecioUnitario);

        UPDATE Producto SET Existencia = Existencia + v_Cantidad WHERE idProducto = v_idProducto;
        DELETE FROM DetalleVenta WHERE idDetalleVenta = v_idDetalleVenta;

        INSERT INTO AuditoriaProducto (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Devolucion Completa', 'Existencia', v_Cantidad, 0, p_idPersona);
    END LOOP;
    CLOSE cur;

    UPDATE Venta SET Subtotal = 0, IVA = 0, MontoTotal = 0, Estatus = 'Devuelta' WHERE idVenta = p_idVenta;
END $$

-- 20. Registrar Sugerencia/Queja
CREATE PROCEDURE RegistrarSugerenciaQueja(IN p_idPersona INT, IN p_Tipo VARCHAR(20), IN p_Descripcion VARCHAR(255))
BEGIN
    INSERT INTO SugerenciaQueja (idPersona, Tipo, Descripcion, Fecha)
    VALUES (p_idPersona, p_Tipo, p_Descripcion, NOW());
END $$

-- 21. Procesar venta de pedido
CREATE PROCEDURE ProcesarVentaPedido(IN p_idPedido INT, IN p_TipoPago VARCHAR(10))
BEGIN
    DECLARE v_idPersona INT;
    DECLARE v_Subtotal DECIMAL(10,2);
    DECLARE v_IVA DECIMAL(10,2);
    DECLARE v_Total DECIMAL(10,2);
    DECLARE v_idVenta INT;

    SELECT idPersona INTO v_idPersona FROM Pedido WHERE idPedido = p_idPedido;

    SELECT SUM(Total), SUM(Total*0.16) INTO v_Subtotal, v_IVA
    FROM DetallePedido WHERE idPedido = p_idPedido;

    SET v_Total = v_Subtotal + v_IVA;

    INSERT INTO Venta (Subtotal, IVA, MontoTotal, TipoPago, Estatus, idPersona)
    VALUES (v_Subtotal, v_IVA, v_Total, p_TipoPago, 'Activa', v_idPersona);

    SET v_idVenta = LAST_INSERT_ID();

    INSERT INTO DetalleVenta (idVenta, idProducto, Cantidad, PrecioUnitario, IVA, Total)
    SELECT v_idVenta, idProducto, Cantidad, PrecioUnitario, Total*0.16, Total
    FROM DetallePedido WHERE idPedido = p_idPedido;

    UPDATE Pedido SET Estatus = 'Atendido' WHERE idPedido = p_idPedido;

    UPDATE Producto p JOIN DetallePedido dp ON p.idProducto = dp.idProducto
    SET p.Existencia = p.Existencia - dp.Cantidad
    WHERE dp.idPedido = p_idPedido;
END $$

DELIMITER ;