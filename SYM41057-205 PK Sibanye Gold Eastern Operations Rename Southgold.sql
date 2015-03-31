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
/*------------------------------------------------------------------
	Sub section
-------------------------------------------------------------------*/


DECLARE @OldOp NVARCHAR(20),
@NewOp NVARCHAR(20)




SET @OldOp ='Southgold'
SET @NewOp = 'SGEO'

---- Secondments over 1 Feb


DECLARE @Restag INT,
@SD DATETIME,
@ED DATETIME,
@MT NVARCHAR(50),
@TOrg NVARCHAR(100),
@TDesig NVARCHAR(100),
@ToSE INT,
@FOrg NVARCHAR(100),
@FDesig NVARCHAR(100),
@FromSE INT,
@PayID NVARCHAR(20),
@count INT,
@i INT


SET @i = 0


SET @count = (SELECT COUNT(*)
FROM    [dbo].[Emp Work History] EWH
    WHERE   ( '20150301' BETWEEN [Start Date] AND [End Date] AND [Start Date] <> '20150301' )
            AND CASE WHEN [Movement Type] LIKE '%second%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END = 'Southgold'
            AND [Movement Type] NOT LIKE '%term%'
            AND [Movement Type] LIKE '%second%')
            
    



DECLARE WHSec CURSOR
FOR
    SELECT  [Resource Tag] ,
            [Start Date] ,
            [End Date] ,
            [Movement Type] ,
            [To Org Unit - Gang] ,
            [To Designation] ,
            [To Structure Entity] ,
            [From Org Unit - Gang] ,
            [From Designation] ,
            [From Structure Entity] ,
            [To Payment ID]
    FROM    [dbo].[Emp Work History] EWH
    WHERE   ( '20150301' BETWEEN [Start Date] AND [End Date] AND [Start Date] <> '20150301' )
            AND CASE WHEN [Movement Type] LIKE '%second%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END = 'Southgold'
            AND [Movement Type] NOT LIKE '%term%'
            AND [Movement Type] LIKE '%second%'
            
    ORDER BY [Resource Tag] ,
            [Start Date]




OPEN WHSec

FETCH NEXT FROM WHSec INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

WHILE @@FETCH_STATUS <> -1

BEGIN

DECLARE @NewSE INT
DECLARE @NewED DATETIME

SET @NewED = (SELECT DATEADD(dd,-1,MIN([Start Date])) FROM [dbo].[Emp Work History] WHERE [Resource Tag] = @Restag AND [Start Date] > '20150301')

IF @NewED IS NULL
BEGIN
SET @NewED = '99991231'
END
SET @NewSE = (SELECT TOP 1 [Structure Entity] FROM [dbo].[Organisation Structure] WHERE [Designation] = @FDesig AND [Org Unit - Gang] = REPLACE(@FOrg,@OldOp,@NewOp))



SET @i = @i + 1

PRINT '---Busy with ' + CAST(@Restag AS NVARCHAR(20)) + ' no ' + CAST(@i AS NVARCHAR(10)) + ' out of ' + CAST(@count AS NVARCHAR(10)) + '----'


INSERT INTO [dbo].[Emp Work History]
        ( [Resource Tag] ,
          [Start Date] ,
          [End Date] ,
          [Movement Type] ,
          [To Structure Entity] ,
          [To Payment ID] 
         
        )
VALUES  ( @Restag, -- Resource Tag - int
          '20150301' , -- Start Date - datetime
          '20150301' , -- End Date - datetime
          'Transfer',
		  @NewSE,
		  @PayID
        )




INSERT INTO [dbo].[Emp Work History]
        ( [Resource Tag] ,
          [Start Date] ,
          [End Date] ,
          [Movement Type] ,
          [To Structure Entity] ,
          [To Payment ID] 
         
        )
VALUES  ( @Restag, -- Resource Tag - int
          '20150302' , -- Start Date - datetime
          @NewED , -- End Date - datetime
          'Secondment',
		  @ToSE,
		  @PayID
        )


FETCH NEXT FROM WHSec INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

END

CLOSE WHSec
DEALLOCATE WHSec





