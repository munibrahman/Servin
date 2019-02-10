//
//  NotificationsAroundYouViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-09-04.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit

class NotificationsAroundYouViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    let reuseIdentifier = "cell"
    let headerID = "header"
    
    var closeButton: UIButton!
    
    override func loadView() {
        view = UIView()
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        collectionView?.register(NotificationCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerID)
        collectionView?.delegate = self
        
        collectionView?.backgroundColor = .white
        
        setNeedsStatusBarAppearanceUpdate()
        
        closeButton = UIButton.init(frame: CGRect.zero)
        closeButton.setImage(#imageLiteral(resourceName: "close_icon"), for: .normal)
        
        self.view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        closeButton.addTarget(self, action: #selector(userDidTapX), for: UIControl.Event.allTouchEvents)
        
    }
    
    @objc func userDidTapX() {
        print("User did tap X")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height: 311)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        
        cell.discoveryImageView.image = ServinData.allPins[indexPath.row]._images.first ?? #imageLiteral(resourceName: "1")
        cell.discoveryTitle.text = ServinData.allPins[indexPath.row]._title ?? ""
        cell.discoveryPrice.text = "$ " + "\(ServinData.allPins[indexPath.row]._price ?? 0)"
        cell.discoveryTime.text = "3 mins away"
        
//        cell.backgroundColor = .blue
        
        return cell
    }
    
    
    
    
    private class NotificationCell: UICollectionViewCell {
        
        var discoveryImageView: UIImageView!
        var discoveryTitle: UILabel!
        var discoveryPrice: UILabel!
        var discoveryTime: UILabel!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            discoveryImageView = UIImageView()
            
            contentView.addSubview(discoveryImageView)
            discoveryImageView.translatesAutoresizingMaskIntoConstraints = false
            
            discoveryImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
            discoveryImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
            discoveryImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
            discoveryImageView.heightAnchor.constraint(equalToConstant: 218).isActive = true
            
            discoveryImageView.layer.cornerRadius = 3.0
            discoveryImageView.clipsToBounds = true
            discoveryImageView.contentMode = .scaleAspectFill
            
            discoveryTitle = UILabel()
            self.contentView.addSubview(discoveryTitle)
            
            discoveryTitle.translatesAutoresizingMaskIntoConstraints = false
            discoveryTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
            discoveryTitle.topAnchor.constraint(equalTo: discoveryImageView.bottomAnchor, constant: 10).isActive = true
            discoveryTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
            
            discoveryTitle.numberOfLines = 2
            discoveryTitle.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            discoveryTitle.textColor = UIColor.blackFontColor
            
            
            discoveryPrice = UILabel()
            self.contentView.addSubview(discoveryPrice)
            discoveryPrice.translatesAutoresizingMaskIntoConstraints = false
            
            discoveryPrice.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
            discoveryPrice.topAnchor.constraint(equalTo: discoveryTitle.bottomAnchor, constant: 6).isActive = true
            discoveryPrice.numberOfLines = 1
            discoveryPrice.font = UIFont.systemFont(ofSize: 21, weight: .light)
            discoveryPrice.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
            
            
            discoveryTime = UILabel()
            self.contentView.addSubview(discoveryTime)
            
            discoveryTime.translatesAutoresizingMaskIntoConstraints = false
            
            discoveryTime.leadingAnchor.constraint(equalTo: discoveryPrice.trailingAnchor, constant: 20).isActive = true
            discoveryTime.topAnchor.constraint(equalTo: discoveryTitle.bottomAnchor, constant: 6).isActive = true
            
            discoveryTime.numberOfLines = 1
            
            discoveryTime.font = UIFont.systemFont(ofSize: 21, weight: .light)
            discoveryTime.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
            
            
            
            
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
            aroundYouLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
            aroundYouLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 27).isActive = true
            
            aroundYouLabel.numberOfLines = 1
            aroundYouLabel.text = "AROUND YOU"
            aroundYouLabel.font = UIFont.systemFont(ofSize: 21, weight: .medium)
            aroundYouLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.5)
            
            let weThinkLabel = UILabel()
            self.contentView.addSubview(weThinkLabel)
            
            weThinkLabel.translatesAutoresizingMaskIntoConstraints = false
            weThinkLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
            weThinkLabel.topAnchor.constraint(equalTo: aroundYouLabel.bottomAnchor).isActive = true
            
            weThinkLabel.numberOfLines = 1
            weThinkLabel.text = "We think you might like these"
            weThinkLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
            weThinkLabel.textColor = UIColor.blackFontColor
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}

