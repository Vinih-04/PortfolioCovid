-- Base de Dados
SELECT *
FROM CovidPortfolio..Death_Information
ORDER BY 3,4

-- Base de Dados selecionada
SELECT location, date, population, new_cases, total_cases, total_deaths
FROM CovidPortfolio..Death_Information
ORDER BY 1,2

-- Porcentagem de Morte Brazil
SELECT location, date, total_cases, total_deaths, (CAST(total_deaths as float)/CAST(total_cases as float))*100 AS DeathPercentage
FROM CovidPortfolio..Death_Information
WHERE location = 'Brazil'
ORDER BY 1,2

--Dia Maior Porcentagem Morte Brazil
SELECT *
FROM #table2
WHERE DeathPercentage = (SELECT MAX(DeathPercentage) FROM #table2)

--Porcentagem de casos Brasil
SELECT location, date, total_cases, population, (CAST(total_cases as float)/CAST(population as float))*100 AS CasePercentage
FROM CovidPortfolio..Death_Information
WHERE location = 'Brazil'
ORDER BY 1,2

--Dia Maior Porcentagem Casos Brazil
SELECT *
FROM #table1
WHERE CasePercentage = (SELECT MAX(CasePercentage) FROM #table1)

--Maiores Porcentagens de casos Mundo
SELECT location, date, total_cases, population, (CAST(total_cases as float)/CAST(population as float))*100 AS CasePercentage
FROM CovidPortfolio..Death_Information
WHERE date = '2021-05-04 00:00:00.000'
ORDER BY CasePercentage DESC

--Maiores Porcentagens de mortes Mundo
SELECT location, date, total_cases, total_deaths, (CAST(total_deaths as float)/CAST(total_cases as float))*100 AS DeathPercentage
FROM CovidPortfolio..Death_Information
WHERE date = '2021-05-04 00:00:00.000'
ORDER BY DeathPercentage DESC

--Maiores Porcentagens de mortes Continentes
SELECT location, date, total_cases, total_deaths, (CAST(total_deaths as float)/CAST(total_cases as float))*100 AS DeathPercentage
FROM CovidPortfolio..Death_Information
WHERE date = '2021-05-04 00:00:00.000' AND continent IS NULL
ORDER BY DeathPercentage DESC

-- Novos Casos e Mortes no Mundo
SELECT date, SUM(CAST(new_cases as float)) AS DailyNewCases, SUM(CAST(new_deaths as float)) AS DailyNewDeaths, (SUM(CAST(new_deaths as float))/SUM(CAST(new_cases as float)))*100 AS DailyDeathPercentage
FROM CovidPortfolio..Death_Information
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1

-- Base de Dados
SELECT *
FROM CovidPortfolio..Vaccinations_Information
ORDER BY 3,4
-- Porcentagem de Testes População Países
SELECT dea.location, MAX(CAST(dea.population AS float)) AS Population, 
MAX(CAST(dea.total_cases AS float)) AS Cases, 
MAX(CAST(vac.total_vaccinations AS float)) AS Vaccination,
(MAX(CAST(vac.total_vaccinations AS float))/MAX(CAST(dea.population AS float)))*100 AS PercentageVacinated
FROM CovidPortfolio..Death_Information dea
 JOIN CovidPortfolio..Vaccinations_Information vac
 ON dea.location = vac.location
 AND dea.date = vac.date
 WHERE dea.continent IS NOT NULL
 GROUP BY dea.location
 ORDER BY PercentageVacinated DESC

 --
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS PeopleVaccinated
 FROM CovidPortfolio..Death_Information dea
  JOIN CovidPortfolio..Vaccinations_Information vac
 ON dea.location = vac.location
 AND dea.date = vac.date
 ORDER BY 2,3

 SELECT *, (PeopleVaccinated/population)*100 AS PercentageVaccinated
 FROM #table3
 ORDER BY location, date
