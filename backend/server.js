import "dotenv/config";

import express from "express";
const app = express();
app.listen(8080);

import mysql from "mysql";
export const db = mysql.createConnection({
  user: process.env.USERNAME,
  password: process.env.PASSWORD,
  database: "tt",
});

db.connect();
let crewNameConcat = "CONCAT(last_name, ', ',initial, '.')";
let passengerNameMacro = `CONCAT(given_name, ' ', middle_initial, '. ', last_name)`;

// serve files in frontend folder by default
app.use(express.static("frontend"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get("/api/test", (req, res) => {
  const data = { test: "this is some data" };
  res.send(data);
});

app.get("/api/db_test", (req, res) => {
  db.query("SELECT * FROM test", (error, results, fields) => {
    res.send(results);
    console.log(error);
    console.log(results);
    console.log(fields);
  });
});

app.get("/api/logs", (req, res) => {

  let sQuery1 =
    "SELECT maintenance_id 'Maintenance ID', log_date 'Log Date', task 'Task', ";
  let sQuery2 = `cond 'Condition', train_id 'Train ID',${crewNameConcat} 'Crew Name' `;
  let jQurery =
    "FROM MAINTENANCE_LOG ml JOIN CREW c ON ml.crew_id = c.crew_id ";
  let oQuery = `ORDER BY maintenance_id ASC `
  let query = sQuery1 + sQuery2 + jQurery + oQuery;
  const filters = [];

  for (const param in req.query) {
    if (param == "date") {
      filters.push(
        `log_date BETWEEN ${db.escape(req.query[param] + " 00:00:00")}` +
          ` AND ${db.escape(req.query[param] + " 23:59:59")} `,
      );
    } else if (param == "crew-name") {
      filters.push(
        `${crewNameConcat} LIKE ${db.escape("%" + req.query[param] + "%")}`,
      );
    } else filters.push(`${param} = ${db.escape(req.query[param])}`);
  }

  console.log(filters);
  if (filters.length > 0) {
    query += " WHERE " + filters.join(" AND ");
  }
  
  console.log(query);
  db.query(query, (error, results, fields) => {
    res.send(results);
    console.log(error);
    console.log(results);
    console.log(fields);
  });
});

app.post("/api/logs", (req, res) => {
  console.log(req.body)
  let crewSelectRes = {}
  db.query(`SELECT crew_id FROM CREW WHERE ${crewNameConcat} = ${db.escape(req.body.crew_name)}`, (error, results) => {
    console.log(error)
    crewSelectRes = (Object.values(JSON.parse(JSON.stringify(results))))
    const crew_id = crewSelectRes[0]['crew_id']
    db.query(`INSERT INTO MAINTENANCE_LOG (log_date, task, cond, train_id, crew_id) VALUES
      ('${req.body.date} 00:00:00', "${req.body.task}", "${req.body.cond}", ${req.body.train_id}, ${crew_id})`, (error, result) => {
        res.send(result)
        console.log(error)
        console.log(result)
    })
  })
});

app.get("/api/stations", (req, res) => {
  let query =
    "SELECT station_id 'Station ID', station_name 'Station Name' FROM STATION";

  console.log(query);
  db.query(query, (error, results, fields) => {
    res.send(results);
    console.log(error);
    console.log(results);
    console.log(fields);
  });
});

app.post("/api/stations", (req, res) => {
  console.log(req.body);
  res.send(200);
});

app.get("/api/destinationRoutes", (req, res) => {
  console.log(req.query);
  const destination = req.query.destination;
  console.log(destination);
  let sQuery1 =
    "SELECT r.route_id 'Route ID', st.station_name 'Origin Station', s.station_name 'Destination Station', r.is_active 'Is Active' FROM ROUTE r , STATION s, STATION st WHERE r.destination_station_id = s.station_id AND st.station_id = r.origin_station_id AND r.destination_station_id = ";
  sQuery1 += destination;

  let query = sQuery1;
  const filters = [];

  console.log(query);
  db.query(query, (error, results, fields) => {
    res.send(results);
    console.log(error);
    console.log(results);
    console.log(fields);
  });
});

app.get("/api/outgoingRoutes", (req, res) => {
  const origin = req.query.origin;
  let sQuery1 =
    "SELECT r.route_id 'Route ID', s.station_name 'Origin Station', st.station_name 'Destination Station', r.is_active 'Is Active' FROM ROUTE r , STATION s, STATION st WHERE r.origin_station_id = s.station_id AND st.station_id = r.destination_station_id AND r.origin_station_id =  ";
  sQuery1 += origin;

  let query = sQuery1;
  const filters = [];

  db.query(query, (error, results, fields) => {
    res.send(results);
    console.log(error);
    console.log(results);
    console.log(fields);
  });
});

app.get("/api/tickets", (req, res) => {
  const name = req.query.passenger;

  let sQuery1 = `SELECT t.ticket_id, t.total_cost, t.date_purchased, p.passenger_id, `;
  let sQuery2 = `tr.departure, tr.arrival, tr.cost, ${passengerNameMacro} 'Passenger Name' `;
  let fQuery = `FROM TICKET t, TICKET_TRIP tt, TRIP tr, PASSENGER p `;
  let wQuery = `WHERE t.ticket_id = tt.ticket_id AND tr.trip_id = tt.trip_id AND p.passenger_id = t.passenger_id `;
  let nQuery = `AND ${passengerNameMacro} LIKE ${db.escape("%" + name + "%")}`;

  let query = sQuery1 + sQuery2 + fQuery + wQuery + nQuery;
  db.query(query, (error, results, fields) => {
    res.send(results);
    console.log(error);
    console.log(results);
    console.log(fields);
  });
});
