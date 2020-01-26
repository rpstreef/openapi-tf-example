'use strict'

const { SuccessResponse } = require('../../../lib/response')

async function handler (params, operation) {
  return new SuccessResponse({
    message: 'User ' + params.username + ' confirmed, please login'
  })
}

module.exports = { handler }
