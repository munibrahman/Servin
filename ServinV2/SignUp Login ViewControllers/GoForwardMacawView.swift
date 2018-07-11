//
//  GoForwardMacawView.swift
//  ServinV2
//
//  Created by Developer on 2018-07-11.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Macaw

class GoForwardMacawView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        let svgView = SVGView.init(frame: self.bounds)
        svgView.fileName = ">_clear"
        svgView.contentMode = .scaleAspectFit
        
        self.backgroundColor = .clear
        svgView.backgroundColor = .clear
        svgView.isUserInteractionEnabled = true
        self.isUserInteractionEnabled = true
        self.addSubview(svgView)
    }
    
}
