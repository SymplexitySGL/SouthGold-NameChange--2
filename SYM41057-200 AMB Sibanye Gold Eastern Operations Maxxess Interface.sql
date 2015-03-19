USE [Sibanye Gold Limited]
/*------------------------------------------------------------------------
  CONFIGURATION CONTROL																																
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
* Modification history
* Version | Date				| By  | Description
* 1		  | 2015-03-13			| AMB | Create 
------------------------------------------------------------------------*/
/****************************************************************************************
   Insert Audit entry
****************************************************************************************/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Bit, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)
SET @User			= 'Anton Beukes' 
SET @IssueNumber	= 'SYM41057' 
SET @ScriptName		= 'SYM41057-200 AMB Sibanye Gold Eastern Operations Maxxess Interface.sql' 
SET @Description	= 'Insert the Operation into ReconOperations table'
SET @DataChange		= 1
SET @FunctionalArea = 'Interface'
SET @ObjectType		= 'Table'
SET @ObjectName		= 'ReconOperations'
SET @Version		= '2.4.3'
SET @SpecialInstructions = ''
SET @LoggedBy		= 'Cornel Metcalfe'
SET @VerifiedBy		= 'Pieter Kitshoff'
Exec SYMsp_SymplexityChangeCTRL 0, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy 
Begin Try
Begin Transaction
/****************************************************************************************
   Main Code
****************************************************************************************/

/*####################################################################################################################################################
Declare Working values
####################################################################################################################################################*/
DECLARE @OLDOperation Varchar(50) = 'Southgold';
DECLARE @NEWOperation Varchar(50) = 'SG Eastern Operations';
DECLARE @NEWDisplayOperation Varchar(50) = 'Sibanye Gold Eastern Operations (Pty) Ltd';
DECLARE @OLDPrefixOperation  Varchar(50) = 'SGE';
DECLARE @NewPrefixOperation  Varchar(50) = 'SGEO';
DECLARE @ResourceTag Int = (SELECT TOP 1 [T].[Resource Tag] FROM [Resource] AS T  WHERE T.[Resource Reference] =  @NEWOperation)
DECLARE @ResourceAudit Table ([Resource Tag] Int);
/*####################################################################################################################################################
Update Recon Operations
####################################################################################################################################################*/
DELETE FROM [dbo].[ReconOperations] WHERE [Operation] = @OLDOperation

INSERT INTO [dbo].[ReconOperations] ([Operation])
 SELECT @NEWOperation AS [Operation] FROM (SELECT @NEWOperation AS  [Operation] ) AS [RO] 
 LEFT OUTER JOIN [dbo].[ReconOperations] AS [RO2] ON [RO2].[Operation] = @NEWOperation
 WHERE [RO2].[Operation] IS  NULL
/*####################################################################################################################################################
Update the Interface TA Parameters 
####################################################################################################################################################*/
UPDATE [Interface GFL TA Proc Parameters] 
 SET [Value] = CASE WHEN CHARINDEX(@OLDOperation,Value) = 0	 THEN [Value] + ',' + @NEWOperation 
 				    WHEN CHARINDEX(@NEWOperation,Value) != 0 THEN [Value]
					ELSE REPLACE([Value],@OLDOperation,@NEWOperation) END 
 WHERE [Stored Proc] = 'sp_GFL_Interface_TA_Recon_Export' AND [Parameter] = 'nvcReconOperations'

UPDATE [Interface GFL TA Proc Parameters] 
 SET [Value] = CASE WHEN CHARINDEX(@OLDOperation,Value) = 0 THEN [Value] + ',' + @NEWOperation 
 				    WHEN CHARINDEX(@NEWOperation,Value) != 0 THEN [Value]
 				    ELSE REPLACE([Value],@OLDOperation,@NEWOperation) END 
 WHERE [Stored Proc] = 'sp_GFL_Interface_TA_Recon_Export_New' AND [Parameter] = 'nvcReconOperations'

UPDATE [Interface GFL TA Proc Parameters] 
 SET [Value] = CASE WHEN CHARINDEX(@OLDOperation,Value) = 0 THEN [Value] + ',' + @NEWOperation 
 				    WHEN CHARINDEX(@NEWOperation,Value) != 0 THEN [Value] ELSE REPLACE([Value],@OLDOperation,@NEWOperation) 
 			   END 
 WHERE [Stored Proc] = 'sp_GFL_Interface_TA_RT_Employee_Export' AND [Parameter] = 'nvcRealtimeOperations'

UPDATE [Interface GFL TA Proc Parameters] 
 SET [Value] = CASE WHEN CHARINDEX(@OLDOperation,Value) = 0 THEN [Value] + ',' + @NEWOperation 
 				    WHEN CHARINDEX(@NEWOperation,Value) != 0 THEN [Value] ELSE REPLACE([Value],@OLDOperation,@NEWOperation) 
 			   END 
 WHERE [Stored Proc] = 'sp_GFL_Interface_TA_SP_Overrides_Import' AND [Parameter] = 'Clocking Operations'
/****************************************************************************************
	Log Resource Audit Log
****************************************************************************************/
INSERT INTO @tbRT (resourcetag) 
      SELECT TOP 1 [Resource Tag] 
	  FROM [dbo].[Resource] AS [R] 
	  WHERE [R].[Resource Reference] = @NEWOperation
/*
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