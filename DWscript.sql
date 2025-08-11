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
	ProductID		INT NOT NULL, --Llave de negocio
	ProductoSKU		VARCHAR(25) NOT NULL,
	Nombre			VARCHAR(50) NOT NULL,
	Categoria		VARCHAR(50)NOT NULL,
	GrupoItem		VARCHAR(50) NOT NULL,
	Demografica		VARCHAR(50) NOT NULL,
	Precio			FLOAT NOT NULL DEFAULT(0),
	TipoKit			CHAR(3) NOT NULL,
	Canales			TINYINT NOT NULL
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
)
GO

-- Creacion de FactVentas
CREATE TABLE FactVentas
(
	EstadoKey 		INT NOT NULL FOREIGN KEY REFERENCES DimEstado(EstadoKey),
	ProductoKey 	INT NOT NULL FOREIGN KEY REFERENCES DimProducto(ProductoKey),
	FechaOrdenKey 	INT NOT NULL FOREIGN KEY REFERENCES DimTiempo(TiempoKey),
	FechaEnvioKey 	INT NOT NULL FOREIGN KEY REFERENCES DimTiempo(TiempoKey),
	Cantidad 		INT NOT NULL,
	PrecioUnitario 	FLOAT NOT NULL,
	Descuento 		FLOAT NOT NULL,
	NumeroOrden 	VARCHAR(20) NOT NULL,
	CodigoPromocion VARCHAR(20) NOT NULL,
)
GO
