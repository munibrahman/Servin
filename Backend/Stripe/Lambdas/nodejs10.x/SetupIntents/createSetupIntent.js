let AWS = require('aws-sdk');
let documentClient = new AWS.DynamoDB.DocumentClient();

const stripe = require("stripe")(process.env.StripeSecretKey);

// Description: This function starts a payment intent on behalf of a connected stripe account. 
//               After a successful creation, this function will expose a client secret token, which can then be used
//              by the user to finalize a payment method.

exports.lambdaHandler = (event, context, callback) => {
    console.log("Event");
    console.log(JSON.stringify(event, null, 0));


    const { username } = event.arguments.identity;
    
    // Getting user's stripe account id
    var params = {
        TableName : process.env.DynamoDBTableName,
        Key: {
            username: username
        }
    };

    console.log("DynamoDB Params");
    console.log(JSON.stringify(params));

    documentClient.get(params).promise()
    .then((data) => {
        console.log("Got stripe account id from dynamodb making stripe call now");
        console.log(JSON.stringify(data));

        if(!data.Item.stripe_account_id) {
            throw new Error("Stripe account doesn't exist for this user.");
        }

        var stripe_account_id = data.Item.stripe_account_id;

        const stripeParams = {
            metadata: {
                username : username
            },
            on_behalf_of : stripe_account_id,
            usage : "on_session"           // If all payments are to be made while the user is in the app.
        };
        
        console.log("Stripe parameters");
        console.log(JSON.stringify(stripeParams));
        
        // Calling stripe to create setup Intent
        return stripe.setupIntents.create(stripeParams);
    })
    .catch((err) => {
        console.log("Error creating a setupIntent");
        console.log(JSON.stringify(err));
        callback(err);
        return Promise.reject(err);
    }).then((data) => {
        console.log("Created setupIntent, send it back to the user");
        console.log(JSON.stringify(data));
        callback(null, data);
    });
    
};