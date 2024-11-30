import 'dotenv/config'

import express from 'express'
const app = express()
app.listen(8080)

import mysql from 'mysql'
export const db = mysql.createConnection({
  user: process.env.USERNAME,
  password: process.env.PASSWORD,
  database: 'tt'
})

db.connect()

// serve files in frontend folder by default
app.use(express.static('frontend'))

app.get('/api/test', (req, res) => {
  const data = {test: 'this is some data'}
	res.send(data)
})

app.get('/api/db_test', (req, res) => {
  db.query('SELECT * FROM test', (error, results, fields) => {
    res.send(results)
    console.log(error)
    console.log(results)
    console.log(fields)
  })
})

app.get('/api/logs', (req, res) => {
  let query = "SELECT maintenance_id 'Maintenance ID', log_date 'Log Date', task 'Task', cond 'Condition', train_id 'Train ID',CONCAT(last_name, ', ',initial, '.') 'Crew Name' FROM MAINTENANCE_LOG ml, CREW c WHERE ml.crew_id = c.crew_id";
  const filters = [];

  for (const param in req.query) {
    if (param == 'log_date'){
      filters.push(`${param} BETWEEN ${db.escape(req.query[param] + ' 00:00:00')} AND ${db.escape(req.query[param] + ' 23:59:59')} `)
    }else if (param == 'crew_name'){
      filters.push(`CONCAT(last_name, ', ',initial, '.') LIKE ${db.escape('%'+req.query[param]+'%%')}`)
    }else
      filters.push(`${param} = ${db.escape(req.query[param])}`);
  }
  console.log(filters)
  if (filters.length > 0) {
    query += " AND " + filters.join(" AND ");
  }
  
  console.log(query)
  db.query(query, (error, results, fields) => {
    res.send(results)
    console.log(error)
    console.log(results)
    console.log(fields)
  })
})
