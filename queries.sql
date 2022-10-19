/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name = 'Luna';

/* Find all animals whose name ends in "mon". */
SELECT * FROM public.animals WHERE name LIKE '%mon';

/* List the name of all animals born between 2016 and 2019. */
SELECT name FROM public.animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

/* List the name of all animals that are neutered and have less than 3 escape attempts */
SELECT
	name
FROM
	public.animals
WHERE
	neutered
	AND escape_attempts < 3;

/* List the date of birth of all animals named either "Agumon" or "Pikachu". */
SELECT
	date_of_birth
FROM
	public.animals
WHERE
	name = 'Agumon'
	OR name = 'Pikachu';

/* List name and escape attempts of animals that weigh more than 10.5kg */
SELECT
	name,
	escape_attempts
FROM
	public.animals
WHERE
	weight_kg > 10.5;

/* Find all animals that are neutered. */
SELECT
	*
FROM
	public.animals
WHERE
	neutered;

/* Find all animals not named Gabumon. */
SELECT
	*
FROM
	public.animals
WHERE
	name <> 'Gabumon';

/* Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg) */
SELECT
	*
FROM
	public.animals
WHERE
	 weight_kg BETWEEN 10.4 AND 17.3;

/* Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction. */
BEGIN;

UPDATE public.animals
	SET species = 'unspecified';

ROLLBACK;

/* Update the animals table by setting the species column to digimon for all animals that have a name ending in mon. */
BEGIN;

UPDATE public.animals
	SET species = 'digimon'
WHERE name LIKE '%mon';

SELECT * FROM public.animals;

/* Update the animals table by setting the species column to pokemon for all animals that don't have species already set. */

UPDATE public.animals
	SET species = 'pokemon'
WHERE species is NULL;

SELECT * FROM public.animals;

/*  Commit the transaction. */
COMMIT;

/*  Now, take a deep breath and... **Inside a transaction** delete all records in the `animals` table, then roll back the transaction. */

BEGIN;

DELETE FROM public.animals;

SELECT * FROM public.animals;

/* After the rollback verify if all records in the `animals` table still exists. After that, you can start breathing as usual ;)  */

ROLLBACK;

SELECT * FROM public.animals;

/*  Delete all animals born after Jan 1st, 2022. */

BEGIN;

DELETE FROM public.animals
WHERE date_of_birth > '2022-01-01';

SELECT * FROM public.animals;

/* Create a savepoint for the transaction. */

SAVEPOINT  UpdateAllWeight;

/* Update all animals' weight to be their weight multiplied by -1. */

UPDATE public.animals
	SET weight_kg = weight_kg * (-1);

SELECT * FROM public.animals;

/* Rollback to the savepoint */

ROLLBACK TO SAVEPOINT UpdateAllWeight;


/* Update all animals' weights that are negative to be their weight multiplied by -1. */

UPDATE public.animals
	SET weight_kg = weight_kg * (-1)
WHERE weight_kg < 0;

SELECT * FROM public.animals;

/*  Commit transaction */

COMMIT;


/* How many animals are there? */

SELECT COUNT(*) as animals
FROM public.animals;

/* How many animals have never tried to escape? */

SELECT
	COUNT(*) as animals_that_escape
FROM
	public.animals
WHERE
	escape_attempts = 0;

/* What is the average weight of animals */

SELECT
	AVG(weight_kg) as average_weight
FROM
	public.animals;

/* Who escapes the most, neutered or not neutered animals? */

SELECT
	are_neutered AS who_escape_most_are_neutered
FROM
	(SELECT
		neutered AS are_neutered,
		COUNT(escape_attempts) count_has_escape
	FROM
		public.animals
	WHERE
	escape_attempts <> 0
	GROUP BY neutered) AS count_netured_has_escape
