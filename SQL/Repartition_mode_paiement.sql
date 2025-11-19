SELECT
    pay.Payment_Method,
    COUNT(*) AS NbTransactions,
    SUM(f.Total_Cost) AS TotalSales
FROM dbo.FactSales f
JOIN dbo.DimPayment pay ON f.PaymentKey = pay.PaymentKey
GROUP BY pay.Payment_Method
ORDER BY TotalSales DESC;
