

--**********************************************************************
--                    STORED PROCEDURES
--**********************************************************************
------------------------- INSERT RECORDS ---------------------------

-- Add New Employee to Employee Table
CREATE PROCEDURE sp_insert_Employee 
    @emplastname VARCHAR(15),
    @empfirstname VARCHAR(15),
    @empaddr VARCHAR(25),
    @empcontactnum VARCHAR(11),
    @role VARCHAR(15)
AS
BEGIN
    DECLARE @empid INTEGER = ( SELECT MAX(empid) FROM Employee ) + 1;
    INSERT INTO Employee VALUES (@empid, @emplastname, @empfirstname, @empaddr, @empcontactnum, @role,'Active');
END;
-- PARAMETERS -> EmployeeLastName, EmployeeFirstName, EmployeeAddress, EmployeeContactNumber, EmployeeRole

EXEC sp_insert_Employee 'Lalloo', 'Jalil', 'Rochester Fall', '54678976', 'Cashier';
select * from Employee

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

-- Add New Supplier to Supplier Table
CREATE PROCEDURE sp_insert_Supplier
    @supname VARCHAR(20),
    @supcontactnum VARCHAR(11),
    @supaddr VARCHAR(25)
AS
BEGIN   
    DECLARE @supid INTEGER = ( SELECT MAX(supid) FROM Supplier ) + 1;
    INSERT INTO Supplier VALUES (@supid, @supname, @supcontactnum, @supaddr);
END;

-- PARAMETERS -> SupplierName, SupplierContactNumber, SupplierAddress

EXEC sp_insert_Supplier 'Septonix Ltd', '2340987', 'Belle Rose';
select * from Supplier

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Add new drug to Drug_Info table
CREATE PROCEDURE sp_insert_drugs
    @drugname VARCHAR(50),
    @drugtype VARCHAR(20),
    @expirydate DATE,
    @unitprice FLOAT,
    @num INTEGER
AS
BEGIN
    DECLARE @drugid INTEGER
    SET @drugid = (SELECT MAX(drugid) FROM Drug_Info) + 1 
    INSERT INTO Drug_Info VALUES (@drugid, @drugname, @drugtype, @expirydate, @unitprice,@num);
    RETURN @drugid
END

EXEC sp_insert_drugs 'test2', 'test', '2023-12-08', 3.34, 12
SELECT * FROM Drug_Info
DELETE FROM Drug_Info WHERE drugtype = 'test' -- REMOVE UNWANTED DATA

----------------------- UPDATE RECORDS ---------------------------
-- Procedure to change workstatus to inactive if employee has left the pharmacy
CREATE PROCEDURE sp_update_workstatus 
     @empid INTEGER
AS 
BEGIN
    UPDATE Employee
    SET workstatus='Inactive'
    WHERE empid=@empid
END

-- PARAMETER -> Employee Id

SELECT * FROM Employee
EXEC sp_update_workstatus 1
SELECT * FROM Employee

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

-- Update the unitprice of a drug in the Drug_Info Table
CREATE PROCEDURE sp_update_unitprice
    @id INTEGER,
    @newprice FLOAT
AS
BEGIN   
    UPDATE Drug_Info
    SET unitprice = @newprice
    WHERE drugid = @id;
END;

-- PARAMETERS -> DrugId, NewDrugPrice

SELECT * FROM Drug_Info
EXEC sp_update_unitprice 20001,8.5;
SELECT * FROM Drug_Info

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

-- procedure to add new drugs to the number of drugs currently in stock
CREATE PROCEDURE sp_update_numinstock
    @id INTEGER,
    @qty INTEGER
AS
BEGIN   
    UPDATE Drug_Info
    SET numinstock = numinstock + @qty
    WHERE drugid = @id;
END;

-- PARAMETERS -> DrugId, quantity

SELECT * FROM Drug_Info
EXEC sp_update_numinstock 20001,52
SELECT * FROM Drug_Info

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

-- Update the salary 
CREATE PROCEDURE sp_update_salary
    @role VARCHAR(20),
    @newsalary INTEGER
