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
SET @ScriptName = 'SYM42051-505 AW SG Eastern Update Interface Operation.sql'
SET @Description = 'Insert Interface Operation for SG Eastern'
SET @DataChange = 0 -- 0 = Object 1=Data, 3=Data (priority change), 4=Object (priority change)
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'Interface Operation'
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

--select * from [Interface Operation] Where [Description] Like 'SouthGold%'
--select * from [interface Operation] where [description] like 'SG Eastern Operations%'

IF OBJECT_ID('[GFL_Backup].[dbo].[Interface Operation NamechangeSG]') IS NOT NULL 
   DROP TABLE [GFL_Backup].[dbo].[Interface Operation NamechangeSG]

   CREATE TABLE [GFL_Backup].[dbo].[Interface Operation NamechangeSG]
   (
	[Operation Code] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[Operation Identity] [nvarchar](50) NULL,
	[Operation Reference] [nvarchar](50) NULL,
	[COM Code] [nvarchar](50) NULL,
	[Trading Name] [nvarchar](99) NULL,
	[PAYE Number] [nvarchar](50) NULL,
	[UIF Number] [nvarchar](50) NULL,
	[Physical Address Line 1] [nvarchar](50) NULL,
	[Physical Address Line 2] [nvarchar](50) NULL,
	[Physical Address Line 3] [nvarchar](50) NULL,
	[Physical Address Line 4] [nvarchar](50) NULL,
	[Physical Address Postal Code] [nvarchar](50) NULL,
	[Postal Address Line 1] [nvarchar](50) NULL,
	[Postal Address Line 2] [nvarchar](50) NULL,
	[Postal Address Line 3] [nvarchar](50) NULL,
	[Postal Address Line 4] [nvarchar](50) NULL,
	[Postal Address Postal Code] [nvarchar](50) NULL,
	[Diplomatic Exemption] [nvarchar](50) NULL,
	[Edit Bank Detail] [nvarchar](1) NOT NULL,
	[Active] [nvarchar](1) NOT NULL
	)

INSERT INTO [GFL_Backup].[dbo].[Interface Operation NamechangeSG]
        ( [Operation Code] ,
          [Description] ,
          [Operation Identity] ,
          [Operation Reference] ,
          [COM Code] ,
          [Trading Name] ,
          [PAYE Number] ,
          [UIF Number] ,
          [Physical Address Line 1] ,
          [Physical Address Line 2] ,
          [Physical Address Line 3] ,
          [Physical Address Line 4] ,
          [Physical Address Postal Code] ,
          [Postal Address Line 1] ,
          [Postal Address Line 2] ,
          [Postal Address Line 3] ,
          [Postal Address Line 4] ,
          [Postal Address Postal Code] ,
          [Diplomatic Exemption] ,
          [Edit Bank Detail] ,
          [Active]
        )
SELECT * 
FROM  [sibanye Gold Limited].[dbo].[Interface Operation]




UPDATE [Sibanye Gold Limited].[dbo].[Interface Operation]    
SET  [Description] = Replace([Description], 'SouthGold', 'SG Eastern Operations'), [Operation Reference] = Replace([Operation Reference], 'SouthGold', 'SG Eastern Operations')
WHERE [Description] Like 'SouthGold%'
			

 
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
