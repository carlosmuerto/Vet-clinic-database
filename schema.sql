/* Database schema to keep the structure of entire database. */

CREATE DATABASE vet_clinic
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

CREATE TABLE IF NOT EXISTS public.animals
(
    id bigserial NOT NULL, /* Use Bigserial instead of bigint for the auto increment */
    name character varying(100) NOT NULL,
    date_of_birth date NOT NULL,
    escape_attempts bigint NOT NULL DEFAULT 0,
    neutered boolean NOT NULL DEFAULT FALSE,
    weight_kg numeric NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public.animals
    OWNER to postgres;

ALTER TABLE IF EXISTS public.animals
    ADD COLUMN species character varying(100);


BEGIN;

CREATE TABLE IF NOT EXISTS public.owners
(
    id bigserial NOT NULL,
    full_name character varying NOT NULL,
    age smallint NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT age_nonnegative CHECK (age >= 0) NOT VALID
);

ALTER TABLE IF EXISTS public.owners
    OWNER to postgres;

CREATE TABLE IF NOT EXISTS public.species
(
    id bigserial NOT NULL,
    name character varying NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public.species
    OWNER to postgres;

COMMIT;

/* ALTER animals table to add owners and species */

BEGIN;

ALTER TABLE animals
DROP COLUMN species;

ALTER TABLE IF EXISTS public.animals
  ADD COLUMN species_id bigint,
	ADD	CONSTRAINT fk_animals_species
			FOREIGN KEY (species_id) REFERENCES species (id);


ALTER TABLE IF EXISTS public.animals
  ADD COLUMN owners_id bigint,
	ADD	CONSTRAINT fk_animals_owners
			FOREIGN KEY (owners_id) REFERENCES owners (id);

COMMIT;

/* Create a table named vets with the following columns:  */

BEGIN;

CREATE TABLE IF NOT EXISTS public.vets
(
	id bigserial NOT NULL,
	name character varying NOT NULL,
	age smallint NOT NULL,
	date_of_graduation date NOT NULL,
	PRIMARY KEY (id),
	CONSTRAINT age_nonnegative CHECK (age >= 0) NOT VALID
);

ALTER TABLE IF EXISTS public.vets
	OWNER to postgres;

CREATE TABLE IF NOT EXISTS public.specializations
(
	vets_id bigint REFERENCES vets (id) ON UPDATE CASCADE,
	species_id bigint REFERENCES species (id) ON UPDATE CASCADE,
	CONSTRAINT vets_species_pkey PRIMARY KEY (vets_id, species_id)
);

ALTER TABLE IF EXISTS public.specializations
	OWNER to postgres;

CREATE TABLE IF NOT EXISTS public.visits
(
	vets_id bigint REFERENCES vets (id) ON UPDATE CASCADE,
	animals_id bigint REFERENCES animals (id) ON UPDATE CASCADE,
	date_of_visits date NOT NULL;
	CONSTRAINT vets_animals_pkey PRIMARY KEY (vets_id, animals_id, date_of_visits)
);

ALTER TABLE IF EXISTS public.visits
    OWNER to postgres;

commit;

BEGIN;

ALTER TABLE public.visits
    ALTER COLUMN date_of_visits TYPE timestamp with time zone ;

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(100);

COMMIT;

BEGIN;

CREATE INDEX visits_animals_id_asc ON visits(animals_id ASC);

CREATE INDEX owners_email_asc ON owners(email ASC);

COMMIT;
