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
DECLARE @NewResourceTag Int;
DECLARE @OldResourceTag Int;

SELECT @NewResourceTag = [R].[Resource Tag] FROM [dbo].[Resource] AS [R] WHERE [R].[Resource Reference] = @NEWOperation
SELECT @OldResourceTag = [R].[Resource Tag] FROM [dbo].[Resource] AS [R] WHERE [R].[Resource Reference] = @OLDOperation
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
INSERT INTO [dbo].[CO TAX RSA] ([Resource Tag],[Tax Year],[Company Name],[Trading Name],[Company ID],[Tax Reference Number],[Physical Address Line 1],
									[Physical Address Line 2],[Physical Address Line 3],[Physical Address Line 4],[Physical Address Postal Code],
									[Postal Address Line 1],[Postal Address Line 2],[Postal Address Line 3],[Postal Address Line 4],[Postal Address Postal Code],
									[Diplomatic Indemnity],[Last Certificate Number Issued],[Account Category],[Bank Name],[Branch Name],[Branch Code],
									[Account Number],[Tax Certificate Prefix],[Tax Authority],[Tax Office],[Tax Year Start Date],[Tax Year End Date],
									[UIF Reference Number],[UIF Contact Person],[UIF Contact Number],[UIF Email Address],[Starting Certificate],
									[SDL Reference Number],[Contact Person],[Contact Telephone No],[Contact E-Mail Address],[Software Name],[VAT Trade Code],
									[Physical Address: Unit Number],[Physical Address: Complex],[Physical Address: Street Number],
									[Physical Address: Street/Name of Farm],[Physical Address: Suburb/District],[Physical Address: City/Town],
									[Physical Address: Postal Code],[Default Employee Business Address: Unit Number],
									[Default Employee Business Address: Complex],[Default Employee Business Address: Street Number],
									[Def Employee Business Address: Street/Name of Farm],[Default Employee Business Address: Suburb/District],
									[Default Employee Business Address: City/Town],[Default Employee Business Address: Postal Code],
									[Default Employee Business Tel No],[Company Display Name],[SIC Code],[SEZ Code])
SELECT  @NewResourceTag,[CTR].[Tax Year],@NEWOperation,@NEWDisplayOperation,[CTR].[Company ID],[CTR].[Tax Reference Number],
		[CTR].[Physical Address Line 1],[CTR].[Physical Address Line 2],[CTR].[Physical Address Line 3],[CTR].[Physical Address Line 4],
		[CTR].[Physical Address Postal Code],[CTR].[Postal Address Line 1],[CTR].[Postal Address Line 2],[CTR].[Postal Address Line 3],
		[CTR].[Postal Address Line 4],[CTR].[Postal Address Postal Code],[CTR].[Diplomatic Indemnity],[CTR].[Last Certificate Number Issued],
		[CTR].[Account Category],[CTR].[Bank Name],[CTR].[Branch Name],[CTR].[Branch Code],[CTR].[Account Number],[CTR].[Tax Certificate Prefix],
		[CTR].[Tax Authority],[CTR].[Tax Office],[CTR].[Tax Year Start Date],[CTR].[Tax Year End Date],[CTR].[UIF Reference Number],[CTR].[UIF Contact Person],
		[CTR].[UIF Contact Number],[CTR].[UIF Email Address],[CTR].[Starting Certificate],[CTR].[SDL Reference Number],[CTR].[Contact Person],
		[CTR].[Contact Telephone No],[CTR].[Contact E-Mail Address],[CTR].[Software Name],[CTR].[VAT Trade Code],[CTR].[Physical Address: Unit Number],
		[CTR].[Physical Address: Complex],[CTR].[Physical Address: Street Number],[CTR].[Physical Address: Street/Name of Farm],
		[CTR].[Physical Address: Suburb/District],[CTR].[Physical Address: City/Town],[CTR].[Physical Address: Postal Code],
		[CTR].[Default Employee Business Address: Unit Number],[CTR].[Default Employee Business Address: Complex],
		[CTR].[Default Employee Business Address: Street Number],[CTR].[Def Employee Business Address: Street/Name of Farm],
		[CTR].[Default Employee Business Address: Suburb/District],[CTR].[Default Employee Business Address: City/Town],
		[CTR].[Default Employee Business Address: Postal Code],[CTR].[Default Employee Business Tel No],@NEWDisplayOperation,[CTR].[SIC Code],
		[CTR].[SEZ Code] FROM [dbo].[CO TAX RSA] AS [CTR] LEFT OUTER JOIN [dbo].[CO TAX RSA] AS [CTR2] ON [CTR2].[Resource Tag] = @NewResourceTag AND [CTR2].[Tax Year] = [CTR].[Tax Year]
WHERE [CTR2].[Resource Tag] IS NULL
AND [CTR].[Resource Tag] = @OldResourceTag
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
      select 2130231947
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