USE [Sibanye Gold Limited]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																				CONFIGURATION CONTROL																																
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--   Place description here
--------------------------------------------------------------
--   * Modification history
--   * Version | Date     | By  | Description
--   * 1.11.01 | dd/mm/yy | PKA | Create
--------------------------------------------------------------
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																					  Main Code
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET NOCOUNT ON

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Configure Rename Script -- -- Configure Rename Script -- -- Configure Rename Script -- -- Configure Rename Script -- -- Configure Rename Script -- -- Configure Rename Script -- -- Configure Rename Script -- 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @OldName NVARCHAR(50) = 'Southgold',
		@NewName NVARCHAR(50) = 'SG Eastern Operations';


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create Working Tables-- -- Create Working Tables-- -- Create Working Tables-- -- Create Working Tables-- -- Create Working Tables-- -- Create Working Tables-- -- Create Working Tables-- -- Create Working Tables-- 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('[GFL_Backup].dbo.DB_Search') IS NOT NULL
BEGIN
	IF object_id('[GFL_Backup].dbo.DB_Search_History') IS NULL
		CREATE TABLE [GFL_Backup].dbo.DB_Search_History (
										[ID]			INT,				[TableName]		NVARCHAR(255),
										[ColumnName]	NVARCHAR(255),		[TypeName]		VARCHAR(25),
										[SQLS]			VARCHAR(MAX),		[SQLU1]			VARCHAR(MAX),
										[SQLU2]			VARCHAR(MAX),		[SQLU3]			VARCHAR(MAX),
										[Errors]		NVARCHAR(MAX),		[DataFound]		INT,
										[Duration]		INT,	[UseLongName]	INT,
										[Date] datetime	 DEFAULT GETDATE()) 
 
	INSERT INTO [GFL_Backup].dbo.DB_Search_History(ID,TableName,ColumnName,TypeName,SQLS,SQLU1,SQLU2,SQLU3,Errors,DataFound,Duration,UseLongName)
	SELECT     ID,TableName,ColumnName,TypeName,SQLS,SQLU1,SQLU2,SQLU3,Errors,DataFound,Duration,UseLongName FROM 	[GFL_Backup].dbo.DB_Search  
	DROP TABLE [GFL_Backup].dbo.DB_Search
END

--------
CREATE TABLE [GFL_Backup].dbo.DB_Search (
	[ID]			INT IDENTITY(1,1),
	[OldName]		NVARCHAR(50),
	[NewName]		NVARCHAR(50),
	[TableName]		NVARCHAR(255),
	[ColumnName]	NVARCHAR(255),
	[TypeName]		VARCHAR(25),
	[SQLS]			VARCHAR(MAX),
	[SQLU1]			VARCHAR(MAX),
	[SQLU2]			VARCHAR(MAX),
	[SQLU3]			VARCHAR(MAX),
	[Errors]		NVARCHAR(MAX),
	[DataFound]		INT,
	[Duration]		INT,
	[UseLongName]	INT,
	[HasTriggers]	INT,
	[DisableTriggers]	INT,
	[SchemaName]	NVARCHAR(20)
)

IF OBJECT_ID('[GFL_Backup].dbo.DB_Search_ResourceTags') IS NOT NULL
	DROP TABLE [GFL_Backup].dbo.DB_Search_ResourceTags

CREATE TABLE [GFL_Backup].dbo.DB_Search_ResourceTags (
	[Resource Tag]	INT,
	[TableName] NVARCHAR(128),
	[RTFieldName] NVARCHAR(128)
	)

IF OBJECT_ID('[GFL_Backup].dbo.DB_Search_Exclusions ') IS NOT NULL
	DROP TABLE [GFL_Backup].dbo.[DB_Search_Exclusions] 


CREATE TABLE [GFL_Backup].dbo.[DB_Search_Exclusions]  (
	[TableName] NVARCHAR(128),
	[ColumnName] NVARCHAR(128)
)


