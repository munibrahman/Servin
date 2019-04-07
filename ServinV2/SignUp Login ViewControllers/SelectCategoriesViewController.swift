//
//  SelectCategoriesViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-07-20.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import AWSAppSync

class SelectCategoriesViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let demoLabel = UILabel()
    private let minCellSpacing: CGFloat = 16.0
    private var maxCellWidth: CGFloat!
    
    var data: [String] = ["Tech", "Design", "Humor", "Travel", "Music", "Writing", "Social Media", "Life", "Education", "Edtech", "Education Reform", "Photography", "Startup", "Poetry", "Women In Tech", "Female Founders", "Business", "Fiction", "Love", "Food", "Autos", "Cleaning", "Technology", "Business", "Sports", "Childcare", "Airsoft", "Cycling", "Fitness", "Baseball", "Basketball", "Bird Watching", "Bodybuilding", "Camping", "Dowsing", "Driving", "Fishing", "Flying", "Flying Disc", "Foraging", "Freestyle Football", "Gardening", "Geocaching", "Ghost hunting", "Grafitti", "Handball", "High-power rocketry", "Hooping", "Horseback riding", "Hunting"]
    
    var highlightedArray: [Bool]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Welcome to Servin"
        
        let rightBarItem = UIBarButtonItem.init(title: "Next", style: .plain, target: self, action: #selector(didTapNext))
        rightBarItem.tintColor = .blackFontColor
        rightBarItem.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        let leftBarItem = UIBarButtonItem.init(title: "Skip", style: .plain, target: self, action: #selector(didTapSkip))
        leftBarItem.tintColor = .blackFontColor
        leftBarItem.isEnabled = true
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        self.highlightedArray =  Array.init(repeating: false, count: data.count)
        
        self.maxCellWidth = UIScreen.main.bounds.width - (minCellSpacing * 2)
        
        self.view.backgroundColor = .white
        self.demoLabel.font = CollectionViewCell().label.font
        
        let layout = FlowLayout()
        layout.sectionInset = UIEdgeInsets(top: self.minCellSpacing, left: 2.0, bottom: self.minCellSpacing, right: 2.0)
        layout.minimumInteritemSpacing = self.minCellSpacing
        layout.minimumLineSpacing = 16.0
        
        
        let infoLabel = UILabel.init()
        infoLabel.text = "Pick a few categories that interest you"
        infoLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.6)
        infoLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        infoLabel.textAlignment = .center
        self.view.addSubview(infoLabel)
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 8.0).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        infoLabel.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(collectionView)
        
        
        
        collectionView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
        
        // Leading/Trailing gutter CellSpacing+ShadowWidth
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: minCellSpacing + layout.sectionInset.left).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -(minCellSpacing + layout.sectionInset.right)).isActive = true
    }
    
    @objc func didTapSkip() {
        print("Skip choosing categories")
        let mainVC = Constants.getMainContentVC()
        
        self.present(mainVC, animated: true, completion: nil)
    }
    
    @objc func didTapNext() {
        
        let progressSpinner = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        progressSpinner.color = UIColor.black
        progressSpinner.startAnimating()
        
        let progressBarButton = UIBarButtonItem.init(customView: progressSpinner)
        
        self.navigationItem.rightBarButtonItem = progressBarButton
        
        let finalArray = data.filter { (value) -> Bool in
            return highlightedArray[data.index(of: value)!] == true
        }
        
        print(finalArray)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let appSyncClient = appDelegate.appSyncClient
            
            let mutation = UpdateCategoriesMutation.init(list: finalArray)
            
            appSyncClient?.perform(mutation: mutation, resultHandler: { (result, err) in
                if let result = result {
                    print("Successful response for selecting categories.")
                    
                } else if let error = err {
                    print("Error response for selecting categories: \(error)")
                    self.showErrorNotification(title: "Error", subtitle: "Can't select categories, please try again later")
                }
            })
        }
        
        let mainVC = Constants.getMainContentVC()
        
        self.present(mainVC, animated: true, completion: nil)
        
    }
}

extension SelectCategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CollectionViewCell
        cell.label.text = self.data[indexPath.item]
        cell.label.textColor = highlightedArray[indexPath.row] ? UIColor.white : UIColor.blackFontColor
        cell.contentView.backgroundColor = highlightedArray[indexPath.row] ? UIColor.blackFontColor : UIColor.white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.demoLabel.text = self.data[indexPath.item]
        self.demoLabel.sizeToFit()
        return CGSize(width: min(self.demoLabel.frame.width + 16, self.maxCellWidth), height: 36.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected \(data[indexPath.row])")
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            
            cell.label.textColor = highlightedArray[indexPath.row] ? UIColor.blackFontColor : UIColor.white
            cell.contentView.backgroundColor = highlightedArray[indexPath.row] ? UIColor.white : UIColor.blackFontColor
            
            highlightedArray[indexPath.row] = !highlightedArray[indexPath.row]
            
            let selected = highlightedArray.reduce(false) { (x, y) -> Bool in
                return x || y
            }
            
            navigationItem.rightBarButtonItem?.isEnabled = selected
        }
    }
}

class FlowLayout: UICollectionViewFlowLayout {
    
