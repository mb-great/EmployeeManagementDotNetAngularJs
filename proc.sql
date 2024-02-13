use EmployeeManagementDB_8jan2024
-- Create a procedure to insert an employee

ALTER PROCEDURE [dbo].[InsertEmployee]
    @Name NVARCHAR(255),
    @Email NVARCHAR(255),
    @Gender NVARCHAR(10),
    @CountryId INT,
    @StateId INT,
    @ImageData VARBINARY(MAX)
    
AS
BEGIN
    DECLARE @Id INT;

    -- Find the maximum Id in the Employee table
    SELECT @Id = ISNULL(MAX(Id), 0) + 1
    FROM Employee;

    -- Insert data into the Employee table with the new Id
    INSERT INTO Employee (Id, Name, Email, Gender, CountryId, StateId, ImageData)
    VALUES (@Id, @Name, @Email, @Gender, @CountryId, @StateId, @ImageData);

    -- Return the newly inserted Id
    SELECT @Id AS NewEmployeeId;
END


-- Create a procedure to get all employees with countries
ALTER PROCEDURE GetAllEmployees
AS
BEGIN
    SELECT E.Id, E.Name, E.Email, E.Gender, E.CountryId, E.StateId,
           C.CountryName, S.StateName, E.ImageData
    FROM Employee E
    INNER JOIN Countries C ON E.CountryId = C.CountryId
    INNER JOIN State S ON E.StateId = S.StateId;
END;

Create PROCEDURE GetImageDataById 
	@Id int
AS
BEGIN
    SELECT E.ImageData
    FROM Employee E
    where e.Id= @Id
END;


-- Create a procedure to get an employee by ID with country details
Alter PROCEDURE GetEmployeeById 
    @EmployeeId INT
AS
BEGIN
    SELECT E.*, C.CountryName
    FROM Employee E
    INNER JOIN Countries C ON E.CountryId = C.CountryId
	INNER JOIN State S ON E.StateId = S.StateId
    WHERE E.Id = @EmployeeId;
END;

go

-- Create a procedure to update an employee
alter PROCEDURE [dbo].[UpdateEmployee]
    @Id INT,
    @Name NVARCHAR(255),
    @Email NVARCHAR(255),
    @Gender NVARCHAR(10),
    @CountryId INT,
    @StateId INT,
    @ImageData VARBINARY(MAX)
AS
BEGIN
    UPDATE Employee
    SET
        Name = @Name,
        Email = @Email,
        Gender = @Gender,
        CountryId = @CountryId,
        StateId = @StateId,
        ImageData = @ImageData
    WHERE Id = @Id;
END
go

-- Create a procedure to delete an employee by ID
CREATE PROCEDURE DeleteEmployee
    @EmployeeId INT
AS
BEGIN
    DELETE FROM Employee
    WHERE Id = @EmployeeId;
END;

go



-- Create a procedure to get all countries for dropdown binding
CREATE PROCEDURE GetAllCountriesForDropdown
AS
BEGIN
    SELECT CountryId, CountryName
    FROM Countries;
END; 
-- Create a procedure to get all States 
CREATE PROCEDURE GetAllStates
AS
BEGIN
    SELECT StateId,StateName,CountryId
    FROM State S
END; 

-- Create a procedure to get all States for dropdown binding
Alter PROCEDURE GetAllStatesForDropdown 
	@CountryID int
AS
BEGIN
    SELECT StateId,StateName,CountryId
    FROM State S
	where CountryId = @CountryID
END; 



exec GetAllEmployees
exec GetAllCountriesForDropdown
exec GetAllStates
exec GetAllStatesForDropdown

delete from employee

EXEC InsertEmployee 'John Doe', 'john@example.com', 'Male', 1,1;
EXEC InsertEmployee 'Jane Smith', 'jane@example.com', 'Female', 2,4;
EXEC InsertEmployee 'M b', 'mb@mb.com', 'Female', 2,6;



alter table employee alter column ImageData VARBINARY(MAX)