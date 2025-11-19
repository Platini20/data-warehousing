USE RetailDB;
GO

-------------------------------
-- 1. Recréer la table RAW
-------------------------------
IF OBJECT_ID('dbo.Retail_Transactions_Raw', 'U') IS NOT NULL
    DROP TABLE dbo.Retail_Transactions_Raw;
GO

CREATE TABLE dbo.Retail_Transactions_Raw (
    Transaction_ID       NVARCHAR(200) NULL,
    [Date]               NVARCHAR(200) NULL,
    Customer_Name        NVARCHAR(200) NULL,
    Product              NVARCHAR(200) NULL,
    Total_Items          NVARCHAR(200) NULL,
    Total_Cost           NVARCHAR(200) NULL,
    Payment_Method       NVARCHAR(200) NULL,
    City                 NVARCHAR(200) NULL,
    Store_Type           NVARCHAR(200) NULL,
    Discount_Applied     NVARCHAR(200) NULL,
    Customer_Category    NVARCHAR(200) NULL,
    Season               NVARCHAR(200) NULL,
    Promotion            NVARCHAR(200) NULL
);
GO

-------------------------------
-- 2. BULK INSERT depuis le CSV
-------------------------------
BULK INSERT dbo.Retail_Transactions_Raw
FROM 'C:\Users\Platini AGOUANET\OneDrive\Desktop\UQO-Automne\Fouille et entreposage\Projet 2\Retail_Transactions_Dataset.csv'  -- 🔁 ADAPTER CE CHEMIN
WITH (
    FIRSTROW = 2,              -- ignore l'en-tête
    FIELDTERMINATOR = ',',     -- séparateur de colonnes
    ROWTERMINATOR = '0x0A',    -- fin de ligne (LF)
    CODEPAGE = '65001',        -- UTF-8 ; si ça pose problème on l'enlève
    TABLOCK
);
GO

-------------------------------
-- 3. Vérifier que RAW est remplie
-------------------------------
SELECT COUNT(*) AS NbLignes_RAW FROM dbo.Retail_Transactions_Raw;
SELECT TOP 5 * FROM dbo.Retail_Transactions_Raw;
GO