GO


--- NOn Secondments over 1 Feb

DECLARE @OldOp NVARCHAR(20),
@NewOp NVARCHAR(20)




SET @OldOp = 'SGE'
SET @NewOp = 'SGEO'

DECLARE @Restag INT,
@SD DATETIME,
@ED DATETIME,
@MT NVARCHAR(50),
@TOrg NVARCHAR(100),
@TDesig NVARCHAR(100),
@ToSE INT,
@FOrg NVARCHAR(100),
@FDesig NVARCHAR(100),
@FromSE INT,
@PayID NVARCHAR(20),
@count INT,
@i INT



SET @i = 0


SET @count = (SELECT COUNT(*)
FROM    [dbo].[Emp Work History] EWH
    WHERE   ( '20150301' BETWEEN [Start Date] AND [End Date] AND [Start Date] <> '20150301' )
            AND CASE WHEN [Movement Type]  LIKE '%second%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END = 'Southgold'
				AND [Movement Type] NOT LIKE '%Second%'
            AND [Movement Type] NOT LIKE '%term%')




DECLARE WHNSEc CURSOR
FOR
    SELECT  [Resource Tag] ,
            [Start Date] ,
            [End Date] ,
            [Movement Type] ,
            [To Org Unit - Gang] ,
            [To Designation] ,
            [To Structure Entity] ,
            [From Org Unit - Gang] ,
            [From Designation] ,
            [From Structure Entity] ,
            [To Payment ID]
    FROM    [dbo].[Emp Work History] EWH
    WHERE   ( '20150301' BETWEEN [Start Date] AND [End Date] AND [Start Date] <> '20150301' )
            AND CASE WHEN [Movement Type]  LIKE '%second%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END = 'Southgold'
				AND [Movement Type] NOT LIKE '%Second%'
            AND [Movement Type] NOT LIKE '%term%'
           
            
    ORDER BY [Resource Tag] ,
            [Start Date]




OPEN WHNSEc

FETCH NEXT FROM WHNSEc INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

WHILE @@FETCH_STATUS <> -1

BEGIN

DECLARE @NewSE INT
DECLARE @NewED DATETIME

SET @i = @i + 1

PRINT '---Busy with ' + CAST(@Restag AS NVARCHAR(20)) + ' no ' + CAST(@i AS NVARCHAR(10)) + ' out of ' + CAST(@count AS NVARCHAR(10)) + '----'

SET @NewED = (SELECT DATEADD(dd,-1,MIN([Start Date])) FROM [dbo].[Emp Work History] WHERE [Resource Tag] = @Restag AND [Start Date] > '20150301')

IF @NewED IS NULL
BEGIN
SET @NewED = '99991231'
END
SET @NewSE = (SELECT TOP 1 [Structure Entity] FROM [dbo].[Organisation Structure] WHERE [Designation] = @TDesig AND [Org Unit - Gang] = REPLACE(@TOrg,@OldOp,@NewOp))

PRINT  @NewSE

PRINT @NewED


INSERT INTO [dbo].[Emp Work History]
        ( [Resource Tag] ,
          [Start Date] ,
          [End Date] ,
          [Movement Type] ,
          [To Structure Entity] ,
          [To Payment ID] 
         
        )
VALUES  ( @Restag, -- Resource Tag - int
          '20150301' , -- Start Date - datetime
          @NewED , -- End Date - datetime
          'Transfer',
		  @NewSE,
		  @PayID
        )






FETCH NEXT FROM WHNSEc INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

END

CLOSE WHNSEc
DEALLOCATE WHNSEc






GO


--ANY record greater than 1 feb non secondments

DECLARE @OldOp NVARCHAR(20),
@NewOp NVARCHAR(20)




SET @OldOp = 'SGE'
SET @NewOp = 'SGEO'


DECLARE @Restag INT,
@SD DATETIME,
@ED DATETIME,
@MT NVARCHAR(50),
@TOrg NVARCHAR(100),
@TDesig NVARCHAR(100),
@ToSE INT,
@FOrg NVARCHAR(100),
@FDesig NVARCHAR(100),
@FromSE INT,
@PayID NVARCHAR(20),
@count INT,
@i INT



