--           DATABASE MINI PROJECT (PHARMACY)

--**********************************************************************
--                      CREATING THE TABLES
--**********************************************************************

CREATE TABLE Salary (
    emprole VARCHAR(30) PRIMARY KEY,
    salary INTEGER NOT NULL
);

CREATE TABLE Employee (
    empid INTEGER PRIMARY KEY,
    emplastname VARCHAR(25) NOT NULL,
    empfirstname VARCHAR(25) NOT NULL,
    empaddr VARCHAR(40),
    empcontactnum VARCHAR(11),
    emprole VARCHAR(30) FOREIGN KEY REFERENCES Salary(emprole),
    workstatus VARCHAR(8) CHECK(workstatus IN ('Active','Inactive'))
);

CREATE TABLE Drug_Info (
    drugid INTEGER PRIMARY KEY,
    drugname VARCHAR(50),
    drugtype VARCHAR(25) ,
    expirydate DATE,
    unitprice FLOAT,
    numinstock INTEGER
);
SELECT * FROM Drug_Info
CREATE TABLE Customer (
    custid INTEGER PRIMARY KEY,
    custlastname VARCHAR(25) NOT NULL,
    custfirstname VARCHAR(25) NOT NULL ,
    custcontactnum VARCHAR(15),
    NumPurchases INTEGER
);

CREATE TABLE Supplier (
    supid INTEGER PRIMARY KEY,
    supname VARCHAR(40) NOT NULL,
    supcontactnum VARCHAR(15) NOT NULL,
	supaddr VARCHAR(40)
);

CREATE TABLE Drug_Supplied (
    supid INTEGER FOREIGN KEY REFERENCES Supplier(supid),
    drugid INTEGER FOREIGN KEY REFERENCES Drug_Info(drugid),
    supplieddate DATE,
    numbox INTEGER,
	drugperbox INTEGER,
    costprice FLOAT,
	sellingprice FLOAT,
    PRIMARY KEY(supid, drugid, supplieddate)
);

CREATE TABLE Sales_Info (
    salesid INTEGER PRIMARY KEY,
    empid INTEGER FOREIGN KEY REFERENCES Employee(empid),
    custid INTEGER FOREIGN KEY REFERENCES Customer(custid),
    totalprice FLOAT
);

CREATE TABLE Drug_Sold (
    detailsid INTEGER IDENTITY(30000,1) PRIMARY KEY,
    salesid INTEGER FOREIGN KEY REFERENCES Sales_Info(salesid),
    drugid INTEGER FOREIGN KEY REFERENCES Drug_Info(drugid),
    quantity INTEGER
);

-- Use to store all expired drugs
CREATE TABLE expired_drugs (
    drug VARCHAR(50),
    expireddate DATE,
    amount INTEGER,
    price FLOAT
)

--**********************************************************************
--                    USER DEFINED TABLE TYPE
--**********************************************************************
-- Will be used to temporary store customer orders
CREATE TYPE temporary_order_table AS TABLE (
    row_num INTEGER IDENTITY(1,1) PRIMARY KEY,
    drugname VARCHAR(70),
    quantity INTEGER
)



