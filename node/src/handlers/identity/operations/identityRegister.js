'use strict'

const { SuccessResponse, ErrorResponse } = require('../../../lib/response')

const JsonSchema = require('../../../lib/jsonSchema')
const schema = require('../../../schema/example.json')
const input = new JsonSchema(schema['/identity/register'].post.body)

async function handler (params, operation) {
  // register user
  const results = input.validateInput(params)

  if (results.valid) {
    return new SuccessResponse('Success, user with email address: ' + params.email + ' registered successfully')
  }

  return new ErrorResponse({
    message: results.errors
  })
}

module.exports = { handler }
