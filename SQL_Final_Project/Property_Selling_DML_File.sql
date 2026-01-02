
--CASE NO:2

USE Property_Selling
GO
INSERT INTO Agency(AgencyID, AgencyName,PhoneNumber,EmailAddress)
VALUES
('A01','Sheltech (Pvt.) Ltd.','01711547941','Sheltechltd02@gmail.com'),
('A02','Assure Group','01712154652','assuregroup44@gmail.com'),
('A03','Shanta Holdings Limited','01711211243','shantaholdingsltd@gmail.com'),
('A04','Bashundhara Group','01712154652','bashundharagroup21@gmail.com')

INSERT INTO Clients(ClientID,ClientName,PhoneNumber, EmailAddress,Budget)
VALUES
('C01','Farhana Karim','01452214544','farhanakarim55@gmail.com',20000000),
('C02','Abdullah Al Mamun','0132255554','almamun@gmail.com',35000000),
('C03','Mrs.Laila Rahman','0165115556','mrsahman5@gmail.com',15000000),
('C04','Md.Tasnim Akhter','017221556','tasnimakhter@gmail.com',25000000),
('C05','Monir Hossain','0150165522','monirhossain@gmail.com',9000000),
('C06','Mita Sultana','01800001154','mitasultana@gmail.com',42000000),
('C07','Salim Reza','01457601154','salimreza@gmail.com',18000000),
('C08','Ayesha Sultana','0156445654','ayesha15556@gmail.com',35000000),
('C09','Imran Hossain','0154861154','hossain2554@gmail.com',15000000),
('C10','Nahid Hasan Chowdhury','0192545766','vpnahid012@gmail.com',15000000),
('C11','Mrs.Lutfun Nahar','01416569564','lutfunnahar1@gmail.com',12000000),
('C12','Monzur Miah','01954462775','miahhah26@gmail.com',11100000),
('C13','Nabila Akter','01315445455','nabilaajjg@gmail.com',25000000),
('C14','Habib Ullah','01712454865','habibullah01@gmail.com',320000000),
('C15','Adv.Samira Chowdhury','01785235566','samiarakhatun@gmail.com',20000000)

GO
INSERT INTO PropertyType(PropertyTypeID,PropertyTypeName)
VALUES
('P01','Apartment'),
('P02','Commercial'),
('P03','Land')

GO
INSERT INTO Properties(PropertyID, AgencyID, PropertyTypeID, Area_sqft, PropertyCity, PropertyState,PropertyZipCode)
VALUES
('Pr1','A01','P01',1800,'Dhaka','DH',1200),
('Pr2','A02','P02'	,3200,'Chattogram','CH',4300),
('Pr3','A03','P03'	,5000,'Sylhet','SY',3100),
('Pr4','A02','P01',2200,'Dhaka','DH',1200),
('Pr5','A01','P01',1500,'Khulna','KH',9000),
('Pr6','A02','P02',4000,'Rajshahi','RA',6000),
('Pr7','A03','P01',1700,'Dhaka','DH',1200),
('Pr8','A01','P02',3500,'Chattogram','CH',4300),
('Pr9','A02','P03',4500,'Sylhet','SY',3100),
('Pr10','A02','P01',1600,'Dhaka','KH',9000),
('Pr11','A03','P01',1400,'Rajshahi','RA',6000),
('Pr12','A04','P03',5200,'Khulna','KH',9000),
('Pr13','A04','P01',2300,'Dhaka','DH',1200),
('Pr14','A02','P02',3100,'Chattogram','CH',4300),
('Pr15','A01','P01',1700,'Sylhet','SY',3100)

GO
INSERT INTO DealStatus(DealStatusID,DealStatusName)
VALUES
('DS1','Negotiating'),
('DS2','Pending'),
('DS3','Completed')

