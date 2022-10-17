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
