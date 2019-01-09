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
        collectionView?.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.headerID)
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
    
    var userConversations: [MeQuery.Data.Me.Conversation.UserConversation?]?
    
    func fetchConversations() {
        
        
        let convoQuery = getUserConversationConnectionThroughUser()

        appSyncClient?.fetch(query: convoQuery, cachePolicy: CachePolicy.fetchIgnoringCacheData, resultHandler: { (result, error) in
            
            if let error = error {
                print("Error fetching conversations: \(error)")
            } else {
                
                print("Fetched all the conversations")
                print(result)
//                if let userConversations = result?.data?.me?.conversations?.userConversations {
//                    self.userConversations = userConversations
//
//                    for eachUserConvo in userConversations {
//                        print(eachUserConvo?.__typename)
//                        print(eachUserConvo?.conversationId)
//                        print(eachUserConvo?.snapshot)
//                        print(eachUserConvo?.userId)
//                    }
//
//                }
            }
            
        })
        
        
        
        
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
        print("number of pine \(ServinData.allPins.count)")
        return ServinData.allPins.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        
        cell.userImageView.image = ServinData.allPins[indexPath.row]._images.first ?? #imageLiteral(resourceName: "1")
        cell.userNameLabel.text = "Meghan"
        cell.dateLabel.text = "2 hours"
        cell.messageLabel.text = "Sounds great!"
        cell.titleLabel.text = ServinData.allPins[indexPath.row]._title
        cell.priceLabel.text = "$ " + "\(ServinData.allPins[indexPath.row]._price ?? 0)"
        
        //        cell.backgroundColor = .blue
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let vc = DetailedMessageViewController()
                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    private class MessageCell: UICollectionViewCell {
        
        var userImageView: UIImageView!
        var userNameLabel: UILabel!
        var dateLabel: UILabel!
        var messageLabel: UILabel!
        var titleLabel: UILabel!
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
            
            userNameLabel = UILabel()
            self.contentView.addSubview(userNameLabel)
            
            userNameLabel.translatesAutoresizingMaskIntoConstraints = false
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 12).isActive = true
            userNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15).isActive = true
            
            userNameLabel.numberOfLines = 1
            userNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            userNameLabel.textColor = UIColor.blackFontColor
            
            
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
            messageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 6).isActive = true
            messageLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12).isActive = true
            
            messageLabel.numberOfLines = 1
            
            messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            messageLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
            
            
            titleLabel = UILabel()
            self.contentView.addSubview(titleLabel)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 12).isActive = true
            
            titleLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 3).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12).isActive = true
            
            titleLabel.numberOfLines = 1
            titleLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            
            
            priceLabel = UILabel()
            self.contentView.addSubview(priceLabel)
            
            priceLabel.translatesAutoresizingMaskIntoConstraints = false
            
            priceLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 12).isActive = true
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3).isActive = true
            
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





public final class getUserConversationConnectionThroughUser: GraphQLQuery {
    public static let operationString = "query getUserConversationConnectionThroughUser($after: String, $first: Int) {\n    me {\n    userId\n    __typename\n    conversations(first: $first, after: $after) {\n    __typename\n    nextToken\n    userConversations {\n    __typename\n    userId\n    conversationId\n    associated {\n    __typename\n    userId\n    }\n    conversation {\n    __typename\n    id\n    discoveryId\n    }\n    }\n    }\n    }\n}"
    
    public init() {
    }
    
    public struct Data: GraphQLSelectionSet {
        public static let possibleTypes = ["Query"]
        
        public static let selections: [GraphQLSelection] = [
            GraphQLField("me", type: .object(Me.selections)),
            ]
        
        public var snapshot: Snapshot
        
        public init(snapshot: Snapshot) {
            self.snapshot = snapshot
        }
        
        public init(me: Me? = nil) {
            self.init(snapshot: ["__typename": "Query", "me": me.flatMap { $0.snapshot }])
        }
        
