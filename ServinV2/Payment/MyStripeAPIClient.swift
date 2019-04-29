//
//  MyStripeAPIClient.swift
//  ServinV2
//
//  Created by Developer on 2018-10-03.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

class MyStripeAPIClient: NSObject, STPEphemeralKeyProvider {
    
    static let sharedClient = MyStripeAPIClient()
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func signUpStripe(completion: @escaping STPJSONResponseCompletionBlock) {
        print("create customer key")
        let url = self.baseURL.appendingPathComponent("signup")
        print(url)
        
        let email = DefaultsWrapper.getString(Key.email)
        
        let parameters = [
            "email": email
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                print("request")
                print(responseJSON.request)
                print(responseJSON.request?.httpBody!)
                print("response")
                print(responseJSON)
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    func completeCharge(_ result: STPPaymentResult,
                        amount: Int,
                        shippingAddress: STPAddress?,
                        shippingMethod: PKShippingMethod?,
                        completion: @escaping STPErrorBlock) {
        print("charge account")
        let url = self.baseURL.appendingPathComponent("stripe/charge")
        
        var params: [String: Any] = [
            "source": result.source.stripeID,
            "amount": amount,
            "metadata": [
                // example-ios-backend allows passing metadata through to Stripe
                "subject": "Math 211 tutoring requested",
            ],
            ]
        let header = [
            "Authorization": "ERROR: CANT GET ID TOKEN"
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header )
            .validate(statusCode: 200..<300)
            .responseString { response in
                print(response)
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
        }
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        print("create customer key")
        let url = self.baseURL.appendingPathComponent("stripe/ephemeral_keys")
        print(url)
        
        let parameters = [
            "Authorization": "ERROR: CANT GET ID TOKEN",
            "api_version" : "2018-09-24"
        ]
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                print("request")
                print(responseJSON.request)
                print("response")
                print(responseJSON)
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
}
