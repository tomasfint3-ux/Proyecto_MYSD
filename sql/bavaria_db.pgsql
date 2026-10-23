-- bavaria: modelo postgresql
-- orden: tablas, tablas intermedias, primary keys, unique keys, foreign keys,
-- nulidades, checks, triggers, poblar ok y poblar no ok


/* ---------- tablas ---------- */
create table proveedor(
  id_proveedor int,
  nombre text,
  nit int,
  direccion text,
  pais_origen text
);

create table infraestructura(
  id_infraestructura varchar(15),
  tipo_infraestructura text,
  disponibilidad text,
  direccion text,
  capacidad int
);

create table producto(
  id_producto varchar(15),
  nombre text,
  categoria text,
  precio_unitario int,
  codigo_sku varchar(15)
);

create table produccion(
  lote varchar(15),
  estado boolean,
  cantidad_total int,
  id_proveedor int,
  id_infraestructura varchar(15),
  fecha_produccion timestamp,
  empleado varchar(10)
);

create table costo_operativo(
  id_costo int,
  tipo_costo text,
  valor int,
  fecha timestamp,
  lote varchar(15)
);

create table calidad(
  id_control int,
  puntuacion int,
  empleado text,
  fecha_control timestamp,
  lote varchar(15)
);

create table importacion(
  id_importacion int,
  fecha_importacion timestamp,
  transportista text,
  arancel int,
  id_proveedor int
);

create table inventario(
  id_inventario varchar(20),
  id_producto varchar(15),
  cantidad int,
  id_infraestructura varchar(15),
  fecha_actualizacion timestamp,
  empleado text
);

create table distribucion(
  id_distribucion varchar(15),
  id_inventario varchar(20),
  fecha_salida timestamp,
  fecha_llegada timestamp,
  cantidad_enviada int,
  empleado text
);

create table local(
  id_local varchar(15),
  nombre text,
  direccion text,
  ciudad text,
  dueño text,
  tipo_local text
);

create table ruta(
  id_ruta varchar(15),
  id_local varchar(15),
  distancia int,
  duracion int
);

create table transporte(
  id_transporte varchar(15),
  conductor text,
  vehiculo text,
  id_distribucion varchar(15),
  id_ruta varchar(15)
);

create table cliente(
  id_cliente varchar(10),
  nombre text,
  documento int,
  direccion text,
  telefono int
);

create table comercializacion(
  id_comercializacion varchar(15),
  id_producto varchar(15),
  id_local varchar(15),
  id_cliente varchar(10),
  fecha_venta timestamp,
  cantidad_vendida int,
  valor_venta int,
  empleado text
);

create table factura(
  id_factura int,
  id_cliente varchar(10),
  fecha timestamp,
  total float
);

create table pago(
  id_pago int,
  id_factura int,
  fecha_pago timestamp,
  metodo_pago text,
  monto int
);

-- tablas intermedias
create table detalle_importacion_produccion(
  id_importacion int,
  lote varchar(15),
  cantidad_usada int
);

create table detalle_produccion(
  lote varchar(15),
  id_producto varchar(15),
  cantidad_producida int
);

create table producto_local(
  id_producto varchar(15),
  id_local varchar(15),
  cantidad_disponible int,
  fecha_llegada timestamp
);


-- primary keys
ALTER TABLE proveedor
    ADD CONSTRAINT pk_proveedor
    PRIMARY KEY (id_proveedor);

ALTER TABLE infraestructura
    ADD CONSTRAINT pk_infraestructura
    PRIMARY KEY (id_infraestructura);

ALTER TABLE producto
    ADD CONSTRAINT pk_producto
    PRIMARY KEY (id_producto);

ALTER TABLE produccion
    ADD CONSTRAINT pk_produccion
    PRIMARY KEY (lote);

ALTER TABLE costo_operativo
    ADD CONSTRAINT pk_costo_operativo
    PRIMARY KEY (id_costo);

ALTER TABLE calidad
    ADD CONSTRAINT pk_calidad
    PRIMARY KEY (id_control);

ALTER TABLE importacion
    ADD CONSTRAINT pk_importacion
    PRIMARY KEY (id_importacion);

ALTER TABLE inventario
    ADD CONSTRAINT pk_inventario
    PRIMARY KEY (id_inventario);

ALTER TABLE distribucion
    ADD CONSTRAINT pk_distribucion
    PRIMARY KEY (id_distribucion);

ALTER TABLE local
    ADD CONSTRAINT pk_local
    PRIMARY KEY (id_local);

ALTER TABLE ruta
    ADD CONSTRAINT pk_ruta
    PRIMARY KEY (id_ruta);

ALTER TABLE transporte
    ADD CONSTRAINT pk_transporte
    PRIMARY KEY (id_transporte);

