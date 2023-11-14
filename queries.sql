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

-- Who was the last animal seen by William Tatcher?
SELECT animals.name, animals.id, vets.name, MAX(visits.date_of_visit) AS last_visit_date
FROM vets
JOIN visits ON vets.id = visits.vet_id
JOIN animals ON animals.id = visits.animal_id
GROUP BY vets.name, vets.id, animals.name, animals.id, visits.animal_id, visits.date_of_visit
HAVING vets.name = 'William Tatcher'
ORDER BY visits.date_of_visit DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT vets.name, COUNT(visits.date_of_visit)
FROM vets 
JOIN visits ON vets.id = visits.vet_id
WHERE vets.name = 'Stephanie Mendez'
GROUP BY vets.name;

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name
FROM vets
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT vets.name, animals.name, visits.date_of_visit
FROM animals
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez' AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT animals.id, animals.name, COUNT(visits.date_of_visit) as num_visits
FROM animals
JOIN visits ON visits.animal_id = animals.id
GROUP BY animals.name, animals.id
ORDER BY num_visits DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT ve.name, a.name, vi.date_of_visit
FROM visits vi
JOIN animals a ON vi.animal_id = a.id
JOIN vets ve ON vi.vet_id = ve.id
WHERE ve.name = 'Maisy Smith'
ORDER BY vi.date_of_visit ASC
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.name AS pet_name, a.date_of_birth, a.escape_attempts, a.neutered, a.weight_kg, s.name AS species, ve.name AS vet_name, ve.age, ve.date_of_graduation, vi.date_of_visit
FROM visits vi
JOIN animals a ON vi.animal_id = a.id
JOIN vets ve ON vi.vet_id = ve.id
JOIN species s ON a.species_id = s.id
ORDER BY date_of_visit DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(visits.date_of_visit) AS visits_without_specialist
FROM visits
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
JOIN specializations ON specializations.vet_id = vets.id
WHERE specializations.species_id != animals.species_id;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT COUNT(s.name), s.name as species_name
FROM (
	SELECT COUNT(*), a.species_id
	FROM visits vi
	JOIN vets ON vi.vet_id = vets.id
	JOIN animals a ON vi.animal_id = a.id
	WHERE vets.name = 'Maisy Smith'
	GROUP BY vets.name, a.species_id
	ORDER BY count DESC
	LIMIT 1
) subquery
JOIN animals a ON subquery.species_id = a.species_id
JOIN species s ON a.species_id = s.id
GROUP BY s.name;

-- ENSSAH queries:
-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animal_id, vet_id, date_of_visit)
SELECT animal_ids.id, vets_ids.id, visit_timestamp
FROM
    (SELECT id FROM animals) AS animal_ids,
    (SELECT id FROM vets) AS vets_ids,
    generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') AS visit_timestamp
ON CONFLICT (vet_id, animal_id, date_of_visit) DO NOTHING;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';


EXPLAIN ANALYZE SELECT COUNT(*) FROM visits WHERE animal_id = 4;

SELECT COUNT(*) FROM visits where animal_id = 4;
SELECT * FROM visits where vet_id = 2;
SELECT * FROM owners where email = 'owner_18327@mail.com';
