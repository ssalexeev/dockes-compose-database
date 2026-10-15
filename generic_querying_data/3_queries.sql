-- 3.a. Country with the biggest population (id and name of the country)
SELECT 
    c.country_id, 
    c.name
FROM countries c
JOIN citizenships ch ON c.country_id = ch.country_id
GROUP BY c.country_id, c.name
ORDER BY COUNT(ch.person_id) DESC
LIMIT 1;

-- 3.b. Top 10 countries with the lowest population density (names of the countries)
select c.name
from countries c 
join citizenships ch on c.country_id = ch.country_id
group by c.country_id, c.name
order by count(ch.person_id) asc 
limit 10;

-- 3.c. Countries with population density higher than average across all countries
select c.name
from countries c 
join citizenships ch on c.country_id = ch.country_id
group by c.country_id, c.name
having count(ch.person_id) > avg(ch.person_id);

-- 3.d. Country with the longest name (if several countries have name of the same length, show all of them)
select 
	c.country_id,
	c.name
from countries c
where length(c.name) = (
	select max(length(c2.name))
	from countries c2
);

-- 3.e. All countries with name containing letter “F”, sorted in alphabetical order
select 
	c.country_id,
	c.name
from countries c
where LOWER(c.name) like '%f%'
order by c.name asc;

-- 3.f. Country which has a population, closest to the average population of all countries
WITH country_populations AS (
    SELECT 
        c.country_id,
        c.name,
        COUNT(ch.person_id) AS population
    FROM countries c
    LEFT JOIN citizenships ch ON c.country_id = ch.country_id
    GROUP BY c.country_id, c.name
)
SELECT 
    country_id,
    name,
    population,
    ABS(population - (SELECT AVG(population) FROM country_populations)) AS diff_from_avg
FROM country_populations
ORDER BY diff_from_avg ASC
LIMIT 1;
