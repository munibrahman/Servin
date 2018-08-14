//
//  TestViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-05.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import SideMenu
import AWSCognitoIdentityProvider

class TestViewController: UIViewController {
    
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        
        self.present(Constants.getMainContentVC(), animated: true, completion: nil)
        
//        self.present(UINavigationController.init(rootViewController: EditMapViewController()), animated: true, completion: nil)
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
