SELECT
    d.[Year],
    d.[Month],
    d.[Day],
    f.HourInDay,
    SUM(f.Total_Cost) AS TotalSales
FROM dbo.FactSales f
JOIN dbo.DimDate d ON f.DateKey = d.DateKey
GROUP BY d.[Year], d.[Month], d.[Day], f.HourInDay
ORDER BY d.[Year], d.[Month], d.[Day], f.HourInDay;
