const express = require('express')
const axios = require('axios')
const logger = require('pino')()
const redis = require('../cache/redis')

const router = express.Router()

const key = 'repositories'

const cacheConnection = async () => {
  try {
    const redisStatus = await redis.connectionStatus()

    if (redisStatus === 'ready') {
      return true
    }
    return false

  } catch (exception) {
    return exception
  }
}

const checkCache = async (key) => {
  try {
    const connectionStatus = await cacheConnection()

    if (connectionStatus) {
      return await redis.keyExists(key) ? await fetchFromCache(key) : await fetchFromGithub(key)
    }
    return await fetchFromGithub(key)

  } catch (exception) {
    return exception
  }
}

const fetchFromCache = async (key) => {
  try {
    logger.info('CACHE HIT')
    const data = await redis.getKey(key)
    return JSON.parse(data)

  } catch (exception) {
    return exception
  }
}

const saveToCache = async (key, data) => {
  try {
    await redis.setKey(key, process.env.REDIS_DEFAULT_EXPIRATION, JSON.stringify(data))

  } catch (exception) {
    return exception
  }
}

const fetchFromGithub = async (key) => {
  try {
    logger.info('CACHE MISS')
    const { data } = await axios.get(`${process.env.GITHUB_API_URL}?q=stars:%3E1+sort:stars`)

    if (data.total_count > 0) {
      const connectionStatus = await cacheConnection()

      if (connectionStatus) {
        await saveToCache(key, data.items)
        return data.items
      }
      return data.items
    }

  } catch (exception) {
    return exception
  }
}

router.get('/', async (req, res, next) => {
  try {
    const data = await checkCache(key)
    res.status(200).json({ data })

  } catch (exception) {
    next(exception)
  }
})

module.exports = router