WHERE
	count_has_escape = (SELECT max(count_has_escape) FROM (SELECT
		neutered AS are_neutered,
		COUNT(escape_attempts) count_has_escape
	FROM
		public.animals
	WHERE
	escape_attempts <> 0
	GROUP BY neutered) AS count_netured_has_escape);

/* What is the minimum and maximum weight of each type of animal? */
SELECT
	species,
	MIN(weight_kg),
	MAX(weight_kg)
FROM
	public.animals
GROUP BY
	species;

/*  What is the average number of escape attempts per animal type
of those born between 1990 and 2000? */
SELECT
	species,
	AVG(escape_attempts) AVG_escape_attempts
FROM
	public.animals
 WHERE
 	date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY
	species;



/* What animals belong to Melody Pond? */

SELECT
	animals.name,
	animals.date_of_birth,
	animals.escape_attempts,
	animals.neutered,
	animals.weight_kg,
	owners.full_name as owner,
	species.name as species
FROM
	animals
	INNER JOIN owners ON owners.id = animals.owners_id
	INNER JOIN species ON species.id = animals.species_id
WHERE
	owners.full_name = 'Melody Pond';

/* List of all animals that are pokemon (their type is Pokemon). */

SELECT
	animals.name,
	animals.date_of_birth,
	animals.escape_attempts,
	animals.neutered,
	animals.weight_kg,
	owners.full_name as owner,
	species.name as species
FROM
	animals
	INNER JOIN owners ON owners.id = animals.owners_id
	INNER JOIN species ON species.id = animals.species_id
WHERE
	species.name = 'Pokemon';

/* List all owners and their animals, remember to include those that don't own any animal. */

SELECT
	owners.full_name as owner,
	animals.name,
	animals.date_of_birth,
	animals.escape_attempts,
	animals.neutered,
	animals.weight_kg,
	owners.age as owner_age,
	species.name as species
FROM
	animals
	RIGHT JOIN species ON species.id = animals.species_id
	RIGHT JOIN owners ON owners.id = animals.owners_id;

/* How many animals are there per species? */

SELECT
	COUNT(*) count_per_species,
	species.name as species
FROM
	animals
	RIGHT JOIN species ON species.id = animals.species_id
GROUP BY
	species;

/* List all Digimon owned by Jennifer Orwell. */

SELECT
	animals.name,
	animals.date_of_birth,
	animals.escape_attempts,
	animals.neutered,
	animals.weight_kg,
	owners.full_name as owner,
	owners.age as owner_age,
	species.name as species
FROM
	animals
	INNER JOIN owners ON owners.id = animals.owners_id
	INNER JOIN species ON species.id = animals.species_id
WHERE
	owners.full_name = 'Jennifer Orwell'
	AND species.name = 'Digimon';

/* List all animals owned by Dean Winchester that haven't tried to escape. */

SELECT
	animals.name,
	animals.date_of_birth,
	animals.escape_attempts,
	animals.neutered,
	animals.weight_kg,
	owners.full_name as owner,
	owners.age as owner_age,
	species.name as species
FROM
	animals
	INNER JOIN owners ON owners.id = animals.owners_id
	INNER JOIN species ON species.id = animals.species_id
WHERE
	owners.full_name = 'Dean Winchester'
	AND animals.escape_attempts = 0;

/* Who owns the most animals? */

SELECT
	*
FROM (
	SELECT
		owners.full_name as owner,
		COUNT(*) count_animals
	FROM
		animals
		RIGHT JOIN owners ON owners.id = animals.owners_id
	GROUP BY
		owners.full_name
) AS count_animals_per_owner
WHERE
	count_animals_per_owner.count_animals = (
		SELECT
			MAX(count_per_species)
		FROM (
			SELECT
				owners.full_name as owner,
				COUNT(*) count_per_species
			FROM
				animals
				RIGHT JOIN owners ON owners.id = animals.owners_id
			GROUP BY
				owners.full_name
		) AS count_animals_per_owner
	);
