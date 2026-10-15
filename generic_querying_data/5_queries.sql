-- 5.a. Person with the biggest number of citizenships
select 
	p.first_name,
	count(c.person_id) as cz_ships_count
from people p 
join citizenships c on c.person_id = p.person_id
group by p.first_name
order by cz_ships_count desc
limit 1;
-- 5.b. All people who have no citizenship
SELECT 
    p.person_id,
    p.first_name,
    p.last_name
FROM people p
LEFT JOIN citizenships c ON p.person_id = c.person_id
WHERE c.person_id IS NULL;
-- 5.c. Country with the least people in People table
SELECT 
    c.country_id, 
    c.name
FROM countries c
JOIN citizenships ch ON c.country_id = ch.country_id
GROUP BY c.country_id, c.name
ORDER BY COUNT(ch.person_id) ASC
LIMIT 1;
-- 5.d. Continent with the most people in People table
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
    SUM(cp.population) AS continent_population
FROM continents ct
JOIN country_populations cp ON ct.continent_id = cp.continent_id
GROUP BY ct.continent_id, ct.name
order by continent_population desc
limit 1;
-- 5.e. Find pairs of people with the same name - print 2 ids and the name
SELECT
    p.person_id AS first_person_id,
    p2.person_id AS second_person_id,
    p.first_name AS name
FROM people p
JOIN people p2 ON p.first_name = p2.first_name 
              AND p.person_id < p2.person_id;