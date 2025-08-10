# Proyecto de consturccion data warehouse y procesos ETL

En este proyecto se desarrolla la construccion de un data warehouse y procesos ETL para el analis de datos sobre el proceso de ventas para la empresa **Tailspin Toys**

## Tablas en la base de datos transaccional

Las siguientes son las tablas que podemos encontrar en la base de datos transaccional de la empresa

1. Sales
2. Product
3. Region
4. State
5. SalesOffice
6. zzVersion

De las tablas anteriores se descartaron las siguientes por no proporcionar informacion de valor al proceso de negocio

- SalesOffice
  - Esta tabla no contiene ningun registro
- zzVersion
  - No es claro al ver la informacion contenida en esta tabla, que tipo de version se esta almacenando. Ademas no existe ningun vinculo con el resto de la informacion

===

## Analisis dimensional

A continacion se encuentra el desarrollo del analisis dimensional para la creacion del data warehouse para el analisis de

Proceso para desarrollar el disenio dimensional

1. Proceso de negocio
2. Seleccion de granularidad
3. Definicion de dimensiones
4. Definicion de metricas

### 1 PROCESO DE NEGOCIO

Se utilizara como proceso de negocio las ventas registradas en la base de datos TailSpinToys. Dichas ventas son relativas específicamente a la venta de juguetes.

### 2 SELECCION DE GRANULARIDAD

Se toma como criterio la granularidad mas atomica a la cualpodamos acceder sin que la información deje de ser util.La tabla Sales en este caso es la única tabla de la cualpodemos obtener fechas y podemos darnos cuenta de quetenemos un atributo de tipo Date el cual nos permite relacionarcorrectamente con una granularidad "por dia"

### 3 DEFINICION DE DIMENSIONES

En el siguiente apartado se determinan los atributos para ser utilizados en las dimensiones de acuerdo a las tablas contenidas en la base de datos transaccional

**DimTiempo:** Requerida para analizar las ventas por periodos de tiempo

- TiempoKey (Llave surrogada)
- Fecha
- Dia
- Mes
- Anio

**DimProducto:** De esta dimension podemos obtener una gran cantidad de atributos importantes para las ventas

- ProductoKey (Llave surrogada)
- ProductID -> ProductID (Llave de negocio)
- ProductSKU -> ProductoSKU
- ProductName -> Nombre
- ProductCategory -> Categoria
- ItemGroup -> GrupoItem
- Demographic -> Demografica
- Retail price -> Precio
- Kit type -> TipoKit
- Channels -> Canales

**DimEstado:** De esta dimension podemos obtener informacion geografica de las transacciones

- RegionKey (Llave surrogada)
- RegionID -> RegionID (Llave de negocio)
- State name -> Nombre
- Regio Name -> NombreRegion
- TimeZone -> ZonaHoraria

### 4 DEFINICION DE METRICAS

- EstadoKey
- ProductoKey
- FechaOrdenKey
- FechaEnvioKey
- Cantidad
- PrecioUnitario
- Descuento
- CodigoPromocion
- NumeroOrden
