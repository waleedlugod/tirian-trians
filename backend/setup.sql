DROP DATABASE tt;
CREATE DATABASE tt;
USE tt;
CREATE TABLE test(
    id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
INSERT INTO test(name) VALUES("tt");

CREATE TABLE TRAIN(
    train_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    model VARCHAR(5) NOT NULL,
    max_speed INT NOT NULL,
    seat_count INT NOT NULL,
    toilet_count INT NOT NULL,
    has_reclining_seats BOOL NOT NULL,
    has_folding_tables BOOL NOT NULL,
    has_disability_access BOOL NOT NULL,
    has_luggage_storage BOOL NOT NULL,
    has_vending_machines BOOL NOT NULL,
    has_food_service BOOL NOT NULL
);

CREATE TABLE CREW(
    crew_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    manager_id INT NOT NULL,
    FOREIGN KEY (manager_id) REFERENCES WORKER(worker_id) ON DELETE RESTRICT
);

CREATE TABLE MAINTENANCE_LOG(
    maintenance_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    log_date DATE NOT NULL,
    task TEXT NOT NULL,
    condition VARCHAR(255) NOT NULL,
    train_id INT NOT NULL,
    crew_id INT NOT NULL,
    FOREIGN KEY (train_id) REFERENCES TRAIN(train_id) ON DELETE RESTRICT,
    FOREIGN KEY (crew_id) REFERENCES CREW(crew_id) ON DELETE RESTRICT
);


CREATE TABLE WORKER(
    worker_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    given_name VARCHAR(255) NOT NULL,
    middle_initial VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    crew_id INT NOT NULL,
    FOREIGN KEY (crew_id) REFERENCES CREW(crew_id) ON DELETE RESTRICT
);
