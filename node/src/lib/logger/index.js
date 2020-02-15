'use strict'

const { createLogger, format, transports } = require('winston')
const CorrelationId = require('../correlationId')

/**
 * We want to capture the details of the invocation
 *
 * @param {object} event - Lambda event
 * @param {object} context - Lambda context
 * @param {number} sampleRate - number between 0 - 1 determines the percentage of times the log will set to debug. In Production only
 */
function Logger (event, context) {
  this.event = event
  this.context = context

  this.cId = new CorrelationId(event)
  this.logger = this.create()
}

Logger.prototype.HTTP_DEBUG_HEADER = 'x-debug-level'

/**
 * Create the Winston logger instance
 *
 * @param {string} logLevel - supply level at which we're logging to console
 */
Logger.prototype.create = function () {
  return createLogger({
    levels: this.levels,
    level: this.setLogLevel(),
    format: format.combine(
      format.timestamp({
        format: 'YYYY-MM-DD HH:mm:ss'
      }),
      format.errors({ stack: true }),
      format.splat(), // enables string interpolation(e.g. %d, %s)
      format.json() // json output
    ),
    defaultMeta: {
      service: this.getService(),
      operationName: this.getOperationName(),
      version: this.getFunctionVersion(),
      claims: this.getClaims(),
      source: this.getSourceIP(),
      x_correlation_id: this.cId.getCorrelationID()
    },
    transports: [new transports.Console()], // only output to console
    exceptionHandlers: [new transports.Console()] // automatically capture any uncaught exceptions
  })
}

/**
 * Log Info
 *
 * @param {object|string} message - can be a JSON object or string
 */
Logger.prototype.info = function (message) {
  this.logger.info(message)
}

/**
 * Log Error
 *
 * @param {object|string} message - can be a JSON object or string
 */
Logger.prototype.error = function (message) {
  this.logger.error(message)
}

/**
 * Log Debug
 *
 * @param {object|string} message - can be a JSON object or string
 */
Logger.prototype.debug = function (message) {
  this.logger.debug(message)
}

/**
 * Sets logLevel automatically or based on sample rate given
 *
 * @param {string} logLevel - explicitly set log level, overrides automatic settings
 */
Logger.prototype.setLogLevel = function () {
  const logLevel = this.getLogLevel()

  if (logLevel === undefined) {
    if (process.env.NAMESPACE === 'prod') {
      if (process.env.DEBUG_SAMPLE_RATE > Math.random()) {
        return 'debug'
      } else {
        return 'error'
      }
    } else {
      return 'debug' // for development and test environments
    }
  }
  return logLevel
}

/**
 * Get API operation name that was executed (from API Gateway)
 */
Logger.prototype.getOperationName = function () {
  if (this.event.requestContext) return this.event.requestContext.operationName
  return ''
}

/**
 * Get Service (functionName) that was executed (from API Gateway)
 */
Logger.prototype.getService = function () {
  if (this.context.functionName) return this.context.functionName
  return ''
}

/**
 * Lambda Function version number
 */
Logger.prototype.getFunctionVersion = function () {
  if (this.context.functionVersion) return this.context.functionVersion
  return ''
}

/**
 * Cognito identity (claims) details
 */
Logger.prototype.getClaims = function () {
  if (this.event.requestContext && this.event.requestContext.authorizer) return this.event.requestContext.authorizer
  return 'No Authorization Required'
}

/**
 * Source of the API call
 */
Logger.prototype.getSourceIP = function () {
  if (this.event.requestContext && this.event.requestContext.identity) return this.event.requestContext.identity.sourceIp
  return ''
}

/**
 * Debug explicitly set for API Gateway?
 */
Logger.prototype.isApiGateway = function () {
  return this.event.headers && this.event.headers[this.HTTP_DEBUG_HEADER]
}

/**
 * Debug explicitly set for SNS?
 */
Logger.prototype.isSNS = function () {
  return this.event.Records && this.event.Records[0] && this.event.Records[0].Sns && this.event.Records[0].Sns.MessageAttributes.x_debug_level
}

/**
 * Capture Debug levels from various sources
 *
 * API Gateway; captured from Headers
 * SNS, SQS, DynamoDB; captured from the payload
 */
Logger.prototype.getLogLevel = function () {
  if (this.isApiGateway()) return this.event.headers[this.HTTP_DEBUG_HEADER]
  if (this.isSNS()) return this.event.Records[0].Sns.MessageAttributes.x_debug_level.Value

  // No debug level set
  return undefined
}

module.exports = Logger
