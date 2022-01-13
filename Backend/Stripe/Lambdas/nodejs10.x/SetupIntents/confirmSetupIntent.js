let AWS = require('aws-sdk');
let documentClient = new AWS.DynamoDB.DocumentClient();

const stripe = require("stripe")(process.env.StripeSecretKey);

// Description: This function confirms a setupIntent. By updating the payment method, or the return url/app uri 

exports.lambdaHandler = (event, context, callback) => {
    console.log("Event");
    console.log(JSON.stringify(event, null, 0));

    // Arguments passed in to this function
    const { intent, payment_method, return_url  } = event.arguments.arguments.input;
    
    const stripeParams = {
        payment_method : payment_method,
        return_url : return_url
    };
    
    console.log("Stripe parameters");
    console.log(JSON.stringify(stripeParams));
    
    // Calling stripe to confirm setupIntent
    stripe.setupIntents.confirm(intent, stripeParams).promise()
    .catch((err) => {
        console.log("Error confirming setupIntent");
        console.log(JSON.stringify(err));
        callback(err);
        return Promise.reject(err);
    }).then((data) => {
        console.log("Confirmed setupIntent send it back to the user");
        console.log(JSON.stringify(data));
        callback(null, data);
    });
    
};