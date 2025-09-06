DELIMITER $$
-- Este procedimiento sirve para agregar una persona a la tabla Persona.
-- Se utilizará principalmente en la interfaz de registro de nuevos usuarios.
CREATE OR REPLACE PROCEDURE AgregarPersona(
    IN p_Nombre VARCHAR(100),
    IN p_ApellidoPaterno VARCHAR(100),
    IN p_ApellidoMaterno VARCHAR(100),
    IN p_Telefono VARCHAR(15),
    IN p_Email VARCHAR(150),
    IN p_Edad INT,
    IN p_Sexo ENUM('M','F','Otro'),
    IN p_Usuario VARCHAR(50),
    IN p_Contrasena VARCHAR(255)
)
BEGIN
    INSERT INTO Persona (Nombre, ApellidoPaterno, ApellidoMaterno, Telefono, Email, Edad, Sexo, Estatus, Usuario, Contrasena, idRol)
    VALUES (p_Nombre, p_ApellidoPaterno, p_ApellidoMaterno, p_Telefono, p_Email, p_Edad, p_Sexo, 'Activo', p_Usuario, p_Contrasena, 3);
END $$
DELIMITER ;

DELIMITER $$
-- Este procedimiento sirve principalmente para actualizar los datos de una persona.
-- Se utilizará en la interfaz de edición de usuarios y en la opción de editar perfil.
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
-- Este procedimiento sirve para cambiar el estatus de una persona de 'Activo' a 'Inactivo'.
-- Se utilizará principalmente en la interfaz donde se muestran todos los usuarios, mediante un botón para eliminar usuario.
CREATE OR REPLACE PROCEDURE EliminarPersona(IN p_idPersona INT)
BEGIN
    UPDATE Persona SET Estatus = 'Inactivo' WHERE idPersona = p_idPersona;
END $$
DELIMITER ;

DELIMITER $$
-- Este procedimiento sirve para cambiar el estatus de una persona de 'Inactivo' a 'Activo'.
-- Se utilizará principalmente en la interfaz donde se muestran todos los usuarios, mediante un botón para recuperar usuario.
CREATE OR REPLACE PROCEDURE RecuperarPersona(IN p_idPersona INT)
BEGIN
    UPDATE Persona SET Estatus = 'Activo' WHERE idPersona = p_idPersona;
END $$
DELIMITER ;

DELIMITER $$
-- Este procedimiento sirve para cambiar la contraseña de una persona.
-- Se utilizará principalmente en la interfaz de inicio de sesión, mediante el botón de "Olvidé mi contraseña".
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

DELIMITER $$
-- Este procedimiento sirve para agregar un producto a la base de datos.
-- Se utilizará principalmente en la interfaz donde se muestran las diferentes categorías de productos,
-- mediante un botón para agregar un nuevo producto. Solo estará disponible para usuarios con perfil de administrador.
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
-- Este procedimiento sirve para actualizar los datos de un producto en la base de datos.
-- Se utilizará principalmente en la interfaz donde se muestran las diferentes categorías de productos,
-- mediante un botón para editar producto. Solo estará disponible para usuarios con perfil de administrador.
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
-- Este procedimiento sirve para eliminar un producto de la base de datos.
-- La opción estará en la interfaz donde se muestran los productos
-- y solo podrá ser utilizada por usuarios con perfil de administrador.
CREATE OR REPLACE PROCEDURE EliminarProducto(IN p_idProducto INT)
BEGIN
    DELETE FROM Producto WHERE idProducto = p_idProducto;
END $$
DELIMITER ;

DELIMITER $$
-- Este procedimiento sirve para buscar un producto por su código de barras.
-- Se utilizará en un apartado con una barra de búsqueda y solo estará disponible para usuarios con perfil de empleado.
CREATE OR REPLACE PROCEDURE BuscarProductoPorCodigoBarra(IN p_CodigoBarra VARCHAR(100))
BEGIN
    SELECT * FROM Producto WHERE CodigoBarra = p_CodigoBarra;
END $$
DELIMITER ;

DELIMITER $$
-- Este procedimiento sirve para buscar un producto por su nombre.
-- Se utilizará en un apartado con una barra de búsqueda y estará disponible para todos los perfiles de usuario.
CREATE OR REPLACE PROCEDURE BuscarProductoPorNombre(IN p_Nombre VARCHAR(150))
BEGIN
    SELECT * FROM Producto WHERE Nombre LIKE CONCAT('%', p_Nombre, '%');
