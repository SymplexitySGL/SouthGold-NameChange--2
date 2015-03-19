USE [Sibanye Gold Limited]
/*------------------------------------------------------------------------
  CONFIGURATION CONTROL																																
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
* Modification history
* Version | Date     | By  | Description
* 1.11.01 | dd/mm/yy | ??? | Create
------------------------------------------------------------------------*/
/****************************************************************************************
   Insert Audit entry
****************************************************************************************/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Bit, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)
SET @User = 'Karen Steenkamp'
SET @IssueNumber = 'SYM41057'
SET @ScriptName = 'SYM41057-400 KS SGEO Update Opr cessation days.sql'                                                
SET @Description = 'SGEO Update Opr cessation days'
SET @DataChange = 1
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'Opr cessation days'
SET @Version = '2.4.2'
SET @SpecialInstructions = ''
SET @LoggedBy ='Connie Shaw'
SET @VerifiedBy = 'Etienne Jordaan'
Exec SYMsp_SymplexityChangeCTRL 0, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy
Begin Try
Begin Transaction
/****************************************************************************************
   Main Code
****************************************************************************************/
	USE GFL_Backup
	IF EXISTS (SELECT OBJECT_ID(N'Temp Opr Name Change KS')) AND (SELECT OBJECT_ID(N'Temp Opr Name Change KS')) IS NOT NULL 
	DROP TABLE [Temp Opr Name Change KS]

	IF NOT EXISTS (SELECT 1 FROM sys.objects SO WHERE object_id = OBJECT_ID(N'[dbo].[Temp Opr Name Change KS]') AND SO.type in (N'U'))
    BEGIN
		Create Table [Temp Opr Name Change KS] ([Old Operation] VARCHAR(50), [Old Prefix] VARCHAR(50), [New Operation] VARCHAR(50), [New Prefix] VARCHAR(50), [Start Date] DateTime, [Old Operation Termination Date] DateTime)
		INSERT INTO [Temp Opr Name Change KS] ([Old Operation], [Old Prefix], [New Operation], [New Prefix], [Start Date], [Old Operation Termination Date]) VALUES ('SGSS', 'SGSS', 'SG Eastern Operations', 'SGEO', '01-Mar-2015','28-Feb-2015')
	END			
																																
	USE [Sibanye Gold Limited]
--select * from [opr cessation days]

--select * from [resource] where [resource type] = 'operation'

INSERT INTO [dbo].[Opr Cessation Days]
           ([Operation Name]
           ,[Outcome]
           ,[Operation Expiry Period (Days)]
           ,[Resource Tag]
           ,[Start Date]
           ,[End Date])
    SELECT
           T.[new operation]
           ,OPD.[Outcome]
           ,OPD.[Operation Expiry Period (Days)]
           ,RS.[Resource Tag]
           ,OPD.[Start Date]
           ,OPD.[End Date]
		   FROM [dbo].[Opr Cessation Days] OPD
		   INNER JOIN [GFL_Backup]..[Temp Opr Name Change KS] T 
	    	ON T.[Old Operation] = OPD.[Operation name]
		   INNER JOIN [resource] RS
		   ON rs.[Resource Name] = T.[new operation]
		   WHERE opd.[Operation Name] = T.[Old Operation]
		   AND opd.[End Date] = '31-dec-9999'


DROP TABLE [GFL_Backup]..[Temp Opr Name Change KS] 
/*------------------------------------------------------------------
	Log Resource Audit Log
-------------------------------------------------------------------*/

insert into @tbRT (resourcetag) 
      select 0
	  
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