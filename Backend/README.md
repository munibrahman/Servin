# Servin Cloudformation Stack

This stack's responsibility is to encompass the entire Servin Cloud infrastructure backend.
 
It includes the GraphQL API, Cognito User Pools, DynamoDB Tables for messaging. (Still, need to port over the tables for discoveries and Users).

This is a nested stack, with (hopefully) each major component divided into its own stack. I have commented most of the resources that have been used, but I will be coming back to it after launch and adding/removing stuff as necessary.

Below are the outlined steps to get this stack up and running.

## Requirements

You must have the `aws cli` installed and ready to go.

You also need a single s3 bucket for zipping up the resources to and uploading them.


## Installation

Grant the deploy.sh file execution permissions by

```bash
chmod u+x deploy.sh
```

Run the deploy script by

```bash
./deploy.sh {S3Bucket} {StackName} {ReleaseEnvironment}
```

`S3Bucket` is the bucket that you created earlier. 

`StackName` is the name of the stack you would like to give your stack, I would recommend using the environment variable inside the stack name as well, it helps name resources, logs and so on and makes it easier to debug. 

`ReleaseEnvironment` variable must be `test`, `prod` or `dev` respectively.


Follow the output in the cli and if you dont have any errors, you will see an auto-generated file in the path `outputs/{ReleaseEnvironment}/awsconfiguration.json`.

The `awsconfiguration.json` file you generated contains the configuration of backend resources that MobileClient enabled in your project.


## Generating the config file

If for some reason you only want to generate the awsconfiguration.json file, you can do so by running the awsconfiguration.py python script

```bash
python3 awsconfiguration.py {StackName} {ReleaseEnvironment}
```

# Resources I have used to learn for this project

Click [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-nested-stacks.html) to learn about nested stacks.

You don't need to know everything inside out, the biggest thing to note is the difference between a root stack vs. a parent stack.

To make the actual cloudformation resource. Do not use the `AWS::CloudFormation::Stack` resource tag because it doesn't allow SAM to properly generate the s3 bucket URIs for the path of the children template. So, instead use `AWS::Serverless::Application` provided by SAM. More information can be found [here](https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md#awsserverlessapplication).

When you are deploying the nested stack, you will also need to include `CAPABILITY_AUTO_EXPAND` with the capabilities flag.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate (coming soon).

## Acknowledgements
Copyright (C) Voltic Labs, Inc - All Rights Reserved

Unauthorized copying of this file, via any medium, is strictly prohibited

Proprietary and confidential
