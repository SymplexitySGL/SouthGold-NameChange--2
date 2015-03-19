USE [Sibanye Gold Limited]
/*------------------------------------------------------------------------
  CONFIGURATION CONTROL																																
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
  Place description here
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
* Modification history
* Version | Date     | By  | Description
* 1.11.01 | dd/mm/yy | PKA | Create
------------------------------------------------------------------------*/
/****************************************************************************************
   Insert Audit entry
****************************************************************************************/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Int, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)
SET @User = 'Annemarie Wessels'
SET @IssueNumber = 'SYM42051'
SET @ScriptName = 'SYM42051-503 AW SG Eastern Update Interface file names.sql'
SET @Description = 'Insert Interface file names for SG Eastern'
SET @DataChange = 0 -- 0 = Object 1=Data, 3=Data (priority change), 4=Object (priority change)
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'Interface File Names'
SET @Version = '2.4.2'
SET @SpecialInstructions = ''
SET @LoggedBy = 'Hannes Scheepers'
SET @VerifiedBy = 'Karen Steenkamp'
Exec SYMsp_SymplexityChangeCTRL 0, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy
Begin Try
Begin Transaction
/****************************************************************************************
   Main Code
****************************************************************************************/

--SELECT 'Interface File Names' AS descr, * FROM [dbo].[Interface File Names] WHERE [Operation Group] like '%Southgold%' 
--SELECT 'Interface File Names' AS descr, * FROM [dbo].[Interface File Names] WHERE [Operation Group] like '%Sibanye Gold%' 
--SELECT 'Interface File Names' AS descr, * FROM [dbo].[Interface File Names] WHERE [Operation Group] lIKE '%SG Eastern Operations%' 
--SELECT 'Interface Operation Group Lookup' AS descr, * FROM [dbo].[Interface Operation Group Lookup] WHERE [Operation Group] like 'SouthGold%'  
--SELECT 'Interface Operation Group Lookup' AS descr, * FROM [dbo].[Interface Operation Group Lookup] WHERE [Operation Group] lIKE 'SG Eastern Operations%'
--SELECT 'Interface Operation Group' AS descr, * FROM [dbo].[Interface Operation Group] WHERE [Operation Group] like '%SouthGold%'  
--SELECT 'Interface Operation Group' AS descr, * FROM [dbo].[Interface Operation Group] WHERE [Operation Group] lIKE '%SG Eastern Operations%'
--SELECT [description], COUNT(*) FROM [dbo].[Interface File Names] 
----GROUP BY [description] HAVING COUNT(*) > 1

IF OBJECT_ID('[GFL_Backup].[dbo].[Interface File Names NamechangeSG]') IS NOT NULL 
   DROP TABLE [GFL_Backup].[dbo].[Interface File Names NamechangeSG]

CREATE TABLE [GFL_Backup].[dbo].[Interface File Names NamechangeSG]
    (
	[File ID] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[Group ID] [int] NOT NULL,
	[Operation Group] [nvarchar](50) NOT NULL,
	[Layout ID] [int] NOT NULL,
	[File Export] [nvarchar](1) NOT NULL,
	[Create File] [nvarchar](1) NOT NULL,
	[Replicate] [nvarchar](1) NOT NULL,
	[Require Period ID] [nvarchar](1) NOT NULL,
	[Convert Via Interface] [nvarchar](1) NOT NULL,
	[File Alias Name] [nvarchar](50) NULL,
	[File Name] [nvarchar](100) NOT NULL,
	[File Path] [nvarchar](200) NOT NULL,
	[Distribution Contact Type] [nvarchar](50) NULL,
	[Distribution Address] [nvarchar](50) NULL,
	[Distribution Contact Detail] [nvarchar](50) NULL,
	[Frequency] [nvarchar](50) NULL,
	[Sequence Start] [int] NOT NULL,
	[Group Control Code] [int] NULL,
	[Type Of Service] [int] NULL,
	[TSN ID] [nvarchar](6) NULL,
) 

INSERT INTO [GFL_Backup].[dbo].[Interface File Names NamechangeSG]
    (
	[File ID],
	[Description],
	[Group ID],
	[Operation Group],
	[Layout ID],
	[File Export],
	[Create File],
	[Replicate],
	[Require Period ID],
	[Convert Via Interface],
	[File Alias Name],
	[File Name],
	[File Path],
	[Distribution Contact Type],
	[Distribution Address],
	[Distribution Contact Detail],
	[Frequency],
	[Sequence Start],
	[Group Control Code],
	[Type Of Service],
	[TSN ID]
)
SELECT * 
FROM  [Sibanye Gold Limited].[dbo].[Interface File Names]


