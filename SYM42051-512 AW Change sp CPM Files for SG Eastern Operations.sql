USE [Sibanye Gold Limited]

/*------------------------------------------------------------------------------------------------------------------------------------------------------
  CONFIGURATION CONTROL																																
-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
  Place code here
-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Modification history
* Version | Date     | By  | Description
* 1.9.01  | dd/mm/yy | ??? | Create
------------------------------------------------------------------------------------------------------------------------------------------------------*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
/****************************************************************************************
   Main Code
****************************************************************************************/

USE [Sibanye Gold Limited]
GO

/****** Object:  StoredProcedure [dbo].[sp_CPM_files]    Script Date: 2015-03-18 10:05:47 AM ******/
DROP PROCEDURE [dbo].[sp_CPM_files]
GO

/****** Object:  StoredProcedure [dbo].[sp_CPM_files]    Script Date: 2015-03-18 10:05:47 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

CREATE	 PROCEDURE [dbo].[sp_CPM_files]
AS -- ********************************************************************************************************************
-- 						CHANGE HISTORY LOG
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 04 Aug 2005
-- AUTHOR				: Ina Johns
-- CHANGE REFERENCE		: Request 1058575 PVCS vs 1.0
-- DESCRIPTION OF CHANGE: Create a store proc to create the DCBONUS export file and then copy the file to the CPM server.
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 16 Aug 2005
-- AUTHOR				: Ina Johns
-- CHANGE REFERENCE		: Request 1058575 PVCS vs 1.1
-- DESCRIPTION OF CHANGE: Start the sp_interfacescheduler at step 4 in order to skip the consolidation.
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 30 May 2006
-- AUTHOR				: Linda Shanks
-- CHANGE REFERENCE		: Request 1245630
-- DESCRIPTION OF CHANGE: Copy the new Bonus recon file to the DC server.
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 29 Sep 2006
-- AUTHOR				: Thando Nyamane		
-- CHANGE REFERENCE		: Request 1451123
-- DESCRIPTION OF CHANGE: Copy the E-Learning Interface files to E-learning servers.
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 01 Nov 2006
-- AUTHOR				: Ina Johns & Dina Kassen
-- CHANGE REFERENCE		: Request 1591380
-- DESCRIPTION OF CHANGE: Copy the FS Attendance Analysis file for Beatrix after the file is produced after the 
--			  interface run at 2:00AM.	
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 09 Nov 2006
-- AUTHOR				: Thando Nyamane
-- CHANGE REFERENCE		: Request 1181690
-- DESCRIPTION OF CHANGE: Create the DC Import Messages file and then copy the file to the server.
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 07 Mar 2008
-- AUTHOR				: Ina Johns
-- CHANGE REFERENCE		: Request ZA-02206880
-- DESCRIPTION OF CHANGE: Copy the KCBONUS export file to \\172.21.32.37\pers\arms. Also change the xp_cmdshell command
--						  to show the full path and file name
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 10 Mar 2008
-- AUTHOR				: Ina Johns
-- CHANGE REFERENCE		: Request ZA-02282317
-- DESCRIPTION OF CHANGE: Copy the SDBONUS export file to \\172.16.181.53\PERS\ARMS.
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 14 Mar 2008
-- AUTHOR				: Ina Johns
-- CHANGE REFERENCE		: Request ZA-02282317
-- DESCRIPTION OF CHANGE: Change the way to determine the server name.
--						  It was @@servername and change to (SELECT CONVERT(char(20), SERVERPROPERTY('servername')))
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 09 Jul 2008
-- AUTHOR				: Ina Johns
-- CHANGE REFERENCE		: HEAT 258
-- DESCRIPTION OF CHANGE: Copy the BEBONUS export file to \\172.21.96.23\cpm\pers\arms.
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 07 Aug 2008
-- AUTHOR				: Petro Dyksman
-- CHANGE REFERENCE		: HEAT 510
-- DESCRIPTION OF CHANGE: Copy the BEBONUSSACO export file to \\172.21.96.23\cpm\pers\arms.
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 19 Aug 2008
-- AUTHOR				: Petro Dyksman
-- CHANGE REFERENCE		: HEAT 595
-- DESCRIPTION OF CHANGE: Change copy statement that uses old Reporting server name (gfl-rep) to use ip address in stead.
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 28 Aug 2008
-- AUTHOR				: Petro Dyksman
-- CHANGE REFERENCE		: HEAT 589
-- DESCRIPTION OF CHANGE: Add Shared Services - copy Bonus file to same location as DRF files
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 28 Jan 2009
-- AUTHOR				: Monika le Roux
-- CHANGE REFERENCE		: HEAT 1646
-- DESCRIPTION OF CHANGE: Remove Copy the BEBONUSSACO export file to \\172.21.96.23\cpm\pers\arms.
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 15-Apr-2009
-- AUTHOR				: Monika le Roux
-- CHANGE REFERENCE		: HEAT 2288
-- DESCRIPTION OF CHANGE: Add Copy Bonus file for GFFH, GFFP, GFWH, GFWP, Sibanye Gold, GFPS,GFTS
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 22 Nov 2010
-- AUTHOR				: Peet Schultz
-- CHANGE REFERENCE		: GFL01340
-- DESCRIPTION OF CHANGE: Remove all Copy procedures, the files will now be copied by a SSIS job
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 30 Jul 2012
-- AUTHOR				: Annemarie Wessels
-- CHANGE REFERENCE		: SYM10817
-- DESCRIPTION OF CHANGE: Change to Use Bonus biographical and not the Biographical
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 01 Jul 2013
-- AUTHOR				: Annemarie Wessels
-- CHANGE REFERENCE		: SYM20207
-- DESCRIPTION OF CHANGE: Change to Use Bonus biographical and not the Biographical
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 28 May 2014
-- AUTHOR				: Annemarie Wessels
-- CHANGE REFERENCE		: SYM31031
-- DESCRIPTION OF CHANGE: Add Rand Uranium to the SP
-- ********************************************************************************************************************
-- DATE OF CHANGE		: 18 Mar 2015
-- AUTHOR				: Annemarie Wessels
-- CHANGE REFERENCE		: SYM42051
-- DESCRIPTION OF CHANGE: Add SG Eastern Operations to the SP
-- ********************************************************************************************************************

/*Start of request 1591380*/
    DECLARE @AttendTime DATETIME ,
        @AttendCount INT ,
        @AttendOperation VARCHAR(50) ,
        @AttendSQL VARCHAR(4000) ,
        @CurrentFileName VARCHAR(50) ,
        @ReportNameNew VARCHAR(50) ,
        @NewFileName VARCHAR(50)
