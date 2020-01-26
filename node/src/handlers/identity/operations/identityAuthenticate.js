'use strict'

const { SuccessResponse, ErrorResponse } = require('../../../lib/response')
const cognito = require('../../../lib/cognito')

const JsonSchema = require('../../../lib/jsonSchema')
const schema = require('../../../schema/example.json')
const input = new JsonSchema(schema['/identity/authenticate'].post.body)

async function handler (params, operation) {
  const results = input.validateInput(params)

  if (results.valid) {
    if (params.username === undefined) params.username = null
    if (params.password === undefined) params.password = null
    if (params.refreshToken === undefined) params.refreshToken = null

    const resp = await cognito.authenticate(params.username, params.password, params.refreshToken)

    if (resp.accessToken) {
      return new SuccessResponse({
        idToken: resp.idToken,
        accessToken: resp.accessToken
      })
    }

    return new ErrorResponse({
      message: 'Authentication failed'
    })
  }

  return new ErrorResponse({
    message: results.errors
  })
}

module.exports = { handler }
