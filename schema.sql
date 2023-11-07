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
