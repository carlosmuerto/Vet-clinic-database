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
