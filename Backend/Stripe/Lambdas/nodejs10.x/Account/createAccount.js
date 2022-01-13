// This function will mimic the post signup lambda. When a person confirms their account, we will then be creating them a stripe account, and storing the account id in the provided dynamodb table.

// Use promises: https://developers.google.com/web/fundamentals/primers/promises#whats-all-the-fuss-about
// Promsify all requests, becuase its much better.
let AWS = require('aws-sdk');
let util = require('util');
let documentClient = new AWS.DynamoDB.DocumentClient();

const stripe = require("stripe")(process.env.StripeSecretKey);

/*
Worker Event:

{
    "version": "1",
    "region": "us-east-1",
    "userPoolId": "us-east-1_mCM2bC2qQ",
    "userName": "ef9cd287-23c6-46d8-8680-21d72238abef",
    "callerContext": {
        "awsSdkVersion": "aws-sdk-ios-2.8.4",
        "clientId": "u6qtvhjq6o3b5gldacufb7g7a"
    },
    "triggerSource": "PostConfirmation_ConfirmSignUp",
    "request": {
        "userAttributes": {
            "sub": "ef9cd287-23c6-46d8-8680-21d72238abef",
            "cognito:email_alias": "munibrhmn@gmail.com",
            "cognito:user_status": "CONFIRMED",
            "birthdate": "2019-45-12",
            "email_verified": "false",
            "custom:signup_ip_address": "fd00:8494:8cc6:a622:2873:c453:e8e8:69e9",
            "phone_number_verified": "true",
            "custom:signup_date_time": "2019-06-12 08:45:54 -0600",
            "phone_number": "+15877031317",
            "given_name": "Munib ",
            "family_name": "Rahman",
            "custom:user_type": "worker",
            "email": "munibrhmn@gmail.com"
        }
    },
    "response": {}
}

Venue Event:

{
    "version": "1",
    "region": "us-east-1",
    "userPoolId": "us-east-1_mCM2bC2qQ",
    "userName": "fed95f68-0ef2-4804-bd76-cc3b839961b1",
    "callerContext": {
        "awsSdkVersion": "aws-sdk-ios-2.8.4",
        "clientId": "u6qtvhjq6o3b5gldacufb7g7a"
    },
    "triggerSource": "PostConfirmation_ConfirmSignUp",
    "request": {
        "userAttributes": {
            "sub": "fed95f68-0ef2-4804-bd76-cc3b839961b1",
            "cognito:email_alias": "Business@gmail.com",
            "cognito:user_status": "CONFIRMED",
            "birthdate": "2019-35-13",
            "email_verified": "false",
            "custom:signup_ip_address": "fd00:8494:8cc6:a622:c9fd:fdd1:688e:737a",
            "phone_number_verified": "true",
            "custom:signup_date_time": "2019-06-13 01:36:10 -0600",
            "given_name": "Rep_lname",
            "custom:venue_name": "Famous venue",
            "phone_number": "+15877031317",
            "family_name": "Rep_fname",
            "custom:user_type": "venue",
            "email": "Business@gmail.com"
        }
    },
    "response": {}
}
*/

exports.lambdaHandler = (event, context, callback) => {

	// TODO:
	// Get IP Address of user when they signed up. DONE.
	// Call stripe api, and create an account for them. DONE.
	// Save account id inside dynamodb table. DONE.

    console.log("Event:");
    console.log(JSON.stringify(event));

    const { userPoolId, userName, triggerSource } = event;
    const { clientId } = event.callerContext;
    const { given_name, family_name, phone_number, birthdate, email} = event.request.userAttributes;
    const ipAddress = event.request.userAttributes["custom:signup_ip_address"];
    const userType = event.request.userAttributes["custom:user_type"];
    const signupDateTime = event.request.userAttributes["custom:signup_date_time"];
    const venueName = event.request.userAttributes["custom:venue_name"];

    const signUpEpoch = new Date(signupDateTime).getTime() / 1000;                                     // Stripe API doesn't accept date time strings, must be turned into epoch seconds.
    // console.log(signUpEpoch);
    // console.log(userName);
    // console.log(triggerSource);
    // console.log(clientId);
    // console.log(given_name);
    // console.log(family_name);
    // console.log(phone_number);
    // console.log(birthdate);
    // console.log(email);
    // console.log(ipAddress);
    // console.log(userType);
    // console.log(signupDateTime);
    
    var stripeParams;

    if (userType === "worker") {
        console.log("This user is a worker");

        stripeParams = {
            type: 'custom',
            country: 'CA',
            email: email,
            business_type: 'individual',
            default_currency: 'CAD',
            individual : {
                dob: birthdate,
                email: email,
                first_name: given_name,
                last_name: family_name,
                phone: phone_number
            },
            metadata: {
                userName: userName,
                triggerSource: triggerSource,
                userPoolId: userPoolId,
                clientId: clientId,
                userType: userType,
                signUp: signupDateTime
            },
            tos_acceptance: {
                date: signUpEpoch,
                ip: ipAddress,
                user_agent: clientId
            }
        };

    } else {
        console.log("This user is a venue");
        stripeParams = {
            type: 'custom',
            country: 'CA',
            email: email,
            business_type: 'company',
            default_currency: 'CAD',
            company : {
                name: venueName,
                phone: phone_number
            },
            metadata: {
                userName: userName,
                triggerSource: triggerSource,
                userPoolId: userPoolId,
                clientId: clientId,
                userType: userType,
                repFirstName: given_name,
                repLastName: family_name,
                repBirthDate: birthdate,
                signUp: signupDateTime
            },
            tos_acceptance: {
                date: signUpEpoch,
                ip: ipAddress,
                user_agent: clientId
            }
        };

    }
    
    
    // console.log(stripeParams);

    stripe.accounts.create(stripeParams)
    .catch((err) => {
        console.log("Error creating stripe account.");
        console.log(JSON.stringify(err));
        callback(err);

        // In the event of an error, rejecting a promise is VERY important. If stripe account creation fails. We don't want null values inserted into the table.
        // https://stackoverflow.com/questions/20714460/break-promise-chain-and-call-a-function-based-on-the-step-in-the-chain-where-it
        return Promise.reject(err);                                         
    })
    .then((account) => {
        console.log("Successfuly created stripe account.");
        console.log(JSON.stringify(account));

        // Parameters required for the DynamoDB Table
        const dynamoParams = {
            TableName: process.env.DynamoDBTableName,
            Item: {
                'username': userName,
                'stripe_account_id': account.id,
                'user_type': userType
            }
        };
        return documentClient.put(dynamoParams).promise();
    })
    .then((data) => {
        console.log("Successfully inserted stripe id into dynamodb");
        console.log(JSON.stringify(data));
        callback(null, data);
    })
    .catch((err) => {
        console.log("Error putting data into dynamodb.");
        console.log(JSON.stringify(err));
        callback(err);
    });
};