//
//  DetailedMessageViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-07-03.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class DetailedMessageViewController: UIViewController {

    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        setupNavigationController()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupNavigationController() {
        if self.navigationController == nil {
            fatalError("This VC Must be presented inside a navigation controller")
        }
        
        navigationController?.navigationBar.tintColor = UIColor.black
        
        let barButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_grey"), style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.leftBarButtonItem = barButtonItem
        
        // TODO: Retrieve actual name of user instead of a hardcoded string
        
        self.navigationItem.title = "Adriana"
    }
    
    @objc func barButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupViews()
    }
    func setupViews() {
        let topPinView = UIView.init(frame: CGRect.init(x: 0.0, y: self.topbarHeight, width: self.view.frame.size.width, height: 75.0))
        topPinView.backgroundColor = .white
        
        
        
        let topPinImageView = UIImageView.init(frame: CGRect.init(x: 8.0, y: 4.0, width: 66.0, height: 66.0))
        topPinImageView.contentMode = .scaleAspectFill
        topPinImageView.clipsToBounds = true
        
        // TODO: Add actual image of the pin here
        topPinImageView.image = #imageLiteral(resourceName: "soccer")
        
        topPinView.addSubview(topPinImageView)
        
        // TODO: Populate info for the title here
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0.0, y: 10.0, width: 200.0, height: 50.0))
        titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        titleLabel.textColor = UIColor.blackFontColor
        titleLabel.text = "Soccer Coach for hire!"
        
        topPinView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: topPinView.layoutMarginsGuide.topAnchor, constant: -4.0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: topPinImageView.layoutMarginsGuide.trailingAnchor, constant: 16.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: topPinView.layoutMarginsGuide.trailingAnchor, constant: -8.0).isActive = true
        
        self.view.addSubview(topPinView)
        
        
        let timeLabel = UILabel.init()
        timeLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        timeLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
        
        timeLabel.text = "5 mins away"
        
        topPinView.addSubview(timeLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.leadingAnchor.constraint(equalTo: topPinImageView.layoutMarginsGuide.trailingAnchor, constant: 16.0).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: topPinView.layoutMarginsGuide.bottomAnchor, constant: 0.0).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: topPinView.layoutMarginsGuide.trailingAnchor, constant: -16.0).isActive = true
        
        
        let priceLabel = UILabel.init()
        priceLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        priceLabel.textColor = UIColor.blackFontColor.withAlphaComponent(0.8)
        priceLabel.text = "$ 200"
        
        topPinView.addSubview(priceLabel)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.leadingAnchor.constraint(equalTo: topPinImageView.layoutMarginsGuide.trailingAnchor, constant: 16.0).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: timeLabel.layoutMarginsGuide.topAnchor, constant: -8.0).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: topPinView.layoutMarginsGuide.trailingAnchor, constant: -16.0).isActive = true
        
        let thinLine = UIView()
        thinLine.backgroundColor = UIColor.contentDivider
        
        topPinView.addSubview(thinLine)
        
        thinLine.translatesAutoresizingMaskIntoConstraints = false
        
        
        thinLine.leadingAnchor.constraint(equalTo: topPinView.leadingAnchor).isActive = true
        thinLine.trailingAnchor.constraint(equalTo: topPinView.trailingAnchor).isActive = true
        thinLine.bottomAnchor.constraint(equalTo: topPinView.bottomAnchor).isActive = true
        thinLine.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        let showPinGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(showDetailPin))
        
        topPinView.addGestureRecognizer(showPinGestureRecognizer)
    }
    
    
    @objc func showDetailPin() {
        let userDiscoveryVC = MessageUserPinViewController()
        self.navigationController?.pushViewController(userDiscoveryVC, animated: true)
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
