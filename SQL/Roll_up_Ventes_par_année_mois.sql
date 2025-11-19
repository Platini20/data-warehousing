SELECT
    d.[Year],
    d.[Month],
    SUM(f.Total_Cost) AS TotalSales
FROM dbo.FactSales f
JOIN dbo.DimDate d ON f.DateKey = d.DateKey
GROUP BY d.[Year], d.[Month]
ORDER BY d.[Year], d.[Month];
