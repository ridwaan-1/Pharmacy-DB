

--**********************************************************************
--                           VIEWS 
--**********************************************************************
--VIEW TO SEE THE SALARY OF THE EMPLOYEES
CREATE VIEW vw_empsalary AS
SELECT empfirstname,emplastname,e.emprole,s.salary 
FROM Employee e,Salary s
WHERE e.emprole=s.emprole
AND e.workstatus='Active'

SELECT * FROM vw_empsalary;
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


--VIEW TO HELP EMPLOYEES TO KNOW ABOUT THE DRUGS SUPPLIED BY THEIR SUPPLIER
CREATE VIEW vw_supplier 
AS SELECT s.supid, d.drugid, i.drugname, d.supplieddate, d.numbox, d.drugperbox, d.costprice
FROM Supplier s, Drug_Supplied d, Drug_Info i
WHERE s.supid = d.supid
AND d.drugid= i.drugid;

SELECT * FROM vw_supplier;
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


--VIEW TO SEE ALL EMPLOYEES CURRENTLY WORKING AT THE PHARMACY
CREATE VIEW vw_empinfo AS 
SELECT empid,emplastname,empfirstname,empaddr,empcontactnum
FROM Employee
WHERE workstatus='Active'

SELECT * FROM vw_empinfo;