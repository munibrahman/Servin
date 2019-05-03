////
////  MessageViewController.swift
////  ServinV2
////
////  Created by Developer on 2018-05-05.
////  Copyright © 2018 Voltic Labs Inc. All rights reserved.
////
//
//import UIKit
//import DZNEmptyDataSet
//import Alamofire
//
//class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
//
//
//    let cellIdentifier = "cell"
//
//    @IBOutlet var messagesTableView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        setupNavigationController()
//
//        messagesTableView.delegate = self
//        messagesTableView.dataSource = self
//        messagesTableView.tableFooterView = UIView.init(frame: CGRect.zero)
//
//        self.view.backgroundColor = UIColor.emptyStateBackgroundColor
//
//
//        messagesTableView.register(UINib.init(nibName: String.init(describing: MessageTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
//
//        //setupEmptyState()
//    }
//
//
//    override func viewWillAppear(_ animated: Bool) {
//
//        // This deselects the row that was previously selected by the user.
//        // In a nice animation
//
//        if let index = self.messagesTableView.indexPathForSelectedRow{
//            self.messagesTableView.deselectRow(at: index, animated: true)
//        }
//    }
//
//    func setupNavigationController() {
//
//        if self.navigationController == nil {
//            fatalError("MessageViewController must be presented inside a UINavigationController")
//        }
//
//        navigationController?.navigationBar.tintColor = UIColor.black
//
//        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(barButtonPressed))
//        navigationItem.leftBarButtonItem = barButtonItem
//
//        self.navigationItem.title = "Messages"
//    }
//
//    @objc func barButtonPressed() {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    // MARK:- DZNEmptyState
//    func setupEmptyState() {
//        messagesTableView.emptyDataSetSource = self
//        messagesTableView.emptyDataSetDelegate = self
//
//        messagesTableView.tableFooterView = UIView()
//
//    }
//
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        return #imageLiteral(resourceName: "inbox_empty")
//    }
//
//    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let title = NSString.init(string: "No Messages")
//
//        return NSAttributedString.init(string: "No Messages")
//
//    }
//
//
//    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        return NSAttributedString.init(string: "Start making money by creating a discovery")
//    }
//
//    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
//        return NSAttributedString.init(string: "Post")
//    }
//
//    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
//        return UIColor.emptyStateBackgroundColor
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let messageCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! MessageTableViewCell
//
//
//        Alamofire.request("https://picsum.photos/500/300/?random").responseImage { response in
//            debugPrint(response)
//
//            print(response.request)
//            print(response.response)
//            debugPrint(response.result)
//
//            if let image = response.result.value {
//                print("image downloaded: \(image)")
//
//                messageCell.contentImageView.image = image
//            }
//        }
//
//
//        messageCell.titleLabel.text = "Soccer coach for hire"
//        messageCell.detailLabel.text = "You: That seems good to me, see you soon!"
//        messageCell.priceLabel.text = "$ 60"
//        messageCell.timeLabel.text = "2 hours ago"
//
//        if indexPath.row % 2 == 0 {
//            messageCell.messageHasBeen(read: true)
//        } else {
//            messageCell.messageHasBeen(read: false)
//        }
//
//        return messageCell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // TODO: Show proper Detail message view here
//
//        if let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell {
//            cell.messageHasBeen(read: true)
//        }
//
//        let vc = DetailedMessageViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75.0
//    }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}


//
//  NotificationsAroundYouViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-09-04.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit
import DZNEmptyDataSet
import AWSAppSync
import AWSMobileClient

class MessageViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var appSyncClient: AWSAppSyncClient?
    let reuseIdentifier = "cell"
    let headerID = "header"
    
    var closeButton: UIButton!
    
    override func loadView() {
        view = UIView()
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient
        
        view.backgroundColor = .white
        
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerID)
        collectionView?.delegate = self
        
        collectionView?.backgroundColor = .white
        
        setupNavigationBar()
        fetchConversations()
    }
    
    func setupNavigationBar() {
        
        if self.navigationController?.viewControllers.first == self {
            let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "x_white"), style: .plain, target: self, action: #selector(userDidTapX))
            leftBarButton.tintColor = .black
            self.navigationItem.leftBarButtonItem = leftBarButton
        } else {
            let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_grey"), style: .plain, target: self, action: #selector(userDidTapBack))
            leftBarButton.tintColor = .black
            self.navigationItem.leftBarButtonItem = leftBarButton
        }
        
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .never
        
        
    }
    
    var userConversations = [MeQuery.Data.Me.Conversation.UserConversation.Conversation?]()
    
    func fetchConversations() {
        
        
        let meQuery = MeQuery.init()
        print("request \(meQuery)")
        // Start the queue here
        

        appSyncClient?.fetch(query: meQuery, cachePolicy: CachePolicy.returnCacheDataAndFetch, resultHandler: { (result, error) in
            
            if let error = error {
                print("Error fetching conversations: \(error)")
                self.showErrorNotification(title: "Error", subtitle: "Can't fetch messages, please try again")
            } else {
                
                if let userConversations = result?.data?.me?.conversations?.userConversations {
                    
                    self.userConversations.removeAll()
                    for eachUserConvo in userConversations {
                        
                        self.userConversations.append(eachUserConvo?.conversation)
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                }
            }
            
        })
        
        
    }
    
    func subscribeToUpdates() {
        
//        SubscribeToNewUCsSubscription
//
//        appSyncClient?.subscribe(subscription: <#T##GraphQLSubscription#>, resultHandler: <#T##(GraphQLResult<GraphQLSelectionSet>?, ApolloStore.ReadWriteTransaction?, Error?) -> Void#>)
        
//        guard let username = AWSMobileClient.sharedInstance().username else {
//            return
//        }
//
//        appSyncClient?.subscribe(subscription: SubscribeToNewUCsSubscription.init(userId: username ), resultHandler: { (result, transaction, error) in
//            <#code#>
//        })
    }
    
    @objc func userDidTapX() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func userDidTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height: 145)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height: 70)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath)
        //        cell.backgroundColor = .red
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userConversations.count

    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        
        if let conversation = userConversations[indexPath.item] {
            
            if let profileImage = conversation.discovery?.author?.profilePic, let icon = profileImage.ICONImageKeyS3() {
                cell.userImageView.loadImageUsingS3Key(key: icon)
            } else {
                cell.userImageView.image = #imageLiteral(resourceName: "default_profile")
            }
            
            cell.nameLabel.text = conversation.discovery?.author?.givenName
            cell.dateLabel.text = ("\(Extensions.getReadableDate(timeStamp: TimeInterval(conversation.createdAt!)) ?? "")")
            
            if let latestMessage = conversation.latestMessage?.content {
                print(conversation.latestMessage?.author)
                if let cognitoUsername = conversation.latestMessage?.author?.userId {
                    print(cognitoUsername)
                    cell.messageLabel.text = cognitoUsername == AWSMobileClient.sharedInstance().username ? "You: \(latestMessage)" : "\(latestMessage)"
                } else {
                    cell.messageLabel.text = latestMessage
                }
            }
            
            cell.titleLabel.text = conversation.discovery?.title
            cell.priceLabel.text = "$ " + "\(conversation.discovery?.price ?? 0)"
            
            
        }
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailedMessageViewController()
        vc.conversation = userConversations[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    private class MessageCell: UICollectionViewCell {
        
        var userImageView: UIImageView!
        var titleLabel: UILabel!
        var dateLabel: UILabel!
        var messageLabel: UILabel!
        var nameLabel: UILabel!
        var priceLabel: UILabel!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            userImageView = UIImageView()
            
            contentView.addSubview(userImageView)
            userImageView.translatesAutoresizingMaskIntoConstraints = false
            
            userImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
            userImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12).isActive = true
            userImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            userImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            
            userImageView.layer.cornerRadius = 50/2
            userImageView.clipsToBounds = true
            userImageView.contentMode = .scaleAspectFill
            
            titleLabel = UILabel()
            self.contentView.addSubview(titleLabel)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 12).isActive = true
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15).isActive = true
            
            titleLabel.numberOfLines = 1
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            titleLabel.textColor = UIColor.blackFontColor
            
            
            dateLabel = UILabel()
            self.contentView.addSubview(dateLabel)
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            
            dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15).isActive = true
            dateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12).isActive = true
            dateLabel.numberOfLines = 1
            dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            dateLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
            
            
            messageLabel = UILabel()
            self.contentView.addSubview(messageLabel)
            
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            
            messageLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 12).isActive = true
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
            messageLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12).isActive = true
            
            messageLabel.numberOfLines = 1
            
            messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            messageLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
            
            
            nameLabel = UILabel()
            self.contentView.addSubview(nameLabel)
            
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 12).isActive = true
            
            nameLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 3).isActive = true
            nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12).isActive = true
            
            nameLabel.numberOfLines = 1
            nameLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
            nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            
            
            priceLabel = UILabel()
            self.contentView.addSubview(priceLabel)
            
            priceLabel.translatesAutoresizingMaskIntoConstraints = false
            
            priceLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 12).isActive = true
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3).isActive = true
            
            priceLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            priceLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
            
            
            
            
            
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    private class Header: UICollectionViewCell {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            let aroundYouLabel = UILabel()
            self.contentView.addSubview(aroundYouLabel)
            
            aroundYouLabel.translatesAutoresizingMaskIntoConstraints = false
            aroundYouLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
            aroundYouLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 27).isActive = true
            
            aroundYouLabel.numberOfLines = 1
            aroundYouLabel.text = "Inbox"
            aroundYouLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
            aroundYouLabel.textColor = UIColor.blackFontColor
            
            let weThinkLabel = UILabel()
            self.contentView.addSubview(weThinkLabel)
            
            weThinkLabel.translatesAutoresizingMaskIntoConstraints = false
            weThinkLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
            weThinkLabel.topAnchor.constraint(equalTo: aroundYouLabel.bottomAnchor).isActive = true
            
            weThinkLabel.numberOfLines = 1
            weThinkLabel.text = "You have no unread messages"
            weThinkLabel.font = UIFont.systemFont(ofSize: 19, weight: .regular)
            weThinkLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}
