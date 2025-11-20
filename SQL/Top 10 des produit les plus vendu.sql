SELECT TOP 10
    p.Product,
    SUM(f.Total_Cost) AS TotalSales,
    SUM(f.Total_Items) AS TotalItems
FROM dbo.FactSales f
JOIN dbo.DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.Product
ORDER BY TotalSales DESC;
