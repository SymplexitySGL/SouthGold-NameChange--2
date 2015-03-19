USE [GFL_Backup]
GO

	IF EXISTS (SELECT 1 FROM sys.objects SO WHERE object_id = OBJECT_ID(N'[dbo].[Temp Opr Name Change ET]') AND SO.type in (N'U'))
	DROP TABLE dbo.[Temp Opr Name Change ET]

	Create Table [Temp Opr Name Change ET] ([Old Operation] VARCHAR(50), [Old Prefix] VARCHAR(50), [New Operation] VARCHAR(50), [New Prefix] VARCHAR(50), [Start Date] DateTime, [Old Operation Termination Date] DateTime)
	INSERT INTO [Temp Opr Name Change ET] ([Old Operation], [Old Prefix], [New Operation], [New Prefix], [Start Date], [Old Operation Termination Date]) VALUES ('Southgold', 'SGE', 'SG Eastern Operations', 'SGEO', '01-Mar-2015','28-Feb-2015')
GO
USE [Sibanye Gold Limited]
GO
	SET IDENTITY_INSERT [Opr Course] ON
	INSERT INTO [Opr Course] ([Resource Tag], [Discipline], [Sequence], [Course Name],[Description], [Course Type],[Course Master Start Date],[Course Master End Date], [Cost per Person],[Cost per Course], [Start Date], [End Date],[Start Time], [End Time], [Venue],[Room Name], [Seating Capacity],[Minimum Attendees], [Maximum Attendees],[Facilitator Name], [External Facilitator],[Venue Booked By], [Contact Number],[Course Duration],[Certificate to be Issued],[Cancellation Reason], [Cancellation Date],[Cancelled By Industry Number],[Cancelled by Name], [Comments],[Booking Cancellation Date],[Booking Course],[Employees Booked (Resource Tag)],[Employees Booked], [Booking End Date],[Facilitator Name Booked])
	Select RNew.[Resource Tag], OC.[Discipline], OC.[Sequence], OC.[Course Name],OC.[Description], OC.[Course Type],OC.[Course Master Start Date],OC.[Course Master End Date], OC.[Cost per Person],OC.[Cost per Course], OC.[Start Date], OC.[End Date],OC.[Start Time], OC.[End Time], OC.[Venue],OC.[Room Name], OC.[Seating Capacity],OC.[Minimum Attendees], OC.[Maximum Attendees],OC.[Facilitator Name], OC.[External Facilitator],OC.[Venue Booked By], OC.[Contact Number],OC.[Course Duration],OC.[Certificate to be Issued],OC.[Cancellation Reason], OC.[Cancellation Date],OC.[Cancelled By Industry Number],OC.[Cancelled by Name], OC.[Comments],OC.[Booking Cancellation Date],OC.[Booking Course],OC.[Employees Booked (Resource Tag)],OC.[Employees Booked], OC.[Booking End Date],OC.[Facilitator Name Booked]
	FROM [dbo].[Opr Course] OC
	INNER JOIN [dbo].[Resource] ROld
		ON OC.[resource tag] = ROld.[Resource Tag]
		AND ROld.[Resource Type] = 'Operation'
	INNER JOIN [GFL_Backup].[dbo].[Temp Opr Name Change ET] TONCE
		ON [TONCE].[Old Operation] = ROld.[resource Reference]  
	INNER JOIN [dbo].[Resource] RNew
		ON [TONCE].[New Operation] = RNew.[Resource Reference]
		AND rnew.[Resource Type] = 'Operation'
	LEFT JOIN [dbo].[Opr Course ] OC2
		ON OC2.[Resource Tag] = RNew.[Resource Tag]   
		AND OC2.[Discipline] = OC.[Discipline] 
		AND OC2.[Course Name] = OC.[Course Name]
		AND OC2.[sequence] = OC.[Sequence]
	WHERE OC2.[Resource tag] IS NULL
	
	SET IDENTITY_INSERT [Opr Course] OFF
    
GO

DECLARE @User VARCHAR(50), @IssueNumber VARCHAR(20), @ScriptName VARCHAR(100), @Description VARCHAR(500), @ChangeNumber VARCHAR(20)
DECLARE @IDENTITY INT, @SpecialInstructions VARCHAR(150), @DataChange Int, @sMsg varchar(4000), @LoggedBy NVARCHAR(50), @VerifiedBy NVARCHAR(50)
Declare @tbRT ResourceTagTableType, @FunctionalArea varchar(50), @ObjectType varchar(50), @ObjectName varchar(50), @Version	varchar(50)
SET @User = 'Etienne Jordaan'
SET @IssueNumber = 'SYM41057'
SET @ScriptName = 'SYM41057 130 EJ Opr Course.sql'
SET @Description = 'Opr Course'
SET @DataChange = 1 -- 0 = Object 1=Data, 3=Data (priority change), 4=Object (priority change)
SET @FunctionalArea = 'Payroll'
SET @ObjectType = 'Table' -- 'TABLE', 'VIEW', 'STORED PROC','FUNCTION', 'INDEX', 'CONSTRAINT'
SET @ObjectName = 'Opr Course' 
SET @Version = '2.4.3'
SET @SpecialInstructions = ''
SET @LoggedBy = 'Hannes Scheepers'
SET @VerifiedBy = 'Pieter Kitshoff'
Set @Identity = -1

Exec SYMsp_SymplexityChangeCTRL 1, @User, @IssueNumber, @ScriptName, @Description, @DataChange, @FunctionalArea, @ObjectType, @ObjectName, @Version, @IDENTITY OUTPUT, @tbRT, @LoggedBy

GO