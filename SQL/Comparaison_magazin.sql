SELECT
    s.Store_Type,
    s.City,
    SUM(f.Total_Cost)        AS TotalSales,
    SUM(f.Total_Items)       AS TotalItems,
    COUNT(DISTINCT f.CustomerKey) AS NbCustomers
FROM dbo.FactSales f
JOIN dbo.DimStore s ON f.StoreKey = s.StoreKey
GROUP BY s.Store_Type, s.City
ORDER BY TotalSales DESC;