        /// Get my user.
        public var me: Me? {
            get {
                return (snapshot["me"] as? Snapshot).flatMap { Me(snapshot: $0) }
            }
            set {
                snapshot.updateValue(newValue?.snapshot, forKey: "me")
            }
        }
        
        public struct Me: GraphQLSelectionSet {
            public static let possibleTypes = ["User"]
            
            public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("conversations", type: .object(Conversation.selections)),
                GraphQLField("messages", type: .object(Message.selections)),
                GraphQLField("username", type: .nonNull(.scalar(String.self))),
                GraphQLField("registered", type: .scalar(Bool.self)),
                ]
            
            public var snapshot: Snapshot
            
            public init(snapshot: Snapshot) {
                self.snapshot = snapshot
            }
            
            public init(userId: GraphQLID, conversations: Conversation? = nil, messages: Message? = nil, username: String, registered: Bool? = nil) {
                self.init(snapshot: ["__typename": "User", "userId": userId, "conversations": conversations.flatMap { $0.snapshot }, "messages": messages.flatMap { $0.snapshot }, "username": username, "registered": registered])
            }
            
            public var __typename: String {
                get {
                    return snapshot["__typename"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                }
            }
            
            /// A unique identifier for the user. (cognito id)
            public var userId: GraphQLID {
                get {
                    return snapshot["userId"]! as! GraphQLID
                }
                set {
                    snapshot.updateValue(newValue, forKey: "userId")
                }
            }
            
            /// A user's enrolled Conversations. This is an interesting case. This is an interesting pagination case.
            public var conversations: Conversation? {
                get {
                    return (snapshot["conversations"] as? Snapshot).flatMap { Conversation(snapshot: $0) }
                }
                set {
                    snapshot.updateValue(newValue?.snapshot, forKey: "conversations")
                }
            }
            
            /// Get a users messages by querying a GSI on the Messages table.
            public var messages: Message? {
                get {
                    return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
                }
                set {
                    snapshot.updateValue(newValue?.snapshot, forKey: "messages")
                }
            }
            
            /// The username
            public var username: String {
                get {
                    return snapshot["username"]! as! String
                }
                set {
                    snapshot.updateValue(newValue, forKey: "username")
                }
            }
            
            /// is the user registered?
            public var registered: Bool? {
                get {
                    return snapshot["registered"] as? Bool
                }
                set {
                    snapshot.updateValue(newValue, forKey: "registered")
                }
            }
            
            public struct Conversation: GraphQLSelectionSet {
                public static let possibleTypes = ["UserConverstationsConnection"]
                
                public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("nextToken", type: .scalar(String.self)),
                    GraphQLField("userConversations", type: .list(.object(UserConversation.selections))),
                    ]
                
                public var snapshot: Snapshot
                
                public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                }
                
                public init(nextToken: String? = nil, userConversations: [UserConversation?]? = nil) {
                    self.init(snapshot: ["__typename": "UserConverstationsConnection", "nextToken": nextToken, "userConversations": userConversations.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
                }
                
                public var __typename: String {
                    get {
                        return snapshot["__typename"]! as! String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                    }
                }
                
                public var nextToken: String? {
                    get {
                        return snapshot["nextToken"] as? String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "nextToken")
                    }
                }
                
                public var userConversations: [UserConversation?]? {
                    get {
                        return (snapshot["userConversations"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { UserConversation(snapshot: $0) } } }
                    }
                    set {
                        snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "userConversations")
                    }
                }
                
                public struct UserConversation: GraphQLSelectionSet {
                    public static let possibleTypes = ["UserConversations"]
                    
                    public static let selections: [GraphQLSelection] = [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
                        GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
                        ]
                    
                    public var snapshot: Snapshot
                    
                    public init(snapshot: Snapshot) {
                        self.snapshot = snapshot
                    }
                    