ALTER TABLE cliente
    ADD CONSTRAINT pk_cliente
    PRIMARY KEY (id_cliente);

ALTER TABLE comercializacion
    ADD CONSTRAINT pk_comercializacion
    PRIMARY KEY (id_comercializacion);

ALTER TABLE factura
    ADD CONSTRAINT pk_factura
    PRIMARY KEY (id_factura);

ALTER TABLE pago
    ADD CONSTRAINT pk_pago
    PRIMARY KEY (id_pago);

ALTER TABLE detalle_importacion_produccion
    ADD CONSTRAINT pk_dip
    PRIMARY KEY (id_importacion, lote);

ALTER TABLE detalle_produccion
    ADD CONSTRAINT pk_dp
    PRIMARY KEY (lote, id_producto);

ALTER TABLE producto_local
    ADD CONSTRAINT pk_pl
    PRIMARY KEY (id_producto, id_local);


-- unique keys
ALTER TABLE proveedor
    ADD CONSTRAINT uk_proveedor_nit
    UNIQUE (nit);

ALTER TABLE producto
    ADD CONSTRAINT uk_producto_sku
    UNIQUE (codigo_sku);

ALTER TABLE cliente
    ADD CONSTRAINT uk_cliente_documento
    UNIQUE (documento);


-- foreign keys
ALTER TABLE produccion
    ADD CONSTRAINT fk_produccion_proveedor
    FOREIGN KEY (id_proveedor)
    REFERENCES proveedor(id_proveedor);

ALTER TABLE produccion
    ADD CONSTRAINT fk_produccion_infraestructura
    FOREIGN KEY (id_infraestructura)
    REFERENCES infraestructura(id_infraestructura);

ALTER TABLE costo_operativo
    ADD CONSTRAINT fk_costo_produccion
    FOREIGN KEY (lote)
    REFERENCES produccion(lote);

ALTER TABLE calidad
    ADD CONSTRAINT fk_calidad_produccion
    FOREIGN KEY (lote)
    REFERENCES produccion(lote);

ALTER TABLE importacion
    ADD CONSTRAINT fk_importacion_proveedor
    FOREIGN KEY (id_proveedor)
    REFERENCES proveedor(id_proveedor);

ALTER TABLE inventario
    ADD CONSTRAINT fk_inventario_producto
    FOREIGN KEY (id_producto)
    REFERENCES producto(id_producto);

ALTER TABLE inventario
    ADD CONSTRAINT fk_inventario_infraestructura
    FOREIGN KEY (id_infraestructura)
    REFERENCES infraestructura(id_infraestructura);

ALTER TABLE distribucion
    ADD CONSTRAINT fk_distribucion_inventario
    FOREIGN KEY (id_inventario)
    REFERENCES inventario(id_inventario);

ALTER TABLE ruta
    ADD CONSTRAINT fk_ruta_local
    FOREIGN KEY (id_local)
    REFERENCES local(id_local);

ALTER TABLE transporte
    ADD CONSTRAINT fk_transporte_distribucion
    FOREIGN KEY (id_distribucion)
    REFERENCES distribucion(id_distribucion);

ALTER TABLE transporte
    ADD CONSTRAINT fk_transporte_ruta
    FOREIGN KEY (id_ruta)
    REFERENCES ruta(id_ruta);

ALTER TABLE comercializacion
    ADD CONSTRAINT fk_comercializacion_producto
    FOREIGN KEY (id_producto)
    REFERENCES producto(id_producto);

ALTER TABLE comercializacion
    ADD CONSTRAINT fk_comercializacion_local
    FOREIGN KEY (id_local)
    REFERENCES local(id_local);

ALTER TABLE comercializacion
    ADD CONSTRAINT fk_comercializacion_cliente
    FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente);

ALTER TABLE factura
    ADD CONSTRAINT fk_factura_cliente
    FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente);

ALTER TABLE pago
    ADD CONSTRAINT fk_pago_factura
    FOREIGN KEY (id_factura)
    REFERENCES factura(id_factura);

ALTER TABLE detalle_importacion_produccion
    ADD CONSTRAINT fk_dip_importacion
    FOREIGN KEY (id_importacion)
    REFERENCES importacion(id_importacion);

ALTER TABLE detalle_importacion_produccion
    ADD CONSTRAINT fk_dip_produccion
    FOREIGN KEY (lote)
    REFERENCES produccion(lote);

ALTER TABLE detalle_produccion
    ADD CONSTRAINT fk_dp_produccion
    FOREIGN KEY (lote)
    REFERENCES produccion(lote);

