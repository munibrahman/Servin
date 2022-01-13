// This function will mimic the post signup lambda. When a person confirms their account, we will then be creating them a stripe account, and storing the account id in the provided dynamodb table.

// Use promises: https://developers.google.com/web/fundamentals/primers/promises#whats-all-the-fuss-about
// Promsify all requests, becuase its much better.
let AWS = require('aws-sdk');
let util = require('util');
let documentClient = new AWS.DynamoDB.DocumentClient();

const stripe = require("stripe")(process.env.StripeSecretKey);


// Sample event:
// {
//     "field": "updateExternalDebitCard",
//     "arguments": {
//         "arguments": {
//             "input": {
//                 "id": "My first post",
//                 "address_city": "Calgary",
//                 "address_country": "Canada",
//                 "address_line1": "123 any street SW",
//                 "address_line2": "34 My street NW",
//                 "address_state": "Alberta",
//                 "address_zip": "H0H0H0",
//                 "default_for_currency": true,
//                 "exp_month": 3,
//                 "exp_year": 2019,
//                 "name": "John Doe"
//             }
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
//                 "event_id": "9fb1b9ca-aa6d-476f-8bf9-ba6177e96902",
//                 "token_use": "id",
//                 "auth_time": 1560709194,
//                 "phone_number": "+15877031317",
//                 "exp": 1560712794,
//                 "custom:user_type": "worker",
//                 "iat": 1560709194,
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
//                 "via": "2.0 1570d93226c1bbca2ebaad510cff3e0d.cloudfront.net (CloudFront)",
//                 "content-type": "application/json",
//                 "origin": "https://console.aws.amazon.com",
//                 "cloudfront-forwarded-proto": "https",
//                 "x-amzn-trace-id": "Root=1-5d068a09-74f418803034c5402d643a00",
//                 "x-amz-cf-id": "58l7I_ASXZIjZDyACaAfMAP-EwtN5Cs5rPr_8ICP_L2EUSHKTraNLQ==",
//                 "authorization": "eyJraWQiOiJkeW9Gclh5eVZhYWVNQm5YNXdENmVWdGFEQUtmakNzYjkrYTVXTnZYRVo4PSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiIyYTNmMmEyYy1iZDNhLTQ5ZTEtYmQ3Ny02MzQ1Njk3YTcyNjIiLCJiaXJ0aGRhdGUiOiIyMDE5LTQ0LTEzIiwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tXC91cy1lYXN0LTFfbUNNMmJDMnFRIiwiY3VzdG9tOnNpZ251cF9kYXRlX3RpbWUiOiIyMDE5LTA2LTEzIDE4OjQ0OjQ2IC0wNjAwIiwiY29nbml0bzp1c2VybmFtZSI6IjJhM2YyYTJjLWJkM2EtNDllMS1iZDc3LTYzNDU2OTdhNzI2MiIsImdpdmVuX25hbWUiOiJNdW5pYiIsImF1ZCI6IjQ1ZjAxMmRuaXE3YW9nZTU5MmFuNGxjcXJqIiwiZXZlbnRfaWQiOiI5ZmIxYjljYS1hYTZkLTQ3NmYtOGJmOS1iYTYxNzdlOTY5MDIiLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTU2MDcwOTE5NCwicGhvbmVfbnVtYmVyIjoiKzE1ODc3MDMxMzE3IiwiZXhwIjoxNTYwNzEyNzk0LCJjdXN0b206dXNlcl90eXBlIjoid29ya2VyIiwiaWF0IjoxNTYwNzA5MTk0LCJmYW1pbHlfbmFtZSI6IlJhaG1hbiIsImVtYWlsIjoiTXVuaWJyaG1uQGdtYWlsLmNvbSJ9.y-_dE5Gboyr4_-rfOyKr6gFMliRYOWqS903xaOcfLsbc-ksniPiXFmlaYHWLK-aN_vWCtzp0CUOBoO6ylBMehue_orJa-OS_LOu2RrKKAbAVWqD2LlTGzZM28QarWnaNWr0dq9dHT2HGehlO50C_qNQJ1rXnOfQDYjIop6SnvSBC_1liU0ZcsVb5vL2tEqaTvYrJH0Uw8oSbbCRlm93rRv8eZtiTJpW-t8PGidRkCb943tMrF2qNJqBySdC6OhbZQ6MaLpHq3xCLXUQyeIvvKXZXY-x22SHdNFF1O8rf4Cf6AqCM07he9Itzns4S0DUnpDqITWdqmTyO9od7XyUlJQ",
//                 "content-length": "1572",
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
    
    // id is the id of the external account
    // All other fields are optional
    const { id,
        address_city,
        address_country,
        address_line1,
        address_line2,
        address_state,
        address_zip,
        default_for_currency,
        exp_month,
        exp_year,
        name  } = event.arguments.arguments.input;

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

        const stripeParams = {
            address_city : address_city,
            address_country : address_country,
            address_line1 : address_line1,
            address_line2 : address_line2,
            address_state : address_state,
            address_zip : address_zip,
            default_for_currency : default_for_currency,
            exp_month : exp_month,
            exp_year : exp_year,
            name : name
        };
        
        console.log("Stripe parameters");
        console.log(JSON.stringify(stripeParams));
        
        // Calling stripe to update this account
        return stripe.accounts.updateExternalAccount(data.Item.stripe_account_id, id, stripeParams);
    })
    .catch((err) => {
        console.log("Error adding external account");
        console.log(JSON.stringify(err));
        callback(err);
        return Promise.reject(err);
    }).then((data) => {
        console.log("Got data from stripe, pass it back to appsync");
        console.log(JSON.stringify(data));
        callback(null, data);
    });
    
};