USE RetailDB;
GO

---------------------------------------------------
-- 0. Supprimer la table de faits (enlève les FKs)
---------------------------------------------------
IF OBJECT_ID('dbo.FactSales', 'U') IS NOT NULL
    DROP TABLE dbo.FactSales;
GO

---------------------------
-- DIMDATE (jour seulement)
---------------------------
IF OBJECT_ID('dbo.DimDate', 'U') IS NOT NULL
    DROP TABLE dbo.DimDate;
GO

CREATE TABLE dbo.DimDate (
    DateKey INT NOT NULL PRIMARY KEY,  -- ex : 20220121
    [Date]  DATE NOT NULL,
    [Year]  SMALLINT NOT NULL,
    [Month] TINYINT NOT NULL,
    [Day]   TINYINT NOT NULL
    -- plus de Season ici
);
GO


---------------------------
-- DIMCUSTOMER
---------------------------
IF OBJECT_ID('dbo.DimCustomer', 'U') IS NOT NULL
    DROP TABLE dbo.DimCustomer;
GO

CREATE TABLE dbo.DimCustomer (
    CustomerKey        INT IDENTITY(1,1) PRIMARY KEY,
    Customer_Name      NVARCHAR(150) NOT NULL,
    Customer_Category  NVARCHAR(50)  NOT NULL,
    City               NVARCHAR(100) NOT NULL
);
GO

---------------------------
-- DIMPRODUCT
---------------------------
IF OBJECT_ID('dbo.DimProduct', 'U') IS NOT NULL
    DROP TABLE dbo.DimProduct;
GO

CREATE TABLE dbo.DimProduct (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    Product    NVARCHAR(200) NOT NULL
);
GO

---------------------------
-- DIMSTORE
---------------------------
IF OBJECT_ID('dbo.DimStore', 'U') IS NOT NULL
    DROP TABLE dbo.DimStore;
GO

CREATE TABLE dbo.DimStore (
    StoreKey   INT IDENTITY(1,1) PRIMARY KEY,
    Store_Type NVARCHAR(100) NOT NULL,
    City       NVARCHAR(100) NOT NULL
);
GO

---------------------------
-- DIMPAYMENT
---------------------------
IF OBJECT_ID('dbo.DimPayment', 'U') IS NOT NULL
    DROP TABLE dbo.DimPayment;
GO

CREATE TABLE dbo.DimPayment (
    PaymentKey     INT IDENTITY(1,1) PRIMARY KEY,
    Payment_Method NVARCHAR(50) NOT NULL
);
GO

---------------------------
-- DIMPROMOTION
---------------------------
IF OBJECT_ID('dbo.DimPromotion', 'U') IS NOT NULL
    DROP TABLE dbo.DimPromotion;
GO

CREATE TABLE dbo.DimPromotion (
    PromotionKey   INT IDENTITY(1,1) PRIMARY KEY,
    PromotionType  NVARCHAR(100) NOT NULL,
    DiscountFlag   BIT           NOT NULL,
    [Description]  NVARCHAR(255) NULL
);
GO
