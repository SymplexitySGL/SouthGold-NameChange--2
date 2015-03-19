USE [Sibanye Gold Limited]
/*------------------------------------------------------------------------
  CONFIGURATION CONTROL																																
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
* Modification history
* Version | Date				| By  | Description
* 1		  | 02-04-2015	| AMB | Create 
------------------------------------------------------------------------*/
/****************************************************************************************
   Insert Audit entry
****************************************************************************************/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Bit, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)
SET @User = 'Anton Beukes' 
SET @IssueNumber = 'SYM41057' 
SET @ScriptName = 'SYM41057-224 AMB Sibanye Gold Eastern Operations Reports.sql' 
SET @Description = 'Sibanye Gold Eastern Operations Reports changes'
SET @DataChange = 1
SET @FunctionalArea = 'Data Changes'
SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'Ctl RMA and Capitation Control Table'
SET @Version = '2.4.3'
SET @SpecialInstructions = 'Execute the scripts in order'
SET @LoggedBy ='Cornel Metcalfe'
SET @VerifiedBy = 'Etienne Jordaan'
Exec SYMsp_SymplexityChangeCTRL 0, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy 
Begin Try
Begin Transaction
/****************************************************************************************
   Main Code
****************************************************************************************/
/*####################################################################################################################################################
Declare working values
####################################################################################################################################################*/
DECLARE @OLDOperation Varchar(50) = 'Southgold';
DECLARE @NEWOperation Varchar(50) = 'SG Eastern Operations';
DECLARE @NEWDisplayOperation Varchar(50) = 'Sibanye Gold Eastern Operations (Pty) Ltd';
DECLARE @OLDPrefixOperation  Varchar(50) = 'SGE';
DECLARE @NewPrefixOperation  Varchar(50) = 'SGEO';
/*####################################################################################################################################################
Update RMA Capitation and RSC Control tables
####################################################################################################################################################*/
INSERT INTO [dbo].[Ctl RMA and Capitation Control Table]
	        ( [Start Date] ,
	          [End Date] ,
	          [Operation] ,
	          [Remuneration Method] ,
	          [RMA COID %] ,
	          [RMA Common Law %] ,
	          [Capitation TEBA]
	        )
	SELECT 
			  [Start Date] ,
	          '99991231' AS [End Date] ,
	          @NEWOperation AS [Operation] ,
	          [Remuneration Method] ,
	          [RMA COID %] ,
	          [RMA Common Law %] ,
	          [Capitation TEBA] 
	FROM [Ctl RMA and Capitation Control Table] 
	WHERE [operation] = @OLDOperation
	AND [END DATE] = '99991231'
	
	INSERT INTO [dbo].[Ctl RSC Control Table]
	        ( [Operation] ,
	          [Time Office Register] ,
	          [Start Date] ,
	          [End Date] ,
	          [RSC Percentage]
	        )
	SELECT 
			  @NEWOperation AS [Operation] ,
	          [Time Office Register] ,
	          [Start Date] ,
	          [End Date] ,
	          [RSC Percentage]
	FROM [Ctl RSC Control Table] 
	WHERE [operation] = @OLDOperation AND [END DATE] = '99991231'
/*####################################################################################################################################################
Update CO TAX RSA
####################################################################################################################################################*/
	UPDATE [dbo].[CO TAX RSA] 
	 SET [Company Name] = @NEWOperation,
	 	 [Company Display Name] = @NEWDisplayOperation,
		 [Trading Name] = @NEWDisplayOperation
	 WHERE [company name] = @OLDOperation 
	   AND [Tax Year] >= 2013
/*####################################################################################################################################################
Update Report Users
####################################################################################################################################################*/
	UPDATE [Rpt Scheduler Users] 
	 SET [Operation] = @NEWOperation, 
	 	 [User Name] = REPLACE ([User Name],@OLDPrefixOperation,@NewPrefixOperation)
	 WHERE [Operation] = @OLDOperation 

	UPDATE [dbo].[Rpt Scheduler Reports] 
	 SET [Operations] = REPLACE([Operations],@OLDOperation,@NEWOperation) 
	 WHERE [operations] LIKE '%'+@OLDOperation+'%'
/*----------------------------------------------------------------------
	Report user
----------------------------------------------------------------------*/
PRINT 'Report user'
	UPDATE [Users] 
	 SET [User ID] =  @NewPrefixOperation + 'Reports', 
	 	 [Screen Group] =  @NewPrefixOperation + 'Reports', 
	 	 [Structure Group] = @NewPrefixOperation + 'Reports'
	 WHERE [USER ID] =  @OLDPrefixOperation+'REPORTS'
	
	UPDATE [Security Report Groups] 
	 SET [User ID] = @NewPrefixOperation + 'Reports'
	 WHERE [User ID] = @OLDPrefixOperation+'reports' 
	
	UPDATE [Security User Reports Profile] 
	 SET [User ID] = @NewPrefixOperation + 'Reports'
	 WHERE [User ID] = @OLDPrefixOperation+'reports'
/*----------------------------------------------------------------------
	HR user
----------------------------------------------------------------------*/
PRINT 'HR user'
	UPDATE [Users] 
	 SET [User ID] = @NewPrefixOperation + 'HR',
		 [Screen Group] = @NewPrefixOperation + 'HR', 
		 [Structure Group] = @NewPrefixOperation + 'HR'
	 WHERE [USER ID] =  @OLDPrefixOperation + 'HR'
	     
	UPDATE [Security Report Groups] 
	  SET [User ID] = @NewPrefixOperation+'HR'
	  WHERE [User ID] = @OLDPrefixOperation+'HR'
	 
	 UPDATE [Security User Reports Profile] SET [User ID] = @NewPrefixOperation + 'HR'
	 WHERE [User ID] = @OLDPrefixOperation + 'HR'
/****************************************************************************************
	Log Resource Audit Log
****************************************************************************************/
insert into @tbRT (resourcetag) 
     SELECT TOP 1 [R].[Resource Tag] FROM [dbo].[Resource] AS [R] WHERE [R].[Resource Reference] = @NEWOperation
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