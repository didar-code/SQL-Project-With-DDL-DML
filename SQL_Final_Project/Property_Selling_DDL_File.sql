
---CASE NO:1

IF DB_ID('Property_Selling') IS NOT NULL
DROP DATABASE Property_Selling
GO
CREATE DATABASE Property_Selling
ON(
NAME=Property_Selling_Data,
FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Property_Selling_Data.mdf',
SIZE=25MB,
MAXSIZE=100MB,
FILEGROWTH=5%
)
LOG ON(
NAME=Property_Selling_Log,
FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Property_Selling_Log.ldf',
SIZE=2MB,
MAXSIZE=25MB,
FILEGROWTH=1%
)
GO

USE master
GO
create database Property_Selling
USE Property_Selling
GO
CREATE TABLE Agency(
AgencyID char(3) primary key NOT NULL,
AgencyName varchar(30) NOT NULL,
PhoneNumber char(11) NOT NULL,
EmailAddress varchar(35) NOT NULL
)
GO
CREATE TABLE Clients(
ClientID char (3) primary key  NOT NULL,
ClientName varchar (25) NOT NULL,
PhoneNumber char (11) NOT NULL,
EmailAddress varchar (25) NOT NULL,
Budget MONEY NULL
)
GO
CREATE TABLE PropertyType(
PropertyTypeID char (3) primary key  NOT NULL,
PropertyTypeName varchar(10) NOT NULL
)
GO
CREATE TABLE Properties(
PropertyID char(4) primary key NOT NULL,
AgencyID char(3) REFERENCES Agency(AgencyID) ON DELETE CASCADE NOT NULL,
PropertyTypeID char (3) REFERENCES PropertyType(PropertyTypeID) ON DELETE CASCADE NOT NULL ,
Area_sqft int NOT NULL,
PropertyCity varchar (15) NOT NULL,
PropertyState char (2) NOT NULL,
PropertyZipCode INT NULL
)
GO
CREATE TABLE DealStatus (
DealStatusID char (3) primary key NOT NULL,
DealStatusName varchar (15) NOT NULL,
PropertyZipCode INT NOT NULL
)
GO
CREATE TABLE Deals(
DealID char (3) primary key NOT NULL,
PropertyID char (4) REFERENCES Properties(PropertyID) ON DELETE CASCADE NOT NULL ,
AgencyID char(3) REFERENCES Agency(AgencyID) NOT NULL,
ClientID char(3) REFERENCES Clients(ClientID) ON DELETE CASCADE NOT NULL,
DealPrice MONEY NOT NULL,
DealDate date NOT NULL,
DealStatusID char (3) REFERENCES DealStatus(DealStatusID) ON DELETE CASCADE NOT NULL 
)
--CASE NO:3

USE Property_Selling
DELETE FROM Properties WHERE PropertyID='Pr16'

--CASE NO:5

DROP TABLE DealStatus1
--CASE NO:6

ALTER TABLE Deals1 
DROP COLUMN DealID1
--CASE NO:09

GO
CREATE VIEW vu_DealWiseClientsInfoWithEncryptionAndSchemaBinding
WITH ENCRYPTION,SCHEMABINDING
AS
SELECT ClientID,ClientName,Budget FROM dbo.Clients
WHERE ClientID IN(SELECT DISTINCT ClientID FROM dbo.Deals WHERE DealPrice>2000000)
----JUSTIFY
SELECT * FROM dbo.vu_DealWiseClientsInfoWithEncryptionAndSchemaBinding
EXEC sp_helptext vu_vu_DealWiseClientsInfoWithEncryptionAndSchemaBinding
--CASE NO:10

IF OBJECT_ID ('sp_Proprty_SellingReadInsertUpdateDeleteOutput') IS NOT NULL
DROP PROCEDURE sp_Proprty_SellingReadInsertUpdateDeleteOutput
GO
CREATE PROC sp_Proprty_SellingReadInsertUpdateDeleteOutput
@OperationType CHAR (1),
@PropertyID CHAR(4),
@AgencyID CHAR(3),
@PropertyTypeID CHAR(3),
@Area_sqft INT,
@PropertyCity VARCHAR (15),
@PropertyState CHAR(2),
@Name VARCHAR (15) OUTPUT
AS
BEGIN
IF @OperationType='S'
BEGIN
SELECT * FROM Properties
END
IF  @OperationType='I'
BEGIN
INSERT INTO Properties (PropertyID,AgencyID,Area_sqft,PropertyTypeID,PropertyCity,PropertyState)
VALUES  (@PropertyID,@AgencyID,@Area_sqft,@PropertyTypeID,@PropertyCity,@PropertyState)
END
IF  @OperationType='U'
BEGIN
UPDATE Properties  
SET AgencyID=@AgencyID, Area_sqft=@Area_sqft,PropertyTypeID=@PropertyTypeID,PropertyCity=@PropertyCity,PropertyState=@PropertyState
WHERE PropertyID=@PropertyID
END
IF  @OperationType='D'
BEGIN
DELETE FROM Properties WHERE PropertyID=@PropertyID
END
IF  @OperationType='O'
BEGIN
SELECT @Name=PropertyCity FROM Properties WHERE PropertyID=@PropertyID
END
END
----JUSTIFY
EXEC sp_Proprty_SellingReadInsertUpdateDeleteOutput 'S','','','','','','',''
EXEC sp_Proprty_SellingReadInsertUpdateDeleteOutput 'I','Pr16','A01','P01','6000','Jessore','JS',''
EXEC sp_Proprty_SellingReadInsertUpdateDeleteOutput 'U','Pr16','A01','P01','7000','','',''
EXEC sp_Proprty_SellingReadInsertUpdateDeleteOutput 'D','Pr16','','','','','',''
EXEC sp_Proprty_SellingReadInsertUpdateDeleteOutput 'O','Pr15','','','','','',''

