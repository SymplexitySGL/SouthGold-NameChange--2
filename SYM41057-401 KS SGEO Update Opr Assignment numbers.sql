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
SET @ScriptName = 'SYM41057-401 KS SGEO Update Opr Assignment numbers.sql'                                                
SET @Description = 'SGEO Update Opr Assignment numbers'
SET @DataChange = 1
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'Update Opr Assignment numbers'
SET @Version = '2.4.3'
SET @SpecialInstructions = ''
SET @LoggedBy ='Connie Shaw'
SET @VerifiedBy = 'Etienne Jordaan'
Exec SYMsp_SymplexityChangeCTRL 0, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy
Begin Try
Begin Transaction
/****************************************************************************************
   Main Code
****************************************************************************************/
--SELECT * FROM [dbo].[Opr Assignment Number] WHERE [Operation] = 'southgold' AND [End Date] > '01-mar-2015'
INSERT INTO [dbo].[Opr Assignment Number]
           ([Resource Tag]
           ,[Operation]
           ,[Activity ID]
           ,[Work Area ID]
           ,[Designation ID]
           ,[Start Date]
           ,[Activity]
           ,[Work Area]
           ,[Designation]
           ,[Oug Unit Resource Tag]
           ,[Account Number]
           ,[Capital Project]
           ,[End Date]
           ,[Assignment Number])
 
 select RS.[resource tag]
           ,'SG Eastern Operations'
           ,OAN.[Activity ID]
           ,OAN.[Work Area ID]
           ,OAN.[Designation ID]
           ,OAN.[Start Date]
           ,OAN.[Activity]
           ,OAN.[Work Area]
           ,OAN.[Designation]
           ,OAN.[Oug Unit Resource Tag]
           ,OAN.[Account Number]
           ,OAN.[Capital Project]
           ,OAN.[End Date]
           ,OAN.[Assignment Number] 
		   from [Opr Assignment Number] OAN
		   inner join [resource] RS
		   on RS.[resource reference] = 'SG Eastern Operations'
		   where OAN.[operation] = 'Southgold' 
		   and OAN.[end date] >= '01-Mar-2015'

UPDATE [dbo].[Opr Assignment Number]
SET [End Date] = '28-Feb-2015'
WHERE [Operation] = 'southgold'
AND [End Date] >= '01-Mar-2015'

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