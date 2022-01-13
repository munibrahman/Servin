let AWS = require('aws-sdk');

const stripe = require("stripe")(process.env.StripeSecretKey);

// Description: This lambda will cancel a given paymentIntent.
// The goal is to cancel any lingering paymentIntents, in the event that the initator backs out of the payment screen, 
// or decides to exit the app or does anything that might cease the need for a payment to go through

exports.lambdaHandler = (event, context, callback) => {
    console.log("Event");
    console.log(JSON.stringify(event, null, 0));

    const { intent  } = event.arguments.arguments;

    stripe.paymentIntents.cancel(intent)
    .then((data) => {
        console.log("Successfully cancelled payment intent, returning data to client");
        console.log(JSON.stringify(data));
        callback(null, data);
    })
    .catch((err) => {
        console.log("Error creating a paymentIntent");
        console.log(JSON.stringify(err));
        callback(err);
        return Promise.reject(err);
    });
    
};