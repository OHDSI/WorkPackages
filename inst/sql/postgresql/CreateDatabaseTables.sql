-- Drop old tables if exists

DROP TABLE IF EXISTS package_descriptions;

-- Create tables

CREATE TABLE package_descriptions (
     package_id INT NOT NULL,
     text_field TEXT,
     another_field TEXT,
     PRIMARY KEY(package_id)
);
