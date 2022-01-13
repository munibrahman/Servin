// This function will mimic the post signup lambda. When a person confirms their account, we will then be creating them a stripe account, and storing the account id in the provided dynamodb table.

// Use promises: https://developers.google.com/web/fundamentals/primers/promises#whats-all-the-fuss-about
// Promsify all requests, becuase its much better.
let AWS = require('aws-sdk');
let util = require('util');
let documentClient = new AWS.DynamoDB.DocumentClient();

const stripe = require("stripe")(process.env.StripeSecretKey);


// Context event:
// {
//     "field": "getPost",
//     "arguments": {
//         "arguments": {},
//         "identity": {
//             "sub": "2a3f2a2c-bd3a-49e1-bd77-6345697a7262",
//             "issuer": "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_mCM2bC2qQ",
//             "username": "2a3f2a2c-bd3a-49e1-bd77-6345697a7262",
//             "claims": {
//                 "sub": "2a3f2a2c-bd3a-49e1-bd77-6345697a7262",
//                 "birthdate": "2019-44-13",
//                 "iss": "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_mCM2bC2qQ",
//                 "custom:signup_date_time": "2019-06-13 18:44:46 -0600",
//                 "cognito:username": "2a3f2a2c-bd3a-49e1-bd77-6345697a7262",
//                 "given_name": "Munib",
//                 "aud": "45f012dniq7aoge592an4lcqrj",
//                 "event_id": "51a6e2f4-47af-4f5a-9221-15add21293cf",
//                 "token_use": "id",
//                 "auth_time": 1560473777,
//                 "phone_number": "+15877031317",
//                 "exp": 1560477377,
//                 "custom:user_type": "worker",
//                 "iat": 1560473777,
//                 "family_name": "Rahman",
//                 "email": "Munibrhmn@gmail.com"
//             },
//             "sourceIp": [
//                 "174.0.164.53"
//             ],
//             "defaultAuthStrategy": "ALLOW",
//             "groups": null
//         },
//         "source": null,
//         "result": null,
//         "request": {
//             "headers": {
//                 "x-forwarded-for": "174.0.164.53, 64.252.140.70",
//                 "accept-encoding": "gzip, deflate, br",
//                 "referer": "https://console.aws.amazon.com/appsync/home?region=us-east-1",
//                 "cloudfront-viewer-country": "CA",
//                 "cloudfront-is-tablet-viewer": "false",
//                 "via": "2.0 d042f60a962591f741406f28a8170c5a.cloudfront.net (CloudFront)",
//                 "content-type": "application/json",
//                 "origin": "https://console.aws.amazon.com",
//                 "cloudfront-forwarded-proto": "https",
//                 "x-amzn-trace-id": "Root=1-5d02f2b8-87eca22ab421d28ca250c4f4",
//                 "x-amz-cf-id": "ZppoUZk6mmqUIbfHBp44DCV8jyRFspBzxTY-qzn3Qv5unRk6V-pcjw==",
//                 "authorization": "eyJraWQiOiJkeW9Gclh5eVZhYWVNQm5YNXdENmVWdGFEQUtmakNzYjkrYTVXTnZYRVo4PSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiIyYTNmMmEyYy1iZDNhLTQ5ZTEtYmQ3Ny02MzQ1Njk3YTcyNjIiLCJiaXJ0aGRhdGUiOiIyMDE5LTQ0LTEzIiwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tXC91cy1lYXN0LTFfbUNNMmJDMnFRIiwiY3VzdG9tOnNpZ251cF9kYXRlX3RpbWUiOiIyMDE5LTA2LTEzIDE4OjQ0OjQ2IC0wNjAwIiwiY29nbml0bzp1c2VybmFtZSI6IjJhM2YyYTJjLWJkM2EtNDllMS1iZDc3LTYzNDU2OTdhNzI2MiIsImdpdmVuX25hbWUiOiJNdW5pYiIsImF1ZCI6IjQ1ZjAxMmRuaXE3YW9nZTU5MmFuNGxjcXJqIiwiZXZlbnRfaWQiOiI1MWE2ZTJmNC00N2FmLTRmNWEtOTIyMS0xNWFkZDIxMjkzY2YiLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTU2MDQ3Mzc3NywicGhvbmVfbnVtYmVyIjoiKzE1ODc3MDMxMzE3IiwiZXhwIjoxNTYwNDc3Mzc3LCJjdXN0b206dXNlcl90eXBlIjoid29ya2VyIiwiaWF0IjoxNTYwNDczNzc3LCJmYW1pbHlfbmFtZSI6IlJhaG1hbiIsImVtYWlsIjoiTXVuaWJyaG1uQGdtYWlsLmNvbSJ9.OywqWkfbBZUJXVnizzhfPGhxm20sXk71vNz6F979Q5rEV8r5tFBRN7KyeceuQyq67kG6CeLE5outELy8bGa3ELNqErv5F0i76HQXDjeUkXl6YAr0DvJOxZipQ4fjEYvgs3rfg9Lcz2ppTMSRqUxXzmX7FoSy7ZefIKcpWO4OBlNjEWfVMzoRXxppgMalLTjB_mpHAaNaB2JGXar9khguo4P11H21Cr96oXBicUSRMuMa_da1zFqbSdew6h6F1fA11U8QmQUeorgkhxA1kah2TlC9iC4ghg2kcraul1Ftt5lu4IhqzYyJFUp9Q1Sl-pYaxxLvKE9UmxtlGECCEEWVkw",
//                 "content-length": "760",
//                 "accept-language": "en-US,en;q=0.9,es;q=0.8",
//                 "x-forwarded-proto": "https",
//                 "host": "zdott3evmzfs3ohfvp3lnvckui.appsync-api.us-east-1.amazonaws.com",
//                 "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36",
//                 "cloudfront-is-desktop-viewer": "true",
//                 "accept": "*/*",
//                 "cloudfront-is-mobile-viewer": "false",
//                 "x-forwarded-port": "443",
//                 "cloudfront-is-smarttv-viewer": "false"
//             }
//         },
//         "error": null,
//         "prev": null,
//         "stash": {},
//         "outErrors": []
//     }
// }


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
        console.log("Got data from dynamodb making stripe call now");
        console.log(data);

        // If the account field is empty, and a request is made to retrive it, stripe will return the main account (our own stripe account).
        checkField(data.Item.stripe_account_id);

        // Calling stripe to get account details
        return stripe.accounts.retrieve(data.Item.stripe_account_id);
    })
    .catch((err) => {
        console.log("Error getting stripe account");
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
        throw new Error("Stripe account doesn't exist for this user.");
    }
}