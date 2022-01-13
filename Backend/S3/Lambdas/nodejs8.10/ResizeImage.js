/**
 *
 * Event doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format
 * @param {Object} event - API Gateway Lambda Proxy Input Format
 * @param {string} event.resource - Resource path.
 * @param {string} event.path - Path parameter.
 * @param {string} event.httpMethod - Incoming request's method name.
 * @param {Object} event.headers - Incoming request headers.
 * @param {Object} event.queryStringParameters - query string parameters.
 * @param {Object} event.pathParameters - path parameters.
 * @param {Object} event.stageVariables - Applicable stage variables.
 * @param {Object} event.requestContext - Request context, including authorizer-returned key-value pairs, requestId, sourceIp, etc.
 * @param {Object} event.body - A JSON string of the request payload.
 * @param {boolean} event.body.isBase64Encoded - A boolean flag to indicate if the applicable request payload is Base64-encode
 *
 * Context doc: https://docs.aws.amazon.com/lambda/latest/dg/nodejs-prog-model-context.html 
 * @param {Object} context
 * @param {string} context.logGroupName - Cloudwatch Log Group name
 * @param {string} context.logStreamName - Cloudwatch Log stream name.
 * @param {string} context.functionName - Lambda function name.
 * @param {string} context.memoryLimitInMB - Function memory.
 * @param {string} context.functionVersion - Function version identifier.
 * @param {function} context.getRemainingTimeInMillis - Time in milliseconds before function times out.
 * @param {string} context.awsRequestId - Lambda request ID.
 * @param {string} context.invokedFunctionArn - Function ARN.
 *
 * Return doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
 * @returns {Object} object - API Gateway Lambda Proxy Output Format
 * @returns {boolean} object.isBase64Encoded - A boolean flag to indicate if the applicable payload is Base64-encode (binary support)
 * @returns {string} object.statusCode - HTTP Status Code to be returned to the client
 * @returns {Object} object.headers - HTTP Headers to be returned
 * @returns {Object} object.body - JSON Payload to be returned
 * 
 */

// dependencies
var async = require('async');
var AWS = require('aws-sdk');
var gm = require('gm').subClass({ imageMagick: true }); // Enable ImageMagick integration.
var util = require('util');
const rek = new AWS.Rekognition();
const dbparams = {
    region: 'us-east-1',
    apiVersion: '2012-08-10'
}
const dynamodb = new AWS.DynamoDB(dbparams);
const MEGABYTE = 1000000;
// constants
var MAX_WIDTH  = 100;
var MAX_HEIGHT = 100;
var documentClient = new AWS.DynamoDB.DocumentClient();
const SizeEnum = {
    "ICON": 128,
    "MED": 512,
    "MAX": 1024
};

// get reference to S3 client 
const s3 = new AWS.S3();
var sha256 = require('js-sha256');

