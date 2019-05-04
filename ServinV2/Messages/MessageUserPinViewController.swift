import UIKit
import GoogleMaps
import AWSMobileClient

// The following view controller displays the pin (discovery) of another user on the network.
// To display one's own pin, use MyDiscoveryViewController instead
// This view controller is very similar to UserDiscoveryViewController but it allows different actions to be taken
// The discovery object is also different along with what is shown to the user and what isn't.
// TODO: In the future, come back here and change this view controller to subclass UserDiscoveryViewController
class MessageUserPinViewController: UIViewController {
    
    var discoveryCollectionView: UICollectionView!
    
    let mapCellHeight: CGFloat = 300.0
    let profileCellHeight: CGFloat = 77.0
    
    let mapCellIdentifier = "MapCell"
    let detailsCellIdentifier = "DetailsCell"
    let imagesCellIdentifier = "ImagesCell"
    let profileCellIdentifier = "ProfileCell"
    let emptyCellIdentifier = "EmptyCell"
    
    var gmsMap: GMSMapView!
    
    var statusBarView = UIView()
    var navigationBarShadow = UIView()
    
    var discovery: MeQuery.Data.Me.Conversation.UserConversation.Conversation.Discovery?
    
    // TODO: Retrieve if this discovery has been saved by the user or not
    var discoverySaved = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View didload called")
        
        self.view.backgroundColor = .white
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        
        discoveryCollectionView = UICollectionView.init(frame: self.view.frame, collectionViewLayout: flowLayout)
        discoveryCollectionView.showsHorizontalScrollIndicator = false
        
        
        self.view.addSubview(discoveryCollectionView)
        
        setupMap()
        
