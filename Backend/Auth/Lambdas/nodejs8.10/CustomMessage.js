/* 	Copyright (C) Voltic Labs, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

// Taken from:
// https://github.com/aws-amplify/amplify-js/issues/612
// Task: This lambda function runs when a user decides to verify their email.
// For more information, visit:
// https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-lambda-custom-message.html


'use strict';

exports.handler = (event, context, callback) => {
    // Identify why was this function invoked
    if(event.triggerSource === "CustomMessage_SignUp") {
        // Ensure that your message contains event.request.codeParameter. This is the placeholder for code that will be sent
        console.log("Event:");
        console.log(event);
        const { codeParameter } = event.request
        const { userName, region } = event
        const { clientId } = event.callerContext
        const { email } = event.request.userAttributes
        const url = process.env.WEBSITE_URL                                                                     // This will redirect the user to the website, where a universal links file will be hosted. It will then redirect the user to the ap.
        const link = `<a href="${url}/confirm/${email}/${codeParameter}" target="_blank">here</a>`
        event.response.emailSubject = "Servin Verification Link"; // event.request.codeParameter
        event.response.emailMessage = `Thank you for signing up for Servin. Click ${link} to verify your email.`;
    } 
    
    else if (event.triggerSource === "CustomMessage_ResendCode") {
        console.log("Resent confirmation code");
        console.log(event);
    }

    else if (event.triggerSource === "CustomMessage_ForgotPassword") {
        console.log("Forgot password");
        console.log(event);

        const { codeParameter } = event.request
        const { userName, region } = event
        const { clientId } = event.callerContext
        const { email, given_name, family_name } = event.request.userAttributes
        const url = process.env.WEBSITE_URL
        const link = `<a href="${url}/forgot/${email}/${codeParameter}" target="_blank">here</a>`
        event.response.emailSubject = "Forgot Password"; // event.request.codeParameter
        event.response.emailMessage = `Hi ${given_name},\nWe got a request to reset your Servin password. Click ${link} to reset your password.`;
    }
    
    else {
        console.log("Trigger source is different.");
        console.log(event.triggerSource);
        console.log(event);
        
    }

    console.log("Event after");
    console.log(event);

    // Return to Amazon Cognito
    callback(null, event);
};