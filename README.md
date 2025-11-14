# INF5173 – Projet P2 : Entrepôt de données Retail (SQL Server 2022)

> **But** : Concevoir un modèle en **étoile** autour des transactions de détail, développer un **ETL** (Python ou outil ETL), exécuter des **opérations ROLAP** (Slice, Dice, Roll-up, Drill-down) et livrer un **rapport** professionnel.

---

## 📦 Contenu du dépôt

```
INF5173-P2-EquipeN/
├─ README.md                       ← ce fichier
├─ report/
│   └─ INF5173-P2-EquipeN-Rapport.docx
├─ sql/
│   ├─ 00_create_database.sql      ← (optionnel) création base
│   ├─ 10_dim_tables.sql           ← DDL dimensions
│   ├─ 20_fact_table.sql           ← DDL table de faits
│   ├─ 30_indexes.sql              ← index & contraintes
│   ├─ 40_seed_promotion.sql       ← seed DimPromotion
│   └─ 50_rolap_queries.sql        ← requêtes ROLAP
├─ etl/
│   ├─ rapidminer_process.rmp      ← (optionnel)
│   └─ python/
│       ├─ requirements.txt        ← pandas, pyodbc, python-dateutil
│       ├─ etl_config.yaml         ← paramètres connexion & chemins
│       ├─ load_dimensions.py      ← création/mapping des Dim
│       ├─ load_fact_sales.py      ← chargement FactSales
│       └─ utils.py
├─ data/
│   ├─ raw/
│   │   └─ retail_transactions.csv ← dataset source (non versionné)
│   ├─ staging/
│   └─ cleaned/
├─ outputs/
│   ├─ rolap_exports/
│   └─ figures/
└─ tests/
    ├─ test_integrity.sql
    └─ test_etl_run.py
```

> ⚠️ **Ne versionnez pas** les données réelles. Utilisez `.gitignore` pour exclure `data/`.

---

## 🧠 Modèle en étoile (schéma logique)

**Table de faits**
- `FactSales(SalesKey, DateKey, CustomerKey, ProductKey, StoreKey, PaymentKey, PromotionKey, Transaction_ID, Total_Items, Total_Cost, Net_Sales, LoadTS)`

**Dimensions**
- `DimDate(DateKey, FullDate, YearNum, QuarterNum, MonthNum, MonthName, DayNum, DayOfWeekNum, DayOfWeekName, Season)`  
- `DimCustomer(CustomerKey, Customer_Name, Customer_Category, City)`  
- `DimProduct(ProductKey, Product)`  
- `DimStore(StoreKey, Store_Type, City)`  
- `DimPayment(PaymentKey, Payment_Method)`  
- `DimPromotion(PromotionKey, PromotionType, DiscountFlag, Description)`

**Justifications clés**
- Grain = **transaction** (une ligne par vente).  
- `Promotion` faible cardinalité (3 modalités avec “No Promotion”) + `Discount_Applied` → **DimPromotion** compacte.  
- Index sur clés étrangères pour accélérer les requêtes OLAP.

---

## 🛠️ Prérequis

- **SQL Server 2022** + **SSMS** (ou Azure Data Studio)
- **Python 3.10+** avec : `pandas`, `pyodbc`, `python-dateutil`, `pyyaml`
- **Pilote ODBC** SQL Server (Windows : *ODBC Driver 17/18 for SQL Server*)

### Installation Python (venv)
```bash
python -m venv .venv
.\.venv\Scripts\activate       # Windows
pip install -r etl/python/requirements.txt
```

---

## 🗄️ Déploiement du schéma

Dans **SSMS** :

1. Créer la base (facultatif si déjà créée) :
   ```sql
   CREATE DATABASE RetailDW;
   GO
   USE RetailDW;
   GO
   ```

2. Exécuter, dans l’ordre :
   - `sql/10_dim_tables.sql`
   - `sql/20_fact_table.sql`
   - `sql/30_indexes.sql`
   - `sql/40_seed_promotion.sql` (insère *No Promotion*, *BOGO*, *Discount on Selected Items*)

> Vérification :  
> ```sql
> USE RetailDW; SELECT name FROM sys.tables ORDER BY name;
> ```

