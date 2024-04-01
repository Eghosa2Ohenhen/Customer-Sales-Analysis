--------Assume the Table was not Imported----------------
CREATE TABLE Customer_data (
    Customer_id INT PRIMARY KEY,
    Gender VARCHAR(10),
    Age INT,
    Payment_method VARCHAR(50)
);

CREATE TABLE Sales_data (
    Invoice_no NVARCHAR(50) PRIMARY KEY, 
    Customer_id INT,
    Category VARCHAR(50),
    Quantity INT,
    Price DECIMAL(10,2),
    Invoice_Year INT,
    Invoice_Month INT,
    InvoiceDay DATE,
    Shopping_mall VARCHAR(50),
    FOREIGN KEY (Customer_id) REFERENCES Customer_data(Customer_id)
);

-- Inspect data
SELECT *
FROM Customer_data;

SELECT *
FROM Sales_data;

-- Distinct Payment_method
SELECT Distinct Payment_method
FROM Customer_data;

-- Distinct Category
SELECT Distinct Category
FROM Sales_data;

-- Distinct Years
SELECT Distinct Invoice_Year
FROM Sales_data;

-- Distinct Shopping_mall
SELECT Distinct Shopping_mall
FROM Sales_data;


----------------------- Data Cleaning --------------------

--Check for Null values (Missing data)

SELECT *
FROM Customer_data
WHERE Customer_id IS NULL
   OR Gender IS NULL
   OR Age IS NULL
   OR Payment_method IS NULL;

/*
 117 data from the Age column in the Customer table have NULL vlaues 
*/

SELECT *
FROM Sales_data
WHERE Invoice_no IS NULL
   OR Customer_id IS NULL
   OR Category IS NULL
   OR Quantity IS NULL
   OR Price IS NULL
   OR Invoice_Year IS NULL
   OR Invoice_Month IS NULL
   OR InvoiceDay IS NULL
   OR Shopping_mall IS NULL;

/*
 No NULL data in the Sales table
*/


----------------------- Analysis List --------------------
--Total Sales Revenue by Category
SELECT Category, SUM(Price * Quantity) AS Total_Revenue
FROM Sales_data
GROUP BY Category
ORDER BY Total_Revenue DESC;

/*

Clotihing has the highest total_Revenue, while Souvenir category has the lowest total_Revenue

*/


-- Number of Sales per Month
SELECT Invoice_Year, Invoice_Month, COUNT(*) AS Number_of_Sales
FROM Sales_data
GROUP BY Invoice_Year, Invoice_Month
ORDER BY Invoice_Year, Invoice_Month;

/*

There was a decline in number of sales in march of 2023

*/


-- Average Purchase Amount per Customer
SELECT s.Customer_id, AVG(s.Price * s.Quantity) AS AvgPurchaseAmount
FROM Sales_data s
GROUP BY s.Customer_id
ORDER BY AvgPurchaseAmount DESC;


-- Monthly Sales Trend
SELECT Invoice_Year, Invoice_Month, SUM(Price * Quantity) AS MonthlyRevenue
FROM Sales_data
GROUP BY Invoice_Year, Invoice_Month
ORDER BY Invoice_Year, Invoice_Month;

/*

The highest sales monthly revenue was "10,159,800.73" on Novemeber 2021

*/

-- Most Popular Payment Method
SELECT TOP 1 Payment_method, COUNT(*) AS NumTransactions
FROM Customer_data
GROUP BY Payment_method
ORDER BY NumTransactions DESC;

/*

The most popular payment method is cash with "44,447" transactions

*/


-- Average Quantity Sold per Category
SELECT Category, AVG(Quantity) AS AvgQuantity
FROM Sales_data
GROUP BY Category;


-- Age Distribution of Customers by Gender
SELECT Gender, AVG(Age) AS Average_Age
FROM Customer_data
GROUP BY Gender;

/*

The average age of both males and female is 43

*/


-- Total Sales Revenue by Gender
SELECT Gender, SUM(Price * Quantity) AS Total_Revenue
FROM Sales_data
INNER JOIN Customer_data ON Sales_data.Customer_id = Customer_data.Customer_id
GROUP BY Gender;

/*
The Female Gender has the highest sales revenue by gender

*/

-- Total Sales Revenue per Customer
SELECT Customer_data.Customer_id, Gender, SUM(Price * Quantity) AS Total_Revenue
FROM Sales_data 
INNER JOIN Customer_data  ON Sales_data.Customer_id = Customer_data.Customer_id
GROUP BY Customer_data.Customer_id, Gender;

-- Customers with Above Average Purchase Amount Using
-- Used Subquery
SELECT Customer_id, TotalPurchaseAmount
FROM (
    SELECT Customer_id, SUM(Price * Quantity) AS TotalPurchaseAmount
    FROM Sales_data
    GROUP BY Customer_id
) AS CustomerPurchase
WHERE TotalPurchaseAmount > (
    SELECT AVG(TotalPurchaseAmount) FROM (
        SELECT SUM(Price * Quantity) AS TotalPurchaseAmount
        FROM Sales_data
        GROUP BY Customer_id
    ) AS AvgPurchasePerCustomer
);


-- Customers with No Purchases
-- Used Subquery
SELECT Customer_id
FROM Customer_data
WHERE Customer_id NOT IN (
    SELECT DISTINCT Customer_id FROM Sales_data
);


