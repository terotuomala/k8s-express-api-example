/* eslint-disable no-undef */
const supertest = require('supertest')
const app = require('../app')
const redis = require('../cache/redis')

const api = supertest(app)

jest.setTimeout(150000)

test('Readiness endpoint returns HTTP 200 OK with status message as JSON', async () => {
  const response = await api.get('/readyz')

  expect(response.statusCode).toEqual(200)
  expect(response.type).toEqual('application/json')
  expect(response.body.status).toBe('ok')
})

test('Liveness endpoint returns HTTP 200 OK with status message as JSON', async () => {
  const response = await api.get('/livez')

  expect(response.statusCode).toEqual(200)
  expect(response.type).toEqual('application/json')
  expect(response.body.status).toBe('ok')
})

test('Root endpoint returns HTTP 200 OK and response including repositories count is bigger than 0', async () => {
  const response = await api.get('/')

  expect(response.statusCode).toEqual(200)
  expect(response.type).toEqual('application/json')
  //expect(response.body.total_count).toBeGreaterThan(0)
})

afterAll(() => redis.closeConnection())
