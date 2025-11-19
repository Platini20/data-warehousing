USE RetailDB;
GO

TRUNCATE TABLE dbo.FactSales;
GO

INSERT INTO dbo.FactSales (
    DateKey,
    CustomerKey,
    ProductKey,
    StoreKey,
    PaymentKey,
    PromotionKey,
    Transaction_ID,
    Total_Items,
    Total_Cost,
    HourInDay
)
SELECT
    CONVERT(INT, FORMAT(CAST(s.[Date] AS date), 'yyyyMMdd')) AS DateKey,
    c.CustomerKey,
    p.ProductKey,
    st.StoreKey,
    pay.PaymentKey,
    promo.PromotionKey,
    s.Transaction_ID,
    s.Total_Items,
    s.Total_Cost,
    DATEPART(HOUR, s.[Date]) AS HourInDay
FROM dbo.Retail_Transactions_Staging s
JOIN dbo.DimCustomer   c   ON c.Customer_Name      = s.Customer_Name
                           AND c.Customer_Category = s.Customer_Category
                           AND c.City             = s.City
JOIN dbo.DimProduct    p   ON p.Product            = s.Product
JOIN dbo.DimStore      st  ON st.Store_Type        = s.Store_Type
                           AND st.City            = s.City
JOIN dbo.DimPayment    pay ON pay.Payment_Method   = s.Payment_Method
JOIN dbo.DimPromotion  promo 
     ON (
            (s.Promotion IS NULL AND promo.PromotionType = 'No Promotion' AND promo.DiscountFlag = 0)
         OR (s.Promotion IS NOT NULL AND promo.PromotionType = s.Promotion AND promo.DiscountFlag = s.Discount_Applied)
        );
GO

TRUNCATE TABLE dbo.FactSales;
GO

INSERT INTO dbo.FactSales (
    DateKey,
    CustomerKey,
    ProductKey,
    StoreKey,
    PaymentKey,
    PromotionKey,
    Transaction_ID,
    Total_Items,
    Total_Cost,
    HourInDay,
    Season              -- ?? on charge Season dans la fact
)
SELECT
    CONVERT(INT, FORMAT(CAST(s.[Date] AS date), 'yyyyMMdd')) AS DateKey,
    c.CustomerKey,
    p.ProductKey,
    st.StoreKey,
    pay.PaymentKey,
    promo.PromotionKey,
    s.Transaction_ID,
    s.Total_Items,
    s.Total_Cost,
    DATEPART(HOUR, s.[Date]) AS HourInDay,
    s.Season                 AS Season   -- ?? valeur brute du dataset
FROM dbo.Retail_Transactions_Staging s
JOIN dbo.DimCustomer   c   ON c.Customer_Name      = s.Customer_Name
                           AND c.Customer_Category = s.Customer_Category
                           AND c.City             = s.City
JOIN dbo.DimProduct    p   ON p.Product            = s.Product
JOIN dbo.DimStore      st  ON st.Store_Type        = s.Store_Type
                           AND st.City            = s.City
JOIN dbo.DimPayment    pay ON pay.Payment_Method   = s.Payment_Method
JOIN dbo.DimPromotion  promo 
     ON (
            (s.Promotion IS NULL AND promo.PromotionType = 'No Promotion' AND promo.DiscountFlag = 0)
         OR (s.Promotion IS NOT NULL AND promo.PromotionType = s.Promotion AND promo.DiscountFlag = s.Discount_Applied)
        );
GO

