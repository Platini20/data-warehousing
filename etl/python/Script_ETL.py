import pandas as pd, pyodbc
from datetime import datetime

cn = pyodbc.connect("DRIVER={ODBC Driver 17 for SQL Server};SERVER=.;DATABASE=RetailDW;Trusted_Connection=yes;")
cur = cn.cursor()

# 1) Lecture source
df = pd.read_csv("C:/Users/Platini AGOUANET/OneDrive/Desktop/UQO-Automne/Fouille et entreposage/Projet 2/INF5173-P2-Equipe15/data/raw/Retail_Transactions_Dataset.csv".csv")

# 2) Normalisation colonnes attendues
df.rename(columns={
    "transaction_id":"TransactionID","date":"TxnDate","customer_id":"CustomerCode",
    "product_id":"SKU","store_id":"StoreCode","qty":"Quantity","unit_price":"UnitPrice",
    "discount":"DiscountAmount","payment_method":"PaymentMethod","promo_code":"PromotionCode"
}, inplace=True)

# 3) Dérivations DateKey
df["TxnDate"] = pd.to_datetime(df["TxnDate"])
df["DateKey"] = df["TxnDate"].dt.strftime("%Y%m%d").astype(int)

# 4) Petites tables de référence (distincts)
dim_customer = df[["CustomerCode"]].dropna().drop_duplicates()
dim_product  = df[["SKU"]].dropna().drop_duplicates()
dim_store    = df[["StoreCode"]].dropna().drop_duplicates()
dim_pay      = df[["PaymentMethod"]].fillna("Unknown").drop_duplicates()
dim_promo    = df[["PromotionCode"]].fillna("NONE").drop_duplicates()

# 5) Upsert dimensions (exemple DimCustomer)
for code in dim_customer["CustomerCode"]:
    cur.execute("""
MERGE dbo.DimCustomer AS tgt
USING (SELECT ? AS CustomerCode) AS src
ON (tgt.CustomerCode = src.CustomerCode)
WHEN NOT MATCHED THEN
  INSERT (CustomerCode) VALUES (src.CustomerCode);
""", code)
cn.commit()

# idem pour DimProduct/DimStore/DimPayment/DimPromotion...

# 6) Remplir DimDate (sur plage min..max)
min_d, max_d = df["TxnDate"].min().date(), df["TxnDate"].max().date()
# (générer calendrier et insérer DimDate…)

# 7) Résoudre clés substitutives en batch (lookup)
# Exemple: obtenir ProductKey pour chaque SKU
prod_map = {r.SKU: r.ProductKey for r in cur.execute("SELECT ProductKey, SKU FROM dbo.DimProduct")}
df["ProductKey"] = df["SKU"].map(prod_map)

# 8) Charger FactSales
rows = df[["DateKey","CustomerCode","ProductKey","StoreCode","PromotionCode","PaymentMethod",
           "TransactionID","Quantity","UnitPrice","DiscountAmount"]].itertuples(index=False, name=None)
# Remplacer codes -> clés (via maps analogues) puis INSERT en batch