END $$
DELIMITER ;

DELIMITER $$
-- Este procedimiento sirve para agregar un producto al carrito.
-- Se utilizará para los perfiles de Usuario y Empleado, y se implementará mediante un botón para agregar al carrito.
CREATE OR REPLACE PROCEDURE AgregarAlCarrito(
    IN p_idPersona INT,
    IN p_idProducto INT
)
BEGIN
    DECLARE v_idCarrito INT;
    DECLARE v_Precio DECIMAL(10,2);
    DECLARE v_idDetalleCarrito INT;
    DECLARE v_CantidadActual INT;

    -- Buscar o crear carrito
    SELECT idCarrito INTO v_idCarrito
    FROM Carrito WHERE idPersona = p_idPersona LIMIT 1;

    IF v_idCarrito IS NULL THEN
        INSERT INTO Carrito (idPersona) VALUES (p_idPersona);
        SET v_idCarrito = LAST_INSERT_ID();
    END IF;

    -- Obtener precio del producto
    SELECT PrecioVenta INTO v_Precio 
    FROM Producto 
    WHERE idProducto = p_idProducto;

    -- Verificar si el producto ya existe en el carrito
    SELECT idDetalleCarrito, Cantidad INTO v_idDetalleCarrito, v_CantidadActual
    FROM DetalleCarrito
    WHERE idCarrito = v_idCarrito AND idProducto = p_idProducto
    LIMIT 1;

    -- Si el producto ya está en el carrito, solo aumentar la cantidad en 1
    IF v_idDetalleCarrito IS NOT NULL THEN
        UPDATE DetalleCarrito
        SET Cantidad = v_CantidadActual + 1,
            Total = v_Precio * (v_CantidadActual + 1)
        WHERE idDetalleCarrito = v_idDetalleCarrito;
    ELSE
        -- Si no está en el carrito, insertarlo con cantidad = 1
        INSERT INTO DetalleCarrito (idCarrito, idProducto, Cantidad, PrecioUnitario, Total)
        VALUES (v_idCarrito, p_idProducto, 1, v_Precio, v_Precio * 1);
    END IF;
END $$
DELIMITER ;

DELIMITER $$
-- Este procedimiento sirve para disminuir la cantidad de un producto en el carrito.
-- Se implementará únicamente para los roles de Empleado y Usuario en la interfaz del carrito.
CREATE OR REPLACE PROCEDURE RestarCantidadCarrito(
    IN p_idDetalleCarrito INT,
    IN p_Cantidad INT
)
BEGIN
    DECLARE v_CantidadActual INT;

    -- Obtener cantidad actual
    SELECT Cantidad INTO v_CantidadActual
    FROM DetalleCarrito
    WHERE idDetalleCarrito = p_idDetalleCarrito;

    -- Restar cantidad
    IF v_CantidadActual > p_Cantidad THEN
        UPDATE DetalleCarrito
        SET Cantidad = Cantidad - p_Cantidad,
            Total = PrecioUnitario * (Cantidad - p_Cantidad)
        WHERE idDetalleCarrito = p_idDetalleCarrito;
    ELSE
        -- Si la cantidad llega a 0 o menos, eliminar del carrito
        DELETE FROM DetalleCarrito WHERE idDetalleCarrito = p_idDetalleCarrito;
    END IF;
END $$
DELIMITER ;

DELIMITER $$
-- Este procedimiento sirve para aumentar la cantidad de un producto ya agregado en el carrito.
-- Se implementará únicamente para los roles de Empleado y Usuario en la interfaz del carrito.
CREATE OR REPLACE PROCEDURE SumarCantidadCarrito(
    IN p_idDetalleCarrito INT,
    IN p_Cantidad INT
)
BEGIN
    DECLARE v_Existencia INT;
    DECLARE v_CantidadActual INT;

    -- Obtener la existencia del producto
    SELECT p.Existencia, dc.Cantidad
    INTO v_Existencia, v_CantidadActual
    FROM DetalleCarrito dc
    JOIN Producto p ON dc.idProducto = p.idProducto
    WHERE dc.idDetalleCarrito = p_idDetalleCarrito;

    -- Solo aumentar si no supera la existencia disponible
    IF v_CantidadActual + p_Cantidad <= v_Existencia THEN
        UPDATE DetalleCarrito
        SET Cantidad = Cantidad + p_Cantidad,
            Total = PrecioUnitario * (Cantidad + p_Cantidad)
        WHERE idDetalleCarrito = p_idDetalleCarrito;
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No hay suficiente stock disponible para aumentar la cantidad.';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
-- Este procedimiento sirve para obtener el carrito en tiempo real de cada usuario.
-- Se utilizará en las interfaces de carrito tanto para los roles de Empleado como de Usuario.
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

