//
//  SavedPinsViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-06-25.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class SavedPinsViewController: UIViewController {

    
    @IBOutlet var savedPinsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupNavigationController()

        savedPinsTableView.delegate = self
        savedPinsTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupNavigationController() {
        
        navigationItem.title = "Saved Pins"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.tintColor = UIColor.black
        
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc func barButtonPressed() {
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


extension SavedPinsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
        
    }
    
    
}
























