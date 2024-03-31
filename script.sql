	USE [EmployeeManagementDB_v1_0]
	GO
	/****** Object:  Table [dbo].[Countries]    Script Date: 31-03-2024 04:04:40 PM ******/
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE TABLE [dbo].[Countries](
		[CountryId] [int] NOT NULL,
		[CountryName] [nvarchar](100) NULL,
	PRIMARY KEY CLUSTERED 
	(
		[CountryId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	GO
	/****** Object:  Table [dbo].[Employee]    Script Date: 31-03-2024 04:04:40 PM ******/
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE TABLE [dbo].[Employee](
		[Id] [int] NOT NULL,
		[Name] [nvarchar](100) NULL,
		[Email] [nvarchar](100) NULL,
		[Gender] [nvarchar](10) NULL,
		[CountryId] [int] NULL,
		[ImageData] [varbinary](max) NULL,
		[StateId] [int] NULL,
	PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	GO
	/****** Object:  Table [dbo].[State]    Script Date: 31-03-2024 04:04:40 PM ******/
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE TABLE [dbo].[State](
		[StateId] [int] NOT NULL,
		[StateName] [nvarchar](100) NULL,
		[CountryId] [int] NULL,
	PRIMARY KEY CLUSTERED 
	(
		[StateId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	GO
	ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([CountryId])
	REFERENCES [dbo].[Countries] ([CountryId])
	GO
	ALTER TABLE [dbo].[Employee]  WITH CHECK ADD FOREIGN KEY([StateId])
	REFERENCES [dbo].[State] ([StateId])
	GO
	ALTER TABLE [dbo].[State]  WITH CHECK ADD FOREIGN KEY([CountryId])
	REFERENCES [dbo].[Countries] ([CountryId])
	GO
	/****** Object:  StoredProcedure [dbo].[DeleteEmployee]    Script Date: 31-03-2024 04:04:40 PM ******/
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	-- Create a procedure to delete an employee by ID
	CREATE PROCEDURE [dbo].[DeleteEmployee]
		@EmployeeId INT
	AS
	BEGIN
		DELETE FROM Employee
		WHERE Id = @EmployeeId;
	END;

	GO
	/****** Object:  StoredProcedure [dbo].[GetAllCountriesForDropdown]    Script Date: 31-03-2024 04:04:40 PM ******/
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE PROCEDURE [dbo].[GetAllCountriesForDropdown]
	AS
	BEGIN
		SELECT CountryId, CountryName
		FROM Countries;
	END; 
	GO
	/****** Object:  StoredProcedure [dbo].[GetAllEmployees]    Script Date: 31-03-2024 04:04:40 PM ******/
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	create PROCEDURE [dbo].[GetAllEmployees]
	AS
	BEGIN
		SELECT E.Id, E.Name, E.Email, E.Gender, E.CountryId, E.StateId,
			   C.CountryName, S.StateName, E.ImageData
		FROM Employee E
		INNER JOIN Countries C ON E.CountryId = C.CountryId
		INNER JOIN State S ON E.StateId = S.StateId;
	END;
	GO
	/****** Object:  StoredProcedure [dbo].[GetAllStates]    Script Date: 31-03-2024 04:04:40 PM ******/
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE PROCEDURE [dbo].[GetAllStates]
	AS
	BEGIN
		SELECT StateId,StateName,CountryId
		FROM State S
	END; 
	GO
	/****** Object:  StoredProcedure [dbo].[GetAllStatesForDropdown]    Script Date: 31-03-2024 04:04:40 PM ******/
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE PROCEDURE [dbo].[GetAllStatesForDropdown] 
		@CountryID int
	AS
	BEGIN
		SELECT StateId,StateName,CountryId
		FROM State S
		where CountryId = @CountryID
	END; 
	GO
	/****** Object:  StoredProcedure [dbo].[GetEmployeeById]    Script Date: 31-03-2024 04:04:40 PM ******/
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	create PROCEDURE [dbo].[GetEmployeeById] 
		@EmployeeId INT
	AS
	BEGIN
		SELECT E.*, C.CountryName
		FROM Employee E
		INNER JOIN Countries C ON E.CountryId = C.CountryId
		INNER JOIN State S ON E.StateId = S.StateId
		WHERE E.Id = @EmployeeId;
	END;
	GO
	/****** Object:  StoredProcedure [dbo].[GetImageDataById]    Script Date: 31-03-2024 04:04:40 PM ******/
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	Create PROCEDURE [dbo].[GetImageDataById] 
		@Id int
	AS
	BEGIN
		SELECT E.ImageData
		FROM Employee E
		where e.Id= @Id
	END;
	GO
	/****** Object:  StoredProcedure [dbo].[InsertEmployee]    Script Date: 31-03-2024 04:04:40 PM ******/
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE PROCEDURE [dbo].[InsertEmployee]
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

	END
	GO
	/****** Object:  StoredProcedure [dbo].[UpdateEmployee]    Script Date: 31-03-2024 04:04:40 PM ******/
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	create PROCEDURE [dbo].[UpdateEmployee]
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
	GO
