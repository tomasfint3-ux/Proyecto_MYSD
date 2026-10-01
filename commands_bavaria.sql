-- cambios
ALTER TABLE importacion RENAME COLUMN id_proveer TO id_proveedor;
ALTER TABLE pago ADD COLUMN monto int;
ALTER TABLE factura ALTER COLUMN id_cliente TYPE varchar(10) USING id_cliente::varchar(10);

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
  id_proveer int
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
\dt

-- tablas intermedias
CREATE TABLE detalle_importacion_produccion (id_importacion int, lote varchar(15), cantidad_usada int);
CREATE TABLE detalle_produccion (lote varchar(15), id_producto varchar(15), cantidad_producida int);
CREATE TABLE producto_local (id_producto varchar(15), id_local varchar(15), cantidad_disponible int, fecha_llegada timestamp);

-- primary keys
ALTER TABLE proveedor ADD CONSTRAINT pk_proveedor PRIMARY KEY (id_proveedor);
ALTER TABLE importacion ADD CONSTRAINT pk_importacion PRIMARY KEY (id_importacion);
ALTER TABLE produccion ADD CONSTRAINT pk_produccion PRIMARY KEY (lote);
ALTER TABLE infraestructura ADD CONSTRAINT pk_infraestructura PRIMARY KEY (id_infraestructura);
ALTER TABLE costo_operativo ADD CONSTRAINT pk_costo_operativo PRIMARY KEY (id_costo);
ALTER TABLE calidad ADD CONSTRAINT pk_calidad PRIMARY KEY (id_control);
ALTER TABLE producto ADD CONSTRAINT pk_producto PRIMARY KEY (id_producto);
ALTER TABLE inventario ADD CONSTRAINT pk_inventario PRIMARY KEY (id_inventario);
ALTER TABLE distribucion ADD CONSTRAINT pk_distribucion PRIMARY KEY (id_distribucion);
ALTER TABLE transporte ADD CONSTRAINT pk_transporte PRIMARY KEY (id_transporte);
ALTER TABLE ruta ADD CONSTRAINT pk_ruta PRIMARY KEY (id_ruta);
ALTER TABLE local ADD CONSTRAINT pk_local PRIMARY KEY (id_local);
ALTER TABLE comercializacion ADD CONSTRAINT pk_comercializacion PRIMARY KEY (id_comercializacion);
ALTER TABLE cliente ADD CONSTRAINT pk_cliente PRIMARY KEY (id_cliente);
ALTER TABLE factura ADD CONSTRAINT pk_factura PRIMARY KEY (id_factura);
ALTER TABLE pago ADD CONSTRAINT pk_pago PRIMARY KEY (id_pago);
ALTER TABLE detalle_importacion_produccion ADD CONSTRAINT pk_dip PRIMARY KEY (id_importacion, lote);
ALTER TABLE detalle_produccion ADD CONSTRAINT pk_dp PRIMARY KEY (lote, id_producto);
ALTER TABLE producto_local ADD CONSTRAINT pk_pl PRIMARY KEY (id_producto, id_local);

-- unique keys
ALTER TABLE proveedor ADD CONSTRAINT uk_proveedor_nit UNIQUE (nit);
ALTER TABLE producto ADD CONSTRAINT uk_producto_sku UNIQUE (codigo_sku);
ALTER TABLE cliente ADD CONSTRAINT uk_cliente_documento UNIQUE (documento);

