//
//  PayoutSetupViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-08-15.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit

class PayoutSetupViewController: UIViewController {
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        if self.navigationController == nil {
            fatalError("Must be presented inside a navigation controller")
        }
        
        setupNavigationBar()
        setupViews()
        
    }
    
    func setupNavigationBar() {
        let leftBarItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(userDidPressX))
        leftBarItem.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        //self.navigationController?.navigationBar.transparentNavigationBar()
    }
    
    @objc func userDidPressX() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        let topLabel = UILabel.init()
        view.addSubview(topLabel)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        topLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 16).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        
        topLabel.text = "Set up a new payout method"
        topLabel.font = UIFont.systemFont(ofSize: 34, weight: .regular)
        topLabel.textColor = UIColor.blackFontColor
        topLabel.numberOfLines = 2
        
        topLabel.sizeToFit()
        
        
        let descriptionLabel = UILabel.init()
        view.addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        
        
        descriptionLabel.text = "You will need a Stripe account to accept payments, you can either authorize your existing stripe account or create a new one"
        descriptionLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.9)
        descriptionLabel.font = UIFont.systemFont(ofSize: 21, weight: .regular)
        descriptionLabel.numberOfLines = 5
        
        descriptionLabel.sizeToFit()
        
        
        let continueButton = UIButton.init()
        view.addSubview(continueButton)
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        continueButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -30).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        continueButton.backgroundColor = UIColor.greyBackgroundColor
        
        continueButton.layer.cornerRadius = 30
        continueButton.clipsToBounds = true
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setImage(#imageLiteral(resourceName: ">_pink_background"), for: .normal)
        continueButton.semanticContentAttribute = .forceRightToLeft
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 21)
        continueButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 10)
        continueButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -10)
        
        continueButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(userDidTapContinue)))
    }
    
    @objc func userDidTapContinue() {
//        self.navigationController?.pushViewController(PayoutAddressViewController(), animated: true)
         self.navigationController?.pushViewController(StripeConnectWebViewController(), animated: true)
        
//        let stripeConnectWebVC = StripeConnectWebViewController()
//        self.present(UINavigationController.init(rootViewController: stripeConnectWebVC), animated: true, completion: nil)

    }
    
    
}


 class PayoutAddressViewController: UIViewController, UITextFieldDelegate, ScrollViewControllerDelegate {
    
    
    
    
    var addressField: UITextField!
    var aptField: UITextField!
    var cityField: UITextField!
    var provinceField: UITextField!
    var postalcodeField: UITextField!
    var countryField: UITextField!
    
    var selectedProvince: String!
    
    let provinces = ["Alberta", "British Columbia", "Manitoba", "New Brunswick", "Newfoundland and Labrador", "Nova Scotia", "Northwest Territories", "Nunavut", "Ontario", "Prince Edward Island", "Quebec", "Saskatchewan", "Yukon" ]
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupViews()
        
        selectedProvince = provinces.first
    }
    
    func setupNavigationBar() {
        let leftBarItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_white"), style: .plain, target: self, action: #selector(userDidPressBack))
        leftBarItem.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        
        let rightBarItem = UIBarButtonItem.init(title: "Next", style: .plain, target: self, action: #selector(userDidPressNext))
        rightBarItem.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = rightBarItem
        
    }
    
    @objc func userDidPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func userDidPressNext() {
        self.navigationController?.pushViewController(PayoutFullNameViewController(), animated: true)
    }
    
    
    let textFieldHeight:CGFloat = 50
    let textFieldFontSize: CGFloat = 21
    
    func setupViews() {
        
        let topLabel = UILabel.init()
        view.addSubview(topLabel)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        topLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 16).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        
        topLabel.text = "Enter the account address"
        topLabel.font = UIFont.systemFont(ofSize: 34, weight: .regular)
        topLabel.textColor = UIColor.blackFontColor
        topLabel.numberOfLines = 2
        
        topLabel.sizeToFit()
        
        
        addressField = UITextField.init()
        addressField.borderStyle = .none
        view.addSubview(addressField)
        
        addressField.translatesAutoresizingMaskIntoConstraints = false
        addressField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 20).isActive = true
        addressField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        addressField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        addressField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        addressField.placeholder = "Address"
        addressField.textColor = UIColor.gray
        addressField.font = UIFont.systemFont(ofSize: textFieldFontSize)
        addressField.delegate = self
        
        
        aptField = UITextField.init()
        aptField.borderStyle = .none
        view.addSubview(aptField)
        
        aptField.translatesAutoresizingMaskIntoConstraints = false
        aptField.topAnchor.constraint(equalTo: addressField.bottomAnchor).isActive = true
        aptField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        aptField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        aptField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        aptField.placeholder = "Apt, suite, etc"
        aptField.textColor = UIColor.gray
        aptField.font = UIFont.systemFont(ofSize: textFieldFontSize)
        aptField.delegate = self
        
        
        cityField = UITextField.init()
        cityField.borderStyle = .none
        view.addSubview(cityField)
        
        cityField.translatesAutoresizingMaskIntoConstraints = false
        cityField.topAnchor.constraint(equalTo: aptField.bottomAnchor).isActive = true
        cityField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        cityField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        cityField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        cityField.placeholder = "City"
        cityField.textColor = UIColor.gray
        cityField.font = UIFont.systemFont(ofSize: textFieldFontSize)
        cityField.delegate = self
        
        
        postalcodeField = UITextField.init()
        postalcodeField.borderStyle = .none
        view.addSubview(postalcodeField)
        
        postalcodeField.translatesAutoresizingMaskIntoConstraints = false
        postalcodeField.topAnchor.constraint(equalTo: cityField.bottomAnchor).isActive = true
        postalcodeField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        postalcodeField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        postalcodeField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        postalcodeField.placeholder = "Postal code"
        postalcodeField.textColor = UIColor.gray
        postalcodeField.font = UIFont.systemFont(ofSize: textFieldFontSize)
        postalcodeField.delegate = self
        
        
        provinceField = UITextField.init()
        provinceField.borderStyle = .none
        view.addSubview(provinceField)
        
        provinceField.translatesAutoresizingMaskIntoConstraints = false
        provinceField.topAnchor.constraint(equalTo: postalcodeField.bottomAnchor).isActive = true
        provinceField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        provinceField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        provinceField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        let editLabel = UILabel.init()
        provinceField.addSubview(editLabel)
        
        editLabel.translatesAutoresizingMaskIntoConstraints = false
        editLabel.textColor = UIColor.blackFontColor
        editLabel.trailingAnchor.constraint(equalTo: provinceField.trailingAnchor, constant: -10).isActive = true
        editLabel.centerYAnchor.constraint(equalTo: provinceField.centerYAnchor).isActive = true
        
        editLabel.text = "Edit"
        
        
        provinceField.text = provinces.first
        provinceField.textColor = UIColor.blackFontColor
        provinceField.font = UIFont.systemFont(ofSize: textFieldFontSize)
        provinceField.delegate = self
        
        countryField = UITextField.init()
        countryField.borderStyle = .none
        view.addSubview(countryField)
        
        countryField.translatesAutoresizingMaskIntoConstraints = false
        countryField.topAnchor.constraint(equalTo: provinceField.bottomAnchor).isActive = true
        countryField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        countryField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        countryField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        countryField.text = "Canada"
        countryField.textColor = UIColor.blackFontColor
        countryField.font = UIFont.systemFont(ofSize: textFieldFontSize)
        countryField.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addressField.addBottomBorderWithColor(color: UIColor.black.withAlphaComponent(0.4), width: 1)
        aptField.addBottomBorderWithColor(color: UIColor.black.withAlphaComponent(0.4), width: 1)
        cityField.addBottomBorderWithColor(color: UIColor.black.withAlphaComponent(0.4), width: 1)
        provinceField.addBottomBorderWithColor(color: UIColor.black.withAlphaComponent(0.4), width: 1)
        postalcodeField.addBottomBorderWithColor(color: UIColor.black.withAlphaComponent(0.4), width: 1)
        countryField.addBottomBorderWithColor(color: UIColor.black.withAlphaComponent(0.4), width: 1)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == provinceField {
            
            showProvinces()
            
            return false
        }
        
        if textField == countryField {
            return false
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("did begin")
        if textField.textColor == UIColor.gray {
            textField.textColor = UIColor.blackFontColor
            textField.text = nil
        }
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         print("did end")
        if textField.text == nil {
            
            textField.textColor = UIColor.gray
            
            if textField == addressField {
                textField.text = "Address"
            } else if textField == aptField {
                textField.text = "Apt, suite, etc"
            } else if textField == cityField {
                textField.text = "City"
            } else if textField == provinceField {
                textField.text = "Provice"
            } else if textField == postalcodeField {
                textField.text = "Postal Code"
            } else if textField == countryField {
                textField.text = "Country"
            }
            
        }
    }
    
    
    
    func showProvinces() {
        let proviceViewController = ScrollViewController()
        proviceViewController.data = provinces
        proviceViewController.delegate = self
        proviceViewController.selected = selectedProvince
        let navVC = UINavigationController.init(rootViewController: proviceViewController)
        
        self.navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    func userDidDismiss() {
        print("Dismissed the selection")
    }
    
    func userDidSelect(value: String) {
        print("Selected \(value)")
        self.provinceField.text = value
        self.provinceField.textColor = UIColor.blackFontColor
        selectedProvince = value
    }
    
    
}


