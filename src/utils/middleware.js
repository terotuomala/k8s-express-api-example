const logger = require('pino')()

const notFound = (req, res, next) => {
  res.status(404)
  const error = new Error(`404 - Not Found - ${req.originalUrl}`)
  next(error)
}

/* eslint-disable no-unused-vars */
const errorHandler = (err, req, res, next) => {
  /* eslint-enable no-unused-vars */
  const statusCode = res.statusCode !== 200 ? res.statusCode : 500
  logger.warn(err)
  res.status(statusCode)
  res.json({
    message: err.message,
    stack: process.env.NODE_ENV === 'production' ? '🥞' : err.stack
  })
}

module.exports = {
  notFound,
  errorHandler
}
