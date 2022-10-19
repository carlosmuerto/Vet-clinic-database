/* Database schema to keep the structure of entire database. */

CREATE DATABASE vet_clinic
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

CREATE IF NOT EXISTS TABLE public.animals
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

CREATE IF NOT EXISTS TABLE public.owners
(
    id bigserial NOT NULL,
    full_name character varying NOT NULL,
    age smallint NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT age_nonnegative CHECK (age >= 0) NOT VALID
);

ALTER TABLE IF EXISTS public.owners
    OWNER to postgres;

CREATE IF NOT EXISTS TABLE public.species
(
    id bigserial NOT NULL,
    full_name character varying NOT NULL,
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
    ADD COLUMN "species_id " bigint;


ALTER TABLE IF EXISTS public.animals
    ADD COLUMN species_id bigint,
	ADD	CONSTRAINT fk_animals_species
			FOREIGN KEY (species_id) REFERENCES species (id);


ALTER TABLE IF EXISTS public.owners
    ADD COLUMN owners_id bigint,
	ADD	CONSTRAINT fk_animals_owners
			FOREIGN KEY (owners_id) REFERENCES owners (id);

COMMIT;
