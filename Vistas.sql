CREATE OR REPLACE VIEW VentasDiariasPorEmpleado AS
SELECT 
    v.idVenta AS NumeroVenta,
    DATE(v.Fecha) AS Fecha,
    TIME(v.Fecha) AS Hora,
    CONCAT(emp.Nombre, ' ', emp.ApellidoPaterno, ' ', emp.ApellidoMaterno) AS Empleado,
    CONCAT(cli.Nombre, ' ', cli.ApellidoPaterno, ' ', cli.ApellidoMaterno) AS Cliente,
    p.Nombre AS Producto,
    dv.Cantidad,
    (dv.Total / dv.Cantidad) AS PrecioUnitario,
    dv.Total AS Subtotal,
    dv.IVA,
    v.MontoTotal AS TotalVenta,
    v.TipoPago,
    v.Estatus
FROM Venta v
JOIN DetalleVenta dv ON v.idVenta = dv.idVenta
JOIN Producto p ON dv.idProducto = p.idProducto
JOIN Persona emp ON v.idPersona = emp.idPersona AND emp.idRol = 2  -- Empleado
JOIN Persona cli ON v.idPersona = cli.idPersona AND cli.idRol = 3; -- Cliente

CREATE OR REPLACE VIEW EmpleadosActivos AS
SELECT 
    p.idPersona AS idEmpleado,
    p.Nombre,
    p.ApellidoPaterno,
    p.ApellidoMaterno,
    p.Telefono,
    p.Email,
    p.Edad,
    p.Sexo,
    p.Estatus,
    p.Usuario
FROM Persona p
WHERE p.Estatus = 'Activo' AND p.idRol = 2;

CREATE OR REPLACE VIEW EmpleadosInactivos AS
SELECT 
    p.idPersona AS idEmpleado,
    p.Nombre,
    p.ApellidoPaterno,
    p.ApellidoMaterno,
    p.Telefono,
    p.Email,
    p.Edad,
    p.Sexo,
    p.Estatus,
    p.Usuario
FROM Persona p
WHERE p.Estatus = 'Inactivo' AND p.idRol = 2;

CREATE OR REPLACE VIEW ProductosActivos AS
SELECT 
    p.idProducto,
    p.Nombre AS Producto,
    c.Nombre AS Categoria,
    p.Existencia,
    p.PrecioCompra,
    p.PrecioVenta
FROM Producto p
JOIN Categoria c ON p.idCategoria = c.idCategoria
WHERE p.Existencia > 0
ORDER BY p.Nombre;

CREATE OR REPLACE VIEW ProductosInactivos AS
SELECT 
    p.idProducto,
    p.Nombre AS Producto,
    c.Nombre AS Categoria,
    p.Existencia,
    p.PrecioCompra,
    p.PrecioVenta
FROM Producto p
JOIN Categoria c ON p.idCategoria = c.idCategoria
WHERE p.Existencia = 0
ORDER BY p.Nombre;

CREATE OR REPLACE VIEW ClientesRegistrados AS
SELECT 
    p.idPersona AS idCliente,
    p.Nombre,
    p.ApellidoPaterno,
    p.ApellidoMaterno,
    p.Email,
    p.Telefono,
    'Cliente' AS TipoCliente
FROM Persona p
WHERE p.Estatus = 'Activo' AND p.idRol = 3;

CREATE OR REPLACE VIEW ClientesRegistradosInactivos AS
SELECT 
    p.idPersona AS idCliente,
    p.Nombre,
    p.ApellidoPaterno,
    p.ApellidoMaterno,
    p.Email,
    p.Telefono,
    'Cliente' AS TipoCliente
FROM Persona p
WHERE p.Estatus = 'Inactivo' AND p.idRol = 3;

CREATE OR REPLACE VIEW PedidosPendientes AS
SELECT 
    pe.idPedido,
    pe.Fecha,
    pe.Estatus,
    pe.idPersona AS idCliente,
    dp.idDetallePedido,
    dp.idProducto,
    p.Nombre AS Producto,
    dp.Cantidad,
    dp.PrecioUnitario,
    dp.Total
