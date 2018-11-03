//
//  APIManager.swift
//  RESTAPIManager
//
//  Created by Petros Demetrakopoulos on 21/12/2016.
//  Copyright © 2016 Petros Demetrakopoulos. All rights reserved.
//
import UIKit
import SwiftyJSON
import Alamofire

class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    
    
    let baseURL = "https://9w2a1r8yqf.execute-api.us-east-1.amazonaws.com/dev"
    let stripeConnectUrl = "https://dashboard.stripe.com/oauth/authorize?response_type=code&client_id=ca_DL7V24Fxrc570DKzWttBuqsZdzlc5Tuy&scope=read_write"
    
    
    
    static let getPostsEndpoint = "/posts/"
    static let getAddConnectEndpoint = "/stripe/add_connect_account"
    
    func getPostWithId(postId: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURL + APIManager.getPostsEndpoint + String(postId)
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                do {
                    let result = try JSON(data: data!)
                    onSuccess(result)
                } catch _ {
                    onFailure(error!)
                }
                
                
            }
        })
        task.resume()
    }
    
    func updateStripeConnectAccount(accountId: String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURL + APIManager.getAddConnectEndpoint
        
        let headers = [
            "Authorization": KeyChainStore.shared.fetchIdToken() ?? ""
        ]
        
        let body = [
            "StripeAccount" : accountId
        ]
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default , headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                print("request")
                print(responseJSON.request?.allHTTPHeaderFields)
                print(responseJSON.request?.httpBody)
                print("response")
                print(responseJSON)
                switch responseJSON.result {
                case .success:
                    onSuccess(JSON.init(responseJSON.data))
                case .failure(let error):
                    onFailure(error)
                }
        }
        
    }
    
}
