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
        
        
        let legalEntity = STPLegalEntityParams.init()
        
        let address = STPAddress.init()
        address.city = "Calgary"
        address.line1 = "3827 Whitehorn Drive NE"
        address.postalCode = "T1Y 1V1"
        address.state = "AB"
        
        var dob = DateComponents.init()
        dob.day = 12
        dob.month = 03
        dob.year = 1995
        
        
        legalEntity.dateOfBirth = dob
        
        legalEntity.firstName = "Munib"
        legalEntity.lastName = "Rahman"
        
        legalEntity.personalIdNumber = "667082036"
        legalEntity.entityTypeString = "individual"
        
        let user = STPConnectAccountParams.init(tosShownAndAccepted: true, legalEntity: legalEntity)
        
        
        STPAPIClient.shared().createToken(withConnectAccount: user) { (token: STPToken?, error: Error?) in
            
            guard let token = token, error == nil else {
                print(error)
                
                return
            }
            
            //TODO: Submit token to backend
            
            print(token.allResponseFields)
        }
        
        
        
        
    }
    
    
    
//    func handlePaymentMethodsButtonTapped() {
//        // Setup customer context
//        
//        STPEphemeralKeyProvider.
//        
//        let customerContext = STPCustomerContext.init(keyProvider: <#T##STPEphemeralKeyProvider#>)
//        
//        // Setup payment methods view controller
//        let paymentMethodsViewController = STPPaymentMethodsViewController(configuration: STPPaymentConfiguration.shared(), theme: STPTheme.default(), customerContext: customerContext, delegate: self)
//        
//        // Present payment methods view controller
//        let navigationController = UINavigationController(rootViewController: paymentMethodsViewController)
//        present(navigationController, animated: true)
//    }
//    
//    // MARK: STPPaymentMethodsViewControllerDelegate
//    
//    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
//        // Dismiss payment methods view controller
//        dismiss(animated: true)
//        
//        // Present error to user...
//    }
//    
//    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
//        // Dismiss payment methods view controller
//        dismiss(animated: true)
//    }
//    
//    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
//        // Dismiss payment methods view controller
//        dismiss(animated: true)
//    }
//    
//    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didSelect paymentMethod: STPPaymentMethod) {
//        // Save selected payment method
//        selectedPaymentMethod = paymentMethod
//    }
    
    @objc func userDidTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
