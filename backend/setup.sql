DROP DATABASE tt;
CREATE DATABASE tt;
USE tt;

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
    manager_id INT NOT NULL
);

CREATE TABLE WORKER(
    worker_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    given_name VARCHAR(255) NOT NULL,
    middle_initial VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    crew_id INT NOT NULL,
    FOREIGN KEY (crew_id) REFERENCES CREW(crew_id)
);

ALTER TABLE CREW ADD CONSTRAINT FK_CREW_WORKER
    FOREIGN KEY (manager_id) REFERENCES WORKER(worker_id);

CREATE TABLE MAINTENANCE_LOG(
    maintenance_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    log_date DATETIME NOT NULL,
    task VARCHAR(255) NOT NULL,
    cond VARCHAR(255) NOT NULL, -- bad, ok, very good, excellent
    train_id INT NOT NULL,
    crew_id INT NOT NULL,
    FOREIGN KEY (train_id) REFERENCES TRAIN(train_id),
    FOREIGN KEY (crew_id) REFERENCES CREW(crew_id),
	CONSTRAINT CK_cond CHECK (cond IN ('bad', 'ok', 'very good', 'excellent'))
);

CREATE TABLE PASSENGER(
    passenger_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    given_name VARCHAR(255) NOT NULL,
    middle_initial VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
	birth_date DATETIME NOT NULL,
	gender VARCHAR(6) NOT NULL, -- male, female
	CONSTRAINT CK_gender CHECK (gender IN ('male', 'female'))
);

CREATE TABLE TICKET(
    ticket_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
	total_cost INT NOT NULL,
	date_purchased DATETIME NOT NULL,
	passenger_id INT NOT NULL,
	FOREIGN KEY (passenger_id) REFERENCES PASSENGER(passenger_id)
);

CREATE TABLE TRIP_SCHEDULE(
    schedule_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
	schedule_date DATE NOT NULL
);

CREATE TABLE STATION(
    station_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
	station_name VARCHAR(255) NOT NULL
);

CREATE TABLE ROUTE(
    route_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
	travel_time TIME NOT NULL,
	system_type VARCHAR(9), -- local, intertown
	origin_station_id INT NOT NULL,
	destination_station_id INT NOT NULL,
	FOREIGN KEY (origin_station_id) REFERENCES STATION(station_id),
	FOREIGN KEY (destination_station_id) REFERENCES STATION(station_id),
	CONSTRAINT CK_system_type CHECK (system_type IN ('local', 'intertown'))
);

CREATE TABLE TRIP(
    trip_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
	departure DATETIME NOT NULL,
	arrival DATETIME NOT NULL,
	train_id INT NOT NULL,
	route_id INT NOT NULL,
	schedule_id INT NOT NULL,
	FOREIGN KEY (train_id) REFERENCES TRAIN(train_id),
	FOREIGN KEY (route_id) REFERENCES ROUTE(route_id),
	FOREIGN KEY (schedule_id) REFERENCES TRIP_SCHEDULE(schedule_id)
);

CREATE TABLE TICKET_TRIP(
    ticket_trip_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
	ticket_id INT NOT NULL,
	trip_id INT NOT NULL,
	FOREIGN KEY (ticket_id) REFERENCES TICKET(ticket_id),
	FOREIGN KEY (trip_id) REFERENCES TRIP(trip_id)
);