SET @i = 0


SET @count = (SELECT COUNT(*)
 FROM    [dbo].[Emp Work History] EWH
    WHERE    [Start Date] > '20150301' 
            AND CASE WHEN [Movement Type] LIKE '%second%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END = 'Southgold'
            AND [Movement Type] NOT LIKE '%term%'
            AND [Movement Type] NOT LIKE '%second%')




DECLARE WH CURSOR
FOR
    SELECT  [Resource Tag] ,
            [Start Date] ,
            [End Date] ,
            [Movement Type] ,
            [To Org Unit - Gang] ,
            [To Designation] ,
            [To Structure Entity] ,
            [From Org Unit - Gang] ,
            [From Designation] ,
            [From Structure Entity] ,
            [To Payment ID]
    FROM    [dbo].[Emp Work History] EWH
    WHERE    [Start Date] > '20150301' 
            AND CASE WHEN [Movement Type] LIKE '%second%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END = 'Southgold'
            AND [Movement Type] NOT LIKE '%term%'
            AND [Movement Type] NOT LIKE '%second%'
            
    ORDER BY [Resource Tag] ,
            [Start Date]




OPEN WH

FETCH NEXT FROM WH INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

WHILE @@FETCH_STATUS <> -1

BEGIN

DECLARE @NewSE INT
DECLARE @NewED DATETIME

SET @i = @i + 1
PRINT '---Busy with ' + CAST(@Restag AS NVARCHAR(20)) + ' no ' + CAST(@i AS NVARCHAR(10)) + ' out of ' + CAST(@count AS NVARCHAR(10)) + '----'

SET @NewSE = (SELECT TOP 1 [Structure Entity] FROM [dbo].[Organisation Structure] WHERE [Designation] = @TDesig AND [Org Unit - Gang] = REPLACE(@TOrg,@OldOp,@NewOp))

PRINT @NewSE


UPDATE [dbo].[Emp Work History] SET [To Structure Entity] = @NewSE WHERE [Resource Tag] =@Restag AND [Start Date] = @SD




FETCH NEXT FROM WH INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

END

CLOSE WH
DEALLOCATE WH




GO



---Secondments greater than 1 Feb



DECLARE @OldOp NVARCHAR(20),
@NewOp NVARCHAR(20)




SET @OldOp = 'SGE'
SET @NewOp = 'SGEO'

DECLARE @Restag INT,
@SD DATETIME,
@ED DATETIME,
@MT NVARCHAR(50),
@TOrg NVARCHAR(100),
@TDesig NVARCHAR(100),
@ToSE INT,
@FOrg NVARCHAR(100),
@FDesig NVARCHAR(100),
@FromSE INT,
@PayID NVARCHAR(20),
@count INT,
@i INT



SET @i = 0


SET @count = (SELECT COUNT(*)
 FROM    [dbo].[Emp Work History] EWH
    WHERE   (  [Start Date] > '20150301' )
            AND CASE WHEN [Movement Type]  LIKE '%second%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END = 'Southgold'
            AND [Movement Type] NOT LIKE '%term%'
			AND [Movement Type] LIKE '%Second%')




DECLARE WHNSEc CURSOR
FOR
    SELECT  [Resource Tag] ,
            [Start Date] ,
            [End Date] ,
            [Movement Type] ,
            [To Org Unit - Gang] ,
            [To Designation] ,
            [To Structure Entity] ,
            [From Org Unit - Gang] ,
            [From Designation] ,
            [From Structure Entity] ,
            [To Payment ID]
    FROM    [dbo].[Emp Work History] EWH
    WHERE   (  [Start Date] > '20150301' )
            AND CASE WHEN [Movement Type]  LIKE '%second%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END = 'Southgold'
            AND [Movement Type] NOT LIKE '%term%'
			AND [Movement Type] LIKE '%Second%'
           
            
    ORDER BY [Resource Tag] ,
            [Start Date]




OPEN WHNSEc

FETCH NEXT FROM WHNSEc INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

