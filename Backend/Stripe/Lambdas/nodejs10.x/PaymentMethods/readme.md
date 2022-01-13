## PaymentMethods


Payment methods are created on the user's end device.
Payment methods can be attached to a customer.


https://stripe.com/docs/payments/payment-methods

The new Payment Methods API, which replaces the existing Tokens and Sources APIs, is now the recommended way for integrations to collect and store payment information. It works with the Payment Intents API to create payments for a wide range of payment methods.

The main difference between the Payment Methods API and the Sources API is that Sources describe transaction state through the status property, which means that each Source object must be transitioned to a chargeable state before it can be used for a payment. In contrast, PaymentMethods are stateless, relying on the PaymentIntent object to represent the transaction state of a given payment.

We plan to eventually support all payment methods on the Payment Methods API. In the meantime, the Sources API may be right for cases where a particular payment method is not yet supported on the Payment Methods API.