--SELECT DISTINCT [TableName], [sqlu1] FROM [GFL_Backup].dbo.[DB_Search] WHERE	[DataFound] = 1
--SELECT TOP 100 * FROM
-- [dbo].[User Prompts] S  WHERE (S.[Active] LIKE '%GFPS%' OR S.[Codeset] LIKE '%GFPS%' OR S.[Field Description] LIKE '%GFPS%' OR S.[Field Value] LIKE '%GFPS%' OR S.[Prompt] LIKE '%GFPS%' OR S.[TA Code] LIKE '%GFPS%');
--  SELECT * FROM [Resource]WHERE [Resource Tag] = 2130085917

 
INSERT INTO [GFL_Backup].dbo.[DB_Search_Exclusions] ([TableName])
	SELECT 'Audit Log'

UNION SELECT 'WH backup rename'
--UNION SELECT 'SYS TA RULES'
UNION SELECT 'Emp Work History Data'
UNION SELECT 'ARMS Reminder Transactions'
UNION SELECT 'Grp RSC by Operation - Section'
UNION SELECT 'Cursor Source Table'
UNION SELECT 'accident report'
UNION SELECT 'Backup Structure'
--UNION SELECT 'Data Prompt Definitions'
UNION SELECT 'EMP CHANGE CONTROL AUDIT'
UNION SELECT 'Batch Processing Log'
UNION SELECT 'Batch Processing'
UNION SELECT 'Batch Processing Details'
UNION SELECT 'New Structure Echo'
UNION SELECT 'OUG Discipline'
UNION SELECT 'OPR Course Facilitator'
UNION SELECT 'OPR Course '
UNION SELECT 'Oug Budgeted Complement Business PLAN'
UNION SELECT 'Oug Budgeted Complement Revised PLAN'
UNION SELECT 'Oug assignment NO'
--UNION SELECT 'Opr Unit Discipline'
UNION SELECT 'Con Contractor details'
UNION SELECT 'Data client scripts'
UNION SELECT 'WH backup rename'
--UNION SELECT 'SYS TA RULES'
UNION SELECT 'Emp Work History Data'
UNION SELECT 'ARMS Reminder Transactions'
UNION SELECT 'Grp RSC by Operation - Section'
UNION SELECT 'Cursor Source Table'
UNION SELECT 'accident report'
UNION SELECT 'Backup Structure'
UNION SELECT 'EMP CHANGE CONTROL AUDIT'
UNION SELECT 'Batch Processing Log'
UNION SELECT 'Batch Processing'
UNION SELECT 'Batch Processing Details'
UNION SELECT 'New Structure Echo'
--UNION SELECT 'Opr Accommodation Inventory Deleted'
--UNION SELECT 'Opr Grievances'
UNION SELECT 'Opr Grievances Enquiry'
UNION SELECT 'EMP Control Increase 07'
UNION SELECT 'Emp Permit'
UNION SELECT 'GRP Designation Control Increase 07'
UNION SELECT 'Grp Designation Control Wed'
UNION SELECT 'HRS Work History Old'
UNION SELECT 'IBM CHANGE CONTROL AUDIT'
UNION SELECT 'IBM Data Change LOG'
UNION SELECT 'IX Index Helper'
UNION SELECT 'Old Scaling Designations'
UNION SELECT 'Rpte Report References Rerun 10-Sep-2008 Interim'
UNION SELECT 'Symplexity Change CONTROL'
UNION SELECT 'DB_Search'
UNION SELECT 'DB_Searchx'
UNION SELECT 'DB_Search_Exclusions'
UNION SELECT 'DB_Searchx_Exclusions'
UNION SELECT 'DB_Search_ResourceTags'
UNION SELECT 'DB_Searchx_ResourceTags'
UNION SELECT 'Beneficiaries'
UNION SELECT 'Biographical'
UNION SELECT 'Bur Full-Time Applicant Details'
UNION SELECT 'Bur Technikon Applicant Details'
UNION SELECT 'Bur University Applicant Details'
UNION SELECT 'Help'
UNION SELECT 'Mine Workers Identification'
UNION SELECT 'Periodic Schedule'
UNION SELECT 'TEBA Contract'
UNION SELECT 'Termination Control'
UNION SELECT 'Work Permits'
UNION SELECT 'Employee Scheduling'
UNION SELECT 'CO TAX RSA'
UNION SELECT 'Process Status History'
UNION SELECT 'EMP TA ACTUALS EDIT'
UNION SELECT 'Rpt Payslip Calendars'
UNION SELECT 'Interface Output Transactions'
UNION SELECT 'Interface Resource Values'
UNION SELECT 'Script Audit'
UNION SELECT 'Emp Output Transactions Leave Payslip'
UNION SELECT 'Process Status'
UNION SELECT 'Process Collections'
UNION SELECT 'Rpt Payslip Rates'
UNION SELECT 'Interface Output Costs'
UNION SELECT 'emp ta elements history'
UNION SELECT 'Audit Control'
UNION SELECT 'Resource Audit TA Control'
UNION SELECT 'Emp Last Payrun Details'
UNION SELECT 'Emp Absence Schedule'
UNION SELECT 'Process Occurrences'
UNION SELECT 'Employee''s Industry Number'
UNION SELECT 'Engagement Control'
UNION SELECT 'Certificates'
UNION SELECT 'tempSowGFTSGFBLA'
UNION SELECT 'Table Audit'
UNION SELECT 'Organisation Structure'
UNION SELECT 'ESOPS Combined Service'
UNION SELECT 'ESOPS Gold Fields Service Data Edited'
UNION SELECT 'ESOPS EMP Service Days Detail'
UNION SELECT 'ESOPS Dim Time'
UNION SELECT 'ESOPS HRS Work History'
UNION SELECT 'ESOPS Emp Service Data'
UNION SELECT 'ESOPS Service Start Dates'
UNION SELECT 'ESOPS Share Allocation'
UNION SELECT 'ESOPS Combined Service Days Summed'
UNION SELECT 'ESOPS Emp Termination'
UNION SELECT 'ESOPS Emp Work History'
UNION SELECT 'ESOPS Goldfields Service Data Verified'
UNION SELECT 'ESOPS Shares and Dividends'
UNION SELECT 'ESOPS Share Allocation Days'
UNION SELECT 'ESOPS Share Allocation'
UNION SELECT 'ESOPS Service Work History'
UNION SELECT 'ESOPS Unique Combined Service'
UNION SELECT 'Process Master'
UNION SELECT 'Process Steps'
UNION SELECT 'Process Step Routing'
UNION SELECT 'Process Occurances'
UNION SELECT 'AA_Archive_ETAD'
UNION SELECT 'ARMS Images'
UNION SELECT 'ARMS Raise Logs'
UNION SELECT 'Resource Audit'
UNION SELECT 'Resource'
UNION SELECT 'Sys TA Absence Transaction Rules'
UNION SELECT 'sys rsa company additional details GFL'
UNION SELECT 'Sys TA Default Shift Patterns'
UNION SELECT 'Sys TA Shift Pattern Parameters'
UNION SELECT 'TAD All Shifts'
UNION SELECT 'TAD Strike Shifts'
UNION SELECT 'Tax Year End Log'
UNION SELECT 'TEBA Recruitment Requisition'
UNION SELECT 'UIF File Details'
UNION SELECT 'Users'
UNION SELECT 'Assignment Operation'
UNION SELECT 'Backup Designations'
UNION SELECT 'Batch Transfer Audit'
UNION SELECT 'BI HR Organisation Structure Mapping'
UNION SELECT 'BI Leave Liability Totals'
UNION SELECT 'BI Users'
UNION SELECT 'Ctl RMA and Capitation Control Table'
UNION SELECT 'Ctl RSC Control TABLE'
UNION SELECT 'Data Screens Original'
UNION SELECT 'Designation Mapping All'
UNION SELECT 'Designation Mapping Employee GFPS'
UNION SELECT 'EE Recruitment Detail'
UNION SELECT 'emp absence delete'
UNION SELECT 'Emp Absence Request'
--UNION SELECT 'Emp Accommodation Allocated'
--UNION SELECT 'Emp Accommodation Allocated inserted'
UNION SELECT 'Emp Appeal'
UNION SELECT 'Emp Attributes'
UNION SELECT 'Emp Batch Transfer'
UNION SELECT 'Emp Cash Advance Request'
UNION SELECT 'Emp Control'
UNION SELECT 'Emp ER Counselling'
UNION SELECT 'Emp Exit Interview'
UNION SELECT 'Emp Exit Rating'
UNION SELECT 'Emp Incident/Transgression Report'
UNION SELECT 'Emp Leave Balances'
UNION SELECT 'Emp Leave Voucher (Annexure A)'
UNION SELECT 'Emp Leave Voucher History'
UNION SELECT 'Emp Movement Audit'
--UNION SELECT 'Emp Pay Point'
UNION SELECT 'Emp Rate History'
UNION SELECT 'Emp Relocation Allowance'
UNION SELECT 'Emp Rented From Details'
UNION SELECT 'Emp Rented To Details'
UNION SELECT 'Emp TA Actuals'
UNION SELECT 'Emp TA Detail'
UNION SELECT 'Emp TA Detail History'
UNION SELECT 'emp ta edits'
UNION SELECT 'EMP TA SHOW SHIFT PATTERNS'
UNION SELECT 'Emp Termination'
UNION SELECT 'Emp Wellness Interface'
UNION SELECT 'Emp Work History'
UNION SELECT 'Emp Work History old'
UNION SELECT 'Emp Work History Scaling'
UNION SELECT 'Gold Fields Service Data Edited'
UNION SELECT 'Grp Designation Control'
UNION SELECT 'Grp Designation Control Scaling'
UNION SELECT 'GRP Designation Generic'
UNION SELECT 'GRP Employee ESS Access'
UNION SELECT 'Grp Grade Control'
UNION SELECT 'Grp Leave Schemes'
UNION SELECT 'GRP Officials Industry No'
UNION SELECT 'Grp Payroll Tables'
UNION SELECT 'Grp Payslip Message'
UNION SELECT 'Grp Remuneration Method Control'
UNION SELECT 'Grp Third Party Details'
UNION SELECT 'Hospital Timesheet'
UNION SELECT 'HRS Work History'
UNION SELECT 'Input Transactions (Leave)'
UNION SELECT 'Input Transactions Authorised (Deductions)'
UNION SELECT 'Input Transactions Authorised (Earnings)'
UNION SELECT 'InterFace Error Table'
UNION SELECT 'Interface File Names'
UNION SELECT 'Interface file names_temp'
UNION SELECT 'Interface GFL TA Proc Parameters'
UNION SELECT 'Interface Job Log'
UNION SELECT 'Interface Operation'
UNION SELECT 'Interface Operation Bank Detail'
UNION SELECT 'Interface Operation Code Map'
UNION SELECT 'Interface Operation Group'
UNION SELECT 'Interface Operation Group Lookup'
UNION SELECT 'Interface Resource Control'
UNION SELECT 'Interface SAP Cost Numbers'
UNION SELECT 'Manning Board'
UNION SELECT 'Manning Board Detail'
UNION SELECT 'NDAWO Interface'
UNION SELECT 'Official Upload Final'
UNION SELECT 'Opr Assignment Number'
UNION SELECT 'Opr Cessation Days'
UNION SELECT 'Opr Prefix'
UNION SELECT 'Organisation Structure Scaling'
UNION SELECT 'Organisation Structure Validated'
UNION SELECT 'OT Period ID Mapping'
UNION SELECT 'PalladiumHR_Load'
UNION SELECT 'PER REM Package'
UNION SELECT 'PER SYS Change Control Audit'
UNION SELECT 'PER TAX Certificate Errors MTD'
UNION SELECT 'PER TAX Certificate TYE'
UNION SELECT 'PER TAX RSA Certificate Extract Errors'
UNION SELECT 'PER TAX RSA Certificates'
UNION SELECT 'PER TAX RSA Year-end Company Control'
UNION SELECT 'Procedure Step Duration'
UNION SELECT 'QA Earnings'
UNION SELECT 'RECON Organisation Structure'
UNION SELECT 'RECON RESOURCE'
UNION SELECT 'Requisition Control'
UNION SELECT 'Resource-grp'
UNION SELECT 'Rpt Pay Cycle Table'
UNION SELECT 'Rpt Payslip Error Tbl'
UNION SELECT 'Rpt Scheduler Reports'
UNION SELECT 'Rpt Scheduler Users'
UNION SELECT 'RPT Sentinel Tbl'
UNION SELECT 'rpt ytd sdl'
UNION SELECT 'rpt ytd tax'
UNION SELECT 'rpt ytd UIF'
UNION SELECT 'RPTE Error LOG'
UNION SELECT 'RPTE Report References'
UNION SELECT 'Rules Structure'
UNION SELECT 'SAP Default Assignment Numbers'
UNION SELECT 'Scheduler Report Pool'
UNION SELECT 'Scheduler Report Pool History'
UNION SELECT 'Scheduler Script Pool History'
UNION SELECT 'Security Screen Groups'
UNION SELECT 'Security Screen Groups Original'
UNION SELECT 'Security Structure Group'
UNION SELECT 'Security Structure Groups'
UNION SELECT 'Security User Designation Profile'
UNION SELECT 'Security User Screen Groups'
UNION SELECT 'Security User Structure Profile'
UNION SELECT 'Sys Personal Employment Details'








