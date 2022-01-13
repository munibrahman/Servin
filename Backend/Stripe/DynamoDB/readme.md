## DynaomDB Stack

This stack has a single dynamoDB table that stores a user's uuid (SUB, username) and their corresponding stripe account id.


This dynamodb table can ONLY be accessed by the lambda functions that are authorized to do so. The client or the Appsync api will never be given access to this table for numerous security reasons.

If you ever find yourself giving direct access to this table, please refrain from doing so, as it will compromise the integrity of the entire system.


## TODO
Figure out dynamodb streams