WHILE @@FETCH_STATUS <> -1

BEGIN

DECLARE @NewSE INT
DECLARE @NewED DATETIME

SET @i = @i + 1

PRINT '---Busy with ' + CAST(@Restag AS NVARCHAR(20)) + ' no ' + CAST(@i AS NVARCHAR(10)) + ' out of ' + CAST(@count AS NVARCHAR(10)) + '----'


SET @NewED = (SELECT DATEADD(dd,-1,MIN([Start Date])) FROM [dbo].[Emp Work History] WHERE [Resource Tag] = @Restag AND [Start Date] > '20150301')

IF @NewED IS NULL
BEGIN
SET @NewED = '99991231'
END
SET @NewSE = (SELECT TOP 1 [Structure Entity] FROM [dbo].[Organisation Structure] WHERE [Designation] = @FDesig AND [Org Unit - Gang] = REPLACE(@FOrg,@OldOp,@NewOp))

PRINT @NewSE

PRINT @NewED


UPDATE [dbo].[Emp Work History] SET [To Structure Entity] = @ToSE WHERE [Resource Tag] =@Restag AND [Start Date] = @SD





FETCH NEXT FROM WHNSEc INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

END

CLOSE WHNSEc
DEALLOCATE WHNSEc



GO
---- Terminations





DECLARE @OldOp NVARCHAR(20),
@NewOp NVARCHAR(20)




SET @OldOp = 'SGE'
SET @NewOp = 'SGEO'

DECLARE @Restag INT,
@SD DATETIME,
@ED DATETIME,
@MT NVARCHAR(50),
@TOrg NVARCHAR(100),
@TDesig NVARCHAR(100),
@ToSE INT,
@FOrg NVARCHAR(100),
@FDesig NVARCHAR(100),
@FromSE INT,
@PayID NVARCHAR(20),
@count INT,
@i INT



SET @i = 0


SET @count = (SELECT COUNT(*)
 FROM    [dbo].[Emp Work History] EWH
    WHERE   (  '20150301' BETWEEN [Start Date] AND [End Date] OR [Start Date] > '20150301' )
            AND CASE WHEN [Movement Type]  LIKE '%second%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END = 'Southgold'
            AND [Movement Type]  LIKE '%term%')




DECLARE WHNSEc CURSOR
FOR
    SELECT  [Resource Tag] ,
            [Start Date] ,
            [End Date] ,
            [Movement Type] ,
            [To Org Unit - Gang] ,
            [To Designation] ,
            [To Structure Entity] ,
            [From Org Unit - Gang] ,
            [From Designation] ,
            [From Structure Entity] ,
            [To Payment ID]
    FROM    [dbo].[Emp Work History] EWH
    WHERE   (  '20150301' BETWEEN [Start Date] AND [End Date] OR [Start Date] > '20150301' )
            AND CASE WHEN [Movement Type]  LIKE '%second%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END = 'Southgold'
            AND [Movement Type]  LIKE '%term%'
           
            
    ORDER BY [Resource Tag] ,
            [Start Date]




OPEN WHNSEc

FETCH NEXT FROM WHNSEc INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

WHILE @@FETCH_STATUS <> -1

BEGIN

DECLARE @NewSE INT
DECLARE @NewED DATETIME


SET @i = @i + 1
PRINT '---Busy with ' + CAST(@Restag AS NVARCHAR(20)) + ' no ' + CAST(@i AS NVARCHAR(10)) + ' out of ' + CAST(@count AS NVARCHAR(10)) + '----'


SET @NewED = (SELECT DATEADD(dd,-1,MIN([Start Date])) FROM [dbo].[Emp Work History] WHERE [Resource Tag] = @Restag AND [Start Date] >= '20150301')

IF @NewED IS NULL
BEGIN
SET @NewED = '99991231'
END
SET @NewSE = (SELECT TOP 1 [Structure Entity] FROM [dbo].[Organisation Structure] WHERE [Designation] = @TDesig AND [Org Unit - Gang] = REPLACE(@TOrg,@OldOp,@NewOp))

PRINT @NewSE

PRINT @NewED


