'use strict'

const middy = require('middy')
const { httpErrorHandler, httpSecurityHeaders } = require('middy/middlewares')
const { ErrorResponse } = require('../../lib/response')
const standards = require('../../lib/standards')

const identityAuthenticate = require('./operations/identityAuthenticate')
const identityRegister = require('./operations/identityRegister')
const identityReset = require('./operations/identityReset')
const identityVerify = require('./operations/identityVerify')

const handler = middy(async (event, context) => {
  const params = standards.getParams(event)
  const operation = standards.getOperationName(event)

  switch (operation) {
    // Login OR Renew authentication token
    case 'identityAuthenticate': {
      return identityAuthenticate.handler(params, operation)
    }
    // Register a new user
    case 'identityRegister': {
      return identityRegister.handler(params, operation)
    }
    // Reset password for user
    case 'identityReset': {
      return identityReset.handler(params, operation)
    }
    // Verify a new user with a confirmation code
    case 'identityVerify': {
      return identityVerify.handler(params, operation)
    }
    // Error, operation does not exist
    default: {
      console.error('Unsupported operationName: ' + operation)
      return new ErrorResponse('Unsupported operationName: ' + operation)
    }
  }
}).use(httpErrorHandler()).use(httpSecurityHeaders())

module.exports = { handler }
