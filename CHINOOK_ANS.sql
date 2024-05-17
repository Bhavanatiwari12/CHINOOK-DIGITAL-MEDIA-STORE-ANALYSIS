-- CHINOOK DIGITAL MEDIA STORE ANALYSIS

USE CHINOOK;

--  1.Calculate Monthly-Wise invoice Sales and sort them in descending order. (12 rows)
SELECT * FROM INVOICE;

SELECT monthname(invoicedate) AS Month_Name, sum(total) AS Total_Sales 
FROM invoice 
GROUP BY Month_Name ORDER BY Total_Sales DESC;

--  2. Write an SQL query to fetch the names of all employees and their managers. (7 rows)

SELECT CONCAT(e.FirstName,' ', e.lastname) AS Employees, 
CONCAT(m.FirstName,' ', m.lastname) AS Manager 
FROM employee e LEFT JOIN employee m 
ON e.reportsto = m.employeeid;

--  3. Find the names of customers who have made a purchase in the USA? (13 rows)

SELECT DISTINCT customerid, c.firstname, c.lastname, i.billingaddress
FROM customer c INNER JOIN invoice i
USING(customerid) WHERE i.billingcountry = 'USA';

--  4. Show the name of each genre and the total number of tracks in that genre. (25 rows)

SELECT g.Genreid, g.Name, COUNT(t.trackid) AS Total_no_tracks
FROM genre g LEFT JOIN track t
USING(genreid) GROUP BY g.genreid, g.name;

-- 4.1 Identify the % of null values in a billing states column in invoice state

select count(*) from invoice;
select count(billingstate) from invoice;

select (count(*) - count(billingstate))/count(*) as percentage_of_null from invoice;

select sum(if(billingstate is null,1,0))/ count(*) as percentage_of_null from invoice;

--  5. Show the name of each customer and the total amount they have spent on purchases. (59 rows)

SELECT c.Customerid, c.Firstname, SUM(i.Total) AS Total_purchase
FROM  customer c LEFT JOIN invoice i
USING(customerid) 
GROUP BY c.customerid;

--  6. Find the name of the album with the highest unit price. (1 row)

SELECT a.AlbumId, a.Title, SUM(t.unitprice) AS Album_Price
FROM album a LEFT JOIN track t
USING(albumid)
GROUP BY a.albumid
ORDER BY Album_price DESC
LIMIT 1;

--  7. Display the percentage of null values for “billingstate” and “billingpostalcode” columns
--  respectively for the invoice table. (1 row)

SELECT SUM(if(billingstate IS NULL,1,0))/ COUNT(*) AS billingstate_percentage_of_null,
SUM(if(billingpostalcode IS NULL,1,0))/ COUNT(*) AS billingpostalcode_percentage_of_null  FROM invoice;

--  8. Show the name of each track and the total number of times it has been purchased. (100 rows)

SELECT t.trackid, t.name, COUNT(i.trackid)
FROM track t LEFT JOIN invoiceline i
USING(trackid)
GROUP BY t.trackid, t.name;

--  9. Find the name of the customer who has made the largest purchase in terms of total cost. (1 row)

SELECT c.Customerid, c.Firstname, SUM(i.Total) AS Total_purchase
FROM  customer c LEFT JOIN invoice i
USING(customerid) 
GROUP BY c.customerid 
ORDER BY Total_purchase DESC 
LIMIT 1;

--  10. Display the total amount spent by each customer and the number of invoices they have. (59 rows)
--  Note: calculate the total amount spent and the number of invoices for each customer.

SELECT c.Customerid, c.Firstname, SUM(i.Total) AS Total_purchase, COUNT(i.invoiceid) AS Invoice_Count
FROM  customer c LEFT JOIN invoice i
USING(customerid) 
GROUP BY c.customerid;

--  11. Find the name of the artist who has the most tracks in the chinook database. (1 row)

SELECT a.ArtistID, a.Name, COUNT(t.trackid) AS No_of_Tracks
FROM artist a LEFT JOIN album al 
USING(artistid)
LEFT JOIN track t 
USING(albumid)
GROUP BY a.ArtistID, a.Name
ORDER BY No_of_Tracks DESC
LIMIT 1;

--  12. Find the names and email addresses of customers who have spent more than the average amount
--  on invoices, above average customers (59 rows) 

SELECT c.CustomerId, c.FirstName, c.Email, SUM(i.total) AS Total_Sales
FROM customer c LEFT JOIN invoice i 
USING(customerid)
GROUP BY c.customerid,c.FirstName, c.Email
HAVING Total_Sales >=
(WITH cte1 AS(
SELECT c.CustomerId, c.FirstName, c.Email, SUM(i.total) AS Total_Sales
FROM customer c LEFT JOIN invoice i 
USING(customerid)
GROUP BY c.customerid,c.FirstName, c.Email)
SELECT AVG(Total_Sales) AS Avg_Sales 
FROM cte1 );


--  13. List the names of all the artists that have tracks in the 'Rock' genre. (51 rows)

SELECT distinct a.name, g.name
FROM artist a INNER JOIN album al 
USING(artistid)
LEFT JOIN track t 
USING(albumid)
LEFT JOIN genre g 
USING(genreid)
WHERE g.name = 'Rock';

