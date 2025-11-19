-- 3. Slice : Ventes par mois pour une catégorie de clients (ex : Professional)
SELECT
    d.[Year],
    d.[Month],
    c.Customer_Category,
    SUM(f.Total_Cost) AS TotalSales
FROM dbo.FactSales f
JOIN dbo.DimDate     d ON f.DateKey     = d.DateKey
JOIN dbo.DimCustomer c ON f.CustomerKey = c.CustomerKey
WHERE c.Customer_Category = 'Professional' 
GROUP BY d.[Year], d.[Month], c.Customer_Category
ORDER BY d.[Year], d.[Month];
