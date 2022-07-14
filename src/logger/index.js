const pino = require('pino')
const logger = require('pino-http')({
  logger: pino(),
  useLevel: process.env.LOG_LEVEL || 'info'
})

module.exports = logger
