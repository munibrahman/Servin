//
//  MapSearchViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-07.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class MapSearchViewController: UIViewController {

    fileprivate var searchBar: SearchView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupSearchBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchBar.searchView.becomeFirstResponder()
    }
    func setupSearchBar() {
        
        if let frame = Constants.searchBarFrame {
            searchBar = SearchView.init(frame: frame, daddyVC: self)

            self.view.addSubview(searchBar)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: false, completion: nil)
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

private class SearchView: UIView {
    
    var daddyVC: UIViewController! = nil
    var searchView: UITextField! = nil
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, daddyVC: MapSearchViewController) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        let menuButton = UIImageView.init(frame: CGRect.init(x: 15.0, y: (frame.size.height / 2.0) - 10.0, width: 20.0, height: 20.0))
        menuButton.image = #imageLiteral(resourceName: "<_grey")
        menuButton.contentMode = .scaleAspectFit
        
        let backTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(backPressed))
        menuButton.isUserInteractionEnabled = false
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(backTapGesture)
        
        self.addSubview(menuButton)
        
        
        searchView = UITextField.init(frame: CGRect.init(x: 60.0, y: 0.0, width: frame.size.width - 60.0, height: frame.size.height))
        searchView.placeholder = "Try house cleaning..."
        searchView.attributedPlaceholder = NSAttributedString(string: "Try: House Cleaning...", attributes:[NSAttributedStringKey.foregroundColor: UIColor.init(red: 174.0/255.0, green: 174.0/255.0, blue: 174.0/255.0, alpha: 1.0)])
        searchView.adjustsFontSizeToFitWidth = true
        searchView.font = UIFont(name: "HelveticaNeue", size: 21.0)!
        searchView.textColor = UIColor.black
        searchView.clearButtonMode = .whileEditing
        self.addSubview(searchView)
        
        let radius: CGFloat = frame.width / 2.0 //change it to .height if you need spread for height
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: frame.height))
        //Change 2.1 to amount of spread you need and for height replace the code for height
        
        self.layer.cornerRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)  //Here you control x and y
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0 //Here your control your blur
        self.layer.masksToBounds =  false
        self.layer.shadowPath = shadowPath.cgPath
        
        self.daddyVC = daddyVC
    }
    

    
    @objc func backPressed() {
        print("tapped")
        
        self.daddyVC.dismiss(animated: false, completion: nil)
    }
}
