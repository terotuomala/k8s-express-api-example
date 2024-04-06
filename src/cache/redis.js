const Redis = require('ioredis')
const logger = require('pino')()

const client = new Redis({
  host: process.env.REDIS_URL,
  port: process.env.REDIS_PORT,
  enableReadyCheck: true,
  enableOfflineQueue: true,
  retryStrategy(times) {
    const delay = Math.min(times * 10000, 5000)
    return delay
  }
})

client.on('connect', () => {
  logger.info(`Connecting to redis ${process.env.REDIS_URL}:${process.env.REDIS_PORT}`)
})

client.on('reconnecting', (time) => {
  logger.info(`Reconnecting to redis after ${time}ms`)
})

client.on('ready', () => {
  logger.info('Connected to redis')
})

client.on('close', () => {
  logger.info('Connection to redis closed')
})

client.on('error', (err) => {
  logger.error({
    message: 'Error with redis client',
    errorMessage: err.message
  })
})

const setKey = async (key, expiration, data) => {
  try {
    return await client.setex(key, expiration, data)

  } catch (err) {
    logger.error('Cannot save data to redis', err)
  }
}

const getKey = async (key) => {
  try {
    return await client.get(key)

  } catch (err) {
    logger.error('Cannot get data from redis', err)
  }
}

const keyExists = async (key) => {
  try {
    return await client.exists(key)

  } catch (err) {
    logger.error('Cannot check if key exists in redis', err)
  }
}

const connectionStatus = async () => {
  try {
    return await client.status

  } catch (err) {
    logger.error('Cannot check redis connection status', err)
  }
}

const closeConnection = () => {
  try {
    client.quit()

  } catch (err) {
    logger.error('Cannot close connection to redis', err)
  }
}

module.exports = {
  setKey,
  getKey,
  keyExists,
  connectionStatus,
  closeConnection
}
