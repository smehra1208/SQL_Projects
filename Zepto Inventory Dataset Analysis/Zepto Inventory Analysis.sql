--Create database
CREATE DATABASE zepto_inventory_db;

-- Create table with all fieldsa, appropiate datatypes and constraints
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
SELECT* FROM inventory;

-- Populate the table with data by loading the csv file: using pgadmin's import feature


--Data Exploration
--1. Count the total number of records in the dataset
SELECT COUNT(*)
	FROM inventory

--2. View a sample of the dataset to understand structure and content
SELECT *
	FROM inventory
LIMIT 10

--3. Check for null values across all columns
SELECT *
	FROM inventory
WHERE sku_id IS NULL OR
	  category IS NULL OR
	  name IS NULL OR
	  mrp IS NULL OR
	  discountPercent IS NULL OR
	  availableQuantity IS NULL OR
	  discountedSellingPrice IS NULL OR
	  weightInGms IS NULL OR
	  outOfStock IS NULL OR
	  quantity IS NULL;

-- 4.Identify distinct product categories
SELECT DISTINCT category
	FROM inventory
ORDER BY category ASC;

-- 5.Compare in-stock vs out-of-stock product counts
SELECT outofstock, COUNT(*)
	FROM inventory
GROUP BY outofstock;

-- 6.Detect products present multiple times, representing different SKUs and categories
SELECT name, category, count(sku_id) as No_of_SKUs
	FROM inventory
GROUP BY name, category
HAVING count(sku_id) >1
ORDER BY name ASC, No_of_SKUs DESC;


-- Data Cleaning
-- 1. Identify and remove rows where MRP or discounted selling price was zero
SELECT * 
	FROM inventory
WHERE mrp = 0 OR
	  discountedSellingPrice = 0;

DELETE from inventory
	WHERE sku_id = 3830;


-- 2. Convert mrp and discountedSellingPrice from paise to rupees for consistency and readability
UPDATE inventory
SET mrp = ROUND(mrp/100, 2),
	discountedSellingPrice = ROUND(discountedSellingPrice/100, 2);

-- Verifying if converted from paise to rupees
SELECT mrp, discountedSellingPrice from inventory


-- Business Insights
-- 1. Found top 10 best-value products based on discount percentage
SELECT DISTINCT name, mrp, discountPercent 
	FROM inventory
ORDER BY discountPercent DESC
LIMIT 10;

-- 2. Identify high-MRP products that are currently out of stock
SELECT DISTINCT name, mrp
	FROm inventory
WHERE outOfStock is TRUE AND
	  mrp > 300
ORDER BY mrp DESC;

-- 3. Estimate potential revenue for each product category
SELECT category, SUM(discountedSellingPrice*availableQuantity) as potential_revenue
	FROM inventory
GROUP BY category
ORDER BY potential_revenue DESC;

-- 4. Filter expensive products (MRP > ₹500) with minimal discount
SELECT DISTINCT name, mrp, discountPercent
	FROM inventory
WHERE mrp > 500 AND
	  discountPercent < 10
ORDER BY discountPercent, mrp DESC; 

-- 5. Rank top 5 categories offering highest average discounts
SELECT category, ROUND(avg(discountPercent),2) as avg_discounts
	FROM inventory
GROUP BY category
ORDER BY avg_discounts DESC
LIMIT 5


-- 6. Calculate price per gram to identify value-for-money products
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
	ROUND(discountedSellingPrice/weightInGms,2) as price_per_gram
 	FROM inventory
WHERE weightInGms <> 0
ORDER BY price_per_gram ASC;

-- 7. Group products based on weight into Low, Medium, and Bulk categories
SELECT DISTINCT name, weightInGms,
	CASE
	WHEN weightInGms < 1000 then 'Low'
	WHEN weightInGms > 5000 then 'Bulk'
	ELSE 'Medium'
	END as weight_category
	FROM inventory;

-- 8. Measure total inventory weight per product category
SELECT category, SUM(weightInGms) as category_weight
	FROM inventory
GROUP BY category
ORDER BY category_weight DESC;



-- End oF Project




