use EmployeeManagementDB_8jan2024
create TABLE Employee (
    Id INT PRIMARY KEY ,
    Name NVARCHAR(100),
    Email NVARCHAR(100),
    Gender NVARCHAR(10),
    CountryId INT FOREIGN KEY REFERENCES Countries(CountryId)
);

select * from Employee

ALTER TABLE Employee
alter column ImageData varbinary(max);

-- Insert Sample Employee Data
EXEC InsertEmployee 'John Doe', 'john@example.com', 'Male', 1;
EXEC InsertEmployee 'Jane Smith', 'jane@example.com', 'Female', 2;
EXEC InsertEmployee 'M b', 'mb@mb.com', 'Female', 2;

SET IDENTITY_INSERT employee on

ALTER TABLE Employee
ADD StateId int FOREIGN KEY REFERENCES State(StateId)

select * from Employee
delete from Employee



DECLARE @FilePath NVARCHAR(MAX) = 'C:\Users\Admin\Desktop\Image.jpg'; -- Replace with your file path
DECLARE @Sql NVARCHAR(MAX);

SET @Sql = 'UPDATE Employee ' +
           'SET ImageData = (SELECT BulkColumn FROM OPENROWSET(BULK N''' + @FilePath + ''', SINGLE_BLOB) AS Image) ' +
           'WHERE Id = 1'; -- Specify the employee ID you want to update

-- Print the dynamic SQL for debugging
use EmployeeManagementDB_8jan2024

PRINT @Sql;

select * from Employee
INSERT INTO Employee(Id,Name, Email, Gender, CountryId,StateID,ImageData)
values(1,'m','m','m',1,2,null)

BEGIN TRY
    UPDATE Employee
    SET ImageData = (SELECT BulkColumn FROM OPENROWSET(BULK N'C:\Users\Admin\Desktop\Image.jpg', SINGLE_BLOB) AS varbinary)
    WHERE Id = 1;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Enable Ole Automation Procedures
sp_configure 'show advanced options', 1;
RECONFIGURE;
sp_configure 'Ole Automation Procedures', 1;
RECONFIGURE;

-- Create OLE Automation object
DECLARE @ObjectToken INT;
EXEC sp_OACreate 'ADODB.Stream', @ObjectToken OUTPUT;

-- Initialize the object
EXEC sp_OASetProperty @ObjectToken, 'Type', 1; -- adTypeBinary

-- Fetch image data
DECLARE @ImageData VARBINARY(MAX)
SELECT TOP 1 @ImageData = ImageData
FROM Employee
ORDER BY Id;

-- Load image data into the stream
EXEC sp_OAMethod @ObjectToken, 'Open';
EXEC sp_OAMethod @ObjectToken, 'Write', NULL, @ImageData;
EXEC sp_OAMethod @ObjectToken, 'SaveToFile', NULL, 'd:\hehe.jpg', 2; -- adSaveCreateOverWrite

-- Close the stream and release the object
EXEC sp_OAMethod @ObjectToken, 'Close';
EXEC sp_OADestroy @ObjectToken;
