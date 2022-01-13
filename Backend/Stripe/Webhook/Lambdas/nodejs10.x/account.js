// Account webhooks are for activity on your own account (e.g., most requests made using your API keys and without authenticating as another Stripe account).


// Connect webhooks are for activity on any connected account. 
// This includes the important account.updated event for any connected accounts.

let AWS = require('aws-sdk');
// let documentClient = new AWS.DynamoDB.DocumentClient();



exports.lambdaHandler = async function(event, context) {
    console.log(JSON.stringify(event));
    event.Records.forEach(record => {
      const { body } = record;
      console.log(body);
    });
    return {};
  }