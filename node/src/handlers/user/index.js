
const middy = require('middy')
const { httpErrorHandler, httpSecurityHeaders } = require('middy/middlewares')
const { ErrorResponse } = require('../../lib/response')
const standards = require('../../lib/standards')

const getUser = require('./operations/getUser')

const handler = middy(async (event, context) => {
  const params = standards.getParams(event)
  const operation = standards.getOperationName(event)

  switch (operation) {
    case 'getUser': {
      return getUser.handler(params, operation)
    }

    default: {
      console.error('Unsupported operationName: ' + operation)
      return new ErrorResponse('Unsupported operationName: ' + operation)
    }
  }
}).use(httpErrorHandler()).use(httpSecurityHeaders())

module.exports = { handler }
