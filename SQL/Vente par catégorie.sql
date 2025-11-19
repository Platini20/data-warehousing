USE RetailDB;
GO

SELECT
    d.[Year],
    c.Customer_Category,
    SUM(f.Total_Cost) AS TotalSales
FROM dbo.FactSales f
JOIN dbo.DimDate d 
       ON f.DateKey = d.DateKey
JOIN dbo.DimCustomer c 
       ON f.CustomerKey = c.CustomerKey
GROUP BY
    d.[Year],
    c.Customer_Category
ORDER BY
    d.[Year],
    c.Customer_Category;
