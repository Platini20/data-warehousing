

-- Dice : clients réguliers, magasins "Mall Store", saisons hivernales
SELECT
    d.[Year],
    d.Season,
    s.Store_Type,
    SUM(f.Total_Cost) AS TotalSales
FROM dbo.FactSales f
JOIN dbo.DimDate d     ON f.DateKey = d.DateKey
JOIN dbo.DimStore s    ON f.StoreKey = s.StoreKey
JOIN dbo.DimCustomer c ON f.CustomerKey = c.CustomerKey
WHERE c.Customer_Category = 'Regular Customer'
  AND s.Store_Type = 'Mall Store'
  AND d.Season IN ('Winter')
GROUP BY d.[Year], d.Season, s.Store_Type
ORDER BY d.[Year], d.Season;

