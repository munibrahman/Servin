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
        
//        searchBarStyle = UISearchBar.Style.minimal
//        isTranslucent = true
//
        self.setImage(UIImage(), for: .search, state: .normal)
//        self.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
//
//        self.backgroundColor = UIColor.white
        
        print("DID call init")

        if let textfield = self.value(forKey: "searchField") as? UITextField {
//            textfield.font = UIFont.systemF
            textfield.backgroundColor = UIColor.white
//            textfield.layer.borderWidth = 1.0
//            textfield.layer.borderColor = UIColor.gray.cgColor
        }
        
        self.placeholder = "Discover"
        
        
        let searchField: UITextField? = self.value(forKey: "searchField") as? UITextField
        let searchBarBackground: UIView? = self.value(forKey: "background") as? UIView
         searchBarBackground?.removeFromSuperview()
        
//        if searchField != nil {
//            var frame = searchField?.frame
//            frame?.size.height = 30
//            searchField?.frame = frame!
//            searchField?.backgroundColor = .white
//        }
        
        self.barTintColor = .white
        self.backgroundColor = .white
        
//        self.layer.borderWidth = 2.0
//        self.layer.borderColor = UIColor.black.cgColor
//        self.layer.cornerRadius = 2.0
        
        
        // This sets the background color of the actual textfield to be white. If it isnt set, you can see a tiny grey textfield
//        if let textfield = self.value(forKey: "searchField") as? UITextField {
//            textfield.backgroundColor = UIColor.white
//
//            for subview in textfield.subviews {
//                subview.backgroundColor = .white
//            }
//
//            if let backgroundview = textfield.subviews.first {
//                // Background color
//                backgroundview.backgroundColor = UIColor.white
//                // Rounded corner
//                backgroundview.layer.cornerRadius = 0;
//                backgroundview.clipsToBounds = true;
//            }
//        }
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//
//        // Find the index of the search field in the search bar subviews.
//        if let index = indexOfSearchFieldInSubviews() {
//            // Access the search field
//            let searchField: UITextField = (subviews[0] ).subviews[index] as! UITextField
//
//
//
//
//
//            // Set the background color of the search field.
//            searchField.backgroundColor = UIColor.white
//        }
//
//        //        Adding a line to the bottom of the search bar
//        //        Making a bezier path
//
//        //        let startPoint = CGPoint(x: 0.0, y: frame.size.height)
//        //        let endPoint = CGPoint(x: frame.size.width, y: frame.size.height)
//        //        let path = UIBezierPath()
//        //        path.move(to: startPoint)
//        //        path.addLine(to: endPoint)
//
//        //        Turning the bezier path into a line
//
//        //        let shapeLayer = CAShapeLayer()
//        //        shapeLayer.path = path.cgPath
//        //        shapeLayer.strokeColor = preferredTextColor.cgColor
//        //        shapeLayer.lineWidth = 2.5
//        //
//        //        layer.addSublayer(shapeLayer)
//
//        super.draw(rect)
//    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.frame.width / 2.0 //change it to .height if you need spread for height
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: frame.height))
        //Change 2.1 to amount of spread you need and for height replace the code for height
        
        layer.cornerRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 0.4)  //Here you control x and y
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5.0 //Here your control your blur
        layer.masksToBounds =  false
        layer.shadowPath = shadowPath.cgPath
        
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
