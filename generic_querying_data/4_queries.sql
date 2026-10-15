-- 4.a. Count of countries for each continent
select 
	c."name",
	count(cr.continent_id) as countries_count
from continents c
join countries cr on cr.continent_id = c.continent_id 
group by cr.continent_id, c."name"; 
--  4.b. Total area for each continent (print continent name and total area), sorted by area from biggest to smallest
select 
	c."name",
	SUM(cs.area) as total_area
from continents c
join countries cs on cs.continent_id = c.continent_id
group by c.continent_id, c.name
order by  total_area desc;

-- 4.c. Average population density per continent
WITH country_populations AS (
    SELECT 
        c.country_id,
        c.continent_id,
        COUNT(ch.person_id) AS population
    FROM countries c
    LEFT JOIN citizenships ch ON c.country_id = ch.country_id
    GROUP BY c.country_id, c.continent_id 
)
SELECT
    c.name AS continent_name,
    AVG(cp.population) AS avg_population_per_country
FROM continents c
JOIN country_populations cp ON cp.continent_id = c.continent_id
GROUP BY c.continent_id, c.name;

-- 4.d. For each continent, find a country with the smallest area (print continent name, country name and area)
SELECT DISTINCT ON (cs.continent_id)
    cs.name AS continent_name,
    c.name AS country_name,
    c.area
FROM continents cs
JOIN countries c ON c.continent_id = cs.continent_id
ORDER BY cs.continent_id, c.area ASC;

-- 4.e. Find all continents, which have average country population less than 20 million
    WITH country_populations AS (
        SELECT 
            c.country_id,
            c.continent_id,
            COUNT(ch.person_id) AS population
        FROM countries c
        LEFT JOIN citizenships ch ON c.country_id = ch.country_id
        GROUP BY c.country_id, c.continent_id
    )
    SELECT 
        ct.continent_id,
        ct.name AS continent_name,
        AVG(cp.population) AS avg_country_population
    FROM continents ct
    JOIN country_populations cp ON ct.continent_id = cp.continent_id
    GROUP BY ct.continent_id, ct.name
    HAVING AVG(cp.population) < 20000000;