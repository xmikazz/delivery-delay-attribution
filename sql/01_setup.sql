-- 01_setup.sql
-- Delivery Delay Attribution — database setup
-- Source: Olist Brazilian E-Commerce Public Dataset (Kaggle)
-- Target: PostgreSQL 18, database `olist`


DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS order_payments;
DROP TABLE IF EXISTS order_reviews;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS geolocation;
DROP TABLE IF EXISTS product_category_translation;

CREATE TABLE orders (
    order_id                      varchar(32) PRIMARY KEY,
    customer_id                   varchar(32),
    order_status                  varchar(20),
    order_purchase_timestamp      timestamp,
    order_approved_at             timestamp,
    order_delivered_carrier_date  timestamp,
    order_delivered_customer_date timestamp,
    order_estimated_delivery_date timestamp
);

CREATE TABLE customers (
    customer_id              varchar(32) PRIMARY KEY,
    customer_unique_id       varchar(32),
    customer_zip_code_prefix int,
    customer_city            varchar(50),
    customer_state           varchar(2)
);

CREATE TABLE order_items (
    order_id            varchar(32),
    order_item_id       int,
    product_id          varchar(32),
    seller_id           varchar(32),
    shipping_limit_date timestamp,
    price               numeric(10,2),
    freight_value       numeric(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE order_payments (
    order_id             varchar(32),
    payment_sequential   int,
    payment_type         varchar(20),
    payment_installments int,
    payment_value        numeric(10,2)
);

-- No primary key: source file contains duplicate review_id values.
CREATE TABLE order_reviews (
    review_id               varchar(32),
    order_id                varchar(32),
    review_score            int,
    review_comment_title    text,
    review_comment_message  text,
    review_creation_date    timestamp,
    review_answer_timestamp timestamp
);

-- `lenght` misspelling is preserved from the source CSV headers.
CREATE TABLE products (
    product_id                 varchar(32) PRIMARY KEY,
    product_category_name      varchar(50),
    product_name_lenght        int,
    product_description_lenght int,
    product_photos_qty         int,
    product_weight_g           int,
    product_length_cm          int,
    product_height_cm          int,
    product_width_cm           int
);

CREATE TABLE sellers (
    seller_id              varchar(32) PRIMARY KEY,
    seller_zip_code_prefix int,
    seller_city            varchar(50),
    seller_state           varchar(2)
);

-- Multiple rows per zip prefix; averaged at analysis time.
CREATE TABLE geolocation (
    geolocation_zip_code_prefix int,
    geolocation_lat             numeric(12,8),
    geolocation_lng             numeric(12,8),
    geolocation_city            varchar(50),
    geolocation_state           varchar(2)
);

CREATE TABLE product_category_translation (
    product_category_name         varchar(50),
    product_category_name_english varchar(50)
);



SET client_encoding TO 'UTF8';

\copy orders FROM 'C:/Users/mikad/Desktop/AIM/Olist Dataset/olist_orders_dataset.csv' CSV HEADER;
\copy customers FROM 'C:/Users/mikad/Desktop/AIM/Olist Dataset/olist_customers_dataset.csv' CSV HEADER;
\copy order_items FROM 'C:/Users/mikad/Desktop/AIM/Olist Dataset/olist_order_items_dataset.csv' CSV HEADER;
\copy order_payments FROM 'C:/Users/mikad/Desktop/AIM/Olist Dataset/olist_order_payments_dataset.csv' CSV HEADER;
\copy order_reviews FROM 'C:/Users/mikad/Desktop/AIM/Olist Dataset/olist_order_reviews_dataset.csv' CSV HEADER;
\copy products FROM 'C:/Users/mikad/Desktop/AIM/Olist Dataset/olist_products_dataset.csv' CSV HEADER;
\copy sellers FROM 'C:/Users/mikad/Desktop/AIM/Olist Dataset/olist_sellers_dataset.csv' CSV HEADER;
\copy geolocation FROM 'C:/Users/mikad/Desktop/AIM/Olist Dataset/olist_geolocation_dataset.csv' CSV HEADER;
\copy product_category_translation FROM 'C:/Users/mikad/Desktop/AIM/Olist Dataset/product_category_name_translation.csv' CSV HEADER;


SELECT 'orders' AS t, COUNT(*) FROM orders
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL SELECT 'product_category_translation', COUNT(*) FROM product_category_translation;
