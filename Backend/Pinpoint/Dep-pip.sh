#!/bin/bash

##################################################################################
#####     Root Stack Variables              #####
##################################################################################
#   Setting up variables
templateFile="template.yaml"
bucketName="templatesmunib"
S3Prefix=""
outputTemplateFile="packaged.yaml"
useJSON=$false
forceUpload=$true
stackName="Pinpoint"
ReleaseEnvironment="dev"

##################################################################################
#####     Packaging Root Stack              #####
##################################################################################
aws cloudformation package \
--template-file $templateFile \
--s3-bucket $bucketName \
--output-template-file $outputTemplateFile \
# --use-json $useJSON \
# --force-upload $forceUpload \
# --debug
# --s3-prefix "$S3Prefix/package" \
# --kms-key-id  \
# --metadata  \
##################################################################################
#####     Deploying Root Stack              #####
##################################################################################
aws cloudformation deploy \
--template-file $outputTemplateFile \
--stack-name $stackName \
--s3-bucket $bucketName \
--force-upload $true \
--capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
# --parameter-overrides S3Bucket=$bucketName $(cat parameters-dev.properties) \
# --s3-prefix "$S3Prefix/deploy" \
# --kms-key-id  \


