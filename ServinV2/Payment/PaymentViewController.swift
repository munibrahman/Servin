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
    let paymentMethodIcon = [STPApplePayPaymentOption().image, STPPaymentCardTextField.brandImage(for: .visa), STPPaymentCardTextField.brandImage(for: STPCardBrand.masterCard)]
    let payoutInfo = "Add your stripe account to recieve payments automatically"
    
    let paymentReuseIdentifier = "PaymentCell"
    let addPaymentReuseIdentifier = "AddPaymentCell"
    let stripeInfoReuseIdentifier = "StripeInfoCell"
    
    let sectionHeaderHeight: CGFloat = 75
    
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
        self.tableView.register(StripeConnectTableViewCell.self, forCellReuseIdentifier: stripeInfoReuseIdentifier)
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
            return 2
        }
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 65
    }
    
    
    // Row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: sectionHeaderHeight))
        
        let label = UILabel.init()
        
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4).isActive = true
        
        label.textColor = UIColor.blackFontColor
        label.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        
        if section == 0 {
            label.text =  "Payment Methods"
        }
        
        if section == 1 {
            label.text = "Accept payments"
        }
        
        view.addSubview(label)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            
            if indexPath.row == paymentMethods.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: paymentReuseIdentifier, for: indexPath) as! PaymentMethodTableViewCell
                cell.paymentLabel.text = "Add Payment Method"
                cell.paymentImageView.image = #imageLiteral(resourceName: "add_icon")
                cell.paymentImageView.contentMode = .scaleAspectFit
                
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: paymentReuseIdentifier, for: indexPath) as! PaymentMethodTableViewCell
            cell.paymentLabel.text = paymentMethods[indexPath.row]
            cell.paymentImageView.image = paymentMethodIcon[indexPath.row]
            
            return cell
            
        }
        
        if indexPath.section == 1 {
            
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: paymentReuseIdentifier, for: indexPath) as! PaymentMethodTableViewCell
                cell.paymentLabel.text = "Connect With Stripe"
                cell.paymentImageView.image = #imageLiteral(resourceName: "add_icon")
                cell.paymentImageView.contentMode = .scaleAspectFit
                
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: stripeInfoReuseIdentifier, for: indexPath) as! StripeConnectTableViewCell
            cell.infoLabel.text = "Connect your stripe account to recieve funds today."
            
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Payment Methods
        if indexPath.section == 0 {
            if indexPath.row == paymentMethods.count {
                
                let config = STPPaymentConfiguration()
                config.additionalPaymentOptions = .all
                config.requiredBillingAddressFields = .none
                config.appleMerchantIdentifier = "merchant.com.servin"
                
                let theme = STPTheme.init()
                theme.primaryBackgroundColor = .white
                theme.accentColor = UIColor.blackFontColor
                
                let customerContext = STPCustomerContext(keyProvider: MyStripeAPIClient.sharedClient)
                
                let viewController = STPPaymentOptionsViewController(configuration: config,
                                                                     theme: theme,
                                                                     customerContext: customerContext,
                                                                     delegate: self)
                
                viewController.paymentOptionsViewControllerFooterView.backgroundColor = .red
                
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.navigationBar.stp_theme = theme
                present(navigationController, animated: true, completion: nil)
                
                
            }
        }
        
        // Payout Methods
        if indexPath.section == 1 {
            
            if indexPath.row == 1 {
                // If/When you decide to go with stripe custom or express, you can use PayoutSetupViewController
                let payoutSetupVC = PayoutSetupViewController()
                let navVc = UINavigationController.init(rootViewController: payoutSetupVC)

                self.present(navVc, animated: true, completion: nil)
            }
        }
        
    }
    
    
    private class PaymentMethodTableViewCell: UITableViewCell {
        
        
        var paymentImageView: UIImageView!
        var paymentLabel: UILabel!
        
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
    
    private class StripeConnectTableViewCell: UITableViewCell {
        var infoLabel: UILabel!
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            
            infoLabel = UILabel.init()
            self.contentView.addSubview(infoLabel)
            
            infoLabel.translatesAutoresizingMaskIntoConstraints = false
            infoLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
            infoLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
            
            
            infoLabel.textColor = UIColor.blackFontColor
            infoLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}

extension PaymentViewController: STPPaymentOptionsViewControllerDelegate {
    // MARK: STPPaymentMethodsViewControllerDelegate
    func paymentOptionsViewController(_ paymentOptionsViewController: STPPaymentOptionsViewController, didFailToLoadWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }
    
    func paymentOptionsViewControllerDidFinish(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
        paymentOptionsViewController.navigationController?.popViewController(animated: true)
    }
    
    func paymentOptionsViewControllerDidCancel(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
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



























