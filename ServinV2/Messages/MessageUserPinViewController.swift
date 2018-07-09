//
//  MessageUserPinViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-07-04.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class MessageUserPinViewController: UserDiscoveryViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imInterstedView.removeFromSuperview()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        let leftButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_grey"), style: .plain, target: self, action: #selector(userDidTapBack))
        
        self.navigationItem.leftBarButtonItem = leftButtonItem
    }
    
    override func userDidTapBack() {
        self.navigationController?.popViewController(animated: true)
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
