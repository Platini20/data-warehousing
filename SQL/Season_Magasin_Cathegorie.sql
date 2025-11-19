-- 4. Dice : filtrer plusieurs dimensions (Season, type de magasin, catégorie client)
SELECT
    d.[Year],
    f.Season,
    c.Customer_Category,
    s.Store_Type,
    SUM(f.Total_Cost) AS TotalSales,
    COUNT(*)          AS NbTransactions
FROM dbo.FactSales f
JOIN dbo.DimDate     d ON f.DateKey     = d.DateKey
JOIN dbo.DimCustomer c ON f.CustomerKey = c.CustomerKey
JOIN dbo.DimStore    s ON f.StoreKey    = s.StoreKey
WHERE f.Season = 'Winter'                  
  AND c.Customer_Category LIKE '%Retiree%'    
  AND s.Store_Type        LIKE '%Pharmacy%'       
GROUP BY
    d.[Year],
    f.Season,
    c.Customer_Category,
    s.Store_Type
ORDER BY
    d.[Year], c.Customer_Category, s.Store_Type;