protocol ScrollViewControllerDelegate {
    func userDidDismiss()
    func userDidSelect(value: String)
}

private class ScrollViewController: UITableViewController {
    
    var data: [String]!
    var delegate: ScrollViewControllerDelegate!
    var selected: String!
    
    override func loadView() {
        view = UIView()
        tableView = UITableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(LabelCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorColor = .white
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let leftBarItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(userDidPressX))
        leftBarItem.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    @objc func userDidPressX() {
        delegate.userDidDismiss()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LabelCell
        cell.label.text = data[indexPath.row]
        cell.selectionStyle = .none
        if data[indexPath.row] != selected {
            cell.label.textColor = UIColor.blackFontColor.withAlphaComponent(0.4)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.userDidSelect(value: data[indexPath.row])
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private class LabelCell: UITableViewCell {
        
        var label: UILabel!
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            self.contentView.backgroundColor = .clear
            
            label = UILabel.init()
            contentView.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
            
            label.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
            label.textColor = UIColor.blackFontColor
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}


private class PayoutFullNameViewController: UIViewController, UITextFieldDelegate {
    
    var firstNameField: UITextField!
    var lastNameField: UITextField!
    var bdayField: UITextField!
    var sinField: UITextField!
    
    var birthdatePicker: UIDatePicker!
    
    
    let textFieldHeight:CGFloat = 50
    let textFieldFontSize: CGFloat = 21
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupNavigationBar()
        setupViews()
        
    }
    
    func setupNavigationBar() {
        let leftBarItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_white"), style: .plain, target: self, action: #selector(userDidPressBack))
        leftBarItem.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        let rightBarItem = UIBarButtonItem.init(title: "Next", style: .plain, target: self, action: #selector(userDidPressNext))
        rightBarItem.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = rightBarItem
        
    }
    
    @objc func userDidPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func userDidPressNext() {
        print("go next")
        
        self.navigationController?.pushViewController(PayoutBankAccountInfoViewController(), animated: true)
        
    }
    
    
    func setupViews() {
        
        let topLabel = UILabel.init()
        view.addSubview(topLabel)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        topLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 16).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        
        topLabel.text = "Enter bank transfer information"
        topLabel.font = UIFont.systemFont(ofSize: 34, weight: .regular)
        topLabel.textColor = UIColor.blackFontColor
        topLabel.numberOfLines = 2
        
        topLabel.sizeToFit()
        
        
        firstNameField = UITextField.init()
        firstNameField.borderStyle = .none
        view.addSubview(firstNameField)
        
        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        firstNameField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 20).isActive = true
        firstNameField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        firstNameField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        firstNameField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        firstNameField.placeholder = "First name"
        firstNameField.textColor = UIColor.gray
        firstNameField.font = UIFont.systemFont(ofSize: textFieldFontSize)
        firstNameField.delegate = self
        
        
        lastNameField = UITextField.init()
        lastNameField.borderStyle = .none
        view.addSubview(lastNameField)
        
        lastNameField.translatesAutoresizingMaskIntoConstraints = false
        lastNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor).isActive = true
        lastNameField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        lastNameField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        lastNameField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        lastNameField.placeholder = "Last name"
        lastNameField.textColor = UIColor.gray
        lastNameField.font = UIFont.systemFont(ofSize: textFieldFontSize)
        lastNameField.delegate = self
        
        bdayField = UITextField.init()
        bdayField.borderStyle = .none
        view.addSubview(bdayField)
        
        bdayField.translatesAutoresizingMaskIntoConstraints = false
        bdayField.topAnchor.constraint(equalTo: lastNameField.bottomAnchor).isActive = true
        bdayField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        bdayField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        bdayField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        bdayField.placeholder = "Birthday"
        bdayField.textColor = UIColor.gray
        bdayField.font = UIFont.systemFont(ofSize: textFieldFontSize)
        bdayField.delegate = self
        
        
        sinField = UITextField.init()
        sinField.borderStyle = .none
        view.addSubview(sinField)
        sinField.keyboardType = .numberPad
        
        sinField.translatesAutoresizingMaskIntoConstraints = false
        sinField.topAnchor.constraint(equalTo: bdayField.bottomAnchor).isActive = true
        sinField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        sinField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        sinField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        sinField.placeholder = "Social Insurance Number"
        sinField.textColor = UIColor.gray
        sinField.font = UIFont.systemFont(ofSize: textFieldFontSize)
        sinField.delegate = self
        
        
        
        
        
        
        
        birthdatePicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 200))
        
