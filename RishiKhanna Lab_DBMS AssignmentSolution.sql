create DATABASE Ecom;
use ECom;

CREATE TABLE Supplier (
SUPP_ID int primary key NOT NULL,
SUPP_NAME varchar(15),
SUPP_CITY varchar(15),
SUPP_PHONE int );

CREATE TABLE Customer (
CUS__ID int primary key NOT NULL,
CUS_NAME varchar(15),
CUS_PHONE int,
CUS_CITY varchar(15),
CUS_GENDER varchar(1));

CREATE TABLE Category (
CAT_ID int primary key NOT NULL,
CAT_NAME varchar(15));

CREATE TABLE Product (
PRO_ID int primary key NOT NULL,
PRO_NAME varchar(15),
PRO_DESC varchar(15),
CAT_ID int,
Foreign key(CAT_ID) REFERENCES Category(CAT_ID) );

CREATE TABLE ProductDetails (
PROD_ID int primary key NOT NULL,
PRO_ID int,
SUPP_ID int,
PRICE int );

CREATE TABLE Orders(
ORD_ID int primary key NOT NULL,
ORD_AMOUNT int,
ORD_DATE date,
CUS__ID int,
PROD_ID int,
Foreign key(CUS__ID) REFERENCES Customer(CUS__ID),
Foreign key(PROD_ID) REFERENCES ProductDetails(PROD_ID));

CREATE TABLE Rating (
RAT_ID int,
CUS__ID int,
SUPP_ID int,
RAT_RATSTARS int,
Foreign key(CUS__ID) REFERENCES Customer(CUS__ID),
Foreign key(SUPP_ID) REFERENCES Supplier(SUPP_ID));

ALTER TABLE Supplier MODIFY SUPP_NAME varchar(30);
ALTER TABLE Supplier MODIFY SUPP_PHONE varchar(30);
INSERT INTO Supplier values (1,'Rajesh Retails','Delhi',1234567890);
INSERT INTO Supplier values (2,'Appario Ltd.','Mumbai',2589631470);
INSERT INTO Supplier values (3,'Knome products','Banglore',9785462315);
INSERT INTO Supplier values (4,'Bansal Retails','Kochi',8975463285);
INSERT INTO Supplier values (5,'Mittal Ltd.','Lucknow',7898456532);

ALTER TABLE Customer MODIFY CUS_PHONE varchar(30);
INSERT INTO Customer values(1,'AAKASH','9999999999','DELHI','M');
INSERT INTO Customer values (2,'AMAN',9785463215,'NOIDA','M'),
(3,'NEHA',9999999999,'MUMBAI','F'),
(4,'MEGHA',9994562399,'KOLKATA','F'),
(5,'PULKIT',7895999999,'LUCKNOW','M');

INSERT INTO Category values (1,'BOOKS'),
(2,'GAMES'),
(3,'GROCERIES'),
(4,'ELECTRONICS'),
(5,'CLOTHES');

ALTER TABLE Product MODIFY PRO_DESC varchar(30);
INSERT INTO Product values (1,'GTA V','DFJDJFDJFDJFDJFJF',2),
(2,'TSHIRT','DFDFJDFJDKFD',5),
(3,'ROG LAPTOP','DFNTTNTNTERND',4),
(4,'OATS','REURENTBTOTH',3),
(5,'HARRY POTTER','NBEMCTHTJTH',1);

INSERT INTO ProductDetails values (1,1,2,1500),
(2,3,5,30000),
(3,5,1,3000),
(4,2,3,2500),
(5,4,1,1000);

INSERT INTO Orders values (20,1500,'2021-10-12',3,5);
INSERT INTO Orders values (25,30500,'2021-09-16',5,2);
INSERT INTO Orders values (26,2000,'2021-10-05',1,1);
INSERT INTO Orders values (30,3500,'2021-08-16',4,3);
INSERT INTO Orders values (50,2000,'2021-10-06',2,1);

INSERT INTO Rating values (1,2,2,4),
(2,3,4,3),
(3,5,1,5),
(4,1,3,2),
(5,4,5,4);

/* SOlution 3 */
select CUS_GENDER, count(CUS_NAME) from 
(select CUS_NAME ,CUS_GENDER from customer
INNER JOIN 
(select * from Orders where ORD_AMOUNT >=3000) AS A ON Customer.CUS__ID = A.CUS__ID) AS Result
GROUP BY CUS_GENDER;

/* Solution 4 */
Select Product.PRO_NAME, P.*
FROM Product 
INNER JOIN
Orders AS P on P.PROD_ID = Product.PRO_ID where P.CUS__Id=2;

/* Solution 5 */
Select * from supplier 
where Supplier.SUPP_ID IN (Select SUPP_ID FROM 
(Select SUPP_ID,count(SUPP_ID) FROM ProductDetails GROUP BY
SUPP_ID having count(SUPP_ID)>1) as S)
GROUP BY SUPP_ID;

/* Solution 6 */
Select CAT_NAME from Category
where CAT_ID =(
Select CAT_ID FROM Product where Product.PRO_ID =
(Select PROD_ID FROM (Select * from Orders where ORD_AMOUNT =
 (Select MIN(ORD_AMOUNT) from Orders)) as Min));

/* Solution 7 */
Select  PRO_ID, PRO_NAME from Product
INNER JOIN
(Select * from Orders where ORD_DATE > "2021-10-05") AS Z on Z.PROD_ID = Product.PRO_ID;

/* Solution 8 */
Select CUS_NAME,CUS_GENDER from Customer where CUS_NAME like '%A%';

/* Solution 9 */
DROP PROCEDURE If EXISTS ShowResult

DELIMITER $$
CREATE PROCEDURE ShowResult(id INT)
BEGIN
    SELECT S.SUPP_ID, R.RAT_RATSTARS,
        CASE
            WHEN R.RAT_RATSTARS > 4 THEN "Genuine Supplier"
            WHEN R.RAT_RATSTARS > 2 THEN "Average Supplier"
            ELSE "Supplier should not to be considered"
	    END AS Verdict
        FROM Supplier S, Rating R
        WHERE S.SUPP_ID = R.SUPP_ID AND S.SUPP_ID = id;
END ;
$$
DELIMITER ; 

CALL ShowResult(1);
