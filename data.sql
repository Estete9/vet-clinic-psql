/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES
  ('Agumon', '2020-02-03', 0, true, 10.23),
  ('Gabumon', '2018-11-15', 2, true, 8.0),
  ('Pikachu', '2021-01-07', 1, false, 15.04),
  ('Devimon', '2017-05-12', 5, true, 11.0);

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES
	('Charmander', '2020-02-08', 0, false, 11.0),
	('Plantmon', '2021-11-15', 2, true, 5.7),
	('Squirtle', '1993-04-02', 3, false, 12.13),
	('Angemon', '2005-06-12', 1, true, 45.0),
	('Boarmon', '2005-06-07', 7, true, 20.4),
	('Blossom', '1998-10-13', 3, true, 17.0),
	('Ditto', '2022-05-14', 4, true, 22.0);

-- Add values to owners table
INSERT INTO owners (full_name, age)
VALUES
	('Sam Smith', 34),
	('Jennifer Orwell', 19),
	('Bob', 45),
	('Melody Pond', 77),
	('Dean Winchester', 14),
	('Jodie Whittaker', 38);

-- Add values to species table
INSERT INTO species(name)
VALUES
	('Digimon'),
	('Pokemon');

-- Set all animals' species id
UPDATE animals
SET species_id = CASE
	WHEN name LIKE '%mon' THEN 1 
	ELSE 2
END;

-- Set all animals' owners id
UPDATE animals
SET owner_id = CASE
	WHEN name = 'Agumon' THEN 1 
	WHEN name = 'Gabumon' OR name = 'Pikachu' THEN 2
	WHEN name = 'Devimon' OR name = 'Plantmon' THEN 3
	WHEN name = 'Charmander' OR name = 'Squirtle' OR name = 'Blossom' THEN 4
	WHEN name = 'Angemon' OR name = 'Boarmon' THEN 5
END;

-- Set data for vets
INSERT INTO vets(name, age, date_of_graduation)
VALUES
('William Tatcher', 45, '2000-04-23'),
('Maisy Smith', 26, '2019-01-17'),
('Stephanie Mendez', 64, '1981-05-04'),
('Jack Harkness', 38, '2008-06-08');

-- Set data for specializations
INSERT INTO specializations(vet_id, species_id)
VALUES
(1, 2),
(3, 1),
(3, 2),
(4, 1);

-- Set data for visits
INSERT INTO visits(animal_id, vet_id, date_of_visit)
VALUES
(1, 1, '2020-05-24'),
(1, 3, '2020-07-22'),
(2, 4, '2021-02-02'),
(3, 2, '2020-01-05'),
(3, 2, '2020-03-08'),
(3, 2, '2020-05-14'),
(4, 3, '2021-05-04'),
(5, 4, '2021-02-24'),
(6, 2, '2019-12-21'),
(6, 1, '2020-08-10'),
(6, 2, '2021-04-07'),
(7, 3, '2019-09-29'),
(8, 4, '2020-10-03'),
(8, 4, '2020-11-04'),
(9, 2, '2019-01-24'),
(9, 2, '2019-05-15'),
(9, 2, '2020-02-27'),
(9, 2, '2020-08-03'),
(10, 3, '2020-05-24'),
(10, 1, '2021-01-11');

/*
*/
-- ENSSAH data insert:
-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.) 
-- (may need to do add this several times so it exceeds 1 second execution time)
INSERT INTO visits (animal_id, vet_id, date_of_visit) 
SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';
