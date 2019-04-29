//
//  S3BucketKeys.swift
//  ServinV2
//
//  Created by Munib Rahman on 2019-04-25.
//  Copyright © 2019 Voltic Labs Inc. All rights reserved.
//

// This file holds the key names for aws s3 bucket.
// Private paths can only be read and written by the user themselves
// Protected file can be written to and read from
import Foundation
import AWSMobileClient
// Warning: To run this sample correctly, you must set the following constants.

//let S3DownloadKeyName: String = "public/test-image.png"    // Name of file to be downloaded
//let S3UploadKeyName: String = "public/test-image.png"      // Name of file to be uploaded

let S3ProfileImageKeyName: String = "protected/\(AWSMobileClient.sharedInstance().identityId ?? "")/profile.jpg"
