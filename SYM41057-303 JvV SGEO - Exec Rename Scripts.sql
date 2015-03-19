USE [Sibanye Gold Limited]

SET NOCOUNT ON;

DECLARE @OldName NVARCHAR(128),
		@NewName NVARCHAR(128);


SELECT TOP 1 @OldName = [OldName], @NewName = [NewName] FROM [GFL_Backup].dbo.DB_Search

DECLARE @SQL1 VARCHAR(MAX),
		@SQL2 VARCHAR(MAX),
		@SQL3 VARCHAR(MAX),
		@TableName NVARCHAR(128),
		@Rows INT;

DECLARE @ID INT = 0,
		@MAXID INT;
SELECT @MAXID = MAX([ID]) FROM GFL_Backup.dbo.DB_Search WHERE	[DataFound] = 1

WHILE (@ID IS NOT NULL AND @MAXID IS NOT NULL)
BEGIN 

	SELECT TOP 1 @SQL1 = ISNULL([SQLU1],''), @SQL2 = ISNULL([SQLU2],''), @SQL3 = ISNULL([SQLU3], ''), @TableName = [TableName]
	FROM GFL_Backup.dbo.[DB_Search] WHERE	[DataFound] = 1 AND [Errors] IS NULL ORDER BY [TableName] DESC
	IF @@ROWCOUNT = 0 
	BEGIN
		UPDATE [GFL_Backup].dbo.[DB_Search] SET [Errors] = NULL WHERE	[DataFound] IN (1,2) AND [Errors] = 'Run Last'  
		SELECT TOP 1 @SQL1 = ISNULL([SQLU1],''), @SQL2 = ISNULL([SQLU2],''), @SQL3 = ISNULL([SQLU3], ''), @TableName = [TableName]
		FROM GFL_Backup.dbo.[DB_Search] WHERE	[DataFound] IN (1,2) AND [Errors] IS NULL ORDER BY [TableName] --DESC
		IF @@ROWCOUNT = 0 BREAK
	END

	SET @SQL3 = @SQL3 +CHAR(13)+'UPDATE	GFL_Backup.dbo.[DB_Search] SET [Errors] = ''Done:'' +CONVERT(VARCHAR(10), @@ROWCOUNT) WHERE	[TableName] = '''+@TableName+''''

	PRINT @SQL1+ @SQL2+ @SQL3

	BEGIN TRY
		EXEC (@SQL1+@SQL2+@SQL3)
		UPDATE	GFL_Backup.dbo.[DB_Search] SET [Errors] = 'Done: '+CONVERT(VARCHAR(10), @@ROWCOUNT) WHERE	[TableName] = @TableName
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
		UPDATE	GFL_Backup.dbo.[DB_Search] SET [Errors] = ERROR_MESSAGE() WHERE	[TableName] = @TableName
	END CATCH
END



GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Int, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)
SET @User = 'Jaco J v Vuuren'
SET @IssueNumber = 'SYM41057'
SET @ScriptName = 'SYM41057-303 JvV Run - Rename Southgold to Sibanye Gold Eastern Operations.sql'
SET @Description = 'Generate - Rename Southgold to Sibanye Gold Eastern Operations'
SET @DataChange = 1 -- 0 = Object 1=Data, 3=Data (priority change), 4=Object (priority change)
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'Template Master' 
SET @Version = '2.4.2'
SET @SpecialInstructions = ''
SET @LoggedBy = 'Hannes Scheepers'
SET @VerifiedBy = 'Peet Schultz'
Set @Identity = -1

Exec SYMsp_SymplexityChangeCTRL 1, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy

GO