GO
INSERT INTO Deals(DealID, PropertyID, AgencyID, ClientID, DealPrice,  DealDate,DealStatusID)
VALUES
('D01','Pr1','A01','C01',18000000,'2025-09-22', 'DS1'),
('D02','Pr2','A02','C02',34000000,'2025-08-10','DS2'),
('D03','Pr3','A03','C03',10500000,'2025-05-18',	'DS3'),
('D04','Pr4','A02','C04',23500000,'2025-06-12' ,'DS3'),
('D05','Pr5','A01','C05',9000000,'2025-07-21','DS2'),
('D06','Pr6','A02','C06',41000000,'2025-05-30','DS1'),
('D07','Pr7','A01','C07',1700000,'2025-04-16','DS3'),
('D08','Pr8','A03','C08',3550000,'2025-08-02','DS3'),
('D09','Pr9','A01','C09',1150000,'2025-07-16','DS2'),
('D10','Pr10','A02','C10',1550000,'2025-09-01','DS1'),
('D11','Pr11','A03','C11',1050000,'2025-06-25','DS3'),
('D12','Pr12','A04','C12',1200000,'2025-07-30','DS2'),
('D13','Pr13','A04','C13',2450000,'2025-08-25','DS3'),
('D14','Pr14','A02','C14',3300000,'2025-05-19','DS1'),
('D15','Pr15','A01','C15',1700000,'2025-06-07','DS3')



--CASE NO:4

UPDATE Deals SET DealPrice=DealPrice+100000
WHERE DealPrice<100000
--CASE NO:7

SELECT p.PropertyID,MAX(P.PropertyState) AS NumOfState,d.AgencyID,d.DealPrice FROM Properties AS p JOIN Deals AS d ON p.AgencyID=d.AgencyID
GROUP BY p.PropertyID,d.AgencyID,d.DealPrice
HAVING DealPrice>2000000
--CASE NO:08

SELECT ClientID,ClientName,(SELECT SUM(DealPrice) AS TotalDeal FROM Deals WHERE Deals.ClientID=Clients.ClientID 
) AS TotalDeal  FROM Clients 
ORDER BY TotalDeal DESC
--CASE NO:11

SELECT DealID,DealDate,DealStatusID,DealPrice FROM Deals 
WHERE NOT DealDate>'2025-08-10'
AND DealPrice<20000000
OR DealStatusID='DS3'


--CASE NO:19

GO
WITH SUMMERY AS (
SELECT  p.PropertyState,p.PropertyCity, SUM( d.DealPrice) AS SumAmount FROM Deals AS d JOIN  Properties AS p ON d.AgencyID=p.AgencyID
GROUP BY  p.PropertyState,p.PropertyCity),
TOPAmountTable AS
(SELECT s.PropertyState,MAX(SumAmount) AS MaxAmount  FROM SUMMERY As S 
GROUP BY s.PropertyState)
SELECT s.PropertyState,S.SumAmount,t.MaxAmount FROM SUMMERY AS s JOIN TOPAmountTable
AS t ON s.PropertyState=t.PropertyState AND SumAmount=MaxAmount

--CASE NO:20

SELECT PropertyTypeName,PropertyTypeID, 
CASE PropertyTypeID
WHEN 'P01' THEN 'Small'
WHEN 'P02' THEN 'Medium'
WHEN 'P03' THEN 'High'
END
AS Type1
FROM PropertyType
ORDER BY PropertyTypeID
--CASE NO:21

GO

DECLARE @PropertyIDVar CHAR(4), @AgenyIDVar char(3),@PropertyTypeIDVar CHAR(3) ,@Area_sqftVar INT,@UpdateCount int;
SET @UpdateCount=0;

DECLARE Properties_cursor CURSOR
FOR
SELECT PropertyID,AgencyID,PropertyTypeID,Area_sqft FROM Properties WHERE Area_sqft>1000

OPEN Properties_cursor

FETCH NEXT FROM Properties_cursor INTO @PropertyIDVar,@AgenyIDVar,@PropertyTypeIDVar,@Area_sqftVar;
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @AgenyIDVar='A01'
BEGIN
UPDATE Properties
SET Area_sqft=Area_sqft+.1
WHERE PropertyID=@PropertyIDVar
PRINT 'PropertyID '+CONVERT(varchar,@PropertyIDVar)+' AgenyID '+CONVERT(varchar,@AgenyIDVar)+'PropertyTypeID '+CONVERT(varchar,@PropertyTypeIDVar)+'Area_sqft '+CONVERT(varchar,@Area_sqftVar)
SET @UpdateCount=@UpdateCount+1;
END;
FETCH NEXT FROM Properties_cursor INTO @PropertyIDVar,@AgenyIDVar,@PropertyTypeIDVar,@Area_sqftVar;
END

