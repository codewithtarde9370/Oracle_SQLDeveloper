----CREATE TABLE--
CREATE TABLE CUSTOMERS
(CustomerID INTEGER,
CustomerName VARCHAR(30),
ContactName VARCHAR(30),
Address varchar2(30),
City VARCHAR(20),	PostalCode NUMBER,
Country VARCHAR(20));

desc customers;

---INSERT INTO TABLE--

INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country)
VALUES ('Cardinal', 'Tom B. Erichsen', 'Skagen 21', 'Stavanger', '4006', 'Norway');

select * from customers;

INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country) 
VALUES ('Cardinal', 'Tom B. Erichsen', 'Skagen 21', 'Stavanger', '4006', 'Norway');

INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country)
VALUES ('Greasy Burger', 'Per Olsen', 'Gateveien 15', 'Sandnes', '4306', 'Norway');

INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country)
VALUES ('Tasty Tee', 'Finn Egan', 'Streetroad 19', 'Liverpool', '6788', 'UK');

INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country)
VALUES ('Alfreds Futterkiste', 	'Maria Anders' ,	'Obere Str. 57', 	'Berlin ',	12209 ,'Germany');
INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country)
VALUES (	'Blauer See Delikatessen ',	'Hanna Moos' ,	'Forsterstr. 57' 	,'Mannheim ',	68306 ,	'Germany');
INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country)
VALUES (	'Frankenversand', '	Peter Franken' 	,'Berliner Platz 43' ,'München' ,	80805 ,	'Berlin');

	insert into customers (CUSTOMERID) Values (1);
    insert into customers (CUSTOMERID) Values (2);
    insert into customers (CUSTOMERID) Values (3);
    insert into customers (CUSTOMERID) Values (4);
    insert into customers (CUSTOMERID) Values (5);
    insert into customers (CUSTOMERID) Values (6);
    insert into customers (CUSTOMERID) Values (7);

---RETRIEVE OR DISPLAY OR SELECT THE DATA FROM TABLE---

SELECT * FROM CUSTOMERS;

SELECT CUSTOMERNAME, ADDRESS FROM CUSTOMERS;

SELECT DISTINCT ADDRESS FROM CUSTOMERS;

   --WHERE CLAUSE TO FILTER---
SELECT * FROM CUSTOMERS WHERE CITY='Sandnes';

---OPERATORS IN WHERE CLAUSE---
SELECT * FROM CUSTOMERS WHERE POSTALCODE>4150;
SELECT * FROM CUSTOMERS WHERE POSTALCODE BETWEEN 4306 AND 6788;
SELECT * FROM CUSTOMERS WHERE CUSTOMERNAME LIKE '%Tee%';
SELECT * FROM CUSTOMERS WHERE CITY IN ('Stavanger','Liverpool','Sandnes');
SELECT * FROM CUSTOMERS WHERE CUSTOMERNAME IN ('Cardinal','Tasty Tee');

---ORDER BY CLAUSE
SELECT * FROM CUSTOMERS ORDER BY CONTACTNAME; ---ASC ID DEFAULT--
SELECT * FROM CUSTOMERS ORDER BY POSTALCODE DESC; --BY DEFAULT ASC--
SELECT * FROM CUSTOMERS ORDER BY CUSTOMERID;
SELECT * FROM Customers
ORDER BY Country ASC, CustomerName DESC;

-----AND OPERATOR---TO DSIPLAY RECORD WHICH SATISFY ALL CONDITION--

SELECT * FROM Customers
WHERE Country = 'Norway' AND CustomerName LIKE 'C%';

-----OR OPERATOR DISPLAY THE DIFFERNT RECORDS WITH SATISFY EITHER OF DIFFERENT CONDITION;
SELECT * FROM Customers
WHERE Country = 'Norway' OR CustomerName LIKE 'A%';

/*
Select all customers that either:
are from Spain and starts with either "G", or
starts with the letter "R":

*/
SELECT * FROM Customers
WHERE Country = 'Spain' AND CustomerName LIKE 'G%' OR CustomerName LIKE 'R%';

SELECT * FROM Customers
WHERE City = 'Berlin' OR CustomerName LIKE 'G%' OR Country = 'Norway';

SELECT * FROM Customers
WHERE Country='Berlin' OR Country='Germany' OR Country='Spain';

---NOT OPERATOR---CAN BE USED WITH ALL THE OTHER OPERATORS--

SELECT * FROM CUSTOMERS WHERE NOT COUNTRY = 'Berlin';

----NULL VALUE OPERATOR--
SELECT * FROM CUSTOMERS WHERE Country IS NULL;
SELECT * FROM CUSTOMERS WHERE Country IS NOT NULL;

DELETE (SELECT * FROM CUSTOMERS WHERE Country IS NULL);

----UPDATE --

UPDATE CUSTOMERS SET COUNTRY='Spain' WHERE COUNTRY='Berlin';
SELECT * FROM customers;

---DELETE--ROWS--
DELETE FROM CUSOTERS;
--DROP--COMPLETE TABLE--
DROP TABLE CISTOENR;

SELECT TOP 3 * FROM Customers;---NOT ALLOWED IN ORACLE SQL--

SELECT COUNTRY,CITY
FROM CUSTOMERS
WHERE ROWNUM <= 2;

/*SELECT CUSTOMERNAME
FROM CUSTOMERS
ORDER BY CITY
FETCH FIRST 4 ROWS ONLY;*/

SELECT *
FROM (SELECT CUSTOMERNAME FROM CUSTOMERS ORDER BY CITY)
WHERE ROWNUM <= 5;

./*Query the two cities in STATION with the shortest and longest CITY names, 
as well as their respective lengths (i.e.: number of characters in the name). 
If there is more than one smallest or largest city, choose the one that comes 
first when ordered alphabetically.
The STATION table is described as follows*/

-- City with the shortest name
SELECT CITY, LENGTH(CITY) AS LEN
FROM (
    SELECT CITY, LENGTH(CITY) AS LEN
    FROM STATION
    ORDER BY LENGTH(CITY) ASC, CITY ASC
)
WHERE ROWNUM = 1
UNION ALL
-- City with the longest name
SELECT CITY, LENGTH(CITY) AS LEN
FROM (
    SELECT CITY, LENGTH(CITY) AS LEN
    FROM STATION
    ORDER BY LENGTH(CITY) DESC, CITY ASC
)
WHERE ROWNUM = 1;








