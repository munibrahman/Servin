//
//  MessageViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-05.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Alamofire

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    
    let cellIdentifier = "cell"

    @IBOutlet var messagesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationController()
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        

        self.view.backgroundColor = UIColor.emptyStateBackgroundColor
        
        
        messagesTableView.register(UINib.init(nibName: String.init(describing: MessageTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        //setupEmptyState()
    }
    
    
    
    func setupNavigationController() {
        
        if self.navigationController == nil {
            fatalError("MessageViewController must be presented inside a UINavigationController")
        }
        
        navigationController?.navigationBar.tintColor = UIColor.black
        
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
        
        navigationController?.navigationBar.topItem?.title = "Messages"
    }
    
    @objc func barButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- DZNEmptyState
    func setupEmptyState() {
        messagesTableView.emptyDataSetSource = self
        messagesTableView.emptyDataSetDelegate = self
        
        messagesTableView.tableFooterView = UIView()
        
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "inbox_empty")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = NSString.init(string: "No Messages")
        
        return NSAttributedString.init(string: "No Messages")
        
    }
    
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString.init(string: "Start making money by creating a discovery")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        return NSAttributedString.init(string: "Post")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.emptyStateBackgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! MessageTableViewCell
        
        
        Alamofire.request("https://picsum.photos/500/300/?random").responseImage { response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                
                messageCell.contentImageView.image = image
            }
        }
        
        
        messageCell.titleLabel.text = "Soccer coach for hire"
        messageCell.detailLabel.text = "You: That seems good to me, see you soon!"
        messageCell.priceLabel.text = "$ 60"
        messageCell.timeLabel.text = "2 hours ago"
        
        if indexPath.row % 2 == 0 {
            messageCell.messageHasBeen(read: true)
        } else {
            messageCell.messageHasBeen(read: false)
        }
        
        return messageCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Show proper Detail message view here
        
        if let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell {
            cell.messageHasBeen(read: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
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