--CASE NO:12

GO
CREATE INDEX IX_Clients_ClientName_Budget
ON Clients (ClientName ASC, Budget DESC)
GO
--CASE NO:13

GO
CREATE FUNCTION fnSumPrice()
RETURNS MONEY
BEGIN
RETURN(SELECT SUM(DealPrice) 
FROM Deals
WHERE DealPrice>5000000);
END;

PRINT 'DealPrice:$' + CONVERT (VARCHAR,dbo.fnSumPrice(),1);
--CASE NO:14

GO
CREATE TRIGGER tr_PropertyType_InsertUpdate
ON PropertyType
AFTER INSERT,UPDATE
AS

SELECT * FROM deleted
SELECT * FROM inserted

INSERT INTO PropertyType
VALUES ('P18','Rent')

UPDATE PropertyType SET PropertyTypeName='Rent', PropertyTypeID='P19' WHERE PropertyTypeID='P18'
GO
CREATE TRIGGER tr_TermsDelete
ON PropertyType
AFTER DELETE
AS
SELECT * FROM deleted
ROLLBACK

DELETE FROM PropertyType WHERE PropertyTypeID='P18'
--JUSTIFY
SELECT * FROM PropertyType
--CASE NO:15

IF OBJECT_ID('tempdb..#ClientsCopy') IS NOT NULL
DROP TABLE tempdb..#ClientsCopy
SELECT ClientID,ClientName INTO #ClientsCopy
FROM Clients WHERE Budget<20000000

BEGIN TRAN
DELETE FROM #ClientsCopy WHERE ClientID='C03'
SAVE TRAN Clients1;
DELETE FROM #ClientsCopy WHERE ClientID='C05'
SAVE TRAN Clients2;
DELETE FROM #ClientsCopy WHERE ClientID='C07'
SELECT * FROM #ClientsCopy;
ROLLBACK TRAN Clients2;
SELECT * FROM #ClientsCopy;
ROLLBACK TRAN Clients1;
SELECT * FROM #ClientsCopy;
COMMIT TRAN
SELECT * FROM #ClientsCopy;
--CASE NO:16

GO
CREATE FUNCTION fn_StateWisePropertiesInformation(@State char(2))
RETURNS TABLE
AS
RETURN(
SELECT PropertyID,PropertyCity,PropertyZipCode FROM Properties WHERE PropertyState=@State
)
--JUSTIFY
SELECT * FROM dbo.fn_StateWisePropertiesInformation('kh')
--CASE NO:17
GO
CREATE FUNCTION fn_MultiStatementForSumDealPrice(@SumAmount money)
RETURNS @SumAmountTable TABLE 
(DealID char(3),DealPrice money,SumAmount money)
AS
BEGIN
INSERT INTO  @SumAmountTable
SELECT DealID,DealPrice,SUM(DealPrice) AS SumAmount FROM Deals
GROUP BY DealID,DealPrice
HAVING SUM(DealPrice) >=@SumAmount
RETURN
END
GO
--JUSTIFY
SELECT * FROM fn_MultiStatementForSumDealPrice(10000000)

--CASE NO:18

CREATE PROC spHandleErrorByThrow
@PropertyID CHAR(4),
@AgencyID CHAR(3),
@PropertyTypeID CHAR(3),
@Area_sqft INT,
@PropertyCity VARCHAR(15),
@PropertyState CHAR(2),
@Name VARCHAR(50) OUTPUT
AS
BEGIN
SET NOCOUNT ON;

IF EXISTS (SELECT 1 FROM Deals WHERE AgencyID = @AgencyID)
BEGIN
 INSERT INTO Properties 
 (PropertyID, AgencyID, PropertyTypeID, Area_sqft, PropertyCity, PropertyState)
 VALUES (@PropertyID, @AgencyID, @PropertyTypeID, @Area_sqft, @PropertyCity, @PropertyState);

SET @Name = 'Property inserted successfully for Agency ' + @AgencyID;
END
ELSE
BEGIN
THROW 50001, 'Not a Valid Property — Agency ID not found in Deals table.', 1;
END
END

DECLARE @ResultMessage VARCHAR(50);

EXEC spHandleErrorByThrow
@PropertyID = 'PR18',
@AgencyID = 'A01',
@PropertyTypeID = 'P01',
@Area_sqft = 2500,
@PropertyCity = 'Jessore',
@PropertyState = 'JS',
@Name = @ResultMessage OUTPUT;

SELECT @ResultMessage AS Result;

 --CASE NO:23


GO
ALTER TABLE BuildingType ADD Size VARCHAR(10)
ALTER TABLE BuildingType DROP COLUMN Size
CREATE TABLE Test(TestID int)
DROP TABLE Test
 --CASE NO:27

 CREATE TABLE Transations2(
 Transactionid INT NOT NULL IDENTITY PRIMARY KEY,
 InvoiceTotal MONEY NOT NULL,
 PaymentTotal MONEY NOT NULL DEFAULT 0,
 CHECK((InvoiceTotal>=0) AND (PaymentTotal>=0))
 )