--UNION SELECT 'Interface Operation Group'
--UNION SELECT 'Interface Operation Group Lookup'
--UNION SELECT 'Interface Operation Code Map'
--UNION SELECT 'Interface File NAMES'
--UNION SELECT 'Data Screens'
--UNION SELECT 'Requisition Control'

-- Column Names to exclude when builing initial list --
INSERT INTO [GFL_Backup].dbo.[DB_Search_Exclusions] ([ColumnName])
	SELECT SC.name FROM sysobjects SO JOIN sys.syscolumns SC ON SO.id = SC.id AND SO.type = 'u' AND SC.name LIKE '% date%'
UNION SELECT 'ARMS Process Status'
UNION SELECT 'Field Name'
UNION SELECT 'Table Name'
UNION SELECT 'Prompt'
UNION SELECT 'Resource Type'
UNION SELECT 'Prompt Name'
UNION SELECT 'Screen Name'
UNION SELECT 'User ID'
UNION SELECT 'Run Type'
UNION SELECT 'Gender'
UNION SELECT 'ID Number'
UNION SELECT 'Industry Number'
UNION SELECT 'Payment ID'
UNION SELECT 'Initials'
UNION SELECT 'Assignment Number'
UNION SELECT 'Back Pay'
UNION SELECT 'Movement Type'
UNION SELECT 'Movement Reason'
UNION SELECT 'RunType'
UNION SELECT 'Passport Number'
UNION SELECT 'Family Name'
UNION SELECT 'Grade'
UNION SELECT 'Home Language'
UNION SELECT 'Surname'
UNION SELECT 'Requestor Industry Number'
UNION SELECT 'Race'
UNION SELECT 'HLA'
UNION SELECT 'Step Name'
UNION SELECT 'Accommodation Cost'
UNION SELECT 'Contact Person'
UNION SELECT 'Geographical Heritage'
UNION SELECT 'Transport Cost'
UNION SELECT 'Branch Code'
UNION SELECT 'Employee Type'
UNION SELECT 'Termination Date'
UNION SELECT 'Housing Category'
UNION SELECT 'Bank Name'
UNION SELECT 'Ethnic Group'
UNION SELECT 'Telephone Number'
UNION SELECT 'Income Tax Reference Number'
UNION SELECT 'Contact Number'
UNION SELECT 'To Remuneration Method'
UNION SELECT 'Preferred Name'
UNION SELECT 'Accommodation Type'
UNION SELECT 'To Grade'
UNION SELECT 'Occupational Category'
UNION SELECT 'Marital Status'
UNION SELECT 'Certificate Number'
UNION SELECT 'Verifier (Name)'
UNION SELECT 'Verifier (Industry Number)'
UNION SELECT 'First Name'
UNION SELECT 'Attendance Code'
UNION SELECT 'Display Option'
UNION SELECT 'Requestor Name'
UNION SELECT 'Absence Reason'
UNION SELECT 'Leave Type'
UNION SELECT 'Clocker'
UNION SELECT 'Absence Transaction'
UNION SELECT 'Literacy Level'
UNION SELECT 'Cancelled By (Industry Number)'
UNION SELECT 'Literacy Type'
UNION SELECT 'Course Duration'
UNION SELECT 'Shift Type'
UNION SELECT 'Cancelled By (Name)'
UNION SELECT '3rd Assessment Outcome'
UNION SELECT 'GFTS Resource Tag'
UNION SELECT 'Day of Week'
UNION SELECT 'Middle Name'
UNION SELECT 'Expected at Work'
UNION SELECT 'E-mail Address'
UNION SELECT 'To Payment ID'
UNION SELECT 'Status'
UNION SELECT 'Given Name'
UNION SELECT 'Type of Assessment'
UNION SELECT 'Shift Pattern'
UNION SELECT 'Structure Group'
UNION SELECT 'Group'
UNION SELECT 'Trading Name'
UNION SELECT SC.NAME FROM sysobjects SO JOIN syscolumns SC ON SO.id = SC.id WHERE	SO.type = 'u'	 AND SC.name LIKE '%resource tag%'
--UNION SELECT SC.NAME FROM sysobjects SO JOIN syscolumns SC ON SO.id = SC.id WHERE	SO.type = 'u' AND SO.name = 'Organisation Structure' AND SC.name NOT LIKE '%Operation%'
--UNION SELECT SC.NAME FROM sysobjects SO JOIN syscolumns SC ON SO.id = SC.id WHERE	SO.type = 'u' AND SO.name = 'Emp Work History' AND SC.name NOT LIKE '%Operation%'
--UNION SELECT SC.NAME FROM sysobjects SO JOIN syscolumns SC ON SO.id = SC.id WHERE	SO.type = 'u' AND (SC.name LIKE '%Shaft%' OR SC.name LIKE '%Region%' OR  SC.name LIKE '%Section%')  


