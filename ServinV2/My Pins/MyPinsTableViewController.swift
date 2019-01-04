//
//  MyPinsTableViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-05.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//
import UIKit
import DZNEmptyDataSet
import AlamofireImage
import Alamofire

class MyPinsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    
    @IBOutlet var myPinsTableView: UITableView!
    
    let reuseIdentifier = "cell"
    
    var myPins: [Discovery?]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavigationController()
        setupEmptyState()
        
        myPinsTableView.register(UINib.init(nibName: String.init(describing: MyPinTableViewCell.self), bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        myPinsTableView.delegate = self
        myPinsTableView.dataSource = self
        myPinsTableView.rowHeight = 104.0
        self.view.backgroundColor = UIColor.emptyStateBackgroundColor
        
        ServinData.init()
        
        myPins = ServinData.me._pinsOnMap
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.tintColor = UIColor.black
        
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
        
        navigationController?.navigationBar.topItem?.title = "My Pins"
        
    }
    
    @objc func barButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- DZNEmptyState
    func setupEmptyState() {
        myPinsTableView.emptyDataSetSource = self
        myPinsTableView.emptyDataSetDelegate = self
        
        myPinsTableView.tableFooterView = UIView()
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "thumbtack_icon")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        return NSAttributedString.init(string: "No Pins")
        
    }
    
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.init(string: "You currently don't have any pins on the map.")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        return NSAttributedString.init(string: "Drop a pin")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.emptyStateBackgroundColor
    }
    // MARK:- Tableview protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Add proper cells
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MyPinTableViewCell
        
        
        Alamofire.request("https://picsum.photos/500/300/?random").responseImage { response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                
                cell.pinImageView.image = image
            }
        }
        
        
        cell.titleLabel.text = myPins[indexPath.row]?._title
        cell.priceLabel.text = "$ \(myPins[indexPath.row]?._price ?? 0) "
        cell.viewsLabel.text = "\(myPins[indexPath.row]?._views ?? 0)"
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(MyDiscoveryViewController(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.removeTransparentNavigationBar()
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
