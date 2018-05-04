//
//  SignUp2ViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-03.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class SignUp2ViewController: UIViewController {

    @IBOutlet var emailAddressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.cyan
        // Do any additional setup after loading the view.
        
        setupBackground()
        setupNavigationBar()
        setupTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.setProgress(2/4, animated: true)
    }
    
    func setupBackground() {
        let backgroundImageView = UIImageView.init(frame: self.view.frame)
        backgroundImageView.image = #imageLiteral(resourceName: "background_black_blur")
        view.insertSubview(backgroundImageView, at: 0)
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
        emailAddressTextField.keyboardType = .default
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func nextButton(_ sender: UIButton) {
        let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
        let secondSignUpVC = mainSB.instantiateViewController(withIdentifier: "SignUp3ViewController")
        
        self.navigationController?.pushViewController(secondSignUpVC, animated: true)
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