exports.handler = function(event, context, callback) {
    // Read options from the event.
    console.log("Reading options from event:\n", util.inspect(event, {depth: 5}));

    // If file is too large delete it
    if (event.Records[0].s3.object.size > 5*MEGABYTE) {
        // delete image
        deleteImage(srcBucket, srcKey);
        return
    }
    console.log("Image is small enough");

    var srcBucket = event.Records[0].s3.bucket.name;
    var srcKey    = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " "));     // Object key may have spaces or unicode non-ASCII characters.
    var dstBucket = srcBucket;

    console.log("Source Bucket " + srcBucket);
    console.log("Source Key " + srcKey);
    console.log("Destination Bucket " + dstBucket);

    var splitSource = srcKey.split('/');
    var folder = splitSource[0];
    var discoveryId = splitSource[1];
    var fileName = splitSource[2].split('.')[0];
    var fileType = splitSource[2].split('.')[1];

    console.log("Folder is " + folder);
    console.log("Discovery Id " + discoveryId);
    console.log("File name " + fileName);
    console.log("File type " + fileType);
    
    fileType = "png"

    // for (const Enum in SizeEnum) {
    //     if (SizeEnum.hasOwnProperty(Enum)) {
            
    //         if (Enum === fileName) {
    //             console.log("Dont resize the images that have already been resized");
    //             callback(null, event);
    //             return;
    //         }
            
    //     }
    // }
    // Infer the image type.
    var typeMatch = srcKey.match(/\.([^.]*)$/);
    if (!typeMatch) {
        callback("Could not determine the image type.");
        console.log("Could not determine the image type.");
        deleteImage(srcBucket, srcKey);
        return;
    }
    var imageType = typeMatch[1];
    if (imageType != "jpg") {
        callback('Unsupported image type: ${imageType}');
        console.log('Unsupported image type: ${imageType}');
        deleteImage(srcBucket, srcKey);
        return;
    }

    console.log("The image is the right size and is a JPG");

    // Performing Machine Learning  ---------------------------------------------------------------------------------------
    
    var tags = [];

    rek.detectModerationLabels({
        Image: {
            S3Object: {
                Bucket: srcBucket,      // enter your S3 bucket
                Name: srcKey            // enter your picture file name
            }
        },
        MinConfidence: 80  // only see labels above this confidence
    }, function(err, data) {
        if (err) {
            console.log(err, err.stack); // an error occurred
        }else{
            // console.log("The data moderation is: ")
            // console.log(data);// successful response
            // console.log("Reading Moderation Data:\n", util.inspect(data, {depth: 5}));
            // data.ModerationLabels.forEach(label =>{
            //     console.log(label.Name);
            // })
            if (data.ModerationLabels.length > 0) {
                // found bad images, delete them
                console.log("Found bad images lol");
                deleteImage(srcBucket, dstBucket);
            }else{
                // rekognition detect labels output
                rek.detectLabels({
                    Image: {
                        S3Object: {
                            Bucket: srcBucket,      // enter your S3 bucket
                            Name: srcKey            // enter your picture file name
                        }
                    },
                    MaxLabels: 5,     // the max number of labels
                    MinConfidence: 90  // only see labels above this confidence
                },function (err, data) {
                    if (err) {
                        console.log(err, err.stack); // an error occurred
                    }else{
                        //console.log("The labels are: ")
                        //console.log(data);          // successful response
                        console.log("Reading Label Data:\n", util.inspect(data, {depth: 5}));
                        
                        data.Labels.forEach(aLabel => {
                            console.log(aLabel.Name);
                            tags.push(aLabel.Name.toString());    
                        });
                        rek.detectText({
                            Image: {
                                S3Object: {
                                    Bucket: srcBucket,      // enter your S3 bucket
                                    Name: srcKey            // enter your picture file name
                                }
                            }
                        }, function (err, data) {
                            if (err) {
                                console.log(err, err.stack); // an error occurred
                            }else{
                                // console.log("The detected text is: ")
                                // console.log(data);// successful response
                                console.log("Reading Text Data:\n", util.inspect(data, {depth: 5}));
                                data.TextDetections.forEach(text => {
                                    if (text.Confidence > 80) {
                                        console.log(text.DetectedText);
                                        tags.push(text.DetectedText.toString());
                                    }
                                });

                                s3.getObject({
                                    Bucket: srcBucket,
                                    Key: srcKey
                                },(err, data) =>  {
                                    if(err){
                                        console.log("THERE WAS AN ERROR ACCESSING S3 Object");
                                    }else{
                                        //if (data.Metadata.hasOwnProperty("discovery_id")) {      // is a discovery image
                                        // if (data.Metadata['type'] === "discovery") {      // is a discovery image
                                        console.log("PRINTING METADATA ---------------------------DISCOVERY IMAGE");
                                        console.log(data);
                                        console.log("discovery_id: " + data.Metadata['discovery_id']);
                                        console.log("geohash_prefix: " + data.Metadata['geohash_prefix']);
                                        console.log("image_number: " + data.Metadata['image_number']);
                                        console.log("The SET: ");
                                        console.log(Array.from(new Set(tags)));
                                        console.log("The array length: " + tags.length);
                                        
                                        var imagePaths = {
                                            "original" : srcKey,
                                            "ICON" : `${folder}/${discoveryId}/ICON/${fileName}.${fileType}`,
                                            "MED" : `${folder}/${discoveryId}/MED/${fileName}.${fileType}`,
                                            "MAX" : `${folder}/${discoveryId}/MAX/${fileName}.${fileType}`
                                        }

                                        var params = {
                                            TableName : "Discoveries",                          // TODO: Change this to environment variable
                                            Key: {
                                                "discoveryId": data.Metadata['discovery_id'],
                                                "geohashPrefix": parseInt(data.Metadata['geohash_prefix'])
                                            },
                                            UpdateExpression: 'add #a :x set #b = :y',
                                            ExpressionAttributeNames: {'#a' : 'tags', "#b": 'image_' + data.Metadata['image_number']},
                                            ExpressionAttributeValues: {
                                                ':x' : documentClient.createSet(Array.from(new Set(tags))),
                                                ':y' : imagePaths
                                            }
                                        };
                                        documentClient.update(params, function(err, data) {
                                            if (err) console.log(err);
                                            else console.log(data);
                                        });
                                    }
                                });
                            }
                        });
                    }
                });
            }
        }
    });

    // Updating DynamoDB Table (Discoveries)---------------------------------------------------------------------------------------------------------------------
    // Extract Metadata from image;
    //console.log(data.Metadata['x-amz-meta-checksum']);
    // s3.getObject({
    //     Bucket: srcBucket,
    //     Key: srcKey
    // },(err, data) =>  {
    //     if(err){
    //         console.log("THERE WAS AN ERROR ACCESSING S3 Object");
    //     }else{
    //         console.log("PRINTING METADATA");
    //         console.log("discovery_id: " + data.Metadata['discovery_id']);
    //         console.log("geohash_prefix: " + data.Metadata['geohash_prefix']);
    //         console.log("image_number: " + data.Metadata['image_number']);

    //         console.log("The SET: ");
    //         console.log(Array.from(new Set(tags)));
    //         console.log("The array length: " + tags.length);
            
    //         ////////////////////////////////////////////////
    //         var params = {
    //             TableName : "Discoveries",
    //             Key: {
    //                 "discoveryId": data.Metadata['discovery_id'],
    //                 "geohashPrefix": parseInt(data.Metadata['geohash_prefix'])
    //             },
    //             //UpdateExpression: "set tags= :arrp",
    //             // UpdateExpression: "ADD tags = list_append(tags, :arrp)",
    //             UpdateExpression: "ADD tags :arrp",
    //             ExpressionAttributeValues: {
    //                 ":arrp": documentClient.createSet([ "test3", "asf" ])//documentClient.createSet(Array.from(new Set(tags)))//
    //             }
    //         };
    //         documentClient.update(params, function(err, data) {
    //             if (err) console.log(err);
    //             else console.log(data);
    //          });
    //     }
    // });
    //---------------------------------------------------------------------------------------------------------------------

    // Generating image assets
    for (const imageSize in SizeEnum) {
        if (SizeEnum.hasOwnProperty(imageSize)) {
            var dstKey = `${folder}/${discoveryId}/${imageSize}/${fileName}.${fileType}`;
            console.log(dstKey);
            resize(srcBucket, dstBucket, srcKey, dstKey, fileType, imageSize);
        }
    }

};


