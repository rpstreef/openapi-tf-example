
const middy = require('middy')
const { httpErrorHandler, httpSecurityHeaders } = require('middy/middlewares')
const { SuccessResponse } = require('../../lib/response')

const Logger = require('../../lib/logger')
const CorrelationId = require('../../lib/correlationId')

const handler = middy(async (event, context) => {
  const logger = new Logger(event, context)
  const correlationId = new CorrelationId(event).getCorrelationID()

  logger.info('Sns message received')

  return new SuccessResponse({
    message: correlationId
  })
}).use(httpErrorHandler()).use(httpSecurityHeaders())

module.exports = { handler }
