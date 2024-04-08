CREATE DATABASE SALES
go
use SALES
go
CREATE SCHEMA SALES
go
CREATE TABLE SALES.CurrencyRate--1.1
(CurrencyRateID int primary key,CurrencyRateDate datetime not null,FromCurrencyCode nchar(3) not null,
ToCurrencyCode nchar(3) not null,AverageRate money not null,EndOfDayRate money not null,ModifiedDate datetime not null)
   
CREATE TABLE SALES.CreditCard--1.3
(CreditCardID int primary key,CardTYPE nvarchar(50) not null,CardNumber nvarchar(25) not null
,ExpMonth tinyint not null,ExpYear smallint not null,ModifiedDate datetime not null)
   
CREATE TABLE SALES.SalesTerritory--1.4
(TerritoryID int primary key,CountryRegionCode nvarchar(3) not null,
[Group] nvarchar(50)not null,SalesYTD money not null,
SalesLastYear money not null,CostYTD money not null,
CostLastYear money not null,ModifiedDate datetime not null)

CREATE TABLE SALES.Customer--1.5
(CustomerID int primary key,PersonID int null,StoreID int null,
TerritoryID int foreign key references SALES.SalesTerritory,AccountNumber varchar(10) not null,
ModifiedDate datetime not null)

CREATE TABLE SALES.SalesPerson--1.6
(BusinessEntityID int primary key,
TerritoryID int null foreign key references SALES.SalesTerritory,
SalesQuota money null,Bonus money,CommissionPct smallmoney not null,
SalesYTD money not null,SalesLastYear money not null,
ModifiedDate datetime not null)

		go
		CREATE SCHEMA PURCHASING --2
		go
		CREATE TABLE PURCHASING.ShipMethod--2.1
		(ShipMethodID int primary key,[Name] nvarchar(50) not null,ShipBase money not null,
		ShipRate money not null,ModifiedDate datetime not null)

	    go
        CREATE SCHEMA PERSON --3
	    go

CREATE TABLE PERSON.Address--3.1
(AddressID int primary key,AddressLine1 nvarchar(60) not null,
AddressLine2 nvarchar(60) null,City nvarchar(30) not null,
StateProvincelID INT not null,PostalCode nvarchar(10) not null,
SpatialLocation geography null,ModifiedDate datetime not null)

		go
	
CREATE TABLE SALES.SalesOrderHeader--1.7
(SalesOrderID int primary key,RevisionNumber tinyint not null,OrderDate datetime not null,
DueDate datetime not null,ShipDate datetime null,Status tinyint not null,
CustomerID int null foreign key references SALES.Customer(CustomerID),
SalesPersonID int null foreign key references SALES.SalesPerson(BusinessEntityID),
TerritoryID int null foreign key references SALES.SalesTerritory(TerritoryID),
BillToAddressID int not null foreign key references PERSON.Address(addressID),
ShipToAddressID int not null foreign key references PERSON.Address(addressID),
ShipMethodID int null foreign key references PURCHASING.ShipMethod(ShipMethodID),
CreditCardID int null foreign key references SALES.CreditCard(CreditCardID),
CreditCardApprovalCode varchar(15) null,
CurrencyRateID int null foreign key references SALES.CurrencyRate(CurrencyRateID),
SubTotal money not null,TaxAmt money not null,Freight money not null)
		go
CREATE TABLE SALES.SpecialOfferProduct--1.2 
(SpecialOfferID int not null,ProductID int not null,
ModifiedDate datetime not null,primary key(SpecialOfferID,ProductID))

		go
	    CREATE SCHEMA SALESB--4
	    go

CREATE TABLE SALESB.SalesOrderDetail--4.1
(SalesOrderID INT FOREIGN KEY references SALES.SalesOrderHeader ,
SalesOrderDetailID INT NOT NULL,
PRIMARY KEY (SalesOrderDetailID,SalesOrderID),
CarrierTrackingNumber NVARCHAR(25),
OrderQty SMALLINT NOT NULL,
ProductID INT NOT NULL,
SpecialOfferID INT NOT NULL,
UnitPrice MONEY NOT NULL,
UnitPriceDiscount MONEY NOT NULL,
ModifiedDate DATETIME NOT NULL,
FOREIGN KEY (ProductID, SpecialOfferID)
REFERENCES SALES.SpecialOfferProduct(SpecialOfferID,ProductID))
	   
              --PART B--
INSERT INTO SALES.CreditCard--1.3
SELECT *
FROM AdventureWorks2022.SALES.CreditCard

INSERT INTO SALES.SpecialOfferProduct--1.2  
SELECT SpecialOfferID,ProductID,ModifiedDate
FROM AdventureWorks2022.SALES.SpecialOfferProduct

INSERT INTO SALES.CurrencyRate--1.1 
SELECT *
FROM AdventureWorks2022.SALES.CurrencyRate

INSERT INTO PURCHASING.ShipMethod--2.1
SELECT ShipMethodID,[Name],ShipBase,ShipRate,ModifiedDate
	FROM AdventureWorks2022.PURCHASING.ShipMethod

	INSERT INTO PERSON.Address--3.1
SELECT AddressID,AddressLine1,AddressLine2,City,StateProvinceID, 
       PostalCode,SpatialLocation,ModifiedDate	        
	FROM AdventureWorks2022.PERSON.Address

INSERT INTO SALES.SalesTerritory--1.4
SELECT TerritoryID,CountryRegionCode,[Group],SalesYTD,
	   SalesLastYear,CostYTD,CostLastYear,ModifiedDate
	FROM AdventureWorks2022.SALES.SalesTerritory

INSERT INTO SALES.SalesPerson--1.6
SELECT BusinessEntityID,TerritoryID,SalesQuota,Bonus,CommissionPct,
	   SalesYTD,SalesLastYear,ModifiedDate
	FROM AdventureWorks2022.SALES.SalesPerson

INSERT INTO SALES.Customer--1.5
SELECT CustomerID,PersonID,StoreID,TerritoryID,AccountNumber,ModifiedDate
	FROM AdventureWorks2022.SALES.Customer

INSERT INTO SALES.SalesOrderHeader--1.7 
SELECT SalesOrderID,RevisionNumber,OrderDate,
DueDate,ShipDate,Status,CustomerID,SalesPersonID,
TerritoryID,BillToAddressID,ShipToAddressID,ShipMethodID,
CreditCardID,CreditCardApprovalCode,CurrencyRateID,
SubTotal,TaxAmt,Freight
FROM AdventureWorks2022.SALES.SalesOrderHeader

INSERT INTO SALESB.SalesOrderDetail--4.1
SELECT SalesOrderID,SalesOrderDetailID,CarrierTrackingNumber,
       OrderQty,SpecialOfferID,ProductID,UnitPrice,
       UnitPriceDiscount,ModifiedDate
	FROM AdventureWorks2022.SALES.SalesOrderDetail
	
