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
    initial CHAR(1) NOT NULL,
    last_name VARCHAR(255) NOT NULL
);

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
    middle_initial CHAR(1),
    last_name VARCHAR(255) NOT NULL,
	birth_date DATE NOT NULL,
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
	system_type VARCHAR(9), -- local, intertown
	origin_station_id INT NOT NULL,
	destination_station_id INT NOT NULL,
	FOREIGN KEY (origin_station_id) REFERENCES STATION(station_id),
	FOREIGN KEY (destination_station_id) REFERENCES STATION(station_id),
	CONSTRAINT CK_system_type CHECK (system_type IN ('local', 'intertown'))
);

CREATE TABLE TRIP(
    trip_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
	departure TIME NOT NULL,
	arrival TIME NOT NULL,
	cost INT NOT NULL,
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

DELIMITER //
CREATE TRIGGER LOCAL_TRIP_RULES BEFORE INSERT ON TRIP
FOR EACH ROW BEGIN
	IF((SELECT system_type FROM ROUTE r WHERE r.route_id = new.route_id) = 'local'
		AND (new.cost <> 2 OR TIMEDIFF(new.arrival, new.departure) <> '00:05:00')) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "incorrect values for local route";
	END IF;
END //
DELIMITER ;

INSERT INTO TRAIN (model,max_speed,seat_count,toilet_count,has_reclining_seats,has_folding_tables,has_disability_access,has_luggage_storage,has_vending_machines,has_food_service)
VALUES 
("S-000",200,500,10,true,false,true,true,false,true),
("S-001",150,800,7,true,true,false,true,false,true),
("A-000",300,300,6,true,true,true,true,true,true),
("A-001",180,800,10,false,false,true,true,false,true),
("A-002",150,700,8,true,true,false,true,false,true);

INSERT INTO CREW (initial, last_name) VALUES
("D", "Lugod"),
("C", "Onana"),
("F", "Martinez"),
("H", "Fernandes"),
("K", "Rashford");

INSERT INTO MAINTENANCE_LOG (log_date,task,cond,train_id,crew_id)
VALUES
('2024-06-18 13:30:22',"Weekly wash","very good",2,3),
('2024-06-18 09:13:48',"Vending Machine Restock","ok",3,5),
('2024-06-18 15:01:55',"Checked perpetual motion engine","bad",1,1),
('2024-06-18 18:17:36',"Oppressed lower class to back carriage","very good",5,4),
('2024-06-18 22:44:03',"Repainted exterior","ok",4,2),
('2024-06-19 04:39:21',"Brake replacement","bad",2,5),
('2024-06-19 07:41:35',"Seat dusting","excellent",5,1),
('2024-06-19 10:51:29',"Kitchen restocking","ok",4,2),
('2024-06-19 16:30:00',"Oil chance","ok",3,3),
('2024-06-19 17:19:04',"Link checking","very good",1,4);

INSERT INTO PASSENGER (given_name, middle_initial, last_name, birth_date, gender) 
VALUES
('Lucy', 'R', 'Pevensie', '2005-05-25', 'female'),
('Edmund', 'K', 'Pevensie', '2003-03-13', 'male'),
('Susan', 'E', 'Pevensie', '2001-04-18', 'female'),
('Peter', 'A', 'Pevensie', '2000-10-23', 'male'),
('Caspian', 'O', 'Paravel', '1998-05-22', 'male'),
('Harpa', 'L', 'Tarkaan', '1997-03-14', 'female'),
('Mabel', 'D', 'Kirke', '2000-07-09', 'female'),
('Digory', 'C', 'Kirke', '1996-10-04', 'male'),
('Tumnus', 'J', 'Faun', '1990-12-15', 'female'),
('Odette', 'H', 'Cygnus', '2003-08-09', 'female'),
('Jadis', 'S', 'Moonwood', '1999-11-13', 'female'),
('Giselle', 'P', 'von Welsbourg', '2002-12-17', 'female'),
('Maugrim', 'C', 'Mentius', '1998-01-28', 'male'),
('Arista', 'D', 'Farrowe', '1996-05-17', 'female'),
('Cersei', 'M', 'Telmar', '1997-11-05', 'female'),
('Eustace', 'J', 'Scrubb', '2004-09-30', 'male'),
('Enid', 'W', 'Voluns', '2002-09-30', 'female'),
('Theodore', 'C', 'Pire', '2005-07-24', 'male'),
('Briar', 'R', 'Theoden', '2003-08-21', 'female');

INSERT INTO TICKET (total_cost,date_purchased,passenger_id)
VALUES
(6,'2024-11-24',1),
(30,'2024-11-25',2);

INSERT INTO TRIP_SCHEDULE (schedule_date)
VALUES
('2024-11-24'),
('2024-11-25');

INSERT INTO STATION (station_name)
VALUES
('Beaver''s Dam'),
('Allies'' Enclave'),
('The Wardrobe'),
('The Lamp Post'),
('Mr. Tumms'), -- 5
('Aslan''s Camp'),
('Cauldron Pool'),
('Witch''s Camp'),
('The Stone Table'),
('Dancing Lawn'), -- 10
('Anvard'),
('Cherry Tree'),
('Father Christmas');

INSERT INTO ROUTE (system_type, origin_station_id, destination_station_id) 
VALUES
-- Local System Routes (Circular)
('local', 1, 2),
('local', 2, 3),
('local', 3, 4),
('local', 4, 1),

-- Intertown System Routes
('intertown', 5, 2), -- 5
('intertown', 2, 5),
('intertown', 2, 6),
('intertown', 6, 2),
('intertown', 2, 7),
('intertown', 7, 2), -- 10
('intertown', 2, 10),
('intertown', 10, 2),
('intertown', 7, 13),
('intertown', 13, 7),
('intertown', 7, 12), -- 15
('intertown', 12, 7),
('intertown', 12, 13),
('intertown', 13, 12),
('intertown', 13, 8),
('intertown', 8, 13), -- 20
('intertown', 8, 9),
('intertown', 9, 8),
('intertown', 9, 10),
('intertown', 10, 9),
('intertown', 10, 11), -- 25
('intertown', 11, 10);

INSERT INTO TRIP (departure, arrival, cost, train_id, route_id, schedule_id)
VALUES
-- Local trips
('2024-11-24 09:05:00', '2024-11-24 09:10:00', 2, 1, 1, 1),
('2024-11-24 09:12:00', '2024-11-24 09:17:00', 2, 1, 2, 1),
('2024-11-24 09:19:00', '2024-11-24 09:24:00', 2, 1, 3, 1),
('2024-11-24 09:26:00', '2024-11-24 09:31:00', 2, 1, 4, 1),

-- Intertown trips
('2024-11-25 09:05:00', '2024-11-25 10:15:00', 5, 3, 5, 2),
('2024-11-25 10:17:00', '2024-11-25 11:30:00', 6, 3, 9, 2),
('2024-11-25 11:33:00', '2024-11-25 12:48:00', 7, 3, 15, 2),
('2024-11-25 12:50:00', '2024-11-25 13:58:00', 8, 3, 17, 2),
('2024-11-25 14:00:00', '2024-11-25 14:47:00', 4, 3, 19, 2),
('2024-11-25 14:50:00', '2024-11-25 15:42:00', 5, 3, 21, 2),
('2024-11-25 15:44:00', '2024-11-25 16:31:00', 7, 3, 23, 2),
('2024-11-25 16:35:00', '2024-11-25 17:21:00', 8, 3, 12, 2);

INSERT INTO TICKET_TRIP (ticket_id,trip_id)
VALUES
(1,1),
(1,2),
(1,3),
(2,5),
(2,6),
(2,7),
(2,8),
(2,9);

-- SELECT * FROM TRAIN;
-- SELECT * FROM CREW;
-- SELECT * FROM WORKER;
-- SELECT * FROM MAINTENANCE_LOG;
-- SELECT * FROM PASSENGER;
-- SELECT * FROM TICKET;
-- SELECT * FROM TRIP_SCHEDULE;
-- SELECT * FROM STATION;
-- SELECT * FROM ROUTE;
-- SELECT * FROM TRIP;
-- SELECT * FROM TICKET_TRIP;

-- SELECT CONSTRAINT_NAME,TABLE_NAME,COLUMN_NAME,REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME
-- FROM information_schema.KEY_COLUMN_USAGE
-- WHERE TABLE_SCHEMA = 'tt' AND REFERENCED_TABLE_NAME IS NOT NULL;
