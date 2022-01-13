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

    var progressView: UIActivityIndicatorView!
    var svgView: SVGView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        
        progressView = UIActivityIndicatorView.init(frame: self.bounds)
        progressView.color = .white
        progressView.startAnimating()
        progressView.backgroundColor = .clear
        
        self.svgView = SVGView.init(frame: self.bounds)
        svgView.fileName = ">_clear"
        svgView.contentMode = .scaleAspectFit
        progressView.isUserInteractionEnabled = false
        
        self.backgroundColor = .clear
        svgView.backgroundColor = .clear
        svgView.isUserInteractionEnabled = true
        self.isUserInteractionEnabled = true
        self.addSubview(svgView)
    }
    
    func toggleProgress(showProgress: Bool) {
        if showProgress {
            self.addSubview(progressView)
            
            svgView.removeFromSuperview()
            
        } else {
            self.addSubview(svgView)
            
            progressView.removeFromSuperview()
        }
    }
    
}
