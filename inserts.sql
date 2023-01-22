-- --**********************************************************************
-- --                    INSERTING DATA INTO THE TABLES
-- --**********************************************************************

INSERT INTO Salary VAlUES('Dispenser',12000);
INSERT INTO Salary VAlUES('Cleaner',10000);
INSERT INTO Salary VAlUES('Cashier',10000);
INSERT INTO Salary VAlUES('Pharmacy technician',18000);
INSERT INTO Salary VAlUES('Pharmacist',35000);

INSERT INTO Employee VALUES(0001,'Salah','Mohamed','Plaine Verte','58022193','Dispenser','Active');
INSERT INTO Employee VALUES(0002,'Smith','John','Cassis','59786543','Pharmacist','Active');
INSERT INTO Employee VALUES(0003,'Berbel','Alfred','Roche Bois','51234567','Dispenser','Inactive');
INSERT INTO Employee VALUES(0006,'Morinho','Jose','Bell Village','52342345','Cashier','Active');
INSERT INTO Employee VALUES(0004,'Gromblin','Mavrick','Saint Croix','5333444','Pharmacy Technician','Active');
INSERT INTO Employee VALUES(0005,'Alaba','David','Cite La Cure','54617612','Cleaner','Active');

INSERT INTO Drug_Info VALUES(20001,'Doliprane 1g','table','2022-07-31',7.45,42);
INSERT INTO Drug_Info VALUES(20002,'Voltarensupp 100mg','suppositoire','2021-06-30',16.50,12);
INSERT INTO Drug_Info VALUES(20003,'Diprostene inj x1ml','injection','2024-11-30',204.90,2);
INSERT INTO Drug_Info VALUES(20004,'Diprosone cream 10g','cream','2023-10-31',152.68,3);
INSERT INTO Drug_Info VALUES(20005,'Ventolin inhaler 200 doses','Inhalation',' 2022-04-30',92.19,3);
INSERT INTO Drug_Info VALUES(20006,'Gyneco-pevaryl x 1 ovules','Ovule','2023-04-30',125.01,2);
INSERT INTO Drug_Info VALUES(20007,'Gaviscon advance aniseed x12','sachet',' 2022-03-31',16.50,72);
INSERT INTO Drug_Info VALUES(20008,'Ventolin inhaler x 200 doses','inhalation','2025-12-31',94.68,4);
INSERT INTO Drug_Info VALUES(20009,'Benylin 4 flu','table',' 2023-01-31',10.00,50);
INSERT INTO Drug_Info VALUES(20010,'Benylin original','syrup','2022-02-28',170.12,4);
INSERT INTO Drug_Info VALUES(20011,'Betadine mouthwash 100ml','Gargarisme','2021-09-30',98.02,0);
INSERT INTO Drug_Info VALUES(20012,'Scheriproct oint','ointment','2021-04-30',358.50,1);
INSERT INTO Drug_Info VALUES(20013,'Sx tonix condom','miscellaneous','2021-05-15',40.00,4);

INSERT INTO Customer VALUES(1001,'Danny','Rose','59049968',5);
INSERT INTO Customer VALUES(1002,'Benteke','Christian','59046355',1);
INSERT INTO Customer VALUES(1003,'Lukaku','Romelu','58036541',9);
INSERT INTO Customer VALUES(1004,'Bakayoko','Samuel','59162622',4);

INSERT INTO Supplier VALUES(5006,'Unicorn Ltd','2108100','Champ de Mars, Port Louis');
INSERT INTO Supplier VALUES(5001,'Medical Trading Ltd','2104724','Les Salines, Port-Louis');
INSERT INTO Supplier VALUES(5007,'Scott.co Ltd','2069400','Riche Terre');
INSERT INTO Supplier VALUES(5008,'Pharmacy Nouvelle Ltd','2064500','Pailles');
INSERT INTO Supplier VALUES(5415,'Keenpharm.co ltd','2175310','Plaine Verte');
INSERT INTO Supplier VALUES(5355,'Ftm','2860660','Pailles');

INSERT INTO Drug_Supplied VALUES(5006,20005,'2021-02-20',6,1,67.89,92.19);
INSERT INTO Drug_Supplied VALUES(5007,20006,'2021-04-21',2,1,93.78,125.01);
INSERT INTO Drug_Supplied VALUES(5415,20001,'2021-05-01',7,8,47.98,59.60);
INSERT INTO Drug_Supplied VALUES(5006,20002,'2021-05-10',3,5,66.00,82.50);
INSERT INTO Drug_Supplied VALUES(5001,20008,'2021-03-28',4,1,69.90,94.68);
INSERT INTO Drug_Supplied VALUES(5355,20007,'2021-03-20',8,12,158.40,198.00);
INSERT INTO Drug_Supplied VALUES(5001,20010,'2021-04-05',6,1,136.10,170.12);

INSERT INTO Sales_Info VALUES(210421,0001,1002,144.34);
INSERT INTO Sales_Info VALUES(210320,0002,1003,49.50);
INSERT INTO Sales_Info VALUES(210201,0002,1001,266.80);
INSERT INTO Sales_Info VALUES(210511,0003,1004,619.78);

INSERT INTO Drug_Sold (salesid, drugid, quantity) VALUES(210421,20005,1);
INSERT INTO Drug_Sold (salesid, drugid, quantity) VALUES(210421,20001,7);
INSERT INTO Drug_Sold (salesid, drugid, quantity) VALUES(210320,20002,3);
INSERT INTO Drug_Sold (salesid, drugid, quantity) VALUES(210201,20001,4);
INSERT INTO Drug_Sold (salesid, drugid, quantity) VALUES(210201,20007,14);
INSERT INTO Drug_Sold (salesid, drugid, quantity) VALUES(210511,20001,3);
INSERT INTO Drug_Sold (salesid, drugid, quantity) VALUES(210511,20005,1);
INSERT INTO Drug_Sold (salesid, drugid, quantity) VALUES(210511,20007,10);
INSERT INTO Drug_Sold (salesid, drugid, quantity) VALUES(210511,20010,2);

