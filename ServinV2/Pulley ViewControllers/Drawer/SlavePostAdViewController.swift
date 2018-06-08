//
//  SlavePostAdViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-06-07.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit
import Pulley

class SlavePostAdViewController: UIViewController {

    
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var priceTextField: UITextField!
    
    
    @IBOutlet var descriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupViews()
    }
    
    func setupViews() {
        titleTextField.addBottomBorderWithColor(color: UIColor.blackFontColor, width: 1.0)
        priceTextField.addBottomBorderWithColor(color: UIColor.blackFontColor, width: 1.0)
        descriptionTextField.addBottomBorderWithColor(color: UIColor.blackFontColor, width: 1.0)
        
        titleTextField.backgroundColor = .clear
        priceTextField.backgroundColor = .clear
        descriptionTextField.textContainer.lineFragmentPadding = 0
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


extension SlavePostAdViewController : PulleyDrawerViewControllerDelegate {
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return [PulleyPosition.partiallyRevealed, PulleyPosition.open]
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        
        return UIScreen.main.bounds.size.height * (2/3)
        
    }
    
    
}


