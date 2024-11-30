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
  let query = "SELECT * FROM MAINTENANCE_LOG";
  const filters = [];

  for (const param in req.query) {
    console.log(param)
    if (param == 'log_date'){
      filters.push(`${param} BETWEEN ${db.escape(req.query[param] + ' 00:00:00')} AND ${db.escape(req.query[param] + ' 23:59:59')} `)
    }else
      filters.push(`${param} = ${db.escape(req.query[param])}`);
  }
  console.log(filters)
  if (filters.length > 0) {
    query += " WHERE " + filters.join(" AND ");
  }
  db.query(query, (error, results, fields) => {
    res.send(results)
    console.log(error)
    console.log(results)
    console.log(fields)
  })
})
