//
//  MapSearchViewController.swift
//  ServinV2
//
//  Created by Developer on 2018-05-07.
//  Copyright © 2018 Voltic Labs Inc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    static let tableViewCellId = "TableViewCell"
    
    let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
                "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
                "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
                "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
                "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    
    var filteredData: [String]!
    
    lazy var searchBar: HomeMapSearchBar = {
        let bar = HomeMapSearchBar.init()
        bar.delegate = self
        bar.barStyle = .default
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchViewController.tableViewCellId)
        return tableView
    }()
    
    var backButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.system)
        button.setImage(#imageLiteral(resourceName: "<_black"), for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.blackFontColor, for: UIControl.State.normal)
        button.tintColor = UIColor.blackFontColor
        return button
    }()
    

//    fileprivate var searchBar: SearchView! = nil
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        filteredData = data
        setupViews()
        setupSearchBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchBar.becomeFirstResponder()
        
    }
    
    func setupViews() {
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 25).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        backButton.addTarget(self, action: #selector(dismissVC), for: UIControl.Event.touchUpInside)
        
        view.addSubview(searchBar)
        searchBar.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 20).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 15).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -8).isActive = true
    }
    
    func setupSearchBar() {
        
//        if let frame = Constants.searchBarFrame {
//            searchBar = SearchView.init(frame: frame, daddyVC: self)
//
//            self.view.addSubview(searchBar)
//
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: false, completion: nil)
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredData = searchText.isEmpty ? data : data.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: Show search results controller
        // If no results, show an alert that mentions no results.
        
        // Otherwise, show the map with populated search results
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.tableViewCellId, for: indexPath) as UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

class SearchTableViewCell: UITableViewCell {
    
    var label: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 21, weight: .regular)
        label.textColor = UIColor.blackFontColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var leftImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = #imageLiteral(resourceName: "search_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .clear
        
        addSubview(leftImageView)
        leftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        leftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        leftImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        leftImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        contentView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
