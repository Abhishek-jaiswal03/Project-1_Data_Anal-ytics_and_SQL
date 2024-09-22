select * from orders_data;
-- write a SQL query to list all distict cities where orders have been shipped
SELECT DISTINCT city FROM orders_data;

-- CALCULATE THE TOTAL SELLING PRICE AND PROFITS FOR ALL ORDERS 
SELECT `ORDER ID`, 
       SUM(QUANTITY * UNIT_SELLING_PRICE) AS `TOTAL_SELLING_PRICE`,
       CAST(SUM(QUANTITY * UNIT_PROFIT) AS DECIMAL(10,2)) AS `TOTAL_PROFIT`
FROM orders_data
GROUP BY `ORDER ID`
ORDER BY `TOTAL_PROFIT` DESC;

-- WRITE A QUERY TO FIND ALL ORDERS FROM THE 'TECHNOLOGY' CATEGORY THAT WERE SHIPPED USING 'SECOND CLASS' SHIP MODE ,ORDERED BY ORDER DATE.
SELECT `ORDER ID`, `ORDER DATE`
FROM orders_data
WHERE CATEGORY = 'TECHNOLOGY' AND `SHIP MODE` = 'SECOND CLASS'
ORDER BY `ORDER DATE`;

-- WRITE A QUERY TO FIND THE AVERAGE ORDER VALUE
SELECT CAST(AVG(QUANTITY * UNIT_SELLING_PRICE) AS DECIMAL(10,2)) AS AOV
FROM orders_data;

-- FIND THE CITY WITH THE HIGHEST TOTAL QUANTITY OF PRODUCTS ORDERED.
SELECT CITY, SUM(QUANTITY) AS `TOTAL_QUANTITY`
FROM orders_data
GROUP BY CITY
ORDER BY `TOTAL_QUANTITY` DESC
LIMIT 1;


-- USE A WINDOW FUNCTION TO RANK IN EACH REGION BY QUANTITY IN DESCENDING ORDER.

SELECT `ORDER ID`, 
       REGION, 
       QUANTITY AS `TOTAL_QUANTITY`,
       DENSE_RANK() OVER (PARTITION BY REGION ORDER BY QUANTITY DESC) AS RNK
FROM orders_data
ORDER BY REGION, RNK;

-- Write a SQL query to list all orders placed in the first quarter of any year (January to March), including the total cost for these orders.
SELECT `order id`, 
       `order date`, 
       MONTH(`order date`) AS month
FROM orders_data;
SELECT `order id`, 
       SUM(Quantity * unit_selling_price) AS `Total Value`
FROM orders_data
WHERE MONTH(`order date`) IN (1, 2, 3)
GROUP BY `order id`
ORDER BY `Total Value` DESC;


-- Find top 3 highest selling products in each region

WITH cte AS (
    SELECT `region`, 
           `product id`, 
           SUM(quantity * unit_selling_price) AS sales,
           ROW_NUMBER() OVER (PARTITION BY `region` ORDER BY SUM(quantity * unit_selling_price) DESC) AS rn
    FROM `orders_data`
    GROUP BY `region`, `product id`
) 
SELECT * 
FROM cte
WHERE rn <= 3;


WITH cte AS (
    SELECT `region`, 
           `product id`, 
           SUM(quantity * unit_selling_price) AS sales
    FROM `orders_data`
    GROUP BY `region`, `product id`
) 
SELECT * 
FROM (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY `region` ORDER BY sales DESC) AS rn
    FROM cte
) AS A
WHERE rn <= 3;


-- Find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
WITH cte AS (
    SELECT YEAR(`order date`) AS order_year,
           MONTH(`order date`) AS order_month,
           SUM(quantity * unit_selling_price) AS sales
    FROM orders_data
    GROUP BY YEAR(`order date`), MONTH(`order date`)
)
SELECT order_month,
       ROUND(SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END), 2) AS sales_2022,
       ROUND(SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END), 2) AS sales_2023
FROM cte
GROUP BY order_month
ORDER BY order_month;


-- Find the Month with the Highest Sales for Each Category
WITH cte AS (
    SELECT category, 
           DATE_FORMAT(`order date`, '%Y-%m') AS order_year_month,
           SUM(quantity * unit_selling_price) AS sales,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY SUM(quantity * unit_selling_price) DESC) AS rn
    FROM orders_data
    GROUP BY category, DATE_FORMAT(`order date`, '%Y-%m')
)
SELECT category AS `Category`, 
       order_year_month AS `Order Year-Month`, 
       sales AS `Total Sales`
FROM cte
WHERE rn = 1;


-- Find the Sub-Category with the Highest Sales Growth in 2023 Compared to 2022

WITH cte AS (
    SELECT `sub category` AS sub_category, 
           YEAR(`order date`) AS order_year,
           SUM(quantity * unit_selling_price) AS sales
    FROM orders_data
    GROUP BY `sub category`, YEAR(`order date`)
),
cte2 AS (
    SELECT sub_category,
           ROUND(SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END), 2) AS sales_2022,
           ROUND(SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END), 2) AS sales_2023
    FROM cte
    GROUP BY sub_category
)
SELECT sub_category AS `Sub Category`, 
       sales_2022 AS `Sales in 2022`,
       sales_2023 AS `Sales in 2023`,
       (sales_2023 - sales_2022) AS `Diff in Amount`
FROM cte2
ORDER BY `Diff in Amount` DESC
LIMIT 1;





