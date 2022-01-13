let AWS = require('aws-sdk');
let documentClient = new AWS.DynamoDB.DocumentClient();

const stripe = require("stripe")(process.env.StripeSecretKey);

// Description: This function initiates a payment intent to be paid out to another stripe connect account.
// It will take in the amount, the currency and the other user's uuid.
// This function will first find out the stripe id of the current user, and the stripe id of the user to whom amount shall be sent.
// It will then initiate a paymentIntent request, and finally send back the response recieved from stripe.

exports.lambdaHandler = (event, context, callback) => {
    console.log("Event");
    console.log(JSON.stringify(event, null, 0));


    const { username } = event.arguments.identity;
    const { amount, customer_username  } = event.arguments.arguments.input;

    // Account that payments will be sent to
    var to_stripe_account_id;

    // Customer id of the user making this request.
    var stripe_customer_id;  
    
    // Step 1: Getting my stripe information
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
        console.log("Got my stripe info from dynamodb");
        console.log(JSON.stringify(data));

        stripe_customer_id = data.Item.stripe_customer_id;

        if(!data.Item.stripe_customer_id) {
            throw new Error("Stripe customer object doesn't exist for this user.");
        }


        // Step 2: Getting the other user's stripe info.
        var params = {
            TableName : process.env.DynamoDBTableName,
            Key: {
                username: customer_username
            }
        };

        console.log("DynamoDB Params");
        console.log(JSON.stringify(params));

        return documentClient.get(params).promise();

        
    }).then((data) => {

        console.log("Got other user's stripe info from dynamodb");
        console.log(JSON.stringify(data));

        if(!data.Item.stripe_account_id) {
            throw new Error("Stripe account object doesn't exist for this user.");
        }

        to_stripe_account_id = data.Item.stripe_account_id;

        // Step 3: Make request to stripe.
        
        const stripeParams = {
            amount : amount,
            currency : "CAD",
            // application_fee_amount : 0,              // DONT Send in a 0 amount, as it will declare it as an invalid integer
            capture_method : "automatic",
            confirmation_method : "automatic",
            customer: stripe_customer_id,
            description : "Payment for shift taken on XXX",     // TODO: Insert the actual statement description
            on_behalf_of : to_stripe_account_id,
            transfer_data : {
                destination : to_stripe_account_id
            }
        };
        
        console.log("Stripe parameters");
        console.log(JSON.stringify(stripeParams));
        
        // Calling stripe to create payment Intent
        return stripe.paymentIntents.create(stripeParams);
    })
    .catch((err) => {
        console.log("Error creating a paymentIntent");
        console.log(JSON.stringify(err));
        callback(err);
        return Promise.reject(err);
    }).then((data) => {
        console.log("Created paymentIntent, send it back to the user.");
        console.log(JSON.stringify(data));
        callback(null, data);
    });
    
};