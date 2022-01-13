I was under the impression that you could take payments from a single connected account and pass it to another one.
That was wrong, you can create a charge or a paymentIntent, and specify the account which the money will go to, but you are not able to directly specify the account that will be making the payments. Once a paymentIntent is created, the user making the payment (buyer of goods/services) will attach a payment source to the intent and go through with the completion of a payment

Read more:
https://stripe.com/docs/connect/charges-transfers




To setup your front-end application to handle paymentIntents. Follow this link: https://stripe.com/docs/payments/payment-intents/ios

