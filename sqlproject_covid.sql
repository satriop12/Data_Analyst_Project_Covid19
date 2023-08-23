-- Global Number of Covid Cases and Deaths
SELECT location, SUM(new_deaths) AS Total_Death_World, SUM(new_cases) AS Total_Cases_World, SUM(new_deaths)/NULLIF(SUM(new_cases)*100, 0) AS Death_Percentage
FROM `coursera-cleaningdata-week3.covid.covid_indonesia`
WHERE continent IS NOT NULL 
GROUP BY location
order by Death_Percentage


-- Looking at continent with highest death count
SELECT continent, MAX(total_deaths) AS max_total_deaths
FROM `coursera-cleaningdata-week3.covid.covid_indonesia`
-- WHERE location = "Indonesia"
WHERE continent IS NOT NULL
-- kalo continentnya null, locationnya  jadi benua, jadi datanya harus kalo dia ga null
GROUP BY continent
ORDER BY max_total_deaths DESC


-- Looking at country with highest death count
SELECT location, population, MAX(total_deaths) AS max_total_deaths
FROM `coursera-cleaningdata-week3.covid.covid_indonesia`
-- WHERE location = "Indonesia"
WHERE continent IS NOT NULL
-- kalo continentnya null, locationnya  jadi benua, jadi datanya harus kalo dia ga null
GROUP BY location, population
ORDER BY max_total_deaths DESC

-- Looking at country with highest infection rate
SELECT location, population, MAX(total_cases) AS Highest_infection_count, MAX((total_cases/population)*100) AS percentage_of_population_infected
FROM `coursera-cleaningdata-week3.covid.covid_indonesia`
-- WHERE location = "Indonesia"
GROUP BY location, population
ORDER BY percentage_of_population_infected DESC
-- Looking at country with highest infection rate
SELECT location, population, date, MAX(total_cases) AS Highest_infection_count, MAX((total_cases/population)*100) AS percentage_of_population_infected
FROM `coursera-cleaningdata-week3.covid.covid_indonesia`
-- WHERE location = "Indonesia"
GROUP BY location, population, date
ORDER BY percentage_of_population_infected DESC


-- Looking at total cases vs population
-- Shows percentage of population got covid
SELECT date, location, total_cases, population, (total_cases/population)*100 AS percentage_of_population_infected
FROM `coursera-cleaningdata-week3.covid.covid_indonesia`
WHERE location = "Indonesia"
ORDER BY date 


-- Looking at total cases vs total deaths
-- chance of dying if contract with covid
SELECT
  location,
  total_cases,
  total_deaths,
  (total_deaths / total_cases) * 100 AS chance_of_deaths
FROM
  `coursera-cleaningdata-week3.covid.covid_indonesia`
WHERE
  location IS NOT NULL;

SELECT
  location,
  SUM(total_cases) AS total_cases,
  SUM(total_deaths) AS total_deaths,
  (SUM(total_deaths) / SUM(total_cases)) * 100 AS chance_of_deaths
FROM
  `coursera-cleaningdata-week3.covid.covid_indonesia`
WHERE
  location IS NOT NULL
GROUP BY
  location
ORDER BY
  chance_of_deaths DESC;


-- Looking at total population vs vaccinations with Common Table Expression
WITH Population_vs_Vaccine AS (
    SELECT
        continent,
        location,
        date,
        population,
        new_vaccinations,
        SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location) AS Rolling_People_Vaccinated
    FROM
        `coursera-cleaningdata-week3.covid.covid_indonesia`
    WHERE
        continent IS NOT NULL
)
SELECT *
FROM Population_vs_Vaccine;



-- Looking at the Percetage of People Arround the world that got infected

WITH CalculatedData AS (
  SELECT
    date,
    SUM(total_cases) AS Total_Cases,
    SUM(population) AS Population_World,
    (SUM(total_cases) / SUM(population)) * 100 AS Percentage_of_population_infected
  FROM
    `coursera-cleaningdata-week3.covid.covid_indonesia`
  WHERE
    location IS NOT NULL
  GROUP BY
    date
)
SELECT
  date,
  Total_Cases,
  Population_World,
  Percentage_of_population_infected
FROM
  CalculatedData
ORDER BY
  date ASC;



-- Looking at the Percetage of People Arround the world that got vaccinated

WITH CalculatedData AS (
  SELECT
    date,
    SUM(new_people_vaccinated_smoothed) AS People_with_Full_Vaccine,
    SUM(population) AS Population_World,
    (SUM(people_fully_vaccinated) / SUM(population)) * 100 AS Percent_People_Got_Vaccine
  FROM
    `coursera-cleaningdata-week3.covid.covid_indonesia`
  WHERE
    location IS NOT NULL
  GROUP BY
    date
)
SELECT
  date,
  CalculatedData.People_with_Full_Vaccine,
  CalculatedData.Population_World,
  CalculatedData.Percent_People_Got_Vaccine
FROM
  CalculatedData
WHERE 
  CalculatedData.Percent_People_Got_Vaccine < 100
ORDER BY
  date ASC;



