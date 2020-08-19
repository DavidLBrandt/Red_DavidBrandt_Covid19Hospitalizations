/*
  _   ___        __  ____ ___ ____  ____    ____  _____  ___    _____ ___ _   _    _    _     
 | | | \ \      / / | __ )_ _|  _ \|  _ \  |___ \|___ / / _ \  |  ___|_ _| \ | |  / \  | |    
 | | | |\ \ /\ / /  |  _ \| || | | | | | |   __) | |_ \| | | | | |_   | ||  \| | / _ \ | |    
 | |_| | \ V  V /   | |_) | || |_| | |_| |  / __/ ___) | |_| | |  _|  | || |\  |/ ___ \| |___ 
  \___/   \_/\_/    |____/___|____/|____/  |_____|____/ \___/  |_|   |___|_| \_/_/   \_\_____|
  ____  _____ ____    _____ _____    _    __  __                                              
 |  _ \| ____|  _ \  |_   _| ____|  / \  |  \/  |                                             
 | |_) |  _| | | | |   | | |  _|   / _ \ | |\/| |                                             
 |  _ <| |___| |_| |   | | | |___ / ___ \| |  | |                                             
 |_| \_\_____|____/    |_| |_____/_/   \_\_|  |_|                                             
                                                                                              
Members: David Brandt, Jane Lee, Drake Lemm
Course: UW BIDD 230 - Data Management, Maintenance, & Reporting
Assignment: Final - Red Team
Date: August 11, 2020
Description: Load the data warehouse database.

*/

USE [BIDD230Final_RedTeam_DWCovid19]
GO

/************************************************************** 
 Truncate Tables
**************************************************************/

TRUNCATE TABLE [dbo].[DimBingCovid]
TRUNCATE TABLE [dbo].[DimCovidTracking]
TRUNCATE TABLE [dbo].[DimDate]
TRUNCATE TABLE [dbo].[DimStates]
GO

/************************************************************** 
 Load the Data Warehouse 
**************************************************************/

DECLARE 
	@StartDate DATE = '03/01/2020'
  , @EndDate DATE = '07/31/2020'

-- [DimBingCovid]
INSERT INTO [dbo].[DimBingCovid] ([Updated], [ID], [Confirmed], [ConfirmedChange], [Deaths], [DeathsChange], [Recovered], [RecoveredChange], [Latitude], [Longitude], [ISO2], [ISO3], [Country_Region], [AdminRegion1], [AdminRegion2])
SELECT [Updated], [ID], [Confirmed], [ConfirmedChange], [Deaths], [DeathsChange], [Recovered], [RecoveredChange], [Latitude], [Longitude], [ISO2], [ISO3], [Country_Region], [AdminRegion1], [AdminRegion2]
  FROM [BIDD230Final_RedTeam_StagingCovid19].[dbo].[BingCovid]
  WHERE @StartDate <= [Updated] 
    AND [Updated] <= @EndDate
	AND Country_Region = 'United States' 
	AND AdminRegion1 IS NOT NULL
	AND AdminRegion2 IS NULL

-- [DimCovidTracking]
INSERT INTO [dbo].[DimCovidTracking] ([date], [state], [positive], [negative], [pending], [hospitalizedCurrently], [hospitalizedCumulative], [inIcuCurrently], [inIcuCumulative], [onVentilatorCurrently], [onVentilatorCumulative], [recovered], [dataQualityGrade], [lastUpdateEt], [death], [totalTestsViral], [positiveTestsViral], [negativeTestsViral], [positiveCasesViral], [deathConfirmed], [deathProbable], [fips], [positiveIncrease], [totalTestResults], [totalTestResultsIncrease], [deathIncrease], [hospitalizedIncrease])
SELECT 
    CAST(CAST(CAST([date] AS INT) AS CHAR(8)) AS DATE)
  , [state], [positive], [negative], [pending], [hospitalizedCurrently], [hospitalizedCumulative], [inIcuCurrently], [inIcuCumulative], [onVentilatorCurrently], [onVentilatorCumulative], [recovered], [dataQualityGrade], [lastUpdateEt], [death], [totalTestsViral], [positiveTestsViral], [negativeTestsViral], [positiveCasesViral], [deathConfirmed], [deathProbable], [fips], [positiveIncrease], [totalTestResults], [totalTestResultsIncrease], [deathIncrease], [hospitalizedIncrease]
  FROM [BIDD230Final_RedTeam_StagingCovid19].[dbo].[CovidTracking]
  WHERE @StartDate <= CAST(CAST(CAST([date] AS INT) AS CHAR(8)) AS DATE) 
    AND CAST(CAST(CAST([date] AS INT) AS CHAR(8)) AS DATE) <= @EndDate

-- [DimDates]
;WITH seq(n) AS 
  (SELECT 0 UNION ALL SELECT n + 1 FROM seq
   WHERE n < DATEDIFF(DAY, @StartDate, @EndDate)),
d(d) AS 
  (SELECT DATEADD(DAY, n, @StartDate) FROM seq),
src AS
  (SELECT
    TheDate         = CONVERT(date, d),
    TheDay          = DATEPART(DAY,       d),
    TheDayName      = DATENAME(WEEKDAY,   d),
    TheWeek         = DATEPART(WEEK,      d),
    TheISOWeek      = DATEPART(ISO_WEEK,  d),
    TheDayOfWeek    = DATEPART(WEEKDAY,   d),
    TheMonth        = DATEPART(MONTH,     d),
    TheMonthName    = DATENAME(MONTH,     d),
    TheQuarter      = DATEPART(Quarter,   d),
    TheYear         = DATEPART(YEAR,      d),
    TheFirstOfTheMonth = DATEFROMPARTS(YEAR(d), MONTH(d), 1),
    TheLastOfTheYear   = DATEFROMPARTS(YEAR(d), 12, 31),
    DayOfTheYear    = DATEPART(DAYOFYEAR, d)
  FROM d)

INSERT INTO [dbo].[DimDate]
	SELECT 
	* 
	FROM src
	WHERE TheDate <= @EndDate
	ORDER BY TheDate
	OPTION (MAXRECURSION 0);

-- [DimStates]
INSERT INTO [dbo].[DimStates] ([state], [latitude], [longitude], [name], [color])
SELECT [state], [latitude], [longitude], [name], [color]
  FROM [BIDD230Final_RedTeam_StagingCovid19].[dbo].[States]

GO

/************************************************************** 
 Sample Warehouse Data 
**************************************************************/
SELECT TOP 5 * FROM [dbo].[vDimBingCovid]
SELECT TOP 5 * FROM [dbo].[vDimCovidTracking]
SELECT TOP 5 * FROM [dbo].[vDimDate]
SELECT TOP 5 * FROM [dbo].[vDimStates]
GO