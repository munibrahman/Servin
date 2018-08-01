//
//  SavedPinsViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-06-25.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class SavedPinsViewController: UIViewController {
    
    let reuseIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupNavigationController()
        
        setupCollectionView()

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
        
        let layout = UICollectionViewFlowLayout.init()
        layout.estimatedItemSize = CGSize.init(width: view.frame.size.width, height: 220.0)
        layout.sectionInset = UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView.init(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView.register(SavedPinsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        self.view.addSubview(collectionView)
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SavedPinsCollectionViewCell
        cell.pinImageView.image = #imageLiteral(resourceName: "1")
        cell.pinTitle.text = "Learn to kayak like a pro"
        cell.pinPrice.text = "$ 100"
        cell.timeAway.text = "3 mins away"
        return cell
    }
    
}


class SavedPinsCollectionViewCell: UICollectionViewCell {
    
    var pinImageView: UIImageView!
    var pinTitle: UILabel!
    var pinPrice: UILabel!
    var timeAway: UILabel!
    var isSaved: Bool = false
    
    var savedView: SaveIconView!
    
    let leftPadding: CGFloat = 20.0
    let rightPadding: CGFloat = 20.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        pinImageView = UIImageView.init()
        
        self.addSubview(pinImageView)
        
        pinImageView.translatesAutoresizingMaskIntoConstraints = false
        pinImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: leftPadding).isActive = true
        pinImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        pinImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -rightPadding).isActive = true
        pinImageView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        
        pinImageView.layer.cornerRadius = 5.0
        pinImageView.clipsToBounds = true
        pinImageView.contentMode = .scaleAspectFill
        
        pinTitle = UILabel.init()
        
        self.addSubview(pinTitle)
        
        pinTitle.translatesAutoresizingMaskIntoConstraints = false
        pinTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: leftPadding).isActive = true
        pinTitle.topAnchor.constraint(equalTo: pinImageView.bottomAnchor).isActive = true
        pinTitle.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        pinTitle.adjustsFontSizeToFitWidth = true
        pinTitle.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        pinTitle.textColor = UIColor.blackFontColor
        
        
        pinPrice = UILabel.init()
        self.addSubview(pinPrice)
        
        pinPrice.translatesAutoresizingMaskIntoConstraints = false
        pinPrice.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: leftPadding).isActive = true
        pinPrice.topAnchor.constraint(equalTo: pinTitle.bottomAnchor).isActive = true
        pinPrice.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -rightPadding).isActive = true
        pinPrice.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        pinPrice.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        pinPrice.textColor = UIColor.blackFontColor.withAlphaComponent(0.7)
        
        timeAway = UILabel.init()
        
        self.addSubview(timeAway)
        
        timeAway.translatesAutoresizingMaskIntoConstraints = false
        timeAway.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: leftPadding).isActive = true
        timeAway.topAnchor.constraint(equalTo: pinPrice.bottomAnchor).isActive = true
        timeAway.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -rightPadding).isActive = true
        timeAway.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        timeAway.font = UIFont.systemFont(ofSize: 13, weight: .light)
        timeAway.textColor = UIColor.blackFontColor.withAlphaComponent(0.3)
        
        savedView = SaveIconView.init(frame: CGRect.init(x: 20, y: 0, width: 40, height: 40))
        self.addSubview(savedView)
        
        savedView.translatesAutoresizingMaskIntoConstraints = false
        savedView.centerXAnchor.constraint(equalTo: pinImageView.trailingAnchor, constant: -13).isActive = true
        savedView.centerYAnchor.constraint(equalTo: pinImageView.bottomAnchor).isActive = true
        savedView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        savedView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        pinTitle.trailingAnchor.constraint(equalTo: savedView.leadingAnchor).isActive = true
        
        
        
        let saveTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(userDidTapSave))
        
        savedView.addGestureRecognizer(saveTapGesture)
        
        savedView.saveIcon.image = #imageLiteral(resourceName: "save_icon_empty")
    }
    
    @objc func userDidTapSave() {
        print("Did tap save")
        
        changeSavedState(isSaved: isSaved)
        
        isSaved = !isSaved
        
        
        
    }
    
    func changeSavedState(isSaved: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.savedView.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
            if isSaved {
                self.savedView.saveIcon.image = #imageLiteral(resourceName: "save_icon_empty")
            } else {
                self.savedView.saveIcon.image = #imageLiteral(resourceName: "save_icon_fill")
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























