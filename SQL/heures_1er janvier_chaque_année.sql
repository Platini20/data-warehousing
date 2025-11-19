USE RetailDB;
GO

SELECT
    d.[Year],
    f.HourInDay,
    SUM(f.Total_Cost) AS TotalSales
FROM dbo.FactSales f
JOIN dbo.DimDate d 
    ON f.DateKey = d.DateKey
WHERE d.[Month] = 1
  AND d.[Day] = 1
GROUP BY d.[Year], f.HourInDay
ORDER BY d.[Year], f.HourInDay;
