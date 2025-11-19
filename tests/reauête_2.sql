USE RetailDB;
GO

SELECT COUNT(*) AS NbStaging FROM dbo.Retail_Transactions_Staging;
SELECT COUNT(*) AS NbDimDate FROM dbo.DimDate;
SELECT COUNT(*) AS NbDimCustomer FROM dbo.DimCustomer;
SELECT COUNT(*) AS NbDimProduct FROM dbo.DimProduct;
SELECT COUNT(*) AS NbDimStore FROM dbo.DimStore;
SELECT COUNT(*) AS NbDimPayment FROM dbo.DimPayment;
SELECT COUNT(*) AS NbDimPromotion FROM dbo.DimPromotion;
SELECT COUNT(*) AS NbFactSales FROM dbo.FactSales;
