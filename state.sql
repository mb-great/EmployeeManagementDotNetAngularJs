use EmployeeManagementDB_8jan2024

CREATE TABLE State (
    StateId INT PRIMARY KEY,
    StateName NVARCHAR(100),
	CountryId INT FOREIGN KEY REFERENCES Countries(CountryId)
);

INSERT INTO State (StateId, StateName) VALUES
(1, 'India'),
(2, 'USA'),
(3, 'Nepal');

INSERT INTO State (StateId, StateName, CountryId) VALUES
(1, 'Maharashtra', 1),
(2, 'Uttar Pradesh', 1),
(3, 'California', 2),
(4, 'Texas', 2),
(5, 'New York', 2),
(6, 'Florida', 2),
(7, 'Bagmati', 3),
(8, 'Gandaki', 3),
(9, 'Lumbini', 3);
