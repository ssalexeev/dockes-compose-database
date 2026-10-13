CREATE TABLE continents (
    continent_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE countries (
    country_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    country_code CHAR(2) NOT NULL UNIQUE,
    continent_id INT NOT NULL,
    area NUMERIC(12, 2) NOT NULL DEFAULT 0, -- Area in sq km (e.g., up to 999,999,999.99)
    CONSTRAINT fk_country_continent 
        FOREIGN KEY (continent_id) 
        REFERENCES continents(continent_id) 
        ON DELETE RESTRICT
);

CREATE TABLE people (
    person_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    date_of_birth DATE NOT NULL
);

CREATE TABLE citizenships (
    person_id INT NOT NULL,
    country_id INT NOT NULL,
    granted_date DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (person_id, country_id),
    CONSTRAINT fk_citizenship_person 
        FOREIGN KEY (person_id) 
        REFERENCES people(person_id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_citizenship_country 
        FOREIGN KEY (country_id) 
        REFERENCES countries(country_id) 
        ON DELETE CASCADE
);

-- Insert Continents
INSERT INTO continents (name) VALUES
('Africa'),
('Asia'),
('Europe'),
('North America'),
('South America'),
('Oceania'),
('Antarctica');

-- Insert Countries linked to Continents with Area (in sq km)
INSERT INTO countries (name, country_code, continent_id, area) VALUES
('Canada', 'CA', 4, 9984670.00),
('United States', 'US', 4, 9833517.00),
('Germany', 'DE', 3, 357022.00),
('France', 'FR', 3, 551695.00),
('Japan', 'JP', 2, 377975.00),
('Brazil', 'BR', 5, 8515767.00),
('Australia', 'AU', 6, 7692024.00);
-- Insert Sample People
INSERT INTO people (first_name, last_name, email, date_of_birth) VALUES
('Alice', 'Smith', 'alice.smith@example.com', '1990-05-14'),
('Bob', 'Jones', 'bob.jones@example.com', '1985-11-22'),
('Carlos', 'Silva', 'carlos.silva@example.com', '1993-02-01'),
('Diana', 'Prince', 'diana.prince@example.com', '1988-07-19'),
('Elena', 'Russo', 'elena.russo@example.com', '1995-12-03');

-- Assign Citizenships (Demonstrating Dual/Multiple Citizenships)
INSERT INTO citizenships (person_id, country_id, granted_date) VALUES
(1, 1, '1990-05-14'), -- Alice: Canada
(1, 2, '2015-06-01'), -- Alice: United States (Dual Citizen)
(2, 2, '1985-11-22'), -- Bob: United States
(3, 6, '1993-02-01'), -- Carlos: Brazil
(3, 4, '2018-09-10'), -- Carlos: France (Dual Citizen)
(4, 3, '1988-07-19'), -- Diana: Germany
(4, 5, '2010-04-12'), -- Diana: Japan (Dual Citizen)
(4, 1, '2021-01-15'), -- Diana: Canada (Triple Citizen)
(5, 4, '1995-12-03'); -- Elena: France