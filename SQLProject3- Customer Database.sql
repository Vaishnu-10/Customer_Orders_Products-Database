Create Database Customers

Use Customers

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(50),
  Email VARCHAR(100)
);

INSERT INTO Customers (CustomerID, Name, Email)
VALUES
  (1, 'John Doe', 'johndoe@example.com'),
  (2, 'Jane Smith', 'janesmith@example.com'),
  (3, 'Robert Johnson', 'robertjohnson@example.com'),
  (4, 'Emily Brown', 'emilybrown@example.com'),
  (5, 'Michael Davis', 'michaeldavis@example.com'),
  (6, 'Sarah Wilson', 'sarahwilson@example.com'),
  (7, 'David Thompson', 'davidthompson@example.com'),
  (8, 'Jessica Lee', 'jessicalee@example.com'),
  (9, 'William Turner', 'williamturner@example.com'),
  (10, 'Olivia Martinez', 'oliviamartinez@example.com');


CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  ProductName VARCHAR(50),
  OrderDate DATE,
  Quantity INT
);

INSERT INTO Orders (OrderID, CustomerID, ProductName, OrderDate, Quantity)
VALUES
  (1, 1, 'Product A', '2023-07-01', 5),
  (2, 2, 'Product B', '2023-07-02', 3),
  (3, 3, 'Product C', '2023-07-03', 2),
  (4, 4, 'Product A', '2023-07-04', 1),
  (5, 5, 'Product B', '2023-07-05', 4),
  (6, 6, 'Product C', '2023-07-06', 2),
  (7, 7, 'Product A', '2023-07-07', 3),
  (8, 8, 'Product B', '2023-07-08', 2),
  (9, 9, 'Product C', '2023-07-09', 5),
  (10, 10, 'Product A', '2023-07-10', 1);


CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(50),
  Price DECIMAL(10, 2)
);

INSERT INTO Products (ProductID, ProductName, Price)
VALUES
  (1, 'Product A', 10.99),
  (2, 'Product B', 8.99),
  (3, 'Product C', 5.99),
  (4, 'Product D', 12.99),
  (5, 'Product E', 7.99),
  (6, 'Product F', 6.99),
  (7, 'Product G', 9.99),
  (8, 'Product H', 11.99),
  (9, 'Product I', 14.99),
  (10, 'Product J', 4.99);


SELECT Name, Email
FROM Customers
WHERE Name LIKE 'J%';

SELECT OrderID, ProductName, Quantity
FROM Orders;

SELECT SUM(Quantity) AS TotalQuantity
FROM Orders;

SELECT DISTINCT Customers.Name
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

SELECT ProductName
FROM Products
WHERE Price > 10.00;

SELECT Customers.Name, Orders.OrderDate
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.OrderDate >= '2023-07-05';

SELECT AVG(Price) AS AveragePrice
FROM Products;

SELECT Customers.Name, SUM(Orders.Quantity) AS TotalQuantity
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.Name;

SELECT ProductName
FROM Products
WHERE ProductName NOT IN (
  SELECT DISTINCT ProductName
  FROM Orders
);

Select Top 5 Customers.Name, Sum(Orders.Quantity) As TotalQuantity From Customers
Join Orders on Customers.CustomerID=Orders.CUstomerID 
Group By Customers.Name
Order by TotalQuantity Desc

SELECT ProductName, AVG(Price) AS AveragePrice
FROM Products
GROUP BY ProductName;

SELECT Name
FROM Customers
WHERE CustomerID NOT IN (
  SELECT DISTINCT CustomerID
  FROM Orders
);

SELECT Orders.OrderID, Orders.ProductName, Orders.Quantity
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.Name LIKE 'M%';

Select * from Customers
Select * from orders
Select * from Products

Select SUm(Orders.Quantity* Products.Price) As TotalRevenue From Orders
Join Products ON Orders.ProductName = Products.ProductName;

SELECT Customers.Name, SUM(Orders.Quantity * Products.Price) AS TotalRevenue
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN Products ON Orders.ProductName = Products.ProductName
GROUP BY Customers.Name;

