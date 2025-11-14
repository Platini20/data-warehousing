-- Créer la base
CREATE DATABASE RetailDW;
GO
USE RetailDW;
GO

-- Tables de dimensions
CREATE TABLE dbo.DimDate (
  DateKey        INT        NOT NULL PRIMARY KEY, -- yyyymmdd
  [Date]         DATE       NOT NULL,
  DayOfWeekNum   TINYINT    NOT NULL,
  DayOfWeekName  NVARCHAR(20) NOT NULL,
  DayInMonth     TINYINT    NOT NULL,
  WeekInYear     TINYINT    NOT NULL,
  MonthNum       TINYINT    NOT NULL,
  MonthName      NVARCHAR(20) NOT NULL,
  QuarterNum     TINYINT    NOT NULL,
  YearNum        SMALLINT   NOT NULL
);

CREATE TABLE dbo.DimCustomer (
  CustomerKey    INT IDENTITY(1,1) PRIMARY KEY,
  CustomerCode   NVARCHAR(64) NOT NULL UNIQUE,
  FullName       NVARCHAR(150) NULL,
  Gender         NVARCHAR(10) NULL,
  Age            INT NULL,
  City           NVARCHAR(100) NULL,
  Region         NVARCHAR(100) NULL,
  Country        NVARCHAR(100) NULL
);

CREATE TABLE dbo.DimProduct (
  ProductKey     INT IDENTITY(1,1) PRIMARY KEY,
  SKU            NVARCHAR(64) NOT NULL UNIQUE,
  ProductName    NVARCHAR(200) NULL,
  Category       NVARCHAR(100) NULL,
  SubCategory    NVARCHAR(100) NULL,
  Brand          NVARCHAR(100) NULL
);

CREATE TABLE dbo.DimStore (
  StoreKey       INT IDENTITY(1,1) PRIMARY KEY,
  StoreCode      NVARCHAR(64) NOT NULL UNIQUE,
  StoreName      NVARCHAR(200) NULL,
  Channel        NVARCHAR(50)  NULL,  -- online, in-store, etc.
  City           NVARCHAR(100) NULL,
  Region         NVARCHAR(100) NULL,
  Country        NVARCHAR(100) NULL
);

CREATE TABLE dbo.DimPromotion (
  PromotionKey   INT IDENTITY(1,1) PRIMARY KEY,
  PromotionCode  NVARCHAR(64) NULL,
  PromotionType  NVARCHAR(100) NULL,
  DiscountPct    DECIMAL(5,2)  NULL,
  Description    NVARCHAR(200) NULL
);

CREATE TABLE dbo.DimPayment (
  PaymentKey     INT IDENTITY(1,1) PRIMARY KEY,
  PaymentMethod  NVARCHAR(50) NOT NULL  -- Cash, CreditCard, etc.
);

-- Table de faits
CREATE TABLE dbo.FactSales (
  SalesKey       BIGINT IDENTITY(1,1) PRIMARY KEY,
  DateKey        INT           NOT NULL FOREIGN KEY REFERENCES dbo.DimDate(DateKey),
  CustomerKey    INT           NULL FOREIGN KEY REFERENCES dbo.DimCustomer(CustomerKey),
  ProductKey     INT           NOT NULL FOREIGN KEY REFERENCES dbo.DimProduct(ProductKey),
  StoreKey       INT           NULL FOREIGN KEY REFERENCES dbo.DimStore(StoreKey),
  PromotionKey   INT           NULL FOREIGN KEY REFERENCES dbo.DimPromotion(PromotionKey),
  PaymentKey     INT           NULL FOREIGN KEY REFERENCES dbo.DimPayment(PaymentKey),

  -- Dégénérées
  TransactionID  NVARCHAR(64)  NULL,
  LineNumber     INT           NULL,

  -- Mesures
  Quantity       DECIMAL(18,4) NOT NULL,
  UnitPrice      DECIMAL(18,4) NOT NULL,
  DiscountAmount DECIMAL(18,4) NULL,
  ExtendedAmount AS (Quantity * UnitPrice - ISNULL(DiscountAmount,0)) PERSISTED,

  -- Métadonnées
  LoadTS         DATETIME2(3)  NOT NULL DEFAULT SYSUTCDATETIME()
);

-- Index pour accélérer ROLAP
CREATE INDEX IX_FactSales_Date ON dbo.FactSales(DateKey);
CREATE INDEX IX_FactSales_Product ON dbo.FactSales(ProductKey);
CREATE INDEX IX_FactSales_Customer ON dbo.FactSales(CustomerKey);
CREATE INDEX IX_FactSales_Store ON dbo.FactSales(StoreKey);
