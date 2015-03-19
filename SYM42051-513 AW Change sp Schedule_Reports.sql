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

/****** Object:  StoredProcedure [dbo].[Schedule_Reports]    Script Date: 2015-03-18 10:17:12 AM ******/
DROP PROCEDURE [dbo].[Schedule_Reports]
GO

/****** Object:  StoredProcedure [dbo].[Schedule_Reports]    Script Date: 2015-03-18 10:17:12 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[Schedule_Reports]
	--@Date DATETIME ,
    --@Date1 VARCHAR(11) 
   
AS

DECLARE @Date DATETIME

SET @Date = RIGHT('0' + CONVERT(VARCHAR,DATEPART(DD,CONVERT(nvarchar(100),getdate(),106))),2) + '-' + LEFT(DATENAME(MM,CONVERT(nvarchar(100),getdate(),106)),3) + '-' + CONVERT(VARCHAR,DATEPART(YYYY,CONVERT(nvarchar(100),getdate(),106))) 

--SELECT @Date

DECLARE	@Date1 VARCHAR(11) 
	
SET @Date1 = RIGHT('0' + CONVERT(VARCHAR,DATEPART(DD,CONVERT(nvarchar(100),getdate(),106))),2) + '-' + LEFT(DATENAME(MM,CONVERT(nvarchar(100),getdate(),106)),3) + '-' + CONVERT(VARCHAR,DATEPART(YYYY,CONVERT(nvarchar(100),getdate(),106))) 

--SELECT @Date1
	
	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Bonus Biographical DE', '', 'OPRresourcetag=2130000332;rptearmsuser=BTXHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Beatrix;@Shaft=;@Department=;@Unit=;@Section=;@OrgUnit=', 'BTXReports', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Bonus Biographical DE', '', 'OPRresourcetag=130000149;rptearmsuser=DRFHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Driefontein;@Shaft=;@Department=;@Unit=;@Section=;@OrgUnit=', 'DRFHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Bonus Biographical DE', '', 'OPRresourcetag=2130218523;rptearmsuser=SGFHHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGFH;@Shaft=;@Department=;@Unit=;@Section=;@OrgUnit=', 'SGFHHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Bonus Biographical DE', '', 'OPRresourcetag=2130218755;rptearmsuser=SGFPHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGFP;@Shaft=;@Department=;@Unit=;@Section=;@OrgUnit=', 'SGFPHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Bonus Biographical DE', '', 'OPRresourcetag=2130156157;rptearmsuser=GFSAHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Sibanye Gold;@Shaft=;@Department=;@Unit=;@Section=;@OrgUnit=', 'GFSAHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Bonus Biographical DE', '', 'OPRresourcetag=2130218203;rptearmsuser=SGPSHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGPS;@Shaft=;@Department=;@Unit=;@Section=;@OrgUnit=', 'SGPSHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Bonus Biographical DE', '', 'OPRresourcetag=2130218774;rptearmsuser=SGAHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGA;@Shaft=;@Department=;@Unit=;@Section=;@OrgUnit=', 'SGAHR', @Date, @Date, null, null


	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Bonus Biographical DE', '', 'OPRresourcetag=2130219808;rptearmsuser=SGWHHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGWH;@Shaft=;@Department=;@Unit=;@Section=;@OrgUnit=', 'SGWHHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Bonus Biographical DE', '', 'OPRresourcetag=2130104465;rptearmsuser=GFWPHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=GFWP;@Shaft=;@Department=;@Unit=;@Section=;@OrgUnit=', 'GFWPHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Bonus Biographical DE', '', 'OPRresourcetag=130000147;rptearmsuser=KLFHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Kloof;@Shaft=;@Department=;@Unit=;@Section=;@OrgUnit=', 'KLFHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Bonus Biographical DE', '', 'OPRresourcetag=2130220533;rptearmsuser=SGSSHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGSS;@Shaft=;@Department=;@Unit=;@Section=;@OrgUnit=', 'SGSSHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Detail', '', 'OPRresourcetag=2130000332;rptearmsuser=BTXReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Beatrix', 'BTXReports', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=2130000332;rptearmsuser=BTXHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Beatrix', 'BTXHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Detail', '', 'OPRresourcetag=130000149;rptearmsuser=DRFReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Driefontein', 'DRFReports', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=130000149;rptearmsuser=DRFHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Driefontein', 'DRFHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Detail', '', 'OPRresourcetag=2130218203;rptearmsuser=SGPSReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGPS', 'SGPSReports', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=2130218203;rptearmsuser=SGPSHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGPS', 'SGPSHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Detail', '', 'OPRresourcetag=2130219808;rptearmsuser=SGWHReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGWH', 'SGWHReports', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=2130219808;rptearmsuser=SGWHHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGWH', 'SGWHHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Detail', '', 'OPRresourcetag=130000147;rptearmsuser=KLFReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Kloof', 'KLFReports', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=130000147;rptearmsuser=KLFHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Kloof', 'KLFHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Detail', '', 'OPRresourcetag=2130000332;rptearmsuser=BTXReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Beatrix', 'BTXReports', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit - Gang Listing', '', 'OPRresourcetag=2130000332;rptearmsuser=BTXHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Beatrix', 'BTXHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=2130000332;rptearmsuser=BTXHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Beatrix', 'BTXHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Detail', '', 'OPRresourcetag=130000149;rptearmsuser=DRFReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Driefontein', 'DRFReports', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit - Gang Listing', '', 'OPRresourcetag=130000149;rptearmsuser=DRFHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Driefontein', 'DRFHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=130000149;rptearmsuser=DRFHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Driefontein', 'DRFHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Detail', '', 'OPRresourcetag=2130218523;rptearmsuser=SGFHReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGFH', 'SGFHReports', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit - Gang Listing', '', 'OPRresourcetag=2130218523;rptearmsuser=SGFHHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGFH', 'SGFHHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=2130218523;rptearmsuser=SGFHHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGFH', 'SGFHHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Detail', '', 'OPRresourcetag=2130218755;rptearmsuser=SGFPReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGFP', 'SGFPReports', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit - Gang Listing', '', 'OPRresourcetag=2130218755;rptearmsuser=SGFPHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGFP', 'SGFPHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=2130218755;rptearmsuser=SGFPHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGFP', 'SGFPHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Detail', '', 'OPRresourcetag=2130218203;rptearmsuser=SGPSReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGPS', 'SGPSReports', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit - Gang Listing', '', 'OPRresourcetag=2130218203;rptearmsuser=SGPSHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGPS', 'SGPSHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=2130218203;rptearmsuser=SGPSHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGPS', 'SGPSHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Detail', '', 'OPRresourcetag=2130218774;rptearmsuser=SGAReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGA', 'SGAReports', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit - Gang Listing', '', 'OPRresourcetag=2130218774;rptearmsuser=SGAHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGA', 'SGAHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=2130218774;rptearmsuser=SGAHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGA', 'SGAHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Detail', '', 'OPRresourcetag=2130219808;rptearmsuser=SGWHReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGWH', 'SGWHReports', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit - Gang Listing', '', 'OPRresourcetag=2130219808;rptearmsuser=SGWHHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGWH', 'SGWHHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=2130219808;rptearmsuser=SGWHHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGWH', 'SGWHHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Detail', '', 'OPRresourcetag=2130220509;rptearmsuser=SGWPReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGWP', 'SGWPReports', @Date, @Date, null, null

	insert into [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit - Gang Listing', '', 'OPRresourcetag=2130220509;rptearmsuser=SGWPHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGWP', 'SGWPHR', @Date, @Date, null, null

	insert into [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=2130220509;rptearmsuser=SGWPHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGWP', 'SGWPHR', @Date, @Date, null, null

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + CONVERT(VARCHAR,CONVERT(DATE,@Date),113) , NULL, NULL, NULL, NULL, -1, 'Org Unit Detail', '', 'OPRresourcetag=130000147;rptearmsuser=KLFReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Kloof', 'KLFReports', @Date, @Date, NULL, NULL

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + CONVERT(VARCHAR,CONVERT(DATE,@Date),113) , NULL, NULL, NULL, NULL, -1, 'Org Unit - Gang Listing', '', 'OPRresourcetag=130000147;rptearmsuser=KLFHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Kloof', 'KLFHR', @Date, @Date, NULL, NULL

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + CONVERT(VARCHAR,CONVERT(DATE,@Date),113) , NULL, NULL, NULL, NULL, -1, 'Org Unit Summary', '', 'OPRresourcetag=130000147;rptearmsuser=KLFHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Kloof', 'KLFHR', @Date, @Date, NULL, NULL

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + CONVERT(VARCHAR,CONVERT(DATE,@Date),113) , NULL, NULL, NULL, NULL, -1, 'Org Unit Detail', '', 'OPRresourcetag=2130220533;rptearmsuser=SGSSReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGSS', 'SGSSReports', @Date, @Date, NULL, NULL

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + CONVERT(VARCHAR,CONVERT(DATE,@Date),113) , NULL, NULL, NULL, NULL, -1, 'Org Unit - Gang Listing', '', 'OPRresourcetag=2130220533;rptearmsuser=SGSSHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGSS', 'SGSSHR', @Date, @Date, NULL, NULL

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + CONVERT(VARCHAR,CONVERT(DATE,@Date),113) , NULL, NULL, NULL, NULL, -1, 'Org Unit Summary', '', 'OPRresourcetag=2130220533;rptearmsuser=SGSSHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SGSS', 'SGSSHR', @Date, @Date, NULL, NULL

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + CONVERT(VARCHAR,CONVERT(DATE,@Date),113) , NULL, NULL, NULL, NULL, -1, 'Org Unit Detail', '', 'OPRresourcetag=2130156157;rptearmsuser=GFSAReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Sibanye Gold', 'GFSAReports', @Date, @Date, NULL, NULL

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + CONVERT(VARCHAR,CONVERT(DATE,@Date),113) , NULL, NULL, NULL, NULL, -1, 'Org Unit - Gang Listing', '', 'OPRresourcetag=2130156157;rptearmsuser=GFSAHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Sibanye Gold', 'GFSAHR', @Date, @Date, NULL, NULL

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + CONVERT(VARCHAR,CONVERT(DATE,@Date),113) , NULL, NULL, NULL, NULL, -1, 'Org Unit Summary', '', 'OPRresourcetag=2130156157;rptearmsuser=GFSAHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Sibanye Gold', 'GFSAHR', @Date, @Date, NULL, NULL

	--SELECT * FROM [resource] WHERE [Resource name] = 'southgold'
	--SELECT * FROM [resource] WHERE [Resource name] = 'SG Eastern Operations'
	--SELECT * FROM [resource] WHERE [Resource name] = 'Rand Uranium'
	--SELECT * FROM [resource] WHERE [Resource name] = 'Ezulwini'

	
	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Bonus Biographical DE', '', 'OPRresourcetag=2130231947;rptearmsuser=SGEHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SG Eastern Operations;@Shaft=;@Department=;@Unit=;@Section=;@OrgUnit=', 'SGEHR', @Date, @Date, null, null
		
	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=2130231947;rptearmsuser=SGEHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SG Eastern Operations', 'SGEHR', @Date, @Date, null, null
		
	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + CONVERT(VARCHAR,CONVERT(DATE,@Date),113) , NULL, NULL, NULL, NULL, -1, 'Org Unit - Gang Listing', '', 'OPRresourcetag=2130231947;rptearmsuser=SGEHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SG Eastern Operations', 'SGEHR', @Date, @Date, NULL, NULL

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + CONVERT(VARCHAR,CONVERT(DATE,@Date),113) , NULL, NULL, NULL, NULL, -1, 'Org Unit Detail', '', 'OPRresourcetag=2130231947;rptearmsuser=SGEReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=SG Eastern Operations', 'SGEReports', @Date, @Date, NULL, NULL


	
	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Bonus Biographical DE', '', 'OPRresourcetag=2130229520;rptearmsuser=EZLHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Ezulwini;@Shaft=;@Department=;@Unit=;@Section=;@OrgUnit=', 'EZLHR', @Date, @Date, null, null
		
	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=2130229520;rptearmsuser=EZLHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Ezulwini', 'EZLHR', @Date, @Date, null, null
		
	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + CONVERT(VARCHAR,CONVERT(DATE,@Date),113) , NULL, NULL, NULL, NULL, -1, 'Org Unit - Gang Listing', '', 'OPRresourcetag=2130229520;rptearmsuser=EZLHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Ezulwini', 'EZLHR', @Date, @Date, NULL, NULL

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + CONVERT(VARCHAR,CONVERT(DATE,@Date),113) , NULL, NULL, NULL, NULL, -1, 'Org Unit Detail', '', 'OPRresourcetag=2130229520;rptearmsuser=EZLReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Ezulwini', 'EZLReports', @Date, @Date, NULL, NULL



	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Bonus Biographical DE', '', 'OPRresourcetag=2130229527;rptearmsuser=RULHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Rand Uranium;@Shaft=;@Department=;@Unit=;@Section=;@OrgUnit=', 'RULHR', @Date, @Date, null, null
		
	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + convert(varchar,convert(date,@Date),113) , null, null, null, null, -1, 'Org Unit Summary', '', 'OPRresourcetag=2130229527;rptearmsuser=RULHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Rand Uranium', 'RULHR', @Date, @Date, null, null
		
	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + CONVERT(VARCHAR,CONVERT(DATE,@Date),113) , NULL, NULL, NULL, NULL, -1, 'Org Unit - Gang Listing', '', 'OPRresourcetag=2130229527;rptearmsuser=RULHR;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Rand Uranium', 'RULHR', @Date, @Date, NULL, NULL

	INSERT INTO [Scheduler Report Pool]([Online Report Flag],[Status],[Status Date],[Time Taken],[Scheduler IP],[Sequence],[Report Name],[Command String],[Parameter String],[User],[Run Date],[Submitted],[Started],[Completed])
	SELECT 'HR Reports : ' + CONVERT(VARCHAR,CONVERT(DATE,@Date),113) , NULL, NULL, NULL, NULL, -1, 'Org Unit Detail', '', 'OPRresourcetag=2130229527;rptearmsuser=RULReports;rptearmsstructure=Organisation;@DateFrom='+@Date1+';@DateTo='+@Date1+';@Operation=Rand Uranium', 'RULReports', @Date, @Date, NULL, NULL

GO
    
DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Int, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)
SET @User = 'Annemarie Wessels'
SET @IssueNumber = 'SYM42051'
SET @ScriptName = 'SYM42051-513 AW Change sp Schedule_Reports.sql'
SET @Description = 'Change sp Schedule_Reports'
SET @DataChange = 0 -- 0 = Object 1=Data, 3=Data (priority change), 4=Object (priority change)
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'STORED PROC' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'Schedule_Reports' 
SET @Version = '2.4.3'
SET @SpecialInstructions = ''
SET @LoggedBy = 'Hannes Scheepers'
SET @VerifiedBy = 'Karen Steenkamp'
Set @Identity = -1

Exec SYMsp_SymplexityChangeCTRL 1, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy

GO
