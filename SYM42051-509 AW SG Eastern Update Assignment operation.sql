USE [Sibanye Gold Limited]
GO
/*------------------------------------------------------------------------
  CONFIGURATION CONTROL																																
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
  Place description here
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
* Modification history
* Version | Date     | By  | Description
* 1.11.01 | dd/mm/yy | PKA | Create
------------------------------------------------------------------------*/
/****************************************************************************************
   Insert Audit entry
****************************************************************************************/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Int, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)
SET @User = 'Annemarie Wessels'
SET @IssueNumber = 'SYM42051'
SET @ScriptName = 'SYM42051-509 AW SG Eastern Update Assignment operation.sql'
SET @Description = 'Insert Interface Assignment operation for SG Eastern'
SET @DataChange = 0 -- 0 = Object 1=Data, 3=Data (priority change), 4=Object (priority change)
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'Assignment operation'
SET @Version = '2.4.3'
SET @SpecialInstructions = ''
SET @LoggedBy = 'Hannes Scheepers'
SET @VerifiedBy = 'Karen Steenkamp'
Exec SYMsp_SymplexityChangeCTRL 0, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy
Begin Try
Begin Transaction
/****************************************************************************************
   Main Code
****************************************************************************************/

--SELECT * FROM [assignment operation]

IF OBJECT_ID('[GFL_Backup].[dbo].[assignment operation NamechangeSG]') IS NOT NULL 
   DROP TABLE [GFL_Backup].[dbo].[assignment operation NamechangeSG]

CREATE TABLE [GFL_Backup].[dbo].[Assignment Operation NamechangeSG]
(
	[code] [nvarchar](50) NULL,
	[name] [nvarchar](50) NULL
)
 
INSERT INTO [GFL_Backup].[dbo].[Assignment Operation NamechangeSG]
        ( [code] ,
          [name]
         
        )
SELECT * 
FROM  [Sibanye Gold Limited].[dbo].[Assignment Operation]


UPDATE [Assignment Operation]
SET [name] = REPLACE([name], 'Southgold', 'SG Eastern Operations')
WHERE [code] = 'Y'

 
/*------------------------------------------------------------------
	Sub section
-------------------------------------------------------------------*/
/*------------------------------------------------------------------
	Log Resource Audit Log
-------------------------------------------------------------------*/

--insert into @tbRT (resourcetag) 
--	select 2130142470

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
