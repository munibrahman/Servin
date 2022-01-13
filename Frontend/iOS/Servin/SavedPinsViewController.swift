//
//  SavedPinsViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-06-25.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import AWSAppSync

class SavedPinsViewController: UIViewController {
    
    let reuseIdentifier = "Cell"
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.estimatedItemSize = CGSize.init(width: view.frame.size.width, height: 220.0)
        layout.sectionInset = UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView.init(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView.register(SavedPinsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    var allSavedDiscoveries = [AllSavedDiscoveriesQuery.Data.AllSavedDiscovery?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupNavigationController()
        
        setupCollectionView()

        fetchMySavedPins()
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
    
    func setupCollectionView() {
        
        
        
        self.view.addSubview(collectionView)
    }
    
    func fetchMySavedPins() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let allsavedquery = AllSavedDiscoveriesQuery.init()
            
            appSyncClient?.fetch(query: allsavedquery, cachePolicy: CachePolicy.returnCacheDataAndFetch, resultHandler: { (result, error) in
                if let result = result {
                    print("Got my saved discoveries")
                    if let discoveries = result.data?.allSavedDiscoveries {
                        self.allSavedDiscoveries = discoveries
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
                else if let error = error {
                    print("Error getting saved discoveries")
                    print(error)
                    self.showErrorNotification(title: "Error", subtitle: "Unable to get your saved discoveries")
                    return
                } else if let errors = result?.errors {
                    print("Error in here")
                    print(errors)
                }
            })
            
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


extension SavedPinsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if allSavedDiscoveries.count == 0 {
            collectionView.setEmptyMessage("You don't have any saved pins", image: nil)
        } else {
            collectionView.restore()
        }
        
        return allSavedDiscoveries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SavedPinsCollectionViewCell
        
        if let discovery = allSavedDiscoveries[indexPath.item] {
//            cell.pinImageView.loadImageUsingS3Key(key: discovery.discovery?.image_0?.MEDImageKeyS3() ?? "")
            cell.pinTitle.text = discovery.discovery?.title
            cell.pinPrice.text = "$ \(discovery.discovery?.price)"
            cell.timeAway.text = "3 mins away"
            
            if let image_0 = discovery.discovery?.image_0, let ICONUrl = image_0.MEDImageKeyS3() {
                cell.pinImageView.loadImageUsingS3Key(key: ICONUrl)
            }
            
            cell.discoveryId = discovery.discoveryId
            cell.isSaved = discovery.discovery?.isSaved ?? false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let discovery = allSavedDiscoveries[indexPath.row], let snapshot = discovery.discovery?.snapshot {
            let vc = UserDiscoveryViewController()
            vc.pin = GetSurroundingDiscoveriesQuery.Data.GetSurroundingDiscovery.init(snapshot: snapshot)
            self.present(UINavigationController.init(rootViewController: vc), animated: true, completion: nil)
        }
    }
    
}


class SavedPinsCollectionViewCell: UICollectionViewCell {
    
    var pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var pinTitle: UILabel = {
        let label = UILabel.init()
        label.adjustsFontSizeToFitWidth = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.blackFontColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var pinPrice: UILabel = {
        let label = UILabel.init()
        label.adjustsFontSizeToFitWidth = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor.blackFontColor.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var timeAway: UILabel = {
        let label = UILabel.init()
        label.adjustsFontSizeToFitWidth = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor.blackFontColor.withAlphaComponent(0.3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var isSaved: Bool = false {
        willSet {
            changeSavedState(isSaved: newValue)
        }
    }
    
    private var savedView: SaveIconView!
    
    var discoveryId:  String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {

        self.addSubview(pinImageView)
        
        pinImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        pinImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pinImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        pinImageView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true

        self.addSubview(pinTitle)
        
        pinTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        pinTitle.topAnchor.constraint(equalTo: pinImageView.bottomAnchor).isActive = true
        pinTitle.heightAnchor.constraint(equalToConstant: 30.0).isActive = true

        pinTitle.text = "Selling this discovery"

        
        self.addSubview(pinPrice)

        pinPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        pinPrice.topAnchor.constraint(equalTo: pinTitle.bottomAnchor).isActive = true
        pinPrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        pinPrice.heightAnchor.constraint(equalToConstant: 20).isActive = true

        pinPrice.text = "$ 500"

        self.addSubview(timeAway)

        timeAway.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        timeAway.topAnchor.constraint(equalTo: pinPrice.bottomAnchor).isActive = true

        
        savedView = SaveIconView.init(frame: CGRect.init(x: 20, y: 0, width: 40, height: 40))
        self.addSubview(savedView)

        savedView.translatesAutoresizingMaskIntoConstraints = false
        savedView.centerXAnchor.constraint(equalTo: pinImageView.trailingAnchor, constant: -13).isActive = true
        savedView.centerYAnchor.constraint(equalTo: pinImageView.bottomAnchor).isActive = true
        savedView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        savedView.widthAnchor.constraint(equalToConstant: 40).isActive = true
//
//
//        pinTitle.trailingAnchor.constraint(equalTo: savedView.leadingAnchor).isActive = true
//
//
//
        let saveTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(userDidTapSave))

        savedView.addGestureRecognizer(saveTapGesture)

        savedView.saveIcon.image = #imageLiteral(resourceName: "save_icon_empty")
        
        
    }
    
//    func configureCellFor(discovery: AllSavedDiscoveriesQuery.Data.AllSavedDiscovery) {
//        pinTitle.text = discovery.discovery?.title
//        pinPrice.text = "$ \(discovery.discovery?.price ?? 0)"
//        changeSavedState(isSaved: discovery.discovery?.isSaved ?? false)
//        self.isSaved = discovery.discovery?.isSaved ?? false
//        timeAway.text = "3 mins away"
//        self.discovery = discovery
//
//        if let image_0 = discovery.discovery?.image_0, let ICONUrl = image_0.MEDImageKeyS3() {
//                pinImageView.loadImageUsingS3Key(key: ICONUrl)
//
//        }
//    }
    
    @objc func userDidTapSave() {
        print("Did tap save")
        
//        changeSavedState(isSaved: isSaved)
//
//        isSaved = !isSaved
        
        guard let discoveryId = self.discoveryId else {
            print("no discovery id here")
         return
        }
        
        
        
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
         
            if isSaved {
                let mutation = RemoveSavedDiscoveryMutation.init(discoveryId: discoveryId)
                appSyncClient?.perform(mutation: mutation)
            } else {
                let mutation = SaveDiscoveryMutation.init(discoveryId: discoveryId)
                appSyncClient?.perform(mutation: mutation)
                
            }
            
            isSaved = !isSaved
            changeSavedState(isSaved: isSaved)
        }
        
    }
    
    func changeSavedState(isSaved: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.savedView.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
            if isSaved {
                self.savedView.saveIcon.image = #imageLiteral(resourceName: "save_icon_fill")
                
            } else {
                self.savedView.saveIcon.image = #imageLiteral(resourceName: "save_icon_empty")
            }
        }) { (finish) in
            self.savedView.transform = .identity
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class SaveIconView: UIView {
        
        
        var saveIcon: UIImageView!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            if frame.height != frame.width {
                fatalError("Must be a square")
            }
            
            self.backgroundColor = .white
            self.layer.cornerRadius = self.frame.width / 2.0
            self.clipsToBounds = true
            
            self.borderWidth = 1.0
            self.borderColor = UIColor.blackFontColor.withAlphaComponent(0.2)
            
            saveIcon = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 16, height: 19.3))
            saveIcon.contentMode = .scaleAspectFit
            
            self.addSubview(saveIcon)
            
            saveIcon.translatesAutoresizingMaskIntoConstraints = false
            saveIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            saveIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}























