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
    
    
    let baseURL = "https://rf0506menl.execute-api.us-east-1.amazonaws.com/Dev"
    let stripeConnectUrl = "https://dashboard.stripe.com/oauth/authorize?response_type=code&client_id=ca_DL7V24Fxrc570DKzWttBuqsZdzlc5Tuy&scope=read_write"
    
    
    
    static let getPostsEndpoint = "/posts/"
    static let getDiscoveriesEndpoint = "/discoveries"
    static let getUserEndpoint = "/user"
    static let getAddConnectEndpoint = "/stripe/add_connect_account"
    
    func postDiscovery(body: [String: Any], onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURL + APIManager.getDiscoveriesEndpoint
        
        let headers = [
            "Authorization": KeyChainStore.shared.fetchIdToken() ?? ""
        ]
        
        print(body)
        
        let request = Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default , headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let val):
                    print(val)
                    onSuccess(JSON(val))
                    
                case .failure(let err):
                    print(err)
                    onFailure(err)
                }
                
        }
        
        print(request)
    }
    
    func putImage(url: String, image: UIImage, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        let header = ["Content-Type": "image/jpeg"]
        
        print(url)
        
        Alamofire.upload(imageData, to: url, method: .put, headers: header)
            .validate(statusCode: 200..<300)
            .responseString { (response) in
                switch response.result {
                    case .success(let val):
                    onSuccess(JSON(val))
                
                    case .failure(let err):
                    onFailure(err)
                }
        }
        
    }
    
    func getDiscoveries(params: [String: Any], onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURL + APIManager.getDiscoveriesEndpoint
        print(url)
        
        
        guard let idToken = KeyChainStore.shared.fetchIdToken() else {
            print("ERROR, Can't get id token!")
            return
        }
        
        let headers = [
            "Authorization": idToken
        ]
        
        print("URL is \(url)")
        print("Fetching discovery with the id token \(idToken)")
        
        print(params)
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.queryString , headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let val):
                    print(val)
                    onSuccess(JSON.init(val))
                case .failure(let err):
                    print(err)
                    onFailure(err)
                }
                
        }
        
    }
    
    func getUser(username: String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURL + APIManager.getUserEndpoint + "/" + username
        print(url)
        let headers = [
            "Authorization": KeyChainStore.shared.fetchIdToken() ?? ""
        ]
        
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default , headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let val):
                    print(val)
                    onSuccess(JSON.init(val))
                case .failure(let err):
                    print(err)
                    onFailure(err)
                }
                
        }
        
    }
    
    func putUser(username: String, body: [String: Any], onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURL + APIManager.getUserEndpoint + "/" + username
        print(url)
        let headers = [
            "Authorization": KeyChainStore.shared.fetchIdToken() ?? ""
        ]
        
        
        Alamofire.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let val):
                    print(val)
                    onSuccess(JSON.init(val))
                case .failure(let err):
                    print(err)
                    onFailure(err)
                }
                
        }
        
    }
    
//    .responseJSON { response in
//    print("request")
//    print(response.request?.allHTTPHeaderFields)
//    print(response.request?.httpBody)
//    print("response")
//    print(response)
//    print("data")
//    print(response.data ?? "No Data")
//    switch response.result {
//    case .success:
//    onSuccess(JSON.init(response.data))
//    case .failure(let error):
//    onFailure(error)
//    }
//    }
    
//    func updateStripeConnectAccount(accountId: String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
//        let url : String = baseURL + APIManager.getAddConnectEndpoint
//
//        let headers = [
//            "Authorization": KeyChainStore.shared.fetchIdToken() ?? ""
//        ]
//
//        let body = [
//            "StripeAccount" : accountId
//        ]
//
//        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default , headers: headers)
//            .validate(statusCode: 200..<300)
//            .responseJSON { responseJSON in
//                print("request")
//                print(responseJSON.request?.allHTTPHeaderFields)
//                print(responseJSON.request?.httpBody)
//                print("response")
//                print(responseJSON)
//                switch responseJSON.result {
//                case .success:
//                    onSuccess(JSON.init(responseJSON.data))
//                case .failure(let error):
//                    onFailure(error)
//                }
//        }
//
//    }
    
}
