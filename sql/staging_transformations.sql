/* =============================
   4. STAGING TRANSFORMATION
============================= */

SET search_path TO staging;

DROP TABLE IF EXISTS orders_stg;

CREATE TABLE orders_stg AS
SELECT
    order_id,
    customer_id,
    order_status,
    NULLIF(order_purchase_timestamp, '')::timestamp AS purchase_ts,
    NULLIF(order_approved_at, '')::timestamp AS approved_ts,
    NULLIF(order_delivered_carrier_date, '')::timestamp AS delivered_carrier_ts,
    NULLIF(order_delivered_customer_date, '')::timestamp AS delivered_customer_ts,
    NULLIF(order_estimated_delivery_date, '')::date AS estimated_delivery_date
FROM raw.orders_raw;

SET search_path TO staging;

DROP TABLE IF EXISTS customers_stg;

CREATE TABLE customers_stg AS
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM raw.customers_raw;

SET search_path TO staging;

DROP TABLE IF EXISTS order_items_stg;

CREATE TABLE order_items_stg AS
SELECT
    order_id,
    order_item_id::int,
    product_id,
    seller_id,
    NULLIF(shipping_limit_date, '')::timestamp AS shipping_limit_ts,
    NULLIF(price, '')::numeric AS price,
    NULLIF(freight_value, '')::numeric AS freight_value
FROM raw.order_items_raw;

DROP TABLE IF EXISTS order_payments_stg;

SET search_path TO staging;

CREATE TABLE order_payments_stg AS
SELECT
    order_id,
    payment_sequential::int,
    payment_type,
    NULLIF(payment_installments, '')::int AS payment_installments,
    NULLIF(payment_value, '')::numeric AS payment_value
FROM raw.order_payments_raw;

SET search_path TO staging;

DROP TABLE IF EXISTS order_reviews_stg;

CREATE TABLE order_reviews_stg AS
SELECT
    review_id,
    order_id,
    NULLIF(review_score, '')::int AS review_score,
    review_comment_title,
    review_comment_message,
    NULLIF(review_creation_date, '')::timestamp AS review_creation_ts,
    NULLIF(review_answer_timestamp, '')::timestamp AS review_answer_ts
FROM raw.order_reviews_raw;

SET search_path TO staging;
DROP TABLE IF EXISTS products_stg;

CREATE TABLE products_stg AS
SELECT
    product_id,
    product_category_name,
    NULLIF(product_name_lenght, '')::int        AS product_name_length,
    NULLIF(product_description_lenght, '')::int AS product_description_length,
    NULLIF(product_photos_qty, '')::int         AS product_photos_qty,
    NULLIF(product_weight_g, '')::numeric       AS product_weight_g,
    NULLIF(product_length_cm, '')::numeric      AS product_length_cm,
    NULLIF(product_height_cm, '')::numeric      AS product_height_cm,
    NULLIF(product_width_cm, '')::numeric       AS product_width_cm
FROM raw.products_raw;

SET search_path TO staging;
DROP TABLE IF EXISTS sellers_stg;

CREATE TABLE sellers_stg AS
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM raw.sellers_raw;

SET search_path TO staging;
DROP TABLE IF EXISTS geolocation_stg;

CREATE TABLE geolocation_stg AS
SELECT
    geolocation_zip_code_prefix,
    NULLIF(geolocation_lat, '')::numeric AS geolocation_lat,
    NULLIF(geolocation_lng, '')::numeric AS geolocation_lng,
    geolocation_city,
    geolocation_state
FROM raw.geolocation_raw;

SET search_path TO staging;
DROP TABLE IF EXISTS category_translation_stg;

CREATE TABLE category_translation_stg AS
SELECT
    product_category_name,
    product_category_name_english
FROM raw.category_translation_raw;


/* =============================
   5. STAGING VALIDATION
    Purpose: Validate record counts after staging transformations
============================= */

SELECT COUNT(*) FROM raw.orders_raw;
SELECT COUNT(*) FROM staging.orders_stg;

SELECT COUNT(*) FROM raw.customers_raw;
SELECT COUNT(*) FROM staging.customers_stg;

SELECT COUNT(*) FROM raw.order_items_raw;
SELECT COUNT(*) FROM staging.order_items_stg;

SELECT COUNT(*) FROM raw.order_payments_raw;
SELECT COUNT(*) from staging.order_payments_stg;

SELECT COUNT(*) FROM raw.order_reviews_raw;
SELECT COUNT(*) from staging.order_reviews_stg;

SELECT COUNT(*) FROM raw.products_raw;
SELECT COUNT(*) from staging.products_stg;

SELECT COUNT(*) FROM raw.sellers_raw;
SELECT COUNT(*) from staging.sellers_stg;

SELECT COUNT(*) FROM raw.geolocation_raw;
SELECT COUNT(*) from staging.geolocation_stg;

SELECT COUNT(*) FROM raw.category_translation_raw;
SELECT COUNT(*) from staging.category_translation_stg;
