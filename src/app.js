const express = require('express')
const http = require('http')
const helmet = require('helmet')
const cors = require('cors')

require('dotenv').config()

const middleware = require('./utils/middleware')
const api = require('./api')
const logger = require('./logger')
const healthCheck = require('./health')

const app = express()

app.use(logger)
app.use(helmet())
app.use(cors())
app.use(express.json())

app.use('/', api)

app.use(middleware.notFound)
app.use(middleware.errorHandler)

const server = http.createServer(app)

healthCheck.createTerminus(server, healthCheck.options)

module.exports = server
