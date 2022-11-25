

---------------------------------------------------------
/**** Checking if the right datasets were imported *****/
---------------------------------------------------------
Select * 
   from PortfolioProject1..COVID_Deaths
       order by 3,4
Select * 
   from PortfolioProject1..COVID_Vaccinations
      order by 3,4

------------------------------------------------------------------------
/****** COVID-19 DEATHS DATASET*****/
------------------------------------------------------------------------
Select location, date, total_cases, new_cases, total_deaths, population
     from PortfolioProject1..COVID_Deaths
	    order by 1,2
		/**** SA: The first COVID-19 case to have been reported in SA was on the 05th of March 2020, population ofd the country stood at 59,392,255******/

/******Comparison: Total Cases(# of people who infected) vs. Total Deaths(# of people who died from the noble virus)***/
Select location, date, total_cases, total_deaths, (total_deaths/total_cases) as DeathPercentage
     from PortfolioProject1..COVID_Deaths
	    where location = 'South Africa'
	    order by 1,2
		/***** SA: Where 1187 people where infected with the virus, only 1 death occured. There is a 0.00084 probability/likelihood of dying from the virus. 
		           There is a directly proportional relationship between contraction and death mortality. It got really bad in the beginning of Feb 2021 & the beginning of August 2021
				   Became a whole lot better after that. Why?***/

/******Comparison: Total Cases vs. Nation's Population*******/
Select location, date, population, total_cases, (total_deaths/population)*100 as ContractionPercentage
     from PortfolioProject1..COVID_Deaths
	    where location = 'South Africa'
	    order by 1,2
		/***** SA: The ratio of contraction percentage vs population was less than 2% when COVID hit SA in early 2020. During the month of month of April 2020, the contraction rate was dabbling between 8% & 9.7% - at it's highest
		           An indirectly proportional relationaship can be  observed after April 2020, where the contraction rate went extremely down.
				   To date, SA's contraction rate is below 1% ***/

		/****Comparison: Countries with Highest Infection Rate vs. Nation's Population****/
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_deaths/population))*100 as PopulationInfectedRate
     from PortfolioProject1..COVID_Deaths
		Group by location, population
	    order by PopulationInfectedRate desc
		/***** look again**/

/****Comparion: Death Mortality ****/
Select location, MAX(cast(total_deaths as int)) as MortalityRate
     from PortfolioProject1..COVID_Deaths
	    where continent is not null
		Group by location
	    order by MortalityRate desc
		/**** Top 5 countries where people died of COVID are USA, Brazil, India, Russia and Mexico***/

/****Top Continent with Highest # of COVID deaths***/
Select continent, MAX(cast(total_deaths as int)) as MortalityRatebyContinent
     from PortfolioProject1..COVID_Deaths
	    where continent is not null
		Group by continent
	    order by MortalityRatebyContinent desc

/***Checking Vaccinations Dataset***/
Select *
  from PortfolioProject1..COVID_Vaccinations

/****************************************************/
/*******COVID DEATHS + VACCINATIONS JOINING*********/
/****************************************************/
Select *
  from PortfolioProject1..COVID_Deaths dea
  join PortfolioProject1..COVID_Vaccinations vac
    on dea.location = vac.location
	 and dea.date = vac.date

/******COMPARISON: Total Population vs Vaccinated People****************/
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
   from PortfolioProject1..COVID_Deaths dea
   join PortfolioProject1..COVID_Vaccinations vac
     on dea.location = vac.location
	  and dea.date = vac.date
	   where dea.continent is not null
	    order by 1,2,3
		/*****SA: Vaccinations in SA became available on the 19th of Feb 2021, where only 4264 people were vaccinated on that specific day. As time went on, more and more people
		      opened up to the idea of vaccinations despite so many others being against others. SA experienced a flatuation of people vaccinating with some days having no
			  people vaccinate at all. Towards mid-year of 2021, more and more people were showing up for vaccinations, with numbers surpassing the 100K mark.***********/

/********************************Rolling Count + Partitioning*************************************/
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.location ORDER BY dea.location, 
 dea.date) as PeopleVaccinated
   from PortfolioProject1..COVID_Deaths dea
   join PortfolioProject1..COVID_Vaccinations vac
     on dea.location = vac.location
	  and dea.date = vac.date
	   where dea.continent is not null
	    order by 1,2,3

	
