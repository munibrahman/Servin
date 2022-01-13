/* 	Copyright (C) Voltic Labs, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

'use strict';
require('dotenv').config()
var AWS = require('aws-sdk');
AWS.config.setPromisesDependency(require('bluebird'));
var CognitoIdentityServiceProvider = new AWS.CognitoIdentityServiceProvider({ apiVersion: '2016-04-19', region: process.env.COGNITO_AWS_REGION });

exports.handler = function(event, context, callback) {

    console.log(event);
    const confirmationCode = event.queryStringParameters.code
    const username = event.queryStringParameters.username
    const clientId = event.queryStringParameters.clientId
    const region = event.queryStringParameters.region
    const email = event.queryStringParameters.email

    console.log("confirmationCode");
    console.log(confirmationCode);
    console.log("username");
    console.log(username);
    console.log("clientId");
    console.log(clientId);
    

    let params = {
        ClientId: clientId,
        ConfirmationCode: confirmationCode,
        Username: username
    }

    var confirmSignUp = CognitoIdentityServiceProvider.confirmSignUp(params).promise()

    confirmSignUp.then(
        (data) => {
            console.log("Successfully confirmed user");
            console.log(data);

            let redirectUrl = process.env.POST_REGISTRATION_VERIFICATION_REDIRECT_URL
            const response = {
                statusCode: 301,
                headers: {
                    Location: redirectUrl
                }
            };
            
            console.log("Formulated response")
            console.log(response);

            callback(null, response);
        }
    ).catch(
        (error) => {
        callback(error)
        }
    )
}