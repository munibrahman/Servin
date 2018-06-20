//
//  EditDiscoveryViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-06-19.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import TLPhotoPicker
import GoogleMaps


// TODO: Finish impleneting this VC after myPins have been completed.

class EditDiscoveryViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    //TODO: Come here and clean everything up, especially the segmented control and fix the collectionview for ALL screens!...
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var descriptionTextField: UIPlaceHolderTextView!
    
    @IBOutlet var imageTitleLabel: UILabel!
    
    @IBOutlet var offerRequestSegmentedControl: SegmentedControl!
    
    @IBOutlet var scrollView: UIScrollView!
    
    
    @IBOutlet var contentView: UIView!
    
    
    var selectedAssets = [TLPHAsset]()
    
    var myCollectionView: UICollectionView!
    
    var defaultImageArray = [#imageLiteral(resourceName: "default_image_icon"), #imageLiteral(resourceName: "default_image_icon"), #imageLiteral(resourceName: "default_image_icon"), #imageLiteral(resourceName: "default_image_icon"),#imageLiteral(resourceName: "default_image_icon"), #imageLiteral(resourceName: "default_image_icon")]
    
    @IBOutlet var superviewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var collectionViewXIB: UIView!
    
    @IBOutlet var gmsMapView: GMSMapView!
    
    let gmsMapViewHeight: CGFloat = 250.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupNavigationBar()
        setupSegmantationControl()
        setupMap()
        
        titleTextField.delegate = self
        priceTextField.delegate = self
        descriptionTextField.delegate = self
        
        
    }
    
    func setupSegmantationControl() {
        offerRequestSegmentedControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }
    
    func setupNavigationBar() {
        if self.navigationController == nil {
            fatalError("This VC must be presented inside a NavigationViewController")
        }
        
        let backButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_grey"), style: .plain, target: self, action: #selector(userDidTapBack))
        backButton.tintColor = .black
        
        let saveButton = UIBarButtonItem.init(title: "Save", style: .plain, target: self, action: #selector(userDidTapSave))
        saveButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func userDidTapBack() {
        if textInputChanged {
            
            let alertViewController = UIAlertController.init(title: "If you exit now, your edits won't be saved.", message: "" , preferredStyle: .alert)
            
            
            // Don't do anything, just go back to editing.
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
                print("cancel pressed")
                
            })
            
            
            // Leave the current VC then
            let exitAction = UIAlertAction.init(title: "Exit", style: .destructive, handler: { (action) in
                print("exit pressed")
                self.navigationController?.popViewController(animated: true)
            })
            
            alertViewController.addAction(cancelAction)
            alertViewController.addAction(exitAction)
            
            self.present(alertViewController, animated: true, completion: nil)
            
            
        } else {
            // Don't do anything, just dismiss the VC
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc func userDidTapSave() {
        print("Save it here")
        // TODO: Save user's stuff here
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func segmentValueChanged(sender: Any?) {
        
        print("segment value changed")
        textInputChanged = true
        
        
        switch offerRequestSegmentedControl.selectedIndex {
        case 0:
            print("Offer")
            
        default:
            print("Requests")
            
        }
        
    }
    
    
    func setupMap() {
        let mapTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(userDidTapMap))
        
        gmsMapView.settings.tiltGestures = false
        gmsMapView.settings.rotateGestures = false
        gmsMapView.settings.zoomGestures = false
        gmsMapView.settings.scrollGestures = false
        
        gmsMapView.addGestureRecognizer(mapTapGesture)
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                gmsMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        let position = CLLocationCoordinate2D(latitude: 51.075477, longitude:  -114.137113)
        let marker = GMSMarker(position: position)
        marker.map = gmsMapView
        marker.isDraggable = true
        
        let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 15)
        
        gmsMapView.camera = camera
        
    }
    
    @objc func userDidTapMap() {
        print("User did tap map")
    }
    
    var viewsHaveBeenSetup = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear")
        
        if viewsHaveBeenSetup {
            
        } else {
            setupViews()
            viewsHaveBeenSetup = true
        }
        
    }
    
    func setupViews() {
        titleTextField.addBottomBorderWithColor(color: UIColor.blackFontColor, width: 1.0)
        priceTextField.addBottomBorderWithColor(color: UIColor.blackFontColor, width: 1.0)
        
        titleTextField.backgroundColor = .clear
        priceTextField.backgroundColor = .clear
        descriptionTextField.textContainer.lineFragmentPadding = 0
        
        titleTextField.placeholder = "e.g. Tutor for hire"
        priceTextField.placeholder = "Price"
        descriptionTextField.placeholder = "Description"
        descriptionTextField.placeholderColor = UIColor.placeHolderColor
        
        priceTextField.leftView = UIImageView.init(image: #imageLiteral(resourceName: "dollar_sign_icon"))
        priceTextField.leftViewMode = .always
        
        
        let numberOfCellsPerRow: CGFloat = 3
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
        let cellWidth = (collectionViewXIB.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        
        flowLayout.scrollDirection = .vertical
        
        
        
        myCollectionView = UICollectionView(frame:
            collectionViewXIB.frame, collectionViewLayout: flowLayout)
        
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        myCollectionView.register(UINib.init(nibName: "PostAdImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        myCollectionView.backgroundColor = .clear
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.showsVerticalScrollIndicator = false
        
        myCollectionView.isScrollEnabled = false
        
        
        imageTitleLabel.superview?.addSubview(myCollectionView)
        
        self.scrollView.delegate = self
        
        let collectionViewYBottom = self.collectionViewXIB.frame.origin.y + self.collectionViewXIB.frame.size.height
        
        let spaceNeededForScrollView = collectionViewYBottom - self.view.frame.size.height
        
        var extraPadding: CGFloat = 10.0
        
        if let mySuperview = self.parent as? MasterPulleyViewController {
            extraPadding = extraPadding + mySuperview.topInset
        } else {
            extraPadding = 60.0
        }
        
        superviewHeightConstraint.constant = spaceNeededForScrollView + extraPadding
        self.view.layoutIfNeeded()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        
        if offset.y < 0.0 {
            var transform = CATransform3DTranslate(CATransform3DIdentity, 0, offset.y, 0)
            let scaleFactor = 1 + (-1 * offset.y / (gmsMapViewHeight / 2))
            transform = CATransform3DScale(transform, scaleFactor, scaleFactor, 1)
            gmsMapView.layer.transform = transform
        } else {
            gmsMapView.layer.transform = CATransform3DIdentity
        }
    }
    
    
    // This boolean value keeps track of the user's changes on any textfields/textviews and is then used to ask the user whether they would like to discard the changes or not.
    var textInputChanged = false
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Textfield started editing")
        textInputChanged = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textInputChanged = true
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


extension EditDiscoveryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PostAdImageCollectionViewCell
        cell?.backgroundColor = .clear
        cell?.imageView.image = defaultImageArray[indexPath.row]
        cell?.imageView.contentMode = .scaleAspectFill
        cell?.layer.cornerRadius = 3.0
        cell?.clipsToBounds = true
        cell?.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let viewController = CustomPhotoPickerViewController()
        viewController.delegate = self
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showExceededMaximumAlert(vc: picker)
        }
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.maxSelectedAssets = 6
        configure.allowedLivePhotos = true
        configure.allowedVideo = false
        configure.allowedVideoRecording = false
        configure.nibSet = (nibName: "CustomCell_Instagram", bundle: Bundle.main)
        viewController.configure = configure
        viewController.selectedAssets = self.selectedAssets
        viewController.logDelegate = self
        
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    
}


extension EditDiscoveryViewController: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        
        defaultImageArray = [#imageLiteral(resourceName: "default_image_icon"), #imageLiteral(resourceName: "default_image_icon"), #imageLiteral(resourceName: "default_image_icon"), #imageLiteral(resourceName: "default_image_icon"),#imageLiteral(resourceName: "default_image_icon"), #imageLiteral(resourceName: "default_image_icon")]
        
        print("Im called in here")
        print(withTLPHAssets.count)
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets
        
        var index = 0;
        for eachImage in withTLPHAssets {
            defaultImageArray.insert(eachImage.fullResolutionImage!, at: index)
            index = index + 1
        }
        
        myCollectionView.reloadData()
        
    }
    
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        picker.dismiss(animated: true) {
            let alert = UIAlertController(title: "", message: "Album permissions not granted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        let alert = UIAlertController(title: "", message: "Camera permissions not granted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        picker.present(alert, animated: true, completion: nil)
    }
    
    func showExceededMaximumAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "", message: "You have reached the maximum count of possible images", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}


extension EditDiscoveryViewController: TLPhotosPickerLogDelegate {
    //For Log User Interaction
    func selectedCameraCell(picker: TLPhotosPickerViewController) {
        print("selectedCameraCell")
    }
    
    func selectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        print("selectedPhoto")
    }
    
    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        print("deselectedPhoto")
    }
    
    func selectedAlbum(picker: TLPhotosPickerViewController, title: String, at: Int) {
        print("selectedAlbum")
    }
}