---

## 🔄 Chargement (ETL)

**Entrée attendue :** `data/raw/retail_transactions.csv` avec les colonnes :  
`['Transaction_ID','Date','Customer_Name','Product','Total_Items','Total_Cost','Payment_Method','City','Store_Type','Discount_Applied','Customer_Category','Season','Promotion']`

1) **Créer les dimensions** (déduplication et mapping) :
```bash
python etl/python/load_dimensions.py
```

2) **Charger la table de faits** :
```bash
python etl/python/load_fact_sales.py
```

> Le mapping `Promotion + Discount_Applied` → `DimPromotion` se fait dans l’ETL.  
> `Promotion=None` est mappé à `PromotionType='No Promotion'` et `DiscountFlag=0`.

---

## 📊 Requêtes ROLAP (extraits)

**Slice – par type de promotion**
```sql
SELECT p.PromotionType, COUNT(*) AS NbTxn, SUM(f.Total_Cost) AS TotalSales
FROM dbo.FactSales f
JOIN dbo.DimPromotion p ON f.PromotionKey = p.PromotionKey
GROUP BY p.PromotionType
ORDER BY TotalSales DESC;
```

**Dice – par saison et mode de paiement**
```sql
SELECT d.Season, pay.Payment_Method, SUM(f.Total_Cost) AS TotalSales
FROM dbo.FactSales f
JOIN dbo.DimDate d ON f.DateKey = d.DateKey
JOIN dbo.DimPayment pay ON f.PaymentKey = pay.PaymentKey
GROUP BY d.Season, pay.Payment_Method;
```

**Roll-up – Année → Trimestre → Mois**
```sql
SELECT d.YearNum, d.QuarterNum, d.MonthName, SUM(f.Total_Cost) AS Sales
FROM dbo.FactSales f
JOIN dbo.DimDate d ON f.DateKey = d.DateKey
GROUP BY ROLLUP (d.YearNum, d.QuarterNum, d.MonthName);
```

**Drill-down – Store_Type → City**
```sql
SELECT s.Store_Type, s.City, SUM(f.Total_Cost) AS Sales
FROM dbo.FactSales f
JOIN dbo.DimStore s ON f.StoreKey = s.StoreKey
GROUP BY s.Store_Type, s.City
ORDER BY s.Store_Type, Sales DESC;
```

---

## ✅ Contrôles qualité (à inclure au rapport)

- Integrité référentielle : 0 FK orphelines (`FactSales` → Dim\*).  
- Comptage : #lignes Fact = #transactions source.  
- Totaux : `SUM(Total_Cost)` (Fact) ≈ total source.  
- Distribs : répartition par `Season`, `Store_Type`, `Payment_Method`.

---

## 🤝 Collaboration & branches Git

### Initialisation locale
```bash
git init
git add .
git commit -m "feat: initial commit – star schema, ETL scaffolding, ROLAP queries"
```

### Création du dépôt GitHub (via GitHub CLI)
```bash
gh repo create INF5173-P2-EquipeN --public --source=. --remote=origin --push
```

> Sans CLI : crée le repo vide sur GitHub, puis :
```bash
git remote add origin https://github.com/<votre-org>/INF5173-P2-EquipeN.git
git branch -M main
git push -u origin main
```

### Branche pour le coéquipier
```bash
git checkout -b feature/etl-coequipier
git push -u origin feature/etl-coequipier
```
Inviter ton coéquipier : *GitHub → Settings → Collaborators → Add people*.

**Workflow recommandé**
- Dev sur branches `feature/*`
- Pull Request → Review → Merge vers `main`
- Optionnel : protéger `main` (branch protection rules, 1 review min).

---

## 📝 Licence & auteurs
- Licence : académique (à préciser selon consignes du cours).
- Équipe : `EquipeN` – Franklin & Coéquipier (ajouter noms/comptes GitHub).

---

## 📚 Références rapides
- SQL Server 2022 + SSMS
- Pandas, pyodbc, dateutil
- Bonnes pratiques Kimball (modèle en étoile, dims conformes, SCD – type 1 ici)
