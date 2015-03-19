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
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Bit, @sMsg VARCHAR(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
DECLARE @tbRT ResourceTagTableType, @FunctionalArea VARCHAR(50), @ObjectType VARCHAR(50), @ObjectName VARCHAR(50), @Version	VARCHAR(50)

	SET @User = 'Petrus Niehaus'
	SET @IssueNumber = 'SYM42054'
	SET @ScriptName = 'SYM42054-001 PN SG Eastern Operations Security.sql'                                                
	SET @Description = 'SG Eastern Operations Security'
	SET @DataChange = 1-- 0 = Object 1=Data, 3=Data (priority change), 4=Object (priority change)
	SET @FunctionalArea = 'Payroll'
	SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
	SET @ObjectName = 'Security Structure Groups'
	SET @Version = '2.4.2'
	SET @SpecialInstructions = ''
	SET @LoggedBy ='Cornel Metcalfe' 
					--Betsie Foord --Cornel Metcalfe -- Hannes Scheepers
	SET @VerifiedBy = 'Anton Beukes' 
					--Paul Allen --Cobus Struwig --Monika le Roux -- Pieter Kitshoff -- Theresa Lombaard -- Karen Steenkamp --Annemarie Wessels  --Etienne Jordaan

	Exec SYMsp_SymplexityChangeCTRL 0, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy

	Begin Try
	Begin Transaction
		/****************************************************************************************
		   Main Code
		****************************************************************************************/

		--SELECT * FROM  [Security Structure Groups] WHERE [Structure Group] = 'SouthGold'
		--SELECT * FROM  [Security Structure Group] WHERE [Value] = 'SouthGold'

		IF NOT EXISTS (SELECT TOP 1 1  FROM [Security Structure Groups] WHERE [Operation] = 'SG Eastern Operations')
		INSERT INTO [dbo].[Security Structure Groups]
				( [Structure Group] ,
				  [Level] ,
				  [Value] ,
				  [Group] ,
				  [Region] ,
				  [Operation] ,
				  [Division] ,
				  [Department] ,
				  [Miner] ,
				  [Section] ,
				  [Shaft] ,
				  [Sub Shaft] ,
				  [Shaft Group] ,
				  [Stream] ,
				  [Sub Section] ,
				  [Unit] ,
				  [Org Unit - Gang] ,
				  [Designation] ,
				  [Tertiary Shaft] ,
				  [Remuneration Method]
				)
		SELECT    'SG Eastern Operations' AS [Structure Group] ,
				  [Level] ,
				  [Value] ,
				  [Group] ,
				  [Region] ,
				  'SG Eastern Operations' AS [Operation] ,
				  [Division] ,
				  [Department] ,
				  [Miner] ,
				  [Section] ,
				  [Shaft] ,
				  [Sub Shaft] ,
				  [Shaft Group] ,
				  [Stream] ,
				  [Sub Section] ,
				  [Unit] ,
				  [Org Unit - Gang] ,
				  [Designation] ,
				  [Tertiary Shaft] ,
				  [Remuneration Method] FROM [Security Structure Groups]  WHERE [Structure Group] = 'SouthGold'

		DECLARE @SequenceVar AS INT

		SET @SequenceVar = (Select TOP 1 [Sequence] FROM [Security Structure Groups]  WHERE [Structure Group] = 'SG Eastern Operations')

		PRINT @SequenceVar

		IF NOT EXISTS (SELECT * FROM [Security Structure Group] WHERE [Level] = 'Operation' AND Value = 'SG Eastern Operations')
		INSERT INTO [dbo].[Security Structure Group] 
				( [Sequence] ,
				  [Structure Group] ,
				  [Level] ,
				  [Value] ,
				  [Structure]
				)
		SELECT @SequenceVar AS  [Sequence]  ,
				  [Structure Group] ,
				  [Level] ,
				  'SG Eastern Operations' AS [Value] ,
				  [Structure] 
		FROM [Security Structure Group] 
		WHERE [Level] = 'Operation' AND Value = 'SouthGold'




		/****************************************************************************************
		   If sucessful update Audit entry
		****************************************************************************************/
		Exec SYMsp_SymplexityChangeCTRL @IDENTITY, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy
		COMMIT
	END TRY
    
	/****************************************************************************************
	   Error processing
	****************************************************************************************/
	BEGIN CATCH
		ROLLBACK
		SET @sMsg = 'Error '+Convert(varchar(50),ERROR_NUMBER())+' on line '+Convert(varchar(50),ERROR_LINE())+' message text is "'+ERROR_MESSAGE()+'"'
		EXEC SYMsp_SymplexityChangeCTRL -1, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy, @sMsg
		RAISERROR ('%s',16, 1, @sMsg)
		RAISERROR ('Transactions on script "%s" have been rolled back.',16, 1, @ScriptName)
	END CATCH
