
--**********************************************************************
--                         Triggers 
--**********************************************************************

-- Check whether telephone is valid or not
CREATE TRIGGER tg_check_telephoneNum
ON Customer
    INSTEAD OF INSERT
AS
    DECLARE @num VARCHAR(15), @id INTEGER, @name VARCHAR(25), @lastname VARCHAR(25), @totalpurchases INTEGER;
    SELECT @id = custid, @name = custfirstname, @lastname = custlastname, @num = custcontactnum, @totalpurchases=NumPurchases
    FROM INSERTED;
    IF ((LEN(@num)<8) OR (LEN(@num)>8))
        BEGIN
        PRINT 'Invalid phone Number';
        RETURN
        END
    IF (@num IS NULL)
        BEGIN
        PRINT 'Phone Number has not yet been entered';
        RETURN
        END
    INSERT INTO Customer VALUES(@id, @lastname, @name, @num, @totalpurchases);
    PRINT 'INSERTION SUCCESSFULL'

SELECT * FROM Customer
INSERT INTO Customer VALUES (1005, 'Rid', 'Wan', '56789898', 1)  -- INSERT SUCCESSFUL
INSERT INTO Customer VALUES (1006, 'Willy', 'Wonca', '89898', 1) -- INVALID PHONE NUM
INSERT INTO Customer VALUES (1007, 'Fred', 'Vimm', NULL, 1)      -- NO PHONE NUMBER
SELECT * FROM Customer
DELETE FROM Customer WHERE custid=1005 -- TO REMOVE UNWANTED DATA

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

-- Check wether employee role is valid or not
CREATE TRIGGER tg_check_emprole
ON Employee
    INSTEAD OF INSERT
AS
    DECLARE @emprole VARCHAR(11), @empid INTEGER, @emplastname VARCHAR(20), @empfirstname VARCHAR(20), @empaddr VARCHAR(40), @empcontactnum VARCHAR(15);
    SELECT @empid=empid, @emplastname=emplastname, @empfirstname=empfirstname, 
        @empaddr=empaddr, @empcontactnum=empcontactnum, @emprole=emprole
    FROM INSERTED;
    IF (@emprole IS NULL)
        BEGIN
        PRINT 'The role of the employee should be inserted';
        RETURN
        END
    IF NOT EXISTS( SELECT emprole FROM salary WHERE emprole=@emprole)
        BEGIN
        PRINT 'This employee role does not exist';
        RETURN
        END
    INSERT INTO Employee VALUES(@empid,@emplastname,@empfirstname,@empaddr,@empcontactnum,@emprole,'Active');
    PRINT 'INSERTION SUCCESSFULL'

SELECT * FROM Employee
INSERT INTO Employee VALUES (7, 'Rid', 'Wan', '12 ally', '56789898', 'Dispenser', 'Active')  -- INSERT SUCCESSFUL
INSERT INTO Employee VALUES (8, 'Rid', 'Wan', '13 ally', '56239898', 'test', 'Active')       -- INVALID EMPLOYEE ROLE
INSERT INTO Employee VALUES (9, 'Rid', 'Wan', '14 ally', '56549898', NULL, 'Active')         -- NO EMPLOYEE ROLE 
SELECT * FROM Employee
DELETE FROM Employee WHERE empid=7 -- TO REMOVE UNWANTED DATA

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


-- When drugs are supplied, this trigger sets the unitprice and number of drugs in stock
-- From the data obtained in the Drug_Supplied Table
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

-- NOTE: THIS TRIGGER WORKS ONLY AFTER sp_update_drugsupplied is called.

-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


-- tg_check_expirydate is used to check if drugs are expired
CREATE TRIGGER tg_check_expirydate
ON Drug_Info
    AFTER INSERT,UPDATE
AS
    INSERT INTO expired_drugs (drug, expireddate, amount, price)
    SELECT drugname, expirydate, numinstock, unitprice
    FROM Drug_Info
    WHERE expirydate < CAST( GETDATE() AS DATE )
    AND numinstock!=0;

    UPDATE Drug_Info
    SET numinstock=0
    WHERE expirydate < CAST( GETDATE() AS DATE );

SELECT * FROM Drug_Info
INSERT INTO Drug_Info VALUES (20014, 'test', 'test', '2020-12-11', 8.45, 12)  -- EXPIRED DRUGS
SELECT * FROM Drug_Info
SELECT * FROM expired_drugs
DELETE FROM expired_drugs WHERE drug='test' -- TO REMOVE UNWANTED DATA

