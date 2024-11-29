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
  db.query('SELECT * FROM MAINTENANCE_LOG', (error, results, fields) => {
    res.send(results)
    console.log(error)
    console.log(results)
    console.log(fields)
  })
})