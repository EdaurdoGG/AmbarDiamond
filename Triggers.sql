DELIMITER $$

-- Trigger: ProductoAfterUpdate
-- Descripción general:
-- Este trigger se ejecuta automáticamente después de que se actualiza cualquier
-- registro en la tabla Producto. Su propósito principal es auditar los cambios
-- realizados en los campos críticos de un producto, registrando qué usuario
-- realizó la modificación y los valores anteriores y nuevos de cada campo.
-- Además, detecta y genera alertas cuando la existencia de un producto cae
-- por debajo de 10 unidades.

-- Funcionalidad:
-- - Inserta un registro en la tabla AuditoriaProducto por cada cambio detectado.
-- - El campo "Movimiento" indica el tipo de cambio y el ID del usuario que lo realizó.
-- - Para Existencia, distingue si el cambio fue por venta, devolución o modificación directa.
-- - Genera alertas automáticas cuando la existencia del producto baja de 10 unidades.
CREATE TRIGGER ProductoAfterUpdate
AFTER UPDATE ON Producto
FOR EACH ROW
BEGIN
    DECLARE v_usuario INT DEFAULT @id_usuario_actual;

    -- Cambios en Producto
    IF NOT (NEW.Nombre <=> OLD.Nombre) THEN
        INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES (CONCAT('Modificacion por Usuario ', v_usuario), 'Nombre', OLD.Nombre, NEW.Nombre, v_usuario);
    END IF;
    IF NOT (NEW.CodigoBarra <=> OLD.CodigoBarra) THEN
        INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES (CONCAT('Modificacion por Usuario ', v_usuario), 'CodigoBarra', OLD.CodigoBarra, NEW.CodigoBarra, v_usuario);
    END IF;
    IF NOT (NEW.Existencia <=> OLD.Existencia) THEN
        INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES (CONCAT('Cambio por Venta/Devolucion/Usuario ', v_usuario), 'Existencia', OLD.Existencia, NEW.Existencia, v_usuario);

        -- Alerta de baja existencia (<10)
        IF NEW.Existencia < 10 AND OLD.Existencia >= 10 THEN
            INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
            VALUES ('Alerta Baja Existencia', 'Existencia', OLD.Existencia, NEW.Existencia, v_usuario);
        END IF;
    END IF;
    IF NOT (NEW.PrecioCompra <=> OLD.PrecioCompra) THEN
        INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES (CONCAT('Modificacion por Usuario ', v_usuario), 'PrecioCompra', OLD.PrecioCompra, NEW.PrecioCompra, v_usuario);
    END IF;
    IF NOT (NEW.PrecioVenta <=> OLD.PrecioVenta) THEN
        INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES (CONCAT('Modificacion por Usuario ', v_usuario), 'PrecioVenta', OLD.PrecioVenta, NEW.PrecioVenta, v_usuario);
    END IF;
    IF NOT (NEW.idCategoria <=> OLD.idCategoria) THEN
        INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES (CONCAT('Modificacion por Usuario ', v_usuario), 'Categoria', OLD.idCategoria, NEW.idCategoria, v_usuario);
    END IF;
END $$

-- Trigger: ProductoAfterInsert
-- Descripción general:
-- Este trigger se ejecuta automáticamente después de insertar un nuevo registro
-- en la tabla Producto. Su finalidad es auditar la creación de productos,
-- registrando qué usuario realizó la acción y el nombre del producto creado.

-- Funcionalidad:
-- - Inserta un registro en la tabla AuditoriaProducto indicando que se creó
--   un nuevo producto.
-- - El campo "Movimiento" indica que la acción fue una creación y registra
--   el ID del usuario que realizó la operación.
-- - El campo "DatoAnterior" queda como NULL porque se trata de un registro nuevo.
CREATE TRIGGER ProductoAfterInsert
AFTER INSERT ON Producto
FOR EACH ROW
BEGIN
    INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
    VALUES (CONCAT('Creacion por Usuario ', @id_usuario_actual), 'Nombre', NULL, NEW.Nombre, @id_usuario_actual);
END $$

-- Trigger: PersonaAfterUpdate
-- Descripción general:
-- Este trigger se ejecuta automáticamente después de actualizar un registro
-- en la tabla Persona. Su finalidad es auditar todas las modificaciones realizadas
-- por un usuario sobre los datos de una persona (empleado o cliente).

