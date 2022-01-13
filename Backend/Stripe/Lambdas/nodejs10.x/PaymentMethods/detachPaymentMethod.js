
let AWS = require('aws-sdk');
let documentClient = new AWS.DynamoDB.DocumentClient();

const stripe = require("stripe")(process.env.StripeSecretKey);


// Task: detach payment method from customer

exports.lambdaHandler = (event, context, callback) => {
    console.log("Event");
    console.log(JSON.stringify(event, null, 0));

    const { username } = event.arguments.identity;
    const { token } = event.arguments.arguments;

    // Dynamodb parameters for retrieving the user's stripe customer id
    var params = {
        TableName : process.env.DynamoDBTableName,
        Key: {
            username: username
        }
    };

    documentClient.get(params).promise()
    .catch((err) => {
        console.log("Error retriveing stripe customer id from dynamodb");
        console.log(JSON.stringify(err));
        callback(err);
        return Promise.reject(err);
    })
    .then((data) => {
        console.log("Got data from dynamodb making stripe call now");
        console.log(data);

        checkField(data.Item.stripe_customer_id);

        // Calling stripe to detach payment method
        return stripe.paymentMethods.detach(token);
    })
    .catch((err) => {
        console.log("Error attaching payment method");
        console.log(JSON.stringify(err));
        callback(err);
        return Promise.reject(err);
    }).then((data) => {
        console.log("Got data from stripe, pass it back to appsync");
        console.log(JSON.stringify(data));
        callback(null, data);
    });
    
};

function checkField(field) {
    if(!field) {
        throw new Error("Stripe customer object doesn't exist for this user.");
    }
}