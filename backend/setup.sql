DROP DATABASE tt;
CREATE DATABASE tt;
USE tt;
CREATE TABLE test(
    id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
INSERT INTO test(name) VALUES("tt");