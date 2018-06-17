//
//  MyDiscoveryViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-06-12.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import GoogleMaps

class MyDiscoveryViewController: UIViewController {
    
    @IBOutlet var discoveryCollectionView: UICollectionView!
    
    let mapCellHeight: CGFloat = 300.0
    let profileCellHeight: CGFloat = 77.0
    
    let mapCellIdentifier = "MapCell"
    let detailsCellIdentifier = "DetailsCell"
    let imagesCellIdentifier = "ImagesCell"
    let profileCellIdentifier = "ProfileCell"
    
    var gmsMap: GMSMapView!
    
    var statusBarView = UIView()
    var navigationBarShadow = UIView()
    
    var discoverySaved = false
    
    var imInterestedButton: UIButton = {
        let imInterestedButton = UIButton()
        imInterestedButton.setTitle("I'm Interested!", for: .normal)
        imInterestedButton.titleLabel?.textColor = .white
        imInterestedButton.backgroundColor = UIColor.greyBackgroundColor
        imInterestedButton.layer.cornerRadius = 4.0
        imInterestedButton.clipsToBounds = true
        imInterestedButton.translatesAutoresizingMaskIntoConstraints = false
        return imInterestedButton
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        discoveryCollectionView.backgroundColor = .clear
        // Do any additional setup after loading the view.
        discoveryCollectionView.delegate = self
        discoveryCollectionView.dataSource = self
        
        
        discoveryCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: mapCellIdentifier)
        discoveryCollectionView.register(UINib.init(nibName: String.init(describing: DiscoveryDetailsCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: detailsCellIdentifier)
        discoveryCollectionView.register(UINib.init(nibName: String.init(describing: DiscoveryImagesCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: imagesCellIdentifier)
        discoveryCollectionView.register(UINib.init(nibName: String.init(describing: DiscoveryUserProfileCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: profileCellIdentifier)
        
        
        
        
        gmsMap = GMSMapView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: mapCellHeight * 2.0))
        gmsMap.isUserInteractionEnabled = false
        
        let position = CLLocationCoordinate2D(latitude: -33.8683, longitude: 151.2086)
        let marker = GMSMarker(position: position)
        marker.title = "Hello World"
        marker.map = gmsMap
        
        let camera = GMSCameraPosition.camera(withLatitude: position.latitude - 0.005, longitude: position.longitude, zoom: 15)
        gmsMap.camera = camera
        
        self.view.insertSubview(gmsMap, belowSubview: discoveryCollectionView)
        
        var bottomPadding: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            if let bottom = window?.safeAreaInsets.bottom {
                bottomPadding = bottom
            }
        }
        
        let imInterstedView = UIView.init(frame: CGRect.init(x: 0.0, y: self.view.frame.size.height - 70.0 - bottomPadding, width: self.view.frame.size.width, height: 70.0))
        imInterstedView.backgroundColor = UIColor.white
        
        imInterstedView.layer.shadowColor = UIColor.black.cgColor
        imInterstedView.layer.shadowOpacity = 1
        imInterstedView.layer.shadowOffset = CGSize.zero
        imInterstedView.layer.shadowRadius = 10
        
        var shadowRect = imInterstedView.bounds.insetBy(dx: 0.0, dy: 20.0)
        shadowRect.origin.y -= 20.0
        imInterstedView.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        
        self.imInterestedButton.frame = CGRect.init(x: 196.0, y: 10.0, width: 166.0, height: 46.0)
        
        
        imInterstedView.addSubview(imInterestedButton)
        
        let numOfReplies = UILabel.init(frame: CGRect.init(x: 19.0, y: 10.0, width: 129.0, height: 50.0))

        numOfReplies.text = "Be the first one to reply!"
        numOfReplies.numberOfLines = 3
        numOfReplies.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        numOfReplies.adjustsFontSizeToFitWidth = true
        numOfReplies.translatesAutoresizingMaskIntoConstraints = false

        imInterstedView.addSubview(numOfReplies)
        
        
        imInterestedButton.trailingAnchor.constraint(equalTo: imInterstedView.layoutMarginsGuide.trailingAnchor, constant: -8.0).isActive = true
        imInterestedButton.topAnchor.constraint(equalTo: imInterstedView.layoutMarginsGuide.topAnchor, constant: 10.0).isActive = true
        //imInterestedButton.heightAnchor.constraint(equalTo: imInterestedButton.widthAnchor, multiplier: 1.0/5.0).isActive = true
        //imInterestedButton.bottomAnchor.constraint(equalTo: imInterstedView.layoutMarginsGuide.bottomAnchor, constant: -10.0)
        imInterestedButton.widthAnchor.constraint(equalTo: imInterestedButton.heightAnchor, multiplier: 166.0 / 46.0).isActive = true
        //imInterestedButton.addConstraint(NSLayoutConstraint.init(item: imInterestedButton, attribute: .height, relatedBy: .equal, toItem: imInterestedButton, attribute: .width, multiplier: imInterestedButton.frame.size.height / imInterestedButton.frame.size.width, constant: 0.0))
        
        numOfReplies.leadingAnchor.constraint(equalTo: imInterstedView.layoutMarginsGuide.leadingAnchor, constant: 12.0).isActive = true
        numOfReplies.topAnchor.constraint(equalTo: imInterstedView.layoutMarginsGuide.topAnchor, constant: 10.0).isActive = true
        numOfReplies.bottomAnchor.constraint(equalTo: imInterstedView.layoutMarginsGuide.bottomAnchor, constant: -10.0).isActive = true
        
        numOfReplies.trailingAnchor.constraint(equalTo: imInterestedButton.leadingAnchor, constant: -10.0).isActive  = true

        let imInterestedTap = UITapGestureRecognizer.init(target: self, action: #selector(userDidTapImInterested))
        
        imInterestedButton.addGestureRecognizer(imInterestedTap)
        
        statusBarView.frame = UIApplication.shared.statusBarFrame
        statusBarView.backgroundColor = .clear
        self.view.insertSubview(statusBarView, aboveSubview: discoveryCollectionView)
        
        self.navigationBarShadow.frame = CGRect.init(x: 0.0, y: (self.navigationController?.navigationBar.frame.size.height)!, width: self.view.frame.size.height, height: 0.5)
        self.navigationBarShadow.backgroundColor = .clear
        self.navigationController?.navigationBar.addSubview(self.navigationBarShadow)
        
        self.view.insertSubview(imInterstedView, aboveSubview: discoveryCollectionView)
        
        setupNavigationBar()
    }
    
    @objc func userDidTapImInterested() {
        print("Im interested did tap")
    }
    
    var saveButton = UIBarButtonItem()
    var shareButton = UIBarButtonItem()
    var moreActions = UIBarButtonItem()
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        if discoverySaved {
            self.saveButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "save_icon_fill"), style: .plain, target: self, action: #selector(userDidTapSave))
        } else {
            self.saveButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "save_icon_empty"), style: .plain, target: self, action: #selector(userDidTapSave))
        }
        
        self.shareButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "share_icon"), style: .plain, target: self, action: #selector(userDidTapShare))
        self.moreActions = UIBarButtonItem.init(image: #imageLiteral(resourceName: "more_icon"), style: .plain, target: self, action: #selector(userDidTapMore))
        
        saveButton.tintColor = UIColor.black
        shareButton.tintColor = UIColor.black
        moreActions.tintColor = UIColor.black
        
        let backButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_grey"), style: .plain, target: self, action: #selector(userDidTapBack))
        
        backButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItems = [moreActions, shareButton, saveButton ]
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    
    
    @objc func userDidTapSave() {
        
        
        if discoverySaved {
            saveButton.image = #imageLiteral(resourceName: "save_icon_empty")
            discoverySaved = false
        } else {
            saveButton.image = #imageLiteral(resourceName: "save_icon_fill")
            discoverySaved = true
        }
        
        
        print("Add to saved items")
    }
    
    @objc func userDidTapShare() {
        
        
        print("Share this ad")
    }
    
    @objc func userDidTapMore() {
        
        let alertVC = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let flagOption = UIAlertAction.init(title: "Report Discovery", style: .destructive) { (didShow) in
            print("Flag this listing")
        }
        
        let cancelOption = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(flagOption)
        alertVC.addAction(cancelOption)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func userDidTapBack() {
        print("Back pressed")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension MyDiscoveryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let mapCell = collectionView.dequeueReusableCell(withReuseIdentifier: mapCellIdentifier, for: indexPath)
            mapCell.backgroundColor = .clear
            
            return mapCell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailsCellIdentifier, for: indexPath) as! DiscoveryDetailsCollectionViewCell
            cell.priceLabel.text = "$ 90"
            cell.timeAwayLabel.text = "10 mins away"
            cell.descriptionLabel.text = "I’m looking for someone to come and clean my dorm room, its dirty and messy! Willing to pay $90."
            cell.descriptionLabel.sizeToFit()
            return cell
        } else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imagesCellIdentifier, for: indexPath) as! DiscoveryImagesCollectionViewCell
            
