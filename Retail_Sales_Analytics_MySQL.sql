-- ============================================
-- RETAIL ANALYTICS PROJECT
-- SQL ANALYSIS QUERIES
-- ============================================

-- Q1. Total Records + Unique Orders
SELECT
    COUNT(*) AS total_record,
    COUNT(DISTINCT Order_id) AS distinct_order
FROM fact_sales;


-- Q2. Customers & Products
SELECT
    COUNT(DISTINCT Customer_id) AS total_customer,
    COUNT(DISTINCT `Product ID`) AS total_product
FROM fact_sales;


-- Q3. Overall KPIs
SELECT
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    SUM(Quantity) AS total_quantity,
    AVG(Discount) AS average_discount
FROM fact_sales;


-- Q4. Category Performance
SELECT
    Category,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM fact_sales
GROUP BY Category;


-- Q5. Sub-Category Performance
SELECT
    Sub_Category,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM fact_sales
GROUP BY Sub_Category;


-- Q6. Top 10 Products by Sales
SELECT
    Product_name,
    SUM(Sales) AS total_sales
FROM fact_sales
GROUP BY Product_name
ORDER BY total_sales DESC
LIMIT 10;


-- Q7. Top 10 Products by Profit
SELECT
    Product_name,
    SUM(Profit) AS total_profit
FROM fact_sales
GROUP BY Product_name
ORDER BY total_profit DESC
LIMIT 10;


-- Q8. Loss-Making Products
SELECT
    Product_name,
    SUM(Profit) AS total_profit
FROM fact_sales
GROUP BY Product_name
HAVING total_profit < 0
ORDER BY total_profit ASC;


-- Q9. Region Performance
SELECT
    Region,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM fact_sales
GROUP BY Region;


-- Q10. Top 10 States by Sales
SELECT
    State,
    SUM(Sales) AS total_sales
FROM fact_sales
GROUP BY State
ORDER BY total_sales DESC
LIMIT 10;


-- Q11. Top 10 Customers
SELECT
    Customer_name,
    SUM(Sales) AS total_sales
FROM fact_sales
GROUP BY Customer_name
ORDER BY total_sales DESC
LIMIT 10;


-- Q12. Customer Segment Performance
SELECT
    Segment,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM fact_sales
GROUP BY Segment;


-- Q13. Sales & Profit Trend
SELECT
    Order_year,
    Order_month,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM fact_sales
GROUP BY Order_year, Order_month
ORDER BY Order_year ASC;


-- Q14. Discount vs Profit
SELECT
    CASE
        WHEN Discount < 0.10 THEN '0-10%'
        WHEN Discount < 0.20 THEN '10-20%'
        WHEN Discount < 0.30 THEN '20-30%'
        ELSE '30%+'
    END AS discount_range,
    COUNT(DISTINCT Order_id) AS total_orders,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM fact_sales
GROUP BY discount_range;


-- Q15. High-Discount Loss Analysis
SELECT
    Category,
    Region,
    MAX(Discount) AS high_discount,
    SUM(Profit) AS total_profit
FROM fact_sales
GROUP BY Category, Region
HAVING total_profit < 0
ORDER BY total_profit ASC;


-- Q16. Rank Regions by Profit
SELECT
    Region,
    SUM(Profit) AS total_profit,
    RANK() OVER (
        ORDER BY SUM(Profit) ASC
    ) AS profit_rank
FROM fact_sales
GROUP BY Region;


-- Q17. Top Customer in Each Segment
WITH customer_rank AS (
    SELECT
        Segment,
        Customer_name,
        SUM(Sales) AS total_sales,
        RANK() OVER (
            PARTITION BY Segment
            ORDER BY SUM(Sales) DESC
        ) AS sales_rank
    FROM fact_sales
    GROUP BY Segment, Customer_name
)
SELECT
    Segment,
    Customer_name,
    total_sales
FROM customer_rank
WHERE sales_rank = 1;