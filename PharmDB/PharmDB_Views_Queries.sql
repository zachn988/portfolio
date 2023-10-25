/* Query 1: retrieval query to get the birth date, first name, and last name of employees whose salaries are greater than $30,000 */
SELECT p.Fname, p.Lname, p.Birth_Date
FROM Person p, Employee e
WHERE e.Essn = p.Ssn AND e.Salary > 30000;

/* Query 2: retrieve all of the products that are due to be picked up on a specific day, in this case 2/1/2023 */
SELECT p.Name, COUNT(p.Name) as count
FROM product p
JOIN buys b ON p.Name = b.ProdName
JOIN pharmacy.order o ON b.Order_Num = o.Order_Num
GROUP BY p.Name, o.Date_Of_Purchase
HAVING o.Date_Of_Purchase = '2023-2-1';

/* Query 3: For every product that is taken by more than three customers, retrieve the
first name, last name, and address of customers who take those products and find their average cost.
In other words, if there are 4 products taken by n >= 3 people, find the average cost of those 4 products. */

SELECT p.fname, p.lname, p.address, AVG(o.Price)
FROM person p
JOIN Buys b ON p.ssn = b.cssn
JOIN pharmacy.Order o ON o.Order_Num = b.Order_Num
WHERE b.ProdName IN (
	SELECT ProdName
	FROM Buys
	GROUP BY ProdName
    HAVING COUNT(ProdName) >= 3
)
GROUP BY p.fname, p.lname, p.address;

/* Query 4: For all products bought by more than two customers, list active ingredients. */

SELECT a.ingredient, p.Name
FROM product p
JOIN active_ingredients a ON p.Name = a.Prod_Name
JOIN buys b ON b.ProdName = p.Name
GROUP BY a.ingredient, p.Name
HAVING COUNT(a.ingredient) >= 2;

/* Query 5: Give the number of items bought by each customer*/
SELECT p.ssn, p.Fname, p.Lname, COUNT(p.Lname) as Orders
FROM person p
JOIN buys b ON p.ssn = b.cssn
JOIN pharmacy.order o ON o.Order_Num = b.Order_Num
GROUP BY p.Lname, p.Fname, p.ssn; 

/* View 1: Creates a view of the product names and their stock, if the stock is less than 5 */
CREATE VIEW low_stock
AS SELECT p.name,p.stock as remaining_stock
FROM product p
WHERE p.stock < 5;

SELECT * FROM low_stock;

/* View 2: Creates a view of all orders showing order number, products ordered, and customer name. Combines buys and order */
DROP VIEW IF EXISTS customer_orders;
CREATE VIEW customer_orders
AS SELECT p.Fname, p.Lname, prod.Name, b.Order_Num, o.Date_Of_Purchase
FROM person p, product prod, buys b, pharmacy.order o
WHERE p.ssn = b.cssn AND o.Order_Num = b.Order_Num AND prod.Name = b.ProdName;

SELECT * FROM customer_orders;

/* View 3: Creates a view of products and the section they are stocked in */
DROP VIEW IF EXISTS stock_location;
CREATE VIEW stock_location
AS SELECT s.Section, j.Product_Name
FROM stocker s, jobs j
WHERE s.STssn = j.STssn;

SELECT * FROM stock_location;