/*End of request 1591380*/

 --EXEC sp_CPM_files

--***************************************************************************************************************************
/*Start of request 1591380*/

            --WHILE ( SELECT  COUNT(1)
            --        FROM    [Scheduler Report Pool] WITH ( NOLOCK )
            --        WHERE   ISNULL([Status], 'Processing') IN ( 'Processing',
            --                                                  'Awaiting TA' )
            --                AND [Report Name] IN ( 'FS Attendance Analysis' )
            --                AND [USER] = 'BTXHR'
            --      ) > 0 
            --    BEGIN
            --        SET @AttendTime = ( SELECT  DATEADD(SS, 10, GETDATE())
            --                          )
            --        SELECT  @attendtime
            --        WAITFOR TIME @AttendTime
            --    END

            --SET @AttendTime = ( SELECT  DATEADD(SS, 10, GETDATE())
            --                  )
            --WAITFOR TIME @AttendTime

            --SELECT  RRR.[Report Name] ,
            --        RRR.[Storage Reference] ,
            --        RRR.[User] ,
            --        LEFT(RRR.[Storage Reference],
            --             LEN(RRR.[Storage Reference]) - 3) + '.rsf' AS [FileName]
            --INTO    #AttendAnal
            --FROM    [Rpte Report References] RRR WITH ( NOLOCK )
            --        INNER JOIN [Scheduler Report Pool] SRP WITH ( NOLOCK ) ON RRR.[Report Name] = SRP.[Report Name]
            --                                                  AND RRR.[Rpt Param String] LIKE SRP.[Parameter string]
            --WHERE   RRR.[Report Name] IN ( 'FS Attendance Analysis' )
            --        AND SRP.[Status] = 'Succesful'
            --        AND RRR.[USER] = 'BTXHR'  


            --SET @AttendCount = ( SELECT COUNT(1)
            --                     FROM   #AttendAnal
            --                   )

            --WHILE ( SELECT  COUNT(1)
            --        FROM    #AttendAnal
            --      ) > 0 
            --    BEGIN
            --        SET @CurrentFileName = ( SELECT TOP 1
            --                                        [FileName]
            --                                 FROM   #AttendAnal
            --                               )
            --        SET @ReportNameNew = ( SELECT   [Report Name]
            --                               FROM     #AttendAnal
            --                               WHERE    [FileName] = @CurrentFileName
            --                             )
            --        SET @AttendOperation = ( SELECT DISTINCT
            --                                        [Operation]
            --                                 FROM   #AttendAnal
            --                                        INNER JOIN [Rpt Scheduler Users] RSU ON #AttendAnal.[User] = RSU.[User Name]
            --                                 WHERE  [FileName] = @CurrentFileName
            --                               )
            --        SET @NewFileName = ( SELECT REPLACE(@ReportNameNew, ' ',
            --                                            '') + '.CSV'
            --                           )
            --        SET @AttendSQL = 'COPY "\\172.21.16.112\CentralReportStore\reportstore\"'
            --            + @CurrentFileName
            --            + ' "\\172.21.16.112\Interface\Beatrix\Output Files\TA\"'
            --            + @NewFileName -- HEAT 595 Added

            --        PRINT '@CurrentFileName : '
            --            + CONVERT(VARCHAR(1000), @CurrentFileName)
            --        PRINT '@NewFileName : '
            --            + CONVERT(VARCHAR(1000), @NewFileName)
            --        PRINT '@AttendSQL : ' + CONVERT(VARCHAR(1000), @AttendSQL)

            --        EXEC master..xp_cmdshell @AttendSQL, NO_OUTPUT

            --        DELETE  FROM #AttendAnal
            --        WHERE   [FileName] = @CurrentFileName
            --    END
            --PRINT CONVERT(VARCHAR, @AttendCount)
            --    + ' File(s) Copied for FS Attendance Analysis for Beatrix'