function resize(srcBucket, dstBucket,  srcKey, dstKey, imageType, imageSize){
    // Sanity check: validate that source and destination are different buckets.
    if (srcKey == dstKey) {
        // callback("Source and destination Object Keys are the same.");
        console.log("Source and destination Object Keys are the same.");
        return;
    }else{
        // Download the image from S3, transform, and upload to a different S3 bucket.
        async.waterfall([
            function download(next) {
                // Download the image from S3 into a buffer.
                s3.getObject({
                        Bucket: srcBucket,
                        Key: srcKey
                    },
                next);
            },
            function transform(response, next) {
                gm(response.Body).size(function(err, size) {
                    // Infer the scaling factor to avoid stretching the image unnaturally.
                    var scalingFactor = Math.min(
                        SizeEnum[imageSize] / size.width,
                        SizeEnum[imageSize] / size.height
                    );
                    var width  = scalingFactor * size.width;
                    var height = scalingFactor * size.height;

                    // Transform the image buffer in memory.
                    this.resize(width, height)
                        .toBuffer(imageType, function(err, buffer) {
                            if (err) {
                                next(err);
                            } else {
                                next(null, response.ContentType, buffer);
                            }
                        });
                });
            },
            function upload(contentType, data, next) {
                // Stream the transformed image to a different S3 bucket.
                s3.putObject({
                        Bucket: dstBucket,
                        Key: dstKey,
                        Body: data,
                        ContentType: contentType
                },
                next);
            }
            ], function (err) {
                if (err) {
                    console.error(
                        'Unable to resize ' + srcBucket + '/' + srcKey +
                        ' and upload to ' + dstBucket + '/' + dstKey +
                        ' due to an error: ' + err
                    );
                    deleteImage(srcBucket, srcKey);
                } else {
                    console.log(
                        'Successfully resized ' + srcBucket + '/' + srcKey +
                        ' and uploaded to ' + dstBucket + '/' + dstKey
                    );
                }
                //callback(null, "message");
            }
        );
    }
}

