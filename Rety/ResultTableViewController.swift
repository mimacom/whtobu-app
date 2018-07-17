//
//  ResultsTableViewController.swift
//  Rety
//
//  Created by Sergej Kunz on 11.07.18.
//  Copyright © 2018 mimacom Deutschland GmbH. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController  {
    
    var selected: String = ""
    var detailInfo: [[String:AnyObject]] = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var resultTableView: UITableView!
    
    func stopSpinner() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    func startSpinner() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        startSpinner()
    /*
        print("Selected", selected)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LabelCell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeTapped))
        
        
        AmazonService.getProductsByName(name: selected) {
            (items) in
            
            self.detailInfo = items;
            if items.count > 0 {
                self.resultTableView.reloadData()
            }
            
            self.activityIndicator.isHidden = true
        } */
    }
    
    @objc func closeTapped(sender: AnyObject) {
        print("close")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailInfo.count > 0 ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
    //    cell.imageView?.imageFromUrl(urlString: detailInfo[""])
        
        print("Row:", detailInfo)
        
        cell.textLabel?.text = "Test"
        
        return cell
    }
}
