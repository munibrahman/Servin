//
//  MyDiscoveryViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-06-18.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class MyDiscoveryViewController: UserDiscoveryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.insertSubview(discoveryCollectionView, at: 100)

        // Do any additional setup after loading the view.
        
        self.imInterstedView.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Selected something inside ")
//    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        let backButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_grey"), style: .plain, target: self, action: #selector(self.userDidTapBack))
        
        
        
        let shareButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "share_icon"), style: .plain, target: self, action: #selector(self.userDidTapShare))
        
        let editButton = UIBarButtonItem.init(title: "Edit", style: .plain, target: self, action: #selector(self.userDidTapEdit))
        
        
        backButton.tintColor = .black
        shareButton.tintColor = .black
        editButton.tintColor = .black
        
        self.navigationItem.rightBarButtonItems = [editButton, shareButton]
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    @objc func userDidTapEdit() {
        print("Edit this ad, im inside mydiscoveryviewcontroller")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
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
