//
//  SignUp2ViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-03.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Macaw

class SignUp2ViewController: UIViewController {

    @IBOutlet var emailAddressTextField: UITextField!
    @IBOutlet var askForNotifLabel: UILabel!
    
    @IBOutlet var nextButtonSVGView: SVGView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.cyan
        // Do any additional setup after loading the view.
        
        setupBackground()
        setupNavigationBar()
        setupTextField()
        setupNotificationLabel()
        
        nextButtonSVGView.backgroundColor = .clear
        nextButtonSVGView.isUserInteractionEnabled = true
        
        let nextScreenGesture = UITapGestureRecognizer.init(target: self, action: #selector(goForward))
        
        nextButtonSVGView.addGestureRecognizer(nextScreenGesture)
    }
    
    @objc func goForward () {
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        let secondSignUpVC = mainSB.instantiateViewController(withIdentifier: "SignUp3ViewController")
        
        self.navigationController?.pushViewController(secondSignUpVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setProgress(2/4, animated: true)
        
        // This allows the keyboard to popup automatically
        emailAddressTextField.becomeFirstResponder()
    }
    
    
    func setupBackground() {
        self.view.backgroundColor = UIColor.greyBackgroundColor
    }

    func setupNavigationBar() {
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    
    @objc func barButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func setupTextField() {
        emailAddressTextField.backgroundColor = UIColor.clear
        emailAddressTextField.textColor = UIColor.white
        emailAddressTextField.borderStyle = .none
        emailAddressTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        emailAddressTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        emailAddressTextField.keyboardAppearance = .dark
        emailAddressTextField.keyboardType = .emailAddress
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This label shows the text for users to click upon and sign up for finding out when servin will be launched globally.
    func setupNotificationLabel () {
        askForNotifLabel.text = "Click here to be notified when we will be open to the world!"
        let text = (askForNotifLabel.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let clickRange = (text as NSString).range(of: "Click here")
        
        underlineAttriString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 14.0), range: clickRange)
        
        
        askForNotifLabel.attributedText = underlineAttriString
        
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (askForNotifLabel.text)!
        let click = (text as NSString).range(of: "Click")
        
        if gesture.didTapAttributedTextInLabel(label: askForNotifLabel, inRange: click) {
            print("Tapped Click")
        } else {
            print("Tapped none")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