ALTER TABLE detalle_produccion
    ADD CONSTRAINT fk_dp_producto
    FOREIGN KEY (id_producto)
    REFERENCES producto(id_producto);

ALTER TABLE producto_local
    ADD CONSTRAINT fk_pl_producto
    FOREIGN KEY (id_producto)
    REFERENCES producto(id_producto);

ALTER TABLE producto_local
    ADD CONSTRAINT fk_pl_local
    FOREIGN KEY (id_local)
    REFERENCES local(id_local);


-- nulidades (solo las fk obligatorias; produccion.id_proveedor queda opcional)
ALTER TABLE produccion
    ALTER COLUMN id_infraestructura SET NOT NULL;

ALTER TABLE costo_operativo
    ALTER COLUMN lote SET NOT NULL;

ALTER TABLE calidad
    ALTER COLUMN lote SET NOT NULL;

ALTER TABLE importacion
    ALTER COLUMN id_proveedor SET NOT NULL;

ALTER TABLE inventario
    ALTER COLUMN id_producto SET NOT NULL;

ALTER TABLE inventario
    ALTER COLUMN id_infraestructura SET NOT NULL;

ALTER TABLE distribucion
    ALTER COLUMN id_inventario SET NOT NULL;

ALTER TABLE ruta
    ALTER COLUMN id_local SET NOT NULL;

ALTER TABLE transporte
    ALTER COLUMN id_distribucion SET NOT NULL;

ALTER TABLE transporte
    ALTER COLUMN id_ruta SET NOT NULL;

ALTER TABLE comercializacion
    ALTER COLUMN id_producto SET NOT NULL;

ALTER TABLE comercializacion
    ALTER COLUMN id_local SET NOT NULL;

ALTER TABLE comercializacion
    ALTER COLUMN id_cliente SET NOT NULL;

ALTER TABLE factura
    ALTER COLUMN id_cliente SET NOT NULL;

ALTER TABLE pago
    ALTER COLUMN id_factura SET NOT NULL;


-- checks
ALTER TABLE calidad
    ADD CONSTRAINT ck_calidad_puntuacion
    CHECK (puntuacion BETWEEN 1 AND 5);

ALTER TABLE produccion
    ADD CONSTRAINT ck_produccion_cantidad
    CHECK (cantidad_total > 0);

ALTER TABLE producto
    ADD CONSTRAINT ck_producto_precio
    CHECK (precio_unitario > 0);

ALTER TABLE infraestructura
    ADD CONSTRAINT ck_infra_capacidad
    CHECK (capacidad > 0);

ALTER TABLE infraestructura
    ADD CONSTRAINT ck_infra_tipo
    CHECK (tipo_infraestructura IN ('Planta', 'Centro de distribucion'));

ALTER TABLE infraestructura
    ADD CONSTRAINT ck_infra_disponibilidad
    CHECK (disponibilidad IN ('Disponible', 'En mantenimiento', 'Fuera de servicio'));

ALTER TABLE costo_operativo
    ADD CONSTRAINT ck_costo_valor
    CHECK (valor > 0);

ALTER TABLE costo_operativo
    ADD CONSTRAINT ck_costo_tipo
    CHECK (tipo_costo IN ('Materia prima', 'Mano de obra', 'Energia', 'Empaque', 'Mantenimiento'));

ALTER TABLE importacion
    ADD CONSTRAINT ck_importacion_arancel
    CHECK (arancel >= 0);

ALTER TABLE inventario
    ADD CONSTRAINT ck_inventario_cantidad
    CHECK (cantidad >= 0);

ALTER TABLE distribucion
    ADD CONSTRAINT ck_distribucion_cantidad
    CHECK (cantidad_enviada > 0);

ALTER TABLE distribucion
    ADD CONSTRAINT ck_distribucion_fechas
    CHECK (fecha_llegada >= fecha_salida);

ALTER TABLE ruta
    ADD CONSTRAINT ck_ruta_distancia
    CHECK (distancia > 0);

ALTER TABLE ruta
    ADD CONSTRAINT ck_ruta_duracion
    CHECK (duracion > 0);

ALTER TABLE comercializacion
    ADD CONSTRAINT ck_comercializacion_cantidad
    CHECK (cantidad_vendida > 0);

ALTER TABLE factura
    ADD CONSTRAINT ck_factura_total
    CHECK (total > 0);

ALTER TABLE pago
    ADD CONSTRAINT ck_pago_monto
    CHECK (monto > 0);

ALTER TABLE pago
    ADD CONSTRAINT ck_pago_metodo
    CHECK (metodo_pago IN ('Efectivo', 'Transferencia', 'Tarjeta', 'Cheque'));

ALTER TABLE detalle_importacion_produccion
    ADD CONSTRAINT ck_dip_cantidad
    CHECK (cantidad_usada > 0);

