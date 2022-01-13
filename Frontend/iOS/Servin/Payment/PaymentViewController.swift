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
import SwiftyJSON

class PaymentViewController: UITableViewController {
    
    
    var paymentMethods: [JSON] = []
    var payoutMethods: [JSON] = []
    let paymentMethodIcon = [STPApplePayPaymentOption().image, STPPaymentCardTextField.brandImage(for: .visa), STPPaymentCardTextField.brandImage(for: STPCardBrand.masterCard)]
    
    let paymentReuseIdentifier = "PaymentCell"
    let addPaymentReuseIdentifier = "AddPaymentCell"
    
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
        
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.title = "Payment"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.tableView.register(PaymentMethodTableViewCell.self, forCellReuseIdentifier: paymentReuseIdentifier)
        self.tableView.register(AddPaymentTableViewCell.self, forCellReuseIdentifier: addPaymentReuseIdentifier)
        
        fetchPaymentMethods()
        fetchPayoutMethods()
        
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
    
    // MARK:- API Related calls TODO: Move them to a stripe helper class.
    private func fetchPaymentMethods() {
        
        VolticStripeHelper.shared.listPaymentMethods(input: ListPaymentMethodsInput.init(type: PaymentMethodTypes.card), onSuccess: { (json) in
            self.paymentMethods = json["data"].arrayValue
//            print(self.paymentMethods)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            self.showErrorNotification(title: "Error", subtitle: "We can't retrive your payment methods, please try again.")
        }
        
    }
    
    private func fetchPayoutMethods() {
        VolticStripeHelper.shared.listExternalAccounts(type: ExternalAccountType.bankAccount, limit: nil, ending_before: nil, starting_after: nil, onSuccess: { (json) in
            self.payoutMethods = json["data"].arrayValue
            print(self.payoutMethods)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
            self.showErrorNotification(title: "Error", subtitle: "We can't retrive your bank accounts, please try again.")
        }
    }
    
    func handleAddPaymentOptionButtonTapped() {
        // Setup add card view controller
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        
        // Present add card view controller
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
    }
    
    
    private class PaymentMethodTableViewCell: UITableViewCell {
        
        var checkMarkImageView: UIImageView = {
            let imageView = UIImageView.init(image: #imageLiteral(resourceName: "check_icon"), highlightedImage: #imageLiteral(resourceName: "check_icon_highlighted"))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        
        var paymentImageView: UIImageView!
        var paymentLabel: UILabel!
        
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            
            self.accessoryType = .none
            
            
            self.contentView.addSubview(checkMarkImageView)
            checkMarkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            checkMarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            checkMarkImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            checkMarkImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            checkMarkImageView.isHighlighted = false
            
            
            paymentImageView = UIImageView()
            self.contentView.addSubview(paymentImageView)
            
            paymentImageView.translatesAutoresizingMaskIntoConstraints = false
            paymentImageView.leadingAnchor.constraint(equalTo: checkMarkImageView.trailingAnchor, constant: 10).isActive = true
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
        
        
        var addImageView: UIImageView = {
            let imageView = UIImageView.init(image: #imageLiteral(resourceName: "add_icon"), highlightedImage: #imageLiteral(resourceName: "add_icon"))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        
        
        var paymentLabel: UILabel!
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            
            self.accessoryType = .none
            
            
            self.contentView.addSubview(addImageView)
            
            addImageView.translatesAutoresizingMaskIntoConstraints = false
            addImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            addImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
            addImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
            addImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            addImageView.contentMode = .scaleAspectFill
            addImageView.layer.cornerRadius = 3.0
            addImageView.clipsToBounds = true
            
            addImageView.backgroundColor = .clear
            
            
            paymentLabel = UILabel()
            self.contentView.addSubview(paymentLabel)
            
            paymentLabel.translatesAutoresizingMaskIntoConstraints = false
            paymentLabel.leadingAnchor.constraint(equalTo: addImageView.trailingAnchor, constant: 10).isActive = true
            paymentLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
            
            paymentLabel.textColor = UIColor.blackFontColor
            paymentLabel.font = UIFont.systemFont(ofSize: 17)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}

extension PaymentViewController {
    
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
                let cell = tableView.dequeueReusableCell(withIdentifier: addPaymentReuseIdentifier, for: indexPath) as! AddPaymentTableViewCell
                cell.paymentLabel.text = "Add Payment Method"
                
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: paymentReuseIdentifier, for: indexPath) as! PaymentMethodTableViewCell
            cell.paymentLabel.text = "**** " + paymentMethods[indexPath.row]["card"]["last4"].stringValue
//            cell.paymentLabel.text = paymentMethods[indexPath.row]
            
            let brand = STPCard.brand(from: paymentMethods[indexPath.row]["card"]["brand"].stringValue)
            cell.paymentImageView.image =  STPPaymentCardTextField.brandImage(for: brand)
            
            return cell
            
        }
        
        if indexPath.section == 1 {
            
            if indexPath.row == payoutMethods.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: addPaymentReuseIdentifier, for: indexPath) as! AddPaymentTableViewCell
                cell.paymentLabel.text = "Add Bank Account"
                
                return cell
            }
            
            print(indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: paymentReuseIdentifier, for: indexPath) as! PaymentMethodTableViewCell
            cell.paymentLabel.text = payoutMethods[indexPath.row]["bank_name"].stringValue
            cell.paymentImageView.image =  #imageLiteral(resourceName: "bank_icon")
            cell.paymentImageView.contentMode = .scaleAspectFit
            
            return cell
            
            
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Payment Methods
        if indexPath.section == 0 {
            if indexPath.row == paymentMethods.count {

                handleAddPaymentOptionButtonTapped()
                
            } else {
                
                // TODO: Make it a default payment method
                print("DID tap on card")
                
                let cardInfo = paymentMethods[indexPath.row]
                
//                let vc = PaymentDetailViewController.ViewControllerFor(card: cardInfo)
                
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        // Payout Methods
        if indexPath.section == 1 {
            
            print(indexPath.row)
            
            
            if indexPath.row == payoutMethods.count {

                // Add Bank account tapped
                // If/When you decide to go with stripe custom or express, you can use PayoutSetupViewController
                let payoutSetupVC = PayoutSetupViewController()
                let navVc = UINavigationController.init(rootViewController: payoutSetupVC)

                self.present(navVc, animated: true, completion: nil)
            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 0 && indexPath.row == paymentMethods.count {
            // Add payment cell
            return false
        }
        
        if indexPath.section == 1 {
            // Description cell and the add payout cell
            if indexPath.row == 0 || indexPath.row == payoutMethods.count + 1 {
                return false
            }
            
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            if indexPath.section == 0 {
                // remove payment method (like a card)
            }
        }
    }
}

extension PaymentViewController: STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        print("Did create token")
        print(token)
        
        
        VolticStripeHelper.shared.attachPaymentMethod(token: token.tokenId, onSuccess: {
            DispatchQueue.main.async {
                completion(nil)
                self.dismiss(animated: true)
            }
        }) { (error) in
            
            DispatchQueue.main.async {
                self.showErrorNotification(title: "Error", subtitle: "Unable to add your card, please try again.")
                completion(error)
            }
        }
//        submitPaymentMethodToBackend(paymentMethod, completion: { (error: Error?) in
//            if let error = error {
//                // Show error in add card view controller
//                completion(error)
//            }
//            else {
//                // Notify add card view controller that PaymentMethod creation was handled successfully
//                completion(nil)
//
//                // Dismiss add card view controller
//                dismiss(animated: true)
//            }
//        })
    }

}