UPDATE [dbo].[Emp Work History] SET [To Structure Entity] = @NewSE WHERE [Resource Tag] =@Restag AND [Start Date] = @SD





FETCH NEXT FROM WHNSEc INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

END

CLOSE WHNSEc
DEALLOCATE WHNSEc


GO



--




--- 1 Feb Excptions








DECLARE @OldOp NVARCHAR(20),
@NewOp NVARCHAR(20)




SET @OldOp = 'SGE'
SET @NewOp = 'SGEO'

DECLARE @Restag INT,
@SD DATETIME,
@ED DATETIME,
@MT NVARCHAR(50),
@TOrg NVARCHAR(100),
@TDesig NVARCHAR(100),
@ToSE INT,
@FOrg NVARCHAR(100),
@FDesig NVARCHAR(100),
@FromSE INT,
@PayID NVARCHAR(20),
@count INT,
@i INT



SET @i = 0


SET @count = (SELECT COUNT(*)
 FROM    [dbo].[Emp Work History] EWH
   
    WHERE   (  [Start Date] = '20150301' )
            AND CASE WHEN [Movement Type]  LIKE '%second%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END = 'Southgold'
            AND [Movement Type] not LIKE '%term%')




DECLARE WHNSEc CURSOR
FOR
    SELECT  [Resource Tag] ,
            [Start Date] ,
            [End Date] ,
            [Movement Type] ,
            [To Org Unit - Gang] ,
            [To Designation] ,
            [To Structure Entity] ,
            [From Org Unit - Gang] ,
            [From Designation] ,
            [From Structure Entity] ,
            [To Payment ID]
    FROM    [dbo].[Emp Work History] EWH
    WHERE   (  [Start Date] = '20150301' )
            AND CASE WHEN [Movement Type]  LIKE '%second%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END = 'Southgold'
            AND [Movement Type] not LIKE '%term%'
           
            
    ORDER BY [Resource Tag] ,
            [Start Date]




OPEN WHNSEc

FETCH NEXT FROM WHNSEc INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

WHILE @@FETCH_STATUS <> -1

BEGIN

DECLARE @NewSE INT
DECLARE @NewED DATETIME


SET @i = @i + 1
PRINT '---Busy with ' + CAST(@Restag AS NVARCHAR(20)) + ' no ' + CAST(@i AS NVARCHAR(10)) + ' out of ' + CAST(@count AS NVARCHAR(10)) + '----'


SET @NewED = (SELECT DATEADD(dd,-1,MIN([Start Date])) FROM [dbo].[Emp Work History] WHERE [Resource Tag] = @Restag AND [Start Date] >= '20150301')

IF @NewED IS NULL
BEGIN
SET @NewED = '99991231'
END
SET @NewSE = (SELECT TOP 1 [Structure Entity] FROM [dbo].[Organisation Structure] WHERE [Designation] = @TDesig AND [Org Unit - Gang] = REPLACE(@TOrg,@OldOp,@NewOp))

PRINT @NewSE

PRINT @NewED


UPDATE [dbo].[Emp Work History] SET [To Structure Entity] = @NewSE WHERE [Resource Tag] =@Restag AND [Start Date] = @SD





FETCH NEXT FROM WHNSEc INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

END

CLOSE WHNSEc
DEALLOCATE WHNSEc



GO

---- Acting on 1 Feb--

DECLARE @OldOp NVARCHAR(20),
@NewOp NVARCHAR(20)




SET @OldOp = 'SGE'
SET @NewOp = 'SGEO'

DECLARE @Restag INT,
@SD DATETIME,
@ED DATETIME,
@MT NVARCHAR(50),
@TOrg NVARCHAR(100),
@TDesig NVARCHAR(100),
@ToSE INT,
@FOrg NVARCHAR(100),
@FDesig NVARCHAR(100),
@FromSE INT,
@PayID NVARCHAR(20),
@count INT,
@i INT


SET @i = 0


