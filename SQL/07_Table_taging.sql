USE RetailDB;
GO

IF OBJECT_ID('dbo.Retail_Transactions_Staging', 'U') IS NOT NULL
    DROP TABLE dbo.Retail_Transactions_Staging;
GO

CREATE TABLE dbo.Retail_Transactions_Staging (
    Transaction_ID       NVARCHAR(64)      NOT NULL,
    [Date]               DATETIME2(0)      NOT NULL,
    Customer_Name        NVARCHAR(150)     NOT NULL,
    Product              NVARCHAR(200)     NOT NULL,
    Total_Items          INT               NOT NULL,
    Total_Cost           DECIMAL(18,2)     NOT NULL,
    Payment_Method       NVARCHAR(50)      NOT NULL,
    City                 NVARCHAR(100)     NOT NULL,
    Store_Type           NVARCHAR(100)     NOT NULL,
    Discount_Applied     BIT               NOT NULL,
    Customer_Category    NVARCHAR(50)      NOT NULL,
    Season               NVARCHAR(20)      NOT NULL,
    Promotion            NVARCHAR(100)     NULL
);
GO

INSERT INTO dbo.Retail_Transactions_Staging (
    Transaction_ID,
    [Date],
    Customer_Name,
    Product,
    Total_Items,
    Total_Cost,
    Payment_Method,
    City,
    Store_Type,
    Discount_Applied,
    Customer_Category,
    Season,
    Promotion
)
SELECT
    Transaction_ID,
    CONVERT(datetime2(0), REPLACE([Date], '  ', ' '), 120) AS [Date],
    Customer_Name,
    Product,
    CONVERT(int, Total_Items),
    CONVERT(decimal(18,2), Total_Cost),
    Payment_Method,
    City,
    Store_Type,
    CASE 
        WHEN Discount_Applied IN ('1','True','true','TRUE') THEN 1
        WHEN Discount_Applied IN ('0','False','false','FALSE') THEN 0
        ELSE 0
    END AS Discount_Applied,
    Customer_Category,
    Season,
    NULLIF(Promotion, '')
FROM dbo.Retail_Transactions_Raw;
GO

SELECT COUNT(*) AS NbLignes_STAGING FROM dbo.Retail_Transactions_Staging;
SELECT TOP 5 * FROM dbo.Retail_Transactions_Staging;

