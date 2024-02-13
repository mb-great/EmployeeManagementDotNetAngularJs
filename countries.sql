use EmployeeManagementDB_8jan2024

CREATE TABLE Countries (
    CountryId INT PRIMARY KEY,
    CountryName NVARCHAR(100)
);

-- Insert Sample Data (Feel free to add more countries)
INSERT INTO Countries (CountryId, CountryName) VALUES
(1, 'India'),
(2, 'USA'),
(3, 'Nepal');
