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
SET @ScriptName = 'SYM42051-507 AW SG Eastern Update SAP Default Assignment Numbers.sql'
SET @Description = 'Insert SAP Default Assignment Numbers for SG Eastern'
SET @DataChange = 0 -- 0 = Object 1=Data, 3=Data (priority change), 4=Object (priority change)
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'SAP Default Assignment Numbers'
SET @Version = '2.4.2'
SET @SpecialInstructions = ''
SET @LoggedBy = 'Hannes Scheepers'
SET @VerifiedBy = 'Karen Steenkamp'
Exec SYMsp_SymplexityChangeCTRL 0, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy
Begin Try
Begin Transaction
/****************************************************************************************
   Main Code
****************************************************************************************/

--select * FROM [SAP Default Assignment Numbers] WHERE [Operation] like 'GFPS%' OR [Operation Code] = 'GP'

IF OBJECT_ID('[GFL_Backup].[dbo].[SAP Default Assignment Numbers NamechangeSG]') IS NOT NULL 
   DROP TABLE [GFL_Backup].[dbo].[SAP Default Assignment Numbers NamechangeSG]

CREATE TABLE [GFL_Backup].[dbo].[SAP Default Assignment Numbers NamechangeSG]
(
	[Assignment No] [varchar](50) NOT NULL,
	[Operation] [varchar](50) NOT NULL,
	[Operation Code] [varchar](2) NOT NULL,
	[Default SAP Cost No] [varchar](50) NOT NULL
)

INSERT INTO [GFL_Backup].[dbo].[SAP Default Assignment Numbers NamechangeSG]
        ( 
		  [Assignment No] ,
          [Operation] ,
          [Operation Code] ,
          [Default SAP Cost No]
        )
SELECT * 
FROM [Sibanye Gold Limited].[dbo].[SAP Default Assignment Numbers] 


UPDATE [SAP Default Assignment Numbers]
SET [Operation] = 'SG Eastern Operations'
WHERE [Operation] = 'Southgold' AND [operation code] = 'SG'

 
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
