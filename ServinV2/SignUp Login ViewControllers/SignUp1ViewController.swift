//
//  SignUp1ViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-03.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import KYNavigationProgress
import Macaw

class SignUp1ViewController: UIViewController {

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    @IBOutlet var nextButtonSVGView: SVGView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setupBackground()
        setupNavigationBar()
        setupTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set progress with animation.
        self.navigationController?.progressTintColor = UIColor.navigationProgressColor
        self.navigationController?.setProgress(1/4, animated: true)
        self.navigationController?.progressHeight = 3.0
        
        // This allows the keyboard to popup automatically
        firstNameTextField.becomeFirstResponder()
        
        nextButtonSVGView.backgroundColor = .clear
        nextButtonSVGView.isUserInteractionEnabled = true
        
        let nextScreenGesture = UITapGestureRecognizer.init(target: self, action: #selector(goForward))
        
        nextButtonSVGView.addGestureRecognizer(nextScreenGesture)
    }

    @objc func goForward () {
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        let secondSignUpVC = mainSB.instantiateViewController(withIdentifier: "SignUp2ViewController")
        
        self.navigationController?.pushViewController(secondSignUpVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBackground() {
        self.view.backgroundColor = UIColor.greyBackgroundColor
    }
    
    func setupNavigationBar() {
        
        
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
        
        
    }
    
    func setupTextFields() {
        firstNameTextField.backgroundColor = UIColor.clear
        firstNameTextField.textColor = UIColor.white
        firstNameTextField.borderStyle = .none
        firstNameTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        firstNameTextField.keyboardAppearance = .dark
        firstNameTextField.keyboardType = .default
        
        lastNameTextField.backgroundColor = UIColor.clear
        lastNameTextField.textColor = UIColor.white
        lastNameTextField.borderStyle = .none
        lastNameTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        lastNameTextField.keyboardAppearance = .dark
        lastNameTextField.keyboardType = .default
    }
    
    @objc func barButtonPressed() {
        print("bar button pressed")
        self.dismiss(animated: true, completion: nil)
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
