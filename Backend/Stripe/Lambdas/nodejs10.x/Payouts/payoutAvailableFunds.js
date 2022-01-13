let AWS = require('aws-sdk');
let documentClient = new AWS.DynamoDB.DocumentClient();

const stripe = require("stripe")(process.env.StripeSecretKey);

// Description: This function takes the available amount from a user's stripe account, and sends them to the user's specified external account.

exports.lambdaHandler = (event, context, callback) => {
    console.log("Event");
    console.log(JSON.stringify(event, null, 0));


    const { username } = event.arguments.identity;
    const { external_account } = event.arguments.arguments;

    var stripe_account_id;
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

        if(!data.Item.stripe_account_id) {
            throw new Error("Stripe account doesn't exist for this user.");
        }

        stripe_account_id = data.Item.stripe_account_id;

        const stripeParams = {
            stripe_account : stripe_account_id
        };
        
        console.log("Stripe parameters");
        console.log(JSON.stringify(stripeParams));
        
        // Calling stripe to get this accounts balance
        return stripe.balance.retrieve(stripeParams);
    })
    .catch((err) => {
        console.log("Error getting balance...");
        console.log(JSON.stringify(err));
        callback(err);
        return Promise.reject(err);
    }).then((data) => {
        console.log("Got user's balance, send all the available balances to this user's external account");
        console.log(JSON.stringify(data));

        const stripeParams = {
            amount : data.avaibale.amount,
            currency: data.avaibale.currency,
            destination: external_account
        };

        const accountParams = {
            stripe_account : stripe_account_id
        }

        return stripe.payouts.create(stripeParams, accountParams);
        
    }).then((data) => {
        console.log("Sent the payment to the external account.");
        console.log(JSON.stringify(data));
        callback(null, data);
    }).catch((err) => {
        console.log("Error sending payment to the external account.");
        console.log(JSON.stringify(err));
        callback(err);
    });
    
};