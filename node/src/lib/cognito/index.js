'use strict'

const AWS = require('aws-sdk')
const https = require('https')
const agent = new https.Agent({
  maxSockets: 50,
  keepAlive: true,
  rejectUnauthorized: true
})
agent.setMaxListeners(0)

AWS.config.update({
  httpOptions: {
    agent: agent
  }
})

const cognito = new AWS.CognitoIdentityServiceProvider({ apiVersion: '2016-04-18' })

/**
 * Getting new access and id tokens
 *
 * https://docs.aws.amazon.com/cognito/latest/developerguide/amazon-cognito-user-pools-using-tokens-with-identity-providers.html
 *
 * @param {string} username
 * @param {string} password
 *
 * @return {AuthenticationResult}
 */
async function authenticate (username, password, refreshToken) {
  let params = {}

  if (refreshToken === null) {
    params = {
      UserPoolId: process.env.COGNITO_USER_POOL_ID,
      AuthFlow: 'ADMIN_NO_SRP_AUTH',
      ClientId: process.env.COGNITO_USER_POOL_CLIENT_ID,
      AuthParameters: {
        USERNAME: username,
        PASSWORD: password
      }
    }
  } else {
    params = {
      UserPoolId: process.env.COGNITO_USER_POOL_ID,
      AuthFlow: 'REFRESH_TOKEN_AUTH',
      ClientId: process.env.COGNITO_USER_POOL_CLIENT_ID,
      AuthParameters: {
        REFRESH_TOKEN: refreshToken
      }
    }
  }
  return cognito.adminInitiateAuth(params).promise()
}

module.exports = {
  authenticate
}
