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
	PRIMARY KEY (id),
	CONSTRAINT age_nonnegative CHECK (age >= 0) NOT VALID
);

ALTER TABLE IF EXISTS public.vets
	OWNER to postgres;

SELECT * FROM vets;

CREATE TABLE IF NOT EXISTS public.specializations
(
	vets_id bigint REFERENCES vets (id) ON UPDATE CASCADE,
    species_id bigint REFERENCES species (id) ON UPDATE CASCADE,
	CONSTRAINT vets_species_pkey PRIMARY KEY (vets_id, species_id)
);

ALTER TABLE IF EXISTS public.specializations
    OWNER to postgres;