-- Get Resource Tags of Employees and Structure
INSERT INTO [GFL_Backup].dbo.[db_Search_ResourceTags] ([Resource Tag])
SELECT [Resource Tag] FROM [Resource] WHERE	[Resource Reference] LIKE '%'+@OldName+'%'
UNION 
SELECT [Resource Tag] FROM [Emp Work History] WHERE	[To Operation] LIKE '%'+@OldName+'%' OR [From Operation] LIKE '%'+@OldName+'%'

INSERT INTO [GFL_Backup].dbo.[db_Search_ResourceTags] ([TableName], [RTFieldName])
SELECT 'Emp Absence Schedule', 'Resource Tag'
UNION SELECT 'Per_Lve_PreRequest', 'Resource Tag'
UNION SELECT 'PER LVE Absence Request', 'Resource Tag'
UNION SELECT 'PER LVE Absence Amend', 'Resource Tag'
UNION SELECT 'PER LVE Absence Delete', 'Resource Tag'
UNION SELECT 'Emp Training Session Booking', 'Resource Tag'
UNION SELECT 'Input Transactions', 'Resource Tag'
UNION SELECT 'Input Transactions 112', 'Resource Tag'
UNION SELECT 'Input Transactions 112_1', 'Resource Tag'
UNION SELECT 'Output Transactions', 'Resource Tag'
UNION SELECT 'Resource Audit', 'Resource Tag'
UNION SELECT 'Rpt Payslip Precalc Tbl', 'Resource Tag'