ALTER TABLE detalle_produccion
    ADD CONSTRAINT ck_dp_cantidad
    CHECK (cantidad_producida > 0);

ALTER TABLE producto_local
    ADD CONSTRAINT ck_pl_cantidad
    CHECK (cantidad_disponible >= 0);


-- triggers

-- validacion de stock y descuento de inventario
CREATE OR REPLACE FUNCTION fn_distribucion_stock() RETURNS trigger AS $$
DECLARE v_stock int;
BEGIN
  SELECT cantidad INTO v_stock FROM inventario
  WHERE id_inventario = NEW.id_inventario FOR UPDATE;
  IF v_stock IS NULL OR NEW.cantidad_enviada > v_stock THEN
    RAISE EXCEPTION 'Stock insuficiente en inventario %', NEW.id_inventario;
  END IF;
  UPDATE inventario
  SET cantidad = cantidad - NEW.cantidad_enviada, fecha_actualizacion = now()
  WHERE id_inventario = NEW.id_inventario;
  RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_distribucion_stock
BEFORE INSERT ON distribucion
FOR EACH ROW EXECUTE FUNCTION fn_distribucion_stock();

-- los pagos no pueden superar el total de la factura
CREATE OR REPLACE FUNCTION fn_pago_limite() RETURNS trigger AS $$
DECLARE v_total float; v_pagado numeric;
BEGIN
  SELECT total INTO v_total FROM factura WHERE id_factura = NEW.id_factura FOR UPDATE;
  SELECT COALESCE(SUM(monto), 0) INTO v_pagado FROM pago
  WHERE id_factura = NEW.id_factura AND id_pago <> NEW.id_pago;
  IF v_pagado + NEW.monto > v_total THEN
    RAISE EXCEPTION 'El pago excede el saldo de la factura %', NEW.id_factura;
  END IF;
  RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_pago_limite
BEFORE INSERT OR UPDATE ON pago
FOR EACH ROW EXECUTE FUNCTION fn_pago_limite();

-- el inventario no puede superar la capacidad de la infraestructura
CREATE OR REPLACE FUNCTION fn_inventario_capacidad() RETURNS trigger AS $$
DECLARE v_cap int; v_ocupado bigint;
BEGIN
  SELECT capacidad INTO v_cap FROM infraestructura
  WHERE id_infraestructura = NEW.id_infraestructura FOR UPDATE;
  SELECT COALESCE(SUM(cantidad), 0) INTO v_ocupado FROM inventario
  WHERE id_infraestructura = NEW.id_infraestructura AND id_inventario <> NEW.id_inventario;
  IF v_ocupado + NEW.cantidad > v_cap THEN
    RAISE EXCEPTION 'Capacidad excedida en %', NEW.id_infraestructura;
  END IF;
  RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inventario_capacidad
BEFORE INSERT OR UPDATE OF cantidad, id_infraestructura ON inventario
FOR EACH ROW EXECUTE FUNCTION fn_inventario_capacidad();

-- lo producido no puede superar la cantidad_total del lote
CREATE OR REPLACE FUNCTION fn_detalle_produccion_total() RETURNS trigger AS $$
DECLARE v_total int; v_suma bigint;
BEGIN
  SELECT cantidad_total INTO v_total FROM produccion WHERE lote = NEW.lote FOR UPDATE;
  SELECT COALESCE(SUM(cantidad_producida), 0) INTO v_suma FROM detalle_produccion
  WHERE lote = NEW.lote AND id_producto <> NEW.id_producto;
  IF v_suma + NEW.cantidad_producida > v_total THEN
    RAISE EXCEPTION 'El lote % excede su cantidad_total', NEW.lote;
  END IF;
  RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_detalle_produccion_total
BEFORE INSERT OR UPDATE ON detalle_produccion
FOR EACH ROW EXECUTE FUNCTION fn_detalle_produccion_total();

-- valida valor de la venta y stock del local, y descuenta del local
CREATE OR REPLACE FUNCTION fn_comercializacion_valida() RETURNS trigger AS $$
DECLARE v_precio int; v_disp int;
BEGIN
  SELECT precio_unitario INTO v_precio FROM producto WHERE id_producto = NEW.id_producto;
  IF NEW.valor_venta <> NEW.cantidad_vendida * v_precio THEN
    RAISE EXCEPTION 'valor_venta no coincide con cantidad x precio';
  END IF;
  SELECT cantidad_disponible INTO v_disp FROM producto_local
  WHERE id_producto = NEW.id_producto AND id_local = NEW.id_local FOR UPDATE;
  IF v_disp IS NULL OR v_disp < NEW.cantidad_vendida THEN
    RAISE EXCEPTION 'Stock insuficiente en el local % para el producto %', NEW.id_local, NEW.id_producto;
  END IF;
  UPDATE producto_local SET cantidad_disponible = cantidad_disponible - NEW.cantidad_vendida
  WHERE id_producto = NEW.id_producto AND id_local = NEW.id_local;
  RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_comercializacion_valida
