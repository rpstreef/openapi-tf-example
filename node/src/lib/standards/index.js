'use strict'

/**
 * Operation name of the event, used for switch statements
 *
 * @param {object} event
 */
function getOperationName (event) {
  return event.requestContext.operationName
}

/**
 * Return either the Query parameters or the body parameters
 *
 * If both are empty, returns null
 *
 * @param {object | null} event
 */
function getParams (event) {
  const queryParams = _getQueryParams(event)
  const bodyParams = _getBodyParams(event)

  if (queryParams === null && bodyParams === null) {
    return null
  } else if (queryParams === null) {
    return bodyParams
  }
  return queryParams
}

function _getQueryParams (event) {
  if (event.queryStringParameters !== null) {
    if (typeof event.queryStringParameters === 'object') {
      return event.queryStringParameters
    }
    return JSON.parse(event.queryStringParameters)
  }
  return null
}

function _getBodyParams (event) {
  if (event.body !== null) {
    if (typeof event.body === 'object') {
      return event.body
    }
    return JSON.parse(event.body)
  }
  return null
}

module.exports = {
  getParams,
  getOperationName
}