SELECT Customers.Name
FROM Customers
WHERE NOT EXISTS (
  SELECT 1
  FROM (SELECT DISTINCT ProductName FROM Products) AS pc
  WHERE NOT EXISTS (
    SELECT 1
    FROM Orders
    JOIN Products ON Orders.ProductName = Products.ProductName
    WHERE Orders.CustomerID = Customers.CustomerID
    AND Products.ProductName = pc.ProductName
  )
);


SELECT DISTINCT c.Name
FROM Customers c
JOIN Orders o1 ON c.CustomerID = o1.CustomerID
JOIN Orders o2 ON c.CustomerID = o2.CustomerID
WHERE DATEDIFF(DAY, o2.OrderDate, o1.OrderDate) = 1;

SELECT Top 3 ProductName, AVG(Quantity) AS AvgQuantity
FROM Orders
GROUP BY ProductName
ORDER BY AvgQuantity DESC

SELECT 
  (COUNT(CASE WHEN Quantity > (SELECT AVG(Quantity) FROM Orders) THEN 1 END) * 100.0 / COUNT(*)) AS Percentage
FROM Orders;

WITH AvgQuantityCTE AS (
    SELECT AVG(Quantity) AS AvgQuantity
    FROM Orders
)
SELECT 
  (COUNT(CASE WHEN Quantity > AvgQuantity THEN 1 END) * 100.0 / COUNT(*)) AS Percentage
FROM Orders, AvgQuantityCTE;

SELECT c.Name
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Name
HAVING COUNT(DISTINCT o.ProductName) = (SELECT COUNT(*) FROM Products);

SELECT p.ProductName
FROM Products p
JOIN Orders o ON p.ProductName = o.ProductName
GROUP BY p.ProductName
HAVING COUNT(DISTINCT o.CustomerID) = (SELECT COUNT(*) FROM Customers);

SELECT 
  YEAR(OrderDate) AS OrderYear,
  MONTH(OrderDate) AS OrderMonth,
  SUM(o.Quantity * p.Price) AS TotalRevenue
FROM Orders o
JOIN Products p ON o.ProductName = p.ProductName
GROUP BY YEAR(OrderDate), MONTH(OrderDate);

SELECT p.ProductName
FROM Products p
JOIN Orders o ON p.ProductName = o.ProductName
GROUP BY p.ProductName
HAVING COUNT(DISTINCT o.CustomerID) > (SELECT COUNT(*) FROM Customers) / 2;

SELECT TOP 5 c.Name, SUM(o.Quantity * p.Price) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Products p ON o.ProductName = p.ProductName
GROUP BY c.Name
ORDER BY TotalSpent DESC;

SELECT 
    c.Name,
    o.OrderDate,
    o.Quantity,
    SUM(o.Quantity) OVER (PARTITION BY c.CustomerID ORDER BY o.OrderDate) AS RunningTotal
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
ORDER BY 
    c.CustomerID, o.OrderDate;


SELECT 
    CustomerID,
    OrderID,
    ProductName,
    OrderDate
FROM (
    SELECT 
        CustomerID,
        OrderID,
        ProductName,
        OrderDate,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS OrderRank
    FROM 
        Orders
) AS RankedOrders
WHERE 
    OrderRank <= 3;


SELECT 
  c.Name,
  SUM(o.Quantity * p.Price) AS TotalRevenue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Products p ON o.ProductName = p.ProductName
WHERE o.OrderDate >= DATEADD(DAY, -30, GETDATE())
GROUP BY c.Name;


SELECT c.Name
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Products p ON o.ProductName = p.ProductName
GROUP BY c.Name
HAVING COUNT(DISTINCT p.ProductName) >= 2;


SELECT 
  c.Name,
  AVG(o.Quantity * p.Price) AS AverageRevenuePerOrder
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Products p ON o.ProductName = p.ProductName
GROUP BY c.Name;

Select * from Orders

SELECT DISTINCT c.Name
FROM Customers c
JOIN Orders o1 ON c.CustomerID = o1.CustomerID
JOIN Orders o2 ON c.CustomerID = o2.CustomerID
WHERE DATEDIFF(MONTH, o1.OrderDate, o2.OrderDate) = 1
  AND o1.ProductName = o2.ProductName;

SELECT p.ProductName
FROM Products p
JOIN Orders o ON p.ProductName = o.ProductName
GROUP BY p.ProductName
HAVING COUNT(DISTINCT o.CustomerID) >= 2;

