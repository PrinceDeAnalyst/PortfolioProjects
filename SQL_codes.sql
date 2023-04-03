Select *
from [Portfolio Project]..CovidDeaths$
where continent is not null
order by 3,4

--Select *
--from [Portfolio Project]..CovidVac$
--order by 3,4

 ----Select First Data for the Our Project

 Select Location, date, total_cases, new_cases, total_deaths, population
 From [Portfolio Project]..CovidDeaths$
 where continent is not null
 order by 1,2


 ----Looking at Total cases vs Total Deaths
 ----Likelihood of death as of today.
  Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
 From [Portfolio Project]..CovidDeaths$
 where continent is not null
 where location like '%states%'
 order by 1,2


 ----Looking at Total cases vrs population 
 ----Shows percentage of population got covid

 Select Location, date, population, total_cases, (total_cases/population)*100 as ContractionPercentage
 From [Portfolio Project]..CovidDeaths$
 where continent is not null
 --where location like '%states%'
 order by 1,2


 ---Looking at Countries with Highest Infection Rate compared to Population
 Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as HighestContractionPercentage
 From [Portfolio Project]..CovidDeaths$
 where continent is not null
 --where location like '%states%'
 group by Location, population 
 order by HighestContractionPercentage desc



 ---Countries with Highest Death Counts per population
 Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
 From [Portfolio Project]..CovidDeaths$
 where continent is not null
 --where location like '%states%'
 group by Location  
 order by TotalDeathCount desc

 ----CONTINENT ANALYSIS
 Select continent, MAX(cast(total_Deaths as int)) as TotalDeathCount
 from [Portfolio Project]..CovidDeaths$
 where continent is not null
 --where location like '%states%'
 group by continent  
 order by TotalDeathCount desc


 ----GLOBAL ANALYSIS
Select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeath, 
 sum(cast(new_deaths as int))/sum(new_cases)*100 as GlobalDeathPercentage
 From [Portfolio Project]..CovidDeaths$
 where continent is not null
 --where location like '%states%'
 --group by continent  
 order by 1,2


 ---LOOKING AT TOTAL POPULATION VS VACCINATION
 select dea.continent, dea.location, dea.date, dea.population,
 vac.new_vaccinations, sum(convert(int,new_vaccinations))   
 over (partition by dea.location order by dea.location,dea.date) as CommulativeVacCount
 from [Portfolio Project]..CovidDeaths$ dea
 Join [Portfolio Project]..CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

 ----EMPLOY CTE

 With PopvsVac (continent,location, date, population, new_vaccinations,CommulativeVacCount)
 as
 (
 select dea.continent, dea.location, dea.date, dea.population,
 vac.new_vaccinations, sum(convert(int,new_vaccinations))   
 over (partition by dea.location order by dea.location,dea.date) as CommulativeVacCount
 from [Portfolio Project]..CovidDeaths$ dea
 Join [Portfolio Project]..CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 ---order by 2,3
 )

 select * , (CommulativeVacCount/population)*100 as PercentageVaccinated
 from PopvsVac


---- DOING THE PREVIOUS STEP USING A TEMP TABLE

Drop table if exists #PercentageVaccinated   
Create table #PercentageVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
CommulativeVacCount numeric
)


Insert into #PercentageVaccinated
select dea.continent, dea.location, dea.date, dea.population,
 vac.new_vaccinations, sum(convert(int,new_vaccinations))   
 over (partition by dea.location order by dea.location,dea.date) as CommulativeVacCount
 from [Portfolio Project]..CovidDeaths$ dea
 Join [Portfolio Project]..CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 --where dea.continent is not null
 ---order by 2,3
 
 select * , (CommulativeVacCount/population)*100 as PercentageVaccinated
 from #PercentageVaccinated


 -----Creating View to store data for later Visualization


Create view Per$entageVaccinated as
select dea.continent, dea.location, dea.date, dea.population,
 vac.new_vaccinations, sum(convert(int,new_vaccinations))   
 over (partition by dea.location order by dea.location,dea.date) as CommulativeVacCount
 from [Portfolio Project]..CovidDeaths$ dea
 Join [Portfolio Project]..CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3

 select *
 from Per$entageVaccinated






































  














