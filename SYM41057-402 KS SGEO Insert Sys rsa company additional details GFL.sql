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
SET @ScriptName = 'SYM41057-402 KS SGEO Insert Sys rsa company additional details GFL.sql'                                                
SET @Description = 'Insert Sys rsa company additional details GFL for new operation resource tags'
SET @DataChange = 1
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'Sys rsa company additional details GFL'
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
--select * from [resource] where [resource reference] = 'southgold'
--select * from [sys rsa company additional details GFL]
--select distinct [resource tag]  from [sys rsa company additional details GFL]


Insert into [Sys rsa company additional details GFL]
([Resource Tag]
           ,[Directors Initials and Surnames]
           ,[Regional Tax Office Name]
           ,[Regional Tax Office Address Details]
           ,[MWPF Number]
           ,[MWPF Mine House]
           ,[MWPF Mine Number]
           ,[Aumed Mine Code]
           ,[Medisense Mine Number]
           ,[COM Number]
           ,[Main Business Activity]
           ,[Company Telephone Number]
           ,[Company Fax Number]
           ,[Company E-Mail Address]
           ,[Industry Sector]
           ,[Sentinel Employer Code]
           ,[Pension Age])
		  Select
		   RS.[resource tag]
           ,SRC.[Directors Initials and Surnames]
           ,SRC.[Regional Tax Office Name]
           ,SRC.[Regional Tax Office Address Details]
           ,SRC.[MWPF Number]
           ,SRC.[MWPF Mine House]
           ,SRC.[MWPF Mine Number]
           ,SRC.[Aumed Mine Code]
           ,SRC.[Medisense Mine Number]
           ,SRC.[COM Number]
           ,SRC.[Main Business Activity]
           ,SRC.[Company Telephone Number]
           ,SRC.[Company Fax Number]
           ,SRC.[Company E-Mail Address]
           ,SRC.[Industry Sector]
           ,SRC.[Sentinel Employer Code]
           ,SRC.[Pension Age]
from [Sys rsa company additional details GFL] SRC
		   inner join [resource] RS
		   on RS.[resource reference] = 'SG Eastern Operations'
		   where SRC.[resource tag] = 2130231947 -- southgold res tag
 
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