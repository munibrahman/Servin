//
//  SegmentedControl.swift
//  Livenue
//
//  Created by Macbook on 2017-07-15.
//  Copyright © 2017 Macbook. All rights reserved.
//

import Foundation

import UIKit


@IBDesignable class SegmentedControl: UIControl {
    
    private var labels = [UILabel]()
    
    var thumbView = UIView()
    
    var items:[String] = ["Offer", "Request"] {
        didSet{
           setupLabels()
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        
        backgroundColor = UIColor.clear
        
        setupLabels()
        
        insertSubview(thumbView, at: 0)
    }
    
    func setupLabels() {
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for index in 1...items.count {
            let label = UILabel(frame: CGRect.zero)
            label.text = items[index - 1]
            label.textAlignment = .center
            label.textColor = UIColor.placeHolderColor
            self.addSubview(label)
            labels.append(label)
        }
        
        labels[0].textColor = UIColor.black
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectedFrame = self.bounds
        let newWidth = selectedFrame.width / CGFloat(items.count)
        selectedFrame.size.width = newWidth
        thumbView.frame = selectedFrame
        thumbView.backgroundColor = UIColor.clear

        thumbView.addBottomBarForSegmentControl(color: UIColor.black, width: 2.0, spacing: 10.0)
        let labelHeight = self.bounds.height
        let labelWidth = self.bounds.width / CGFloat(labels.count)
        
        for index in 0...labels.count - 1 {
            let label = labels[index]
            
            let xPosition = CGFloat(index) * labelWidth
            label.frame = CGRect(x: xPosition, y: 0, width: labelWidth, height: labelHeight)
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        var calculatedIndex: Int?
        
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func displayNewSelectedIndex() {
        
        let label = labels[selectedIndex]
        label.textColor = UIColor.black
        
        if selectedIndex == 0 {
            labels[1].textColor = UIColor.placeHolderColor
        } else {
            labels[0].textColor = UIColor.placeHolderColor
        }
        
        UIView.animate(withDuration: 0.2) {
            self.thumbView.frame = label.frame
        }
        
        
        
        
    }
}
