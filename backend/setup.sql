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

CREATE TABLE ROUTES(
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
	FOREIGN KEY (route_id) REFERENCES ROUTES(route_id),
	FOREIGN KEY (schedule_id) REFERENCES TRIP_SCHEDULE(schedule_id)
);

CREATE TABLE TICKET_TRIP(
    ticket_trip_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
	ticket_id INT NOT NULL,
	trip_id INT NOT NULL,
	FOREIGN KEY (ticket_id) REFERENCES TICKET(ticket_id),
	FOREIGN KEY (trip_id) REFERENCES TRIP(trip_id)
);

INSERT INTO TRAIN (model,max_speed,seat_count,toilet_count,has_reclining_seats,has_folding_tables,has_disability_access,has_luggage_storage,has_vending_machines,has_food_service)
VALUES 
("TRN1",200,500,10,true,false,true,true,false,true),
("TRN2",150,800,7,true,true,false,true,false,true),
("TRN3",300,300,6,true,true,true,true,true,true),
("TRN4",180,800,10,false,false,true,true,false,true),
("TRN5",150,700,8,true,true,false,true,false,true);

INSERT INTO CREW (manager_id) 
VALUES 
(5),
(8),
(11),
(13),
(16);

INSERT INTO WORKER (given_name,middle_initial,last_name,crew_id) 
VALUES 
("Roger", "M", "Candari", 1),
("Zoe", "IDK", "Ongkiko", 1),
("Albert", "IDK", "Abdon", 1),
("James", "IDK", "Mostajo", 1),
("Waleed", "IDK", "Lugod", 1), -- 5
("Altay", "A", "Bayindir", 2),
("Tom", "B", "Heaton", 2),
("Andre", "C", "Onana", 2), -- 8
("Victor", "D", "Lindelof", 3),
("Matthijs", "E", "De Ligt", 3),
("Lisandro", "F", "Martinez", 3),
("Noussair", "G", "Mazraoui", 3), -- 12
("Bruno", "H", "Fernandes", 4),
("Manuel", "I", "Ugarte", 4),
("Mason", "J", "Mount", 4), -- 15
("Marcus", "K", "Rashford", 5),
("Joshua", "L", "Zirkzee", 5),
("Alejandro", "M", "Garnacho", 5),
("Rasmus", "N", "Hojlund", 5); -- 20

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
(15,'2024-07-22',1),
(15,'2024-07-22',2),
(15,'2024-07-22',3),
(15,'2024-07-22',4),
(10,'2024-07-24',5),
(10,'2024-07-25',6),
(10,'2024-07-26',7),
(20,'2024-07-26',8),
(25,'2024-07-30',9),
(20,'2024-08-02',10),
(15,'2024-08-02',11),
(10,'2024-08-03',12),
(10,'2024-08-06',13),
(5,'2024-08-06',14),
(10,'2024-08-07',15),
(15,'2024-08-10',16),
(15,'2024-08-10',17),
(10,'2024-08-10',18),
(30,'2024-08-11',19);

INSERT INTO TRIP_SCHEDULE (schedule_date)
VALUES
('2024-07-25'),
('2024-07-30'),
('2024-08-04'),
('2024-08-09'),
('2024-08-14');

INSERT INTO STATION (station_name)
VALUES
('Allies'' Enclave'),
('Beaver Dam''s'),
('The Lamp Post'),
('The Wardrobe'),
('Asian''s Camp'), -- 5
('The Stone Table'),
('Dancing Lawn'),
('Anvard'),
('Cauldron Pool'),
('R. Tumms'),
('Cherry Pool'),
('Witch''s Camp'),
('Father Christmas');

INSERT INTO ROUTES (travel_time, system_type, origin_station_id, destination_station_id) 
VALUES
-- Local System Routes (Circular)
('00:05:00', 'local', 2, 1),
('00:05:00', 'local', 1, 4),
('00:05:00', 'local', 4, 3),
('00:05:00', 'local', 3, 2),

-- Revised Intertown System Routes
('01:05:00', 'intertown', 10, 1),
('01:05:00', 'intertown', 1, 9),
('01:05:00', 'intertown', 1, 7),
('01:05:00', 'intertown', 1, 5),
('01:05:00', 'intertown', 9, 13),
('01:05:00', 'intertown', 9, 11),
('01:05:00', 'intertown', 11, 13),
('01:05:00', 'intertown', 7, 8),
('01:05:00', 'intertown', 7, 6),
('01:05:00', 'intertown', 6, 12),
('01:05:00', 'intertown', 12, 13),
('01:05:00', 'intertown', 8, 7),
('01:05:00', 'intertown', 6, 12),

('00:10:00', 'local', 2, 4),
('00:05:00', 'local', 4, 3),
('00:05:00', 'local', 3, 2),
('00:10:00', 'local', 4, 2),
('00:15:00', 'local', 3, 4),

