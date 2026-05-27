-------Build the First Mart: Customer Metrics------

CREATE TABLE marts.customer_metrics AS
SELECT
    c.customer_key,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.price) AS total_spent,
    AVG(f.price) AS avg_order_value,
    MIN(f.purchase_ts) AS first_purchase_date,
    MAX(f.purchase_ts) AS last_purchase_date,
    CURRENT_DATE - MAX(f.purchase_ts) AS days_since_last_order
FROM analytics.fact_order_items f
JOIN analytics.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key;

-----Validation-----
SELECT COUNT(*) FROM marts.customer_metrics;
select COUNT(*) from analytics.dim_customers;

-----Check Sample Data----

select * from marts.customer_metrics limit 10;

-------analyzes seller performance--------

CREATE TABLE marts.seller_metrics AS
SELECT
    s.seller_key,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.price) AS total_revenue,
    AVG(r.review_score) AS avg_review_score,
    AVG(
        DATE_PART('day', o.delivered_customer_ts - o.purchase_ts)
    ) AS avg_delivery_days,
    SUM(
        CASE 
            WHEN o.delivered_customer_ts > o.estimated_delivery_date 
            THEN 1 ELSE 0 
        END
    )::float / COUNT(*) AS late_delivery_rate
FROM analytics.fact_order_items f
JOIN analytics.dim_sellers s
ON f.seller_key = s.seller_key
JOIN staging.orders_stg o
ON f.order_id = o.order_id
LEFT JOIN staging.order_reviews_stg r
ON f.order_id = r.order_id
GROUP BY s.seller_key;

-----Validation-----

SELECT COUNT(*) FROM marts.seller_metrics;
SELECT COUNT(*) FROM analytics.dim_sellers;

-----Check Sample Data----

SELECT *  FROM marts.seller_metrics LIMIT 10;

-----Quick logic validation----

select seller_key, total_revenue from marts.seller_metrics order by total_revenue  desc limit 10;

----Delivery performance check------

select avg(late_delivery_rate) from  marts.seller_metrics;

----delivery-related features for ML-----

CREATE TABLE marts.delivery_features AS
SELECT
    f.order_id,
    f.customer_key,
    f.seller_key,
    f.product_key,
    f.price,
    f.freight_value,
    o.purchase_ts,
    o.estimated_delivery_date,
    o.delivered_customer_ts,

    DATE_PART(
        'day',
        o.delivered_customer_ts - o.purchase_ts
    ) AS delivery_days,

    DATE_PART(
        'day',
        o.estimated_delivery_date - o.purchase_ts
    ) AS estimated_delivery_days,

    CASE
        WHEN o.delivered_customer_ts > o.estimated_delivery_date
        THEN 1
        ELSE 0
    END AS late_delivery_flag

FROM analytics.fact_order_items f
JOIN staging.orders_stg o
ON f.order_id = o.order_id;


------Validate-----

SELECT COUNT(*) FROM marts.delivery_features;
SELECT COUNT(*) FROM analytics.fact_order_items;

-----Check Distribution of Late Deliveries----

SELECT
    late_delivery_flag,
    COUNT(*)
FROM marts.delivery_features
GROUP BY late_delivery_flag;

----Check Sample Data----
SELECT *
FROM marts.delivery_features
LIMIT 10;

