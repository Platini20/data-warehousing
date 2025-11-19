-- Slice : ventes des clients "Loyal"
SELECT
    d.[Year],
    d.[Month],
    SUM(f.Total_Cost) AS TotalSales
FROM dbo.FactSales f
JOIN dbo.DimDate d      ON f.DateKey = d.DateKey
JOIN dbo.DimCustomer c  ON f.CustomerKey = c.CustomerKey
WHERE c.Customer_Category = 'Loyal Customer'
GROUP BY d.[Year], d.[Month]
ORDER BY d.[Year], d.[Month];
