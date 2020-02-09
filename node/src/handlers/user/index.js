
const middy = require('middy')
const { httpErrorHandler, httpSecurityHeaders } = require('middy/middlewares')
const { ErrorResponse } = require('../../lib/response')
const standards = require('../../lib/standards')

const getUser = require('./operations/getUser')
const postUser = require('./operations/postUser')

const handler = middy(async (event, context) => {
  const operation = standards.getOperationName(event)

  switch (operation) {
    case 'getUser': {
      return getUser.handler(event, context)
    }

    case 'postUser': {
      return postUser.handler(event, context)
    }

    default: {
      console.error('Unsupported operationName: ' + operation)
      return new ErrorResponse('Unsupported operationName: ' + operation)
    }
  }
}).use(httpErrorHandler()).use(httpSecurityHeaders())

module.exports = { handler }
