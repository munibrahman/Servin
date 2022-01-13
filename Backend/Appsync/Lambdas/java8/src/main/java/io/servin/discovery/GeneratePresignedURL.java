package io.servin.discovery;

//Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//SPDX-License-Identifier: MIT-0 (For details, see https://github.com/awsdocs/amazon-s3-developer-guide/blob/master/LICENSE-SAMPLECODE.)

import java.io.IOException;
import java.net.URL;

import org.json.simple.JSONObject;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.HttpMethod;
import com.amazonaws.SdkClientException;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.Headers;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;

public class GeneratePresignedURL {
	static final int PRESIGNED_URL_EXPIRATION_TIME_MINUTES = 5;

	public static URL generate(String clientRegion, String bucketName, String objectKey, HttpMethod method, JSONObject metaData) throws IOException {
		URL url = null;
		try {
			AmazonS3 s3Client = AmazonS3ClientBuilder.defaultClient();

			// AmazonS3 s3Client = AmazonS3ClientBuilder.standard().withRegion(clientRegion).withCredentials(new ProfileCredentialsProvider()).build();

			// Set the presigned URL to expire after one hour.
			java.util.Date expiration = new java.util.Date();
			expiration.setTime(expiration.getTime() + PRESIGNED_URL_EXPIRATION_TIME_MINUTES * 60 * 1000);

			// Generate the presigned URL.
			//System.out.println("Generating pre-signed URL.");

			GeneratePresignedUrlRequest generatePresignedUrlRequest = new GeneratePresignedUrlRequest(bucketName, objectKey).withMethod(method).withExpiration(expiration);
			//generatePresignedUrlRequest.setContentType("image/jpeg");
			//generatePresignedUrlRequest.
			
			// add metadata to object that is uploaded via presigned url
			
//			generatePresignedUrlRequest.addRequestParameter(Headers.S3_USER_METADATA_PREFIX + metaData.get("discoveryId"), "bar");
			if (method == HttpMethod.PUT) {
			    for (Object key : metaData.keySet()) {
			        //based on you key types
			        String keyStr = (String)key;
			        Object keyvalue = metaData.get(keyStr);
			        System.out.println("keyStr" + keyStr);
			        //generatePresignedUrlRequest.addRequestParameter(Headers.S3_USER_METADATA_PREFIX + metaData.get(keyStr), (String) keyvalue);
			        generatePresignedUrlRequest.addRequestParameter(Headers.S3_USER_METADATA_PREFIX + keyStr, metaData.get(keyStr).toString());
			        //Print key and value
//			        System.out.println("key: "+ keyStr + " value: " + keyvalue);

//			        //for nested objects iteration if required
//			        if (keyvalue instanceof JSONObject)
//			            printJsonObject((JSONObject)keyvalue);
			    }
			    generatePresignedUrlRequest.setContentType("image/jpeg");		// required so that the image isn't donwloaded
			}

			url = s3Client.generatePresignedUrl(generatePresignedUrlRequest);
			//System.out.println("Pre-Signed URL: " + url.toString());
			
		} catch (AmazonServiceException e) {
			// The call was transmitted successfully, but Amazon S3 couldn't process
			// it, so it returned an error response.
			e.printStackTrace();
		} catch (SdkClientException e) {
			// Amazon S3 couldn't be contacted for a response, or the client
			// couldn't parse the response from Amazon S3.
			e.printStackTrace();
		}
		return url;
	}
}
