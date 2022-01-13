
let AWS = require('aws-sdk');
let documentClient = new AWS.DynamoDB.DocumentClient();

const stripe = require("stripe")(process.env.StripeSecretKey);


// Task: List payment methods

exports.lambdaHandler = (event, context, callback) => {
    console.log("Event");
    console.log(JSON.stringify(event, null, 0));

    const { username } = event.arguments.identity;
    const { type, ending_before, limit, starting_after } = event.arguments.arguments.input;

    // Dynamodb parameters for retrieving the user's payment methods
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

        var stripeParams = {
            customer : data.Item.stripe_customer_id,
            type : type,
            ending_before : ending_before,
            limit : limit,
            starting_after : starting_after
        }

        // Calling stripe to update this customer
        return stripe.paymentMethods.list(stripeParams);
    })
    .catch((err) => {
        console.log("Error getting payment methods");
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