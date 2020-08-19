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
Description: Create the data warehouse database.

*/

/************************************************************** 
 Create the Data Warehouse 
**************************************************************/

--****************** [BIDD230Final_Covid19_RedTeam_DW] *********************--
-- This file will drop and create the [BIDD230Final_Covid19_RedTeam_DW]
-- database, with all its objects. 
--****************** Instructors Version ***************************--

USE [master]
GO
If Exists (Select * from Sysdatabases Where Name = 'BIDD230Final_RedTeam_DWCovid19')
	Begin 
		ALTER DATABASE [BIDD230Final_RedTeam_DWCovid19] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE [BIDD230Final_RedTeam_DWCovid19]
	End
GO
Create Database [BIDD230Final_RedTeam_DWCovid19]
Go

USE [BIDD230Final_RedTeam_DWCovid19]
GO

--********************************************************************--
-- Create Data Warehouse Tables
--********************************************************************--

CREATE TABLE [dbo].[DimBingCovid](
	[ID] [float] NULL,
	[Updated] [date] NULL,
	[Confirmed] [float] NULL,
	[ConfirmedChange] [float] NULL,
	[Deaths] [float] NULL,
	[DeathsChange] [float] NULL,
	[Recovered] [nvarchar](255) NULL,
	[RecoveredChange] [nvarchar](255) NULL,
	[Latitude] [nvarchar](255) NULL,
	[Longitude] [nvarchar](255) NULL,
	[ISO2] [nvarchar](255) NULL,
	[ISO3] [nvarchar](255) NULL,
	[Country_Region] [nvarchar](255) NULL,
	[AdminRegion1] [nvarchar](255) NULL,
	[AdminRegion2] [nvarchar](255) NULL
)
GO

CREATE TABLE [dbo].[DimCovidTracking](
	[date] [date] NULL,
	[state] [nvarchar](255) NULL,
	[positive] [float] NULL,
	[negative] [float] NULL,
	[pending] [nvarchar](255) NULL,
	[hospitalizedCurrently] [float] NULL,
	[hospitalizedCumulative] [float] NULL,
	[inIcuCurrently] [float] NULL,
	[inIcuCumulative] [float] NULL,
	[onVentilatorCurrently] [float] NULL,
	[onVentilatorCumulative] [float] NULL,
	[recovered] [float] NULL,
	[dataQualityGrade] [nvarchar](255) NULL,
	[lastUpdateEt] [datetime] NULL,
--	[dateModified] [nvarchar](255) NULL,	-- Deprecated
--	[checkTimeEt] [datetime] NULL,			-- Deprecated
	[death] [float] NULL,
--	[hospitalized] [float] NULL,			-- Deprecated
--	[dateChecked] [nvarchar](255) NULL,		-- Deprecated
	[totalTestsViral] [float] NULL,
	[positiveTestsViral] [float] NULL,
	[negativeTestsViral] [float] NULL,
	[positiveCasesViral] [float] NULL,
	[deathConfirmed] [float] NULL,
	[deathProbable] [float] NULL,
	[fips] [float] NULL,
	[positiveIncrease] [float] NULL,
--	[negativeIncrease] [float] NULL,		-- Deprecated
--	[total] [float] NULL, -- Deprecated
	[totalTestResults] [float] NULL,
	[totalTestResultsIncrease] [float] NULL,
--	[posNeg] [float] NULL,
	[deathIncrease] [float] NULL,
	[hospitalizedIncrease] [float] NULL,
--	[hash] [nvarchar](255) NULL,			-- Deprecated
--	[commercialScore] [float] NULL,			-- Deprecated
--	[negativeRegularScore] [float] NULL,	-- Deprecated
--	[negativeScore] [float] NULL,			-- Deprecated
--	[positiveScore] [float] NULL,			-- Deprecated
--	[score] [float] NULL,					-- Deprecated
--	[grade] [nvarchar](255) NULL			-- Deprecated
)
GO

CREATE TABLE [dbo].[DimStates](
	[state] [nvarchar](255) NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL,
	[name] [nvarchar](255) NULL,
	[color] [nvarchar](255) NULL
)
GO

