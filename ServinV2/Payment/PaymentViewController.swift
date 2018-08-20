//
//  PaymentViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-08-19.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit
import Stripe

class PaymentViewController: UITableViewController {
    
    
    let paymentMethods = ["Apple Pay", "**** 2575", "**** 4323"]
    let paymentMethodIcon = [STPApplePayPaymentMethod().image, STPPaymentCardTextField.brandImage(for: .visa), STPPaymentCardTextField.brandImage(for: STPCardBrand.masterCard)]
    let payoutMethods = ["Royal Bank of Canada", "TD Bank", "Scotiabank"]
    
    let paymentReuseIdentifier = "PaymentCell"
    let addPaymentReuseIdentifier = "AddPaymentCell"
    
    override func loadView() {
        view = UIView()
        tableView = UITableView.init(frame: self.view.bounds, style: .grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        
        
        setupNavigationBar()
        
        self.tableView.register(PaymentMethodTableViewCell.self, forCellReuseIdentifier: paymentReuseIdentifier)
        self.tableView.register(AddPaymentTableViewCell.self, forCellReuseIdentifier: addPaymentReuseIdentifier)
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
        
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.title = "Payment"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        
    }
    
    @objc func userDidTapX() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func userDidTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Payment methods
        if section == 0 {
            return paymentMethods.count + 1
        }
        
            // Payout methods
        else if section == 1 {
            return payoutMethods.count + 1
        }
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 65
    }
    
    
    // Row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Payment Methods"
        }
        
        if section == 1 {
            return "Accept payments"
            
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            
            if indexPath.row == paymentMethods.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: addPaymentReuseIdentifier, for: indexPath) as! AddPaymentTableViewCell
                cell.addPaymentLabel.text = "Add Payment Method"
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: paymentReuseIdentifier, for: indexPath) as! PaymentMethodTableViewCell
            cell.paymentLabel.text = paymentMethods[indexPath.row]
            cell.paymentImageView.image = paymentMethodIcon[indexPath.row]
            
            return cell
            
        }
        
        if indexPath.section == 1 {
            
            if indexPath.row == payoutMethods.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: addPaymentReuseIdentifier, for: indexPath) as! AddPaymentTableViewCell
                cell.addPaymentLabel.text = "Add Payout Method"
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: paymentReuseIdentifier, for: indexPath) as! PaymentMethodTableViewCell
            cell.paymentLabel.text = payoutMethods[indexPath.row]
            cell.paymentImageView.image = #imageLiteral(resourceName: "bank_icon")
            cell.paymentImageView.contentMode = .scaleAspectFit
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Payment Methods
        if indexPath.section == 0 {
            if indexPath.row == paymentMethods.count {
                
                let config = STPPaymentConfiguration()
                config.additionalPaymentMethods = .all
                config.requiredBillingAddressFields = .none
                config.appleMerchantIdentifier = "merchant.com.servin"
                
                let theme = STPTheme.init()
                theme.primaryBackgroundColor = .white
                theme.accentColor = UIColor.blackFontColor
                
                let customerContext = MockCustomerContext()
                
                let viewController = STPPaymentMethodsViewController(configuration: config,
                                                                     theme: theme,
                                                                     customerContext: customerContext,
                                                                     delegate: self)
                
                viewController.paymentMethodsViewControllerFooterView.backgroundColor = .red
                
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.navigationBar.stp_theme = theme
                present(navigationController, animated: true, completion: nil)
                
                
            }
        }
        
        // Payout Methods
        if indexPath.section == 1 {
            
            if indexPath.row == payoutMethods.count {
                let payoutSetupVC = PayoutSetupViewController()
                let navVc = UINavigationController.init(rootViewController: payoutSetupVC)
                
                self.present(navVc, animated: true, completion: nil)
            }
        }
        
    }
    
    
    private class PaymentMethodTableViewCell: UITableViewCell {
        
        
        var paymentImageView: UIImageView!
        var paymentLabel: UILabel!
        
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            
            self.accessoryType = .disclosureIndicator
            
            paymentImageView = UIImageView()
            self.contentView.addSubview(paymentImageView)
            
            paymentImageView.translatesAutoresizingMaskIntoConstraints = false
            paymentImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
            paymentImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
            paymentImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            paymentImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            paymentImageView.contentMode = .scaleAspectFill
            paymentImageView.layer.cornerRadius = 3.0
            paymentImageView.clipsToBounds = true
            
            paymentImageView.backgroundColor = .clear
            
            
            paymentLabel = UILabel()
            self.contentView.addSubview(paymentLabel)
            
            paymentLabel.translatesAutoresizingMaskIntoConstraints = false
            paymentLabel.leadingAnchor.constraint(equalTo: paymentImageView.trailingAnchor, constant: 10).isActive = true
            paymentLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
            
            paymentLabel.textColor = UIColor.blackFontColor
            paymentLabel.font = UIFont.systemFont(ofSize: 17)
            
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    private class AddPaymentTableViewCell: UITableViewCell {
        
        var addPaymentLabel: UILabel!
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            
            addPaymentLabel = UILabel.init()
            self.contentView.addSubview(addPaymentLabel)
            
            addPaymentLabel.translatesAutoresizingMaskIntoConstraints = false
            addPaymentLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
            addPaymentLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
            
            
            addPaymentLabel.textColor = UIColor.blackFontColor
            addPaymentLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}

extension PaymentViewController: STPPaymentMethodsViewControllerDelegate {
    // MARK: STPPaymentMethodsViewControllerDelegate
    
    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        paymentMethodsViewController.navigationController?.popViewController(animated: true)
    }
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }
}


class PaymentDetailViewController: UIViewController {
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
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
        
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.title = "Payment"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        
    }
    
    @objc func userDidTapX() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func userDidTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}















//private class AddPayment: STPPaymentMethodsViewController {
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        self.
//    }
//
//}
























