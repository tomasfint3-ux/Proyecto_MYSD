/* tabla de producción*/
create table produccion(
  lote varchar(15),
  estado boolean,
  cantidad_total int,
  id_proveedor int,
  id_infraestructura varchar(15),
  fecha_produccion timestamp,
  empleado varchar(10)
);

/*tabla producto*/
create table producto(
  id_producto varchar(15),
  nombre text,
  categoria text,
  precio_unitario int,
  codigo_sku varchar(15)
);

/*tabla infraestructura*/
create table infraestructura(
  id_infraestructura varchar(15),
  tipo_infraestructura text,
  disponibilidad text,
  direccion text,
  capacidad int
);

/*tabla costo_operativo*/
create table costo_operativo(
  id_costo int,
  tipo_costo text,
  valor int,
  fecha timestamp,
  lote varchar(15)
);

/*tabla calidad*/
create table calidad(
  id_control int,
  puntuacion int,
  empleado text,
  fecha_control timestamp,
  lote varchar(15)
);

/*tabla proveedor*/
create table proveedor(
  id_proveedor int,
  nombre text,
  nit int,
  direccion text,
  pais_origen text
);

/*tabla importacion*/
create table importacion(
  id_importacion int,
  fecha_importacion timestamp,
  transportista text,
  arancel int,
  id_proveedor int
);

/*tabla inventario*/
create table inventario(
  id_inventario varchar(20),
  id_producto varchar(15),
  cantidad int,
  id_infraestructura varchar(15),
  fecha_actualizacion timestamp,
  empleado text
);

/*tabla distribucion*/
create table distribucion(
  id_distribucion varchar(15),
  id_inventario varchar(20),
  fecha_salida timestamp,
  fecha_llegada timestamp,
  cantidad_enviada int,
  empleado text
);

/*tabla transporte*/
create table transporte(
  id_transporte varchar(15),
  conductor text,
  vehiculo text,
  id_distribucion varchar(15),
  id_ruta varchar(15)
);

/*tabla ruta*/
create table ruta(
  id_ruta varchar(15),
  id_local varchar(15),
  distancia int,
  duracion int
);

/*tabla local*/
create table local(
  id_local varchar(15),
  nombre text,
  direccion text,
  ciudad text,
  dueño text,
  tipo_local text
);

/*tabla comercializacion*/
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

/*tabla cliente*/
create table cliente(
  id_cliente varchar(10),
  nombre text,
  documento int,
  direccion text,
  telefono int
);

/*tabla pago*/
create table pago(
  id_pago int,
  id_factura int,
  fecha_pago timestamp,
  metodo_pago text
);

/*tabla factura*/
create table factura(
  id_factura int,
  id_cliente int,
  fecha timestamp,
  total float
);


-- tablas intermedias
CREATE TABLE detalle_importacion_produccion (
    id_importacion int,
    lote varchar(15), 
    cantidad_usada int
);

CREATE TABLE detalle_produccion (
    lote varchar(15), 
    id_producto varchar(15), 
    cantidad_producida int
);
CREATE TABLE producto_local (
    id_producto varchar(15),
    id_local varchar(15), 
    cantidad_disponible int, 
    fecha_llegada timestamp
);

-- primary keys
ALTER TABLE proveedor
    ADD CONSTRAINT pk_proveedor 
    PRIMARY KEY (id_proveedor);

ALTER TABLE importacion 
    ADD CONSTRAINT pk_importacion 
    PRIMARY KEY (id_importacion);

ALTER TABLE produccion 
    ADD CONSTRAINT pk_produccion 
    PRIMARY KEY (lote);

ALTER TABLE infraestructura 
    ADD CONSTRAINT pk_infraestructura 
    PRIMARY KEY (id_infraestructura);

ALTER TABLE costo_operativo 
    ADD CONSTRAINT pk_costo_operativo 
    PRIMARY KEY (id_costo);

ALTER TABLE calidad 
    ADD CONSTRAINT pk_calidad 
    PRIMARY KEY (id_control);

ALTER TABLE producto 
    ADD CONSTRAINT pk_producto 
    PRIMARY KEY (id_producto);

ALTER TABLE inventario 
    ADD CONSTRAINT pk_inventario 
    PRIMARY KEY (id_inventario);

ALTER TABLE distribucion 
    ADD CONSTRAINT pk_distribucion 
    PRIMARY KEY (id_distribucion);

ALTER TABLE transporte 
    ADD CONSTRAINT pk_transporte 
    PRIMARY KEY (id_transporte);

ALTER TABLE ruta 
    ADD CONSTRAINT pk_ruta 
    PRIMARY KEY (id_ruta);

ALTER TABLE local 
    ADD CONSTRAINT pk_local 
    PRIMARY KEY (id_local);

ALTER TABLE comercializacion 
    ADD CONSTRAINT pk_comercializacion 
    PRIMARY KEY (id_comercializacion);

ALTER TABLE cliente 
    ADD CONSTRAINT pk_cliente 
    PRIMARY KEY (id_cliente);

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

-- nulidades (solo FK obligatorias; produccion.id_proveedor queda opcional)
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

ALTER TABLE transporte 
    ALTER COLUMN id_distribucion SET NOT NULL;

ALTER TABLE transporte 
    ALTER COLUMN id_ruta SET NOT NULL;

