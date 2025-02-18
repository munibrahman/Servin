//
//  MessageDiscoveryViewController.swift
//  ServinV2
//
//  Created by Munib Rahman on 2019-05-12.
//  Copyright © 2019 Voltic Labs Inc. All rights reserved.
//

import UIKit
import AWSAppSync
import IQKeyboardManagerSwift
import AWSMobileClient
import SwiftyJSON
import AWSPinpoint
// CHATLOG Controller

// This VC will be displayed after a user taps the "Im interested" button.
// Its job is to check whether a conversation has already been started over this discovery.
// If there is a conversation that exists, it will then pull all the related messages in that conversation
// If there isn't a conversation that has been started, it will start a new conversation, create a new user conversation mutation and then finally send a new message.
class MessageDiscoveryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var aDiscovery: GetSurroundingDiscoveriesQuery.Data.GetSurroundingDiscovery? {
        didSet {
            navigationItem.title = aDiscovery?.author?.givenName
        }
    }
    
    lazy var inputTextField: UITextField = {
        let inputTextField = UITextField()
        inputTextField.backgroundColor = .white
        inputTextField.placeholder = "Enter message..."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.delegate = self
        return inputTextField
    }()
    
    var appSyncClient: AWSAppSyncClient?
    
    
    var collectionView: UICollectionView?
    
    var newMessageSubscriptionWatcher: AWSAppSyncSubscriptionWatcher<SubscribeToNewMessageSubscription>?
    var messages: [AllMessageConnectionQuery.Data.AllMessageConnection.Message?]?
    
    
    let cellId = "cellId"
    
    var conversation: MeQuery.Data.Me.Conversation.UserConversation.Conversation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient
        
        view.backgroundColor = .white
        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        collectionView?.backgroundColor = .white
        
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(collectionView!)
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        
        setupNavigationController()
        
        fetchConversation()
        
        setupViews()
        setupInputComponents()
        setupKeyboardObservers()
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            containerViewBottomAnchor?.constant = -keyboardFrame.height
            
            if let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                
                
                UIView.animate(withDuration: keyboardDuration, animations: {
                    self.view.layoutIfNeeded()
                    
                    if let messages = self.messages {
                        let indexPath = IndexPath.init(item: messages.count - 1, section: 0)
                        self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    }
                    
                    
                }) { (completion) in
                    //                    let indexPath = IndexPath.init(item: (self.messages?.count)! - 1, section: 0)
                    //                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        containerViewBottomAnchor?.constant = 0
        
        if let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: keyboardDuration) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        newMessageSubscriptionWatcher?.cancel()
        print("cancelled")
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages![indexPath.item]
        cell.textView.text = message?.content
        
        if message?.sender == AWSMobileClient.sharedInstance().username ?? " " {
            // This message was my own
            cell.bubbleView.backgroundColor = UIColor.white
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            // This is another person's message
            cell.bubbleView.backgroundColor = ChatMessageCell.lightGrayColor
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
        
        cell.bubbleWidthAnchor?.constant = estimateFrameFor(text: message?.content ?? "").width + 32
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        // estimate the height here.
        if let text = messages![indexPath.item]?.content {
            height = estimateFrameFor(text: text).height + 20
        }
        
        return CGSize.init(width: view.frame.width, height: height)
    }
    
    private func estimateFrameFor(text: String) -> CGRect {
        
        let size = CGSize.init(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString.init(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupNavigationController() {
        if self.navigationController == nil {
            fatalError("This VC Must be presented inside a navigation controller")
        }
        
        navigationController?.navigationBar.tintColor = UIColor.black
        
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_grey"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
        
        
    }
    
    @objc func barButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        //        let topPinView = UIView.init(frame: CGRect.init(x: 0.0, y: self.topbarHeight, width: self.view.frame.size.width, height: 75.0))
        
        let topPinView = UIView()
        
        topPinView.backgroundColor = .white
        topPinView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topPinView)
        
        topPinView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topPinView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        topPinView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topPinView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        
        let topPinImageView = UIImageView.init(frame: CGRect.init(x: 8.0, y: 4.0, width: 66.0, height: 66.0))
        topPinImageView.contentMode = .scaleAspectFill
        topPinImageView.clipsToBounds = true
        
        // TODO: Get the image of the discovery in here
        //        topPinImageView.image = #imageLiteral(resourceName: "soccer")
        //        topPinImageView.image = aDiscovery?.image_0
        
        
        if let image_0 = aDiscovery?.image_0, let ICONLink = image_0.ICONImageKeyS3() {
            topPinImageView.loadImageUsingS3Key(key: ICONLink)
        }
        
        topPinView.addSubview(topPinImageView)
        
        // TODO: Populate info for the title here
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0.0, y: 10.0, width: 200.0, height: 50.0))
        titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        titleLabel.textColor = UIColor.blackFontColor
        //        titleLabel.text = "Soccer Coach for hire!"
        titleLabel.text = aDiscovery?.title ?? " "
        
        topPinView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: topPinView.layoutMarginsGuide.topAnchor, constant: -4.0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: topPinImageView.layoutMarginsGuide.trailingAnchor, constant: 16.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: topPinView.layoutMarginsGuide.trailingAnchor, constant: -8.0).isActive = true
        
        
        let timeLabel = UILabel.init()
        timeLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        timeLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
        
        //        timeLabel.text = "5 mins away"
        
        topPinView.addSubview(timeLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.leadingAnchor.constraint(equalTo: topPinImageView.layoutMarginsGuide.trailingAnchor, constant: 16.0).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: topPinView.layoutMarginsGuide.bottomAnchor, constant: 0.0).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: topPinView.layoutMarginsGuide.trailingAnchor, constant: -16.0).isActive = true
        
        
        let priceLabel = UILabel.init()
        priceLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        priceLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
        priceLabel.text = "$ \(aDiscovery?.price ?? 0)"
        
        topPinView.addSubview(priceLabel)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.leadingAnchor.constraint(equalTo: topPinImageView.layoutMarginsGuide.trailingAnchor, constant: 16.0).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: timeLabel.layoutMarginsGuide.topAnchor, constant: -8.0).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: topPinView.layoutMarginsGuide.trailingAnchor, constant: -16.0).isActive = true
        
        let thinLine = UIView()
        thinLine.backgroundColor = UIColor.contentDivider
        
        topPinView.addSubview(thinLine)
        
        thinLine.translatesAutoresizingMaskIntoConstraints = false
        
        
        thinLine.leadingAnchor.constraint(equalTo: topPinView.leadingAnchor).isActive = true
        thinLine.trailingAnchor.constraint(equalTo: topPinView.trailingAnchor).isActive = true
        thinLine.bottomAnchor.constraint(equalTo: topPinView.bottomAnchor).isActive = true
        thinLine.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        collectionView?.topAnchor.constraint(equalTo: topPinView.bottomAnchor).isActive = true
    }
    
    
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let sendButton = UIButton.init(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView)
        
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        collectionView?.bottomAnchor.constraint(equalTo: seperatorLineView.topAnchor).isActive = true
    }
    
    @objc func handleSend() {
        
        
        guard let textFieldContent = inputTextField.text, !textFieldContent.isEmpty else {
            return
        }
        
        // Conversation already exists, just need to send a new message
        if let conversation = conversation {
            let messageMutation = CreateMessageMutation.init(content: textFieldContent, conversationId: conversation.id)
            
            appSyncClient?.perform(mutation: messageMutation, resultHandler: { (result, error) in
                
                if let error = error {
                    print("Error sending message")
                    print(error)
                    self.showErrorNotification(title: "Error", subtitle: "Can't send message right now")
                }
                
                if let errors = result?.errors {
                    print("Errors sending this message")
                    print(errors)
                    self.showErrorNotification(title: "Error", subtitle: "Can't send message right now")
                }
                
                if let result = result {
                    print("Successful response for sending message: \(result)")
                    self.inputTextField.text = nil
                    
                    PinpointManager.shared.sendPinpointNotification(to: self.aDiscovery?.author?.username ?? " ", title: self.aDiscovery?.title ?? " " , body: textFieldContent)
                }
            })
            
            
            print(textFieldContent)
        }
        
        // Conversation doesn't exist. We must start a new convo.
        else {
            print("Start new conversation")
            
            if let discovery = aDiscovery {
                
                
                guard let discoveryId = discovery.discoveryId else {
                    print("No discovery Id stored for this user...")
                    return
                }
                
                guard let userName = AWSMobileClient.sharedInstance().username else {
                    print("No username stored for this user...")
                    return
                }
                
                let startConvo = CreateConversationMutation.init(discoveryId: discoveryId)
                
                appSyncClient?.perform(mutation: startConvo, resultHandler: { (result, error) in
                    if let error = error {
                        print("Error creating a new conversation \(error.localizedDescription)")
                    } else {
                        print("Created conversation: \(result?.data)")
                        
                        if let id = result?.data?.createConversation?.id {
                            print("Conversation id is \(id)")
                            
                            
                            self.appSyncClient?.perform(mutation: CreateUserConversationsMutation.init(conversationId: id, username: userName), resultHandler: { (result, error) in
                                if let error = error {
                                    print("Error creating a new user conversation \(error.localizedDescription)")
                                } else {
                                    print("Created a user conversation \(result?.data)")
                                }
                            })

                            guard let userId = result?.data?.createConversation?.discovery?.cognitoUserName else {
                                print("Can't get other person's user name, abandon")
                                return
                            }
                            
                            self.appSyncClient?.perform(mutation: CreateUserConversationsMutation.init(conversationId: id, username: userId), resultHandler: { (result, error) in
                                if let error = error {
                                    print("Error creating a new user conversation \(error.localizedDescription)")
                                } else {
                                    print("Created a user conversation \(result?.data)")
                                }
                            })
                            
                            let messageMutation = CreateMessageMutation.init(content: textFieldContent, conversationId: id)
                            
                            self.appSyncClient?.perform(mutation: messageMutation, resultHandler: { (result, err) in
                                
                                if let error = error {
                                    print("Error sending message")
                                    print(error)
                                    self.showErrorNotification(title: "Error", subtitle: "Can't send message right now")
                                }
                                
                                if let errors = result?.errors {
                                    print("Errors sending this message")
                                    print(errors)
                                    self.showErrorNotification(title: "Error", subtitle: "Can't send message right now")
                                }
                                
                                if let result = result {
                                    print("Successful response for sending message: \(result)")
                                    self.inputTextField.text = nil
                                    self.fetchMessages()
                                    
                                    PinpointManager.shared.sendPinpointNotification(to: self.aDiscovery?.author?.username ?? " ", title: self.aDiscovery?.title ?? " " , body: textFieldContent)
                                }

                            })
                            
                            if let snapshot = result?.data?.createConversation?.snapshot {
                                print("Made a conversation object from the snapshot, update the tableview to message being sent")
                                self.conversation = MeQuery.Data.Me.Conversation.UserConversation.Conversation.init(snapshot: snapshot)
                                self.observeMessages()
                            } else {
                                print("no snapshot to be extracted... made a new convo but nothing to show for it.")
                            }
                            
                            
                            
                        } else {
                            print("no conversation id... wtf")
                        }
                    }
                })
            } else {
                print("No discovery passed")
            }
            
            
            
            
        }
        
        
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    func fetchConversation() {
        
        guard let discovery = aDiscovery else {
            print("Can't unwrap discovery, must be passed in from the previous VC")
            return
        }
        
        guard let discoveryId = discovery.discoveryId else {
            print("No discovery Id stored for this user...")
            return
        }
        
        let checkConvo = ConversationFromDiscoveryQuery.init(discoveryId: discoveryId)
        
        appSyncClient?.fetch(query: checkConvo, cachePolicy: CachePolicy.returnCacheDataAndFetch, resultHandler: { (result, error) in
            if let error = error {
                // TODO: SHOW error to user
                print("Error fetching data... \(error.localizedDescription)")
                print(error)
                self.showErrorNotification(title: "Erro", subtitle: "Unable to get messages")
            }
            if let errors = result?.errors {
                // TODO: SHOW error to user
                print("Errors fetching data... \(errors)")
                self.showErrorNotification(title: "Erro", subtitle: "Unable to get messages")
            }
            else {
                
                if let convo = result?.data?.conversationFromDiscovery {
                    print("Conversation exists, fetch messages")
                    self.conversation = MeQuery.Data.Me.Conversation.UserConversation.Conversation.init(snapshot: convo.snapshot)
                    self.fetchMessages()
                } else {
                    print("Conversation doesn't exist")
                }
                
                
            }
        })
        
        
    }
    
    func fetchMessages() {
        
        guard let conversation = conversation else {
            print("Error retriveing convo id")
            return
        }
        
        let messagesQuery = AllMessageConnectionQuery.init(conversationId: conversation.id)
        
        appSyncClient?.fetch(query: messagesQuery, cachePolicy: CachePolicy.returnCacheDataAndFetch, resultHandler: { (result, error) in
            if let error = error {
                print("Error fetching messages \(error.localizedDescription)")
            } else if let result = result {
                
                if let messages = result.data?.allMessageConnection?.messages {
                    self.messages = messages.sorted(by: { (lhs, rhs) -> Bool in
                        
                        if let left = lhs, let right = rhs {
                            return left.createdAt ?? 0 < right.createdAt ?? 0
                        }
                        
                        return false
                    })
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        let indexPath = IndexPath.init(item: (self.messages?.count)! - 1, section: 0)
                        self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    }
                }
                
                self.observeMessages()
            }
        })
        
    }
    
    func observeMessages() {
        
        guard let conversation = conversation else {
            print("Error getting id")
            return
        }
        
        
        let subscribeToMessages = SubscribeToNewMessageSubscription.init(conversationId: conversation.id)
        
        do {
            
            newMessageSubscriptionWatcher =  try appSyncClient?.subscribe(subscription: subscribeToMessages, resultHandler: { (res, transaction, err) in
                
                print("recieved new message")
                
                let content = res?.data?.subscribeToNewMessage?.content
                let sender = res?.data?.subscribeToNewMessage?.sender
                
//                print(content)
//                print(sender)
                
                
                if let snapshot = res?.data?.subscribeToNewMessage?.snapshot {
                    print("Snap shot exists")
                    let messageObject = AllMessageConnectionQuery.Data.AllMessageConnection.Message.init(snapshot: snapshot)
                    print("created snapshot")
                    
                    if let messages = self.messages {
                        print("Able to decrypt message")
                        self.messages?.append(messageObject)
                        
                        DispatchQueue.main.async {
                            self.collectionView?.performBatchUpdates({
                                let indexSet = IndexSet(integer: 0)
                                self.collectionView?.reloadSections(indexSet)
                                
                            }, completion: { (didFinish) in
                                print("Did finish updating")
                                let indexPath = IndexPath.init(item: (self.messages?.count)! - 1, section: 0)
                                self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                            })
                            
                        }
                    }
                    
                }
            })
            
            
        } catch {
            print("Error occured while subscribing \(error)")
        }
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
