/* ============================================================
   7. DIMENSION TABLES CREATION
   Purpose:
   - Create descriptive entities for analytical reporting
   - Introduce surrogate keys
   - Prepare star schema structure
============================================================ */

SET search_path TO analytics;

DROP TABLE IF EXISTS dim_customers;

CREATE TABLE dim_customers AS
SELECT
    ROW_NUMBER() OVER () AS customer_key,   -- surrogate key
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM staging.customers_stg;

DROP TABLE IF EXISTS dim_products;

CREATE TABLE dim_products AS
SELECT
    ROW_NUMBER() OVER () AS product_key,
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM staging.products_stg;

DROP TABLE IF EXISTS dim_sellers;

CREATE TABLE dim_sellers AS
SELECT
    ROW_NUMBER() OVER () AS seller_key,
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM staging.sellers_stg;

/* =============================
   7. DIMENSION VALIDATION
============================= */

SELECT COUNT(*) FROM staging.customers_stg;
SELECT COUNT(*) FROM analytics.dim_customers;

SELECT COUNT(*) from staging.products_stg;
SELECT COUNT(*) FROM analytics.dim_products;

SELECT COUNT(*) from staging.sellers_stg;
SELECT COUNT(*) FROM analytics.dim_sellers;

/* ============================================================
   8. FACT TABLE CREATION
   Purpose:
   - Store measurable transactional data
   - Connect dimensions through surrogate keys
   - Enable revenue and performance analysis
============================================================ */

SET search_path TO analytics;

DROP TABLE IF EXISTS fact_order_items;

CREATE TABLE fact_order_items AS
SELECT
    oi.order_id,
    p.product_key,
    s.seller_key,
    c.customer_key,
    oi.order_item_id,
    oi.price,
    oi.freight_value,
    o.order_status,
    o.purchase_ts
FROM staging.order_items_stg oi
JOIN staging.orders_stg o
    ON oi.order_id = o.order_id
JOIN analytics.dim_products p
    ON oi.product_id = p.product_id
JOIN analytics.dim_sellers s
    ON oi.seller_id = s.seller_id
JOIN analytics.dim_customers c
    ON o.customer_id = c.customer_id;


/* =============================
   9. FACTS VALIDATION
============================= */

SELECT COUNT(*) FROM analytics.fact_order_items;
SELECT COUNT(*) FROM staging.order_items_stg;

/* ============================================================
   10. DATE DIMENSION CREATION (dim_date)
   Purpose:
   - Standardize time-based analysis
   - Enable year/month/quarter aggregations
   - Support business reporting requirements
============================================================ */

DROP TABLE IF EXISTS analytics.dim_date;

CREATE TABLE analytics.dim_date AS
SELECT DISTINCT
    DATE(purchase_ts) AS date_key,
    EXTRACT(YEAR FROM purchase_ts) AS year,
    EXTRACT(MONTH FROM purchase_ts) AS month,
    EXTRACT(DAY FROM purchase_ts) AS day,
    EXTRACT(QUARTER FROM purchase_ts) AS quarter,
    TO_CHAR(purchase_ts, 'Month') AS month_name,
    TO_CHAR(purchase_ts, 'Day') AS day_name
FROM analytics.fact_order_items;

/* =============================
   11. VALIDATE DIM_DATE
============================= */

	/* Check Row Count */
SELECT COUNT(*) FROM analytics.dim_date;

	/* Check Min & Max Dates */
SELECT MIN(date_key), MAX(date_key)
FROM analytics.dim_date;

	/* Check for Null Dates */
SELECT * FROM analytics.dim_date
WHERE date_key IS NULL;

/* ============================================================
   8. ADDING PRIMARY & FOREIGN KEY CONSTRAINTS
   Purpose:
   - Enforce data integrity
   - Prevent orphan records
   - Simulate production-grade warehouse design
============================================================ */

/* -------------------------------
   8.1 PRIMARY KEYS - DIMENSIONS
-------------------------------- */

ALTER TABLE analytics.dim_customers
ADD PRIMARY KEY (customer_key);

ALTER TABLE analytics.dim_products
ADD PRIMARY KEY (product_key);

ALTER TABLE analytics.dim_sellers
ADD PRIMARY KEY (seller_key);

ALTER TABLE analytics.dim_date
ADD PRIMARY KEY (date_key);

/* -------------------------------
   8.2 FOREIGN KEYS - FACT TABLE
   Ensures referential integrity
-------------------------------- */

ALTER TABLE analytics.fact_order_items
ADD CONSTRAINT fk_product
FOREIGN KEY (product_key)
REFERENCES analytics.dim_products(product_key);

ALTER TABLE analytics.fact_order_items
ADD CONSTRAINT fk_seller
FOREIGN KEY (seller_key)
REFERENCES analytics.dim_sellers(seller_key);

ALTER TABLE analytics.fact_order_items
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_key)
REFERENCES analytics.dim_customers(customer_key);

/* ===========================================
   8.3 CONSTRAINT VALIDATION
   Purpose:
   - Confirm referential integrity
   - Ensure no orphan dimension keys exist
============================================== */

/* Check for Orphan Product Keys */
SELECT COUNT(*) AS orphan_products
FROM analytics.fact_order_items f
LEFT JOIN analytics.dim_products d
    ON f.product_key = d.product_key
WHERE d.product_key IS NULL;

/* Check for Orphan Seller Keys */
SELECT COUNT(*) AS orphan_sellers
FROM analytics.fact_order_items f
LEFT JOIN analytics.dim_sellers d
    ON f.seller_key = d.seller_key
WHERE d.seller_key IS NULL;

/* Check for Orphan Customer Keys*/
SELECT COUNT(*) AS orphan_customers
FROM analytics.fact_order_items f
LEFT JOIN analytics.dim_customers d
    ON f.customer_key = d.customer_key
WHERE d.customer_key IS NULL;