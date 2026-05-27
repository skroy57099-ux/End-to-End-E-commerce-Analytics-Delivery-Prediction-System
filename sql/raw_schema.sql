SET search_path TO raw;

/*=====================================================
   AGENTIC E-COMMERNCE INTELLIGANCE PLATFORM
   Author: Shubham Kumar
   Architecture: raw → staging → analytics
===================================================== */


/* =============================
   1. CREATE SCHEMAS
============================= */

CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS analytics;


/* =============================
   2. RAW TABLE STRUCTURES
   Purpose:
   - Landing zone for CSV ingestion
   - No transformations
   - All columns stored as TEXT
   - No constraints (PK/FK handled in staging)
============================= */

SET search_path TO raw;

  CREATE TABLE if not exists customers_raw (
    customer_id TEXT,
    customer_unique_id TEXT,
    customer_zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state TEXT
);

CREATE TABLE if not exists orders_raw (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TEXT,
    order_approved_at TEXT,
    order_delivered_carrier_date TEXT,
    order_delivered_customer_date TEXT,
    order_estimated_delivery_date TEXT
);

CREATE table if not exists order_items_raw (
    order_id TEXT,
    order_item_id TEXT,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TEXT,
    price TEXT,
    freight_value TEXT
);

CREATE TABLE if not exists order_payments_raw (
    order_id TEXT,
    payment_sequential TEXT,
    payment_type TEXT,
    payment_installments TEXT,
    payment_value TEXT
);

SET search_path TO raw;
CREATE TABLE if not exists order_reviews_raw (
    review_id TEXT,
    order_id TEXT,
    review_score TEXT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TEXT,
    review_answer_timestamp TEXT
);

CREATE TABLE if not exists products_raw (
    product_id TEXT,
    product_category_name TEXT,
    product_name_lenght TEXT,
    product_description_lenght TEXT,
    product_photos_qty TEXT,
    product_weight_g TEXT,
    product_length_cm TEXT,
    product_height_cm TEXT,
    product_width_cm TEXT
);

CREATE TABLE if not exists sellers_raw (
    seller_id TEXT,
    seller_zip_code_prefix TEXT,
    seller_city TEXT,
    seller_state TEXT
);

CREATE TABLE if not exists geolocation_raw (
    geolocation_zip_code_prefix TEXT,
    geolocation_lat TEXT,
    geolocation_lng TEXT,
    geolocation_city TEXT,
    geolocation_state TEXT
);

CREATE TABLE if not exists category_translation_raw (
    product_category_name TEXT,
    product_category_name_english TEXT
); 

/*
=============================
    3. DATA VALIDATION
    Purpose: Optional step to validate record counts after CSV ingestion
============================= */

SELECT COUNT(*) FROM orders_raw;
SELECT COUNT(*) FROM customers_raw;
SELECT COUNT(*) FROM products_raw;
select count(*) from geolocation_raw;
select count(*) from order_items_raw;
select count(*) from order_payments_raw;
select count(*) from order_reviews_raw;
select count(*) from sellers_raw;