function deleteImage(srcBucket, srcKey) {
    s3.deleteObject({
        Bucket: srcBucket,
        Key: srcKey
    },function (err,data){
        console.log("Image Deleted- Bucket: " + srcBucket + "Key: " + srcKey);
    });
}

exports.profileHandler = function(event, context, callback) {
    // Read options from the event.
    console.log("Reading options from event:\n", util.inspect(event, {depth: 5}));

    // If file is too large delete it
    if (event.Records[0].s3.object.size > 5*MEGABYTE) {
        // delete image
        deleteImage(srcBucket, srcKey);
        return
    }
    console.log("Image is small enough");

    var srcBucket = event.Records[0].s3.bucket.name;
    var srcKey    = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " "));     // Object key may have spaces or unicode non-ASCII characters.
    var dstBucket = srcBucket;

    console.log("Source Bucket " + srcBucket);
    console.log("Source Key " + srcKey);
    console.log("Destination Bucket " + dstBucket);

    var splitSource = srcKey.split('/');
    var folder = splitSource[0];
    var identityId = splitSource[1];
    var fileName = splitSource[2].split('.')[0];
    var fileType = splitSource[2].split('.')[1];

    console.log("Folder is " + folder);
    console.log("Identity Id " + identityId);
    console.log("File name " + fileName);
    console.log("File type " + fileType);
    
    fileType = "png"

    // Infer the image type.
    var typeMatch = srcKey.match(/\.([^.]*)$/);
    if (!typeMatch) {
        callback("Could not determine the image type.");
        console.log("Could not determine the image type.");
        deleteImage(srcBucket, srcKey);
        return;
    }
    var imageType = typeMatch[1];
    if (imageType != "jpg") {
        callback('Unsupported image type: ${imageType}');
        console.log('Unsupported image type: ${imageType}');
        deleteImage(srcBucket, srcKey);
        return;
    }

    console.log("The image is the right size and is a JPG");

    // Performing Machine Learning  ---------------------------------------------------------------------------------------
    
    var tags = [];

    rek.detectModerationLabels({
        Image: {
            S3Object: {
                Bucket: srcBucket,      // enter your S3 bucket
                Name: srcKey            // enter your picture file name
            }
        },
        MinConfidence: 80  // only see labels above this confidence
    }, function(err, data) {
        if (err) {
            console.log(err, err.stack); // an error occurred
        }else{
            // console.log("The data moderation is: ")
            // console.log(data);// successful response
            // console.log("Reading Moderation Data:\n", util.inspect(data, {depth: 5}));
            // data.ModerationLabels.forEach(label =>{
            //     console.log(label.Name);
            // })
            if (data.ModerationLabels.length > 0) {
                // found bad images, delete them
                console.log("Found bad images lol");
                deleteImage(srcBucket, dstBucket);
            }else{
                // rekognition detect labels output
                rek.detectLabels({
                    Image: {
                        S3Object: {
                            Bucket: srcBucket,      // enter your S3 bucket
                            Name: srcKey            // enter your picture file name
                        }
                    },
                    MaxLabels: 5,     // the max number of labels
                    MinConfidence: 90  // only see labels above this confidence
                },function (err, data) {
                    if (err) {
                        console.log(err, err.stack); // an error occurred
                    }else{
                        //console.log("The labels are: ")
                        //console.log(data);          // successful response
                        console.log("Reading Label Data:\n", util.inspect(data, {depth: 5}));
                        
                        data.Labels.forEach(aLabel => {
                            console.log(aLabel.Name);
                            tags.push(aLabel.Name.toString());    
                        });
                        rek.detectText({
                            Image: {
                                S3Object: {
                                    Bucket: srcBucket,      // enter your S3 bucket
                                    Name: srcKey            // enter your picture file name
                                }
                            }
                        }, function (err, data) {
                            if (err) {
                                console.log(err, err.stack); // an error occurred
                            }else{
                                // console.log("The detected text is: ")
                                // console.log(data);// successful response
                                console.log("Reading Text Data:\n", util.inspect(data, {depth: 5}));
                                data.TextDetections.forEach(text => {
                                    if (text.Confidence > 80) {
                                        console.log(text.DetectedText);
                                        tags.push(text.DetectedText.toString());
                                    }
                                });

                                s3.getObject({
                                    Bucket: srcBucket,
                                    Key: srcKey
                                },(err, data) =>  {
                                    if(err){
                                        console.log("THERE WAS AN ERROR ACCESSING S3 Object");
                                    }else{
                                        //if (data.Metadata.hasOwnProperty("discovery_id")) {      // is a discovery image
                                        // if (data.Metadata['type'] === "discovery") {      // is a discovery image
                                        console.log("PRINTING METADATA ---------------------------DISCOVERY IMAGE");
                                        console.log(data);

                                        var cognito_id = data.Metadata['cognito_id'];
                                        console.log("cognito_id: " + data.Metadata['cognito_id']);
                                        console.log("The SET: ");
                                        console.log(Array.from(new Set(tags)));
                                        console.log("The array length: " + tags.length);
                                        
                                        var imagePaths = {
                                            "original" : srcKey,
                                            "ICON" : `${folder}/${identityId}/ICON/${fileName}.${fileType}`,
                                            "MED" : `${folder}/${identityId}/MED/${fileName}.${fileType}`,
                                            "MAX" : `${folder}/${identityId}/MAX/${fileName}.${fileType}`
                                        }

                                        var params = {
                                            TableName : process.env.USER_TABLE,                          // TODO: Change this to environment variable
                                            Key: {
                                                "username": cognito_id
                                            },
                                            UpdateExpression: 'set #b = :y',
                                            ExpressionAttributeNames: {"#b": 'profilePic'},
                                            ExpressionAttributeValues: {
                                                ':y' : imagePaths
                                            }
                                        };
                                        documentClient.update(params, function(err, data) {
                                            if (err) console.log(err);
                                            else console.log(data);
                                        });
                                    }
                                });
                            }
                        });
                    }
                });
            }
        }
    });

    // Generating image assets
    for (const imageSize in SizeEnum) {
        if (SizeEnum.hasOwnProperty(imageSize)) {
            var dstKey = `${folder}/${identityId}/${imageSize}/${fileName}.${fileType}`;
            console.log(dstKey);
            resize(srcBucket, dstBucket, srcKey, dstKey, fileType, imageSize);
        }
    }

};