USE [Sibanye Gold limited]

/*------------------------------------------------------------------------------------------
	  CONFIGURATION CONTROL																	
	*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-							
																							
	*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-							
	* Modification history																	
	* Version | Date     | By  | Description												
	* 1.11.01 | dd/mm/yy | ??? | Create														
	----------------------------------------------------------------------------------------
	****************************************************************************************
	   Insert Audit entry																	
	****************************************************************************************/
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Bit, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)

	SET @User = 'Etienne Jordaan'
	SET @IssueNumber = 'SYM41057'
	SET @ScriptName = 'SYM41057-102 EJ SGE Structure Fix.sql'                                                
	SET @Description = 'SGE Structure Fix'
	SET @DataChange = 1
	SET @FunctionalArea = 'Screens'
	SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
	SET @ObjectName = 'Organisation Structure'
	SET @Version = '2.4.2'
	SET @SpecialInstructions = ''
	SET @LoggedBy ='Hannes Scheepers'
	SET @VerifiedBy = 'Pieter Kitshoff'

	Exec SYMsp_SymplexityChangeCTRL 0, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy

Begin Try
Begin Transaction
/****************************************************************************************
   Main Code
****************************************************************************************/

	SELECT 'OS to clean up', OS.[Org Unit - Gang], [Designation], MIN([Start Date]), MAX([End date]), Min([Structure Entity]), COUNT(1) AS Duplicates
	FROM [Organisation Structure] OS 
	WHERE OS.[Designation] = ''
	AND OS.[Org Unit - Gang] != ''
	GROUP BY [Org Unit - Gang], [Designation]
	HAVING COUNT(1) > 1
	ORDER BY Duplicates DESC

	--WITH UpdateMe AS (SELECT OS.[Org Unit - Gang], [Designation], MIN([Start Date]) AS MinSD, MAX([End date]) AS MaxSD, Min([Structure Entity]) AS StructEnt
	--				FROM [Organisation Structure] OS
	--				WHERE OS.[Designation] = '' 
	--				AND OS.[Org Unit - Gang] != ''
	--				GROUP BY [Org Unit - Gang], [Designation]
	--				HAVING COUNT(1)>1)
	--UPDATE RI
	--SET [Structure Entity] = UM.[StructEnt]
	--FROM [Organisation Structure] OS
	--JOIN UpdateMe UM
	--	ON UM.[Org Unit - Gang] = OS.[Org Unit - Gang]
	--	AND OS.[Designation] = ''
	--	AND OS.[Org Unit - Gang] != ''
	--	AND OS.[Structure Entity] != UM.[StructEnt]
	--INNER JOIN [dbo].[Resource Instances] RI
	--	ON OS.[Structure Entity] = RI.[Structure Entity]

	WITH UpdateMe AS (SELECT OS.[Org Unit - Gang], [Designation], MIN([Start Date]) AS MinSD, MAX([End date]) AS MaxSD, Min([Structure Entity]) AS Structent
					FROM [Organisation Structure] OS
					WHERE OS.[Designation] = '' 
					AND OS.[Org Unit - Gang] != ''
					GROUP BY [Org Unit - Gang], [Designation]
					HAVING COUNT(1)>1)
	Update OS
	SET [Start Date] = MinSD, [End Date] = MaxSD
	FROM [Organisation Structure] OS
	JOIN UpdateMe UM
		ON UM.[Org Unit - Gang] = OS.[Org Unit - Gang]
		AND OS.[Designation] = ''
		AND OS.[Org Unit - Gang] != ''
		AND OS.[Structure Entity] != UM.Structent

	WITH DELETEME AS (SELECT OS.[Org Unit - Gang], [Designation], MIN([Start Date]) AS MinSD, MAX([End date]) AS MaxSD, Min([Structure Entity]) AS Structent
					FROM	[Organisation Structure] OS
					WHERE	OS.[Designation] = '' 
					AND OS.[Org Unit - Gang] != ''
					GROUP BY
							[Org Unit - Gang], [Designation]
					HAVING	COUNT(1)>1)
	Delete OS
	FROM [Organisation Structure] OS
	JOIN DELETEME DM
		ON DM.[Org Unit - Gang] = OS.[Org Unit - Gang]
		AND OS.[Designation] = ''
		AND OS.[Org Unit - Gang] != ''
		AND OS.[Structure Entity] != DM.Structent

	SELECT 'Dupes Left', OS.[Org Unit - Gang], [Designation], MIN([Start Date]), MAX([End date]), Min([Structure Entity]), COUNT(1) AS Duplicates
	FROM [Organisation Structure] OS
	WHERE OS.[Designation] = ''
	AND OS.[Org Unit - Gang] != ''
	GROUP BY [Org Unit - Gang], [Designation]
	HAVING COUNT(1)>1
	ORDER BY Duplicates DESC

/****************************************************************************************
   If sucessful update Audit entry
****************************************************************************************/
Exec SYMsp_SymplexityChangeCTRL @IDENTITY, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy
COMMIT
End Try
/****************************************************************************************
   Error processing
****************************************************************************************/
Begin Catch
ROLLBACK
Set @sMsg = 'Error '+Convert(varchar(50),ERROR_NUMBER())+' on line '+Convert(varchar(50),ERROR_LINE())+' message text is "'+ERROR_MESSAGE()+'"'
Exec SYMsp_SymplexityChangeCTRL -1, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy, @sMsg
RAISERROR ('%s',16, 1, @sMsg)
RAISERROR ('Transactions on script "%s" have been rolled back.',16, 1, @ScriptName)
End Catch
