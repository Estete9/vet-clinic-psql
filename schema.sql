/* Database schema to keep the structure of the entire database. */


CREATE TABLE animals(
  id				      INT GENERATED ALWAYS AS IDENTITY,
  name			      VARCHAR(100) NOT NULL,
  date_of_birth		DATE,
  escape_attempts	INT NOT NULL,
  neutered 			  BOOLEAN NOT NULL,
  weight_kg			  DECIMAL NOT NULL,
  PRIMARY KEY(id)
);

ALTER TABLE animals
ADD COLUMN species VARCHAR(100);

CREATE TABLE owners(
  id				      INT GENERATED ALWAYS AS IDENTITY,
  full_name			      VARCHAR(100) NOT NULL,
  age		INT,
  PRIMARY KEY(id)
);

CREATE TABLE species(
  id				      INT GENERATED ALWAYS AS IDENTITY,
  name			      VARCHAR(100) NOT NULL,
  PRIMARY KEY(id)
);

-- Set "id" as auto-incremented primary key
ALTER TABLE animals
ALTER COLUMN id SET GENERATED ALWAYS AS IDENTITY PRIMARY KEY;

-- Remove the "species" column
ALTER TABLE animals
DROP COLUMN species;

-- Add the "species_id" column as a foreign key
ALTER TABLE animals
ADD COLUMN species_id INT,
ADD CONSTRAINT fk_species_id
FOREIGN KEY (species_id)
REFERENCES species(id);

-- Add the "owner_id" column as a foreign key
ALTER TABLE animals
ADD COLUMN owner_id INT,
ADD CONSTRAINT fk_owner_id
FOREIGN KEY (owner_id)
REFERENCES owners(id);
