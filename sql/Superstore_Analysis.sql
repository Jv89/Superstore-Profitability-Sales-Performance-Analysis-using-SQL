/*
Superstore Profitability & Sales Performance Analysis using SQL

Purpose:
Analyze sales, profit, discount behavior, regional performance, product performance,
and customer contribution using SQL.

Assumption:
The CSV file has been imported into a table named superstore.
Column names with spaces are wrapped in double quotes.
*/

-- =========================================================
-- 1. Overall business summary
-- =========================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT "Order ID") AS total_orders,
    COUNT(DISTINCT "Customer ID") AS total_customers,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_pct
FROM superstore;


-- =========================================================
-- 2. Sales, profit, and margin by region
-- Business question: Which regions perform best?
-- =========================================================

SELECT
    Region,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY Region
ORDER BY total_profit DESC;


-- =========================================================
-- 3. Category profitability analysis
-- Business question: Which categories generate the most profit?
-- =========================================================

SELECT
    Category,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY Category
ORDER BY total_profit DESC;


-- =========================================================
-- 4. Sub-category profitability analysis
-- Business question: Which sub-categories are profit drivers or loss drivers?
-- =========================================================

SELECT
    Category,
    "Sub-Category",
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY Category, "Sub-Category"
ORDER BY total_profit ASC;


-- =========================================================
-- 5. Discount impact using CASE WHEN
-- Business question: Are discounts helping or hurting profitability?
-- =========================================================

SELECT
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount > 0 AND Discount <= 0.20 THEN 'Low Discount (0.01 - 0.20)'
        WHEN Discount > 0.20 AND Discount <= 0.50 THEN 'Medium Discount (0.21 - 0.50)'
        ELSE 'High Discount (> 0.50)'
    END AS discount_level,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(Profit), 2) AS avg_profit_per_row,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount > 0 AND Discount <= 0.20 THEN 'Low Discount (0.01 - 0.20)'
        WHEN Discount > 0.20 AND Discount <= 0.50 THEN 'Medium Discount (0.21 - 0.50)'
        ELSE 'High Discount (> 0.50)'
    END
ORDER BY total_profit DESC;


-- =========================================================
-- 6. Profit status using CASE WHEN
-- Business question: How many order lines are profitable vs. unprofitable?
-- =========================================================

SELECT
    CASE
        WHEN Profit > 0 THEN 'Profitable'
        WHEN Profit = 0 THEN 'Break Even'
        ELSE 'Loss'
    END AS profit_status,
    COUNT(*) AS total_rows,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(Profit), 2) AS avg_profit
FROM superstore
GROUP BY
    CASE
        WHEN Profit > 0 THEN 'Profitable'
        WHEN Profit = 0 THEN 'Break Even'
        ELSE 'Loss'
    END
ORDER BY total_profit DESC;


-- =========================================================
-- 7. Customer value segmentation using CASE WHEN
-- Business question: Which customers are high-value, mid-value, or low-value?
-- =========================================================

WITH customer_performance AS (
    SELECT
        "Customer ID",
        "Customer Name",
        COUNT(DISTINCT "Order ID") AS total_orders,
        ROUND(SUM(Sales), 2) AS total_sales,
        ROUND(SUM(Profit), 2) AS total_profit
    FROM superstore
    GROUP BY "Customer ID", "Customer Name"
)
SELECT
    "Customer ID",
    "Customer Name",
    total_orders,
    total_sales,
    total_profit,
    CASE
        WHEN total_profit >= 1000 THEN 'High Value Customer'
        WHEN total_profit BETWEEN 250 AND 999.99 THEN 'Medium Value Customer'
        WHEN total_profit > 0 AND total_profit < 250 THEN 'Low Value Customer'
        ELSE 'Unprofitable Customer'
    END AS customer_value_segment
FROM customer_performance
ORDER BY total_profit DESC;


-- =========================================================
-- 8. Top 10 customers by profit
-- Business question: Which customers contribute the most profit?
-- =========================================================