CLOSE Properties_cursor;

DEALLOCATE Properties_cursor;

PRINT '';
PRINT CONVERT(varchar,@UpdateCount)+' row(s) updated'

--CASE NO:22

SELECT DealStatusName,
 NTILE('DS1') OVER (ORDER BY DealStatusID) AS Ntile2,
 NTILE('DS2') OVER (ORDER BY DealStatusID) AS Ntile3,
 NTILE('DS3') OVER (ORDER BY DealStatusID) AS Ntile4
 FROM DealStatus
  --CASE NO:24

GO
DECLARE @MyIdentity int,@MyRowCount int;

INSERT INTO Agency (AgencyID,AgencyName,PhoneNumber,EmailAddress)
VALUES('A06','JamunaGroup','0132457896','jamunagroup@gamail@com')
SET @MyIdentity=@@IDENTITY;
SET @MyRowCount=@@ROWCOUNT;

IF @MyRowCount=1
INSERT INTO Agency VALUES(@MyRowCount,'A06','JamunaGroup','0132457896','jamunagroup@gamail@com')

SELECT * FROM Agency WHERE AgencyName='JamunaGroup'

 --CASE NO:25

DECLARE @PropertyIDVar CHAR(4), @AgenyIDVar char(3),@PropertyTypeIDVar CHAR(3) ,@Area_sqftVar INT,@UpdateCount int;
SET @UpdateCount=0;

DECLARE Properties_cursor CURSOR
FOR
SELECT PropertyID,AgencyID,PropertyTypeID,Area_sqft FROM Properties WHERE Area_sqft>1000

OPEN Properties_cursor

FETCH NEXT FROM Properties_cursor INTO @PropertyIDVar,@AgenyIDVar,@PropertyTypeIDVar,@Area_sqftVar;
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @AgenyIDVar='A01'
BEGIN
UPDATE Properties
SET Area_sqft=Area_sqft+.1
WHERE PropertyID=@PropertyIDVar
PRINT 'PropertyID '+CONVERT(varchar,@PropertyIDVar)+' AgenyID '+CONVERT(varchar,@AgenyIDVar)+'PropertyTypeID '+CONVERT(varchar,@PropertyTypeIDVar)+'Area_sqft '+CONVERT(varchar,@Area_sqftVar)
SET @UpdateCount=@UpdateCount+1;
END;
FETCH NEXT FROM Properties_cursor INTO @PropertyIDVar,@AgenyIDVar,@PropertyTypeIDVar,@Area_sqftVar;
END

CLOSE Properties_cursor;

DEALLOCATE Properties_cursor;

PRINT '';
PRINT CONVERT(varchar,@UpdateCount)+' row(s) updated'
 --CASE NO:26

SELECT CAST('01-June-2019 10:00AM' AS DATE)

SELECT FORMAT(CONVERT(datetime,'01-June-2019 10:00 AM'),'hh:mm:ss')
--CASE NO:28

----iif
SELECT	DealID,SUM(DealPrice)  AS Amount, 
IIF (SUM(DealPrice)>20000000,'High','Low') AS DealStutus
FROM  Deals
GROUP BY DealID
ORDER BY SUM(DealPrice) DESC

---CHOOSE
SELECT PropertyCity,PropertyState,Area_sqft,
CHOOSE (Area_sqft,'Best','Better','Good','Decent')
FROM Properties
--CASE NO:29

---ISNULL
SELECT DealID,DealPrice,DealDate,
ISNULL (DealDate,'1900-01-01')
FROM Deals

---COALESCE--
SELECT DealID,DealPrice,DealDate,
COALESCE (DealDate,'1900-01-01')
FROM Deals
--CASE NO:30

SELECT PropertyCity,PropertyState,COUNT (*) AS QtyPropety
FROM Properties
GROUP BY GROUPING sets ((PropertyCity,PropertyState),PropertyZipCode)
ORDER BY PropertyCity DESC,PropertyState DESC
--CASE NO:31