Delete From [Interface Run Detail] where [File ID] in (Select [File ID] From [Interface File Names] Where [Operation Group] like 'SG Eastern Operations%')

Delete From [Interface Relations Join Globals] where [File ID] in (Select [File ID] From [Interface File Names] Where [Operation Group] like 'SG Eastern Operations%')

Delete From [Interface File Names] Where [Operation Group] = 'SG Eastern Operations%'
--SELECT* FROM [Interface File Names] Where [Operation Group] = 'SGS%'

--SGS
IF OBJECT_ID('tempdb..#SGSTemp') IS NOT NULL DROP TABLE #SGSTemp 

SELECT    
            [File Id]
           ,[Description]
           ,[Group ID]
           ,REPLACE([Operation Group],'SouthGold', 'SG Eastern Operations')  AS [Operation Group]
           ,[Layout ID]
           ,[File Export]
           ,[Create File]
           ,[Replicate]
           ,[Require Period ID]
           ,[Convert Via Interface]
           ,[File Alias Name]
           ,[File Name]
           ,Replace([File Path], '\SouthGold\', '\SG Eastern Operations\') AS [File Path]
           ,[Distribution Contact Type]
           ,[Distribution Address]
           ,[Distribution Contact Detail]
           ,[Frequency]
           ,[Sequence Start]
           ,[Group Control Code]
           ,[Type Of Service]
           ,[TSN ID]
INTO #SGSTemp

FROM
			[Interface File Names]
WHERE 
			[Operation Group] LIKE 'SouthGold%' 
		
--SELECT * FROM #SGSTemp

ALTER TABLE [interface file names] NOCHECK CONSTRAINT ALL
ALTER TABLE [Interface Operation Group Lookup] NOCHECK CONSTRAINT ALL
ALTER TABLE [Interface Operation Group] NOCHECK CONSTRAINT ALL

Delete From [Interface Run Detail] where [File ID] in (Select [File ID] From [Interface File Names] Where [Operation Group] LIKE 'SouthGold%')

Delete From [Interface Relations Join Globals] where [File ID] in (Select [File ID] From [Interface File Names] Where [Operation Group] LIKE 'SouthGold%')

--SELECT *  FROM [interface file names] WHERE [Operation Group] = 'GFPS%'
--SELECT * FROM [dbo].[Interface Operation Group Lookup] WHERE [Operation Group] like 'GFPS%'
--SELECT * FROM [dbo].[Interface Operation Group] WHERE [Operation Group] like 'GFPS%'

DELETE FROM [interface file names] WHERE [Operation Group] LIKE 'Southgold%'
DELETE FROM [dbo].[Interface Operation Group Lookup] WHERE [Operation Group] like 'SouthGold%'
DELETE FROM [dbo].[Interface Operation Group] WHERE [Operation Group] like 'SouthGold%'

ALTER TABLE [interface file names] CHECK CONSTRAINT ALL 
ALTER TABLE [Interface Operation Group Lookup] CHECK CONSTRAINT ALL
ALTER TABLE [Interface Operation Group] CHECK CONSTRAINT ALL


INSERT INTO [Interface File Names]
           ([File ID]
           ,[Description]
           ,[Group ID]
           ,[Operation Group]
           ,[Layout ID]
           ,[File Export]
           ,[Create File]
           ,[Replicate]
           ,[Require Period ID]
           ,[Convert Via Interface]
           ,[File Alias Name]
           ,[File Name]
           ,[File Path]
           ,[Distribution Contact Type]
           ,[Distribution Address]
           ,[Distribution Contact Detail]
           ,[Frequency]
           ,[Sequence Start]
           ,[Group Control Code]
           ,[Type Of Service]
           ,[TSN ID])
SELECT * 
FROM #SGSTemp

--SELECT * FROM [dbo].[Interface File Names] WHERE [Operation Group]= 'GFPS' 
--SELECT * FROM [dbo].[Interface File Names] WHERE [Operation Group]= 'SGS' 


/*------------------------------------------------------------------
	Sub section
-------------------------------------------------------------------*/
/*------------------------------------------------------------------
	Log Resource Audit Log
-------------------------------------------------------------------*/

--insert into @tbRT (resourcetag) 
--	select 2130142470

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
