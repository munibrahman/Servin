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
    
    let sidePadding: CGFloat = 20.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, daddyVC: MapSearchViewController) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        // This is the hamburger menu icon.
        let menuIcon = UIImageView.init(frame: CGRect.init(x: sidePadding, y: (frame.size.height / 2.0) - 10.0, width: 20.0, height: 20.0))
        menuIcon.image = #imageLiteral(resourceName: "<_black")
        menuIcon.contentMode = .scaleAspectFit
        menuIcon.isUserInteractionEnabled = false
        
        let menuIconSpace: CGFloat = menuIcon.frame.size.width + (sidePadding * 2.0)
        
        let menuTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.backPressed))
        let menuTapView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: menuIconSpace, height: self.frame.size.height))
        menuTapView.backgroundColor = .clear
        menuTapView.isUserInteractionEnabled = true
        menuTapView.addGestureRecognizer(menuTapGesture)
        
        self.addSubview(menuIcon)
        self.addSubview(menuTapView)
        
        
        
        
        let searchBar = UIView.init(frame: CGRect.init(x: menuIconSpace, y: 0.0, width: self.frame.size.width - menuIconSpace - sidePadding, height: self.frame.size.height))
        searchBar.backgroundColor = .white
        
        let radius: CGFloat = searchBar.frame.width / 2.0 //change it to .height if you need spread for height
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: frame.height))
        //Change 2.1 to amount of spread you need and for height replace the code for height
        
        searchBar.layer.cornerRadius = 2
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)  //Here you control x and y
        searchBar.layer.shadowOpacity = 0.5
        searchBar.layer.shadowRadius = 5.0 //Here your control your blur
        searchBar.layer.masksToBounds =  false
        searchBar.layer.shadowPath = shadowPath.cgPath
        
        self.addSubview(searchBar)
        
        
        
        searchView = UITextField.init(frame: searchBar.frame.insetBy(dx: 10.0, dy: 0.0))
        //searchView.placeholder = "Try house cleaning..."
        searchView.attributedPlaceholder = NSAttributedString(string: "Try: House Cleaning...", attributes:[NSAttributedStringKey.foregroundColor: UIColor.init(red: 174.0/255.0, green: 174.0/255.0, blue: 174.0/255.0, alpha: 1.0)])
        searchView.adjustsFontSizeToFitWidth = true
        searchView.font = UIFont(name: "HelveticaNeue", size: 21.0)!
        searchView.textColor = UIColor.black
        searchView.clearButtonMode = .whileEditing
        self.addSubview(searchView)
        
        
        
        self.daddyVC = daddyVC
    }
    

    
    @objc func backPressed() {
        print("tapped")
        
        self.daddyVC.dismiss(animated: false, completion: nil)
    }
}
