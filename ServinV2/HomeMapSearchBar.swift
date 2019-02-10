//
//  HomeMapSearchBar.swift
//  ServinV2
//
//  Created by Developer on 2018-05-07.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class HomeMapSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        
        searchBarStyle = UISearchBar.Style.minimal
        isTranslucent = false
        
        self.setImage(UIImage(), for: .search, state: .normal)
        
        self.backgroundColor = UIColor.white
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        // Find the index of the search field in the search bar subviews.
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = (subviews[0] ).subviews[index] as! UITextField
            
            
            
            
            
            // Set the background color of the search field.
            searchField.backgroundColor = UIColor.white
        }
        
        //        Adding a line to the bottom of the search bar
        //        Making a bezier path
        
        //        let startPoint = CGPoint(x: 0.0, y: frame.size.height)
        //        let endPoint = CGPoint(x: frame.size.width, y: frame.size.height)
        //        let path = UIBezierPath()
        //        path.move(to: startPoint)
        //        path.addLine(to: endPoint)
        
        //        Turning the bezier path into a line
        
        //        let shapeLayer = CAShapeLayer()
        //        shapeLayer.path = path.cgPath
        //        shapeLayer.strokeColor = preferredTextColor.cgColor
        //        shapeLayer.lineWidth = 2.5
        //
        //        layer.addSublayer(shapeLayer)
        
        super.draw(rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func indexOfSearchFieldInSubviews() -> Int! {
        // Uncomment the next line to see the search bar subviews.
        print(subviews[0].subviews)
        
        var index: Int!
        let searchBarView = subviews[0]
        
        for i in 0 ..< searchBarView.subviews.count + 1 {
            if searchBarView.subviews[i].isKind(of: UITextField.self) {
                index = i
                break
            }
        }
        
        return index
    }
    
    
    
}