------ROW NUMBER 
SELECT  ROW_NUMBER() OVER(PARTITION BY PropertyState ORDER BY PropertyCity) AS RowNumber,PropertyCity 
FROM Properties
------RANK
 SELECT RANK () OVER(ORDER BY AgencyID) AS RANK FROM Deals

------DENSE RANK
SELECT DENSE_RANK () OVER(ORDER BY AgencyID) AS DenseRank FROM Deals
--CASE NO:32

 ---FIRST_VALUE
SELECT PropertyID,Area_sqft,PropertyCity,AgencyID,FIRST_VALUE(Area_sqft) OVER (PARTITION BY AgencyID ORDER BY AgencyID) AS FirstValue FROM Properties  
----LAST_VALUE
SELECT PropertyID,Area_sqft,PropertyCity,AgencyID,LAST_VALUE(Area_sqft) OVER (PARTITION BY AgencyID ORDER BY AgencyID) AS LastValue FROM Properties 
----LEAD
SELECT AgencyID,DealPrice,DealDate,
LEAD(DealPrice) 
OVER(PARTITION BY AgencyID ORDER BY DealDate) AS LeadAmount
FROM Deals 
---LAG
SELECT AgencyID,DealPrice,DealDate,
LAG(DealPrice) 
OVER(PARTITION BY AgencyID ORDER BY DealDate) AS LagAmount
FROM Deals 
--CASE NO:33

SELECT DISTINCT AgencyID,PropertyCity,(SELECT MAX (DealDate) From Deals  
WHERE Deals.AgencyID= Properties.AgencyID) AS LastestInDate
FROM Properties 
ORDER BY LastestInDate DESC
--CASE NO:34

--------SOME
SELECT PropertyCity,PropertyState,Area_sqft,PropertyZipCode  FROM Properties
Where Area_sqft> SOME (SELECT Area_sqft FROM Properties Where PropertyZipCode =1200)
--------ANY
SELECT PropertyCity,PropertyState,Area_sqft,PropertyZipCode  FROM Properties
Where Area_sqft> ANY (SELECT Area_sqft FROM Properties Where PropertyZipCode =1200)
--------ALL
SELECT PropertyCity,PropertyState,Area_sqft,PropertyZipCode  FROM Properties
Where Area_sqft> ALL (SELECT Area_sqft FROM Properties Where PropertyZipCode =1200)
--CASE NO:35

SELECT PropertyCity,PropertyState,AgencyID FROM Properties 
WHERE AgencyID IN (SELECT AgencyID FROM Deals WHERE AgencyID='A01')
--CASE NO:36

SELECT DealPrice,DealDate,AgencyID FROM Deals
WHERE  EXISTS (SELECT * FROM Properties WHERE Properties.AgencyID=Deals.AgencyID)
--CASE NO:37

Select PropertyID,PropertyCity,PropertyZipCode From Properties
Where PropertyCity Like 'KH%'
-----
Select AgencyID,AgencyName,PhoneNumber from Agency
Where AgencyName Like '[A,E,I,U,O]%'
----
Select PropertyID,PropertyCity,PropertyZipCode,PropertyState From Properties 
WHere PropertyState Like 'D[A-J]'
----
Select PropertyID,PropertyCity,PropertyZipCode,PropertyState From Properties 
WHere PropertyState Like 'K[^K-Y]'
--CASE NO:38

Select DealID,DealDate,DealPrice From Deals 
Order BY DealPrice
OFFSET 5 ROWS FETCH NEXT 6 ROWS  Only
--CASE NO:39

SELECT PropertyCity,PropertyState,DealID,SUM(DealPrice) AS TotalDealAmount  
FROM Properties AS p JOIN Deals AS s ON p.AgencyID=s.AgencyID
GROUP BY  PropertyCity,PropertyState,DealID
ORDER BY TotalDealAmount DESC
--CASE NO:40

SELECT 'Active' AS Source, DealID, DealDate, DealPrice 
FROM Deals 
WHERE DealDate >= '2025-05-05' 
UNION 
SELECT 'Paid' AS Source, DealID, DealDate, DealPrice 
FROM Deals 
WHERE DealDate >= '2025-01-01' 
ORDER BY DealPrice DESC;

