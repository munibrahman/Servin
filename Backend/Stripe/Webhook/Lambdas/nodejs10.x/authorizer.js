let AWS = require('aws-sdk');
let sqs = new AWS.SQS();

const stripe = require("stripe")(process.env.StripeSecretKey);
const endpointSecret = process.env.StripeEndpointSecret;

// Description: This lambda function's task is to authenticate that all calls being made are in fact from stripe and not from anyone else.
//              To view more information about webhook signature checking, visit: https://stripe.com/docs/webhooks/signatures

exports.lambdaHandler =  function(event, context, callback) {
    
    console.log("Event");
    console.log(JSON.stringify(event));

    const sig = event.headers['Stripe-Signature'];
    

    let stripeEvent;

    try {
        
        stripeEvent = stripe.webhooks.constructEvent(event.body, sig, endpointSecret);

        console.log(JSON.stringify(stripeEvent));

        callback(null, 
            {
                'body': 'Success, your event has been recieved!',
                'headers': {
                    'Content-Type': 'text/plain'
                },
                    'statusCode': 200
            });

        var params = {
            MessageBody: JSON.stringify(stripeEvent), /* required */
            QueueUrl: process.env.EventQueueURL /* required */
        };

        sqs.sendMessage(params, function(err, data) {
            if (err) console.log(err, err.stack); // an error occurred
            else     console.log(data);           // successful response
        });

    }
    catch (err) {
        
        console.log(JSON.stringify(err));
        callback("Unauthorized");   // Return a 401 Unauthorized response
    }

};
