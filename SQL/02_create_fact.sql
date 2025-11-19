USE RetailDB;
GO

IF OBJECT_ID('dbo.FactSales', 'U') IS NOT NULL
    DROP TABLE dbo.FactSales;
GO

CREATE TABLE dbo.FactSales (
    SalesKey       INT IDENTITY(1,1) PRIMARY KEY,
    DateKey        INT NOT NULL,
    CustomerKey    INT NOT NULL,
    ProductKey     INT NOT NULL,
    StoreKey       INT NOT NULL,
    PaymentKey     INT NOT NULL,
    PromotionKey   INT NOT NULL,
    Transaction_ID NVARCHAR(64) NOT NULL,
    Total_Items    INT NOT NULL,
    Total_Cost     DECIMAL(18,2) NOT NULL,
    HourInDay      TINYINT NOT NULL,  -- 0 à 23

    CONSTRAINT FK_FactSales_DimDate
        FOREIGN KEY (DateKey) REFERENCES dbo.DimDate(DateKey),
    CONSTRAINT FK_FactSales_DimCustomer
        FOREIGN KEY (CustomerKey) REFERENCES dbo.DimCustomer(CustomerKey),
    CONSTRAINT FK_FactSales_DimProduct
        FOREIGN KEY (ProductKey) REFERENCES dbo.DimProduct(ProductKey),
    CONSTRAINT FK_FactSales_DimStore
        FOREIGN KEY (StoreKey) REFERENCES dbo.DimStore(StoreKey),
    CONSTRAINT FK_FactSales_DimPayment
        FOREIGN KEY (PaymentKey) REFERENCES dbo.DimPayment(PaymentKey),
    CONSTRAINT FK_FactSales_DimPromotion
        FOREIGN KEY (PromotionKey) REFERENCES dbo.DimPromotion(PromotionKey)
);
GO

CREATE TABLE dbo.FactSales (
    SalesKey       INT IDENTITY(1,1) PRIMARY KEY,
    DateKey        INT NOT NULL,
    CustomerKey    INT NOT NULL,
    ProductKey     INT NOT NULL,
    StoreKey       INT NOT NULL,
    PaymentKey     INT NOT NULL,
    PromotionKey   INT NOT NULL,
    Transaction_ID NVARCHAR(64) NOT NULL,
    Total_Items    INT NOT NULL,
    Total_Cost     DECIMAL(18,2) NOT NULL,
    HourInDay      TINYINT NOT NULL,
    Season         NVARCHAR(20) NULL,   -- ?? Season brute ici

    -- FKs comme avant...
);
GO