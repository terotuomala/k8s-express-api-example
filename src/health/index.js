const { createTerminus } = require('@godaddy/terminus')
const logger = require('pino')()
const redis = require('../cache/redis')

const onSignal = () => {
  logger.info('Server is starting cleanup')
  return Promise.all([
    // your clean logic, like closing database connections
    logger.info('Closing connection to Redis'),
    redis.closeConnection()
  ])
}

const livenessCheck = () => {
  return Promise.resolve(
    // optionally include a resolve value to be included as
    // info in the health check response
    //logger.info('Liveness check OK')
  )
}

const readinessCheck = () => {
  return Promise.resolve(
    //logger.info('Readiness check OK')
  )
}

const beforeShutdown = () => {
  // the number of milliseconds or higher that's defined by the readiness probe "periodSeconds"
  return new Promise((resolve) => {
    setTimeout(resolve, 5000)
  })
}

const onShutdown = () => {
  logger.info('Cleanup finished, server is shutting down')
}

const options = {
  signals: ['SIGINT', 'SIGTERM'],
  healthChecks: {
    '/livez': livenessCheck,
    '/readyz': readinessCheck,
  },
  onSignal,
  sendFailuresDuringShutdown: true,
  beforeShutdown,
  onShutdown
}

module.exports = {
  createTerminus,
  options,
}
