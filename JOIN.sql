--  INNER JOIN - Orders with valid customers and products
SELECT 
    o.OrderID,
    c.FirstName,
    c.LastName,
    p.ProductName,
    o.Quantity,
    o.OrderDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN Products p ON o.ProductID = p.ProductID;

--  LEFT JOIN - Customers who have never made an order
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    o.OrderID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

--  RIGHT JOIN - Products never ordered
SELECT 
    p.ProductID,
    p.ProductName,
    o.OrderID
FROM Products p
RIGHT JOIN Orders o ON p.ProductID = o.ProductID
WHERE o.OrderID IS NULL;

--  FULL OUTER JOIN - Show all customers and products
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    p.ProductID,
    p.ProductName,
    o.OrderID
FROM Customers c
FULL OUTER JOIN Orders o ON c.CustomerID = o.CustomerID
FULL OUTER JOIN Products p ON o.ProductID = p.ProductID;

--  SELF JOIN - Compare customers in the same city
SELECT 
    c1.CustomerID AS Customer1,
    c1.FirstName AS FirstName1,
    c2.CustomerID AS Customer2,
    c2.FirstName AS FirstName2,
    c1.City
FROM Customers c1
INNER JOIN Customers c2 ON c1.City = c2.City AND c1.CustomerID < c2.CustomerID;