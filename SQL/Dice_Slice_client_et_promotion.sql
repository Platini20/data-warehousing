SELECT
    c.Customer_Category,
    promo.PromotionType,
    promo.DiscountFlag,
    SUM(f.Total_Cost) AS TotalSales,
    AVG(f.Total_Cost) AS AvgBasket
FROM dbo.FactSales f
JOIN dbo.DimCustomer   c    ON f.CustomerKey  = c.CustomerKey
JOIN dbo.DimPromotion  promo ON f.PromotionKey = promo.PromotionKey
GROUP BY
    c.Customer_Category,
    promo.PromotionType,
    promo.DiscountFlag
ORDER BY
    c.Customer_Category,
    promo.PromotionType;