SELECT
    "Customer ID",
    "Customer Name",
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY "Customer ID", "Customer Name"
ORDER BY total_profit DESC
LIMIT 10;


-- =========================================================
-- 9. Bottom 10 products by profit
-- Business question: Which products are creating the largest losses?
-- =========================================================

SELECT
    "Product Name",
    Category,
    "Sub-Category",
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY "Product Name", Category, "Sub-Category"
HAVING SUM(Profit) < 0
ORDER BY total_profit ASC
LIMIT 10;


-- =========================================================
-- 10. Shipping mode performance
-- Business question: Which shipping modes are most used and most profitable?
-- =========================================================

SELECT
    "Ship Mode",
    COUNT(DISTINCT "Order ID") AS total_orders,
    SUM(Quantity) AS total_quantity,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY "Ship Mode"
ORDER BY total_orders DESC;


-- =========================================================
-- 11. Sales and profit trend by year
-- Business question: Is the business growing over time?
-- Note: Date syntax may need adjustment depending on SQL engine.
-- PostgreSQL-compatible version below.
-- =========================================================

SELECT
    EXTRACT(YEAR FROM TO_DATE("Order Date", 'MM/DD/YYYY')) AS order_year,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY EXTRACT(YEAR FROM TO_DATE("Order Date", 'MM/DD/YYYY'))
ORDER BY order_year;


-- =========================================================
-- 12. Sales and profit trend by month
-- Business question: What are the monthly performance trends?
-- PostgreSQL-compatible version below.
-- =========================================================

SELECT
    DATE_TRUNC('month', TO_DATE("Order Date", 'MM/DD/YYYY')) AS order_month,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY DATE_TRUNC('month', TO_DATE("Order Date", 'MM/DD/YYYY'))
ORDER BY order_month;


-- =========================================================
-- 13. Ranking sub-categories by profit within each category
-- Business question: Which sub-categories rank highest inside each category?
-- =========================================================

WITH subcategory_performance AS (
    SELECT
        Category,
        "Sub-Category",
        ROUND(SUM(Sales), 2) AS total_sales,
        ROUND(SUM(Profit), 2) AS total_profit
    FROM superstore
    GROUP BY Category, "Sub-Category"
)
SELECT
    Category,
    "Sub-Category",
    total_sales,
    total_profit,
    RANK() OVER (
        PARTITION BY Category
        ORDER BY total_profit DESC
    ) AS profit_rank_within_category
FROM subcategory_performance
ORDER BY Category, profit_rank_within_category;


-- =========================================================
-- 14. Region and category performance matrix
-- Business question: Which region-category combinations should be prioritized?
-- =========================================================

SELECT
    Region,
    Category,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_pct,
    CASE
        WHEN SUM(Profit) < 0 THEN 'Needs Immediate Review'
        WHEN SUM(Profit) / NULLIF(SUM(Sales), 0) < 0.05 THEN 'Low Margin'
        WHEN SUM(Profit) / NULLIF(SUM(Sales), 0) BETWEEN 0.05 AND 0.15 THEN 'Healthy Margin'
        ELSE 'Strong Margin'
    END AS margin_status
FROM superstore
GROUP BY Region, Category
ORDER BY total_profit ASC;


-- =========================================================
-- 15. Data quality checks
-- Business question: Are there missing or suspicious values in key fields?
-- =========================================================

SELECT
    SUM(CASE WHEN "Order ID" IS NULL THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN "Customer ID" IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN "Product ID" IS NULL THEN 1 ELSE 0 END) AS missing_product_id,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS missing_sales,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS missing_profit,
    SUM(CASE WHEN Discount < 0 OR Discount > 1 THEN 1 ELSE 0 END) AS invalid_discount_values,
    SUM(CASE WHEN Quantity <= 0 THEN 1 ELSE 0 END) AS invalid_quantity_values
FROM superstore;
