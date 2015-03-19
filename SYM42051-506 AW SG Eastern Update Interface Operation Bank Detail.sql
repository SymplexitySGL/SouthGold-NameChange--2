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
SET @ScriptName = 'SYM42051-506 AW SG Eastern Update Interface Operation Bank Detail.sql'
SET @Description = 'Insert Interface Operation bank detail for SG Eastern'
SET @DataChange = 0 -- 0 = Object 1=Data, 3=Data (priority change), 4=Object (priority change)
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'Interface Operation Bank Detail'
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

--SELECT * FROM [Interface Operation Bank Detail] WHERE [description] LIKE 'Salaries SG 1%' 
--SELECT * FROM [Interface Operation Bank Detail] WHERE [operation code] IN ('PC','PF','PR','PW')
--SELECT * FROM [dbo].[Interface Operation Code Map] WHERE [operation] LIKE 'SGS%'


IF OBJECT_ID('[GFL_Backup].[dbo].[Interface Operation Bank Detail NamechangeSG]') IS NOT NULL 
   DROP TABLE [GFL_Backup].[dbo].[Interface Operation Bank Detail NamechangeSG]

  CREATE TABLE [GFL_Backup].[dbo].[Interface Operation Bank Detail NamechangeSG]
  (
	[Operation Code] [nvarchar](50) NOT NULL,
	[Account Reference] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[Bank Name] [nvarchar](50) NULL,
	[Bank Code] [nvarchar](50) NULL,
	[Branch Name] [nvarchar](50) NULL,
	[Branch Code] [nvarchar](50) NULL,
	[Account Number] [nvarchar](50) NULL,
	[Account Name] [nvarchar](50) NULL,
	[Account Type] [nvarchar](50) NULL,
	[Account Description] [nvarchar](50) NULL,
	[Account Alias] [nvarchar](50) NULL,
)

INSERT INTO [GFL_Backup].[dbo].[Interface Operation Bank Detail NamechangeSG]
(
	[Operation Code],
	[Account Reference],
	[Description],
	[Bank Name],
	[Bank Code],
	[Branch Name],
	[Branch Code],
	[Account Number],
	[Account Name],
	[Account Type],
	[Account Description],
	[Account Alias]
)

SELECT * FROM [Sibanye Gold Limited].[dbo].[Interface Operation Bank Detail]

--SELECT * FROM [Interface Operation Bank Detail] WHERE [description] LIKE 'GFPS%' 
--SELECT * FROM [Interface Operation Bank Detail] WHERE [operation code] IN ('PC','PF','PR','PW')
--SELECT * FROM [dbo].[Interface Operation Code Map] WHERE [operation] LIKE 'SGS%'
--DELETE FROM [Interface Operation Bank Detail Map] WHERE [Operation Code] = 'GP'

UPDATE [Sibanye Gold Limited].[dbo].[Interface Operation Bank Detail]    
SET [Account Description] = Replace([Account Description], 'Southgold', 'SG Eastern Operations')
WHERE [Operation Code] = 'SG'
			

 
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