AS
BEGIN   
    UPDATE Salary
    SET salary = @newsalary
    WHERE emprole = @role;
END
-- PARAMETERS -> EmployeeRole, NewNumber

SELECT * FROM Salary
EXEC sp_update_salary 'Cashier',9000
SELECT * FROM Salary

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

-- NumPurchases is incremented whenever sp_update_numpurchases is called
CREATE PROCEDURE sp_update_numpurchases @id INTEGER
AS
BEGIN
    UPDATE Customer
    SET NumPurchases=NumPurchases+1
    WHERE custid=@ID;
END
-- PARAMETERS -> CustomerId

SELECT * FROM Customer
EXEC sp_update_numpurchases 1002
SELECT * FROM Customer

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


-- Procedure to calculate total sales
CREATE PROCEDURE sp_calculate_totalsales 
AS 
BEGIN
    DECLARE @totalsales FLOAT;
    SET @totalsales = (  
        SELECT SUM(totalprice)
        FROM Sales_Info
    );
    IF @totalsales IS NULL
        SET @totalsales = 0;
    PRINT 'Total Sales: Rs ' + CAST(@totalsales AS VARCHAR(10));
    RETURN @totalsales;
END

EXEC sp_calculate_totalsales;

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


-- Procedure to calculate cost price of all expired drugs
CREATE PROCEDURE sp_calculate_costexpireddrugs 
AS 
BEGIN
    DECLARE @cost FLOAT;
    SET @cost = (  
        SELECT SUM(price * amount)
        FROM expired_drugs
    );
    IF @cost IS NULL
        SET @cost = 0;
    PRINT 'Cost Of Expired Drugs: Rs ' + CAST(@cost AS VARCHAR(10));
    RETURN @cost;
END

EXEC sp_calculate_costexpireddrugs;

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


-- Procedure to calculate total salary
CREATE PROCEDURE sp_calculate_totalsalary 
AS 
BEGIN
    DECLARE @totalsalary FLOAT;
    SET @totalsalary = (
        SELECT SUM(salary)
        FROM Salary S, Employee E
        WHERE E.emprole = S.emprole
        AND workstatus='Active'
    );
    IF @totalsalary IS NULL
        SET @totalsalary = 0;
    PRINT 'Total Salary: Rs ' + CAST(@totalsalary AS VARCHAR(10));
    RETURN @totalsalary;
END

EXEC sp_total_salary;

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


-- Procedure to calculate profit
CREATE PROCEDURE sp_calculate_profit
AS 
BEGIN
    DECLARE @totalsales AS FLOAT,@totalsalary AS FLOAT,@costexpireddrugs AS FLOAT, @profit FLOAT
    PRINT 'REVENUE:';
    EXEC @totalsales = sp_calculate_totalsales;
    PRINT 'EXPENSE:';
    EXEC @costexpireddrugs = sp_calculate_costexpireddrugs;
    EXEC @totalsalary = sp_calculate_totalsalary;
    
    SET @profit = @totalsales - (@totalsalary+@costexpireddrugs);
    PRINT 'PROFIT: Rs ' + CAST(@profit AS VARCHAR(11));
END

EXEC sp_calculate_profit;

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

-----------------------------
--  Customer Buys Drugs   --
-----------------------------
-- NOTE: ALL OF THE 7 PROCEDURES BELOW ARE INTERCONNECTED
--       EXECUTING ONE OF THEM WILL PRODUCE INCONSISTENCIES


CREATE PROCEDURE sp_insert_drugsold @salesid INTEGER, @drugid INTEGER, @quantity INTEGER 
AS
BEGIN
    INSERT INTO Drug_Sold (salesid, drugid, quantity) VALUES (@salesid, @drugid, @quantity);
END

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- sp_processtransaction takes customer order, employee id, customer lastname, customer firstname 
-- and customer contactnumber as parameter
CREATE PROCEDURE sp_processtransaction
	@customer_order temporary_order_table READONLY,
    @empid INTEGER,
    @custlname VARCHAR(20),
    @custfname VARCHAR(20),
    @custcontactnum VARCHAR(11)
