/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon".
SELECT * FROM animals
WHERE name LIKE '%mon';
-- List the name of all animals born between 2016 and 2019.
SELECT * FROM animals
WHERE date_of_birth >= '2016-01-01' AND date_of_birth <= '2019-01-01';
-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT * FROM animals
WHERE neutered = true AND escape_attempts < 3;
-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT * FROM animals
WHERE name IN ('Agumon', 'Pikachu');
-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals
WHERE weight_kg > 10.5;
-- Find all animals that are neutered.
SELECT * FROM animals
WHERE neutered = true;
-- Find all animals not named Gabumon.
SELECT * FROM animals
WHERE name NOT IN ('Gabumon');
-- Find all animals with a weight between 10.4kg and 17.3kg (inclusive)
SELECT * FROM animals
WHERE weight_kg >= 10.4 and weight_kg <= 17.3;

-- Inside a transaction update the animals table by setting the species column to unspecified then rollback.
BEGIN;
	UPDATE animals
	SET species = 'undefined'
	WHERE species IS NULL;
	ROLLBACK;

-- update species
	BEGIN;
	UPDATE animals
	SET species = 'digimon'
	WHERE name LIKE '%mon';
	UPDATE animals
	SET species = 'pokemon'
	WHERE name NOT LIKE '%mon';
	COMMIT;

-- Remove animals older than 2022-01-01
BEGIN;
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';
SAVEPOINT REMOVE1;

-- make all weights negative
UPDATE animals
SET weight_kg = weight_kg * -1;

ROLLBACK TO REMOVE1;

-- make all negative weights positive
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
COMMIT;

-- Write queries to answer the following questions:

-- How many animals are there?
SELECT COUNT(*) FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals 
WHERE escape_attempts = 0

-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, MAX(escape_attempts) FROM animals 
GROUP BY neutered;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) AS min_weight_kg, MAX(weight_kg) AS max_weight_kg FROM animals 
GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, date_of_birth, AVG(escape_attempts) AS avg_escape_attempts FROM animals 
GROUP BY species, date_of_birth 
HAVING date_of_birth BETWEEN '1990-01-01' AND '2000-01-01';

-- What animals belong to Melody Pond?
SELECT name 
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name 
FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.id = 2;

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name, animals.name
FROM owners
LEFT JOIN animals ON animals.owner_id = owners.id;


-- How many animals are there per species?
SELECT species.name, COUNT(animals.species_id)
FROM animals
JOIN species ON animals.species_id = species.id
GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name, owners.full_name
FROM animals
JOIN owners ON animals.owner_id = owners.id
JOIN species ON animals.species_id = species.id
WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name, owners.full_name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE animals.escape_attempts = 0 AND owners.full_name = 'Dean Winchester';

-- Who owns the most animals?

SELECT owners.full_name, COUNT(*) AS pet_count
FROM owners
JOIN animals ON animals.owner_id = owners.id
GROUP BY owners.full_name
ORDER BY pet_count DESC
LIMIT 1;

