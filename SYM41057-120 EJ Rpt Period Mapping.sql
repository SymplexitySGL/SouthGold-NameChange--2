--USE [Sibanye Gold limited]



--From 1 Feb 2013, until going LIVE date with the Operation name change, 

--change the [structure entity] in [RPT period mapping] to the new corresponding [structure entity] for all employees that have work history in any of the 7 operations.

--Get structure entity, find corresponding new structure entity for the 7 operations, and update [rpt period mapping] for the [resource tag] and [period id]

--Table

USE [GFL_Backup]
GO

	USE [GFL_Backup]

	IF NOT EXISTS (SELECT 1 FROM sys.objects SO WHERE object_id = OBJECT_ID(N'[dbo].[Calendar Periods 201503 NameChange]') AND SO.type in (N'U'))
	BEGIN
		CREATE TABLE [dbo].[Calendar Periods 201503 NameChange](
			[Resource Tag] [int] NOT NULL,
			[Period ID] [int] NOT NULL, 
			[Structure Entity] [int] NOT NULL, 
			[Payment ID] [int] NOT NULL, 
			[New Structure Entity] [int] NOT NULL
		) ON [PRIMARY]
	END

	IF EXISTS (SELECT 1 FROM sys.objects SO WHERE object_id = OBJECT_ID(N'[dbo].[Temp Opr Name Change ET]') AND SO.type in (N'U'))
	DROP TABLE dbo.[Temp Opr Name Change ET]

	Create Table [Temp Opr Name Change ET] ([Old Operation] VARCHAR(50), [Old Prefix] VARCHAR(50), [New Operation] VARCHAR(50), [New Prefix] VARCHAR(50), [Start Date] DateTime, [Old Operation Termination Date] DateTime)
	INSERT INTO [Temp Opr Name Change ET] ([Old Operation], [Old Prefix], [New Operation], [New Prefix], [Start Date], [Old Operation Termination Date]) VALUES ('Southgold', 'SGE', 'SG Eastern Operations', 'SGEO', '01-Mar-2015','28-Feb-2015')

	USE [Sibanye Gold Limited]
GO

	INSERT INTO [GFL_Backup]..[Calendar Periods 201503 NameChange]([Resource Tag], [Period ID], [Structure Entity], [Payment ID], [New Structure Entity])
	SELECT RPM.[Resource Tag], RPM.[Period ID], RPM.[Structure Entity], RPM.[Payment ID], NewOS.[Structure Entity] AS [New Structure Entity] 
	FROM [dbo].[Calendar Periods] CP WITH (nolock)
	INNER JOIN [dbo].[Rpt Period Mapping] RPM WITH (nolock)
	 ON [CP].[Period ID] = [RPM].[Period Id]
	INNER JOIN [dbo].[Organisation Structure] OldOS WITH (nolock)
		ON [RPM].[Structure Entity] = OldOS.[Structure Entity]
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] MyData WITH (nolock)
		ON [OldOS].[Operation] = MyData.[Old Operation]
	INNER JOIN [Organisation Structure] NewOS WITH (nolock)
		ON [OldOS].[Group] = [NewOS].[Group]
		AND [OldOS].[Region] = [NewOS].[Region]
		AND [OldOS].[Division] = [NewOS].[Division]
		AND REPLACE([OldOS].[Operation],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Operation]
		AND REPLACE([OldOS].[Shaft Group],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Shaft Group]
		AND REPLACE([OldOS].[Shaft],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Shaft]
		AND REPLACE([OldOS].[Sub Shaft],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Sub Shaft] 
		AND REPLACE([OldOS].[Tertiary Shaft],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Tertiary Shaft]
		AND REPLACE([OldOS].[Department],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Department]
		AND REPLACE([OldOS].[UNIT],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[UNIT]
		AND REPLACE([OldOS].[Section],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Section]
		AND REPLACE([OldOS].[Sub Section],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Sub Section]
		AND REPLACE([OldOS].[Miner],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Miner]
		AND REPLACE([OldOS].[Org Unit - Gang],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Org Unit - Gang]
		AND REPLACE([OldOS].[Designation],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Designation]
	WHERE CP.[Start Date] >= MyData.[Start Date]

	UPDATE RPM
	SET RPM.[Structure Entity] = NewOS.[Structure Entity]
	--SELECT RPM.[Structure Entity] , NewOS.[Structure Entity]
	FROM [dbo].[Calendar Periods] CP WITH (nolock)
	INNER JOIN [dbo].[Rpt Period Mapping] RPM WITH (nolock)
	 ON [CP].[Period ID] = [RPM].[Period Id]
	INNER JOIN [dbo].[Organisation Structure] OldOS WITH (nolock)
		ON [RPM].[Structure Entity] = OldOS.[Structure Entity]
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] MyData WITH (nolock)
		ON [OldOS].[Operation] = MyData.[Old Operation]
	INNER JOIN [Organisation Structure] NewOS WITH (nolock)
		ON [OldOS].[Group] = [NewOS].[Group]
		AND [OldOS].[Region] = [NewOS].[Region]
		AND [OldOS].[Division] = [NewOS].[Division]
		AND REPLACE([OldOS].[Operation],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Operation]
		AND REPLACE([OldOS].[Shaft Group],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Shaft Group]
		AND REPLACE([OldOS].[Shaft],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Shaft]
		AND REPLACE([OldOS].[Sub Shaft],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Sub Shaft] 
		AND REPLACE([OldOS].[Tertiary Shaft],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Tertiary Shaft]
		AND REPLACE([OldOS].[Department],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Department]
		AND REPLACE([OldOS].[UNIT],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[UNIT]
		AND REPLACE([OldOS].[Section],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Section]
		AND REPLACE([OldOS].[Sub Section],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Sub Section]
		AND REPLACE([OldOS].[Miner],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Miner]
		AND REPLACE([OldOS].[Org Unit - Gang],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Org Unit - Gang]
		AND REPLACE([OldOS].[Designation],MyData.[Old Operation],MyData.[New Operation]) = [NewOS].[Designation]
	WHERE CP.[Start Date] >= MyData.[Start Date]

GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Int, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)
SET @User = 'Etienne Jordaan'
SET @IssueNumber = 'SYM41057'
SET @ScriptName = 'SYM41057 120 EJ Rpt Period Mapping.sql'
SET @Description = 'Rpt Period Mapping'
SET @DataChange = 1 -- 0 = Object 1=Data, 3=Data (priority change), 4=Object (priority change)
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'RPT period mapping' 
SET @Version = '2.4.3'
SET @SpecialInstructions = ''
SET @LoggedBy = 'Hannes Scheepers'
SET @VerifiedBy = 'Pieter Kitshoff'
Set @Identity = -1

Exec SYMsp_SymplexityChangeCTRL 1, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy

GO