ALTER TABLE ruta 
    ALTER COLUMN id_local SET NOT NULL;

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

--triggers--


--validacion de stock y descuento de inventario--
CREATE OR REPLACE FUNCTION fn_distribucion_stock() RETURNS trigger AS $$
DECLARE v_stock int;
BEGIN
  SELECT cantidad INTO v_stock FROM inventario
  WHERE id_inventario = NEW.id_inventario FOR UPDATE;

  IF v_stock IS NULL OR NEW.cantidad_enviada > v_stock THEN
    RAISE EXCEPTION 'Stock insuficiente en inventario %: disponible %, solicitado %',
      NEW.id_inventario, COALESCE(v_stock,0), NEW.cantidad_enviada;
  END IF;

  UPDATE inventario
  SET cantidad = cantidad - NEW.cantidad_enviada,
      fecha_actualizacion = now()
  WHERE id_inventario = NEW.id_inventario;
  RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_distribucion_stock
BEFORE INSERT ON distribucion
FOR EACH ROW EXECUTE FUNCTION fn_distribucion_stock();

--verificacion del total de la factura--
CREATE OR REPLACE FUNCTION fn_pago_limite() RETURNS trigger AS $$
DECLARE v_total float; v_pagado numeric;
BEGIN
  SELECT total INTO v_total FROM factura WHERE id_factura = NEW.id_factura FOR UPDATE;
  SELECT COALESCE(SUM(monto),0) INTO v_pagado
  FROM pago WHERE id_factura = NEW.id_factura AND id_pago <> NEW.id_pago;

  IF v_pagado + NEW.monto > v_total THEN
    RAISE EXCEPTION 'El pago excede el saldo de la factura % (total %, pagado %)',
      NEW.id_factura, v_total, v_pagado;
  END IF;
  RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_pago_limite
BEFORE INSERT OR UPDATE ON pago
FOR EACH ROW EXECUTE FUNCTION fn_pago_limite();

--control para no superar la capacidad de la infraestructura--
CREATE OR REPLACE FUNCTION fn_inventario_capacidad() RETURNS trigger AS $$
DECLARE v_cap int; v_ocupado bigint;
BEGIN
  SELECT capacidad INTO v_cap FROM infraestructura
  WHERE id_infraestructura = NEW.id_infraestructura FOR UPDATE;
  SELECT COALESCE(SUM(cantidad),0) INTO v_ocupado FROM inventario
  WHERE id_infraestructura = NEW.id_infraestructura
    AND id_inventario <> NEW.id_inventario;

  IF v_ocupado + NEW.cantidad > v_cap THEN
    RAISE EXCEPTION 'Capacidad excedida en %: capacidad %, ocupado %, nuevo %',
      NEW.id_infraestructura, v_cap, v_ocupado, NEW.cantidad;
  END IF;
  RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inventario_capacidad
BEFORE INSERT OR UPDATE OF cantidad, id_infraestructura ON inventario
FOR EACH ROW EXECUTE FUNCTION fn_inventario_capacidad();

--la produccion no puede superar cantidad_total del lote--
CREATE OR REPLACE FUNCTION fn_detalle_produccion_total() RETURNS trigger AS $$
DECLARE v_total int; v_suma bigint;
BEGIN
  SELECT cantidad_total INTO v_total FROM produccion WHERE lote = NEW.lote FOR UPDATE;
  SELECT COALESCE(SUM(cantidad_producida),0) INTO v_suma FROM detalle_produccion
  WHERE lote = NEW.lote AND id_producto <> NEW.id_producto;

  IF v_suma + NEW.cantidad_producida > v_total THEN
    RAISE EXCEPTION 'El lote % excede su cantidad_total (%): ya asignado %, nuevo %',
      NEW.lote, v_total, v_suma, NEW.cantidad_producida;
  END IF;
  RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_detalle_produccion_total
BEFORE INSERT OR UPDATE ON detalle_produccion
FOR EACH ROW EXECUTE FUNCTION fn_detalle_produccion_total();

--validacion del stock en el local y el valor de la venta--
CREATE OR REPLACE FUNCTION fn_comercializacion_valida() RETURNS trigger AS $$
DECLARE v_precio int; v_disp int;
BEGIN
  SELECT precio_unitario INTO v_precio FROM producto WHERE id_producto = NEW.id_producto;
  IF NEW.valor_venta <> NEW.cantidad_vendida * v_precio THEN
    RAISE EXCEPTION 'valor_venta (%) no coincide con cantidad x precio (%)',
      NEW.valor_venta, NEW.cantidad_vendida * v_precio;
  END IF;

  SELECT cantidad_disponible INTO v_disp FROM producto_local
  WHERE id_producto = NEW.id_producto AND id_local = NEW.id_local FOR UPDATE;
  IF v_disp IS NULL OR v_disp < NEW.cantidad_vendida THEN
    RAISE EXCEPTION 'Stock insuficiente en el local % para el producto %',
      NEW.id_local, NEW.id_producto;
  END IF;

  UPDATE producto_local SET cantidad_disponible = cantidad_disponible - NEW.cantidad_vendida
  WHERE id_producto = NEW.id_producto AND id_local = NEW.id_local;
  RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_comercializacion_valida
BEFORE INSERT ON comercializacion
FOR EACH ROW EXECUTE FUNCTION fn_comercializacion_valida();