AS
BEGIN
	DECLARE @transaction_possible INTEGER;
	EXEC @transaction_possible = sp_check_drugorders @customer_order
	IF @transaction_possible = 1
		EXEC sp_start_transaction @customer_order, @empid, @custlname, @custfname, @custcontactnum	
END

-- Check if the order of the customer is available
CREATE PROCEDURE sp_check_drugorders @order AS temporary_order_table READONLY
AS
BEGIN
	DECLARE @order_num INTEGER, @drug_qty INTEGER, @drug_qtyinstock INTEGER, @drugname VARCHAR(50), @ordered_drugname VARCHAR(50)
    DECLARE @order_available INTEGER = 1;
	SET @order_num = ( SELECT MAX(row_num) FROM @order )
    DEClare @count INTEGER = 1

    WHILE @count<=@order_num
    BEGIN
        SET @ordered_drugname = ( SELECT drugname FROM @order WHERE row_num=@count )

        SELECT @drugname=D.drugname, @drug_qty=T.quantity
        FROM Drug_Info D, @order T 
        WHERE T.row_num=@count AND D.drugname=T.drugname

        IF @@ROWCOUNT = 0
            BEGIN
                PRINT @ordered_drugname + ' -> Not available currently.'
                SET @order_available = 0
            END
        ELSE
            BEGIN
                SET @drug_qtyinstock = ( SELECT SUM(numinstock) FROM Drug_Info WHERE drugname=@drugname )
                IF @drug_qtyinstock < @drug_qty
                    BEGIN
                        PRINT @ordered_drugname + ' -> Only ' + CAST(@drug_qtyinstock AS VARCHAR(5)) + ' available currently.'
                        SET @order_available = 0
                    END
                ELSE
                    PRINT @ordered_drugname + ' -> Available.'
            END

        SET @count = @count + 1
    END

    RETURN @order_available
END

-- PARAMETERS -> OrderOfCustomer (declared as a user define type)

-- NOTE: ALL THE 3 LINES BELOW NEED TO BE EXECUTED AT THE SAME TIME
SELECT * FROM Drug_Info
/* LINE 1 */ DECLARE @cust_order AS temporary_order_table;														
/* LINE 2 */ INSERT INTO @cust_order VALUES ('Doliprane 1g',300),('Benylin 4 flu',3), ('test1',1)
/* LINE 3 */ EXEC sp_check_drugorders @cust_order;  

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


-- sp_start_transaction is used to create appropriate records in their respective table
-- for processing
CREATE PROCEDURE sp_start_transaction
    @order temporary_order_table READONLY,
    @empid INTEGER,
    @custlname VARCHAR(20),
    @custfname VARCHAR(20),
    @custcontactnum VARCHAR(11)
AS
BEGIN
    DECLARE @id AS INTEGER, @cust INTEGER;
    EXEC @cust = sp_check_previousCust @custlname, @custfname, @custcontactnum;
    EXEC sp_update_numpurchases @cust;
    SET @id = (SELECT MAX(salesid) FROM Sales_Info) + 1;

    -- NULL will be updated later
    INSERT INTO Sales_Info VALUES (@id, @empid, @cust, NULL);

    DECLARE @NUMROWS INTEGER = (SELECT MAX(row_num) FROM @order);
    EXEC sp_process_sale @order, @NUMROWS, @id;
    EXEC sp_update_totalprice @id;
END

-- sp_process_sale is used to process the orders obtained from Customer and add them to
-- Drug_Sold table

