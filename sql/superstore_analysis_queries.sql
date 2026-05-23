/*
Superstore Sales & Profitability Analysis
SQL Query File

Project: Superstore Sales & Profitability Analysis Using SQL and Tableau
Tools used in notebook: Python, SQLite, SQL, Tableau

Note:
These queries use the cleaned Superstore table named `superstore`.
The cleaned table includes standardized snake_case columns and calculated fields:
- profit_margin
- shipping_days
- order_month
- discount_band

This SQL file is meant to document the main SQL analysis used in the Kaggle notebook.
*/

-- ============================================================
-- 1. Data Validation
-- ============================================================

-- Check total rows, unique orders, unique customers, and unique products
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT product_id) AS unique_products
FROM superstore;

-- Check date range
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM superstore;

-- Check overall sales, profit, and profit margin
SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent
FROM superstore;


-- ============================================================
-- 2. Overall Business Performance
-- ============================================================

SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_percent
FROM superstore;


-- ============================================================
-- 3. Regional Performance
-- ============================================================

SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY region
ORDER BY total_profit DESC;


-- ============================================================
-- 4. State-Level Performance
-- ============================================================

SELECT
    state,
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY state, region
ORDER BY total_profit DESC;


-- ============================================================
-- 5. Product Category Performance
-- ============================================================

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY category
ORDER BY total_profit DESC;


-- ============================================================
-- 6. Sub-Category Performance
-- ============================================================

SELECT
    sub_category,
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY sub_category, category
ORDER BY total_profit DESC;


-- Sub-categories sorted by lowest profit margin
SELECT
    sub_category,
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent
FROM superstore
GROUP BY sub_category, category
ORDER BY profit_margin_percent ASC;


-- ============================================================
-- 7. Customer Segment Performance
-- ============================================================

SELECT
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM superstore
GROUP BY segment
ORDER BY total_profit DESC;


-- ============================================================
-- 8. Discount Impact
-- ============================================================

-- Discount band performance
SELECT
    discount_band,
    COUNT(*) AS order_lines,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent
FROM superstore
GROUP BY discount_band
ORDER BY profit_margin_percent DESC;

-- Exact discount-level performance
SELECT
    discount,
    COUNT(*) AS order_lines,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent
FROM superstore
GROUP BY discount
ORDER BY discount;


-- ============================================================
-- 9. Discount Impact by Category
-- ============================================================

SELECT
    category,
    discount_band,
    COUNT(*) AS order_lines,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent
FROM superstore
GROUP BY category, discount_band
ORDER BY category, profit_margin_percent DESC;


-- ============================================================
-- 10. Monthly and Yearly Sales/Profit Trends
-- ============================================================

-- Monthly trend
SELECT
    order_month,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY order_month
ORDER BY order_month;

-- Yearly trend
SELECT
    SUBSTR(order_date, 1, 4) AS order_year,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY SUBSTR(order_date, 1, 4)
ORDER BY order_year;


-- ============================================================
-- 11. Shipping Analysis
-- ============================================================

SELECT
    ship_mode,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(shipping_days), 2) AS avg_shipping_days,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent
FROM superstore
GROUP BY ship_mode
ORDER BY total_orders DESC;


-- ============================================================
-- 12. Product-Level Analysis
-- ============================================================

-- Top 10 products by sales
SELECT
    product_name,
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY product_name, category, sub_category
ORDER BY total_sales DESC
LIMIT 10;

-- Top 10 products by profit
SELECT
    product_name,
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY product_name, category, sub_category
ORDER BY total_profit DESC
LIMIT 10;

-- Bottom 10 products by profit
SELECT
    product_name,
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY product_name, category, sub_category
ORDER BY total_profit ASC
LIMIT 10;

-- High-sales products with negative profit
SELECT
    product_name,
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY product_name, category, sub_category
HAVING SUM(sales) > 10000
   AND SUM(profit) < 0
ORDER BY total_sales DESC;
