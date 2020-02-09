'use strict'

const { SuccessResponse, ErrorResponse } = require('../../../lib/response')
const Logger = require('../../../lib/logger')
const CorrelationId = require('../../../lib/correlationId')
const sns = require('../../../lib/sns')

async function handler (event, context) {
  console.info('Event: ' + JSON.stringify(event))
  console.info('Context: ' + JSON.stringify(context))

  const logger = new Logger(event, context).create()
  const correlationId = new CorrelationId(event).getCorrelationID()

  const results = await sns.publish(
    process.env.SNS_TOPIC,
    'Message',
    logger,
    correlationId
  )

  if (results) {
    return new SuccessResponse({
      message: 'Message send, message id: ' + results
    })
  }

  return new ErrorResponse({
    message: 'Message failed to send'
  })
}

module.exports = { handler }
