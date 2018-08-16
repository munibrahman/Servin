//
//  PayoutMethodsViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-08-16.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import Foundation
import UIKit

class PayoutMethodsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var payoutTableView: UITableView!
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        
        setupViews()
    }
    
    func setupNavigationBar() {
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        let leftBarItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "<_white"), style: .plain, target: self, action: #selector(userDidPressBack))
        leftBarItem.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        
        let rightBarItem = UIBarButtonItem.init(title: "Add", style: .plain, target: self, action: #selector(userDidPressNext))
        rightBarItem.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = rightBarItem
        
    }
    
    @objc func userDidPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func userDidPressNext() {
        self.navigationController?.present(UINavigationController.init(rootViewController: PayoutSetupViewController()), animated: true, completion: nil)
    }
    
    func setupViews() {
        payoutTableView = UITableView.init(frame: CGRect.init(), style: .grouped)
        view.addSubview(payoutTableView)
        
        payoutTableView.translatesAutoresizingMaskIntoConstraints = false
        payoutTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        payoutTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        payoutTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        payoutTableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        
        payoutTableView.delegate = self
        payoutTableView.dataSource = self
        
        payoutTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        payoutTableView.separatorStyle = .none
        
        payoutTableView.register(PayoutTableViewCell.self, forCellReuseIdentifier: "cell")
        
        payoutTableView.backgroundColor = .clear

    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.blackFontColor
        titleLabel.text = "Payout Methods"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .regular)
        return titleLabel
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PayoutTableViewCell
        cell.titleLabel.text = "No payment methods"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    private class PayoutTableViewCell: UITableViewCell {
        
        var titleLabel: UILabel!
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            
            setupViews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupViews() {
            titleLabel = UILabel()
            titleLabel.textColor = UIColor.blackFontColor
            
            contentView.addSubview(titleLabel)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
    }
}





















