DELIMITER $$
-- Este procedimiento registra un pedido completo del carrito de un usuario.
-- Inserta un nuevo registro en la tabla Pedido y transfiere los productos del carrito
-- al DetallePedido, con sus cantidades, precios unitarios y totales.
CREATE OR REPLACE PROCEDURE RegistrarPedido(IN p_idPersona INT)
BEGIN
    DECLARE v_idCarrito INT;
    DECLARE v_idPedido INT;

    -- Buscar el carrito del usuario
    SELECT idCarrito INTO v_idCarrito
    FROM Carrito
    WHERE idPersona = p_idPersona
    LIMIT 1;

    INSERT INTO Pedido (idPersona, Estatus)
    VALUES (p_idPersona, 'Pendiente');

    SET v_idPedido = LAST_INSERT_ID();

    INSERT INTO DetallePedido (idPedido, idProducto, Cantidad, PrecioUnitario, Total)
    SELECT v_idPedido, dc.idProducto, dc.Cantidad, dc.PrecioUnitario, dc.Total
    FROM DetalleCarrito dc
    WHERE dc.idCarrito = v_idCarrito;

    DELETE FROM DetalleCarrito WHERE idCarrito = v_idCarrito;
END $$
DELIMITER ;

DELIMITER $$
-- Este procedimiento sirve para cambiar el estado de un pedido a 'Cancelado'.
-- Se utilizará en la interfaz de pedidos disponible para los empleados, mediante un botón para cancelar el pedido.
CREATE OR REPLACE PROCEDURE CambiarPedidoACancelado(IN p_idPedido INT)
BEGIN
    UPDATE Pedido SET Estatus = 'Cancelado' WHERE idPedido = p_idPedido;
END $$
DELIMITER ;

DELIMITER $$
-- Este procedimiento sirve para procesar una venta normal desde el carrito.
-- Se utilizará en las interfaces de Empleado y Usuario mediante el botón de "Realizar venta" en el carrito.
CREATE OR REPLACE PROCEDURE ProcesarVentaNormal(
    IN p_idPersona INT,
    IN p_TipoPago ENUM('Efectivo','Tarjeta')
)
BEGIN
    DECLARE v_idCarrito INT;
    DECLARE v_Subtotal DECIMAL(10,2) DEFAULT 0;
    DECLARE v_IVA DECIMAL(10,2) DEFAULT 0;
    DECLARE v_Total DECIMAL(10,2) DEFAULT 0;

    -- Obtener el carrito del usuario
    SELECT idCarrito INTO v_idCarrito FROM Carrito WHERE idPersona = p_idPersona LIMIT 1;

    -- Calcular subtotal e IVA sumando los totales de los productos en el carrito
    SELECT SUM(Total), SUM(Total * 0.16)
    INTO v_Subtotal, v_IVA
    FROM DetalleCarrito
    WHERE idCarrito = v_idCarrito;

    SET v_Total = v_Subtotal + v_IVA;

    -- Registrar la venta
    INSERT INTO Venta (Subtotal, IVA, MontoTotal, TipoPago, Estatus, idPersona)
    VALUES (v_Subtotal, v_IVA, v_Total, p_TipoPago, 'Activa', p_idPersona);

    -- Copiar los detalles del carrito a DetalleVenta
    INSERT INTO DetalleVenta (idVenta, idProducto, Cantidad, PrecioUnitario, IVA, Total)
    SELECT LAST_INSERT_ID(), idProducto, Cantidad, PrecioUnitario, Total * 0.16, Total
    FROM DetalleCarrito
    WHERE idCarrito = v_idCarrito;

    -- Reducir existencia de los productos vendidos
    UPDATE Producto p
    JOIN DetalleCarrito dc ON p.idProducto = dc.idProducto
    SET p.Existencia = p.Existencia - dc.Cantidad
    WHERE dc.idCarrito = v_idCarrito;

    -- Limpiar el carrito
    DELETE FROM DetalleCarrito WHERE idCarrito = v_idCarrito;
