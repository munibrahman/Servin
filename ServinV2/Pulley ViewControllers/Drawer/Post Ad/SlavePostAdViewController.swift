//
//  SlavePostAdViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-06-07.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Pulley
import TLPhotoPicker

class SlavePostAdViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setupSegmantationControl()
    }
    
    func setupSegmantationControl() {
        offerRequestSegmentedControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }
    
    @objc func segmentValueChanged(sender: Any?) {
        
        print("segment value changed")
        
        switch offerRequestSegmentedControl.selectedIndex {
        case 0:
            print("Offer")
            
        default:
            print("Requests")
            
        }
        
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
        
//        let border = CALayer()
//        let width = CGFloat(1.0)
//        border.borderColor = UIColor.darkGray.cgColor
//        border.frame = CGRect(x: 0, y: descriptionTextField.frame.size.height - width, width:  descriptionTextField.frame.size.width, height: descriptionTextField.frame.size.height)
//
//        border.borderWidth = width
//        descriptionTextField.layer.addSublayer(border)
//        descriptionTextField.layer.masksToBounds = true
        
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
//        self.scrollViewSuperView.frame = CGRect.init(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height + 1000.0)
//
//        self.scrollViewSuperView.layoutIfNeeded()
        
//        self.scrollViewSuperView.frame.size.height = 2000.0
        
        //scrollView.contentSize = contentRect.size
        
        //self.scrollView.resizeScrollViewContentSize()
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


extension SlavePostAdViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
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


extension SlavePostAdViewController : PulleyDrawerViewControllerDelegate, UIScrollViewDelegate {
    
    
    
    // The post ad view controller will only be allowed to be partially revealed and all the way open.
    func supportedDrawerPositions() -> [PulleyPosition] {
        return [PulleyPosition.partiallyRevealed, PulleyPosition.open, ]
    }
    
    
    // We will change the partial height to 2/3 of the screen, this way it will be long enough.
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        
        return UIScreen.main.bounds.size.height * (2/3)
        
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        
        if drawer.drawerPosition == PulleyPosition.partiallyRevealed {
            self.scrollView.isScrollEnabled = false
        } else {
            self.scrollView.isScrollEnabled = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //disable bounce only at the top of the screen
        scrollView.bounces = scrollView.contentOffset.y > 100
    }
    
    
}

extension SlavePostAdViewController: TLPhotosPickerViewControllerDelegate {
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


extension SlavePostAdViewController: TLPhotosPickerLogDelegate {
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

class UIPlaceHolderTextView: UITextView {
    
    
    //MARK: - Properties
    @IBInspectable var placeholder: String?
    @IBInspectable var placeholderColor: UIColor?
    var placeholderLabel: UILabel?
    
    
    //MARK: - Initializers
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Use Interface Builder User Defined Runtime Attributes to set
        // placeholder and placeholderColor in Interface Builder.
        if self.placeholder == nil {
            self.placeholder = ""
        }
        
        if self.placeholderColor == nil {
            self.placeholderColor = UIColor.placeHolderColor
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
    }
    
    @objc func textChanged(_ notification: Notification) -> Void {
        if self.placeholder?.count == 0 {
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            if self.text.count == 0 {
                self.viewWithTag(999)?.alpha = 1
            }
            else {
                self.viewWithTag(999)?.alpha = 0
            }
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if (self.placeholder?.count ?? 0) > 0 {
            if placeholderLabel == nil {
                placeholderLabel = UILabel.init()
                placeholderLabel?.lineBreakMode = .byWordWrapping
                placeholderLabel?.numberOfLines = 0
                placeholderLabel?.font = self.font
                placeholderLabel?.backgroundColor = self.backgroundColor
                placeholderLabel?.textColor = self.placeholderColor
                placeholderLabel?.alpha = 0
                placeholderLabel?.tag = 999
                
                self.addSubview(placeholderLabel!)
                
                placeholderLabel?.translatesAutoresizingMaskIntoConstraints = false
                placeholderLabel?.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
                placeholderLabel?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
                placeholderLabel?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                placeholderLabel?.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            }
            
            placeholderLabel?.text = self.placeholder
            placeholderLabel?.sizeToFit()
            self.sendSubview(toBack: self.placeholderLabel!)
        }
        
        if self.text.count == 0 && (self.placeholder?.count ?? 0) > 0 {
            self.viewWithTag(999)?.alpha = 1
        }
    }
}




