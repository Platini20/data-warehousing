/* 1) Base de données */
CREATE DATABASE RetailDB;
GO
USE RetailDB;
GO

/* 2) Dimensions */

/* 2.1 DimDate (dérivée de la colonne Date + Season existante) */
CREATE TABLE dbo.DimDate (
    DateKey INT NOT NULL PRIMARY KEY,   -- ex: 2022012106 (AAAA MM JJ HH)
    [Date]  DATE NOT NULL,              -- 2022-01-21
    [Year]  SMALLINT NOT NULL,          -- 2022
    [Month] TINYINT NOT NULL,           -- 1..12
    [Day]   TINYINT NOT NULL,           -- 1..31
    [Hour]  TINYINT NOT NULL,           -- 0..23
    Season  NVARCHAR(20) NOT NULL       -- ex: Winter, Spring, etc.
);
GO


/* 2.2 DimCustomer (depuis Customer_Name, Customer_Category, City) */
CREATE TABLE dbo.DimCustomer (
  CustomerKey        INT IDENTITY(1,1) PRIMARY KEY,
  Customer_Name      NVARCHAR(150) NOT NULL,
  Customer_Category  NVARCHAR(50)  NULL,   -- ex: Regular, VIP, Student...
  City               NVARCHAR(100) NULL
);
CREATE UNIQUE INDEX UX_DimCustomer_BusinessKey
  ON dbo.DimCustomer(Customer_Name, Customer_Category, City);

    

/* 2.3 DimProduct (depuis Product) */
CREATE TABLE dbo.DimProduct (
  ProductKey   INT IDENTITY(1,1) PRIMARY KEY,
  Product      NVARCHAR(200) NOT NULL
);
CREATE UNIQUE INDEX UX_DimProduct_Product ON dbo.DimProduct(Product);

/* 2.4 DimStore (depuis Store_Type, City) */
CREATE TABLE dbo.DimStore (
  StoreKey    INT IDENTITY(1,1) PRIMARY KEY,
  Store_Type  NVARCHAR(100) NOT NULL,   -- ex: Supermarket, Convenience, Online...
  City        NVARCHAR(100) NULL
);

-- 2) Colonne calculée City_NN (si pas déjà là)
IF COL_LENGTH('dbo.DimStore','City_NN') IS NULL
  ALTER TABLE dbo.DimStore
    ADD City_NN AS ISNULL(City, N'') PERSISTED;

-- 3) Index unique corrigé
CREATE UNIQUE INDEX UX_DimStore_BusinessKey
  ON dbo.DimStore(Store_Type, City_NN);

/* 2.5 DimPayment (depuis Payment_Method) */
CREATE TABLE dbo.DimPayment (
  PaymentKey     INT IDENTITY(1,1) PRIMARY KEY,
  Payment_Method NVARCHAR(50) NOT NULL   -- ex: Credit Card, Cash, Debit...
);
CREATE UNIQUE INDEX UX_DimPayment_Method ON dbo.DimPayment(Payment_Method);

/* 2.6 DimPromotion (compacte : No Promotion / Discount on Selected Items / BOGO) */
CREATE TABLE dbo.DimPromotion (
  PromotionKey   INT IDENTITY(1,1) PRIMARY KEY,
  PromotionType  NVARCHAR(100) NOT NULL,  -- 'No Promotion' | 'Discount on Selected Items' | 'BOGO (Buy One Get One)'
  DiscountFlag   BIT NOT NULL,            -- 1 si un rabais a effectivement été appliqué, sinon 0
  Description    NVARCHAR(200) NULL
);
CREATE UNIQUE INDEX UX_DimPromotion_TypeFlag
  ON dbo.DimPromotion(PromotionType, DiscountFlag);

/* 3) Table de faits (grain = une transaction) */
CREATE TABLE dbo.FactSales (
  SalesKey       BIGINT IDENTITY(1,1) PRIMARY KEY,

  DateKey        INT          NOT NULL
    FOREIGN KEY REFERENCES dbo.DimDate(DateKey),

  CustomerKey    INT          NULL   -- peut être NOT NULL si toutes les lignes ont un client
    FOREIGN KEY REFERENCES dbo.DimCustomer(CustomerKey),

  ProductKey     INT          NOT NULL
    FOREIGN KEY REFERENCES dbo.DimProduct(ProductKey),

  StoreKey       INT          NULL    -- peut être NOT NULL si toujours connu
    FOREIGN KEY REFERENCES dbo.DimStore(StoreKey),

  PaymentKey     INT          NULL
    FOREIGN KEY REFERENCES dbo.DimPayment(PaymentKey),

  PromotionKey   INT          NOT NULL
    FOREIGN KEY REFERENCES dbo.DimPromotion(PromotionKey),

  /* Dégénérée : identifiant de transaction d’origine pour traçabilité */
  Transaction_ID NVARCHAR(64) NULL,

  /* Mesures (depuis ton dataset) */
  Total_Items    INT             NOT NULL,
  Total_Cost     DECIMAL(18,2)   NOT NULL,

  /* Mesure dérivée (optionnelle) — si tu veux la persister */
  Net_Sales      AS (Total_Cost) PERSISTED,  -- ajuster si un montant de remise existe ailleurs

  /* Métadonnées de chargement ETL */
  LoadTS         DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);

/* 4) Index pour ROLAP (slices/dice/rollup/drill) */
CREATE INDEX IX_FactSales_Date     ON dbo.FactSales(DateKey);
CREATE INDEX IX_FactSales_Product  ON dbo.FactSales(ProductKey);
CREATE INDEX IX_FactSales_Customer ON dbo.FactSales(CustomerKey);
CREATE INDEX IX_FactSales_Store    ON dbo.FactSales(StoreKey);
CREATE INDEX IX_FactSales_Payment  ON dbo.FactSales(PaymentKey);
CREATE INDEX IX_FactSales_Promo    ON dbo.FactSales(PromotionKey);
CREATE INDEX IX_FactSales_Txn      ON dbo.FactSales(Transaction_ID);
