'use strict'

const { SuccessResponse } = require('../../../lib/response')

async function handler (params, operation) {
  return new SuccessResponse({
    message: 'Password reset request send for user: ' + params.username
  })
}

module.exports = { handler }
