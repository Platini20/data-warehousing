USE RetailDB;
GO

SELECT
    f.Season,
    COUNT(DISTINCT f.CustomerKey) AS NbClients
FROM dbo.FactSales f
JOIN dbo.DimDate d 
    ON f.DateKey = d.DateKey
WHERE d.[Year] = 2024
GROUP BY f.Season
ORDER BY f.Season;
