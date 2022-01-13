import subprocess
import json
import boto3
import sys
import os

## This script creates the awsconfiguration.json file required for aws amplify

stackName = sys.argv[1]
environment = sys.argv[2]

# Describes the stack, used to get db endpoint and secrets arn

stackDescriptionCommand = subprocess.Popen(["aws", "cloudformation", "describe-stacks", "--stack-name", stackName, "--output", "json"], stdout=subprocess.PIPE)

output = stackDescriptionCommand.communicate()[0]

stackDescriptionJSON = json.loads(output)

print(json.dumps(stackDescriptionJSON, indent=4, sort_keys=True))

ApiUrl = ""
Region = "us-east-1"
AuthMode = "AMAZON_COGNITO_USER_POOLS"
IdentityPoolId = ""
AppClientSecret = ""
AppClientId = ""
CognitoPoolId = ""
Bucket = ""
PinpointAppId = ""
PinpointAppRegion = ""
SecretsManagerARN = ""

for outputObject in stackDescriptionJSON["Stacks"][0]["Outputs"]:
        print(outputObject)
        key = outputObject["OutputKey"]
        value = outputObject["OutputValue"]
        if key == "UserPoolID":
                CognitoPoolId = value
        if key == "GraphQLApiUrl":
                ApiUrl = value
        if key == "UserPoolClientID":
                AppClientId = value
        if key == "IdentityPoolID":
                IdentityPoolId = value
        if key == "S3BucketName":
                Bucket = value
        if key == "PinpointAppId":
                PinpointAppId = value
        if key == "PinpointAppRegion":
                PinpointAppRegion = value
        if key == "SecretsManagerARN":
                SecretsManagerARN = value
        if key == "RDSClusterName":
                RDSDBClusterEndpoint = value



cognitoPoolCommand = subprocess.Popen(["aws", "cognito-idp", "describe-user-pool-client", "--client-id", AppClientId, "--user-pool-id", CognitoPoolId], stdout=subprocess.PIPE)

output = cognitoPoolCommand.communicate()[0]

cognitoPoolCommandJSON = json.loads(output)

print(cognitoPoolCommandJSON)

AppClientSecret = cognitoPoolCommandJSON["UserPoolClient"]["ClientSecret"]

print(ApiUrl)
print(IdentityPoolId)
print(AppClientId)
print(CognitoPoolId)
print(Bucket)
print(AppClientSecret)
print(PinpointAppId)

jsonText = {
    "UserAgent": "aws-amplify/cli",
    "Version": "0.1.0",
    "IdentityManager": {
        "Default": {}
    },
    "AppSync": {
        "Default": {
            "ApiUrl": ApiUrl,
            "Region": Region,
            "AuthMode": AuthMode
        }
    },
    "CredentialsProvider": {
        "CognitoIdentity": {
            "Default": {
                "PoolId": IdentityPoolId,
                "Region": Region
            }
        }
    },
    "CognitoUserPool": {
        "Default": {
            "AppClientSecret": AppClientSecret,
            "AppClientId": AppClientId,
            "PoolId": CognitoPoolId,
            "Region": Region
        }
    },
    "S3TransferUtility": {
        "Default": {
            "Bucket": Bucket,
            "Region": Region
        }
    },
    "PinpointAnalytics": {
        "Default": {
            "AppId": PinpointAppId,
            "Region": PinpointAppRegion
        }
    },
    "PinpointTargeting": {
        "Default": {
            "Region": PinpointAppRegion
        }
    }
}

pathToFile = ""

print(environment)

if environment == "test":
        pathToFile = "Amplify/output/test/awsconfiguration.json"
if environment == "prod":
        pathToFile = "Amplify/output/prod/awsconfiguration.json"
if environment == "dev":
        pathToFile = "Amplify/output/dev/awsconfiguration.json"

os.makedirs(os.path.dirname(pathToFile), exist_ok=True)
with open(pathToFile, 'w') as outfile:
    json.dump(jsonText, outfile, sort_keys = True, indent = 4, ensure_ascii = False)

# ## Following code snippet is used to upload the sql schema into the rds database
# # Command used to get the arn for a db cluster
# print("\n\n*****Uploading the SQL Schema to RDS\n")
# dbClusterArnCommand = subprocess.Popen(["aws", "rds", "describe-db-clusters", "--db-cluster-identifier", RDSDBClusterEndpoint, "--region", "us-east-1"], stdout=subprocess.PIPE)

# output = dbClusterArnCommand.communicate()[0]

# dbClusterArnCommandJSON = json.loads(output)
# print(json.dumps(dbClusterArnCommandJSON, indent=4, sort_keys=True))

# dbClusterArn = dbClusterArnCommandJSON["DBClusters"][0]["DBClusterArn"]

# print(RDSDBClusterEndpoint)
# print(dbClusterArn)
# print(SecretsManagerARN)

# sql = open("./Schema_Script.sql").read()

# sqlCommand = subprocess.Popen(["aws", "rds-data", "execute-sql", "--db-cluster-or-instance-arn", dbClusterArn, "--schema", "mysql",  "--aws-secret-store-arn", SecretsManagerARN, "--region", "us-east-1", "--sql-statements", sql], stdout=subprocess.PIPE)

# output = sqlCommand.communicate()[0]

# print("Uploaded database tables")
# print(output)