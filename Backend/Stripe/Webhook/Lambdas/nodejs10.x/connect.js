// Connect webhooks are for activity on any connected account. 
// This includes the important account.updated event for any connected accounts.

let AWS = require('aws-sdk');
let documentClient = new AWS.DynamoDB.DocumentClient();



exports.lambdaHandler = (event, context, callback) => {
    console.log("Event");
    console.log(JSON.stringify(event, null, 0));

    callback(null, event);
    
};