INSERT INTO [GFL_Backup].dbo.DB_Search
	([OldName], [NewName], [TableName], [ColumnName], [TypeName], [HasTriggers], [schemaName])
SELECT	DISTINCT
		@OldName,
		@NewName,
		SO.name,
		SC.name,
		CASE WHEN ST.NAME IN ('varchar', 'sysname') THEN 'nvarchar' ELSE ST.name END,
		CASE WHEN SOT.name IS NULL THEN 0 ELSE 1 END,
		SS.NAME	
FROM	sysobjects SO
		JOIN syscolumns SC
		ON SO.id = SC.id
		AND SC.colstat = 0
		JOIN sys.schemas SS
		ON SS.schema_id = SO.uid
		JOIN systypes ST
		ON ST.type = SC.type
		LEFT JOIN [GFL_Backup].dbo.[DB_Search_Exclusions] EXCOL
		ON EXCOL.[ColumnName] = SC.name
		LEFT JOIN [GFL_Backup].dbo.[DB_Search_Exclusions] EXTAB
		ON EXTAB.[TableName] = SO.name
		LEFT JOIN sysobjects SOT
		ON SO.id = SOT.parent_obj
		AND SOT.xtype = 'TR'
WHERE	SO.type = 'u'
	AND ST.name IN ('varchar', 'nvarchar', 'text')
	AND EXCOL.[ColumnName] IS NULL
	AND EXTAB.[TableName] IS NULL

