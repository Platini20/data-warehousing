# INF5173 – Projet P2 : Entrepôt de données Retail (SQL Server 2022)

> **But** : 
Ce projet consiste à construire un entrepôt de données décisionnel complet à partir d’un jeu d’un million de transactions de détail.  
Il inclut :  
- l’analyse du jeu de données,  
- la conception d’un schéma en étoile,  
- la construction de la base dans SQL Server,  
- un pipeline ETL entièrement basé sur SQL Server Management Studio (SSMS),  
- et une série d’analyses OLAP accompagnées de visualisations.  

---

## 📌 1. Objectifs du projet

Le but de ce travail est de :

1. Explorer le jeu de données et identifier les dimensions pertinentes.  
2. Concevoir un **schéma en étoile** adapté au domaine du retail.  
3. Construire un entrepôt de données dans SQL Server.  
4. Peupler l’entrepôt via un **pipeline ETL 100% SQL/SSMS**.  
5. Effectuer des opérations OLAP : **Slice, Dice, Roll-up, Drill-down**.  
6. Exporter les résultats sous forme de graphiques et interpréter les tendances.

---


## 🏗️ 3. Modèle conceptuel – Schéma en étoile

L’entrepôt est structuré autour de la table de faits **FactSales**, reliée à six dimensions :

- **DimDate** : structure temporelle (Year, Month, Day).  
- **DimCustomer** : informations sur les clients.  
- **DimProduct** : produits achetés.  
- **DimStore** : villes et types de magasins.  
- **DimPayment** : méthodes de paiement.  
- **DimPromotion** : type de promotion et discount appliqué.

👉 Le choix du schéma en étoile permet une navigation rapide dans les données (Slice, Dice, Roll-up, Drill-down).

---

## ⚙️ 4. Pipeline ETL (100 % SQL/SSMS)

Nous n'avons utilisé Vscode que pour l'analyse des données.

### Étapes ETL :

1. **Chargement du CSV brut** dans la table `Retail_Transactions_Raw` via `BULK INSERT`.  
2. **Nettoyage et typage** dans `Retail_Transactions_Staging`.  
3. **Chargement des dimensions** avec génération de clés substituts.  
4. **Construction de la table de faits** avec jointure sur les dimensions.  

📌 *Note importante* :  
L’attribut `Season` du dataset s’est révélé **incohérent** (toutes les saisons apparaissant à tous les mois).  
Nous avons **conservé la valeur brute dans FactSales**, mais **exclu cette variable des analyses temporelles**.

---

## 📊 5. Analyses OLAP réalisées

Les requêtes suivantes ont été exécutées et exportées en CSV pour création des graphiques :

1. **Roll-up temporel** – Ventes par année et par mois  
2. **Drill-down simplifié** – Ventes par heure d’une journée représentative par année  
3. **Slice** – Analyse d’une catégorie de client  
4. **Dice** – Analyse multidimensionnelle (client × magasin × attributs)  
5. **Slice/Dice** – Impact des promotions par catégorie de client  
6. **Comparaison des magasins** (Store_Type × City)  
7. **Répartition des modes de paiement**

Chaque analyse est accompagnée dans le rapport :
- d’un graphique Excel,  
- d’une interprétation académique,  
- et d’une explication de la tendance observée.

---

## 📈 6. Visualisations

Les fichiers CSV issus des requêtes ont été transformés en :

- diagrammes en colonnes groupées,  
- graphiques en lignes,  
- diagrammes en secteurs,  
- tableaux croisés dynamiques,  

selon le type d’analyse.

Les visualisations permettent de mettre en évidence :
- des cycles temporels,  
- des comportements client,  
- l’impact des promotions,  
- la performance des magasins,  
- les préférences de paiement.

---

## 📝 7. Limitations observées

- L’attribut *Season* du dataset est **incohérent** → exclu des analyses.  
- Certaines promotions étaient absentes ou nulles → normalisations nécessaires.  
- Le dataset ne comprend pas de vraies clés clients/produits → difficulté d’analyse longitudinale.  
- ETL manuel sous SSMS → performant mais sans automatisation.  

---

## 🎯 8. Conclusion générale

Ce projet démontre la construction complète d’un entrepôt de données, depuis la modélisation jusqu’à l’analyse OLAP d’un jeu de transactions massif.  
Le schéma en étoile conçu facilite les analyses multidimensionnelles, tandis que l’ETL basé sur SSMS assure un pipeline fiable et contrôlé pour l’intégration des données.  
Les opérations OLAP ont permis de révéler des tendances importantes liées aux ventes, aux magasins, au comportement client et aux méthodes de paiement, confirmant la valeur du modèle décisionnel mis en place.

---

# 📬 Auteur

**Franklin Agouanet**  
Programme : Maitrise en informatique — Science des données et IA  
Université du Québec en Outaouais (UQO)