CREATE PROCEDURE sp_process_sale @order_obtained temporary_order_table READONLY, @row_num INTEGER, @salesid INTEGER
AS
BEGIN
    IF @row_num != 0
    BEGIN
        DECLARE @current_order temporary_order_table;
        INSERT @current_order (drugname,quantity) 
        SELECT drugname, quantity 
        FROM @order_obtained;

        DECLARE @drug_ordered VARCHAR(50), @quantity INTEGER;
        SELECT @drug_ordered=drugname, @quantity=quantity
        FROM @order_obtained WHERE row_num=@row_num;

        DECLARE @current_stock INTEGER, @id INTEGER;
        SELECT TOP 1 @current_stock=numinstock, @id=drugid
        FROM Drug_Info WHERE drugname=@drug_ordered AND numinstock>0
        ORDER BY numinstock ASC;

        IF @current_stock < @quantity
            BEGIN
                SET @quantity = @quantity - @current_stock;
                UPDATE @current_order
                SET quantity=@quantity
                WHERE row_num=@row_num;

                UPDATE Drug_Info
                SET numinstock=0
                WHERE drugid=@id;

                EXEC sp_insert_DRUGSOLD @salesid, @id, @current_stock;
                EXEC sp_process_sale @current_order, @row_num, @salesid;
            END
        ELSE
            BEGIN
                SET @current_stock = @current_stock - @quantity;
                UPDATE  Drug_Info
                SET numinstock=@current_stock
                WHERE drugid=@id;
                SET @row_num = @row_num - 1;
                EXEC sp_insert_DRUGSOLD @salesid, @id, @quantity;
                EXEC sp_process_sale @current_order, @row_num, @salesid;
            END
    END
END
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


-- This procedure is use to calculate total price of the order 
CREATE PROCEDURE sp_update_totalprice @salesid INTEGER
AS
BEGIN
    DECLARE @price FLOAT, @totalpurchases INTEGER;
    SET @price = (
        SELECT SUM(S.quantity*I.unitprice)
        FROM Drug_Info I, Drug_Sold S
        WHERE S.salesid=@salesid
        AND I.drugid=S.drugid
    );

	SET @totalpurchases = (
		SELECT C.NumPurchases
		FROM Customer C, Sales_Info S
		WHERE S.salesid=@salesid
		AND C.custid = S.custid
	)

	IF @totalpurchases%10=0
		BEGIN
			SET @price = 0.98 * @price
			PRINT '2% DISCOUNT'
		END
    UPDATE Sales_Info
    SET totalprice=@price
    WHERE salesid=@salesid;

    PRINT 'Transaction Successful';
    PRINT 'Total Price: Rs' + CAST(@price AS VARCHAR(5));
END

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- Check if customer is already in Customer table and if not, a new record for that customer is created
-- This procedure return custid
CREATE PROCEDURE sp_check_previousCust
    @custlastname VARCHAR(15),
    @custfirstname VARCHAR(15),
    @custcontactnum VARCHAR(11)
AS
BEGIN
    DECLARE @ID INTEGER;
    SET @ID = (SELECT custid
               FROM Customer
               WHERE custlastname=@custlastname AND custfirstname=@custfirstname);
    IF @ID IS NULL
        BEGIN
        SET @ID = (SELECT MAX(custid) FROM Customer) + 1;
        INSERT INTO Customer VALUES (@ID, @custlastname, @custfirstname, @custcontactnum,0);
        END

    RETURN @ID;
END


-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- AVAILABLE DRUGS
/* LINE 1 */ DECLARE @newcust_order AS temporary_order_table;							   
/* LINE 2 */ INSERT INTO @newcust_order VALUES ('Doliprane 1g',3),('Benylin 4 flu',3);  
/* LINE 3 */ EXEC sp_processtransaction @newcust_order, 1, 'Ridwaan', 'Ibrahim', '54368767';

-- UNAVAILABLE DRUGS
/* LINE 1 */ DECLARE @newcust_order AS temporary_order_table;							   
/* LINE 2 */ INSERT INTO @newcust_order VALUES ('Doliprane 1g',3000),('Benylin 4 flu',3);  
/* LINE 3 */ EXEC sp_processtransaction @newcust_order, 1, 'Lukaku', 'Romelu', '54368767'; 

-- 2% DISCOUNT
/* LINE 1 */ DECLARE @newcust_order AS temporary_order_table;							   
/* LINE 2 */ INSERT INTO @newcust_order VALUES ('Doliprane 1g',3),('Benylin 4 flu',3);  
/* LINE 3 */ EXEC sp_processtransaction @newcust_order, 1, 'Lukaku', 'Romelu', '54368767'; 