-- foreign keys
ALTER TABLE produccion ADD CONSTRAINT fk_produccion_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor);
ALTER TABLE produccion ADD CONSTRAINT fk_produccion_infraestructura FOREIGN KEY (id_infraestructura) REFERENCES infraestructura(id_infraestructura);
ALTER TABLE costo_operativo ADD CONSTRAINT fk_costo_produccion FOREIGN KEY (lote) REFERENCES produccion(lote);
ALTER TABLE calidad ADD CONSTRAINT fk_calidad_produccion FOREIGN KEY (lote) REFERENCES produccion(lote);
ALTER TABLE importacion ADD CONSTRAINT fk_importacion_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor);
ALTER TABLE inventario ADD CONSTRAINT fk_inventario_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto);
ALTER TABLE inventario ADD CONSTRAINT fk_inventario_infraestructura FOREIGN KEY (id_infraestructura) REFERENCES infraestructura(id_infraestructura);
ALTER TABLE distribucion ADD CONSTRAINT fk_distribucion_inventario FOREIGN KEY (id_inventario) REFERENCES inventario(id_inventario);
ALTER TABLE transporte ADD CONSTRAINT fk_transporte_distribucion FOREIGN KEY (id_distribucion) REFERENCES distribucion(id_distribucion);
ALTER TABLE transporte ADD CONSTRAINT fk_transporte_ruta FOREIGN KEY (id_ruta) REFERENCES ruta(id_ruta);
ALTER TABLE ruta ADD CONSTRAINT fk_ruta_local FOREIGN KEY (id_local) REFERENCES local(id_local);
ALTER TABLE comercializacion ADD CONSTRAINT fk_comercializacion_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto);
ALTER TABLE comercializacion ADD CONSTRAINT fk_comercializacion_local FOREIGN KEY (id_local) REFERENCES local(id_local);
ALTER TABLE comercializacion ADD CONSTRAINT fk_comercializacion_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente);
ALTER TABLE factura ADD CONSTRAINT fk_factura_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente);
ALTER TABLE pago ADD CONSTRAINT fk_pago_factura FOREIGN KEY (id_factura) REFERENCES factura(id_factura);
ALTER TABLE detalle_importacion_produccion ADD CONSTRAINT fk_dip_importacion FOREIGN KEY (id_importacion) REFERENCES importacion(id_importacion);
ALTER TABLE detalle_importacion_produccion ADD CONSTRAINT fk_dip_produccion FOREIGN KEY (lote) REFERENCES produccion(lote);
ALTER TABLE detalle_produccion ADD CONSTRAINT fk_dp_produccion FOREIGN KEY (lote) REFERENCES produccion(lote);
ALTER TABLE detalle_produccion ADD CONSTRAINT fk_dp_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto);
ALTER TABLE producto_local ADD CONSTRAINT fk_pl_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto);
ALTER TABLE producto_local ADD CONSTRAINT fk_pl_local FOREIGN KEY (id_local) REFERENCES local(id_local);

-- nulidades (solo FK obligatorias; produccion.id_proveedor queda opcional)
ALTER TABLE produccion ALTER COLUMN id_infraestructura SET NOT NULL;
ALTER TABLE costo_operativo ALTER COLUMN lote SET NOT NULL;
ALTER TABLE calidad ALTER COLUMN lote SET NOT NULL;
ALTER TABLE importacion ALTER COLUMN id_proveedor SET NOT NULL;
ALTER TABLE inventario ALTER COLUMN id_producto SET NOT NULL;
ALTER TABLE inventario ALTER COLUMN id_infraestructura SET NOT NULL;
ALTER TABLE distribucion ALTER COLUMN id_inventario SET NOT NULL;
ALTER TABLE transporte ALTER COLUMN id_distribucion SET NOT NULL;
ALTER TABLE transporte ALTER COLUMN id_ruta SET NOT NULL;
ALTER TABLE ruta ALTER COLUMN id_local SET NOT NULL;
ALTER TABLE comercializacion ALTER COLUMN id_producto SET NOT NULL;
ALTER TABLE comercializacion ALTER COLUMN id_local SET NOT NULL;
ALTER TABLE comercializacion ALTER COLUMN id_cliente SET NOT NULL;
ALTER TABLE factura ALTER COLUMN id_cliente SET NOT NULL;
ALTER TABLE pago ALTER COLUMN id_factura SET NOT NULL;