USE [Sibanye Gold Limited]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																				CONFIGURATION CONTROL																																
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--   Place description here
--------------------------------------------------------------
--   * Modification history
--   * Version | Date     | By  | Description
--   * 1.11.01 | dd/mm/yy | PKA | Create
--------------------------------------------------------------
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																					  Main Code
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @SQL NVARCHAR(2000)='';

SET @SQL = 'SELECT * INTO [GFL_Backup].dbo.[Emp Work History_SYM41057_'+REPLACE(CONVERT(NVARCHAR(12), CONVERT(DATE, GETDATE()),106), ' ','-')+ '] FROM [Emp Work History] WITH (NoLock)'

EXEC sp_executesql @SQL

SET @SQL = 'SELECT * INTO [GFL_Backup].dbo.[Organisation Structure_SYM41057_'+REPLACE(CONVERT(NVARCHAR(12), CONVERT(DATE, GETDATE()),106), ' ','-')+ '] FROM [Organisation Structure] WITH (NoLock)'

EXEC sp_executesql @SQL


GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Int, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)
SET @User = 'Jaco J v Vuuren'
SET @IssueNumber = 'SYM41057'
SET @ScriptName = 'SYM41057-002 JvV Backup Emp Work History.sql'
SET @Description = 'Backup Emp Work History'
SET @DataChange = 1 -- 0 = Object 1=Data, 3=Data (priority change), 4=Object (priority change)
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'FUNCTION' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'Dates' 
SET @Version = '2.4.2'
SET @SpecialInstructions = ''
SET @LoggedBy = 'Jaco J v Vuuren'
SET @VerifiedBy = 'Etienne Jordaan'
Set @Identity = -1

Exec SYMsp_SymplexityChangeCTRL 1, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy

GO