SET @count = (SELECT COUNT(*)
FROM    [dbo].[Emp Work History] EWH
    WHERE   ( '20150301' BETWEEN [Start Date] AND [End Date] AND [Start Date] = '20150301' )
            AND CASE WHEN [Movement Type] LIKE '%actin%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END = 'Southgold'
            AND [Movement Type] NOT LIKE '%term%'
            AND [Movement Type] LIKE '%acting%')
			--AND [Resource Tag] = 100374402)
            
    



DECLARE WHSec CURSOR
FOR
    SELECT  [Resource Tag] ,
            [Start Date] ,
            [End Date] ,
            [Movement Type] ,
            [To Org Unit - Gang] ,
            [To Designation] ,
            [To Structure Entity] ,
            [From Org Unit - Gang] ,
            [From Designation] ,
            [From Structure Entity] ,
            [To Payment ID]
    FROM    [dbo].[Emp Work History] EWH
    WHERE   ( '20150301' BETWEEN [Start Date] AND [End Date] AND [Start Date] = '20150301' )
            AND CASE WHEN [Movement Type] LIKE '%acting%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END =@OldOp
            AND [Movement Type] NOT LIKE '%term%'
            AND [Movement Type] LIKE '%acting%'
			--AND [Resource Tag] = 100374402
            
    ORDER BY [Resource Tag] ,
            [Start Date]







OPEN WHSec

FETCH NEXT FROM WHSec INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

WHILE @@FETCH_STATUS <> -1

BEGIN

DECLARE @NewSE INT
DECLARE @NewED DATETIME

SET @NewED = (SELECT DATEADD(dd,-1,MIN([Start Date])) FROM [dbo].[Emp Work History] WHERE [Resource Tag] = @Restag AND [Start Date] > '20150301')

IF @NewED IS NULL
BEGIN
SET @NewED = '99991231'
END
SET @NewSE = (SELECT TOP 1 [Structure Entity] FROM [dbo].[Organisation Structure] WHERE [Designation] = @FDesig AND [Org Unit - Gang] = REPLACE(@FOrg,@OldOp,@NewOp))



SET @i = @i + 1

PRINT '---Busy with ' + CAST(@Restag AS NVARCHAR(20)) + ' no ' + CAST(@i AS NVARCHAR(10)) + ' out of ' + CAST(@count AS NVARCHAR(10)) + '----'


--UPDATE [dbo].[Emp Work History] SET [End Date] = '20150301' WHERE [Resource Tag] = @Restag AND [Start Date] = @SD

INSERT INTO [dbo].[Emp Work History]
        ( [Resource Tag] ,
          [Start Date] ,
          [End Date] ,
          [Movement Type] ,
          [To Structure Entity] ,
          [To Payment ID] 
         
        )
VALUES  ( @Restag, -- Resource Tag - int
          '20150302' , -- Start Date - datetime
          '20150302' , -- End Date - datetime
          'Transfer',
		  @NewSE,
		  @PayID
        )




INSERT INTO [dbo].[Emp Work History]
        ( [Resource Tag] ,
          [Start Date] ,
          [End Date] ,
          [Movement Type] ,
          [To Structure Entity] ,
          [To Payment ID] 
         
        )
VALUES  ( @Restag, -- Resource Tag - int
          '20130203' , -- Start Date - datetime
          @NewED , -- End Date - datetime
          'Acting',
		  @ToSE,
		  @PayID
        )


FETCH NEXT FROM WHSec INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

END

CLOSE WHSec
DEALLOCATE WHSec


GO


--- left overs



DECLARE @OldOp NVARCHAR(20),
@NewOp NVARCHAR(20)




SET @OldOp = 'SGE'
SET @NewOp = 'SGEO'

DECLARE @Restag INT,
@SD DATETIME,
@ED DATETIME,
@MT NVARCHAR(50),
@TOrg NVARCHAR(100),
@TDesig NVARCHAR(100),
@ToSE INT,
@FOrg NVARCHAR(100),
@FDesig NVARCHAR(100),
@FromSE INT,
@PayID NVARCHAR(20),
@count INT,
@i INT



SET @i = 0


