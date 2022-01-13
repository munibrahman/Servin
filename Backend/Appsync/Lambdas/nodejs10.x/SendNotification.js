// Input: Cognito Username, notification title, notification body;
// Task: Send the cognito user a push notification to all of their registered devices.
let AWS = require('aws-sdk');
let pinpoint = new AWS.Pinpoint();

exports.lambdaHandler =  async function(event, context) {
    console.log("EVENT: \n" + JSON.stringify(event, null));

    let username = "5358ff60-276f-479e-97c2-632bd3514fc7";
    let title = "Lambda!";
    let body = "Body of this notification";

    var params = {
        ApplicationId: process.env.PinpointAppId, /* required */
        SendUsersMessageRequest: { /* required */
            MessageConfiguration: { /* required */
                APNSMessage: {
                    Action: 'OPEN_APP',
                    Body: body,
                    PreferredAuthenticationMethod: 'TOKEN',
                    SilentPush: false,
                    Sound: 'default',
                    Title: title,
                }
            },
            Users: { /* required */
                [username] : {
                },
            /* '<__string>': ... */
            }
        }
    };
    
    pinpoint.sendUsersMessages(params).promise()
    .catch((err) => {
        console.log("Error sending APNS Notification");
        console.log(JSON.stringify(err));
        return err;
    }).then((data) => {
        console.log(JSON.stringify(data));
        return data;
    });

};