    private var attribs = [IndexPath: UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        self.attribs.removeAll()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var updatedAttributes = [UICollectionViewLayoutAttributes]()
        
        let sections = self.collectionView?.numberOfSections ?? 0
        var indexPath = IndexPath(item: 0, section: 0)
        while (indexPath.section < sections) {
            guard let items = self.collectionView?.numberOfItems(inSection: indexPath.section) else { continue }
            
            while (indexPath.item < items) {
                if let attributes = layoutAttributesForItem(at: indexPath), attributes.frame.intersects(rect) {
                    updatedAttributes.append(attributes)
                }
                
                let headerKind = UICollectionView.elementKindSectionHeader
                if let headerAttributes = layoutAttributesForSupplementaryView(ofKind: headerKind, at: indexPath) {
                    updatedAttributes.append(headerAttributes)
                }
                
                let footerKind = UICollectionView.elementKindSectionFooter
                if let footerAttributes = layoutAttributesForSupplementaryView(ofKind: footerKind, at: indexPath) {
                    updatedAttributes.append(footerAttributes)
                }
                indexPath.item += 1
            }
            indexPath = IndexPath(item: 0, section: indexPath.section + 1)
        }
        
        return updatedAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = attribs[indexPath] {
            return attributes
        }
        
        var rowCells = [UICollectionViewLayoutAttributes]()
        var collectionViewWidth: CGFloat = 0
        if let collectionView = collectionView {
            collectionViewWidth = collectionView.bounds.width - collectionView.contentInset.left
                - collectionView.contentInset.right
        }
        
        var rowTestFrame: CGRect = super.layoutAttributesForItem(at: indexPath)?.frame ?? .zero
        rowTestFrame.origin.x = 0
        rowTestFrame.size.width = collectionViewWidth
        
        let totalRows = self.collectionView?.numberOfItems(inSection: indexPath.section) ?? 0
        
        // From this item, work backwards to find the first item in the row
        // Decrement the row index until a) we get to 0, b) we reach a previous row
        var startIndex = indexPath.row
        while true {
            let lastIndex = startIndex - 1
            
            if lastIndex < 0 {
                break
            }
            
            let prevPath = IndexPath(row: lastIndex, section: indexPath.section)
            let prevFrame: CGRect = super.layoutAttributesForItem(at: prevPath)?.frame ?? .zero
            
            // If the item intersects the test frame, it's in the same row
            if prevFrame.intersects(rowTestFrame) {
                startIndex = lastIndex
            } else {
                // Found previous row, escape!
                break
            }
        }
        
        // Now, work back UP to find the last item in the row
        // For each item in the row, add it's attributes to rowCells
        var cellIndex = startIndex
        while cellIndex < totalRows {
            let cellPath = IndexPath(row: cellIndex, section: indexPath.section)
            
            if let cellAttributes = super.layoutAttributesForItem(at: cellPath),
                cellAttributes.frame.intersects(rowTestFrame),
                let cellAttributesCopy = cellAttributes.copy() as? UICollectionViewLayoutAttributes {
                rowCells.append(cellAttributesCopy)
                cellIndex += 1
            } else {
                break
            }
        }
        
        let flowDelegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout
        let selector = #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))
        let delegateSupportsInteritemSpacing = flowDelegate?.responds(to: selector) ?? false
        
        var interitemSpacing = minimumInteritemSpacing
        
        // Check for minimumInteritemSpacingForSectionAtIndex support
        if let collectionView = collectionView, delegateSupportsInteritemSpacing && rowCells.count > 0 {
            interitemSpacing = flowDelegate?.collectionView?(collectionView,
                                                             layout: self,
                                                             minimumInteritemSpacingForSectionAt: indexPath.section) ?? 0
        }
        
        let aggregateInteritemSpacing = interitemSpacing * CGFloat(rowCells.count - 1)
        
        var aggregateItemWidths: CGFloat = 0
        for itemAttributes in rowCells {
            aggregateItemWidths += itemAttributes.frame.width
        }
        
        let alignmentWidth = aggregateItemWidths + aggregateInteritemSpacing
        let alignmentXOffset: CGFloat = (collectionViewWidth - alignmentWidth) / 2
        
        var previousFrame: CGRect = .zero
        for itemAttributes in rowCells {
            var itemFrame = itemAttributes.frame
            
            if previousFrame.equalTo(.zero) {
                itemFrame.origin.x = alignmentXOffset
            } else {
                itemFrame.origin.x = previousFrame.maxX + interitemSpacing
            }
            
            itemAttributes.frame = itemFrame
            previousFrame = itemFrame
            
            attribs[itemAttributes.indexPath] = itemAttributes
        }
        
        return attribs[indexPath]
    }
}


class CollectionViewCell: UICollectionViewCell {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        self.contentView.addConstraints([
            NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: contentView,
                               attribute: .leading, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: contentView,
                               attribute: .top, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: label,
                               attribute: .trailing, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: label,
                               attribute: .bottom, multiplier: 1.0, constant: 8.0)])
        
        self.backgroundColor = .white
        self.label.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        self.layer.cornerRadius = 3.0
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.1, height: 0.2)
        self.layer.shadowOpacity = 0.28
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







