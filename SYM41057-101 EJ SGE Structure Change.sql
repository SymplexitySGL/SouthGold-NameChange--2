USE [Sibanye Gold limited]

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Bit, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
DECLARE @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)

	SET @User = 'Etienne Jordaan'
	SET @IssueNumber = 'SYM41057'
	SET @ScriptName = 'SYM41057-101 EJ SGE Structure Change.sql'                                                
	SET @Description = 'SGE Structure Change'
	SET @DataChange = 1
	SET @FunctionalArea = 'Screens'
	SET @ObjectType = 'Table'
	SET @ObjectName = 'Organisation Structure'
	SET @Version = '2.4.3'
	SET @SpecialInstructions = ''
	SET @LoggedBy ='Hannes Scheepers'
	SET @VerifiedBy = 'Pieter Kitshoff'
	
	Exec SYMsp_SymplexityChangeCTRL 0, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy

Begin Try
Begin Transaction
/****************************************************************************************
   Main Code
****************************************************************************************/

	--*****************************************************************************************************--
	--***** 2 things to change in this script @UndoPreviousRun and the staging table. Rest is generic.*****--
	--*****************************************************************************************************--

	--*********************************************************************************************--
	USE GFL_Backup
	IF EXISTS (SELECT OBJECT_ID(N'Temp Opr Name Change ET')) AND (SELECT OBJECT_ID(N'Temp Opr Name Change ET')) IS NOT NULL 
	DROP TABLE [Temp Opr Name Change ET]

	DECLARE @UndoPreviousRun VARCHAR(50) = 'No'

	IF NOT EXISTS (SELECT 1 FROM sys.objects SO WHERE object_id = OBJECT_ID(N'[dbo].[Temp Opr Name Change ET]') AND SO.type in (N'U'))
    BEGIN
		Create Table [Temp Opr Name Change ET] ([Old Operation] VARCHAR(50), [Old Prefix] VARCHAR(50), [New Operation] VARCHAR(50), [New Prefix] VARCHAR(50), [Start Date] DateTime, [Old Operation Termination Date] DateTime)
		INSERT INTO [Temp Opr Name Change ET] ([Old Operation], [Old Prefix], [New Operation], [New Prefix], [Start Date], [Old Operation Termination Date]) VALUES ('Southgold', 'SGE', 'SG Eastern Operations', 'SGEO', '01-Mar-2015','28-Feb-2015')
	END			
																																
	USE [Sibanye Gold Limited]
	
	--*********************************************************************************************--

	-- *******************--
	-- ***Begin Generic***--
	-- *******************--

	IF @UndoPreviousRun = 'Yes'
	BEGIN
		DELETE OS
		FROM [dbo].[Organisation Structure] OS
		INNER JOIN [Temp Opr Name Change ET] T
			ON T.[New Operation] = OS.Operation     
	END
	    
	--*** OS Operation Inserts ***--
	INSERT INTO [dbo].[Organisation Structure] ([Group], [Region], [Division], [Operation], [Shaft Group], [Shaft], [Sub Shaft], [Tertiary Shaft], [Department], [Unit], [Section], [Sub Section], [Miner], [Org Unit - Gang], [Designation], [Start Date], [End date])
	Select  Distinct 
		 OS.[Group], -- Group - nvarchar(50)
         OS.[Region], -- Region - nvarchar(50)
         OS.[Division], -- Division - nvarchar(50)
         T.[New Operation], -- Operation - nvarchar(50)
         '', -- Shaft Group - nvarchar(50)
         '', -- Shaft - nvarchar(50)
         '', -- Sub Shaft - nvarchar(50)
         '', -- Tertiary Shaft - nvarchar(50)
         '', -- Department - nvarchar(50)
         '', -- Unit - nvarchar(50)
         '', -- Section - nvarchar(50)
         '', -- Sub Section - nvarchar(50)
         '', -- Miner - nvarchar(50)
         '', -- Org Unit - Gang - nvarchar(50)
         '', -- Designation - nvarchar(50)
         '01-Jan-1901', -- Start Date - datetime
         '31-Dec-9999'  -- End date - datetime
	FROM [Organisation Structure] OS WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = OS.[Operation]
	LEFT JOIN [dbo].[Organisation Structure] OS2 WITH (NOLOCK)
		ON OS2.[Group] = OS.[Group]
		And OS2.[Region] = OS.[Region]
		AND OS2.[Division] = OS.[Division]
		AND OS2.[Operation] = T.[New Operation]
	WHERE ISNULL(OS.[Operation],'') <> ''
	AND ISNULL(OS.[Designation],'') NOT IN ('Applicant','')
	AND ISNULL(OS.[Designation],'') NOT LIKE 'Termination%'
	AND OS2.[Structure Entity] IS NULL
	ORDER BY OS.[Group], OS.[Region], OS.[Division]

	--*** OS Shaft Group Inserts ***--
	INSERT INTO [dbo].[Organisation Structure] ([Group], [Region], [Division], [Operation], [Shaft Group], [Shaft], [Sub Shaft], [Tertiary Shaft], [Department], [Unit], [Section], [Sub Section], [Miner], [Org Unit - Gang], [Designation], [Start Date], [End date])
	Select  Distinct 
		 OS.[Group], -- Group - nvarchar(50)
         OS.[Region], -- Region - nvarchar(50)
         OS.[Division], -- Division - nvarchar(50)
         T.[New Operation], -- Operation - nvarchar(50)
         REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]), -- Shaft Group - nvarchar(50)
         '', -- Shaft - nvarchar(50)
         '', -- Sub Shaft - nvarchar(50)
         '', -- Tertiary Shaft - nvarchar(50)
         '', -- Department - nvarchar(50)
         '', -- Unit - nvarchar(50)
         '', -- Section - nvarchar(50)
         '', -- Sub Section - nvarchar(50)
         '', -- Miner - nvarchar(50)
         '', -- Org Unit - Gang - nvarchar(50)
         '', -- Designation - nvarchar(50)
         OS.[Start Date], -- Start Date - datetime
         OS.[End Date]  -- End date - datetime
	FROM [Organisation Structure] OS WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = OS.[Operation]
	LEFT JOIN [dbo].[Organisation Structure] OS2 WITH (NOLOCK)
		ON OS2.[Group] = OS.[Group]
		And OS2.[Region] = OS.[Region]
		AND OS2.[Division] = OS.[Division]
		AND OS2.[Operation] = T.[New Operation]
		AND OS2.[Shaft Group] = REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
	WHERE ISNULL(OS.[Shaft Group],'') <> ''
	AND ISNULL(OS.[Designation],'') NOT IN ('Applicant','')
	AND ISNULL(OS.[Designation],'') NOT LIKE 'Termination%'
	AND OS2.[Structure Entity] IS NULL
	ORDER BY OS.[Group], OS.[Region], OS.[Division], T.[New Operation]
		,REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]) 

	--*** OS Shaft Inserts ***--
	INSERT INTO [dbo].[Organisation Structure] ([Group], [Region], [Division], [Operation], [Shaft Group], [Shaft], [Sub Shaft], [Tertiary Shaft], [Department], [Unit], [Section], [Sub Section], [Miner], [Org Unit - Gang], [Designation], [Start Date], [End date])
	Select  Distinct 
		 OS.[Group], -- Group - nvarchar(50)
         OS.[Region], -- Region - nvarchar(50)
         OS.[Division], -- Division - nvarchar(50)
         T.[New Operation], -- Operation - nvarchar(50)
         REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]),-- Shaft Group - nvarchar(50)
         REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix]), -- Shaft - nvarchar(50)
         '', -- Sub Shaft - nvarchar(50)
         '', -- Tertiary Shaft - nvarchar(50)
         '', -- Department - nvarchar(50)
         '', -- Unit - nvarchar(50)
         '', -- Section - nvarchar(50)
         '', -- Sub Section - nvarchar(50)
         '', -- Miner - nvarchar(50)
         '', -- Org Unit - Gang - nvarchar(50)
         '', -- Designation - nvarchar(50)
         OS.[Start Date], -- Start Date - datetime
         OS.[End Date]  -- End date - datetime
	FROM [Organisation Structure] OS  WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = OS.[Operation]
	LEFT JOIN [dbo].[Organisation Structure] OS2 WITH (NOLOCK)
		ON OS2.[Group] = OS.[Group]
		And OS2.[Region] = OS.[Region]
		AND OS2.[Division] = OS.[Division]
		AND OS2.[Operation] = T.[New Operation]
		AND OS2.[Shaft Group] = REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
		AND OS2.[Shaft] = REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
	WHERE ISNULL(OS.[Shaft],'') <> ''
	AND ISNULL(OS.[Designation],'') NOT IN ('Applicant','')
	AND ISNULL(OS.[Designation],'') NOT LIKE 'Termination%'
	AND OS2.[Structure Entity] IS NULL
	ORDER BY OS.[Group], OS.[Region], OS.[Division] ,T.[New Operation] 
		,REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])

	--*** OS Sub Shaft Inserts ***--
	INSERT INTO [dbo].[Organisation Structure] ([Group], [Region], [Division], [Operation], [Shaft Group], [Shaft], [Sub Shaft], [Tertiary Shaft], [Department], [Unit], [Section], [Sub Section], [Miner], [Org Unit - Gang], [Designation], [Start Date], [End date])
	Select  Distinct 
		 OS.[Group], -- Group - nvarchar(50)
         OS.[Region], -- Region - nvarchar(50)
         OS.[Division], -- Division - nvarchar(50)
         T.[New Operation], -- Operation - nvarchar(50)
         REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]),-- Shaft Group - nvarchar(50)
         REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix]),-- Shaft - nvarchar(50)
		 REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix]),-- Sub Shaft - nvarchar(50)
         '', -- Tertiary Shaft - nvarchar(50)
         '', -- Department - nvarchar(50)
         '', -- Unit - nvarchar(50)
         '', -- Section - nvarchar(50)
         '', -- Sub Section - nvarchar(50)
         '', -- Miner - nvarchar(50)
         '', -- Org Unit - Gang - nvarchar(50)
         '', -- Designation - nvarchar(50)
         OS.[Start Date], -- Start Date - datetime
         OS.[End Date]  -- End date - datetime
	FROM [Organisation Structure] OS  WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = OS.[Operation]
	LEFT JOIN [dbo].[Organisation Structure] OS2 WITH (NOLOCK)
		ON OS2.[Group] = OS.[Group]
		And OS2.[Region] = OS.[Region]
		AND OS2.[Division] = OS.[Division]
		AND OS2.[Operation] = T.[New Operation]
		AND OS2.[Shaft Group] = REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
		AND OS2.[Shaft] = REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Shaft] = REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
	WHERE ISNULL(OS.[Sub Shaft],'') <> ''
	AND ISNULL(OS.[Designation],'') NOT IN ('Applicant','')
	AND ISNULL(OS.[Designation],'') NOT LIKE 'Termination%'
	AND OS2.[Structure Entity] IS NULL
	ORDER BY OS.[Group], OS.[Region], OS.[Division], T.[New Operation]
		,REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])

	--*** OS Tertiary Shaft Inserts ***--
	INSERT INTO [dbo].[Organisation Structure] ([Group], [Region], [Division], [Operation], [Shaft Group], [Shaft], [Sub Shaft], [Tertiary Shaft], [Department], [Unit], [Section], [Sub Section], [Miner], [Org Unit - Gang], [Designation], [Start Date], [End date])
	Select  Distinct 
		OS.[Group], -- Group - nvarchar(50)
		OS.[Region], -- Region - nvarchar(50)
		OS.[Division], -- Division - nvarchar(50)
		T.[New Operation], -- Operation - nvarchar(50)
		REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]),-- Shaft Group - nvarchar(50)
		REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix]),-- Shaft - nvarchar(50)
		REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix]),-- Sub Shaft - nvarchar(50)
		REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]),-- Tertiary Shaft - nvarchar(50)
		'', -- Department - nvarchar(50)
		'', -- Unit - nvarchar(50)
		'', -- Section - nvarchar(50)
		'', -- Sub Section - nvarchar(50)
		'', -- Miner - nvarchar(50)
		'', -- Org Unit - Gang - nvarchar(50)
		'', -- Designation - nvarchar(50)
		OS.[Start Date], -- Start Date - datetime
		OS.[End Date]  -- End date - datetime
	FROM [Organisation Structure] OS  WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = OS.[Operation]
	LEFT JOIN [dbo].[Organisation Structure] OS2 WITH (NOLOCK)
		ON OS2.[Group] = OS.[Group]
		And OS2.[Region] = OS.[Region]
		AND OS2.[Division] = OS.[Division]
		AND OS2.[Operation] = T.[New Operation]
		AND OS2.[Shaft Group] = REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
		AND OS2.[Shaft] = REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Shaft] = REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Tertiary Shaft] = REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix])
	WHERE ISNULL(OS.[Tertiary Shaft],'') <> ''
	AND ISNULL(OS.[Designation],'') NOT IN ('Applicant','')
	AND ISNULL(OS.[Designation],'') NOT LIKE 'Termination%'
	AND OS2.[Structure Entity] IS NULL
	ORDER BY OS.[Group], OS.[Region], OS.[Division], T.[New Operation]
		,REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]) 

	--*** OS Department Inserts ***--
	INSERT INTO [dbo].[Organisation Structure] ([Group], [Region], [Division], [Operation], [Shaft Group], [Shaft], [Sub Shaft], [Tertiary Shaft], [Department], [Unit], [Section], [Sub Section], [Miner], [Org Unit - Gang], [Designation], [Start Date], [End date])
	Select  Distinct 
		OS.[Group], -- Group - nvarchar(50)
		OS.[Region], -- Region - nvarchar(50)
		OS.[Division], -- Division - nvarchar(50)
		T.[New Operation], -- Operation - nvarchar(50)
		REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]),-- Shaft Group - nvarchar(50)
		REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix]),-- Shaft - nvarchar(50)
		REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix]),-- Sub Shaft - nvarchar(50)
		REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]),-- Tertiary Shaft - nvarchar(50)
		REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]),-- Department - nvarchar(50)
		'', -- Unit - nvarchar(50)
		'', -- Section - nvarchar(50)
		'', -- Sub Section - nvarchar(50)
		'', -- Miner - nvarchar(50)
		'', -- Org Unit - Gang - nvarchar(50)
		'', -- Designation - nvarchar(50)
		OS.[Start Date], -- Start Date - datetime
		OS.[End Date]  -- End date - datetime
	FROM [Organisation Structure] OS  WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = OS.[Operation]
	LEFT JOIN [dbo].[Organisation Structure] OS2 WITH (NOLOCK)
		ON OS2.[Group] = OS.[Group]
		And OS2.[Region] = OS.[Region]
		AND OS2.[Division] = OS.[Division]
		AND OS2.[Operation] = T.[New Operation]
		AND OS2.[Shaft Group] = REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
		AND OS2.[Shaft] = REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Shaft] = REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Tertiary Shaft] = REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Department] = REPLACE(OS.[Department], T.[old prefix],T.[New Prefix])
	WHERE ISNULL(OS.[Department],'') <> ''
	AND ISNULL(OS.[Designation],'') NOT IN ('Applicant','')
	AND ISNULL(OS.[Designation],'') NOT LIKE 'Termination%'
	AND OS2.[Structure Entity] IS NULL
	ORDER BY OS.[Group], OS.[Region], OS.[Division], T.[New Operation]
		,REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]) 

	--*** OS Unit Inserts ***--
	INSERT INTO [dbo].[Organisation Structure] ([Group], [Region], [Division], [Operation], [Shaft Group], [Shaft], [Sub Shaft], [Tertiary Shaft], [Department], [Unit], [Section], [Sub Section], [Miner], [Org Unit - Gang], [Designation], [Start Date], [End date])
	Select  Distinct 
		OS.[Group], -- Group - nvarchar(50)
		OS.[Region], -- Region - nvarchar(50)
		OS.[Division], -- Division - nvarchar(50)
		T.[New Operation], -- Operation - nvarchar(50)
		REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]),-- Shaft Group - nvarchar(50)
		REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix]),-- Shaft - nvarchar(50)
		REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix]),-- Sub Shaft - nvarchar(50)
		REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]),-- Tertiary Shaft - nvarchar(50)
		REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]),-- Department - nvarchar(50)
		REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix]),-- Unit - nvarchar(50)
		'', -- Section - nvarchar(50)
		'', -- Sub Section - nvarchar(50)
		'', -- Miner - nvarchar(50)
		'', -- Org Unit - Gang - nvarchar(50)
		'', -- Designation - nvarchar(50)
		OS.[Start Date], -- Start Date - datetime
		OS.[End Date]  -- End date - datetime
	FROM [Organisation Structure] OS  WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = OS.[Operation]
	LEFT JOIN [dbo].[Organisation Structure] OS2 WITH (NOLOCK)
		ON OS2.[Group] = OS.[Group]
		And OS2.[Region] = OS.[Region]
		AND OS2.[Division] = OS.[Division]
		AND OS2.[Operation] = T.[New Operation]
		AND OS2.[Shaft Group] = REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
		AND OS2.[Shaft] = REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Shaft] = REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Tertiary Shaft] = REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Department] = REPLACE(OS.[Department], T.[old prefix],T.[New Prefix])
		AND OS2.[Unit] = REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix])
	WHERE ISNULL(OS.[Unit],'') <> ''
	AND ISNULL(OS.[Designation],'') NOT IN ('Applicant','')
	AND ISNULL(OS.[Designation],'') NOT LIKE 'Termination%'
	AND OS2.[Structure Entity] IS NULL
	ORDER BY OS.[Group], OS.[Region], OS.[Division], T.[New Operation]
		,REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix])

	--*** OS Section Inserts ***--
	INSERT INTO [dbo].[Organisation Structure] ([Group], [Region], [Division], [Operation], [Shaft Group], [Shaft], [Sub Shaft], [Tertiary Shaft], [Department], [Unit], [Section], [Sub Section], [Miner], [Org Unit - Gang], [Designation], [Start Date], [End date])
	Select  Distinct 
		OS.[Group], -- Group - nvarchar(50)
		OS.[Region], -- Region - nvarchar(50)
		OS.[Division], -- Division - nvarchar(50)
		T.[New Operation], -- Operation - nvarchar(50)
		REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]),-- Shaft Group - nvarchar(50)
		REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix]),-- Shaft - nvarchar(50)
		REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix]),-- Sub Shaft - nvarchar(50)
		REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]),-- Tertiary Shaft - nvarchar(50)
		REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]),-- Department - nvarchar(50)
		REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix]),-- Unit - nvarchar(50)
		REPLACE(OS.[Section], T.[old prefix],T.[New Prefix]),-- Section - nvarchar(50)
		'', -- Sub Section - nvarchar(50)
		'', -- Miner - nvarchar(50)
		'', -- Org Unit - Gang - nvarchar(50)
		'', -- Designation - nvarchar(50)
		OS.[Start Date], -- Start Date - datetime
		OS.[End Date]  -- End date - datetime
	FROM [Organisation Structure] OS  WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = OS.[Operation]
	LEFT JOIN [dbo].[Organisation Structure] OS2 WITH (NOLOCK)
		ON OS2.[Group] = OS.[Group]
		And OS2.[Region] = OS.[Region]
		AND OS2.[Division] = OS.[Division]
		AND OS2.[Operation] = T.[New Operation]
		AND OS2.[Shaft Group] = REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
		AND OS2.[Shaft] = REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Shaft] = REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Tertiary Shaft] = REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Department] = REPLACE(OS.[Department], T.[old prefix],T.[New Prefix])
		AND OS2.[Unit] = REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix])
		AND OS2.[Section] = REPLACE(OS.[Section], T.[old prefix],T.[New Prefix])
	WHERE ISNULL(OS.[Section],'') <> ''
	AND ISNULL(OS.[Designation],'') NOT IN ('Applicant','')
	AND ISNULL(OS.[Designation],'') NOT LIKE 'Termination%'
	AND OS2.[Structure Entity] IS NULL
	ORDER BY OS.[Group], OS.[Region], OS.[Division], T.[New Operation]
		,REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Section], T.[old prefix],T.[New Prefix])

	--*** OS Sub Section Inserts ***--
	INSERT INTO [dbo].[Organisation Structure] ([Group], [Region], [Division], [Operation], [Shaft Group], [Shaft], [Sub Shaft], [Tertiary Shaft], [Department], [Unit], [Section], [Sub Section], [Miner], [Org Unit - Gang], [Designation], [Start Date], [End date])
	Select  Distinct 
		OS.[Group], -- Group - nvarchar(50)
		OS.[Region], -- Region - nvarchar(50)
		OS.[Division], -- Division - nvarchar(50)
		T.[New Operation], -- Operation - nvarchar(50)
		REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]),-- Shaft Group - nvarchar(50)
		REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix]),-- Shaft - nvarchar(50)
		REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix]),-- Sub Shaft - nvarchar(50)
		REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]),-- Tertiary Shaft - nvarchar(50)
		REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]),-- Department - nvarchar(50)
		REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix]),-- Unit - nvarchar(50)
		REPLACE(OS.[Section], T.[old prefix],T.[New Prefix]),-- Section - nvarchar(50)
		REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix]),-- Sub Section - nvarchar(50)
		'', -- Miner - nvarchar(50)
		'', -- Org Unit - Gang - nvarchar(50)
		'', -- Designation - nvarchar(50)
		OS.[Start Date], -- Start Date - datetime
		OS.[End Date]  -- End date - datetime
	FROM [Organisation Structure] OS  WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = OS.[Operation]
	LEFT JOIN [dbo].[Organisation Structure] OS2 WITH (NOLOCK)
		ON OS2.[Group] = OS.[Group]
		And OS2.[Region] = OS.[Region]
		AND OS2.[Division] = OS.[Division]
		AND OS2.[Operation] = T.[New Operation]
		AND OS2.[Shaft Group] = REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
		AND OS2.[Shaft] = REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Shaft] = REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Tertiary Shaft] = REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Department] = REPLACE(OS.[Department], T.[old prefix],T.[New Prefix])
		AND OS2.[Unit] = REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix])
		AND OS2.[Section] = REPLACE(OS.[Section], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Section] = REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix])
	WHERE ISNULL(OS.[Sub Section],'') <> ''
	AND ISNULL(OS.[Designation],'') NOT IN ('Applicant','')
	AND ISNULL(OS.[Designation],'') NOT LIKE 'Termination%'
	AND OS2.[Structure Entity] IS NULL
	ORDER BY OS.[Group], OS.[Region], OS.[Division], T.[New Operation]
		,REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Section], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix]) 

	--*** OS Miner Inserts ***--
	INSERT INTO [dbo].[Organisation Structure] ([Group], [Region], [Division], [Operation], [Shaft Group], [Shaft], [Sub Shaft], [Tertiary Shaft], [Department], [Unit], [Section], [Sub Section], [Miner], [Org Unit - Gang], [Designation], [Start Date], [End date])
	Select  Distinct 
		OS.[Group], -- Group - nvarchar(50)
		OS.[Region], -- Region - nvarchar(50)
		OS.[Division], -- Division - nvarchar(50)
		T.[New Operation], -- Operation - nvarchar(50)
		REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]),-- Shaft Group - nvarchar(50)
		REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix]),-- Shaft - nvarchar(50)
		REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix]),-- Sub Shaft - nvarchar(50)
		REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]),-- Tertiary Shaft - nvarchar(50)
		REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]),-- Department - nvarchar(50)
		REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix]),-- Unit - nvarchar(50)
		REPLACE(OS.[Section], T.[old prefix],T.[New Prefix]),-- Section - nvarchar(50)
		REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix]),-- Sub Section - nvarchar(50)
		REPLACE(OS.[Miner], T.[old prefix],T.[New Prefix]),-- Miner - nvarchar(50)
		'', -- Org Unit - Gang - nvarchar(50)
		'', -- Designation - nvarchar(50)
		OS.[Start Date], -- Start Date - datetime
		OS.[End Date]  -- End date - datetime
	FROM [Organisation Structure] OS  WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = OS.[Operation]
	LEFT JOIN [dbo].[Organisation Structure] OS2 WITH (NOLOCK)
		ON OS2.[Group] = OS.[Group]
		And OS2.[Region] = OS.[Region]
		AND OS2.[Division] = OS.[Division]
		AND OS2.[Operation] = T.[New Operation]
		AND OS2.[Shaft Group] = REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
		AND OS2.[Shaft] = REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Shaft] = REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Tertiary Shaft] = REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Department] = REPLACE(OS.[Department], T.[old prefix],T.[New Prefix])
		AND OS2.[Unit] = REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix])
		AND OS2.[Section] = REPLACE(OS.[Section], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Section] = REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix])
		AND OS2.[Miner] = REPLACE(OS.[Miner], T.[old prefix],T.[New Prefix])
	WHERE ISNULL(OS.[Miner],'') <> ''
	AND ISNULL(OS.[Designation],'') NOT IN ('Applicant','')
	AND ISNULL(OS.[Designation],'') NOT LIKE 'Termination%'
	AND OS2.[Structure Entity] IS NULL
	ORDER BY OS.[Group], OS.[Region], OS.[Division], T.[New Operation]
		,REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Section], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Miner], T.[old prefix],T.[New Prefix])

	--*** OS Org Unit - Gang Inserts ***--
	INSERT INTO [dbo].[Organisation Structure] ([Group], [Region], [Division], [Operation], [Shaft Group], [Shaft], [Sub Shaft], [Tertiary Shaft], [Department], [Unit], [Section], [Sub Section], [Miner], [Org Unit - Gang], [Designation], [Start Date], [End date])
	Select  Distinct 
		OS.[Group], -- Group - nvarchar(50)
		OS.[Region], -- Region - nvarchar(50)
		OS.[Division], -- Division - nvarchar(50)
		T.[New Operation], -- Operation - nvarchar(50)
		REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]),-- Shaft Group - nvarchar(50)
		REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix]),-- Shaft - nvarchar(50)
		REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix]),-- Sub Shaft - nvarchar(50)
		REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]),-- Tertiary Shaft - nvarchar(50)
		REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]),-- Department - nvarchar(50)
		REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix]),-- Unit - nvarchar(50)
		REPLACE(OS.[Section], T.[old prefix],T.[New Prefix]),-- Section - nvarchar(50)
		REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix]),-- Sub Section - nvarchar(50)
		REPLACE(OS.[Miner], T.[old prefix],T.[New Prefix]),-- Miner - nvarchar(50)
		REPLACE(OS.[Org Unit - Gang], T.[old prefix],T.[New Prefix]),-- Org Unit - Gang - nvarchar(50)
		'', -- Designation - nvarchar(50)
		OS.[Start Date], -- Start Date - datetime
		OS.[End Date]  -- End date - datetime
	FROM [Organisation Structure] OS  WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = OS.[Operation]
	LEFT JOIN [dbo].[Organisation Structure] OS2 WITH (NOLOCK)
		ON OS2.[Group] = OS.[Group]
		And OS2.[Region] = OS.[Region]
		AND OS2.[Division] = OS.[Division]
		AND OS2.[Operation] = T.[New Operation]
		AND OS2.[Shaft Group] = REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
		AND OS2.[Shaft] = REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Shaft] = REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Tertiary Shaft] = REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Department] = REPLACE(OS.[Department], T.[old prefix],T.[New Prefix])
		AND OS2.[Unit] = REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix])
		AND OS2.[Section] = REPLACE(OS.[Section], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Section] = REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix])
		AND OS2.[Miner] = REPLACE(OS.[Miner], T.[old prefix],T.[New Prefix])
		AND OS2.[Org Unit - Gang] = REPLACE(OS.[Org Unit - Gang], T.[old prefix],T.[New Prefix])
	WHERE ISNULL(OS.[Org Unit - Gang],'') <> ''
	AND ISNULL(OS.[Designation],'') NOT IN ('Applicant','')
	AND ISNULL(OS.[Designation],'') NOT LIKE 'Termination%'
	AND OS2.[Structure Entity] IS NULL
	ORDER BY OS.[Group], OS.[Region], OS.[Division], T.[New Operation] 
		,REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Section], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Miner], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Org Unit - Gang], T.[old prefix],T.[New Prefix]) 

	--*** Designation Inserts ***--
	INSERT INTO [dbo].[Organisation Structure] ([Group], [Region], [Division], [Operation], [Shaft Group], [Shaft], [Sub Shaft], [Tertiary Shaft], [Department], [Unit], [Section], [Sub Section], [Miner], [Org Unit - Gang], [Designation], [Start Date], [End date])
	Select  Distinct 
		 OS.[Group], -- Group - nvarchar(50)
         OS.[Region], -- Region - nvarchar(50)
         OS.[Division], -- Division - nvarchar(50)
         T.[New Operation], -- Operation - nvarchar(50)
         REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]),-- Shaft Group - nvarchar(50)
         REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix]),-- Shaft - nvarchar(50)
		 REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix]),-- Sub Shaft - nvarchar(50)
		 REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]),-- Tertiary Shaft - nvarchar(50)
		 REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]),-- Department - nvarchar(50)
		 REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix]),-- Unit - nvarchar(50)
		 REPLACE(OS.[Section], T.[old prefix],T.[New Prefix]),-- Section - nvarchar(50)
		 REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix]),-- Sub Section - nvarchar(50)
		 REPLACE(OS.[Miner], T.[old prefix],T.[New Prefix]),-- Miner - nvarchar(50)
		 REPLACE(OS.[Org Unit - Gang], T.[old prefix],T.[New Prefix]),-- Org Unit - Gang - nvarchar(50)
		 REPLACE(OS.[Designation], T.[old prefix],T.[New Prefix]),-- Designation - nvarchar(50)
         OS.[Start Date], -- Start Date - datetime
         OS.[End Date]  -- End date - datetime
	FROM [Organisation Structure] OS  WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = OS.[Operation]
	LEFT JOIN [dbo].[Organisation Structure] OS2 WITH (NOLOCK)
		ON OS2.[Group] = OS.[Group]
		And OS2.[Region] = OS.[Region]
		AND OS2.[Division] = OS.[Division]
		AND OS2.[Operation] = T.[New Operation]
		AND OS2.[Shaft Group] = REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
		AND OS2.[Shaft] = REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Shaft] = REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Tertiary Shaft] = REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Department] = REPLACE(OS.[Department], T.[old prefix],T.[New Prefix])
		AND OS2.[Unit] = REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix])
		AND OS2.[Section] = REPLACE(OS.[Section], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Section] = REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix])
		AND OS2.[Miner] = REPLACE(OS.[Miner], T.[old prefix],T.[New Prefix])
		AND OS2.[Org Unit - Gang] = REPLACE(OS.[Org Unit - Gang], T.[old prefix],T.[New Prefix])
		AND OS2.[Designation] = REPLACE(OS.[Designation], T.[old prefix],T.[New Prefix])
	WHERE ISNULL(OS.[Designation],'') <> ''
	AND ISNULL(OS.[Designation],'') NOT IN ('Applicant','')
	AND ISNULL(OS.[Designation],'') NOT LIKE 'Termination%'
	AND OS2.[Structure Entity] IS NULL
	ORDER BY OS.[Group], OS.[Region], OS.[Division], T.[New Operation]
		,REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Section], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Miner], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Org Unit - Gang], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Designation], T.[old prefix],T.[New Prefix])

	--*** OS Applicants Inserts ***--
	INSERT INTO [dbo].[Organisation Structure] ([Group], [Region], [Division], [Operation], [Shaft Group], [Shaft], [Sub Shaft], [Tertiary Shaft], [Department], [Unit], [Section], [Sub Section], [Miner], [Org Unit - Gang], [Designation], [Start Date], [End date])
	Select  Distinct 
		 OS.[Group], -- Group - nvarchar(50)
         OS.[Region], -- Region - nvarchar(50)
         OS.[Division], -- Division - nvarchar(50)
         T.[New Operation], -- Operation - nvarchar(50)
         REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]),-- Shaft Group - nvarchar(50)
         REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix]),-- Shaft - nvarchar(50)
		 REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix]),-- Sub Shaft - nvarchar(50)
		 REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]),-- Tertiary Shaft - nvarchar(50)
		 REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]),-- Department - nvarchar(50)
		 REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix]),-- Unit - nvarchar(50)
		 REPLACE(OS.[Section], T.[old prefix],T.[New Prefix]),-- Section - nvarchar(50)
		 REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix]),-- Sub Section - nvarchar(50)
		 REPLACE(OS.[Miner], T.[old prefix],T.[New Prefix]),-- Miner - nvarchar(50)
		 REPLACE(OS.[Org Unit - Gang], T.[old prefix],T.[New Prefix]),-- Org Unit - Gang - nvarchar(50)
		 REPLACE(OS.[Designation], T.[old prefix],T.[New Prefix]),-- Designation - nvarchar(50)
         OS.[Start Date], -- Start Date - datetime
         OS.[End Date]  -- End date - datetime
	FROM [Organisation Structure] OS  WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = OS.[Operation]
	LEFT JOIN [dbo].[Organisation Structure] OS2 WITH (NOLOCK)
		ON OS2.[Group] = OS.[Group]
		And OS2.[Region] = OS.[Region]
		AND OS2.[Division] = OS.[Division]
		AND OS2.[Operation] = T.[New Operation]
		AND OS2.[Shaft Group] = REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
		AND OS2.[Shaft] = REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Shaft] = REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Tertiary Shaft] = REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Department] = REPLACE(OS.[Department], T.[old prefix],T.[New Prefix])
		AND OS2.[Unit] = REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix])
		AND OS2.[Section] = REPLACE(OS.[Section], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Section] = REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix])
		AND OS2.[Miner] = REPLACE(OS.[Miner], T.[old prefix],T.[New Prefix])
		AND OS2.[Org Unit - Gang] = REPLACE(OS.[Org Unit - Gang], T.[old prefix],T.[New Prefix])
		AND OS2.[Designation] = REPLACE(OS.[Designation], T.[old prefix],T.[New Prefix])
	WHERE ISNULL(OS.[Designation],'') <> ''
	AND ISNULL(OS.[Designation],'') IN ('Applicant')
	AND OS2.[Structure Entity] IS NULL
	ORDER BY OS.[Group], OS.[Region], OS.[Division], T.[New Operation] 
		,REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Section], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Miner], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Org Unit - Gang], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Designation], T.[old prefix],T.[New Prefix])

	--*** OS Terminations Inserts ***--
	INSERT INTO [dbo].[Organisation Structure] ([Group], [Region], [Division], [Operation], [Shaft Group], [Shaft], [Sub Shaft], [Tertiary Shaft], [Department], [Unit], [Section], [Sub Section], [Miner], [Org Unit - Gang], [Designation], [Start Date], [End date])
	Select  Distinct 
		OS.[Group], -- Group - nvarchar(50)
		OS.[Region], -- Region - nvarchar(50)
		OS.[Division], -- Division - nvarchar(50)
		T.[New Operation], -- Operation - nvarchar(50)
		REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix]),-- Shaft Group - nvarchar(50)
		REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix]),-- Shaft - nvarchar(50)
		REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix]),-- Sub Shaft - nvarchar(50)
		REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]),-- Tertiary Shaft - nvarchar(50)
		REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]),-- Department - nvarchar(50)
		REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix]),-- Unit - nvarchar(50)
		REPLACE(OS.[Section], T.[old prefix],T.[New Prefix]),-- Section - nvarchar(50)
		REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix]),-- Sub Section - nvarchar(50)
		REPLACE(OS.[Miner], T.[old prefix],T.[New Prefix]),-- Miner - nvarchar(50)
		REPLACE(OS.[Org Unit - Gang], T.[old prefix],T.[New Prefix]),-- Org Unit - Gang - nvarchar(50)
		REPLACE(OS.[Designation], T.[old prefix],T.[New Prefix]),-- Designation - nvarchar(50)
		OS.[Start Date], -- Start Date - datetime
		OS.[End Date]  -- End date - datetime
	FROM [Organisation Structure] OS  WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = OS.[Operation]
	LEFT JOIN [dbo].[Organisation Structure] OS2 WITH (NOLOCK)
		ON OS2.[Group] = OS.[Group]
		And OS2.[Region] = OS.[Region]
		AND OS2.[Division] = OS.[Division]
		AND OS2.[Operation] = T.[New Operation]
		AND OS2.[Shaft Group] = REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
		AND OS2.[Shaft] = REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Shaft] = REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Tertiary Shaft] = REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix])
		AND OS2.[Department] = REPLACE(OS.[Department], T.[old prefix],T.[New Prefix])
		AND OS2.[Unit] = REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix])
		AND OS2.[Section] = REPLACE(OS.[Section], T.[old prefix],T.[New Prefix])
		AND OS2.[Sub Section] = REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix])
		AND OS2.[Miner] = REPLACE(OS.[Miner], T.[old prefix],T.[New Prefix])
		AND OS2.[Org Unit - Gang] = REPLACE(OS.[Org Unit - Gang], T.[old prefix],T.[New Prefix])
		AND OS2.[Designation] = REPLACE(OS.[Designation], T.[old prefix],T.[New Prefix])
	WHERE ISNULL(OS.[Designation],'') <> ''
	AND ISNULL(OS.[Designation],'') Like 'Termination%'
	AND OS2.[Structure Entity] IS NULL
	ORDER BY OS.[Group], OS.[Region], OS.[Division], T.[New Operation]
		,REPLACE(OS.[Shaft Group], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Shaft], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Sub Shaft], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Tertiary Shaft], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Department], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Unit], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Section], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Sub Section], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Miner], T.[old prefix],T.[New Prefix])
		,REPLACE(OS.[Org Unit - Gang], T.[old prefix],T.[New Prefix]) 
		,REPLACE(OS.[Designation], T.[old prefix],T.[New Prefix])

	----*** INSERT the Resources that dont exist and is in OS. ***--
	INSERT INTO [dbo].[Resource] ([Resource Reference], [Resource Name],[Resource Type], [Start Date], [End Date])
	SELECT DISTINCT OS.[Operation], OS.[Operation], 'Operation', '01-Jan-1901', '31-Dec-9999' 
	FROM [dbo].[Organisation Structure] OS WITH (NOLOCK)
	WHERE OS.[Operation] NOT IN (	SELECT [Resource Name] 
									FROM [dbo].[Resource] R  WITH (NOLOCK)
									WHERE [Resource Type] = 'Operation'
								)
	AND OS.[Operation] NOT IN ('')

	INSERT INTO [dbo].[Resource] ([Resource Reference], [Resource Name],[Resource Type], [Start Date], [End Date])
	SELECT DISTINCT OS.[Shaft Group], OS.[Shaft Group], 'Shaft Group', '01-Jan-1901', '31-Dec-9999' 
	FROM [dbo].[Organisation Structure] OS WITH (NOLOCK)
	WHERE OS.[Shaft Group] NOT IN (	SELECT R.[Resource Name] 
									FROM [dbo].[Resource] R  WITH (NOLOCK)
									WHERE R.[Resource Type] = 'Shaft Group'
								)
	AND OS.[Shaft Group] NOT IN ('')

	INSERT INTO [dbo].[Resource] ([Resource Reference], [Resource Name],[Resource Type], [Start Date], [End Date])
	SELECT DISTINCT OS.[Shaft], OS.[Shaft], 'Shaft', '01-Jan-1901', '31-Dec-9999' 
	FROM [dbo].[Organisation Structure] OS WITH (NOLOCK)
	WHERE OS.[Shaft] NOT IN (	SELECT R.[Resource Name] 
								FROM [dbo].[Resource] R  WITH (NOLOCK)
								WHERE R.[Resource Type] = 'Shaft'
								)
	AND OS.[Shaft] NOT IN ('')

	INSERT INTO [dbo].[Resource] ([Resource Reference], [Resource Name],[Resource Type], [Start Date], [End Date])
	SELECT DISTINCT OS.[Sub Shaft], OS.[Sub Shaft], 'Sub Shaft', '01-Jan-1901', '31-Dec-9999' 
	FROM [dbo].[Organisation Structure] OS WITH (NOLOCK)
	WHERE OS.[Sub Shaft] NOT IN (	SELECT R.[Resource Name] 
									FROM [dbo].[Resource] R  WITH (NOLOCK)
									WHERE R.[Resource Type] = 'Sub Shaft'
								)
	AND OS.[Sub Shaft] NOT IN ('')

	INSERT INTO [dbo].[Resource] ([Resource Reference], [Resource Name],[Resource Type], [Start Date], [End Date])
	SELECT DISTINCT OS.[Tertiary Shaft], OS.[Tertiary Shaft], 'Tertiary Shaft', '01-Jan-1901', '31-Dec-9999' 
	FROM [dbo].[Organisation Structure] OS WITH (NOLOCK)
	WHERE OS.[Tertiary Shaft] NOT IN (	SELECT R.[Resource Name] 
									FROM [dbo].[Resource] R  WITH (NOLOCK)
									WHERE R.[Resource Type] = 'Tertiary Shaft'
									)
	AND OS.[Tertiary Shaft] NOT IN ('')

	INSERT INTO [dbo].[Resource] ([Resource Reference], [Resource Name],[Resource Type], [Start Date], [End Date])
	SELECT DISTINCT OS.[Department], OS.[Department], 'Department', '01-Jan-1901', '31-Dec-9999' 
	FROM [dbo].[Organisation Structure] OS WITH (NOLOCK)
	WHERE OS.[Department] NOT IN (	SELECT R.[Resource Name] 
									FROM [dbo].[Resource] R  WITH (NOLOCK)
									WHERE R.[Resource Type] = 'Department'
								)
	AND OS.[Department] NOT IN ('')

	INSERT INTO [dbo].[Resource] ([Resource Reference], [Resource Name],[Resource Type], [Start Date], [End Date])
	SELECT DISTINCT OS.[Unit], OS.[Unit], 'Unit', '01-Jan-1901', '31-Dec-9999' 
	FROM [dbo].[Organisation Structure] OS WITH (NOLOCK)
	WHERE OS.[Unit] NOT IN (	SELECT R.[Resource Name] 
								FROM [dbo].[Resource] R  WITH (NOLOCK)
								WHERE R.[Resource Type] = 'Unit'
								)
	AND OS.[Unit] NOT IN ('')

	INSERT INTO [dbo].[Resource] ([Resource Reference], [Resource Name],[Resource Type], [Start Date], [End Date])
	SELECT DISTINCT OS.[Section], OS.[Section], 'Section', '01-Jan-1901', '31-Dec-9999' 
	FROM [dbo].[Organisation Structure] OS WITH (NOLOCK)
	WHERE OS.[Section] NOT IN (	SELECT R.[Resource Name] 
								FROM [dbo].[Resource] R  WITH (NOLOCK)
								WHERE R.[Resource Type] = 'Section'
								)
	AND OS.[Section] NOT IN ('')

	INSERT INTO [dbo].[Resource] ([Resource Reference], [Resource Name],[Resource Type], [Start Date], [End Date])
	SELECT DISTINCT OS.[Sub Section], OS.[Sub Section], 'Sub Section', '01-Jan-1901', '31-Dec-9999' 
	FROM [dbo].[Organisation Structure] OS WITH (NOLOCK)
	WHERE OS.[Sub Section] NOT IN (	SELECT R.[Resource Name] 
									FROM [dbo].[Resource] R  WITH (NOLOCK)
									WHERE R.[Resource Type] = 'Sub Section'
								)
	AND OS.[Sub Section] NOT IN ('')

	INSERT INTO [dbo].[Resource] ([Resource Reference], [Resource Name],[Resource Type], [Start Date], [End Date])
	SELECT DISTINCT OS.[Miner], OS.[Miner], 'Miner', '01-Jan-1901', '31-Dec-9999' 
	FROM [dbo].[Organisation Structure] OS WITH (NOLOCK)
	WHERE OS.[Miner] NOT IN (	SELECT R.[Resource Name] 
								FROM [dbo].[Resource] R  WITH (NOLOCK)
								WHERE R.[Resource Type] = 'Miner'
								)
	AND OS.[Miner] NOT IN ('')

	INSERT INTO [dbo].[Resource] ([Resource Reference], [Resource Name],[Resource Type], [Start Date], [End Date])
	SELECT DISTINCT OS.[Org Unit - Gang], OS.[Org Unit - Gang], 'Org Unit - Gang', '01-Jan-1901', '31-Dec-9999' 
	FROM [dbo].[Organisation Structure] OS WITH (NOLOCK)
	WHERE OS.[Org Unit - Gang] NOT IN (	SELECT R.[Resource Name] 
									FROM [dbo].[Resource] R WITH (NOLOCK) 
									WHERE R.[Resource Type] = 'Org Unit - Gang'
									)
	AND OS.[Org Unit - Gang] NOT IN ('')

	INSERT INTO [dbo].[Resource] ([Resource Reference], [Resource Name],[Resource Type], [Start Date], [End Date])
	SELECT DISTINCT OS.[Designation], OS.[Designation], 'Designation', '01-Jan-1901', '31-Dec-9999' 
	FROM [dbo].[Organisation Structure] OS WITH (NOLOCK)
	WHERE OS.[Designation] NOT IN (	SELECT R.[Resource Name] 
									FROM [dbo].[Resource] R  WITH (NOLOCK)
									WHERE R.[Resource Type] = 'Designation'
									)
	AND OS.[Designation] NOT IN ('')

	----Housing sux.
	INSERT INTO [dbo].[Resource] ([Resource Reference], [Resource Name],[Resource Type], [Start Date], [End Date])
	SELECT REPLACE(R.[Resource Reference],T.[Old Prefix],T.[New Prefix]), REPLACE(R.[Resource Name],T.[Old Prefix],T.[New Prefix]), 'Housing', R.[Start Date], R.[End Date] 
	FROM [dbo].[Resource] R WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON 1=1
	WHERE R.[Resource Reference] LIKE '%' + T.[Old Prefix] + '%'
	And [Resource Type] = 'Housing'
	AND ( R.[Resource Reference] NOT LIKE '%' + T.[New Prefix] + '%'
		And [Resource Type] = 'Housing'
		)

	----*** If we did put duplicates in - Remove them. --script is rerunable except for housing so this is needed to fix it so it can be rerunable:( ***--
	DELETE FROM Resource
	WHERE [Resource Tag] IN (
							SELECT MAX([Resource Tag])
							FROM [Resource] 
							INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T
								ON [Resource Reference] LIKE '%' + T.[New Prefix] + '%'
							WHERE [Resource Type] = 'Housing'
							AND [Resource Reference] IN (  
														SELECT [Resource Reference] 
														FROM [dbo].[Resource] R
														WHERE [Resource Type] = 'Housing'
														GROUP BY [Resource Reference] 
														HAVING COUNT(*) > 1
														)
							GROUP BY [Resource Reference]
							)


	----*** End OS ***--
	UPDATE OS
		SET [End Date] = T.[Old Operation Termination Date]
	FROM [dbo].[Organisation Structure] OS
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T
		ON T.[Old Operation] = OS.[Operation]
	AND OS.[End date] >	T.[Old Operation Termination Date]		

	----***Rules Structure Changes ***--
	UPDATE RS
		SET [End Date] = T.[Old Operation Termination Date]
	FROM [Rules Structure] RS
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T
		ON RS.[Menu] = T.[Old Operation]
	WHERE [End Date] > T.[Old Operation Termination Date]

	INSERT INTO [dbo].[Rules Structure] ([Menu], [Start Date], [End Date])
	SELECT  T.[New Operation], '01-Jan-1901', '31-Dec-9999'
	From [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
	LEFT JOIN [Rules Structure] RS WITH (NOLOCK)
		ON [RS].[Menu] = T.[New Operation]
	WHERE RS.[Structure Entity] IS NULL
    
	IF EXISTS(SELECT DISTINCT TOP 1 R.[Resource Tag], 'Rules', RS.[Structure Entity], '01-Jan-1901','31-Dec-9999' 
				FROM [dbo].[Resource] R WITH (NOLOCK)
				INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
					ON T.[New Operation] = R.[Resource Reference]
				INNER JOIN [dbo].[Rules Structure] RS WITH (NOLOCK)
					ON T.[New Operation] = RS.[Menu]
				LEFT JOIN [Resource Instances] RI WITH (NOLOCK)
					ON [RS].[Structure Entity] = [RI].[Structure Entity]
					AND RI.[Structure] = 'Rules'
				WHERE R.[Resource Type] = 'Operation'
				AND RI.[Structure Entity] IS NULL
				)
	INSERT INTO [dbo].[Resource Instances] ([Resource Tag], [Structure], [Structure Entity], [Start Date], [End Date])
	SELECT DISTINCT TOP 1 R.[Resource Tag], 'Rules', RS.[Structure Entity], '01-Jan-1901','31-Dec-9999' 
	FROM [dbo].[Resource] R WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[New Operation] = R.[Resource Reference]
	INNER JOIN [dbo].[Rules Structure] RS WITH (NOLOCK)
		ON T.[New Operation] = RS.[Menu]
	LEFT JOIN [Resource Instances] RI WITH (NOLOCK)
		ON [RS].[Structure Entity] = [RI].[Structure Entity]
		AND RI.[Structure] = 'Rules'
	WHERE R.[Resource Type] = 'Operation'
	AND RI.[Structure Entity] IS NULL

	----*** OPR Prefix  *** --
	--INSERT INTO [dbo].[Opr Prefix] ([Operation Name], [Operation Prefix])
	--SELECT DISTINCT [New Operation], -- Operation Name - nvarchar(50)
	--       [New Prefix]  -- Operation Prefix - nvarchar(50)
	--From [GFL_Backup]..[Temp Opr Name Change ET] T
	--LEFT JOIN [Opr Prefix] OP
	--	ON OP.[Operation Name] = T.[New Operation]
	--WHERE OP.[Operation Name] IS NULL

	UPDATE OP
	SET [Operation Name] = T.[New Operation], -- Operation Name - nvarchar(50)
		[Operation Prefix] = T.[New Prefix]  -- Operation Prefix - nvarchar(50)
	From [Opr Prefix] OP
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T
		ON OP.[Operation Name] = T.[Old Operation]

	----*** Grp Remuneration Method Control  *** --
	INSERT INTO [dbo].[Grp Remuneration Method Control] ([Start Date], [End Date], [Operation], [Remuneration Method], [Service Increment Percentage], [Maximum Service Increment Percentage], [Retirement Fund], [Group Life Cover], [Medical Scheme Fund])
	SELECT GRMC.[Start Date], GRMC.[End Date], T.[New Operation], GRMC.[Remuneration Method],
			GRMC.[Service Increment Percentage], GRMC.[Maximum Service Increment Percentage],
			GRMC.[Retirement Fund], GRMC.[Group Life Cover], GRMC.[Medical Scheme Fund]
	FROM [dbo].[Grp Remuneration Method Control] GRMC WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = GRMC.[Operation]
	LEFT JOIN [dbo].[Grp Remuneration Method Control] GRMCExist WITH (NOLOCK)
		ON  GRMCExist.[Operation] = T.[New Operation] 
		And GRMCExist.[Start Date] = GRMC.[Start Date]
		AND GRMCExist.[Remuneration Method] = GRMC.[Remuneration Method] 
	WHERE GRMCExist.[Operation] IS NULL

	----*** Grp Grade Control *** --
	INSERT INTO [dbo].[Grp Grade Control] ([Start Date], [End Date], [Operation], [Grade], [Remuneration Method], [Environment], [Minimum Rate], [Maximum Rate], [Leave Scheme], [Notice Period])
	SELECT	GGC.[Start Date], GGC.[End Date], T.[New Operation], GGC.[Grade], GGC.[Remuneration Method],
	        GGC.[Environment], GGC.[Minimum Rate], GGC.[Maximum Rate], GGC.[Leave Scheme], GGC.[Notice Period]
	FROM [dbo].[Grp Grade Control] GGC WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = GGC.[Operation]
	LEFT JOIN [dbo].[Grp Grade Control] GGCExist WITH (NOLOCK)
		ON  GGCExist.[Operation] = T.[New Operation] 
		And GGCExist.[Start Date] = GGC.[Start Date]
		AND GGCExist.[Remuneration Method] = GGC.[Remuneration Method] 
		AND GGCExist.[Grade] = GGC.[Grade] 
	WHERE GGCExist.[Operation] IS NULL

	----*** Grp Payroll Tables *** --
	INSERT INTO [dbo].[Grp Payroll Tables] ([Element Description], [Lookup value 1], [Lookup value 2], [Lookup value 3], [Lookup value 4], [Lookup value 5], [Start Date], [End Date], [Amount], [Amount 2], [Amount 3], [Amount 4], [Percentage of Basic], [Minimum])
	SELECT 
		GPT.[Element Description], T.[New Operation], GPT.[Lookup value 2], GPT.[Lookup value 3], GPT.[Lookup value 4], GPT.[Lookup value 5], 
		GPT.[Start Date], GPT.[End Date], GPT.[Amount], GPT.[Amount 2], GPT.[Amount 3], GPT.[Amount 4], GPT.[Percentage of Basic], GPT.[Minimum]
	FROM [dbo].[Grp Payroll Tables] GPT WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = GPT.[Lookup Value 1]
	LEFT JOIN [dbo].[Grp Payroll Tables] GPTExist WITH (NOLOCK)
		ON  GPTExist.[Lookup value 1] = T.[New Operation] 
		AND GPTExist.[Lookup value 2] = GPT.[Lookup value 2] 
		AND GPTExist.[Lookup value 3] = GPT.[Lookup value 3] 
		AND GPTExist.[Lookup value 4] = GPT.[Lookup value 4] 
		AND GPTExist.[Lookup value 5] = GPT.[Lookup value 5] 
		AND GPTExist.[Start Date] = GPT.[Start Date]
		AND GPTExist.[Element Description] = GPT.[Element Description] 
	WHERE GPTExist.[Lookup Value 1] IS NULL
    
	--*** Grp Retrenchment *** --
	--INSERT INTO [dbo].[Grp Retrenchment] ([Resource Tag], [Operation], [Date of Agreement], [Parties to Agreement], [Remuneration Method], [Weeks Compensation For Service], [Weeks Compensation For Ex Gratia], [Months in Lieu of Notice], [Other Additional Payments], [Comments], [Overall Minimum Compensation])
	--SELECT 
	--	GR.[Resource Tag], T.[New Operation], GR.[Date of Agreement], GR.[Parties to Agreement],
	--	GR.[Remuneration Method], GR.[Weeks Compensation For Service], GR.[Weeks Compensation For Ex Gratia],
	--	GR.[Months in Lieu of Notice], GR.[Other Additional Payments], GR.[Comments], GR.[Overall Minimum Compensation]
	--FROM [dbo].[Grp Retrenchment] GR WITH (NOLOCK)
	--INNER JOIN [dbo].[GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
	--	ON T.[Old Operation] = GR.[Operation]
	--LEFT JOIN [dbo].[Grp Retrenchment] GRExist  WITH (NOLOCK) --Resource Tag, Operation, Date of Agreement, Parties to Agreement, Remuneration Method
	--	ON  GRExist.[Resource Tag] = GR.[Resource Tag] 
	--	AND GRExist.[Operation] = T.[New Operation] 
	--	And GRExist.[Date of Agreement] = GR.[Date of Agreement]
	--	AND GRExist.[Parties to Agreement] = GR.[Parties to Agreement] 
	--	AND GRExist.[Remuneration Method] = GR.[Remuneration Method] 
	--WHERE GRExist.[Operation] IS NULL
    
	UPDATE GR
	SET [Operation] = T.[New Operation]
	FROM [dbo].[Grp Retrenchment] GR
	INNER JOIN[GFL_Backup]..[Temp Opr Name Change ET] T
		ON T.[Old Operation] = GR.[Operation]

	----*** Grp Third Party Details *** --
	IF NOT EXISTS(SELECT TOP 1 1 FROM [Grp Third Party Details] GTPD  WITH (NOLOCK) INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T  WITH (NOLOCK) ON T.[New Operation] = GTPD.[Operation])
	INSERT INTO [dbo].[Grp Third Party Details] ([Operation], [Name of Third Party], [Prompt], [Physical Address Line 1], [Physical Address Line 2], [Physical Address Line 3], [Physical Address Line 4], [Physical Address Postal Code], [Postal Address Line 1], [Postal Address Line 2], [Postal Address Line 3], [Postal Address Line 4], [Postal Address Postal Code], [Contact Person], [Contact Number], [Fax Number], [E-mail Address], [Bank Name], [Bank Code], [Branch Name], [Branch Code], [Bank Branch Code], [Bank Account Type], [Bank Account Number], [Bank Account Holder Name], [Admin Fee Amount], [Admin Fee Percentage], [Coll Fee Amount], [Coll Fee Percentage], [Start Date], [End Date])
	SELECT
		T.[New Operation], GTPD.[Name of Third Party], [Prompt], GTPD.[Physical Address Line 1], GTPD.[Physical Address Line 2], GTPD.[Physical Address Line 3],
	    GTPD.[Physical Address Line 4], GTPD.[Physical Address Postal Code], GTPD.[Postal Address Line 1], GTPD.[Postal Address Line 2], GTPD.[Postal Address Line 3],
	    GTPD.[Postal Address Line 4], GTPD.[Postal Address Postal Code], GTPD.[Contact Person], GTPD.[Contact Number], [Fax Number], GTPD.[E-mail Address], [Bank Name],
	    GTPD.[Bank Code], [Branch Name], GTPD.[Branch Code], GTPD.[Bank Branch Code], GTPD.[Bank Account Type], GTPD.[Bank Account Number], GTPD.[Bank Account Holder Name],
	    GTPD.[Admin Fee Amount], GTPD.[Admin Fee Percentage], GTPD.[Coll Fee Amount], GTPD.[Coll Fee Percentage], GTPD.[Start Date], [End Date]	
	FROM [dbo].[Grp Third Party Details] GTPD WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = GTPD.[Operation]
    
	UPDATE GTPD
		SET [End Date] = T.[Old Operation Termination Date]
	FROM [dbo].[Grp Third Party Details] GTPD
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T
		ON T.[Old Operation] = GTPD.[Operation]
	WHERE [End Date] > T.[Old Operation Termination Date]

	----*** Grp Designation Control *** --
	INSERT INTO [dbo].[Grp Designation Control] ([Start Date], [End Date], [Operation], [Designation], [Metallurgical Plant Official], [Payslip Designation], [Category], [Grade], [Environment], [Remuneration Method], [Divisional Rate], [Minimum Rate], [Maximum Rate], [Recognition Unit], [Leave Scheme], [Housing Category], [Misco], [COM Code], [Job Profile], [Occupational Level], [Occupational Category], [Designation Code], [Winding Engine Driver Relief Allowance], [Charge Hand Allowance], [Service Increment], [OT Leave Qualifier], [Timestamp], [ARMS Process Status], [ARMS Process ID], [Payment ID], [Type], [GRP Minimum Rate], [GRP Maximum Rate], [Remchannel Code], [Scale], [Discipline], [Scarce Skill], [Critical Skill], [High Potential (HIPO)], [Novice Rate])
	SELECT 
		GDC.[Start Date], GDC.[End Date], T.[New Operation], GDC.[Designation], GDC.[Metallurgical Plant Official], GDC.[Payslip Designation], GDC.[Category], 
		GDC.[Grade], GDC.[Environment], GDC.[Remuneration Method], GDC.[Divisional Rate], GDC.[Minimum Rate], GDC.[Maximum Rate], GDC.[Recognition Unit],
		GDC.[Leave Scheme], GDC.[Housing Category], GDC.[Misco], GDC.[COM Code], GDC.[Job Profile], GDC.[Occupational Level], GDC.[Occupational Category],
		GDC.[Designation Code], GDC.[Winding Engine Driver Relief Allowance], GDC.[Charge Hand Allowance], GDC.[Service Increment], GDC.[OT Leave Qualifier],
		GDC.[Timestamp], GDC.[ARMS Process Status], GDC.[ARMS Process ID], GDC.[Payment ID], GDC.[Type], GDC.[GRP Minimum Rate], GDC.[GRP Maximum Rate],
		GDC.[Remchannel Code], GDC.[Scale], GDC.[Discipline], GDC.[Scarce Skill], GDC.[Critical Skill], GDC.[High Potential (HIPO)], GDC.[Novice Rate] 
	FROM [dbo].[Grp Designation Control] GDC WITH (NOLOCK)
	INNER JOIN [GFL_Backup]..[Temp Opr Name Change ET] T WITH (NOLOCK)
		ON T.[Old Operation] = GDC.[Operation]
	LEFT JOIN [dbo].[Grp Designation Control] GDCExist WITH (NOLOCK)
		ON  GDCExist.[Operation] = T.[New Operation] 
		And GDCExist.[Start Date] = GDC.[Start Date]
		AND GDCExist.[Designation] = GDC.[Designation] 
	WHERE GDC.[End Date] >= T.[Old Operation Termination Date]
	AND GDCExist.[Operation] IS NULL
	
	DROP TABLE [GFL_Backup]..[Temp Opr Name Change ET] 

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