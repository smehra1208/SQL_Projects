# Zepto Inventory Dataset Analysis 

## Project Overview

Project Title: Zepto Inventory  
Database: `zepto_inventory_db` 

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
- **Table Creation**: A table named `inventory` is created to store the data. The table structure includes columns for sku_id, category, name, mrp, discountPercent, availableQuantity, discountedSellingPrice, weightInGms, outOfStock and quantity.

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

## Step 2: Data Exploration  
- Counted the total number of records in the dataset.  
- Previewed a sample of rows to understand the data structure and content.  
- Checked for null values across all columns.  
- Extracted distinct product categories. 
- Compared counts of in-stock vs out-of-stock products.  
- Detected duplicate product listings across SKUs and categories.  

---

## Step 3: Data Cleaning  
- Removed rows where `mrp` or `discountedSellingPrice` was zero.  
- Standardized pricing by converting `mrp` and `discountedSellingPrice` from **paise to rupees** for consistency and readability.  

---

## Step 2: Business Insights  
- Identified the **Top 10 best-value products** based on highest discount percentage.  
- Flagged **high-MRP products** that are currently out of stock.  
- Estimated **potential revenue** for each product category.  
- Filtered **expensive products (MRP > ₹500)** offering minimal discount.  
- Ranked the **Top 5 categories** with the highest average discounts.  
- Calculated **price per gram** to identify value-for-money products.  
- Grouped products by weight into **Low, Medium, and Bulk** categories.  
- Measured the **total inventory weight** per product category.  

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.



This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
