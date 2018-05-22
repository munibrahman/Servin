//
//  LoginViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-18.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Macaw
import Pulley

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
       @IBOutlet var nextButtonSVGView: SVGView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBackground()
        setupNavigationBar()
        // Do any additional setup after loading the view.
        
        nextButtonSVGView.backgroundColor = .clear
        nextButtonSVGView.isUserInteractionEnabled = true
        
        let nextScreenGesture = UITapGestureRecognizer.init(target: self, action: #selector(goForward))
        
        nextButtonSVGView.addGestureRecognizer(nextScreenGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        //        signInButton.layer.cornerRadius = signInButton.frame.height / 2
        //        signInButton.layer.borderWidth = 1.0
        //        signInButton.clipsToBounds = true
        //
                emailTextField.backgroundColor = UIColor.clear
                emailTextField.textColor = UIColor.white
                emailTextField.borderStyle = .none
                emailTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
                emailTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                emailTextField.keyboardAppearance = .dark
                emailTextField.keyboardType = .emailAddress
        
        
                passwordTextField.backgroundColor = UIColor.clear
                passwordTextField.textColor = UIColor.white
                passwordTextField.borderStyle = .none
                passwordTextField.addBottomBorderWithColor(color: UIColor.white, width: 1.0)
                passwordTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                passwordTextField.isSecureTextEntry = true
                passwordTextField.keyboardAppearance = .dark
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
    
    @objc func barButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func goForward() {
        
        let mainContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SlaveMapViewController")
        
        let drawerContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SlaveDiscoveriesViewController")
        
        let pulleyController = MasterPulleyViewController(contentViewController: mainContentVC, drawerViewController: drawerContentVC)
        
        self.present(pulleyController, animated: true, completion: nil)
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
