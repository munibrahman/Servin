# Servin

An app that would let its users request and recieve services on demand. If like uber eats and facebook marketplace had a baby.

I started work on the frontend of the app using SwiftUI, and then made my way slowly to the backend. 

Initially I did use Xcode storyboards, but I realized quickly that they are limited and were error prone.

So, the latter parts of this app were written purely using swift code. I found it to be a lot simpler to get changes into production and it was very pleasent using this approach over storyboards.

I learned how to to create backends using this app, it was the first application for which I created my own GraphQL backend! It was all done using AWS Amplify (Auth) and AWS AppSync.

Since it was the first time that I played around with setting an api, its safe to say I would not do it this way again.

Not only were the costs for test app around $60 a month, setting up dynamodb tables. SQS queues and so on. It was quite painful getting the code from my laptop to the cloud.


## Tech stack

Frontend: iOS, SwiftUI

Backend: AWS, Serverless, GeoJSON Dynamodb database, cloudformation, AWS Cognito for authentication

API: Appsync GraphQL API


## Pre-reqs

You will need an aws account to get the backend up and running.

You will need an Xcode enabled device to run the frontend.

## Instructions

Start the backend using the `rootStackTemplate.yaml` file, it will auto generate the required files for you in the frontend app.

You can then follow the instructions inside `Frontend/Readme.md` to setup the remainder of the app.


## Takeaways

Lots of fun building this app. I learned a lot (probably the most) about getting an application through all of its lifecycles. I got as far as putting in stripe for payments and took charge of the backend.

Things I would change:

- Need a clear vision of why this problem needed solving (Didnt do enough user testing :D)
- Build often, and mock things up (at the start of this project, Sketch was pretty new, there was no Figma, so next time around I would generally recommend using UI/UX mockup tools to get the feel right before coding things)
- Don't mix and match Infrastructure and Application code. I would not follow the same blueprint for creating this app. The backend would either be Django, Node, Ruby. Served via nginx to the frontend. 
- Would probably end up containerizing parts of the backend
- Switch out dynamodb for mongodb (dynamo is an overkill)
- A RESTful API approach would be more preferable. Especially since I started to mix/match Stripe API endpoints as well.