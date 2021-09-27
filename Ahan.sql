create database DistributionCompany

/****** Product ******/
CREATE TABLE Product
(
	Id INT,
	Name VARCHAR(20),
	Price INT NOT NULL,
	CONSTRAINT product_productId_pk PRIMARY KEY(Id),
	CONSTRAINT product_name_un UNIQUE(Name)
)

DROP TABLE Product 

/****** Profit ******/
CREATE TABLE Profit
(
	Id INT IDENTITY,
	ProductID INT,
	ProfitRatio decimal(3,2) constraint ProfitRatio_chk check (ProfitRatio between 0 and 1),
	CONSTRAINT profit_profitId_pk PRIMARY KEY(Id),
	CONSTRAINT profit_product_fk FOREIGN KEY(ProductID) REFERENCES Product(Id)
)

DROP TABLE Profit

/****** Customer ******/
CREATE TABLE Customer
(
	Id INT ,
	Name VARCHAR(20),
	CONSTRAINT customer_customerId_pk PRIMARY KEY(Id),
	CONSTRAINT customer_name_un UNIQUE(Name)
)

DROP TABLE Customer


/****** Order ******/
CREATE TABLE SalesOrder
(
	Id INT ,
	CustomerID INT NOT NULL,
	Date INT,
	CONSTRAINT salesOrder_salesOrderId_pk PRIMARY KEY(Id),
	CONSTRAINT salesOrder_customer_fk FOREIGN KEY(CustomerID) REFERENCES Customer(Id)
)

DROP TABLE SalesOrder

/****** Sales ******/
CREATE TABLE Sales
(
	SalesID INT,
	OrderID INT NOT NULL,
	CustomerID INT NOT NULL,
	ProductID INT NOT NULL,
	Date INT,
	Quantity INT NOT NULL,
	UnitPrice INT NOT NULL,
	CONSTRAINT sales_salesid_pk PRIMARY KEY(SalesID),
	CONSTRAINT sales_salesOrder_fk FOREIGN KEY(OrderID) REFERENCES SalesOrder(Id),
	CONSTRAINT sales_customer_fk FOREIGN KEY(CustomerID) REFERENCES Customer(Id),
	CONSTRAINT sales_product_fk FOREIGN KEY(ProductID) REFERENCES Product(Id)
)


DROP TABLE Sales

/****** 1 ******/
SELECT SUM(Quantity*UnitPrice) AS TotalSales
FROM Sales

/****** 2 ******/
SELECT COUNT(DISTINCT customerID) AS NumberOfCustomers
FROM Sales

/****** 3 ******/
SELECT ProductID, SUM(Quantity*UnitPrice) AS SalesOfEachProduct
FROM Sales
GROUP BY ProductID

/****** 4 ******/
SELECT DISTINCT(CustomerID),SUM(Quantity*UnitPrice), COUNT(DISTINCT(OrderID)), SUM(Quantity)
FROM Sales
WHERE CustomerID IN
(SELECT CustomerID
FROM SalesOrder
WHERE Id IN (SELECT OrderID
				  FROM Sales
				  GROUP BY OrderID
				  HAVING SUM(Quantity*UnitPrice)>1500)
				  )
GROUP BY CustomerID

/****** 5 ******/
SELECT SUM(Profit.ProfitRatio * Sales.Quantity * Sales.UnitPrice), SUM(Profit.ProfitRatio * Sales.Quantity * Sales.UnitPrice)/SUM(Quantity*UnitPrice)
FROM Sales INNER JOIN Profit on Sales.ProductID=Profit.ProductID


