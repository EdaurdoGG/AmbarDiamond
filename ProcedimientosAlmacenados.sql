/* ==========================================================
   PERSONAS
   ========================================================== */
DELIMITER $$
CREATE OR REPLACE PROCEDURE AgregarPersona(
    IN p_Nombre VARCHAR(100),
    IN p_ApellidoPaterno VARCHAR(100),
    IN p_ApellidoMaterno VARCHAR(100),
    IN p_Telefono VARCHAR(15),
    IN p_Email VARCHAR(150),
    IN p_Edad INT,
    IN p_Sexo ENUM('M','F','Otro'),
    IN p_Usuario VARCHAR(50),
    IN p_Contrasena VARCHAR(255),
    IN p_idRol INT
)
BEGIN
    INSERT INTO Persona (Nombre, ApellidoPaterno, ApellidoMaterno, Telefono, Email, Edad, Sexo, Usuario, Contrasena, idRol)
    VALUES (p_Nombre, p_ApellidoPaterno, p_ApellidoMaterno, p_Telefono, p_Email, p_Edad, p_Sexo, p_Usuario, p_Contrasena, p_idRol);
END $$
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE ActualizarPersonaCompleto(
    IN p_idPersona INT,
    IN p_Nombre VARCHAR(100),
    IN p_ApellidoPaterno VARCHAR(100),
    IN p_ApellidoMaterno VARCHAR(100),
    IN p_Telefono VARCHAR(15),
    IN p_Email VARCHAR(150),
    IN p_Edad INT,
    IN p_Sexo ENUM('M','F','Otro'),
    IN p_Estatus ENUM('Activo','Inactivo'),
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
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE EliminarPersona(IN p_idPersona INT)
BEGIN
    UPDATE Persona SET Estatus = 'Inactivo' WHERE idPersona = p_idPersona;
END $$
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE RecuperarPersona(IN p_idPersona INT)
BEGIN
    UPDATE Persona SET Estatus = 'Activo' WHERE idPersona = p_idPersona;
END $$
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE CambiarContraseña(
    IN p_idPersona INT,
    IN p_NuevaContrasena VARCHAR(255)
)
BEGIN
    UPDATE Persona
    SET Contrasena = p_NuevaContrasena
    WHERE idPersona = p_idPersona;
END $$
DELIMITER ;

/* ==========================================================
   PRODUCTOS
   ========================================================== */
DELIMITER $$
CREATE OR REPLACE PROCEDURE AgregarProducto(
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
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE ActualizarProductoCompleto(
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
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE EliminarProducto(IN p_idProducto INT)
BEGIN
    DELETE FROM Producto WHERE idProducto = p_idProducto;
END $$
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE RecuperarProducto(IN p_idProducto INT)
BEGIN
    UPDATE Producto SET Existencia = 1 WHERE idProducto = p_idProducto AND Existencia = 0;
END $$
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE BuscarProductoPorCodigoBarra(IN p_CodigoBarra VARCHAR(100))
BEGIN
    SELECT * FROM Producto WHERE CodigoBarra = p_CodigoBarra;
END $$
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE BuscarProductoPorNombre(IN p_Nombre VARCHAR(150))
BEGIN
    SELECT * FROM Producto WHERE Nombre LIKE CONCAT('%', p_Nombre, '%');
END $$
DELIMITER ;

/* ==========================================================
   CARRITO
   ========================================================== */
DELIMITER $$
CREATE OR REPLACE PROCEDURE AgregarAlCarrito(
    IN p_idPersona INT,
    IN p_idProducto INT,
    IN p_Cantidad INT
)
BEGIN
    DECLARE v_idCarrito INT;
    DECLARE v_Precio DECIMAL(10,2);

    -- buscar o crear carrito
    SELECT idCarrito INTO v_idCarrito
    FROM Carrito WHERE idPersona = p_idPersona LIMIT 1;

    IF v_idCarrito IS NULL THEN
        INSERT INTO Carrito (idPersona) VALUES (p_idPersona);
        SET v_idCarrito = LAST_INSERT_ID();
    END IF;

    -- obtener precio
    SELECT PrecioVenta INTO v_Precio FROM Producto WHERE idProducto = p_idProducto;

    -- insertar detalle
    INSERT INTO DetalleCarrito (idCarrito, idProducto, Cantidad, PrecioUnitario, Total)
    VALUES (v_idCarrito, p_idProducto, p_Cantidad, v_Precio, v_Precio * p_Cantidad);
END $$
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE RestarCantidadCarrito(
    IN p_idDetalleCarrito INT,
    IN p_Cantidad INT
)
BEGIN
    UPDATE DetalleCarrito
    SET Cantidad = Cantidad - p_Cantidad,
        Total = PrecioUnitario * (Cantidad - p_Cantidad)
    WHERE idDetalleCarrito = p_idDetalleCarrito
      AND Cantidad > p_Cantidad;
END $$
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE SumarCantidadCarrito(
    IN p_idDetalleCarrito INT,
    IN p_Cantidad INT
)
BEGIN
    UPDATE DetalleCarrito
    SET Cantidad = Cantidad + p_Cantidad,
        Total = PrecioUnitario * (Cantidad + p_Cantidad)
    WHERE idDetalleCarrito = p_idDetalleCarrito;
END $$
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE ObtenerCarritoPorPersona(IN p_idPersona INT)
BEGIN
    SELECT c.idCarrito, dc.idDetalleCarrito, p.Nombre AS Producto,
           dc.Cantidad, dc.PrecioUnitario, dc.Total
    FROM Carrito c
    JOIN DetalleCarrito dc ON c.idCarrito = dc.idCarrito
    JOIN Producto p ON dc.idProducto = p.idProducto
    WHERE c.idPersona = p_idPersona;
END $$
DELIMITER ;

/* ==========================================================
   PEDIDOS
   ========================================================== */
DELIMITER $$
CREATE OR REPLACE PROCEDURE RegistrarPedido(IN p_idPersona INT)
BEGIN
    INSERT INTO Pedido (idPersona, Estatus) VALUES (p_idPersona, 'Pendiente');
END $$
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE CambiarPedidoAAtendido(IN p_idPedido INT)
BEGIN
    UPDATE Pedido SET Estatus = 'Atendido' WHERE idPedido = p_idPedido;
END $$
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE CambiarPedidoACancelado(IN p_idPedido INT)
BEGIN
    UPDATE Pedido SET Estatus = 'Cancelado' WHERE idPedido = p_idPedido;
END $$
DELIMITER ;

/* ==========================================================
   VENTAS
   ========================================================== */
DELIMITER $$
CREATE OR REPLACE PROCEDURE ProcesarVenta(
    IN p_idPersona INT,
    IN p_TipoPago ENUM('Efectivo','Tarjeta','Transferencia','QR')
)
BEGIN
    DECLARE v_idCarrito INT;
    DECLARE v_Subtotal DECIMAL(10,2) DEFAULT 0;
    DECLARE v_IVA DECIMAL(10,2) DEFAULT 0;
    DECLARE v_Total DECIMAL(10,2) DEFAULT 0;

    -- obtener carrito
    SELECT idCarrito INTO v_idCarrito FROM Carrito WHERE idPersona = p_idPersona LIMIT 1;

    -- calcular montos
    SELECT SUM(Total), SUM(Total * 0.16)
    INTO v_Subtotal, v_IVA
    FROM DetalleCarrito WHERE idCarrito = v_idCarrito;

    SET v_Total = v_Subtotal + v_IVA;

    -- registrar venta
    INSERT INTO Venta (Subtotal, IVA, MontoTotal, TipoPago, Estatus, idPersona)
    VALUES (v_Subtotal, v_IVA, v_Total, p_TipoPago, 'Activa', p_idPersona);

    -- limpiar carrito
    DELETE FROM DetalleCarrito WHERE idCarrito = v_idCarrito;
END $$
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE ProcesarVentaDePedido(IN p_idPedido INT)
BEGIN
    UPDATE Pedido SET Estatus = 'Atendido' WHERE idPedido = p_idPedido;
    -- aquí puedes agregar lógica para convertir pedido en venta
END $$
DELIMITER ;

/* ==========================================================
   DEVOLUCIONES
   ========================================================== */
DELIMITER $$
CREATE OR REPLACE PROCEDURE DevolverProductoIndividual(
    IN p_idVenta INT,
    IN p_idDetalleVenta INT,
    IN p_CantidadDevuelta INT,
    IN p_TotalDevuelto DECIMAL(10,2),
    IN p_Motivo VARCHAR(200),
    IN p_idPersona INT
)
BEGIN
    INSERT INTO Devolucion (Motivo, idPersona)
    VALUES (p_Motivo, p_idPersona);

    INSERT INTO DetalleDevolucion (idDevolucion, idVenta, idDetalleVenta, CantidadDevuelta, TotalDevuelto)
    VALUES (LAST_INSERT_ID(), p_idVenta, p_idDetalleVenta, p_CantidadDevuelta, p_TotalDevuelto);
END $$
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE PROCEDURE DevolverVentaCompleta(
    IN p_idVenta INT,
    IN p_Motivo VARCHAR(200),
    IN p_idPersona INT
)
BEGIN
    DECLARE v_idDevolucion INT;

    INSERT INTO Devolucion (Motivo, idPersona)
    VALUES (p_Motivo, p_idPersona);

    SET v_idDevolucion = LAST_INSERT_ID();

    INSERT INTO DetalleDevolucion (idDevolucion, idVenta, idDetalleVenta, CantidadDevuelta, TotalDevuelto)
    SELECT v_idDevolucion, dv.idVenta, dv.idDetalleVenta, dv.Cantidad, dv.Total
    FROM DetalleVenta dv WHERE dv.idVenta = p_idVenta;

    UPDATE Venta SET Estatus = 'Devuelta' WHERE idVenta = p_idVenta;
END $$
DELIMITER ;

/* ==========================================================
   SUGERENCIAS Y QUEJAS
   ========================================================== */
DELIMITER $$
CREATE OR REPLACE PROCEDURE RegistrarSugerenciaQueja(
    IN p_idPersona INT,
    IN p_Tipo ENUM('Sugerencia','Queja'),
    IN p_Descripcion VARCHAR(255)
)
BEGIN
    INSERT INTO SugerenciaQueja (idPersona, Tipo, Descripcion, Fecha)
    VALUES (p_idPersona, p_Tipo, p_Descripcion, NOW());
END $$
DELIMITER ;
