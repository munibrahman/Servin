## Webhook Microservices
Come back to this.

Overview 

Stripe webhooks -> Api Gateway  -- > Lambda Auth  -> SQS Queue -> Lambda function

Stripe api requires the body of an incoming request, along with the header signature to confirm that a webhook is genuine. Since the body of an incoming request is never passed to a custom api gateway authorizer lambda. We need to allow all requests to come through and then verify them ourselves.


Goal is to modularize every big chunck, seperate stack for SQS, seperate stack for API Gateway and so on.

IMPORTANT: Any functions that are triggered by SQS must be asynchronous. For more information, visit: https://docs.aws.amazon.com/lambda/latest/dg/with-sqs-example.html


TODO:

Make slave lambdas after the SQS Queue for handling seperate types of incoming requests