const AWS = require('aws-sdk')
const AWSXRay = require('aws-xray-sdk')

const sns = AWSXRay.captureAWSClient(new AWS.SNS({ apiVersion: '2010-03-31' }))

/*
SNS sample event
{
  "Records": [
    {
      "EventVersion": "1.0",
      "EventSubscriptionArn": "arn:aws:sns:us-east-2:123456789012:sns-lambda:21be56ed-a058-49f5-8c98-aedd2564c486",
      "EventSource": "aws:sns",
      "Sns": {
        "SignatureVersion": "1",
        "Timestamp": "2019-01-02T12:45:07.000Z",
        "Signature": "tcc6faL2yUC6dgZdmrwh1Y4cGa/ebXEkAi6RibDsvpi+tE/1+82j...65r==",
        "SigningCertUrl": "https://sns.us-east-2.amazonaws.com/SimpleNotificationService-ac565b8b1a6c5d002d285f9598aa1d9b.pem",
        "MessageId": "95df01b4-ee98-5cb9-9903-4c221d41eb5e",
        "Message": "Hello from SNS!",
        "MessageAttributes": {
          "Test": {
            "Type": "String",
            "Value": "TestString"
          },
          "TestBinary": {
            "Type": "Binary",
            "Value": "TestBinary"
          }
        },
        "Type": "Notification",
        "UnsubscribeUrl": "https://sns.us-east-2.amazonaws.com/?Action=Unsubscribe&amp;SubscriptionArn=arn:aws:sns:us-east-2:123456789012:test-lambda:21be56ed-a058-49f5-8c98-aedd2564c486",
        "TopicArn":"arn:aws:sns:us-east-2:123456789012:sns-lambda",
        "Subject": "TestInvoke"
      }
    }
  ]
}
*/

/**
 * Publish message with correlation id to SNS
 *
 * @param {string} topicARN
 * @param {string} message
 * @param {string} correlation_id
 */
async function publish (topicARN, message, logger, correlationId) {
  var params = {
    Message: message,
    MessageAttributes: {
      x_correlation_id: {
        DataType: 'String',
        StringValue: correlationId
      }
    },
    TopicArn: topicARN
  }
  const results = await sns.publish(params).promise()

  if (results.err) {
    logger.error('SNS publish error caught: ' + results.err)
    throw Error('SNS publish error caught: ' + JSON.stringify(results.err))
  }

  logger.info('SNS message published, message id: ' + results.MessageId)

  return results.MessageId
}

module.exports = { publish }
