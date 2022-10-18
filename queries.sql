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
