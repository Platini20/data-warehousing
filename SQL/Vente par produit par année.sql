USE RetailDB;
GO

SELECT
    d.[Year],
    p.Product,
    SUM(f.Total_Cost) AS TotalSales
FROM dbo.FactSales f
JOIN dbo.DimDate d     ON f.DateKey = d.DateKey
JOIN dbo.DimProduct p  ON f.ProductKey = p.ProductKey
GROUP BY d.[Year], p.Product
ORDER BY d.[Year], TotalSales DESC;
