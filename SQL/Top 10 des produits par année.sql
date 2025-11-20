USE RetailDB;
GO

WITH ProductSales AS (
    SELECT
        d.[Year],
        p.Product,
        SUM(f.Total_Cost) AS TotalSales,
        SUM(f.Total_Items) AS TotalItems,
        ROW_NUMBER() OVER (
            PARTITION BY d.[Year]
            ORDER BY SUM(f.Total_Cost) DESC
        ) AS RankPerYear
    FROM dbo.FactSales f
    JOIN dbo.DimDate d 
           ON f.DateKey = d.DateKey
    JOIN dbo.DimProduct p
           ON f.ProductKey = p.ProductKey
    GROUP BY d.[Year], p.Product
)
SELECT 
    Year,
    Product,
    TotalSales,
    TotalItems
FROM ProductSales
WHERE RankPerYear <= 10
ORDER BY Year, TotalSales DESC;