SET @count = (SELECT COUNT(*)
 FROM    [dbo].[Emp Work History] EWH
   
    WHERE   (  [Start Date] >= '20150301' )
            AND (CASE WHEN [Movement Type]  LIKE '%second%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END = 'Southgold' OR
                      [From Operation]
                    
                 = @OldOp)
            AND [Movement Type] not LIKE '%term%')




DECLARE WHNSEc CURSOR
FOR
    SELECT  [Resource Tag] ,
            [Start Date] ,
            [End Date] ,
            [Movement Type] ,
            [To Org Unit - Gang] ,
            [To Designation] ,
            [To Structure Entity] ,
            [From Org Unit - Gang] ,
            [From Designation] ,
            [From Structure Entity] ,
            [To Payment ID]
    FROM    [dbo].[Emp Work History] EWH
  WHERE   (  [Start Date] >= '20150301' )
            AND (CASE WHEN [Movement Type]  LIKE '%second%'
                     THEN [From Operation]
                     ELSE [To Operation]
                END = 'Southgold' OR
                      [From Operation]
                    
                 = @OldOp)
            AND [Movement Type] not LIKE '%term%'

            
    ORDER BY [Resource Tag] ,
            [Start Date]




OPEN WHNSEc

FETCH NEXT FROM WHNSEc INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

WHILE @@FETCH_STATUS <> -1

BEGIN

DECLARE @NewSE INT
DECLARE @NewED DATETIME


SET @i = @i + 1
PRINT '---Busy with ' + CAST(@Restag AS NVARCHAR(20)) + ' no ' + CAST(@i AS NVARCHAR(10)) + ' out of ' + CAST(@count AS NVARCHAR(10)) + '----'


SET @NewED = (SELECT DATEADD(dd,-1,MIN([Start Date])) FROM [dbo].[Emp Work History] WHERE [Resource Tag] = @Restag AND [Start Date] >= '20150301')

--IF @NewED IS NULL
--BEGIN
--SET @NewED = '99991231'
--END
--SET @NewSE = (SELECT TOP 1 [Structure Entity] FROM [dbo].[Organisation Structure] WHERE [Designation] = @TDesig AND [Org Unit - Gang] = REPLACE(@TOrg,@OldOp,@NewOp))

--PRINT @NewSE

--PRINT @NewED


UPDATE [dbo].[Emp Work History] SET [To Structure Entity] = @ToSE WHERE [Resource Tag] =@Restag AND [Start Date] = @SD





FETCH NEXT FROM WHNSEc INTO @Restag ,
@SD ,
@ED ,
@MT ,
@TOrg ,
@TDesig ,
@ToSE ,
@FOrg ,
@FDesig ,
@FromSE ,
@PayID 

END

CLOSE WHNSEc
DEALLOCATE WHNSEc




---- Fix weird SG term records

ALTER TABLE [dbo].[Emp Work History] DISABLE TRIGGER Sibanye_Dates


UPDATE  [dbo].[Emp Work History]
SET     [From Structure Entity] = [To Structure Entity] ,
        [From Operation] = [To Operation] ,
        [From Org Unit - Gang] = [To Org Unit - Gang] ,
        [From Designation] = [To Designation]
WHERE   ( '20150301' BETWEEN [Start Date] AND [End Date]
          OR [Start Date] > '20150301'
        )
        AND [From Operation] = 'Southgold'
        AND [Movement Type] LIKE '%term%'


ALTER TABLE [dbo].[Emp Work History] ENABLE TRIGGER Sibanye_Dates		
-------------------------------------------------------------------------------------------------------------------------
go

DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Bit, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)
SET @User = 'Pieter Kitshoff'
SET @IssueNumber = 'SYM41057'
SET @ScriptName = 'SYM41057-205 PK Sibanye Gold Eastern Operations Rename Southgold.sql'
SET @Description = 'Rename Southgold to Sibanye Gold Eastern Operations'
SET @DataChange = 1
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'Emp absence request' 
SET @Version = '2.4.2'
SET @SpecialInstructions = ''
SET @LoggedBy = 'Connie Shaw'
SET @VerifiedBy = 'Karen Steenkamp'
Set @Identity = -1

Exec SYMsp_SymplexityChangeCTRL 1, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy
GO