        let layoutMarginsGuide = self.view.safeAreaLayoutGuide
        
        
        discoveryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        discoveryCollectionView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        discoveryCollectionView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        discoveryCollectionView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        discoveryCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
        
        
        discoveryCollectionView.backgroundColor = .clear
        // Do any additional setup after loading the view.
        discoveryCollectionView.delegate = self
        discoveryCollectionView.dataSource = self
        
        
        discoveryCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: mapCellIdentifier)
        discoveryCollectionView.register(DiscoveryDetailsCollectionViewCell.self, forCellWithReuseIdentifier: detailsCellIdentifier)
        discoveryCollectionView.register(UINib.init(nibName: String.init(describing: DiscoveryImagesCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: imagesCellIdentifier)
        discoveryCollectionView.register(UINib.init(nibName: String.init(describing: DiscoveryUserProfileCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: profileCellIdentifier)
        discoveryCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: emptyCellIdentifier)
        
        
        
        var bottomPadding: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            if let bottom = window?.safeAreaInsets.bottom {
                bottomPadding = bottom
            }
        }
        
        
        statusBarView.frame = UIApplication.shared.statusBarFrame
        statusBarView.backgroundColor = .clear
        self.view.insertSubview(statusBarView, aboveSubview: discoveryCollectionView)
        
        self.navigationBarShadow.frame = CGRect.init(x: 0.0, y: (self.navigationController?.navigationBar.frame.size.height)!, width: self.view.frame.size.height, height: 0.5)
        self.navigationBarShadow.backgroundColor = .clear
        self.navigationController?.navigationBar.addSubview(self.navigationBarShadow)
        
        
        setupNavigationBar()
    }
    
    
    func setupMap() {
        gmsMap = GMSMapView.init(frame: self.view.bounds)
        gmsMap.isUserInteractionEnabled = false
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                gmsMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        // TODO: Get location of the pin
        if let lat = discovery?.latitude, let long = discovery?.longitude {
            let position = CLLocationCoordinate2D(latitude: lat, longitude:  long)
            let marker = GMSMarker(position: position)
            marker.title = "Hello World"
            marker.map = gmsMap

            let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 15)
            gmsMap.camera = camera
            gmsMap.isMyLocationEnabled = true
        }

        
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            
            gmsMap.padding = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: self.view.frame.size.height - mapCellHeight - self.topbarHeight - (bottomPadding ?? 0.0), right: 0.0)
            
        } else {
            gmsMap.padding = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: self.view.frame.size.height - mapCellHeight - self.topbarHeight - 0.0, right: 0.0)
            
        }
        
        
        self.view.insertSubview(gmsMap, belowSubview: discoveryCollectionView)
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
        
        let leftButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_grey"), style: .plain, target: self, action: #selector(userDidTapBack))
        
        self.navigationItem.leftBarButtonItem = leftButtonItem
        
        self.navigationItem.rightBarButtonItems = [moreActions, shareButton, saveButton ]
        
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
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func userDidTapMap() {
        let vc = DiscoveryFullScreenMapViewController()
        // TODO: Get location of the discovery
        if let lat = discovery?.latitude, let long = discovery?.longitude {
            vc.position = CLLocationCoordinate2D(latitude: lat, longitude:  long)
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func userDidTapProfile() {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String.init(describing: UserProfileViewController.self)) as! UserProfileViewController
        
        vc.person = discovery?.author
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - ScrollView Offset Appear/Dissapear
    
    // This variable keeps track of the last used offset for the scroll view, when a view appears, this value is used
    //
    var latestScrollOffset: CGFloat = 0.0
    
    // When the view will appear, we will animate the top bar based on how far the user has scrolled.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white.withAlphaComponent(latestScrollOffset)
        self.statusBarView.backgroundColor = UIColor.white.withAlphaComponent(latestScrollOffset)
        self.navigationBarShadow.backgroundColor = UIColor.contentDivider.withAlphaComponent(latestScrollOffset)
    }
    
    // When the view will dissapear, it will remove the offset entirely.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        self.statusBarView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        self.navigationBarShadow.backgroundColor = UIColor.contentDivider.withAlphaComponent(0.0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("Scrollview did scroll")
        
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
        }
        
        let scrollOffsetY = scrollView.contentOffset.y;
        
        if(scrollOffsetY <= 0.0)
        {
            
            
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
        
        latestScrollOffset = offset
        
        print(offset)
        if offset > 1 {
            offset = 1
            latestScrollOffset = offset
            self.navigationController?.navigationBar.backgroundColor = UIColor.white.withAlphaComponent(offset)
            self.statusBarView.backgroundColor = UIColor.white.withAlphaComponent(offset)
            self.navigationBarShadow.backgroundColor = UIColor.contentDivider.withAlphaComponent(offset)
        } else {
            self.navigationController?.navigationBar.backgroundColor = UIColor.white.withAlphaComponent(offset)
            self.statusBarView.backgroundColor = UIColor.white.withAlphaComponent(offset)
            self.navigationBarShadow.backgroundColor = UIColor.contentDivider.withAlphaComponent(offset)
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


// MARK: - CollectionView

extension MessageUserPinViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // return 4 items since the very bottom cell doesn't need to be shown
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.discovery?.author?.userId == AWSMobileClient.sharedInstance().username {
            print("My own discovery")
            return 3
        }
        return 4
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
            
            cell.priceLabel.text = "$ \(discovery?.price ?? 0)"
            cell.titleLabel.text = discovery?.title
            cell.descriptionLabel.text = discovery?.description
            
            
            cell.priceLabel.sizeToFit()
            cell.titleLabel.sizeToFit()
            cell.timeAwayLabel.sizeToFit()
            cell.descriptionLabel.sizeToFit()
            
            return cell
        } else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imagesCellIdentifier, for: indexPath) as! DiscoveryImagesCollectionViewCell
            // Pass in the discovery, cell will do the rest.
            if let snapshot = self.discovery?.snapshot {
                cell.discovery = GetSurroundingDiscoveriesQuery.Data.GetSurroundingDiscovery.init(snapshot: snapshot)
            }
            
            return cell
            
        } else if indexPath.row == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileCellIdentifier, for: indexPath) as! DiscoveryUserProfileCollectionViewCell
            
            if let firstName = discovery?.author?.givenName {
                cell.userFirstNameLabel.text = firstName
            } else {
                cell.userFirstNameLabel.text = "Servin User"
            }
            
            if let author = discovery?.author, let profileImageUrl = author.profilePic, let key = profileImageUrl.ICONImageKeyS3() {
                cell.userImageView.loadImageUsingS3Key(key: key )
                
            }
            
            cell.userUniversityLabel.text = discovery?.author?.school
            

            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellIdentifier, for: indexPath)
        
        cell.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Map cell
        if indexPath.row == 0 {
            return CGSize.init(width: collectionView.frame.size.width, height: mapCellHeight)
        }
            // Detail cell
        else if indexPath.row == 1 {
            
            let size = CGSize.init(width: collectionView.frame.size.width - 16.0, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            let estimatedTitleFrame = NSString.init(string: discovery?.title ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30, weight: .semibold)], context: nil)
            
            let estimatedPriceFrame = NSString.init(string: "$ \(discovery?.price ?? 0)").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30, weight: .medium)], context: nil)
            
            let estimatedTimeFrame = NSString.init(string: "10 mins away").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .light)], context: nil)
            
            let estimatedDescriptionFrame = NSString.init(string: discovery?.description ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium)], context: nil)
            
            
            return CGSize.init(width: collectionView.frame.size.width, height: estimatedTitleFrame.height + estimatedPriceFrame.height + estimatedTimeFrame.height + estimatedDescriptionFrame.height + 60.0)
            
        }
            // Image cell
        else if indexPath.row == 2 {
            return CGSize.init(width: collectionView.frame.size.width, height: 400.0)
        }
            // Profile cell
        else if indexPath.row == 3 {
            return CGSize.init(width: collectionView.frame.size.width, height: profileCellHeight)
        }
        
        return CGSize.init(width: collectionView.frame.size.width, height: 80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("selected Map")
            self.userDidTapMap()
        } else if indexPath.row == 3 {
            self.userDidTapProfile()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
}
