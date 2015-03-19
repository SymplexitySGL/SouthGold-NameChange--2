USE [Sibanye Gold Limited]

SET NOCOUNT ON;

DECLARE @OldName NVARCHAR(50),
		@NewName NVARCHAR(50),
		@NewShortName NVARCHAR(50);

SELECT TOP 1 @OldName = [OldName], @NewName = [NewName] FROM [GFL_Backup].dbo.[DB_Search]

DECLARE @ID INT = 0,
		@RunID INT = 0,
		@TableName NVARCHAR(128),
		@SQL NVARCHAR(MAX),
		@SQLU VARCHAR(MAX),
		@Criteria NVARCHAR(MAX),
		@UPDATESet NVARCHAR(MAX),
		@Message NVARCHAR(500),
		@Duration DATETIME,
		@EnableTrigger NVARCHAR(MAX),
		@DisableTrigger NVARCHAR(MAX),
		@datafound INT,
		@SchemaName	NVARCHAR(20);

WHILE (@ID IS NOT NULL)
BEGIN

	SELECT	TOP 1 @RunID = MAX([ID]),
			@TableName = [TableName],
			@datafound = [DataFound],
			@SchemaName = [SchemaName]
	FROM	 GFL_Backup.dbo.DB_Search
	WHERE	[ID] > @ID
		AND ISNULL([datafound], 2) = 2-- IS NULL --<---
	GROUP BY [TableName], [DataFound], [SchemaName]
	ORDER BY  MAX([ID]) ASC

	IF @RunID = @ID-- OR @ID > 30
		--SET @ID = NULL
		BREAK      
	ELSE
	BEGIN  
		SET @ID = @RunID;
		SET @Message = '['+@TableName+']'
		RAISERROR (@Message, 0,1) WITH NOWAIT;

		SELECT	@Criteria = COALESCE(@Criteria + ' ', '') + 'OR S.['+[ColumnName]+'] LIKE ''%'+@OldName+'%'''
		FROM	GFL_Backup.dbo.db_search WHERE	[TableName] = @TableName

		SELECT	@UPDATESet = COALESCE(@UPDATESet + ' ', '') + ', S.['+[ColumnName]+'] = REPLACE(CONVERT(NVARCHAR(MAX), S.['+[ColumnName]+']), '''+@OldName+''', '''+CASE [UseLongName] WHEN 1 THEN @NewName ELSE @NewName END+''')'
		FROM	GFL_Backup.dbo.db_search WHERE	[TableName] = @TableName

		--DISABLE TRIGGER 
		WITH TRG AS (SELECT DISTINCT ST.name FROM GFL_Backup.dbo.db_search DBS JOIN sys.sysobjects SO ON DBS.TableName = SO.name AND SO.type = 'u' 
					JOIN sys.sysobjects ST  ON ST.parent_obj = SO.id AND ST.type = 'tr' WHERE	[TableName] = @tablename AND DBS.[HasTriggers] = 1 AND DBS.[DisableTriggers] = 1)

		SELECT	@EnableTrigger = COALESCE(@EnableTrigger, '') + 'ENABLE TRIGGER ['+TRG.[name] +'] ON ['+@TableName+']'+CHAR(13),
				@DisableTrigger = COALESCE(@DisableTrigger, '')+ 'DISABLE TRIGGER ['+ TRG.[name] +'] ON ['+@TableName+']'+CHAR(13)
		FROM TRG


		SET @Criteria = REPLACE(@Criteria, '(OR S.[', '(S.[')
		SET @UPDATESet = REPLACE(@UPDATESet, '(, S.[', '(S.[')


		--Main IF EXISTS() Dynamic SQL		
		SET @SQL = 'IF EXISTS(SELECT 1 FROM ['+@SchemaName+'].['+@TableName+'] S WITH (NoLock) (JOIN) WHERE (WHERE) AND (' + @Criteria + '))'+CHAR(13)+
					'	UPDATE GFL_Backup.dbo.DB_Search SET [DataFound] = 1 WHERE [TableName] = '''+@TableName+''''+CHAR(13)+
					'ELSE'+CHAR(13)+
					'	UPDATE GFL_Backup.dbo.DB_Search SET [DataFound] = 0 WHERE [TableName] = '''+@TableName+''''

		--Main UPDATE Dynamic SQL

		SET @SQLU = 'UPDATE	S SET ('+ @UPDATESet +' FROM  ['+@SchemaName+'].['+@TableName+'] S (JOIN) WHERE (WHERE) AND (' + @Criteria + ');'
	
		SET @SQL = REPLACE(@SQL, '(OR S.[', '(S.[')	
		SET @SQLU = REPLACE(@SQLU, '(, S.[', 'S.[')
		SET @SQLU = REPLACE(@SQLU, '(OR S.[', '(S.[')	
		IF LEN(@EnableTrigger) > 0 
		BEGIN
			SET @SQLU = @DisableTrigger + @SQLU + CHAR(13) +@EnableTrigger		--Disble Trigger Code - Syntax exception.
			SET @DisableTrigger = NULL
			SET @EnableTrigger = NULL
		END

		SET @Criteria = NULL;
		SET @UPDATESet = NULL;

		--Inject ResourceTag Filter.
		IF EXISTS(SELECT 1 FROM sysobjects SO JOIN syscolumns SC ON SO.id = SC.id AND SO.type = 'u' AND SC.name LIKE '%resource%tag%' AND SO.name = @TableName JOIN GFL_Backup.dbo.[DB_Search_ResourceTags] RT ON RT.[TableName] = SO.Name)
		BEGIN
			SELECT @Criteria = COALESCE(@Criteria + ', ', '') + CONVERT(NVARCHAR(50), [Resource Tag])
			FROM	GFL_Backup.dbo.DB_Search_ResourceTags WHERE	[Resource Tag] IS NOT NULL
			IF @@ROWCOUNT = 0 RAISERROR('No Resource Tags Specified - Specify Resource Tags or remove resource tag specific tables from list.',15,1) WITH nowait;

			SELECT	@SQL = REPLACE(@SQL, '(WHERE) AND ', ''),
					@SQLU = REPLACE(@SQLU, '(WHERE) AND ', '')-- S.['+ISNULL([RTFieldName], 'Resource Tag')+'] IN ('+@Criteria+') AND ')
			FROM GFL_Backup.dbo.[DB_Search_ResourceTags] WHERE	[TableName] = @TableName

			-- Inject Join Code --
			SELECT	@SQL = REPLACE(@SQL, '(JOIN)', ' JOIN GFL_Backup.dbo.[DB_Search_ResourceTags] DBSR ON DBSR.[Resource Tag] = S.['+ISNULL([RTFieldName], 'Resource Tag')+'] '),
					@SQLU = REPLACE(@SQLU, '(JOIN)', ' JOIN GFL_Backup.dbo.[DB_Search_ResourceTags] DBSR ON DBSR.[Resource Tag] = S.['+ISNULL([RTFieldName], 'Resource Tag')+'] ')
			FROM GFL_Backup.dbo.[DB_Search_ResourceTags] WHERE	[TableName] = @TableName

		END	
		ELSE
		BEGIN      
			SELECT	@SQL = REPLACE(@SQL, '(WHERE) AND ', ''),
					@SQLU = REPLACE(@SQLU, '(WHERE) AND ', ''),
					@SQL = REPLACE(@SQL, '(JOIN)', ''),
					@SQLU = REPLACE(@SQLU, '(JOIN)', '');
		END

		SET @Criteria = NULL;
		BEGIN TRY
			SET @Duration = GETDATE()
			IF ISNULL(@datafound, 0) != 2 
				EXEC sp_executesql @SQL;

			UPDATE	GFL_Backup.dbo.[DB_Search]  SET [Duration] = DATEDIFF(second, @Duration, GETDATE()), [SQLS] = @SQL, [SQLU1] = LEFT(@SQLU, 8000), [SQLU2] = SUBSTRING(@SQLU, 8001, 8000), [SQLU3] = SUBSTRING(@SQLU, 16001, 8000) WHERE	[TableName] = @TableName

			SELECT @Message = CASE ISNULL(@datafound, 0) WHEN 2 THEN 'No Check - Table is known to contain relevant data.' ELSE 'Duration: ' + CONVERT(NVARCHAR(50), DATEDIFF(second, @Duration, GETDATE())) + ' Seconds' END + CHAR(13);
			PRINT @Message
			--RAISERROR(@Message, 1, 0) WITH NOWAIT;
		END TRY
		BEGIN CATCH
			SET @Message = ERROR_MESSAGE()
			UPDATE	GFL_Backup.dbo.db_Search SET [Errors] = @Message, [DataFound] = 0, [Duration] = DATEDIFF(second, @Duration, GETDATE()), [SQLS] = @SQL WHERE	[tableName] = @TableName
			
			SET @Message += '	[' + @TableName+']'
			RAISERROR('------------------------------', 1, 0) WITH NOWAIT;      
			RAISERROR(@Message, 1, 0) WITH NOWAIT;
			RAISERROR('------------------------------', 1, 0) WITH NOWAIT;      
		END CATCH
	END
END


GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Int, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)
SET @User = 'Jaco J v Vuuren'
SET @IssueNumber = 'SYM41057'
SET @ScriptName = 'SYM41057-302 JvV SGEO - Generate Rename Scripts.sql'
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