---------------------------------------------------------------------------
-- Copy Bonus Info Rport files as well
-------------------------------------------------------------------------------


            DECLARE @CPM DATETIME
	
            WHILE ( SELECT  COUNT(*)
                    FROM    [Scheduler Report Pool] WITH ( NOLOCK )
                    WHERE   ISNULL([Status], 'Processing') = 'Processing'
                            AND [Report Name] IN ( 'Org Unit Detail',
                                                   'Org Unit Summary',
                                                   'Interface Error Report',
                                                   'Bonus Biographical DE' )
                  ) > 0 
                BEGIN
                    SET @CPM = ( SELECT DATEADD(SS, 10, GETDATE())
                               )
	
                    WAITFOR TIME @CPM
                END
	
            SET @CPM = ( SELECT DATEADD(SS, 10, GETDATE())
                       )
	
            WAITFOR TIME @CPM
	
            --SELECT  [Report Name] ,
            --        [Storage Reference] ,
            --        [User] ,
            --        LEFT([Storage Reference], LEN([Storage Reference]) - 3)
            --        + '.rsf' AS [FileName]
            --INTO    #CPM
            --FROM    [Rpte Report References] WITH ( NOLOCK )
            --WHERE   [Date Run] > DATEADD(dd, -5, GETDATE())
            --        AND [Report Name] IN ( 'Org Unit Detail',
            --                               'Org Unit Summary',
            --                               'Interface Error Report',
            --                               'Bonus Biographical DE' )		-- Request 1181690 PVCS vs 2.9 added 'Interface Error Report'
            --        AND [Rpt Param String] LIKE '%@DateFrom='
            --        + REPLACE(CONVERT(VARCHAR, CONVERT(DATETIME, DATEADD(dd,
            --                                                  -1, GETDATE())), 106),
            --                  ' ', '-') + ';' + '%'
            --        AND [Rpt Param String] LIKE '%@DateTo='
            --        + REPLACE(CONVERT(VARCHAR, CONVERT(DATETIME, DATEADD(dd,
            --                                                  -1, GETDATE())), 106),
            --                  ' ', '-') + ';' + '%'


			SELECT  [rr].[Report Name] ,  --SYM20207 
                    [Storage Reference] ,
                    [rr].[User] ,
                    LEFT([Storage Reference], LEN([Storage Reference]) - 3)
                    + '.rsf' AS [FileName]

           INTO    #CPM
            FROM    [Rpte Report References] as [rr] WITH ( NOLOCK )
                     inner join
                     (

            SELECT  [rr].[Report Name] 
                                  ,[rr].[user]
                                  ,max([Date Run]) as [Date Run]
         
            FROM    [Rpte Report References] as [rr] WITH ( NOLOCK )
                     inner join
                           (
                                  select max(convert(date,(Substring([RPT Param String],
								  (Charindex('@DateFrom=',[RPT Param String])+10),11)))) as [Date]
                                  ,[Report Name],[User]
                                  FROM    [Rpte Report References] WITH ( NOLOCK )
                                  WHERE   [Date Run] > DATEADD(dd, -2, GETDATE())
                    AND [Report Name] IN ( 'Org Unit Detail','Org Unit Summary','Interface Error Report','Bonus Biographical DE' )
                    --AND ( [User] LIKE '%Reports'          OR    s LIKE '%HR' )
					AND ISDATE(SUBSTRING([RPT Param String],(CHARINDEX('@DateFrom=',[RPT Param String])+10),11)) = 1
                                  GROUP BY [Report Name],[User]                          
                           )     AS [md]       
                                  ON
                                  [md].[Report Name] = [rr].[Report Name]
                                  AND
                                  [md].[date] =   SUBSTRING([RPT Param String],(CHARINDEX('@DateFrom=',[RPT Param String])+10),11)
                                  AND
                                  [md].[user] = [rr].[user]                  
                     WHERE
                           [Date Run] > DATEADD(dd, -2, GETDATE())    
                           
                     GROUP BY
                                  [rr].[Report Name] ,[rr].[user]

                     ) AS [mr]
                     ON
                     [mr].[Report Name] = [rr].[Report Name]
                     AND
                     [mr].[Date Run] = [rr].[Date Run] 
                     AND
                     [mr].[user] = [rr].[user]         


                     WHERE
                           [rr].[Date Run] > DATEADD(dd, -2, GETDATE())    

         
            DECLARE @CPMCount INT
            DECLARE @CPMOperation VARCHAR(50)
            DECLARE @CPMSQL VARCHAR(4000)
		

            SET @CPMCount = ( SELECT    COUNT(*)
                              FROM      #CPM
                            )

            WHILE ( SELECT  COUNT(*)
                    FROM    #CPM
                  ) > 0 
                BEGIN
                    SET @CurrentFileName = ( SELECT TOP 1
                                                    [FileName]
                                             FROM   #CPM
                                           )
                    SET @ReportNameNew = ( SELECT   CASE WHEN [Report Name] = 'Bonus Biographical DE'
                                                         THEN 'EmployeeBio'
                                                         ELSE [Report Name]
                                                    END
                                           FROM     #CPM
                                           WHERE    [FileName] = @CurrentFileName
                                         )
                    SET @CPMOperation = ( SELECT DISTINCT
                                                    CASE WHEN ( [Operation] = 'Sibanye Gold' OR [Operation] = 'Rand Uranium' OR [Operation] = 'SG Eastern Operations')  --SYM31031
                                                         THEN REPLACE([Operation],
                                                              ' ', '_')
                                                         ELSE [Operation]
                                                    END
                                          FROM      #CPM
                                                    INNER JOIN [Rpt Scheduler Users] RSU ON #CPM.[User] = RSU.[User Name]
                                          WHERE     [FileName] = @CurrentFileName
                                        )
                    SET @NewFileName = ( SELECT REPLACE(@ReportNameNew, ' ',
                                                        '') + '_'
                                                + @CPMOperation + '.CSV'
                                       )
			
			-----Copy Files to Local server as well---
   --                 SET @CPMSQL = 'COPY \\172.21.16.112\CentralReportStore\reportstore\'
   --                     + @CurrentFileName
   --                     + ' "\\172.21.16.112\Arms\Interface\GFL\Output Files\BONUS\'
   --                     + @NewFileName + '"'
   --                 EXEC master..xp_cmdshell @CPMsql


    --Copy Files to Local server as well---
                    SET @CPMSQL = 'COPY \\gfsa-symsqlrep\CentralReportStore\reportstore\'
                        + @CurrentFileName
                        + ' "\\gfsa-symsqlrep\Arms\Interface\GFL\Output Files\BONUS\'
                        + @NewFileName + '"'
                    EXEC master..xp_cmdshell @CPMsql


			----------------------------------		

	
                    DELETE  FROM #CPM
                    WHERE   [FileName] = @CurrentFileName
                --END
            PRINT CONVERT(VARCHAR, @CPMCount) + ' File(s) Copied for CPM'



        END

/*------------------------------------------------------------------
	Sub section
-------------------------------------------------------------------*/
-------------------------------------------------------------------------------------------------------------------------

GO

    
DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Int, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)
SET @User = 'Annemarie Wessels'
SET @IssueNumber = 'SYM42051'
SET @ScriptName = 'SYM42051-512 AW Change sp CPM Files for SG Eastern Operations.sql'
SET @Description = 'Change sp CPM Files for SG Eastern Operations'
SET @DataChange = 0 -- 0 = Object 1=Data, 3=Data (priority change), 4=Object (priority change)
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'STORED PROC' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'sp_CPM_files' 
SET @Version = '2.4.3'
SET @SpecialInstructions = ''
SET @LoggedBy = 'Hannes Scheepers'
SET @VerifiedBy = 'Karen Steenkamp'
Set @Identity = -1

Exec SYMsp_SymplexityChangeCTRL 1, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy

GO
