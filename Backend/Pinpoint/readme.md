## Pinpoint Cloudformation Stack

This repo contains the steps necessary to get Apple Push Notification Service (APNS) up and running for your iOS application.

# Requirements

- An Apple Developer account
- Ability to generate APNS Keys via the apple developer portal

# Instructions
Head over to [this](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/establishing_a_token-based_connection_to_apns) article to get an overview of how to generate an APNS key from the apple developer portal.

Once the key has been generated, download the file and open it in a text editor of your choice. The file will look something like:

`-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgWlFf8zT5kq8PfLmk
kNWBOnRm7OZoYfjSGW8tvMsKk6SgCgYIKoZIzj0DAQehRANCAAQ6pjMJbp2pJrma
bgjTNd96knFlILSh3CTzGT7eTjy8uPLtLn+AC3Hxqn8Ad+fg3bKlzKYN6JNVVAbo
MPy/95do
-----END PRIVATE KEY-----`

Copy the contents of the key, so all of `MIGTAgEAMBM.../95do` and paste it into the `template.yaml` file under the `TokenKey` parameter.

Ensure that all of the other template parameters are correct as well. Once everything is changed to your liking, you are now able to upload this cloudformation stack and register your devices to be able to recieve notifications as well.

# Uploading Stack

Navigate to the root directory and open the `Dep-pip.sh` file. Change the variables to the ones you will be using, including the name of the stack, name of the s3 bucket and so on. Run the following command.

`$ ./Dep-pip.sh`

You can check the progress on the cli or by navigating to the console on the aws website.


# Registering Apple devices for APNS
[This](https://aws-amplify.github.io/docs/ios/push-notifications) article does an excellent job of explaining the entire process.

Keep in mind, in the article, it forces you to use a Release profile instead of the default Debug profile. This is not true in the case of an `APNSSandboxChannel`, which allows you to register the endpoints and also send notifications to them in the sandbox environment.

Once the app is released on the market, the enviornment will be changed to prod, as will the release profile, so it will automatically switch to the `APNSChannel`.

# Testing
In an iOS application, after registering for APNS, you can retrieve your device token by `print(pinpoint?.targetingClient.currentEndpointProfile().address)` inside your Appdelegate.

Navigate to the [console](https://console.aws.amazon.com/pinpoint/home/) and press Test Messaging on the left side. Enter your device token and select the proper channel, create a message and send it to your device. It should send a push notification right away.