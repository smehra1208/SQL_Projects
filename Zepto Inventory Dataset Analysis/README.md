# Zepto Inventory Dataset Analysis 

## Project Overview

## Project Title: Zepto Inventory  
## Database: `zepto_inventory_db` 

## Project Overview  

This project simulates the real-world workflow of data analysts in the e-commerce and retail domain. The aim is to demonstrate how SQL can be applied to manage and analyze messy inventory data, uncover insights, and support business decisions.  

### Key Objectives  
- **Database Setup**: Create a realistic, unstructured e-commerce inventory database.  
- **Exploratory Data Analysis (EDA)**: Investigate product categories, stock availability, and pricing inconsistencies.  
- **Data Cleaning**: Handle missing values, remove invalid records, and standardize pricing by converting from paise to rupees.  
- **Business-Driven SQL Queries**: Extract actionable insights related to pricing, inventory, stock levels, revenue, and more. 

## Dataset Overview  

The dataset is sourced from **Kaggle** and originally scraped from **Zepto’s official product listings**. It closely mirrors the type of data you’d find in a real-world e-commerce inventory system.  

- Each row corresponds to a unique **SKU (Stock Keeping Unit)**.  
- Duplicate product names exist because the same product can appear across multiple **package sizes, weights, discounts, or categories**—a common trait in retail catalog data.  
- This structure reflects the messy, unstandardized nature of actual e-commerce datasets, making it ideal for practicing **data cleaning and analysis with SQL**.  

## Dataset Columns  

- **sku_id**: Unique identifier for each product entry (synthetic primary key).  
- **category**: Product category (e.g., Fruits, Snacks, Beverages).
- **name**: Product name as displayed on the app.     
- **mrp**: Maximum Retail Price, originally in paise and converted to ₹.  
- **discountPercent**: Discount percentage applied to the MRP.  
- **availableQuantity**: Number of units currently available in inventory. 
- **discountedSellingPrice**: Final selling price after discount (converted to ₹).   
- **weightInGms**: Product weight in grams.  
- **outOfStock**: Boolean flag indicating whether the product is out of stock.  
- **quantity**: Number of units per package (sometimes mixed with weight for loose produce). 

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `zepto_inventory_db`.
- **Table Creation**: A table named `zepto_inventory` is created to store the data. The table structure includes columns for sku_id, category, name, mrp, discountPercent, availableQuantity, discountedSellingPrice, weightInGms, outOfStock and quantity.

```sql

# Database Setup 
This section outlines the steps to create the database, define the schema, and load the dataset into PostgreSQL using **pgAdmin**.  

## Step 1: Create Database  

```sql
-- Create a new database
CREATE DATABASE zepto_inventory_db;

-- Create table with all fields, appropriate datatypes and constraints
CREATE TABLE inventory
(
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent NUMERIC(5,2),
    availableQuantity INT,
    discountedSellingPrice NUMERIC(8,2),
    weightInGms INT,
    outOfStock BOOLEAN,
    quantity INT
);

-- Verify table creation
SELECT * FROM inventory;

-- Populate the table with data by loading the csv file: using pgadmin's import feature
If you encounter a UTF encoding error during import, simply re-save the CSV file in **CSV UTF-8 format**. This will resolve the issue.  
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to  4 in the month of Nov-2022**:
```sql
SELECT * 
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND quantity >= 4
	AND sale_date between '2022-11-01' and '2022-11-30';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category and find which category gets the highest sales.**:
```sql
SELECT category,
	SUM(total_sale) as net_sales,
	COUNT(quantity) as total_orders
	FROM retail_sales
GROUP BY category
ORDER BY net_sales desc;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT 
	ROUND(AVG(age),2) as avg_age_Beauty
	FROM retail_sales
WHERE category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT *
	FROM retail_sales
WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category and find the highst one.**:
```sql
SELECT category, gender,
	COUNT(transactions_id) as total_transactions
	FROm retail_sales
GROUP BY category, gender
ORDER BY total_transactions desc;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 	
		customer_id,
		sum(total_sale) as total_sales
	FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
	category,
	COUNT(DISTINCT customer_id)
	FROM retail_sales
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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

```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories i.e  Electronics, Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.



This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