BEFORE INSERT ON comercializacion
FOR EACH ROW EXECUTE FUNCTION fn_comercializacion_valida();


-- poblar ok

INSERT INTO proveedor (id_proveedor, nombre, nit, direccion, pais_origen) VALUES
    (1, 'Malteria Tropical S.A.', 800100201, 'Calle 13 No. 68-45, Bogota', 'Colombia'),
    (2, 'Cebadas del Sur S.A.', 900200302, 'Av. Cordoba 1234, Buenos Aires', 'Argentina'),
    (3, 'Prairie Malt Ltd.', 800300403, 'Main Street 120, Saskatoon', 'Canada');

INSERT INTO infraestructura (id_infraestructura, tipo_infraestructura, disponibilidad, direccion, capacidad) VALUES
    ('INF-001', 'Planta', 'Disponible', 'Autopista Norte Km 30, Tocancipa', 500000),
    ('INF-002', 'Centro de distribucion', 'Disponible', 'Calle 80 No. 100-20, Bogota', 200000),
    ('INF-003', 'Planta', 'En mantenimiento', 'Via 40 No. 85-80, Barranquilla', 400000);

INSERT INTO producto (id_producto, nombre, categoria, precio_unitario, codigo_sku) VALUES
    ('PRD-001', 'Aguila Original 330ml', 'Cerveza', 2500, 'SKU-AGU-330'),
    ('PRD-002', 'Club Colombia Dorada 330ml', 'Cerveza', 3200, 'SKU-CCD-330'),
    ('PRD-003', 'Pony Malta 330ml', 'Malta', 2100, 'SKU-PMA-330');

INSERT INTO local (id_local, nombre, direccion, ciudad, dueño, tipo_local) VALUES
    ('LOC-001', 'Tienda La Esquina', 'Carrera 7 No. 45-10', 'Bogota', 'Carlos Ramirez', 'Tienda'),
    ('LOC-002', 'Bar El Rincon Paisa', 'Carrera 43A No. 5-30', 'Medellin', 'Jorge Gomez', 'Bar');

INSERT INTO cliente (id_cliente, nombre, documento, direccion, telefono) VALUES
    ('CLI-001', 'Carlos Ramirez', 79123456, 'Carrera 7 No. 45-10, Bogota', 2345678),
    ('CLI-002', 'Maria Lopez', 43234567, 'Calle 10 No. 20-15, Medellin', 4456789),
    ('CLI-003', 'Ana Martinez', 1020304050, 'Carrera 15 No. 90-20, Bogota', 6012345);

INSERT INTO importacion (id_importacion, fecha_importacion, transportista, arancel, id_proveedor) VALUES
    (1, '2026-01-15 08:30:00', 'Maersk Line', 1200000, 2),
    (2, '2026-02-10 10:00:00', 'Hapag-Lloyd', 1850000, 3);

-- el lote 3 no tiene proveedor (id_proveedor es opcional)
INSERT INTO produccion (lote, estado, cantidad_total, id_proveedor, id_infraestructura, fecha_produccion, empleado) VALUES
    ('LOT-2026-001', true, 100000, 1, 'INF-001', '2026-03-01 06:00:00', 'EMP-001'),
    ('LOT-2026-002', true, 80000, 2, 'INF-001', '2026-03-10 06:00:00', 'EMP-002'),
    ('LOT-2026-003', false, 60000, NULL, 'INF-001', '2026-04-02 06:00:00', 'EMP-003');

INSERT INTO costo_operativo (id_costo, tipo_costo, valor, fecha, lote) VALUES
    (1, 'Materia prima', 45000000, '2026-03-01 12:00:00', 'LOT-2026-001'),
    (2, 'Energia', 9500000, '2026-03-12 12:00:00', 'LOT-2026-002'),
    (3, 'Empaque', 12000000, '2026-04-03 12:00:00', 'LOT-2026-003');

INSERT INTO calidad (id_control, puntuacion, empleado, fecha_control, lote) VALUES
    (1, 5, 'EMP-010', '2026-03-03 14:00:00', 'LOT-2026-001'),
    (2, 4, 'EMP-011', '2026-03-12 14:00:00', 'LOT-2026-002'),
    (3, 3, 'EMP-010', '2026-04-04 14:00:00', 'LOT-2026-003');

