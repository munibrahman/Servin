let AWS = require('aws-sdk');
let documentClient = new AWS.DynamoDB.DocumentClient();

const stripe = require("stripe")(process.env.StripeSecretKey);

// Description: This function updates a setupIntent.
//              Allows update of the payment_method, payment_method_types

exports.lambdaHandler = (event, context, callback) => {
    console.log("Event");
    console.log(JSON.stringify(event, null, 0));

    // Arguments passed in to this function
    const { intent, payment_method, payment_method_types  } = event.arguments.arguments.input;
    
    const stripeParams = {
        payment_method : payment_method,
        payment_method_types : payment_method_types
    };
    
    console.log("Stripe parameters");
    console.log(JSON.stringify(stripeParams));
    
    // Calling stripe to update setupIntent
    stripe.setupIntents.update(intent, stripeParams).promise()
    .catch((err) => {
        console.log("Error updating setupIntent");
        console.log(JSON.stringify(err));
        callback(err);
        return Promise.reject(err);
    }).then((data) => {
        console.log("Updated setupIntent send it back to the user");
        console.log(JSON.stringify(data));
        callback(null, data);
    });
    
};