CREATE TABLE [dbo].[DimDate](
	[ReportingDate] [date] NULL,
	[TheDay] [int] NULL,
	[TheDayName] [nvarchar](50) NULL,
	[TheWeek] [int] NULL,
	[TheSOWeek] [int] NULL,
	[TheDayOfWeek] [int] NULL,
	[TheMonth] [int] NULL,
	[TheMonthName] [nvarchar](50) NULL,
	[TheQuarter] [int] NULL,
	[TheYear] [int] NULL,
	[TheFirstOfTheMonth] [nvarchar](50) NULL,
	[TheLastOfTheMonth] [nvarchar](50) NULL,
	[DayofTheYear] [nvarchar](50) NULL
) ON [PRIMARY]
GO

--********************************************************************--
-- Create Data Warehouse Views
--********************************************************************--

/* Create vDimBingCovid */
CREATE VIEW [dbo].[vDimBingCovid]
AS
SELECT TOP 100 PERCENT
    [Date] = [Updated]
  , [ID] = [ID]
  , [Confirmed Cases] =[Confirmed]
  , [Change in Confirmed Cases] = [ConfirmedChange]
  , [Deaths] = [Deaths]
  , [Change in Deaths] = [DeathsChange]
  , [Recovered Cases] = [Recovered]
  , [Change in Recovered Cases] = [RecoveredChange]
  , [Latitude] = [Latitude]
  , [Longitude] = [Longitude]
  , [ISO2] = [ISO2]
  , [ISO3] = [ISO3]
  , [Country] = [Country_Region]
  , [State] = [AdminRegion1]
  , [County] = [AdminRegion2] 
FROM [dbo].[DimBingCovid]
ORDER BY [Date]
GO

/* Create vDimCovidTracking */
CREATE VIEW [dbo].[vDimCovidTracking]
AS
SELECT TOP 100 PERCENT
	[Date] = [date]
  , [State Abbr] = [state]
  , [FIPS] = [fips]
  , [Positive Test Results] = [positive]
  , [Negative Test Results] = [negative]
  , [Pending Test Results] = [pending]
  , [Total Test Results] = [totalTestResults]
  , [Increase in Positive Test Results] = [positiveIncrease]
  , [Increase in Total Test Results] = [totalTestResultsIncrease]
  , [Currently Hospitalized] = [hospitalizedCurrently]
  , [Cumulative Hospitalized] = [hospitalizedCumulative]
  , [Increase in Hospitalized] = [hospitalizedIncrease]
  , [Currently in ICU] = [inIcuCurrently]
  , [Cumulative in ICU] = [inIcuCumulative]
  , [Currently on Ventilator] = [onVentilatorCurrently]
  , [Cumulative on Ventilator] = [onVentilatorCumulative]
  , [Recovered] = [recovered]
  , [Death] = [death]
  , [Death Confirmed] = [deathConfirmed]
  , [Death Probable] = [deathProbable]
  , [Increase in Death] = [deathIncrease]
  , [Positive Viral Cases] = [positiveCasesViral]
  , [Positive Viral Tests] = [positiveTestsViral]
  , [Negative Viral Tests] = [negativeTestsViral]
  , [Total Viral Tests] = [totalTestsViral]
  , [Last Update Et] = [lastUpdateEt]
  , [Data Quality Grade] = [dataQualityGrade]
FROM [dbo].[DimCovidTracking]
ORDER BY [Date]
GO

/* Create vDimStates */
CREATE VIEW [dbo].[vDimStates]
AS
SELECT TOP 100 PERCENT
    [State] = [name]
  , [State Abbr] = [state]
  , [Color] = [color]
  , [Latitude] = [latitude]
  , [Longitude] = [longitude]
FROM [dbo].[DimStates]
ORDER BY [State]
GO

CREATE VIEW [dbo].[vDimDate]
AS
SELECT TOP 100 PERCENT
	[Date] = [ReportingDate]
  , [Day] = [TheDay]
  , [Day Name] = [TheDayName]
  , [Week] = [TheWeek]
  , [SO Week] = [TheSOWeek]
  , [Day Of Week] = [TheDayOfWeek]
  , [Month] = [TheMonth]
  , [Month Name] = [TheMonthName]
  , [Quarter] = [TheQuarter]
  , [Year] = [TheYear]
  , [First of The Month] = [TheFirstOfTheMonth]
  , [Last of The Month] = [TheLastOfTheMonth]
  , [Day of The Year] = [DayofTheYear]
FROM [dbo].[DimDate]
ORDER BY [Date]
GO

--********************************************************************--
-- Review the results of this script
--********************************************************************--

Select 'Database Created'
Select Name, xType, CrDate from SysObjects 
Where xType in ('U', 'PK', 'F', 'V')
Order By xType desc, Name