                    public init(conversationId: GraphQLID, userId: GraphQLID) {
                        self.init(snapshot: ["__typename": "UserConversations", "conversationId": conversationId, "userId": userId])
                    }
                    
                    public var __typename: String {
                        get {
                            return snapshot["__typename"]! as! String
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "__typename")
                        }
                    }
                    
                    public var conversationId: GraphQLID {
                        get {
                            return snapshot["conversationId"]! as! GraphQLID
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "conversationId")
                        }
                    }
                    
                    public var userId: GraphQLID {
                        get {
                            return snapshot["userId"]! as! GraphQLID
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "userId")
                        }
                    }
                }
            }
            
            public struct Message: GraphQLSelectionSet {
                public static let possibleTypes = ["MessageConnection"]
                
                public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("messages", type: .list(.object(Message.selections))),
                    GraphQLField("nextToken", type: .scalar(String.self)),
                    ]
                
                public var snapshot: Snapshot
                
                public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                }
                
                public init(messages: [Message?]? = nil, nextToken: String? = nil) {
                    self.init(snapshot: ["__typename": "MessageConnection", "messages": messages.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken])
                }
                
                public var __typename: String {
                    get {
                        return snapshot["__typename"]! as! String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                    }
                }
                
                public var messages: [Message?]? {
                    get {
                        return (snapshot["messages"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Message(snapshot: $0) } } }
                    }
                    set {
                        snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "messages")
                    }
                }
                
                public var nextToken: String? {
                    get {
                        return snapshot["nextToken"] as? String
                    }
                    set {
                        snapshot.updateValue(newValue, forKey: "nextToken")
                    }
                }
                
                public struct Message: GraphQLSelectionSet {
                    public static let possibleTypes = ["Message"]
                    
                    public static let selections: [GraphQLSelection] = [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("content", type: .nonNull(.scalar(String.self))),
                        GraphQLField("conversationId", type: .nonNull(.scalar(GraphQLID.self))),
                        GraphQLField("createdAt", type: .scalar(Int.self)),
                        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                        GraphQLField("isSent", type: .scalar(Bool.self)),
                        GraphQLField("sender", type: .scalar(String.self)),
                        ]
                    
                    public var snapshot: Snapshot
                    
                    public init(snapshot: Snapshot) {
                        self.snapshot = snapshot
                    }
                    
                    public init(content: String, conversationId: GraphQLID, createdAt: Int? = nil, id: GraphQLID, isSent: Bool? = nil, sender: String? = nil) {
                        self.init(snapshot: ["__typename": "Message", "content": content, "conversationId": conversationId, "createdAt": createdAt, "id": id, "isSent": isSent, "sender": sender])
                    }
                    
                    public var __typename: String {
                        get {
                            return snapshot["__typename"]! as! String
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "__typename")
                        }
                    }
                    
                    /// The message content.
                    public var content: String {
                        get {
                            return snapshot["content"]! as! String
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "content")
                        }
                    }
                    
                    /// The id of the Conversation this message belongs to. This is the table primary key.
                    public var conversationId: GraphQLID {
                        get {
                            return snapshot["conversationId"]! as! GraphQLID
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "conversationId")
                        }
                    }
                    
                    /// The message timestamp. This is also the table sort key.
                    public var createdAt: Int? {
                        get {
                            return snapshot["createdAt"] as? Int
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "createdAt")
                        }
                    }
                    
                    /// Generated id for a message -- read-only
                    public var id: GraphQLID {
                        get {
                            return snapshot["id"]! as! GraphQLID
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "id")
                        }
                    }
                    
                    /// Flag denoting if this message has been accepted by the server or not.
                    public var isSent: Bool? {
                        get {
                            return snapshot["isSent"] as? Bool
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "isSent")
                        }
                    }
                    
                    public var sender: String? {
                        get {
                            return snapshot["sender"] as? String
                        }
                        set {
                            snapshot.updateValue(newValue, forKey: "sender")
                        }
                    }
                }
            }
        }
    }
}
