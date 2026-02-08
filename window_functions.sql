-- ranking function: Top 5 products per category using RANK()
-- Goal: Find best-selling products in each category
SELECT 
    Category,
    ProductName,
    SUM(Quantity) AS TotalSold,  -- total quantity sold per product
    RANK() OVER (PARTITION BY Category ORDER BY SUM(Quantity) DESC) AS ProductRank
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID  -- join to get product info
GROUP BY Category, ProductName
ORDER BY Category, ProductRank;


-- Aggreagate function: Running monthly sales totals using SUM() OVER()
-- Goal: See cumulative sales month by month
SELECT 
    DATE_TRUNC('month', OrderDate) AS Month,  -- get month from order date
    SUM(Quantity * Price) OVER (ORDER BY DATE_TRUNC('month', OrderDate)) AS RunningTotal
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID  -- join to get product price
GROUP BY DATE_TRUNC('month', OrderDate)
ORDER BY Month;


-- Navigation function: Month-over-month growth using LAG()
-- Goal: Compare sales this month to previous month
SELECT 
    Month,
    TotalSales,
    TotalSales - LAG(TotalSales) OVER (ORDER BY Month) AS Growth  -- calculate growth
FROM (
    -- calculate total sales per month first
    SELECT 
        DATE_TRUNC('month', OrderDate) AS Month,
        SUM(Quantity * Price) AS TotalSales
    FROM Orders o
    JOIN Products p ON o.ProductID = p.ProductID
    GROUP BY DATE_TRUNC('month', OrderDate)
) AS MonthlySales
ORDER BY Month;

-- Distributive function: Customer quartile segmentation using NTILE(4)
-- Goal: Divide customers into 4 groups based on total spending
SELECT 
    CustomerID,
    FirstName,
    LastName,
    TotalSpent,
    NTILE(4) OVER (ORDER BY TotalSpent DESC) AS CustomerQuartile
FROM (
    -- calculate total spending per customer
    SELECT 
        c.CustomerID,
        c.FirstName,
        c.LastName,
        SUM(o.Quantity * p.Price) AS TotalSpent
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    LEFT JOIN Products p ON o.ProductID = p.ProductID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
) AS CustomerSpending
ORDER BY CustomerQuartile, TotalSpent DESC;