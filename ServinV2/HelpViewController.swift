//
//  HelpViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-05.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    var helpCollectionView: UICollectionView!
    
    var questionsArray = ["What are Pins?", "How to drop a pin?", "How to setup my payment info", "What are Servin points", "I can't see my pin anymore", "Payment Methods", "Coupons and Credits", "Lorem Ipsum", "Doset Amit"]
    let headerID = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationController()
        
        setupCollectionView()
    }
    
    func setupNavigationController() {
        
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc func barButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.headerReferenceSize = CGSize.init(width: self.view.frame.size.width, height: 30.0)
        
        helpCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        helpCollectionView.backgroundColor = .clear
        
        helpCollectionView.delegate = self
        helpCollectionView.dataSource = self
        
        
        self.view.addSubview(helpCollectionView)
        
        helpCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        helpCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        helpCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12.0).isActive = true
        helpCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        helpCollectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        
        helpCollectionView.register(TextCell.self, forCellWithReuseIdentifier: "cell")
        helpCollectionView.register(HorizontalCollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        helpCollectionView.register(QuestionsCollectionViewCell.self, forCellWithReuseIdentifier: "questionsCell")
        
        
        helpCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.headerID)
        // if you don't do something about header size...
        // ...you won't see any headers
        
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

extension HelpViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return questionsArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        // Hello!
        if indexPath.section == 0 {
            return CGSize.init(width: collectionView.frame.size.width, height: 75.0)
        }
            
        // What can we assist you with and the horizontal collectionview
        else if indexPath.section == 1 {
            return CGSize.init(width: collectionView.frame.size.width, height: 135.0)
        }
        
            // Rest of the questions
        else if indexPath.section == 2 {
            return CGSize.init(width: collectionView.frame.size.width, height: 44.0)
        }
        
        return CGSize.init(width: collectionView.frame.size.width, height: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)
            cell.backgroundColor = .clear
            return cell
        }
        
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "questionsCell", for: indexPath) as! QuestionsCollectionViewCell
            cell.questionLabel.text = questionsArray[indexPath.row]
            cell.backgroundColor = .white
            return cell
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var v : UICollectionReusableView! = nil
        if kind == UICollectionElementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID, for: indexPath)
            if v.subviews.count == 0 {
                v.addSubview(UILabel(frame:CGRect.init(x: 0, y: 20, width: collectionView.frame.size.width, height: 30)))
            }
            
            let lab = v.subviews[0] as! UILabel
            lab.text = "Frequently Asked Questions"
            lab.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            lab.textColor = UIColor.blackFontColor.withAlphaComponent(0.3)
        }
        return v
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 2 {
            return CGSize.init(width: collectionView.frame.size.width, height: 50.0)
        } else {
            return CGSize.zero
        }
    }

    
}


class TextCell: UICollectionViewCell {
    
    var helloLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 45.0, weight: .semibold)
        label.textColor = UIColor.blackFontColor
        label.text = "Hello!"
        
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        helloLabel.frame = self.bounds
        self.addSubview(helloLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class HorizontalCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var assistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 15.0)!
        label.textColor = UIColor.blackFontColor
        label.text = "What can we assist you with?"
        return label
    }()
    
    let cellIdentifier = "squareCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if frame.size.height != 135 {
            fatalError()
        }
        
        assistLabel.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 20.0)
        self.addSubview(assistLabel)
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.estimatedItemSize = CGSize.init(width: 100, height: 100)
        flowLayout.scrollDirection = .horizontal
        
        let horizontalCollectionView = UICollectionView.init(frame: CGRect.init(x: 0.0, y: self.frame.height - 100.0, width: self.frame.width, height: 100.0), collectionViewLayout: flowLayout)
        
        self.addSubview(horizontalCollectionView)
        
        horizontalCollectionView.delegate = self
        horizontalCollectionView.dataSource = self
        
        horizontalCollectionView.showsHorizontalScrollIndicator = false
        horizontalCollectionView.backgroundColor = .clear
        horizontalCollectionView.register(squareCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected \(indexPath.row)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class squareCell: UICollectionViewCell {
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.backgroundColor = getRandomColor()
            
            self.layer.cornerRadius = 10.0
            self.clipsToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

class QuestionsCollectionViewCell: UICollectionViewCell {
    
    
    var questionLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont(name: "Avenir-Medium", size: 20.0)!
        label.textColor = UIColor.init(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        questionLabel.frame = self.bounds
        self.addSubview(questionLabel)
        
        
        let arrowWidth: CGFloat = 11.44
        let arrowHeight: CGFloat = 18.8
        
        let arrowImageView = UIImageView.init(image: #imageLiteral(resourceName: ">_grey"))
        arrowImageView.frame = CGRect.init(x: self.frame.width - arrowWidth - 15.0, y: (self.frame.height / 2.0) - (arrowHeight / 2.0), width: arrowWidth, height: arrowHeight)
        
        self.addSubview(arrowImageView)
        
        
        let bottomLineView = UIView.init(frame: CGRect.init(x: 0.0, y: self.frame.height - 2.0, width: self.frame.width, height: 2.0))
        bottomLineView.backgroundColor = UIColor.contentDivider
        
        self.addSubview(bottomLineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}























