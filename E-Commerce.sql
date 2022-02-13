CREATE SCHEMA `ecommerce` ; 

CREATE TABLE Supplier (SUPP_ID int PRIMARY KEY, SUPP_NAME VARCHAR(20), SUPP_CITY VARCHAR(20),
	SUPP_PHONE varchar(20));

CREATE TABLE Customer (CUS_ID int PRIMARY KEY, CUS_NAME varchar(20) , CUS_PHONE  varchar(20) , CUS_CITY varchar(20), 
	CUS_GENDER varchar(20));

CREATE  TABLE Category (CAT_ID INT PRIMARY KEY, CAT_NAME VARCHAR(20));

CREATE TABLE  Product (PRO_ID INT PRIMARY KEY, PRO_NAME VARCHAR(20) , PRO_DESC VARCHAR(20) , CAT_ID int, 
	foreign key (CAT_ID) references Category(CAT_ID));

CREATE TABLE  ProductDetails (PROD_ID INT PRIMARY KEY, PRO_ID INT ,foreign key (PRO_ID) references Product(PRO_ID), 
	SUPP_ID INT ,foreign key (SUPP_ID) references Supplier(SUPP_ID), PRICE float);

CREATE TABLE Orders (ORD_ID INT PRIMARY KEY, ORD_AMOUNT float, ORD_DATE DATE , CUS_ID INT, 
	foreign key (CUS_ID) references Customer(CUS_ID), PROD_ID INT,foreign key (PROD_ID) references ProductDetails(PROD_ID));

create table Rating (RAT_ID INT PRIMARY KEY,CUS_ID INT , foreign key (CUS_ID) references Customer(CUS_ID),
	SUPP_ID INT ,foreign key (SUPP_ID) references Supplier(SUPP_ID), RAT_RATSTARS INT); 2589631470

INSERT INTO Supplier values (1,'Rajesh Retails','Delhi',1234567890) ;
INSERT INTO Supplier values (2,'Appario Ltd.','Mumbai', 2589631470) ;
INSERT INTO Supplier values (3,'Knome products','Banglore',9785462315) ;
INSERT INTO Supplier values (4,'Bansal Retails','Kochi',8975463285) ;
INSERT INTO Supplier values (5,'Mittal Ltd.','Lucknow',7898456532) ;

INSERT INTO Customer values (1,'AAKASH',9999999999,'Delhi','M') ;
INSERT INTO Customer values (2,'AMAN',9785463215,'NOIDA','M') ;
INSERT INTO Customer values (3,'NEHA',9999999999,'MUMBAI','F') ;
INSERT INTO Customer values (4,'MEGHA',9994562399,'KOLKATA','F') ;
INSERT INTO Customer values (5,'PULKIT',7895999999,'LUCKNOW','M') ;

INSERT INTO Category values (1,'BOOKS') ;
INSERT INTO Category values (2,'GAMES') ;
INSERT INTO Category values (3,'GROCERIES') ;
INSERT INTO Category values (4,'ELECTRONICS') ;
INSERT INTO Category values (5,'CLOTHES') ;

INSERT INTO Product values (1,'GTA V','DFJDJFDJFDJFDJFJF',2) ;
INSERT INTO Product values (2,'TSHIRT','DFDFJDFJDKFD',5) ;
INSERT INTO Product values (3,'ROG LAPTOP','DFNTTNTNTERND',4) ;
INSERT INTO Product values (4,'OATS','REURENTBTOTH',3) ;
INSERT INTO Product values (5,'HARRY POTTER','NBEMCTHTJTH',1) ;

INSERT INTO ProductDetails values (1,1,2,1500) ;
INSERT INTO ProductDetails values (2,3,5,30000) ;
INSERT INTO ProductDetails values (3,5,1,3000) ;
INSERT INTO ProductDetails values (4,2,3,2500) ;
INSERT INTO ProductDetails values (5,4,1,1000) ;

INSERT INTO Orders values (20,1500,'2021-10-12',3,5) ;
INSERT INTO Orders values (25,30500,'2021-09-16',5,2) ;
INSERT INTO Orders values (26,2000,'2021-10-05',1,1) ;
INSERT INTO Orders values (30,3500,'2021-08-16',4,3) ;
INSERT INTO Orders values (50,2000,'2021-10-06',2,1) ;

INSERT INTO Rating values (1,2,2,4) ;
INSERT INTO Rating values (2,3,4,3) ;
INSERT INTO Rating values (3,5,1,5) ;
INSERT INTO Rating values (4,1,3,2) ;
INSERT INTO Rating values (5,4,5,4) ; 

/* 3)Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.*/

select  CUS_GENDER , COUNT(CUS_GENDER) as numberOfcustomer 
from customer 
inner join orders
on customer.CUS_ID = Orders.CUS_ID 
where orders.ORD_AMOUNT >= 3000
GROUP BY customer.CUS_GENDER; 

/*4)Display all the orders along with the product name ordered by a customer having Customer_Id=2.*/

select orders.* , product.PRO_NAME 
from orders ,productdetails  , product
where orders.CUS_ID = 2 and orders.PROD_ID = productdetails.PROD_ID and 
productdetails.PRO_ID = product.PRO_ID ;

/*5)Display the Supplier details who can supply more than one product.*/
select supplier.* 
from supplier , productdetails
where supplier.SUPP_ID in (
		select productdetails.SUPP_ID
		from productdetails
	group by productdetails.SUPP_ID 
	having count(productdetails.SUPP_ID) > 1
	)
group by supplier.supp_id ; 

 
/* 6)Find the category of the product whose order amount is minimum. */
SELECT category.* , productdetails.PROD_ID , orders.ORD_ID, product.PRO_ID
FROM orders 
inner join productdetails 
on orders.PROD_ID = productdetails.PROD_ID 
inner join product
on product.PRO_ID = productdetails.PRO_ID
inner join category 
on category.CAT_ID=product.CAT_ID
HAVING MIN(orders.ORD_AMOUNT) ;

/*7)Display the Id and Name of the Product ordered after “2021-10-05”. */

select product.PRO_ID , product.PRO_NAME , orders.ORD_ID 
from  orders
inner join productdetails
on productdetails.PROD_ID =orders.PROD_ID  
inner join product
	on product.PRO_ID  = productdetails.PRO_ID
		where orders.ORD_DATE >  '2021-10-05';
 
/*8)Display customer name and gender whose names start or end with character 'A'.*/
select CUS_NAME , CUS_GENDER
from customer 
where CUS_NAME like 'A%' or CUS_NAME like '%A' ; 

/* 9)Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like 
if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.*/

DELIMITER &&
	CREATE PROCEDURE PROC()
		BEGIN 
			SELECT supplier.SUPP_ID , supplier.SUPP_NAME, rating.RAT_RATSTARS,
            case
				when rating.rat_ratstars > 4 then 'Genuine Supplier'
                when rating.RAT_RATSTARS > 2 then 'Average Supplier'
                ELSE 'Supplier should not be considered'
			end as Verdict from rating inner join supplier on supplier.SUPP_ID=rating.SUPP_ID;
	END &&
DELIMITER ;

call PROC();

