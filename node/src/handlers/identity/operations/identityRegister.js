'use strict'

const { SuccessResponse } = require('../../../lib/response')

async function handler (params, operation) {
  // register user
  return new SuccessResponse('Success')
}

module.exports = { handler }
