//
//  EditDiscoveryViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-06-19.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit


// TODO: Finish impleneting this VC after myPins have been completed.

class EditDiscoveryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.navigationController == nil {
            fatalError("EditDiscoveryViewController must be presented inside a UINavigationViewController")
        }
        
        setupNavigationBar()

        // Do any additional setup after loading the view.
        
        setupViews()
    }
    
    
    func setupViews() {
        if let editVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String.init(describing: SlavePostAdViewController.self)) as? SlavePostAdViewController {
            
//            editVC.titleTextField.text =
//
        }
    }
    
    func setupNavigationBar() {
        
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        let backButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_grey"), style: .plain, target: self, action: #selector(userDidTapBack))
    }
    
    
    @objc func userDidTapBack () {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
