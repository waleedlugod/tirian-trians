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
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

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
  let crewNameConcat = "CONCAT(last_name, ', ',initial, '.')"

  let sQuery1 = "SELECT maintenance_id 'Maintenance ID', log_date 'Log Date', task 'Task', "
  let sQuery2 = `cond 'Condition', train_id 'Train ID',${crewNameConcat} 'Crew Name' `
  let jQurery = "FROM MAINTENANCE_LOG ml JOIN CREW c ON ml.crew_id = c.crew_id "

  let query = sQuery1 + sQuery2 + jQurery
  const filters = [];

  for (const param in req.query) {
    if (param == 'date'){
      filters.push(`log_date BETWEEN ${db.escape(req.query[param] + ' 00:00:00')}` + 
        ` AND ${db.escape(req.query[param] + ' 23:59:59')} `)
    }else if (param == 'crew-name'){
      filters.push(`${crewNameConcat} LIKE ${db.escape('%'+req.query[param]+'%')}`)
    }else
      filters.push(`${param} = ${db.escape(req.query[param])}`);
  }
  console.log(filters)
  if (filters.length > 0) {
    query += " WHERE " + filters.join(" AND ");
  }
  
  console.log(query)
  db.query(query, (error, results, fields) => {
    res.send(results)
    console.log(error)
    console.log(results)
    console.log(fields)
  })
	console.log(req.method)
})


app.post('/api/logs', (req, res) => {
	console.log(req.body)
	res.send(200)
})
