// This function will mimic the post signup lambda. When a person confirms their account, we will then be creating them a stripe account, and storing the account id in the provided dynamodb table.

// Use promises: https://developers.google.com/web/fundamentals/primers/promises#whats-all-the-fuss-about
// Promsify all requests, becuase its much better.
let AWS = require('aws-sdk');
let util = require('util');
let documentClient = new AWS.DynamoDB.DocumentClient();

const stripe = require("stripe")(process.env.StripeSecretKey);


// Sample event:
// {
//     "field": "retrieveExternalAccount",
//     "arguments": {
//         "arguments": {
//             "id": "ba_1EkakhKcsHuVb8KD3LieY824"
//         },
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
//                 "event_id": "090160cd-872e-415a-a1cf-cee0cbb0b691",
//                 "token_use": "id",
//                 "auth_time": 1560558429,
//                 "phone_number": "+15877031317",
//                 "exp": 1560562029,
//                 "custom:user_type": "worker",
//                 "iat": 1560558429,
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
//                 "x-forwarded-for": "174.0.164.53, 64.252.140.73",
//                 "accept-encoding": "gzip, deflate, br",
//                 "referer": "https://console.aws.amazon.com/appsync/home?region=us-east-1",
//                 "cloudfront-viewer-country": "CA",
//                 "cloudfront-is-tablet-viewer": "false",
//                 "via": "2.0 c9b161639a9353c2354b895548ea9fca.cloudfront.net (CloudFront)",
//                 "content-type": "application/json",
//                 "origin": "https://console.aws.amazon.com",
//                 "cloudfront-forwarded-proto": "https",
//                 "x-amzn-trace-id": "Root=1-5d043d34-9fcf3890a36fa408f90df1be",
//                 "x-amz-cf-id": "yV7xkLbqr-G7LmJcpbqxAF2tUCHx3UOGmTcP4E_54jl1EmX2NCic0w==",
//                 "authorization": "eyJraWQiOiJkeW9Gclh5eVZhYWVNQm5YNXdENmVWdGFEQUtmakNzYjkrYTVXTnZYRVo4PSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiIyYTNmMmEyYy1iZDNhLTQ5ZTEtYmQ3Ny02MzQ1Njk3YTcyNjIiLCJiaXJ0aGRhdGUiOiIyMDE5LTQ0LTEzIiwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tXC91cy1lYXN0LTFfbUNNMmJDMnFRIiwiY3VzdG9tOnNpZ251cF9kYXRlX3RpbWUiOiIyMDE5LTA2LTEzIDE4OjQ0OjQ2IC0wNjAwIiwiY29nbml0bzp1c2VybmFtZSI6IjJhM2YyYTJjLWJkM2EtNDllMS1iZDc3LTYzNDU2OTdhNzI2MiIsImdpdmVuX25hbWUiOiJNdW5pYiIsImF1ZCI6IjQ1ZjAxMmRuaXE3YW9nZTU5MmFuNGxjcXJqIiwiZXZlbnRfaWQiOiIwOTAxNjBjZC04NzJlLTQxNWEtYTFjZi1jZWUwY2JiMGI2OTEiLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTU2MDU1ODQyOSwicGhvbmVfbnVtYmVyIjoiKzE1ODc3MDMxMzE3IiwiZXhwIjoxNTYwNTYyMDI5LCJjdXN0b206dXNlcl90eXBlIjoid29ya2VyIiwiaWF0IjoxNTYwNTU4NDI5LCJmYW1pbHlfbmFtZSI6IlJhaG1hbiIsImVtYWlsIjoiTXVuaWJyaG1uQGdtYWlsLmNvbSJ9.g0pr947zWzwuOwiBwTb8iqCEYLkkg2e5TnnEEJK7dNHOIVZ-O0i4MCfVjV_Bdr0QkTy1aAS1GXFsMy7W6hQ2QrvgJ6X8DUnH4B8tKGFSWwQqN6aRzNOMje8_Sa-Q1prkzpP4gp6mDdo2LcJHCR3iLvd99DIUGOQja_2GHARpwg_QQ3sJPbRV_MONIzjfYIyTJVjWvW5ig7hw9suOyWxJDlMo0Eerb1Y3PwNd8DBZ2QYoRqFk4O78QvwL2nePpMC0y5h_F1JiFysvbAGQuxbVuaeEQzShQojtkFiNjFiyVwvjZdmETyZlLqLdORXbsgPFpzWb-u6RvygekqKIv2uldQ",
//                 "content-length": "828",
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
    const id = event.arguments.arguments.id;

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
        
        console.log("External account id");
        console.log(id);

        // Calling stripe to get bank account info
        return stripe.accounts.retrieveExternalAccount(data.Item.stripe_account_id, id);
    })
    .catch((err) => {
        console.log("Error getting external account");
        console.log(JSON.stringify(err));
        callback(err);
        return Promise.reject(err);
    }).then((data) => {
        console.log("Got data from stripe, pass it back to appsync");
        console.log(JSON.stringify(data));
        callback(null, data);
    });
    
};