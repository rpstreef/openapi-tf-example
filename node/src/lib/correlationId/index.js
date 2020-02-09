'use strict'

/**
 * Constructor
 *
 * @param {object} event
 */
function CorrelationId (event) {
  this.event = event
}

CorrelationId.prototype.HTTP_CORRELATION_ID_HEADER = 'x-correlation-id'

/**
 * CorrelationID source check for API Gateway
 */
CorrelationId.prototype.isApiGateway = function () {
  return this.event.headers && this.event.headers[this.HTTP_CORRELATION_ID_HEADER]
}

/**
 * CorrelationID source check for SNS
 */
CorrelationId.prototype.isSNS = function () {
  return this.event.Records && this.event.Records[0] && this.event.Records[0].Sns && this.event.Records[0].Sns.MessageAttributes.x_correlation_id
}

/**
 * Capture CorrelationID from various sources
 *
 * API Gateway; captured from Headers
 * SNS, SQS, DynamoDB; captured from the payload
 */
CorrelationId.prototype.getCorrelationID = function () {
  if (this.isApiGateway()) return this.event.headers[this.HTTP_CORRELATION_ID_HEADER]
  if (this.isSNS()) return this.event.Records[0].Sns.MessageAttributes.x_correlation_id.Value

  // No ID found
  return undefined
}

module.exports = CorrelationId