        view.addSubview(birthdatePicker)
        
        birthdatePicker.timeZone = NSTimeZone.local
        birthdatePicker.datePickerMode = .date
        birthdatePicker.date = Date()
        
        birthdatePicker.maximumDate = Date()
        
        birthdatePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        birthdatePicker.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 200)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
        bdayField.text = selectedDate
        
        bdayField.textColor = UIColor.blackFontColor
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == bdayField {
            
            view.endEditing(true)
            animateBirthdayPicker(slideUp: true)
            return false
        }
        
        animateBirthdayPicker(slideUp: false)
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.textColor == UIColor.gray {
            textField.textColor = UIColor.blackFontColor
            textField.text = nil
        }
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text == nil {
            textField.textColor = UIColor.gray
            
            if textField == firstNameField {
                textField.text = "First name"
            } else if textField == lastNameField {
                textField.text = "Last name"
            } else if textField == sinField {
                textField.text = "Social Insurance Number"
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        firstNameField.addBottomBorderWithColor(color: UIColor.black.withAlphaComponent(0.4), width: 1)
        lastNameField.addBottomBorderWithColor(color: UIColor.black.withAlphaComponent(0.4), width: 1)
        bdayField.addBottomBorderWithColor(color: UIColor.black.withAlphaComponent(0.4), width: 1)
        sinField.addBottomBorderWithColor(color: UIColor.black.withAlphaComponent(0.4), width: 1)

    }
    
    func animateBirthdayPicker(slideUp: Bool) {
        
        if slideUp {
            UIView.animate(withDuration: 0.5) {
                self.birthdatePicker.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 200, width: self.view.frame.size.width, height: 200)
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.birthdatePicker.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 200)
            }
        }
        
    }
    
    
}

