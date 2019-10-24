USE Cars
GO

DECLARE @ListOfStudents Table (
	[rowNumber] int NOT NULL identity(1,1), 
	[LastName] varchar(100) NULL, 
	[FirstName] varchar(100) NULL,
	[Username] varchar(100) NULL, 
	[UserPassword] varchar(100) NULL
)

--Inserting data into the table variable
INSERT INTO @ListOfStudents (LastName, FirstName, Username, UserPassword) SELECT LastName, FirstName, UserName, [Password] FROM Students

--Controlled starting point
IF EXISTS (SELECT * FROM @listOfStudents)

	--Driving loop
	DECLARE @maximumRows int = (select count(*) from @ListOfStudents)
	DECLARE @currentRow int = 1

	WHILE @currentRow <= @maximumRows
		BEGIN 
			set @currentRow=@currentRow

			--Creating Databases
			DECLARE @dbFilePath nvarchar(2000) DECLARE @dbLogPath nvarchar(2000)
			DECLARE @createFolderXP nvarchar(2000) DECLARE @domainLogin nvarchar(30) 
			DECLARE @prefix nvarchar(200)
			DECLARE @dbName nvarchar(1000)

			DECLARE @logicalDataName nvarchar(600) DECLARE @logicalLogName nvarchar(600) DECLARE @dataFileName nvarchar(600) DECLARE @logFileName nvarchar(600)

			DECLARE @dataSize nvarchar(500) 
			DECLARE @dataMaxSize nvarchar(500) DECLARE @dataFileGrowth nvarchar(500) DECLARE @logSize nvarchar(500) 
			DECLARE @logMaxSize nvarchar(500) DECLARE @logFileGrowth nvarchar(500)
			DECLARE @exeTemp nvarchar(4000) DECLARE @exeTemps nvarchar(4000)

			BEGIN
				SET @DBName=(SELECT Username from @ListOfStudents where rowNumber=@currentRow)
				SET @dbFilePath=N'/var/opt/mssql/data/'
				SET @dbLogPath=N'/var/opt/mssql/data/'
				SET @dataSize=N'8192KB'
				SET @DataMaxSize=N'200MB'
				SET @DataFileGrowth=N'65536KB'
				SET @LogSize=N'8192KB'
				SET @LogMaxSize=N'100MB'
				SET @LogFileGrowth=N'65536KB'

				SET @LogicalDataName=@DBName + '_dat'
				SET @DataFileName= @dbFilePath + @DBName + '.mdf'
				SET @LogicalLogName=@DBName + '_log'
				SET @LogFileName= @dbLogPath + @DBName + '.ldf'

				SET @exeTemp = 'CREATE DATABASE ' + @DBName + ' ON ('
				+ 'NAME = [' + @LogicalDataName + '], '
				+ 'FILENAME = [' + @DataFileName + '], '
				+ 'SIZE = ' + @DataSize + ', '
				+ 'MAXSIZE = ' + @DataMaxSize + ', '
				+ 'FILEGROWTH = ' + @DataFileGrowth + ') '
				+ 'LOG ON ('
				+ 'NAME = [' + @LogicalLogName + '], '
				+ 'FILENAME = [' + @LogFileName + '], '
				+ 'SIZE = ' + @LogSize + ', '
				+ 'MAXSIZE = ' + @LogMaxSize + ', '
				+ 'FILEGROWTH = ' + @LogFileGrowth + ') '
				PRINT(@exeTemp)
				EXEC (@exeTemp)

				--Creating logins
				DECLARE @ExecTemp nvarchar(1000)
				DECLARE @_Login nvarchar(100), @_Password nvarchar(100), @_DefaultDatabase nvarchar(100)
					BEGIN
						SET @_Login=(SELECT Username from @ListOfStudents where rowNumber=@currentRow)
						set @_Password=(select UserPassword from @ListOfStudents where rowNumber=@currentRow)
						set @_DefaultDatabase=(SELECT DB_NAME())
						SET @ExecTemp = 'CREATE LOGIN ' + @_Login + ' WITH PASSWORD = ''' + @_Password + ''', DEFAULT_DATABASE = ' + @_DefaultDatabase
						PRINT (@ExecTemp)
						EXEC (@ExecTemp)
					END

				--Creating database users
				SET @_Login=(SELECT Username from @ListOfStudents where rowNumber=@currentRow)
				SET @exeTemps='USE ' + @DBName + ' CREATE USER [' + @_Login + '] FOR LOGIN [' + @_Login + ']'
				print(@exeTemps)
				EXEC (@exeTemps)
			END


		SET @currentRow += 1;
		
		END