FROM Pedido pe
JOIN DetallePedido dp ON pe.idPedido = dp.idPedido
JOIN Producto p ON dp.idProducto = p.idProducto
WHERE pe.Estatus = 'Pendiente';

CREATE OR REPLACE VIEW PedidosAtendidos AS
SELECT 
    pe.idPedido,
    pe.Fecha,
    pe.Estatus,
    pe.idPersona AS idCliente,
    dp.idDetallePedido,
    dp.idProducto,
    p.Nombre AS Producto,
    dp.Cantidad,
    dp.PrecioUnitario,
    dp.Total
FROM Pedido pe
JOIN DetallePedido dp ON pe.idPedido = dp.idPedido
JOIN Producto p ON dp.idProducto = p.idProducto
WHERE pe.Estatus = 'Atendido';

CREATE OR REPLACE VIEW PedidosCancelados AS
SELECT 
    pe.idPedido,
    pe.Fecha,
    pe.Estatus,
    pe.idPersona AS idCliente,
    dp.idDetallePedido,
    dp.idProducto,
    p.Nombre AS Producto,
    dp.Cantidad,
    dp.PrecioUnitario,
    dp.Total
FROM Pedido pe
JOIN DetallePedido dp ON pe.idPedido = dp.idPedido
JOIN Producto p ON dp.idProducto = p.idProducto
WHERE pe.Estatus = 'Cancelado';

CREATE OR REPLACE VIEW DevolucionesRealizadas AS
SELECT 
    d.idDevolucion,
    d.Fecha,
    d.Motivo,
    dd.idDetalleDevolucion,
    dd.idVenta,
    dd.idDetalleVenta,
    dd.CantidadDevuelta,
    dd.TotalDevuelto,
    p.Nombre AS NombreProducto
FROM Devolucion d
JOIN DetalleDevolucion dd ON d.idDevolucion = dd.idDevolucion
JOIN DetalleVenta dv ON dd.idDetalleVenta = dv.idDetalleVenta
JOIN Producto p ON dv.idProducto = p.idProducto;

CREATE OR REPLACE VIEW HistorialModificacionesPersonas AS
SELECT 
    h.idAuditoriaPersona AS idHistorial,
    h.Movimiento,
    h.ColumnaAfectada,
    h.DatoAnterior,
    h.DatoNuevo,
    h.Fecha,
    p.idPersona,
    CONCAT(p.Nombre, ' ', p.ApellidoPaterno, ' ', p.ApellidoMaterno) AS NombrePersona,
    r.NombreRol AS Rol
FROM AuditoriaPersona h
LEFT JOIN Persona p ON h.idPersona = p.idPersona
LEFT JOIN Rol r ON p.idRol = r.idRol;

CREATE OR REPLACE VIEW HistorialModificacionesProductos AS
SELECT 
    h.idAuditoriaProducto AS idHistorial,
    h.Movimiento,
    h.ColumnaAfectada,
    h.DatoAnterior,
    h.DatoNuevo,
    h.Fecha,
    p.idPersona,
    CONCAT(p.Nombre, ' ', p.ApellidoPaterno, ' ', p.ApellidoMaterno) AS NombrePersona,
    r.NombreRol AS Rol
FROM AuditoriaProducto h
LEFT JOIN Persona p ON h.idPersona = p.idPersona
LEFT JOIN Rol r ON p.idRol = r.idRol;

CREATE OR REPLACE VIEW VistaCarritoPorPersona AS
SELECT 
    c.idCarrito,
    per.idPersona,
    CONCAT(per.Nombre, ' ', per.ApellidoPaterno, ' ', per.ApellidoMaterno) AS NombrePersona,
    p.idProducto,
    p.Nombre AS Producto,
    dc.Cantidad,
    dc.PrecioUnitario,
    dc.Total
FROM Carrito c
JOIN Persona per ON c.idPersona = per.idPersona
JOIN DetalleCarrito dc ON c.idCarrito = dc.idCarrito
JOIN Producto p ON dc.idProducto = p.idProducto;