ORDER BY SO.name, SC.name


-- Setup LongName Use --
UPDATE	[GFL_Backup].dbo.[DB_Search] SET [uselongname] = 0 

-- Setup Disble Trigger Use --
--UPDATE	[GFL_Backup].dbo.[DB_Search] SET [DisableTriggers] = 1 WHERE	[TableName] = 'Emp Exit Interview'

-- Tables to update Without having to search through them first --
--UPDATE	GFL_Backup.dbo.[DB_Search] SET [DataFound] = 2, [Duration] = 9999999 WHERE	TableName IN ('Resource Audit', 'Batch Processing Details')
--UPDATE	[gfl_backup].dbo.db_search SET [Errors] = 'Run Last' WHERE	[TableName] IN ('Resource Audit', 'Batch Processing Details')


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates --
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates ---- Manual Updates --
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--UPDATE GFL_Backup.dbo.DB_Search SET [DataFound] = 9  WHERE	[TableName] != 'Emp Pay Point'
--SELECT * FROM GFL_Backup.dbo.DB_Search WHERE	[TableName] = 'Emp Pay Point'



GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Int, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)
SET @User = 'Jaco J v Vuuren'
SET @IssueNumber = 'SYM41057'
SET @ScriptName = 'SYM41057-301 JvV SGEO - Setup Rename.sql'
SET @Description = 'Setup - Rename Southgold to Sibanye Gold Eastern Operations'
SET @DataChange = 1 -- 0 = Object 1=Data, 3=Data (priority change), 4=Object (priority change)
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'Template Master' 
SET @Version = '2.4.2'
SET @SpecialInstructions = ''
SET @LoggedBy = 'Hannes Scheepers'
SET @VerifiedBy = 'Peet Schultz'
Set @Identity = -1

Exec SYMsp_SymplexityChangeCTRL 1, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy

GO
