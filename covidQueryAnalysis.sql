select *
From PortfolioProject..covidDeath
where continent is not null
order by 3,4

--select *
--From PortfolioProject..CovidVaccination
--order by 3,4

select location, date, total_cases, new_cases, total_deaths,population
From PortfolioProject..covidDeath
order by 1,2

--Looking at the Total Cases vs Total Death in the world
--shows likelihood of dying if you contract covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
From PortfolioProject..covidDeath
where location like '%states%'
order by 1,2

---in Nigeria
select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
From PortfolioProject..covidDeath
where location like '%nigeria%'
order by 1,2

--Looking at the Total Cases vs Population in the world
--shows what percentage of population got covid
select location, date, total_cases, Population, (total_cases/population) * 100 as DeathPercentage
From PortfolioProject..covidDeath
order by 1,2

--Looking at the Total Cases vs Population in Unitrd states
select location, date, total_cases, Population, (total_cases/population) * 100 as DeathPercentage
From PortfolioProject..covidDeath
where location like '%states%'
order by 1,2

--Looking at the Total Cases vs Population in nigeria
select location, date, total_cases, Population, (total_cases/population) * 100 as DeathPercentage
From PortfolioProject..covidDeath
where location like '%nigeria%'
order by 1,2

--looking at countries with highest infection rate compared to population
select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected  
From PortfolioProject..covidDeath
Group by Location, Population 
order by PercentagePopulationInfected desc


--countries with the highest death count per population
select Location, MAX(cast(total_deaths as int)) as TotalDeathCount  
From PortfolioProject..covidDeath
Where continent is not null
Group by Location
order by TotalDeathCount desc

-- Let's break things down by continent.
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount  
From PortfolioProject..covidDeath
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- Showing continent with the highest death count
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount  
From PortfolioProject..covidDeath
Where continent is not null
Group by continent
order by TotalDeathCount desc


--Global numbers
select date, SUM(new_cases)as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(New_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From PortfolioProject..covidDeath
where continent is not null
Group By date
order by 1,2

--Looking at Total Population vs Vaccinations
With PopvsVac (continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) 
OVER (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..covidDeath dea
Join PortfolioProject..CovidVaccination vac
  On dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
order by 2,3
)
select *
From PopvsVac