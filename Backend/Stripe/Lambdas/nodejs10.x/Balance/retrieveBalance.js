let AWS = require('aws-sdk');
let documentClient = new AWS.DynamoDB.DocumentClient();

const stripe = require("stripe")(process.env.StripeSecretKey);

// Description: This function's job is to return a user's stripe account balance. 

exports.lambdaHandler = (event, context, callback) => {
    console.log("Event");
    console.log(JSON.stringify(event, null, 0));


    const { username } = event.arguments.identity;

    // Dynamodb parameters for retrieving the user's stripe account id
    var params = {
        TableName : process.env.DynamoDBTableName,
        Key: {
            username: username
        }
    };

    documentClient.get(params).promise()
    .catch((err) => {
        console.log("Error retriveing stripe account id from dynamodb");
        console.log(JSON.stringify(err));
        callback(err);
        return Promise.reject(err);
    })
    .then((data) => {
        console.log("Got stripe account id from dynamodb making stripe call now");
        console.log(JSON.stringify(data));

        // Tag on the ip address that made this requst, the username that this request came from, the event_id that transpired it and the appsync field that was used to make this call.

        if(!data.Item.stripe_account_id) {
            throw new Error("Stripe account doesn't exist for this user.");
        }

        const stripeParams = {
            stripe_account : data.Item.stripe_account_id
        };
        
        console.log("Stripe parameters");
        console.log(JSON.stringify(stripeParams));
        
        // Calling stripe to get this accounts balance
        return stripe.balance.retrieve(stripeParams);
    })
    .catch((err) => {
        console.log("Error adding external account");
        console.log(JSON.stringify(err));
        callback(err);
        return Promise.reject(err);
    }).then((data) => {
        console.log("Got data from stripe, pass it back to appsync");
        console.log(JSON.stringify(data));
        callback(null, data);
    });
    
};