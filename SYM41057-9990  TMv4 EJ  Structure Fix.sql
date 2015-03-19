
USE [GFL_V4]
	
	IF EXISTS (SELECT OBJECT_ID(N'Tempdb..#TempOprNameChange')) AND (SELECT OBJECT_ID(N'Tempdb..#TempOprNameChange')) IS NOT NULL 
	DROP TABLE #TempOprNameChange

	Create Table #TempOprNameChange ([Old Operation] VARCHAR(50), [Old Prefix] VARCHAR(50), [New Operation] VARCHAR(50), [New Prefix] VARCHAR(50), [Start Date] DateTime, [Old Operation Termination Date] DateTime)
	INSERT INTO #TempOprNameChange ([Old Operation], [Old Prefix], [New Operation], [New Prefix], [Start Date], [Old Operation Termination Date]) VALUES ('Southgold', 'SGE', 'Sibanye Gold Eastern Operations', 'SGEO', '01-Mar-2015','28-Feb-2015')

	INSERT INTO [dbo].[STR HRM PM Extra Job Profiles] ([Resource Tag], [Job Title], [Job Profile], [Grade], [Module ID])
	Select  RNew.[Resource Tag], SHPEJP.[Job Title], SHPEJP.[Job Profile], SHPEJP.[Grade], SHPEJP.[Module ID]
	FROM [dbo].[STR HRM PM Extra Job Profiles] SHPEJP
	INNER JOIN [dbo].[Resource Information] ROld
		ON SHPEJP.[resource tag] = ROld.[Resource Tag]
		AND ROld.[Resource Type] = 'Level04'
	INNER JOIN #TempOprNameChange TONCE
		ON TONCE.[Old Operation] = ROld.[resource Reference]
	INNER JOIN dbo.[Resource Information] RNew
		ON TONCE.[New Operation] = RNew.[Resource Reference]
		AND RNew.[Resource Type] = 'Level04'
	LEFT JOIN [dbo].[STR HRM PM Extra Job Profiles] SHPEJP2
		ON RNew.[Resource Tag] = SHPEJP2.[Resource Tag]
		AND SHPEJP2.[Job Title] = SHPEJP.[Job Title]
		AND SHPEJP2.[Job Profile] = SHPEJP.[Job Profile]
	WHERE SHPEJP2.[Resource tag] IS NULL

DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Int, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)
SET @User = 'Etienne Jordaan'
SET @IssueNumber = 'SYM42053'
SET @ScriptName = 'SYM42053-9990 EJ TM V4 Extra Job Profiles for New ops.sql'
SET @Description = 'TM V4 Extra Job Profiles for New ops'
SET @DataChange = 1 -- 0 = Object 1=Data, 3=Data (priority change), 4=Object (priority change)
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'STR HRM PM Extra Job Profiles' 
SET @Version = '5'
SET @SpecialInstructions = ''
SET @LoggedBy = 'Hannes Scheepers'
SET @VerifiedBy = 'Karen Steenkamp'
Set @Identity = -1

Exec SYMsp_SymplexityChangeCTRL 1, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy

GO