INSERT INTO detalle_importacion_produccion (id_importacion, lote, cantidad_usada) VALUES
    (1, 'LOT-2026-002', 4000),
    (2, 'LOT-2026-001', 3500),
    (2, 'LOT-2026-003', 2500);

-- la suma por lote no supera produccion.cantidad_total
INSERT INTO detalle_produccion (lote, id_producto, cantidad_producida) VALUES
    ('LOT-2026-001', 'PRD-001', 60000),
    ('LOT-2026-001', 'PRD-002', 40000),
    ('LOT-2026-002', 'PRD-003', 50000),
    ('LOT-2026-003', 'PRD-001', 40000);

-- la suma por infraestructura no supera su capacidad
INSERT INTO inventario (id_inventario, id_producto, cantidad, id_infraestructura, fecha_actualizacion, empleado) VALUES
    ('INV-001', 'PRD-001', 40000, 'INF-001', '2026-03-05 08:00:00', 'EMP-020'),
    ('INV-002', 'PRD-002', 30000, 'INF-001', '2026-03-05 08:10:00', 'EMP-020'),
    ('INV-003', 'PRD-001', 25000, 'INF-002', '2026-03-20 09:00:00', 'EMP-022'),
    ('INV-004', 'PRD-003', 15000, 'INF-002', '2026-03-20 09:10:00', 'EMP-022');

-- el trigger descuenta del inventario, la ultima va en transito (fecha_llegada NULL)
INSERT INTO distribucion (id_distribucion, id_inventario, fecha_salida, fecha_llegada, cantidad_enviada, empleado) VALUES
    ('DIS-001', 'INV-001', '2026-03-22 07:00:00', '2026-03-22 15:00:00', 10000, 'EMP-030'),
    ('DIS-002', 'INV-003', '2026-04-01 07:30:00', NULL, 5000, 'EMP-031');

INSERT INTO ruta (id_ruta, id_local, distancia, duracion) VALUES
    ('RUT-001', 'LOC-001', 45, 90),
    ('RUT-002', 'LOC-002', 410, 540);

INSERT INTO transporte (id_transporte, conductor, vehiculo, id_distribucion, id_ruta) VALUES
    ('TRA-001', 'Pedro Gutierrez', 'Camion NPR ABC123', 'DIS-001', 'RUT-001'),
    ('TRA-002', 'Andres Salazar', 'Tractocamion Kenworth T800 DEF456', 'DIS-002', 'RUT-002');

INSERT INTO producto_local (id_producto, id_local, cantidad_disponible, fecha_llegada) VALUES
    ('PRD-001', 'LOC-001', 5000, '2026-03-22 16:00:00'),
    ('PRD-002', 'LOC-001', 2000, '2026-03-22 16:30:00'),
    ('PRD-003', 'LOC-002', 3000, '2026-04-02 13:00:00');

-- valor_venta = cantidad_vendida x precio_unitario (el trigger descuenta del local)
INSERT INTO comercializacion (id_comercializacion, id_producto, id_local, id_cliente, fecha_venta, cantidad_vendida, valor_venta, empleado) VALUES
    ('COM-001', 'PRD-001', 'LOC-001', 'CLI-001', '2026-04-05 10:30:00', 100, 250000, 'EMP-040'),
    ('COM-002', 'PRD-003', 'LOC-002', 'CLI-002', '2026-04-06 11:00:00', 150, 315000, 'EMP-041'),
    ('COM-003', 'PRD-002', 'LOC-001', 'CLI-003', '2026-04-08 16:00:00', 80, 256000, 'EMP-040');

INSERT INTO factura (id_factura, id_cliente, fecha, total) VALUES
    (1, 'CLI-001', '2026-04-05 10:45:00', 250000),
    (2, 'CLI-002', '2026-04-06 11:15:00', 315000),
    (3, 'CLI-003', '2026-04-08 16:10:00', 256000);

-- la suma por factura no supera factura.total, la factura 3 queda sin pagos
INSERT INTO pago (id_pago, id_factura, fecha_pago, metodo_pago, monto) VALUES
    (1, 1, '2026-04-05 11:00:00', 'Efectivo', 250000),
    (2, 2, '2026-04-06 12:00:00', 'Transferencia', 200000),
    (3, 2, '2026-04-20 09:00:00', 'Transferencia', 115000);


-- poblar no ok
-- cada insert/update va a fallar

-- primary key duplicada: proveedor
INSERT INTO proveedor (id_proveedor, nombre, nit, direccion, pais_origen) VALUES
    (1, 'Proveedor Repetido S.A.', 800999991, 'Calle 1 No. 1-1, Bogota', 'Colombia');

-- primary key compuesta duplicada: detalle_produccion
INSERT INTO detalle_produccion (lote, id_producto, cantidad_producida) VALUES
    ('LOT-2026-001', 'PRD-001', 10);