            return cell
            
        } else if indexPath.row == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileCellIdentifier, for: indexPath) as! DiscoveryUserProfileCollectionViewCell
            cell.userImageView.image = #imageLiteral(resourceName: "larry_avatar")
            cell.userFirstNameLabel.text = "Adriana"
            cell.userUniversityLabel.text = "Stanford University"
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            return CGSize.init(width: collectionView.frame.size.width, height: mapCellHeight)
        } else if indexPath.row == 1 {
             return CGSize.init(width: collectionView.frame.size.width, height: 250.0)
        } else if indexPath.row == 2 {
            return CGSize.init(width: collectionView.frame.size.width, height: 400.0)
        } else if indexPath.row == 3 {
            return CGSize.init(width: collectionView.frame.size.width, height: profileCellHeight)
        }
        
        return CGSize.init(width: collectionView.frame.size.width, height: 80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("selected Map")
        } else {
            print("selected some other cell")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("Scrollview did scroll")
        
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
        }
        
        let scrollOffsetY = scrollView.contentOffset.y;
        
        if(scrollOffsetY <= 0.0)
        {
            
            //gmsMap.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
            //print(scrollOffsetY)
            //print("Pulling down")
            
            let translate = CGAffineTransform(translationX: 0, y: scrollView.contentOffset.y/3.0);
            let orgHeight: CGFloat = mapCellHeight;
            let scaleFactor = (orgHeight - scrollView.contentOffset.y) / orgHeight;
            let translateAndZoom = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
            gmsMap.transform = translateAndZoom;
            
            
        }
        else if(scrollOffsetY > scrollView.contentSize.height - scrollView.frame.size.height)
        {
            //print("Pulling up")
        }
        
        var offset = scrollView.contentOffset.y / (mapCellHeight - self.topbarHeight)
        print(offset)
        if offset > 1 {
            offset = 1
            self.navigationController?.navigationBar.backgroundColor = UIColor.white.withAlphaComponent(offset)
            self.statusBarView.backgroundColor = UIColor.white.withAlphaComponent(offset)
            self.navigationBarShadow.backgroundColor = UIColor.contentDivider.withAlphaComponent(offset)
        } else {
            self.navigationController?.navigationBar.backgroundColor = UIColor.white.withAlphaComponent(offset)
            self.statusBarView.backgroundColor = UIColor.white.withAlphaComponent(offset)
            self.navigationBarShadow.backgroundColor = UIColor.contentDivider.withAlphaComponent(offset)
        }
    }
    
}

extension UINavigationBar {
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}
