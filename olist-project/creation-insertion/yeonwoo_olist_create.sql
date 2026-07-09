-- MySQL 서버에서
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';   -- ON 확인

CREATE DATABASE IF NOT EXISTS olist
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE olist;

CREATE TABLE customers (
  customer_id CHAR(32) PRIMARY KEY,
  customer_unique_id CHAR(32) NOT NULL,
  customer_zip_code_prefix INT,
  customer_city VARCHAR(64),
  customer_state CHAR(2)
) ENGINE=InnoDB;

CREATE TABLE geolocation (
  geolocation_zip_code_prefix INT,
  geolocation_lat DOUBLE,
  geolocation_lng DOUBLE,
  geolocation_city VARCHAR(64),
  geolocation_state CHAR(2),
  KEY idx_geo_zip (geolocation_zip_code_prefix)
) ENGINE=InnoDB;

CREATE TABLE sellers (
  seller_id CHAR(32) PRIMARY KEY,
  seller_zip_code_prefix INT,
  seller_city VARCHAR(64),
  seller_state CHAR(2)
) ENGINE=InnoDB;

CREATE TABLE products (
  product_id CHAR(32) PRIMARY KEY,
  product_category_name VARCHAR(64),
  product_name_length INT,
  product_description_length INT,
  product_photos_qty INT,
  product_weight_g INT,
  product_length_cm INT,
  product_height_cm INT,
  product_width_cm INT
) ENGINE=InnoDB;

CREATE TABLE product_category_translation (
  product_category_name VARCHAR(64) PRIMARY KEY,
  product_category_name_english VARCHAR(64)
) ENGINE=InnoDB;

CREATE TABLE orders (
  order_id CHAR(32) PRIMARY KEY,
  customer_id CHAR(32) NOT NULL,
  order_status VARCHAR(20),
  order_purchase_timestamp DATETIME,
  order_approved_at DATETIME NULL,
  order_delivered_carrier_date DATETIME NULL,
  order_delivered_customer_date DATETIME NULL,
  order_estimated_delivery_date DATETIME,
  KEY idx_orders_customer (customer_id)
) ENGINE=InnoDB;

CREATE TABLE order_items (
  order_id CHAR(32),
  order_item_id INT,
  product_id CHAR(32),
  seller_id CHAR(32),
  shipping_limit_date DATETIME,
  price DECIMAL(10,2),
  freight_value DECIMAL(10,2),
  PRIMARY KEY (order_id, order_item_id),
  KEY idx_oi_product (product_id),
  KEY idx_oi_seller (seller_id)
) ENGINE=InnoDB;

CREATE TABLE order_payments (
  order_id CHAR(32),
  payment_sequential INT,
  payment_type VARCHAR(20),
  payment_installments INT,
  payment_value DECIMAL(10,2),
  PRIMARY KEY (order_id, payment_sequential)
) ENGINE=InnoDB;

CREATE TABLE order_reviews (
  review_id CHAR(32),
  order_id CHAR(32),
  review_score TINYINT,
  review_comment_title VARCHAR(255),
  review_comment_message TEXT,
  review_creation_date DATETIME,
  review_answer_timestamp DATETIME,
  KEY idx_rev_order (order_id)
) ENGINE=InnoDB;

-- 단순 테이블들
LOAD DATA LOCAL INFILE 'C:/Users/Yowoo0303/olist_data/olist_customers_dataset.csv'
INTO TABLE customers CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/Yowoo0303/olist_data/olist_geolocation_dataset.csv'
INTO TABLE geolocation CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/Yowoo0303/olist_data/olist_sellers_dataset.csv'
INTO TABLE sellers CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/Yowoo0303/olist_data/product_category_name_translation.csv'
INTO TABLE product_category_translation CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/Yowoo0303/olist_data/olist_order_items_dataset.csv'
INTO TABLE order_items CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/Yowoo0303/olist_data/olist_order_payments_dataset.csv'
INTO TABLE order_payments CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- orders: 빈 날짜 3개 → NULL 처리
LOAD DATA LOCAL INFILE 'C:/Users/Yowoo0303/olist_data/olist_orders_dataset.csv'
INTO TABLE orders CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(order_id, customer_id, order_status, order_purchase_timestamp,
 @approved, @carrier, @delivered, order_estimated_delivery_date)
SET order_approved_at            = NULLIF(@approved,''),
    order_delivered_carrier_date = NULLIF(@carrier,''),
    order_delivered_customer_date= NULLIF(@delivered,'');

-- products: 빈 숫자/카테고리 → NULL 처리
LOAD DATA LOCAL INFILE 'C:/Users/Yowoo0303/olist_data/olist_products_dataset.csv'
INTO TABLE products CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(product_id, @cat, @nl, @dl, @pq, @wg, @lc, @hc, @wc)
SET product_category_name      = NULLIF(@cat,''),
    product_name_length        = NULLIF(@nl,''),
    product_description_length = NULLIF(@dl,''),
    product_photos_qty         = NULLIF(@pq,''),
    product_weight_g           = NULLIF(@wg,''),
    product_length_cm          = NULLIF(@lc,''),
    product_height_cm          = NULLIF(@hc,''),
    product_width_cm           = NULLIF(@wc,'');

-- reviews: 빈 제목/본문 → NULL 처리 (개행 포함 셀 주의, 아래 참고)
LOAD DATA LOCAL INFILE 'C:/Users/Yowoo0303/olist_data/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES
(review_id, order_id, review_score, @title, @msg,
 review_creation_date, review_answer_timestamp)
SET review_comment_title   = NULLIF(@title,''),
    review_comment_message = NULLIF(@msg,'');


SHOW PROCESSLIST;
SELECT 'customers' t, COUNT(*) n FROM customers
UNION ALL SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'category_translation', COUNT(*) FROM product_category_translation
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'order_reviews', COUNT(*) FROM order_reviews;


ALTER TABLE orders        ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
ALTER TABLE order_items   ADD FOREIGN KEY (order_id)    REFERENCES orders(order_id),
                          ADD FOREIGN KEY (product_id)  REFERENCES products(product_id),
                          ADD FOREIGN KEY (seller_id)   REFERENCES sellers(seller_id);
ALTER TABLE order_payments ADD FOREIGN KEY (order_id)   REFERENCES orders(order_id);
ALTER TABLE order_reviews  ADD FOREIGN KEY (order_id)   REFERENCES orders(order_id);

SELECT constraint_name, table_name, referenced_table_name
FROM information_schema.KEY_COLUMN_USAGE
WHERE table_schema = 'olist'
  AND referenced_table_name IS NOT NULL;
