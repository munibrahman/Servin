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
import AWSAppSync
import SwiftyJSON

class MyPinsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    
    @IBOutlet var myPinsTableView: UITableView!
    
    var discoveries: [GetMyDiscoveriesQuery.Data.GetMyDiscovery?]?
    
    let reuseIdentifier = "cell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavigationController()
        setupEmptyState()
        
        myPinsTableView.register(MyPinTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        myPinsTableView.delegate = self
        myPinsTableView.dataSource = self
        myPinsTableView.rowHeight = 104.0
        self.view.backgroundColor = UIColor.emptyStateBackgroundColor
        
        fetchDataFromAPI()
        
    }
    
    func fetchDataFromAPI() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let myDiscoveriesQuery = GetMyDiscoveriesQuery.init()
            
            appSyncClient?.fetch(query: myDiscoveriesQuery, cachePolicy: CachePolicy.returnCacheDataAndFetch, resultHandler: { (result, error) in
                if let error = error, let errors = result?.errors {
                    print(errors)
                    print(error)
                    self.showErrorNotification(title: "Error", subtitle: "Can't get discoveries, please try again")
                    
                    
                }
                
                if let discoveries = result?.data?.getMyDiscoveries {
                    self.discoveries = discoveries
                    
                    DispatchQueue.main.async {
                        self.myPinsTableView.reloadData()
                    }
                    
                    print("My Discovieries")
//                    print(discoveries)
                    
                    
                }
            })
            
            
         
            
        }
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
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        return NSAttributedString.init(string: "Drop a pin")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.emptyStateBackgroundColor
    }
    // MARK:- Tableview protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Add proper cells
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MyPinTableViewCell
        
        // TODO: Get actual image of the discovery, not random images from internet.
//        Alamofire.request("https://picsum.photos/500/300/?random").responseImage { response in
////            debugPrint(response)
////
////            print(response.request)
////            print(response.response)
////            debugPrint(response.result)
//
//            if let image = response.result.value {
////                print("image downloaded: \(image)")
//
//                cell.pinImageView.image = image
//            }
//        }
        
        if let discoveries = discoveries, let discovery = discoveries[indexPath.item] {
            cell.titleLabel.text = discovery.title
            cell.priceLabel.text = "$ \(discovery.price ?? 0) "
            // TODO: Get the number of views
            cell.viewsLabel.text = "\(0)"
            
            if let image_0 = discovery.image_0, let data = image_0.data(using: .utf8, allowLossyConversion: false) {
                do {
                    let json = try JSON.init(data: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print("JSON DATA \(json)")
                                        print(json["ICON"].stringValue)
                    cell.pinImageView.loadImageUsingS3Key(key: json["MED"].stringValue)
                    
                } catch {
                    print("Error \(error)")
                }
            }
            
            
        }
        
        
        
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
        // TODO: Pass this discovery into the next screen
        
        
        
        if let discoveries = discoveries, let discovery = discoveries[indexPath.item] {
            
            let myDiscoveryVC = MyDiscoveryViewController()
            myDiscoveryVC.discovery = discovery
            self.navigationController?.pushViewController(myDiscoveryVC, animated: true)
        }
        
        
        
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