-- Funcionalidad:
-- - Para cada campo modificado, inserta un registro en la tabla AuditoriaPersona.
-- - El campo "Movimiento" indica que fue una modificación y registra el ID del usuario
--   que realizó el cambio.
-- - "DatoAnterior" guarda el valor previo del campo y "DatoNuevo" el valor actualizado.
-- - Esto permite mantener un historial completo de cambios por usuario.
CREATE TRIGGER PersonaAfterUpdate
AFTER UPDATE ON Persona
FOR EACH ROW
BEGIN
    DECLARE v_usuario INT DEFAULT @id_usuario_actual;

    IF NOT (NEW.Nombre <=> OLD.Nombre) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES (CONCAT('Modificacion por Usuario ', v_usuario), 'Nombre', OLD.Nombre, NEW.Nombre, v_usuario);
    END IF;
    IF NOT (NEW.ApellidoPaterno <=> OLD.ApellidoPaterno) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES (CONCAT('Modificacion por Usuario ', v_usuario), 'ApellidoPaterno', OLD.ApellidoPaterno, NEW.ApellidoPaterno, v_usuario);
    END IF;
    IF NOT (NEW.ApellidoMaterno <=> OLD.ApellidoMaterno) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES (CONCAT('Modificacion por Usuario ', v_usuario), 'ApellidoMaterno', OLD.ApellidoMaterno, NEW.ApellidoMaterno, v_usuario);
    END IF;
    IF NOT (NEW.Telefono <=> OLD.Telefono) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES (CONCAT('Modificacion por Usuario ', v_usuario), 'Telefono', OLD.Telefono, NEW.Telefono, v_usuario);
    END IF;
    IF NOT (NEW.Email <=> OLD.Email) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES (CONCAT('Modificacion por Usuario ', v_usuario), 'Email', OLD.Email, NEW.Email, v_usuario);
    END IF;
    IF NOT (NEW.Edad <=> OLD.Edad) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES (CONCAT('Modificacion por Usuario ', v_usuario), 'Edad', OLD.Edad, NEW.Edad, v_usuario);
    END IF;
    IF NOT (NEW.Sexo <=> OLD.Sexo) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES (CONCAT('Modificacion por Usuario ', v_usuario), 'Sexo', OLD.Sexo, NEW.Sexo, v_usuario);
    END IF;
    IF NOT (NEW.Estatus <=> OLD.Estatus) THEN
        INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
        VALUES (CONCAT('Modificacion por Usuario ', v_usuario), 'Estatus', OLD.Estatus, NEW.Estatus, v_usuario);
    END IF;
END $$

-- Trigger: PersonaAfterInsert
-- Descripción general:
-- Este trigger se ejecuta automáticamente después de insertar un registro
-- en la tabla Persona. Su finalidad es auditar la creación de nuevos usuarios
-- (empleados o clientes) en el sistema.

