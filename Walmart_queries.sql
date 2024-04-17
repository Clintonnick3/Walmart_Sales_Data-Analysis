-- CREATING DATABASE

CREATE DATABASE IF NOT exists Walmartsales;

-- CREATING TABLE
CREATE TABLE IF NOT EXISTS sales( 
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
	customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_methods VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_per FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1)
);

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------ FEATURE ENGINEERING -----------------------------------------------------------------------------------------
-- DATA CLEANING OR WRANGLING

-- CREATING A TIME_OF_DAY COLUMN IN THE TABLE

SELECT
	time,
    (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:01" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
    ) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` BETWEEN "12:01:01" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
	END
);


-- CREATING A DAY_NAME COLUMN

SELECT
	date,
    DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name =DAYNAME(date);


-- CREATING A MONTH_NAME COLUMN

SELECT
	date,
    MONTHNAME(date) AS month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------GENERIC------------------------------------------------------------------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT
	DISTINCT city
FROM sales;

-- In which city is each branch?
SELECT
	DISTINCT city,
    branch
FROM sales;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------PRODUCT-----------------------------------------------------------------------------------------------------------
-- How many unique product lines does the data have?
SELECT
	COUNT(DISTINCT product_line)
FROM sales;

-- What is the most common payment method?
SELECT
	payment_methods,
    COUNT(payment_methods) AS cnt
FROM sales
GROUP BY payment_methods
ORDER BY cnt DESC;

-- What is the most selling product line?
SELECT
	product_line,
    COUNT(product_line) AS prd
FROM sales
GROUP BY product_line
ORDER BY prd DESC;

-- What is the total revenue by month?
SELECT
	month_name AS month,
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest COGS?
SELECT
	month_name AS month,
    SUM(cogs) AS cog
FROM sales
GROUP BY month_name
ORDER BY cog DESC;

-- What product line had the largest revenue?
SELECT
	product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT
	branch,
	city AS city,
    SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT
	product_line,
    AVG(VAT) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Which branch sold more products than average product sold?
SELECT
	branch,
    SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender?
SELECT
	gender,
    product_line,
    COUNT(gender) AS cnt
FROM sales
GROUP BY gender, product_line
ORDER BY cnt DESC;

-- What is the average rating of each product line?
SELECT
	product_line,
    ROUND(AVG(rating), 2)AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- ------------------------------------------------------------------------------------- SALES ----------------------------------------------------------------------------------------------------
-- Number of sales made in each time of the day per weekday
SELECT 
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
    SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
	city,
    AVG(VAT) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
    ROUND(AVG(VAT), 1) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;

-- --------------------------------------------------------------------- CUSTOMERS --------------------------------------------------------------------------------------------------------------
-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment_methods
FROM sales;

-- What is the most common customer type?
SELECT
	customer_type,
    COUNT(*) AS cust
FROM sales
GROUP BY customer_type
ORDER BY cust DESC;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT
	gender,
    COUNT(*) AS gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
    COUNT(*) AS gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;
    
-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;   

-- Which day for the week has the best avg ratings? 
SELECT
	day_name AS day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY day
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
SELECT
	day_name AS day,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "B"
GROUP BY day
ORDER BY avg_rating DESC;
    





