/* 	Copyright (C) Voltic Labs, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

/*
	Sample Event:

{
    "version": "1",
    "region": "us-east-1",
    "userPoolId": "us-east-1_p1AkLbzJT",
    "userName": "1961fa7e-62cb-4b37-b16b-6930ffb5fd64",
    "callerContext": {
        "awsSdkVersion": "aws-sdk-ios-2.9.8",
        "clientId": "27q6fatoub1a848krdiig84v9e"
    },
    "triggerSource": "PostConfirmation_ConfirmSignUp",
    "request": {
        "userAttributes": {
            "sub": "1961fa7e-62cb-4b37-b16b-6930ffb5fd64",
            "cognito:email_alias": "munibrhmn+7898383@gmail.com",
            "cognito:user_status": "CONFIRMED",
            "email_verified": "true",
            "given_name": "Testing123",
            "family_name": "Servin",
            "email": "munibrhmn+7898383@gmail.com",
			"custom:signup_ip_address" : "192.168.0.1"
        }
    },
    "response": {}
}

 */
var AWS = require('aws-sdk');
var documentClient = new AWS.DynamoDB.DocumentClient();
const stripe = require("stripe")(process.env.StripeSecretKey);

// Description:
//             	This lambda is invoked as when a user confirms their account.
//             	Our job is to take information passed inside the token claims and create stripe accounts
//             	This pertains to creating a connect account and a customer account for the user.
//				We will then save both of those ids in the dynamodb table, along with other information provided upon signup.

// 	Step 1: 	Call stripe api and create a customer and account object.
//	Step 2: 	Batch write the data to each seperate table. Readable user information goes into the user's table while stripe information will be stored in stripe users table.


exports.handler = function(event, context, callback) {

	console.log(JSON.stringify(event, null));

	const { userPoolId, userName, triggerSource } = event;
    const { clientId } = event.callerContext;
	const { given_name, family_name, email} = event.request.userAttributes;
	// TODO: Change userpool so that ip address and signup date are also submitted upon signup.
	const ipAddress = event.request.userAttributes["custom:signup_ip_address"];

    var about = " ";
	const signUpEpoch = Math.floor(new Date().getTime() / 1000);
    var rating = 0;
    var profilePic = "NIL";
    var account_id = "NIL";
	var customer_id = "NIL";
	

	var stripeAccountParams = {
		type: 'custom',
		country: 'CA',
		email: email,
		business_type: 'individual',
		default_currency: 'CAD',
		individual : {
			email: email,
			first_name: given_name,
			last_name: family_name
		},
		metadata: {
			userName: userName,
			triggerSource: triggerSource,
			userPoolId: userPoolId,
			clientId: clientId,
			signUp: signUpEpoch
		},
		tos_acceptance: {
			date: signUpEpoch,
			ip: ipAddress,
			user_agent: clientId
		}
	};

	stripe.accounts.create(stripeAccountParams)
	.catch((err) => {
		console.log("Error creating stripe account.");
		console.log(JSON.stringify(err));
		callback(err);

		// In the event of an error, rejecting a promise is VERY important. If stripe account creation fails. We don't want null values inserted into the table.
		// https://stackoverflow.com/questions/20714460/break-promise-chain-and-call-a-function-based-on-the-step-in-the-chain-where-it
		return Promise.reject(err);                                         
	}).then((account)=> {
		console.log("Successfuly created stripe account.");
		console.log(JSON.stringify(account));

		account_id = account.id;

		var stripeParams = {
            description : `Customer ${given_name} ${family_name}`,
            email : email,
            name : `${given_name} ${family_name}`,
            metadata: {
                userName: userName,
                triggerSource: triggerSource,
                userPoolId: userPoolId,
                clientId: clientId,
                signUp: signUpEpoch,
                ip: ipAddress,
                user_agent: clientId
            }
		};
		

		return stripe.customers.create(stripeParams)
	}).catch((err) => {
		console.log("Error creating stripe customer");
		console.log(JSON.stringify(err));
		callback(err);

		// In the event of an error, rejecting a promise is VERY important. If stripe account creation fails. We don't want null values inserted into the table.
		// https://stackoverflow.com/questions/20714460/break-promise-chain-and-call-a-function-based-on-the-step-in-the-chain-where-it
		return Promise.reject(err);                                         
	})
	.then((customer) => {
		console.log("Successfuly created stripe customer");
		console.log(JSON.stringify(customer));

		customer_id = customer.id;

		var params = {
			RequestItems: {
				[process.env.UserDynamoDBTableName]: [    //"ServinUsers"
					{
						PutRequest: {
							Item: {
								'username': userName,
								'about': about,
								'family_name': family_name,
								'given_name': given_name,
								'profilePic' : profilePic,
								'rating': rating,
								'reviewsLeft': {},
								'signUpDate' : signUpEpoch,
								'streams': {},
								'categories': [],
								'hasChosenCategories': false,
								'school': " "																// TODO: Insert school in here
							}
						}
					}
				],
				[process.env.DynamoDBStripeTableName]: [	// StripeUsers
					{
						PutRequest: {
							Item: {
								'username': userName,
								"stripe_account_id": account_id,
								"stripe_customer_id": customer_id,
							}
						}
					}
				]
			}
		};


		return documentClient.batchWrite(params).promise();
	}).catch((err) => {
		console.log("Error");
		console.log(JSON.stringify(err, null));
		callback(err);
	}).then((data) => {
		console.log("Success");
		console.log(JSON.stringify(data, null));
		callback(null, event); // MUST return event back for the post confirmation lambda trigger to work properly.
	});
};