-- Funcionalidad:
-- - Inserta un registro en la tabla AuditoriaPersona indicando que se creó un nuevo usuario.
-- - El campo "Movimiento" indica la creación y registra el ID del usuario que realizó el registro.
-- - "DatoAnterior" se deja en NULL porque no existía previamente el registro.
-- - "DatoNuevo" contiene el valor del nombre del nuevo usuario.
-- - Esto permite llevar un historial completo de altas de usuarios por cada usuario administrador.
CREATE TRIGGER PersonaAfterInsert
AFTER INSERT ON Persona
FOR EACH ROW
BEGIN
    INSERT INTO AuditoriaPersona(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
    VALUES (CONCAT('Creacion por Usuario ', @id_usuario_actual), 'Nombre', NULL, NEW.Nombre, @id_usuario_actual);
END $$

-- Trigger: DetalleVentaBeforeInsert
-- Descripción general:
-- Este trigger se ejecuta automáticamente antes de insertar un registro
-- en la tabla DetalleVenta. Su finalidad es validar la disponibilidad
-- de stock de un producto antes de realizar la venta.

-- Funcionalidad:
-- - Consulta la existencia actual del producto que se va a vender.
-- - Compara la cantidad solicitada en la venta con el stock disponible.
-- - Si la cantidad a vender excede el stock, se lanza un error con SIGNAL
--   y se detiene la inserción del detalle de venta.
-- - Esto evita ventas que generen stock negativo y mantiene la integridad
--   de inventario.
-- - No inserta registros en auditoría porque solo valida la operación.
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

-- Trigger: DetalleVentaAfterInsert
-- Descripción general:
-- Este trigger se ejecuta automáticamente después de insertar un registro
-- en la tabla DetalleVenta. Su propósito es registrar en la auditoría
-- cualquier venta realizada, reflejando los cambios en la existencia del producto.

-- Funcionalidad:
-- - Calcula el stock anterior sumando la cantidad recién insertada a la existencia actual.
-- - Registra la nueva existencia después de la venta.
-- - Inserta un registro en la tabla AuditoriaProducto indicando que la acción fue realizada por un usuario.
-- - Permite llevar un historial completo de ventas y cambios en inventario por usuario.
CREATE TRIGGER DetalleVentaAfterInsert
AFTER INSERT ON DetalleVenta
FOR EACH ROW
BEGIN
    INSERT INTO AuditoriaProducto(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
    VALUES (
        CONCAT('Venta realizada por Usuario ', @id_usuario_actual),
        'Existencia',
        (SELECT Existencia + NEW.Cantidad FROM Producto WHERE idProducto = NEW.idProducto),
        (SELECT Existencia FROM Producto WHERE idProducto = NEW.idProducto),
        @id_usuario_actual
    );
END $$

-- Trigger: DevolucionAfterInsert
-- Descripción general:
-- Este trigger se ejecuta automáticamente después de insertar un registro
-- en la tabla Devolucion. Su propósito es registrar en la auditoría cada
-- devolución realizada, indicando quién la ejecutó.

-- Funcionalidad:
-- - Inserta un registro en la tabla AuditoriaDevolucion indicando que se creó
--   una nueva devolución.
-- - Permite llevar un historial de todas las devoluciones registradas por usuario.
-- - Ayuda a mantener control sobre las acciones de devoluciones para auditoría y seguimiento.
CREATE TRIGGER DevolucionAfterInsert
AFTER INSERT ON Devolucion
FOR EACH ROW
BEGIN
    INSERT INTO AuditoriaDevolucion(Movimiento, ColumnaAfectada, DatoAnterior, DatoNuevo, idPersona)
    VALUES (CONCAT('Devolucion por Usuario ', @id_usuario_actual), 'Motivo', NULL, NEW.Motivo, @id_usuario_actual);
END $$

DELIMITER ;


-- Trigers Antiguos  nesecitamos ponerlas en la base de datos

-- TRIGGER: PedidoAfterUpdate
-- Descripción general:
-- Este trigger se ejecuta automáticamente después de actualizar un registro
-- en la tabla Pedido. Su propósito es procesar la venta correspondiente 
-- cuando un pedido cambia su estado a 'Atendido'.

-- Funcionalidad:
-- - Se ejecuta después de cada actualización en Pedido.
-- - Verifica si el nuevo Estatus es 'Atendido' y el anterior no lo era.
-- - Llama al procedimiento almacenado ProcesarVentaPedido para generar
--   la venta asociada al pedido.
-- - Permite automatizar el flujo de ventas cuando un pedido se atiende.
CREATE TRIGGER PedidoAfterUpdate
AFTER UPDATE ON Pedido
FOR EACH ROW
BEGIN
    IF NEW.Estatus = 'Atendido' AND OLD.Estatus <> 'Atendido' THEN
        CALL ProcesarVentaPedido(NEW.idPedido);
    END IF;
END $$

-- TRIGGER: VentaAfterInsert
-- Descripción general:
-- Este trigger se ejecuta automáticamente después de insertar un registro
-- en la tabla Venta. Su finalidad es actualizar la tabla Finanzas con los
-- datos de la venta recién registrada.

-- Funcionalidad:
-- - Se ejecuta después de cada inserción en la tabla Venta.
-- - Inserta un nuevo registro en la tabla Finanzas con:
--   * idVenta: ID de la venta recién creada.
--   * TotalVenta: Monto total de la venta.
--   * TotalInvertido: Suma del costo de los productos vendidos en esa venta.
-- - Permite mantener actualizada la información financiera automáticamente
--   al registrar una nueva venta.
CREATE TRIGGER VentaAfterInsert
AFTER INSERT ON Venta
FOR EACH ROW
BEGIN
    INSERT INTO Finanzas (idVenta, TotalVenta, TotalInvertido)
    VALUES (
        NEW.idVenta,
        NEW.MontoTotal,
        (SELECT IFNULL(SUM(PrecioUnitario * Cantidad),0) FROM DetalleVenta WHERE idVenta = NEW.idVenta)
    );
END $$