-- primary key nula: proveedor
INSERT INTO proveedor (id_proveedor, nombre, nit, direccion, pais_origen) VALUES
    (NULL, 'Proveedor Sin Id S.A.', 800999992, 'Calle 4 No. 4-4, Bogota', 'Colombia');

-- unique key duplicada: proveedor.nit
INSERT INTO proveedor (id_proveedor, nombre, nit, direccion, pais_origen) VALUES
    (99, 'Proveedor Nit Repetido S.A.', 800100201, 'Calle 5 No. 5-5, Bogota', 'Colombia');

-- unique key duplicada: producto.codigo_sku
INSERT INTO producto (id_producto, nombre, categoria, precio_unitario, codigo_sku) VALUES
    ('PRD-099', 'Producto Sku Repetido 330ml', 'Cerveza', 2500, 'SKU-AGU-330');

-- unique key duplicada: cliente.documento
INSERT INTO cliente (id_cliente, nombre, documento, direccion, telefono) VALUES
    ('CLI-099', 'Cliente Documento Repetido', 79123456, 'Calle 6 No. 6-6, Bogota', 2000002);

-- foreign key inexistente: produccion.id_proveedor
INSERT INTO produccion (lote, estado, cantidad_total, id_proveedor, id_infraestructura, fecha_produccion, empleado) VALUES
    ('LOT-2026-099', true, 1000, 99, 'INF-001', '2026-05-01 06:00:00', 'EMP-001');

-- foreign key inexistente: costo_operativo.lote
INSERT INTO costo_operativo (id_costo, tipo_costo, valor, fecha, lote) VALUES
    (99, 'Energia', 1000000, '2026-05-01 12:00:00', 'LOT-2026-999');

-- foreign key inexistente: inventario.id_producto
INSERT INTO inventario (id_inventario, id_producto, cantidad, id_infraestructura, fecha_actualizacion, empleado) VALUES
    ('INV-099', 'PRD-999', 10, 'INF-001', '2026-05-01 08:00:00', 'EMP-020');

-- foreign key inexistente: transporte.id_ruta
INSERT INTO transporte (id_transporte, conductor, vehiculo, id_distribucion, id_ruta) VALUES
    ('TRA-099', 'Pedro Gutierrez', 'Camion NPR ABC123', 'DIS-001', 'RUT-999');

-- foreign key inexistente: pago.id_factura
INSERT INTO pago (id_pago, id_factura, fecha_pago, metodo_pago, monto) VALUES
    (99, 99, '2026-05-01 10:00:00', 'Efectivo', 1000);

-- not null: produccion.id_infraestructura
INSERT INTO produccion (lote, estado, cantidad_total, id_proveedor, id_infraestructura, fecha_produccion, empleado) VALUES
    ('LOT-2026-098', true, 1000, 1, NULL, '2026-05-01 06:00:00', 'EMP-001');

-- not null: inventario.id_producto
INSERT INTO inventario (id_inventario, id_producto, cantidad, id_infraestructura, fecha_actualizacion, empleado) VALUES
    ('INV-098', NULL, 10, 'INF-001', '2026-05-01 08:00:00', 'EMP-020');

-- not null: factura.id_cliente
INSERT INTO factura (id_factura, id_cliente, fecha, total) VALUES
    (98, NULL, '2026-05-01 10:00:00', 1000);

-- check: calidad.puntuacion mayor a 5
INSERT INTO calidad (id_control, puntuacion, empleado, fecha_control, lote) VALUES
    (97, 6, 'EMP-010', '2026-05-01 14:00:00', 'LOT-2026-001');

-- check: produccion.cantidad_total en cero
INSERT INTO produccion (lote, estado, cantidad_total, id_proveedor, id_infraestructura, fecha_produccion, empleado) VALUES
    ('LOT-2026-097', true, 0, 1, 'INF-001', '2026-05-01 06:00:00', 'EMP-001');

-- check: producto.precio_unitario en cero
INSERT INTO producto (id_producto, nombre, categoria, precio_unitario, codigo_sku) VALUES
    ('PRD-097', 'Producto Gratis 330ml', 'Cerveza', 0, 'SKU-097-330');

-- check: infraestructura.tipo_infraestructura invalido
INSERT INTO infraestructura (id_infraestructura, tipo_infraestructura, disponibilidad, direccion, capacidad) VALUES
    ('INF-097', 'Bodega', 'Disponible', 'Calle 7 No. 7-7, Bogota', 1000);

-- check: costo_operativo.tipo_costo invalido
INSERT INTO costo_operativo (id_costo, tipo_costo, valor, fecha, lote) VALUES
    (97, 'Publicidad', 1000000, '2026-05-01 12:00:00', 'LOT-2026-001');

