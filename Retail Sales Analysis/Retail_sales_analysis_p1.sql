-- SQL Retail Sales Analysis Project1
CREATE DATABASE sql_project_retail;

-- Create Table
CREATE TABLE retail_sales
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id	 INT,
				gender VARCHAR(15),
				age	INT,
				category VARCHAR(15),
				quantity	INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
  			);

SELECT * FROM retail_sales

SELECT 
	COUNT(*) 
FROM retail_sales

-- Data Cleaning

-- 1. Find rows with null values 

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- 2. Delete rows where quantity, price_per_unit, cogs & total_sale is NULL

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;


-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sales from retail_sales

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_customers from retail_sales

---- What are the unique product categories?
SELECT DISTINCT Category as total_categories from retail_sales

-- Data Analysis & Key Business Problems with solutions
--My Analysis & Findings

-- 1. Write a SQL query to retrieve all columns for sales made on 5 November 2022

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022:

SELECT * 
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND quantity >= 4
	AND sale_date between '2022-11-01' and '2022-11-30';


-- 3. Write a SQL query to calculate the total sales and orders for each category and find which category gets the highest sales

SELECT category,
	SUM(total_sale) as net_sales,
	COUNT(quantity) as total_orders
	FROM retail_sales
GROUP BY category
ORDER BY net_sales desc;


-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
	
SELECT 
	ROUND(AVG(age),2) as avg_age_Beauty
	FROM retail_sales
WHERE category = 'Beauty';


--5. Write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT *
	FROM retail_sales
WHERE total_sale > 1000;


-- 6.Write a SQL query to find the total number of transactions made by each gender in each category and find the highst one

SELECT category, gender,
	COUNT(transactions_id) as total_transactions
	FROm retail_sales
GROUP BY category, gender
ORDER BY total_transactions desc;


-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
		year, month, avg_sales
	FROM 
(
	SELECT 
		EXTRACT (Year from sale_date) as year,
		EXTRACT (Month from sale_date) as month,
		AVG(total_sale) as avg_sales,
		RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG (total_sale) DESC)
	FROM retail_sales
	GROUP BY month, year
) as t1
WHERE rank = 1;


--8. Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 	
		customer_id,
		sum(total_sale) as total_sales
	FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

--9. Write a SQL query to find the number of unique customers who purchased items from each category

SELECT 
	category,
	COUNT(DISTINCT customer_id)
	FROM retail_sales
GROUP BY category;


--10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
	
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift


--END OF PROJECT


	
	
	
	
	

















