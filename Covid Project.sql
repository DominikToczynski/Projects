--SELECT * 
--FROM covid..cd
--ORDER BY 3,4

--SELECT *
--FROM covid..cv
--ORDER BY 3,4

-- Select data needed for project

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid..cd
ORDER BY 1,2;

-- total cases vs total deaths

SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100,2) AS death_pct
FROM covid..cd
WHERE location = 'Poland'
ORDER BY 1,2

-- total cases vs population

SELECT location, date, total_cases, population, ROUND((total_cases/population)*100,2) AS popul_pct
FROM covid..cd
WHERE location = 'Poland'
ORDER BY 1,2

-- highest infection rates in countries with population between 30 and 40 mln

SELECT TOP 10 location, MAX(total_cases) max_total, population, ROUND((MAX(total_cases)/population)*100,2) AS max_popul_pct, ROUND((MAX(total_deaths)/MAX(total_cases))*100,2) AS death_pct
FROM covid..cd
WHERE population BETWEEN 30000000 AND 40000000
GROUP BY population, location
ORDER BY max_popul_pct DESC


-- higest death count per country in the world

SELECT location, population, MAX(CAST(total_deaths AS INT)) AS total_deaths_count
FROM covid..cd
WHERE location NOT IN ('World', 'Europe', 'North America','European Union', 'South America', 'Asia', 'Africa', 'Oceania', 'International')
-- or where continent is not null
GROUP BY location, population
ORDER BY total_deaths_count DESC

-- higest death count per continent in the world

SELECT location, MAX(CAST(total_deaths AS INT)) AS total_deaths_count
FROM covid..cd
WHERE continent IS NULL AND location <> 'World'
GROUP BY location
ORDER BY total_deaths_count DESC

--SELECT DISTINCT(location), population
--FROM covid..cd
--WHERE continent = 'Asia'

-- global numbers

SELECT date, SUM(new_cases) sum_new_cases, SUM(CAST(new_deaths AS INT))sum_new_deaths, CONCAT(ROUND(SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100, 2), + ' %') death_pct
FROM covid..cd
WHERE continent IS NOT NULL
GROUP BY date

-- table join for CD and CV

SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_vacc_count
FROM covid..cd cd
JOIN covid..cv cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3

-- CTE

With popvsvacc (continent, location, date, population, new_vaccinations, rolling_vacc_count)
AS
(
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_vacc_count
FROM covid..cd cd
JOIN covid..cv cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
)
SELECT *, ROUND((rolling_vacc_count/population)*100,2) total_vax
FROM popvsvacc
WHERE location = 'Poland'
ORDER BY total_vax DESC

-- view for later data visualizations

CREATE VIEW world_count AS
SELECT location, MAX(CAST(total_deaths AS INT)) AS total_deaths_count
FROM covid..cd
WHERE continent IS NULL AND location <> 'World'
GROUP BY location

SELECT * FROM world_count
ORDER BY 2 DESC