import Macaw


class PayoutBankAccountInfoViewController: UIViewController, UITextFieldDelegate {
    
    
    var chequeImageView: UIImageView!
    
    var chequeImageViewLeadingAnchor : NSLayoutConstraint?
    
    
    var transitField: UITextField!
    var instututionField: UITextField!
    var accountField: UITextField!
    
    
    let textFieldHeight:CGFloat = 50
    let textFieldFontSize: CGFloat = 21
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupViews()
    }
    
    func setupViews() {
        
        let topLabel = UILabel.init()
        view.addSubview(topLabel)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        topLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 16).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        
        topLabel.text = "Enter your banking info"
        topLabel.font = UIFont.systemFont(ofSize: 34, weight: .regular)
        topLabel.textColor = UIColor.blackFontColor
        topLabel.numberOfLines = 2
        
        topLabel.sizeToFit()
        
        let chequeLabel = UILabel()
        view.addSubview(chequeLabel)
        
        chequeLabel.translatesAutoresizingMaskIntoConstraints = false
        chequeLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 8).isActive = true
        chequeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        chequeLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        
        chequeLabel.text = "You can usually find this information on your bank cheque"
        chequeLabel.textColor = UIColor.blackFontColor
        chequeLabel.numberOfLines = 10
        chequeLabel.sizeToFit()
        
        chequeImageView = UIImageView()
        view.addSubview(chequeImageView)

        
        chequeImageView.translatesAutoresizingMaskIntoConstraints = false
        chequeImageViewLeadingAnchor =  chequeImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        chequeImageViewLeadingAnchor?.isActive = true
        chequeImageView.topAnchor.constraint(equalTo: chequeLabel.bottomAnchor, constant: 20).isActive = true
        chequeImageView.widthAnchor.constraint(equalToConstant: 651).isActive = true
        chequeImageView.heightAnchor.constraint(equalToConstant: 163).isActive = true
        
        chequeImageView.image = #imageLiteral(resourceName: "cheque_normal")
        
        
        
        transitField = UITextField.init()
        transitField.borderStyle = .none
        view.addSubview(transitField)
        
        transitField.translatesAutoresizingMaskIntoConstraints = false
        transitField.topAnchor.constraint(equalTo: chequeImageView.bottomAnchor, constant: 0).isActive = true
        transitField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        transitField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        transitField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        transitField.placeholder = "Transit number"
        transitField.textColor = UIColor.gray
        transitField.font = UIFont.systemFont(ofSize: textFieldFontSize)
        transitField.delegate = self
        
        
        instututionField = UITextField.init()
        instututionField.borderStyle = .none
        view.addSubview(instututionField)
        
        instututionField.translatesAutoresizingMaskIntoConstraints = false
        instututionField.topAnchor.constraint(equalTo: transitField.bottomAnchor).isActive = true
        instututionField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        instututionField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        instututionField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        instututionField.placeholder = "Institution number"
        instututionField.textColor = UIColor.gray
        instututionField.font = UIFont.systemFont(ofSize: textFieldFontSize)
        instututionField.delegate = self
        
        
        accountField = UITextField.init()
        accountField.borderStyle = .none
        view.addSubview(accountField)
        
        accountField.translatesAutoresizingMaskIntoConstraints = false
        accountField.topAnchor.constraint(equalTo: instututionField.bottomAnchor).isActive = true
        accountField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        accountField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        accountField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        accountField.placeholder = "Account Number"
        accountField.textColor = UIColor.gray
        accountField.font = UIFont.systemFont(ofSize: textFieldFontSize)
        accountField.delegate = self
    }
    
    func setupNavigationBar() {
        let leftBarItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_white"), style: .plain, target: self, action: #selector(userDidPressBack))
        leftBarItem.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        let rightBarItem = UIBarButtonItem.init(title: "Next", style: .plain, target: self, action: #selector(userDidPressNext))
        rightBarItem.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = rightBarItem
        
    }
    
    @objc func userDidPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func userDidPressNext() {
        print("go next")
        
        print("Routing Number \(transitField.text)\(instututionField.text)")
        print("Account Number \(accountField.text)")
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.textColor == UIColor.gray {
            textField.textColor = UIColor.blackFontColor
            textField.text = nil
        }
        
        if textField == transitField {
            
            chequeImageViewLeadingAnchor?.constant = 0
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.chequeImageView.image = #imageLiteral(resourceName: "transit_cheque")
                self.chequeImageView.superview?.layoutIfNeeded()
            })
            
        } else if textField == instututionField {
            
            chequeImageViewLeadingAnchor?.constant = -80
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.chequeImageView.image = #imageLiteral(resourceName: "institution_cheque")
                self.chequeImageView.superview?.layoutIfNeeded()
            })
            
            
        } else if textField == accountField {
            
            chequeImageViewLeadingAnchor?.constant = -200
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.chequeImageView.image = #imageLiteral(resourceName: "account_cheque")
                self.chequeImageView.superview?.layoutIfNeeded()
            })
            
        }
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text == nil {
            textField.textColor = UIColor.gray
            
            if textField == transitField {
                textField.text = "Transit Number"
            } else if textField == instututionField {
                textField.text = "Institution Number"
            } else if textField == accountField {
                textField.text = "Account Number"
            }
            
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        transitField.addBottomBorderWithColor(color: UIColor.black.withAlphaComponent(0.4), width: 1)
        instututionField.addBottomBorderWithColor(color: UIColor.black.withAlphaComponent(0.4), width: 1)
        accountField.addBottomBorderWithColor(color: UIColor.black.withAlphaComponent(0.4), width: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillAppear() {
        print("Keyboard will appear")
    }
    
    @objc func keyboardWillDisappear() {
        print("Keyboard will dissapear")
        
        self.chequeImageView.image = #imageLiteral(resourceName: "cheque_normal")
        
        if let anchor = chequeImageViewLeadingAnchor {
            if anchor.constant != 0 {
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.chequeImageViewLeadingAnchor?.constant = 0
                    self.chequeImageView.superview?.layoutIfNeeded()
                })
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}











