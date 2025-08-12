/*
	Autor: Luis Fernando Sorto Merino
	Curso de Especializacion en ingenieria de datos
	DW para analisis de ventas Tailspin Toys
*/

-- Limpieza de la BD en caso de que existan otras con el mismo nombre
USE master;
GO

IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = N'DWVentasTailspinToys'
)
BEGIN
    ALTER DATABASE DWVentasTailspinToys SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DWVentasTailspinToys;
END

-- Creacion de la base de datos
CREATE DATABASE DWVentasTailspinToys;
GO

USE DWVentasTailspinToys
GO

-- Creacion de DimTiempo
CREATE TABLE DimTiempo
(
	TiempoKey		INT PRIMARY KEY, --Llave surrogada
	Fecha			DATETIME NOT NULL,
	Dia				TINYINT NOT NULL,
	Mes				TINYINT NOT NULL,
	Anio			SMALLINT NOT NULL
)
GO

-- Creacion de DimProducto
CREATE TABLE DimProducto
(
	ProductoKey		INT PRIMARY KEY IDENTITY(1,1), --Llave surrogada
	ProductoID		INT NOT NULL, --Llave de negocio
	ProductoSKU		VARCHAR(50) NOT NULL,
	Nombre			VARCHAR(50) NOT NULL,
	Categoria		VARCHAR(50)NOT NULL,
	Grupo			VARCHAR(50) NOT NULL,
	Demografica		VARCHAR(50) NOT NULL,
	Precio			FLOAT NOT NULL DEFAULT(0),
	TipoKit			VARCHAR(20) NOT NULL,
	Canales			TINYINT NOT NULL,
	Activo 			BIT NOT NULL DEFAULT 1,
	FechaInicio 	DATETIME NOT NULL DEFAULT GETDATE(),
	FechaFin 		DATETIME NULL
)
GO

-- Creacion de DimRegion
CREATE TABLE DimEstado
(
	EstadoKey		INT PRIMARY KEY IDENTITY(1,1), --Llave surrogada
	EstadoID		INT NOT NULL, -- Llave de negocio
	Nombre			VARCHAR(50) NOT NULL,
	NombreRegion 	VARCHAR(50) NOT NULL,
	ZonaHoraria		VARCHAR(30) NOT NULL,
	Activo 			BIT NOT NULL DEFAULT 1,
	FechaInicio 	DATETIME NOT NULL DEFAULT GETDATE(),
	FechaFin 		DATETIME NULL
)
GO

-- Creacion de DimPromocion
CREATE TABLE DimPromocion(
	PromocionKey 	INT PRIMARY KEY IDENTITY(1,1),
	CodigoPromocion	NVARCHAR(30) NOT NULL,
)

-- Creacion de FactVentas
CREATE TABLE FactVentas
(
	EstadoClienteKey 		INT NOT NULL FOREIGN KEY REFERENCES DimEstado(EstadoKey),
	ProductoKey 			INT NOT NULL FOREIGN KEY REFERENCES DimProducto(ProductoKey),
	FechaOrdenKey 			INT NOT NULL FOREIGN KEY REFERENCES DimTiempo(TiempoKey),
	FechaEnvioKey 			INT NOT NULL FOREIGN KEY REFERENCES DimTiempo(TiempoKey),
	PromocionKey 			INT NOT NULL FOREIGN KEY REFERENCES DimPromocion(PromocionKey),
	Cantidad 				INT NOT NULL,
	PrecioUnitario 			FLOAT NOT NULL,
	Descuento 				FLOAT NOT NULL,
	TotalLinea				FLOAT NOT NULL,
	NumeroOrden 			VARCHAR(20) NOT NULL,
)
GO


/*
/	=========================================
/	CREACION DE PROCESOS ALMACENADOS PARA ETL
/	=========================================
*/


CREATE OR ALTER PROCEDURE ActualizarEstado
(
	@EstadoKey		INT,
	@Nombre			VARCHAR(50),
	@NombreRegion	VARCHAR(50),
	@ZonaHoraria	VARCHAR(30)
) AS
BEGIN
	DECLARE
		@NombreActual		VARCHAR(100),
		@NombreRegionActual VARCHAR(100),
		@ZonaHorariaActual	VARCHAR(100),
		@EstadoID 			INT;

	SELECT
		@NombreActual = Nombre,
		@NombreRegionActual = NombreRegion,
		@ZonaHorariaActual = ZonaHoraria,
		@EstadoID = EstadoID
	FROM 
		DimEstado
	WHERE
		EstadoKey = @EstadoKey

	IF 
	(
		@NombreActual<>@Nombre OR
		@NombreRegionActual<>@NombreRegion OR
		@ZonaHorariaActual<>@ZonaHoraria
	)
	BEGIN
		UPDATE DimEstado SET Activo=0, FechaFin=getdate() WHERE EstadoKey = @EstadoKey

		INSERT INTO DimEstado
		(
			EstadoID, 
			Nombre, 
			NombreRegion, 
			ZonaHoraria
		)
		VALUES
		(
			@EstadoID, 
			@Nombre, 
			@NombreRegion,
			@ZonaHoraria
		)
	END
END
GO



CREATE OR ALTER PROCEDURE ActualizarProducto
(
	@ProductoKey		INT, 
	@ProductoSKU	VARCHAR(50),
	@NombreProd		VARCHAR(50),
	@Categoria		VARCHAR(50),
	@Grupo			VARCHAR(50),
	@Demografica	VARCHAR(50),
	@Precio			FLOAT,
	@TipoKit		VARCHAR(20),
	@Canales		TINYINT
) AS
BEGIN
	DECLARE
		@ProductoSKUActual	VARCHAR(50),
		@NombreProdActual	VARCHAR(50),
		@CategoriaActual	VARCHAR(50),
		@GrupoActual		VARCHAR(50),
		@DemograficaActual	VARCHAR(50),
		@PrecioActual		FLOAT,
		@TipoKitActual		VARCHAR(20),
		@CanalesActual		TINYINT,
		@ProductoID			INT;

	SELECT 
		@ProductoSKUActual=ProductoSKU,
		@NombreProdActual=Nombre,
		@CategoriaActual=Categoria,
		@GrupoActual=Grupo,
		@DemograficaActual=Demografica,
		@PrecioActual=Precio,
		@TipoKitActual=TipoKit,
		@CanalesActual=Canales,
		@ProductoID=ProductoID	
	FROM 
		DimProducto
	WHERE
		ProductoKey = @ProductoKey

	IF 
	(
		@ProductoSKUActual<>@ProductoSKU OR
		@NombreProdActual<>@NombreProd OR
		@CategoriaActual<>@Categoria OR
		@GrupoActual<>@Grupo OR
		@DemograficaActual<>@Demografica OR
		@PrecioActual<>@Precio OR
		@TipoKitActual<>@TipoKit OR
		@CanalesActual<>@Canales
	)
	BEGIN
		UPDATE DimProducto SET Activo=0, FechaFin=getdate() WHERE ProductoKey = @ProductoKey

		INSERT INTO DimProducto
		(
			ProductoID,
			ProductoSKU,
			Nombre,
			Categoria,
			Grupo,
			Demografica,
			Precio,
			TipoKit,
			Canales
		)
		VALUES
		(
			@ProductoID,
			@ProductoSKU,
			@NombreProd,
			@Categoria,
			@Grupo,
			@Demografica,
			@Precio,
			@TipoKit,
			@Canales
		)
	END
END
GO
