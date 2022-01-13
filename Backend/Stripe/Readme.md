# AWS Resources

This cloudformation stack is made up of the following resources.

Appsync API: To interact with stripe endpoints as a user, the user must belong to a cognito identity pool for verification purposes.

DynamoDB Table: It houses a user's username (uuid), their responding stripe account id and/or their responding stripe customer id. You can signup users as either customers or give them stripe connect accounts in the `PostConfirmationLambda` trigger.

Rest API: To recieve webhook events from stripe regarding various mutations that occur. A single rest endpoint is currently exposed that handles every event. Eventual goal is to spread them out and make specialized endpoints.

SQS Queue: To store all stripe events that are sent to us. Worker lambda functions are then triggered by the SQS Queue to process events as they come in. There is also a dead letter queue (DLQ), to store events that fail. Events are stored in the DLQ for inspection by an admin.

Lambda functions: Each datasource resolver on the appsync API is a lambda function. All of the appsync calls made on behalf of the user doesn't allow them to enter any stripe credentials. Instead, we do a dynamodb table lookup on their uuid (username token) provided to us by cognito inside the request, for their respective stripe account/customer id.

## Stripe

Stripe divides the type of users into 2 categories. Connect accounts and customers. 

Connect accounts can transfer funds to external bank accounts or debit cards

Customers can pay using bank accounts, credit cards and other methods described in the stripe API documentation.

## Requirements


## Recommendations


When creating synchronus lambdas, use promises: https://developers.google.com/web/fundamentals/primers/promises#whats-all-the-fuss-about
Promsify all requests, becuase its much safer.

## TODO: DELETE AUTH STACK once everything is done
        Remove the auth folder and the extra lambda layers that are not needed.