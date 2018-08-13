//
//  PaymentMethodsViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-08-13.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import Stripe

class PaymentMethodsViewController : STPAddCardViewController {
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .always
        self.title = "Add Payment"
        
        let backButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_white"), style: .plain, target: self, action: #selector(userDidTapBack))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func userDidTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
