USE RetailDB;
GO

---------------------------
-- DIMDATE
---------------------------
DELETE FROM dbo.DimDate;
GO

INSERT INTO dbo.DimDate (
    DateKey, [Date], [Year], [Month], [Day]
)
SELECT
    CONVERT(INT, FORMAT(CAST(s.[Date] AS date), 'yyyyMMdd')) AS DateKey,
    CAST(s.[Date] AS date)                                   AS [Date],
    YEAR(s.[Date])                                           AS [Year],
    MONTH(s.[Date])                                          AS [Month],
    DAY(s.[Date])                                            AS [Day]
FROM dbo.Retail_Transactions_Staging s
GROUP BY
    CAST(s.[Date] AS date),
    YEAR(s.[Date]),
    MONTH(s.[Date]),
    DAY(s.[Date]);
GO

---------------------------
-- DIMCUSTOMER
---------------------------
DELETE FROM dbo.DimCustomer;
DBCC CHECKIDENT ('dbo.DimCustomer', RESEED, 0);
GO

INSERT INTO dbo.DimCustomer (Customer_Name, Customer_Category, City)
SELECT DISTINCT
    s.Customer_Name,
    s.Customer_Category,
    s.City
FROM dbo.Retail_Transactions_Staging s;
GO

---------------------------
-- DIMPRODUCT
---------------------------
DELETE FROM dbo.DimProduct;
DBCC CHECKIDENT ('dbo.DimProduct', RESEED, 0);
GO

INSERT INTO dbo.DimProduct (Product)
SELECT DISTINCT s.Product
FROM dbo.Retail_Transactions_Staging s;
GO

---------------------------
-- DIMSTORE
---------------------------
DELETE FROM dbo.DimStore;
DBCC CHECKIDENT ('dbo.DimStore', RESEED, 0);
GO

INSERT INTO dbo.DimStore (Store_Type, City)
SELECT DISTINCT s.Store_Type, s.City
FROM dbo.Retail_Transactions_Staging s;
GO

---------------------------
-- DIMPAYMENT
---------------------------
DELETE FROM dbo.DimPayment;
DBCC CHECKIDENT ('dbo.DimPayment', RESEED, 0);
GO

INSERT INTO dbo.DimPayment (Payment_Method)
SELECT DISTINCT s.Payment_Method
FROM dbo.Retail_Transactions_Staging s;
GO

---------------------------
-- DIMPROMOTION
---------------------------
DELETE FROM dbo.DimPromotion;
DBCC CHECKIDENT ('dbo.DimPromotion', RESEED, 0);
GO

INSERT INTO dbo.DimPromotion (PromotionType, DiscountFlag, [Description])
VALUES ('No Promotion', 0, 'Aucune promotion appliquée');

INSERT INTO dbo.DimPromotion (PromotionType, DiscountFlag, [Description])
SELECT DISTINCT
    s.Promotion,
    s.Discount_Applied,
    CASE
        WHEN s.Promotion = 'Discount on Selected Items'
            THEN 'Réduction sur certains articles'
        WHEN s.Promotion = 'BOGO (Buy One Get One)'
            THEN 'Achetez-en un, obtenez-en un gratuitement'
        ELSE NULL
    END
FROM dbo.Retail_Transactions_Staging s
WHERE s.Promotion IS NOT NULL;
GO
