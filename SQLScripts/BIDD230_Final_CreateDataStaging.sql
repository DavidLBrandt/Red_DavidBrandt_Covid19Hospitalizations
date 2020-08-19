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
Description: Create the data staging database.

*/

/************************************************************** 
 Create the Data Staging Database 
**************************************************************/

--****************** [BIDD230Final_Covid19_RedTeam_DW] *********************--
-- This file will drop and create the [BIDD230Final_Covid19_RedTeam_DW]
-- database, with all its objects. 
--****************** Instructors Version ***************************--

USE [master]
GO
If Exists (Select * from Sysdatabases Where Name = 'BIDD230Final_RedTeam_StagingCovid19')
	Begin 
		ALTER DATABASE [BIDD230Final_RedTeam_StagingCovid19] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE [BIDD230Final_RedTeam_StagingCovid19]
	End
GO
Create Database [BIDD230Final_RedTeam_StagingCovid19]
Go

USE [BIDD230Final_RedTeam_StagingCovid19]
GO

--********************************************************************--
-- Create Staging Tables
--********************************************************************--

CREATE TABLE [dbo].[BingCovid](
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

CREATE TABLE [dbo].[CovidTracking](
	[date] [float] NULL,
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
	[dateModified] [nvarchar](255) NULL,
	[checkTimeEt] [datetime] NULL,
	[death] [float] NULL,
	[hospitalized] [float] NULL,
	[dateChecked] [nvarchar](255) NULL,
	[totalTestsViral] [float] NULL,
	[positiveTestsViral] [float] NULL,
	[negativeTestsViral] [float] NULL,
	[positiveCasesViral] [float] NULL,
	[deathConfirmed] [float] NULL,
	[deathProbable] [float] NULL,
	[fips] [float] NULL,
	[positiveIncrease] [float] NULL,
	[negativeIncrease] [float] NULL,
	[total] [float] NULL,
	[totalTestResults] [float] NULL,
	[totalTestResultsIncrease] [float] NULL,
	[posNeg] [float] NULL,
	[deathIncrease] [float] NULL,
	[hospitalizedIncrease] [float] NULL,
	[hash] [nvarchar](255) NULL,
	[commercialScore] [float] NULL,
	[negativeRegularScore] [float] NULL,
	[negativeScore] [float] NULL,
	[positiveScore] [float] NULL,
	[score] [float] NULL,
	[grade] [nvarchar](255) NULL
)
GO

CREATE TABLE [dbo].[States](
	[state] [nvarchar](255) NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL,
	[name] [nvarchar](255) NULL,
	[color] [nvarchar](255) NULL
)
GO

--********************************************************************--
-- Review the results of this script
--********************************************************************--

Select 'Database Created'
Select Name, xType, CrDate from SysObjects 
Where xType in ('U', 'PK', 'F', 'V')
Order By xType desc, Name