-- check: inventario.cantidad negativa
INSERT INTO inventario (id_inventario, id_producto, cantidad, id_infraestructura, fecha_actualizacion, empleado) VALUES
    ('INV-097', 'PRD-001', -10, 'INF-001', '2026-05-01 08:00:00', 'EMP-020');

-- check: distribucion.fecha_llegada antes de fecha_salida
INSERT INTO distribucion (id_distribucion, id_inventario, fecha_salida, fecha_llegada, cantidad_enviada, empleado) VALUES
    ('DIS-096', 'INV-002', '2026-05-02 10:00:00', '2026-05-01 10:00:00', 100, 'EMP-030');

-- check: ruta.distancia en cero
INSERT INTO ruta (id_ruta, id_local, distancia, duracion) VALUES
    ('RUT-097', 'LOC-001', 0, 60);

-- check: pago.metodo_pago invalido
INSERT INTO pago (id_pago, id_factura, fecha_pago, metodo_pago, monto) VALUES
    (97, 3, '2026-05-01 10:00:00', 'Bitcoin', 1000);

-- trigger fn_distribucion_stock: cantidad_enviada mayor al stock (INV-004 tiene 15000)
INSERT INTO distribucion (id_distribucion, id_inventario, fecha_salida, fecha_llegada, cantidad_enviada, empleado) VALUES
    ('DIS-095', 'INV-004', '2026-05-01 07:00:00', '2026-05-01 15:00:00', 99999, 'EMP-030');

-- trigger fn_distribucion_stock: inventario inexistente
INSERT INTO distribucion (id_distribucion, id_inventario, fecha_salida, fecha_llegada, cantidad_enviada, empleado) VALUES
    ('DIS-095', 'INV-999', '2026-05-01 07:00:00', '2026-05-01 15:00:00', 100, 'EMP-030');

-- trigger fn_pago_limite: insert que supera el total (factura 1 ya pagada completa, 250000)
INSERT INTO pago (id_pago, id_factura, fecha_pago, metodo_pago, monto) VALUES
    (96, 1, '2026-05-01 10:00:00', 'Efectivo', 1000);

-- trigger fn_pago_limite: update que supera el total de la factura 1 (250000)
UPDATE pago SET monto = 600000 WHERE id_pago = 1;

-- trigger fn_inventario_capacidad: insert que supera la capacidad de INF-002 (200000)
INSERT INTO inventario (id_inventario, id_producto, cantidad, id_infraestructura, fecha_actualizacion, empleado) VALUES
    ('INV-096', 'PRD-001', 200000, 'INF-002', '2026-05-01 08:00:00', 'EMP-020');

-- trigger fn_inventario_capacidad: update que supera la capacidad de INF-002 (200000)
UPDATE inventario SET cantidad = 250000 WHERE id_inventario = 'INV-003';

-- trigger fn_detalle_produccion_total: insert que supera cantidad_total del lote 3 (60000)
INSERT INTO detalle_produccion (lote, id_producto, cantidad_producida) VALUES
    ('LOT-2026-003', 'PRD-002', 30000);

-- trigger fn_detalle_produccion_total: update que supera cantidad_total del lote 3 (60000)
UPDATE detalle_produccion SET cantidad_producida = 70000 WHERE lote = 'LOT-2026-003' AND id_producto = 'PRD-001';

-- trigger fn_comercializacion_valida: valor_venta distinto de cantidad x precio (10 x 2500)
INSERT INTO comercializacion (id_comercializacion, id_producto, id_local, id_cliente, fecha_venta, cantidad_vendida, valor_venta, empleado) VALUES
    ('COM-095', 'PRD-001', 'LOC-001', 'CLI-001', '2026-05-01 10:00:00', 10, 99999, 'EMP-040');

-- trigger fn_comercializacion_valida: cantidad_vendida mayor al stock del local (4900 disponibles)
INSERT INTO comercializacion (id_comercializacion, id_producto, id_local, id_cliente, fecha_venta, cantidad_vendida, valor_venta, empleado) VALUES
    ('COM-094', 'PRD-001', 'LOC-001', 'CLI-001', '2026-05-01 10:00:00', 10000, 25000000, 'EMP-040');

-- trigger fn_comercializacion_valida: producto sin registro en producto_local para ese local
INSERT INTO comercializacion (id_comercializacion, id_producto, id_local, id_cliente, fecha_venta, cantidad_vendida, valor_venta, empleado) VALUES
    ('COM-093', 'PRD-003', 'LOC-001', 'CLI-001', '2026-05-01 10:00:00', 10, 21000, 'EMP-040');