END $$

DELIMITER ;

DELIMITER $$
-- Este procedimiento sirve para realizar la devolución de un artículo individual.
-- Se utilizará en la interfaz de devoluciones y solo estará disponible para los empleados.
CREATE OR REPLACE PROCEDURE DevolverProductoIndividual(
    IN p_idVenta INT,
    IN p_idDetalleVenta INT,
    IN p_CantidadDevuelta INT,
    IN p_Motivo VARCHAR(200),
    IN p_idPersona INT
)
BEGIN
    DECLARE v_CantidadActual INT;
    DECLARE v_TotalActual DECIMAL(10,2);
    DECLARE v_PrecioUnitario DECIMAL(10,2);

    -- Obtener la cantidad y precio unitario actuales del detalle de venta
    SELECT Cantidad, PrecioUnitario INTO v_CantidadActual, v_PrecioUnitario
    FROM DetalleVenta
    WHERE idDetalleVenta = p_idDetalleVenta
      AND idVenta = p_idVenta;

    -- Validar que no se devuelva más de lo que se vendió
    IF p_CantidadDevuelta > v_CantidadActual THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad a devolver excede la cantidad vendida.';
    END IF;

    -- Insertar registro de devolución
    INSERT INTO Devolucion (Motivo, idPersona)
    VALUES (p_Motivo, p_idPersona);

    -- Insertar detalle de devolución
    INSERT INTO DetalleDevolucion (idDevolucion, idVenta, idDetalleVenta, CantidadDevuelta, TotalDevuelto)
    VALUES (LAST_INSERT_ID(), p_idVenta, p_idDetalleVenta, p_CantidadDevuelta, v_PrecioUnitario * p_CantidadDevuelta);

    -- Actualizar inventario del producto
    UPDATE Producto p
    JOIN DetalleVenta dv ON p.idProducto = dv.idProducto
    SET p.Existencia = p.Existencia + p_CantidadDevuelta
    WHERE dv.idDetalleVenta = p_idDetalleVenta;

    -- Actualizar o eliminar detalle de venta
    IF v_CantidadActual - p_CantidadDevuelta > 0 THEN
        UPDATE DetalleVenta
        SET Cantidad = Cantidad - p_CantidadDevuelta,
            Total = (Cantidad - p_CantidadDevuelta) * PrecioUnitario,
            IVA = ((Cantidad - p_CantidadDevuelta) * PrecioUnitario) * 0.16
        WHERE idDetalleVenta = p_idDetalleVenta;
    ELSE
        DELETE FROM DetalleVenta
        WHERE idDetalleVenta = p_idDetalleVenta;
    END IF;

    -- Actualizar venta total
    UPDATE Venta v
    JOIN (
        SELECT idVenta, IFNULL(SUM(Total),0) AS Subtotal, IFNULL(SUM(Total * 0.16),0) AS IVA
        FROM DetalleVenta
        WHERE idVenta = p_idVenta
        GROUP BY idVenta
    ) dv_totales ON v.idVenta = dv_totales.idVenta
    SET v.Subtotal = dv_totales.Subtotal,
        v.IVA = dv_totales.IVA,
        v.MontoTotal = dv_totales.Subtotal + dv_totales.IVA
    WHERE v.idVenta = p_idVenta;

    -- Registrar auditoría del producto
    INSERT INTO AuditoriaProducto (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
    VALUES ('Devolucion', 'Existencia', v_CantidadActual, v_CantidadActual - p_CantidadDevuelta, p_idPersona);

END $$
DELIMITER ;

DELIMITER $$
-- Este procedimiento sirve para realizar la devolución completa de una venta.
-- Se utilizará en la interfaz de devoluciones y solo estará disponible para los empleados.
CREATE OR REPLACE PROCEDURE DevolverVentaCompleta(
    IN p_idVenta INT,
    IN p_Motivo VARCHAR(200),
    IN p_idPersona INT
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_idDetalleVenta INT;
    DECLARE v_idProducto INT;
    DECLARE v_Cantidad INT;
    DECLARE v_PrecioUnitario DECIMAL(10,2);

    -- Cursor para recorrer todos los productos de la venta
    DECLARE cur CURSOR FOR
        SELECT idDetalleVenta, idProducto, Cantidad, PrecioUnitario
        FROM DetalleVenta
        WHERE idVenta = p_idVenta;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Crear registro de devolución general
    INSERT INTO Devolucion (Motivo, idPersona)
    VALUES (p_Motivo, p_idPersona);

    -- Guardar el id de la devolución
    DECLARE v_idDevolucion INT;
    SET v_idDevolucion = LAST_INSERT_ID();

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_idDetalleVenta, v_idProducto, v_Cantidad, v_PrecioUnitario;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Insertar detalle de devolución para cada producto
        INSERT INTO DetalleDevolucion (idDevolucion, idVenta, idDetalleVenta, CantidadDevuelta, TotalDevuelto)
        VALUES (v_idDevolucion, p_idVenta, v_idDetalleVenta, v_Cantidad, v_Cantidad * v_PrecioUnitario);

        -- Actualizar inventario del producto
        UPDATE Producto
        SET Existencia = Existencia + v_Cantidad
        WHERE idProducto = v_idProducto;

        -- Eliminar detalle de venta (como se devuelve todo)
        DELETE FROM DetalleVenta
        WHERE idDetalleVenta = v_idDetalleVenta;

        -- Registrar auditoría del producto
        INSERT INTO AuditoriaProducto (Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES ('Devolucion Completa', 'Existencia', v_Cantidad, 0, p_idPersona);
    END LOOP;

    CLOSE cur;

    -- Actualizar la venta a monto 0 y estatus Devuelta
    UPDATE Venta
    SET Subtotal = 0,
        IVA = 0,
        MontoTotal = 0,
        Estatus = 'Devuelta'
    WHERE idVenta = p_idVenta;

END $$
DELIMITER ;

DELIMITER $$
-- Este procedimiento sirve para registrar sugerencias o quejas en la base de datos.
-- Se implementará únicamente en la interfaz de los usuarios.
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

DELIMITER $$

CREATE OR REPLACE PROCEDURE ProcesarVentaPedido(
    IN p_idPedido INT,
    IN p_TipoPago ENUM('Efectivo','Tarjeta')
)
BEGIN
    DECLARE v_idPersona INT;
    DECLARE v_Subtotal DECIMAL(10,2) DEFAULT 0;
    DECLARE v_IVA DECIMAL(10,2) DEFAULT 0;
    DECLARE v_Total DECIMAL(10,2) DEFAULT 0;
    DECLARE v_idVenta INT;

    -- Obtener la persona asociada al pedido
    SELECT idPersona INTO v_idPersona
    FROM Pedido
    WHERE idPedido = p_idPedido;

    -- Calcular subtotal e IVA sumando los totales de los detalles del pedido
    SELECT SUM(Total), SUM(Total * 0.16)
    INTO v_Subtotal, v_IVA
    FROM DetallePedido
    WHERE idPedido = p_idPedido;

    SET v_Total = v_Subtotal + v_IVA;

    -- Registrar la venta
    INSERT INTO Venta (Subtotal, IVA, MontoTotal, TipoPago, Estatus, idPersona)
    VALUES (v_Subtotal, v_IVA, v_Total, p_TipoPago, 'Activa', v_idPersona);

    SET v_idVenta = LAST_INSERT_ID();

    -- Copiar los detalles del pedido a DetalleVenta
    INSERT INTO DetalleVenta (idVenta, idProducto, Cantidad, PrecioUnitario, IVA, Total)
    SELECT v_idVenta, idProducto, Cantidad, PrecioUnitario, Total * 0.16, Total
    FROM DetallePedido
    WHERE idPedido = p_idPedido;

    -- Cambiar el estatus del pedido a 'Atendido'
    UPDATE Pedido
    SET Estatus = 'Atendido'
    WHERE idPedido = p_idPedido;

    -- Reducir existencia de los productos
    UPDATE Producto p
    JOIN DetallePedido dp ON p.idProducto = dp.idProducto
    SET p.Existencia = p.Existencia - dp.Cantidad
    WHERE dp.idPedido = p_idPedido;

END $$
DELIMITER ;