('01:10:00', 'intertown', 10, 7),
('01:10:00', 'intertown', 10, 5),
('01:05:00', 'intertown', 10, 1),
('01:10:00', 'intertown', 10, 9),
('01:10:00', 'intertown', 1, 13),
('01:15:00', 'intertown', 7, 11),
('01:15:00', 'intertown', 7, 13),
('01:10:00', 'intertown', 6, 13),
('01:10:00', 'intertown', 6, 8),
('01:05:00', 'intertown', 12, 13),
('01:20:00', 'intertown', 8, 11),
('01:10:00', 'intertown', 8, 6),
('01:05:00', 'intertown', 13, 12),
('01:20:00', 'intertown', 11, 8),
('01:10:00', 'intertown', 9, 12),
('01:15:00', 'intertown', 9, 6),
('01:10:00', 'intertown', 9, 7),
('01:10:00', 'intertown', 7, 10),
('01:10:00', 'intertown', 13, 6),
('01:15:00', 'intertown', 13, 7),
('01:10:00', 'intertown', 12, 9),
('01:20:00', 'intertown', 12, 10),
('01:15:00', 'intertown', 8, 4),
('01:15:00', 'intertown', 13, 10),
('01:20:00', 'intertown', 13, 3);

INSERT INTO TRIP (departure, arrival, train_id, route_id, schedule_id)
VALUES
('2024-07-25 08:00:00', '2024-07-25 09:05:00', 3, 13, 1),
('2024-07-30 13:00:00', '2024-07-30 14:05:00', 2, 14, 2),
('2024-08-04 12:30:00', '2024-08-04 13:35:00', 5, 15, 3),
('2024-08-09 10:45:00', '2024-08-09 11:50:00', 4, 16, 4),
('2024-08-14 09:05:00', '2024-08-14 10:10:00', 1, 17, 5),
('2024-07-25 14:20:00', '2024-07-25 14:30:00', 2, 18, 1),
('2024-07-30 08:10:00', '2024-07-30 08:15:00', 3, 19, 2),
('2024-08-04 07:30:00', '2024-08-04 07:35:00', 4, 20, 3),
('2024-08-09 11:00:00', '2024-08-09 11:10:00', 5, 21, 4),
('2024-08-14 16:40:00', '2024-08-14 16:55:00', 1, 22, 5),
('2024-07-25 09:15:00', '2024-07-25 10:25:00', 2, 23, 1),
('2024-07-30 12:00:00', '2024-07-30 13:10:00', 3, 24, 2),
('2024-08-04 15:30:00', '2024-08-04 16:35:00', 4, 25, 3),
('2024-08-09 10:20:00', '2024-08-09 11:30:00', 5, 26, 4),
('2024-08-14 08:50:00', '2024-08-14 10:00:00', 1, 27, 5),
('2024-07-25 14:15:00', '2024-07-25 15:30:00', 2, 28, 1),
('2024-07-30 13:30:00', '2024-07-30 14:45:00', 3, 29, 2),
('2024-08-04 10:40:00', '2024-08-04 11:50:00', 4, 30, 3),
('2024-08-09 16:00:00', '2024-08-09 17:10:00', 5, 31, 4),
('2024-08-14 09:25:00', '2024-08-14 10:30:00', 1, 32, 5),
('2024-07-25 12:40:00', '2024-07-25 14:00:00', 2, 33, 1),
('2024-07-30 10:05:00', '2024-07-30 11:15:00', 3, 34, 2),
('2024-08-04 07:50:00', '2024-08-04 09:05:00', 4, 35, 3),
('2024-08-09 14:30:00', '2024-08-09 11:40:00', 5, 36, 4);

INSERT INTO TICKET_TRIP (ticket_id,trip_id)
VALUES
(1,1),
(2,1),
(3,1),
(4,1),
(5,2),
(6,3),
(7,4),
(8,2),
(9,3),
(10,5),
(11,6),
(12,6),
(13,7),
(14,8),
(15,9),
(16,9),
(17,10),
(18,11),
(19,11);

ALTER TABLE CREW ADD CONSTRAINT FK_CREW_WORKER
    FOREIGN KEY (manager_id) REFERENCES WORKER(worker_id);

-- SELECT * FROM TRAIN;
-- SELECT * FROM CREW;
-- SELECT * FROM WORKER;
-- SELECT * FROM MAINTENANCE_LOG;
-- SELECT * FROM PASSENGER;
-- SELECT * FROM TICKET;
-- SELECT * FROM TRIP_SCHEDULE;
-- SELECT * FROM STATION;
-- SELECT * FROM ROUTES;
-- SELECT * FROM TRIP;
-- SELECT * FROM TICKET_TRIP;

-- SELECT CONSTRAINT_NAME,TABLE_NAME,COLUMN_NAME,REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME
-- FROM information_schema.KEY_COLUMN_USAGE
-- WHERE TABLE_SCHEMA = 'tt' AND REFERENCED_TABLE_NAME IS NOT NULL;