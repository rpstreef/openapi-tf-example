'use strict'

/**
 * Set success response Object
 *
 * @param {string} message
 */
function SuccessResponse (message) {
  this.output_schema = {
    isBase64Encoded: false,
    statusCode: 200,
    headers: {
      'Access-Control-Allow-Headers': 'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token',
      'Access-Control-Allow-Methods': 'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT',
      'Access-Control-Allow-Origin': '*'
    },
    body: JSON.stringify(message)
  }

  return this.output_schema
}

/**
 * Set error respoonse Object
 *
 * @param {string} message
 */
function ErrorResponse (message) {
  this.output_schema = {
    isBase64Encoded: false,
    statusCode: 400,
    headers: {
      'Access-Control-Allow-Headers': 'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token',
      'Access-Control-Allow-Methods': 'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT',
      'Access-Control-Allow-Origin': '*'
    },
    body: JSON.stringify(message)
  }

  return this.output_schema
}

module.exports = { SuccessResponse, ErrorResponse }