-- RECORD WITH SAME DRUGNAME AND DRUGTYPE
INSERT INTO Drug_Info VALUES(20021,'Ventolin inhaler x 200 doses','inhalation','2026-12-31',94.68,4);
SELECT * FROM Drug_Info
/* LINE 1 */ DECLARE @newcust_order AS temporary_order_table;							   
/* LINE 2 */ INSERT INTO @newcust_order VALUES ('Doliprane 1g',3),('Ventolin inhaler x 200 doses',6);  
/* LINE 3 */ EXEC sp_processtransaction @newcust_order, 1, 'Lukaku', 'Romelu', '54368767';



-----------------------------
-- Supplier Supplies Drug  --
-----------------------------

-- *****    PART 1    *****
-- sp_search_previousdrug is used to make change to the Drug_Info table
CREATE PROCEDURE sp_search_previousdrug
    @name VARCHAR(40),
    @drugtype VARCHAR(20),
    @expirydate DATE
AS
BEGIN
    DECLARE @ID INTEGER
    -- Search for records with the same drugname and drugtype and numinstock=0
    -- If found then the first record is selected
    SET @ID = (SELECT TOP 1 drugid
               FROM Drug_Info
               WHERE drugname=@name AND drugtype=@drugtype AND numinstock=0
               ORDER BY drugid) 
    -- If no record is found then a new one is created
    IF @ID IS NULL
        -- If no record is found then a new one is created
        BEGIN
        -- NULL values will be updated via a trigger
        EXEC @ID = sp_insert_drugs @name, @drugtype, @expirydate, NULL,NULL
        END
    ELSE
        -- If found then that record is updated
        BEGIN
        UPDATE Drug_Info
        SET expirydate=@expirydate
        WHERE drugid=@ID
        END

    RETURN @ID
END
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

-- *****    PART 2    *****
CREATE PROCEDURE sp_update_drugsupplied
    @supid INTEGER,
    @drugname VARCHAR(40),
    @drugtype VARCHAR(20),
    @expirydate DATE,
    @numbox INTEGER,
    @drugperbox INTEGER,
    @costprice FLOAT,
    @sellingprice FLOAT
AS
BEGIN
    DECLARE @drugid INTEGER
    -- drugid obtained from sp_search_drug
    EXEC @drugid = sp_search_previousdrug @drugname, @drugtype, @expirydate
    INSERT INTO Drug_Supplied VALUES (@supid,@drugid, CAST(GETDATE() AS DATE),@numbox,@drugperbox,@costprice,@sellingprice)

    -- Then Trigger tg_update_druginfo will be called to update numinstock and unitprice in Drug_Info
END
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

-- *****    PART 3    *****
CREATE TRIGGER tg_update_druginfo
ON Drug_Supplied
    AFTER INSERT
AS
    DECLARE @ID INTEGER, @numbox INTEGER, @drugsperbox INTEGER, 
            @sellingprice FLOAT, @unitprice FLOAT, @new_numinstock INTEGER;

    SELECT @ID=drugid, @numbox=numbox, @drugsperbox=drugperbox, @sellingprice=sellingprice
    FROM INSERTED;

    SET @new_numinstock = @numbox * @drugsperbox;
    SET @unitprice = ROUND(@sellingprice/@drugsperbox, 2);

    UPDATE Drug_Info
    SET unitprice = @unitprice, numinstock = @new_numinstock
    WHERE drugid=@ID;


SELECT * FROM Drug_Info
-- UPDATE EXISTING RECORD
EXEC sp_update_drugsupplied 5355, 'Betadine mouthwash 100ml', 'Gargarisme', '2023-10-09', 3, 2, 254.5, 262.56

-- ADD NEW RECORD
EXEC sp_update_drugsupplied 5008, 'Losatan', 'table', '2023-10-09', 3, 12, 124.5, 130.56
