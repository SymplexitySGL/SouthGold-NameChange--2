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
SET @ScriptName = 'SYM42051-510 AW SGA Update Interface GFL Assignment Numbers.sql'
SET @Description = 'Update Interface GFL Assignment Numbers Namechange for SGA'
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

--SELECT * FROM [Interface GFL Assignment Numbers] order by [operation] where [operation] = 'southgold'

IF OBJECT_ID('[GFL_Backup].[dbo].[Interface GFL Assignment Numbers NamechangeSG]') IS NOT NULL 
   DROP TABLE [GFL_Backup].[dbo].[Interface GFL Assignment Numbers NamechangeSG]

CREATE TABLE [GFL_Backup].[dbo].[Interface GFL Assignment Numbers NamechangeSG](
	[Activity ID] [int] NOT NULL,
	[Work Area ID] [int] NOT NULL,
	[Designation ID] [int] NOT NULL,
	[Operation Code] [nvarchar](50) NOT NULL,
	[Assignment Number] [int] NULL,
	[Activity Name] [nvarchar](50) NULL,
	[Work Area Name] [nvarchar](50) NULL,
	[Designation Name] [nvarchar](50) NULL,
	[Operation] [nvarchar](50) NULL,
	[Start Date] [datetime] NOT NULL,
	[End Date] [datetime] NULL,
	[New Or Updated] [nvarchar](1) NULL)
 
INSERT INTO [GFL_Backup].[dbo].[Interface GFL Assignment Numbers NamechangeSG]
        ( [Activity ID] ,
          [Work Area ID] ,
          [Designation ID] ,
          [Operation Code] ,
          [Assignment Number] ,
          [Activity Name] ,
          [Work Area Name] ,
          [Designation Name] ,
          [Operation] ,
          [Start Date] ,
          [End Date] ,
          [New Or Updated]
        )
SELECT * 
FROM [Sibanye Gold Limited].[dbo].[Interface GFL Assignment Numbers] -- WHERE [operation] = 'Driefontein'


INSERT INTO [dbo].[Interface GFL Assignment Numbers]
        ( [Activity ID] ,
          [Work Area ID] ,
          [Designation ID] ,
          [Operation Code] ,
          [Assignment Number] ,
          [Activity Name] ,
          [Work Area Name] ,
          [Designation Name] ,
          [Operation] ,
          [Start Date] ,
          [End Date] ,
          [New Or Updated]
        )
SELECT [Activity ID] ,
          [Work Area ID] ,
          [Designation ID] ,
          REPLACE([Operation Code],'DC', 'SG') ,
          [Assignment Number] ,
          [Activity Name] ,
          [Work Area Name] ,
          [Designation Name] ,
          REPLACE([Operation] , 'Driefontein','SG Eastern Operations'), 
          [Start Date] ,
          [End Date] ,
          [New Or Updated]
FROM [Sibanye Gold Limited].[dbo].[Interface GFL Assignment Numbers]  WHERE [operation] = 'Driefontein'


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
