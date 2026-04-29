# End-to-End E-commerce Analytics & Delivery Prediction System

## 📌 Overview

This project builds a complete data pipeline to transform raw e-commerce data into actionable business insights. It combines data warehousing, feature engineering, and machine learning to analyze customer behavior and predict delivery delays.

---

## 🏗 Architecture

```
Raw CSV Data
    ↓
PostgreSQL Data Warehouse
(RAW → STAGING → ANALYTICS → MARTS)
    ↓
Python (Feature Engineering + ML Model)
    ↓
Predictions stored back in PostgreSQL
    ↓
Business Insights & Analysis
```

---

## 🛠 Tech Stack

* **SQL**: PostgreSQL
* **Python**: Pandas, Scikit-learn
* **Data Modeling**: Star Schema (Fact & Dimension Tables)
* **Visualization**: Power BI (basic KPI view)

---

## ⚙️ Key Features

* Designed a **layered data warehouse architecture** (RAW, STAGING, ANALYTICS, MARTS)
* Built **star schema** with fact and dimension tables for scalable analytics
* Performed **feature engineering** to derive delivery-related metrics
* Developed a **machine learning model** to predict late deliveries
* Stored predictions back into the database for downstream analysis

---

## 🤖 Machine Learning

* Problem: Predict whether an order will be delivered late
* Model: Random Forest Classifier
* Evaluation: ROC-AUC ~0.67 (realistic performance after removing data leakage)
* Addressed class imbalance using balanced class weights

---

## 📊 Key Insights

* Late deliveries account for ~5% of total orders, indicating moderate operational risk
* Delivery delay is the strongest predictor, highlighting logistics inefficiencies
* Order value and freight cost show moderate impact on delivery performance
* Regional variations suggest inconsistencies in delivery operations
* The model enables proactive identification of high-risk deliveries

---

## 📁 Project Structure

```
notebooks/
 ├── 01_data_validation.ipynb
 ├── 02_feature_engineering.ipynb
 ├── 03_customer_segmentation.ipynb
 ├── 04_delivery_prediction.ipynb

sql/
 ├── raw_layer.sql
 ├── staging_layer.sql
 ├── analytics_star_schema.sql

README.md
```

---

## 🚀 How to Run (Optional)

1. Load OLIST dataset into PostgreSQL
2. Execute SQL scripts to build warehouse
3. Run notebooks in sequence
4. Train model and generate predictions

---

## 🎯 Outcome

This project demonstrates the ability to design and implement an end-to-end analytics pipeline, combining data engineering, machine learning, and business insight generation.

---
