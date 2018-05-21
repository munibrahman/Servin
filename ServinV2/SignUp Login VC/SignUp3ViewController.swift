//
//  SignUp3ViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-03.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Macaw

class SignUp3ViewController: UIViewController {

    @IBOutlet var passwordTextField: UITextField!
        @IBOutlet var nextButtonSVGView: SVGView!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.green
        // Do any additional setup after loading the view.
        
        setupBackground()
        setupNavigationBar()
        setupTextField()
        
        nextButtonSVGView.backgroundColor = .clear
        nextButtonSVGView.isUserInteractionEnabled = true
        
        let nextScreenGesture = UITapGestureRecognizer.init(target: self, action: #selector(goForward))
        
        nextButtonSVGView.addGestureRecognizer(nextScreenGesture)
    }
    
    @objc func goForward () {
        self.navigationController?.finishProgress()
        
        self.present((storyboard?.instantiateViewController(withIdentifier: "SlaveMapViewController"))!, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setProgress(3/4, animated: true)
        
        // This allows the keyboard to popup automatically
        passwordTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.textColor = UIColor.white
        passwordTextField.borderStyle = .none
        passwordTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTextField.isSecureTextEntry = true
        passwordTextField.keyboardAppearance = .dark
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
