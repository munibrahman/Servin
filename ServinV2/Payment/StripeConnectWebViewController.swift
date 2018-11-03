//
//  StripeConnectWebViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-10-31.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class StripeConnectWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    override func loadView() {
        
        view = UIView()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
      
        
        
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        var urlString = APIManager.sharedInstance.stripeConnectUrl
        
        if let email = DefaultsWrapper.getString(Key.email) {
            urlString.append("&stripe_user[email]=\(email)")
        }
        urlString.append("&stripe_user[url]=http://www.servin.io")
        urlString.append("&stripe_user[country]=CA")
        urlString.append("&stripe_user[business_name]=servin")
        urlString.append("&stripe_user[business_type]=sole_prop")
        urlString.append("&stripe_user[physical_product]=false")
        urlString.append("&stripe_user[product_category]=other")
        urlString.append("&stripe_user[product_description]=Offering%20services%20on%20the%20Servin%20network")
//        urlString.append("&stripe_user[street_address]=15%20Ranche%20Drive")
//        urlString.append("&stripe_user[city]=Heritage%20Pointe")
//        urlString.append("&stripe_user[state]=AB")
//        urlString.append("&stripe_user[zip]=T0L0X0")
        

        
        if let fname = DefaultsWrapper.getString(Key.givenName) {
            urlString.append("&stripe_user[first_name]=\(fname)")
        }
        
        if let lname = DefaultsWrapper.getString(Key.familyName) {
            urlString.append("&stripe_user[last_name]=\(lname)")
        }
        
        print(urlString)
        
        
        let myURL = URL(string: urlString)
        
        
        let myRequest = URLRequest(url: myURL!)

        
        webView.load(myRequest)
        self.navigationItem.title = myURL?.host
        
        setupNavigationBar()
        setupProgressView()
    }
    
    func setupNavigationBar() {
        if self.navigationController?.viewControllers.first == self {
            let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(userDidTapX))
            leftBarButton.tintColor = .black
            self.navigationItem.leftBarButtonItem = leftBarButton
        } else {
            let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_grey"), style: .plain, target: self, action: #selector(userDidTapBack))
            leftBarButton.tintColor = .black
            self.navigationItem.leftBarButtonItem = leftBarButton
        }
        
    }
    
    @objc func userDidTapX() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func userDidTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupProgressView() {
        progressView = UIProgressView(progressViewStyle: .default)
        self.view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        progressView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        //progressView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            print(webView.estimatedProgress)
            if (webView.estimatedProgress == 1.0) {
                progressView.isHidden = true
            }
            else {
                progressView.isHidden = false
                progressView.progress = Float(webView.estimatedProgress)
            }
            
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigation to:")
        print(webView.url ?? "Can't see url")
        
        self.navigationItem.title = webView.url?.host
        
        if let code = webView.url?.valueOf("code") {
            
            self.navigationItem.title = "servin.io"
            
            // The user was able to connect their account.
            // Make a call to your own api and save the given account id.
            APIManager.sharedInstance.updateStripeConnectAccount(accountId: code, onSuccess: { (json) in
                print("successfully saved stripe account id in dynamodb")
                // TODO: Show some success message maybe.
                print(json)
            }) { (err) in
                print("unable to save account in dynamodb")
                print(err)
            }
        }
        
        if let error = webView.url?.valueOf("error") {
            // Something went wrong, user didn't authenticate properly or maybe some other error.
            print("error")
            
        }
        
        
    }
}

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
