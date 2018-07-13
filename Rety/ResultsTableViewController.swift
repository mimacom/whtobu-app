//
//  ResultsTableViewController.swift
//  Rety
//
//  Created by Sergej Kunz on 11.07.18.
//  Copyright © 2018 mimacom Deutschland GmbH. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {

    var results: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Results", results)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "resultCell")
        
        AmazonService.getProductsByName(name: "Apple Watch")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeTapped))
    }
    
    @objc func closeTapped(sender: AnyObject) {
        print("close")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Results"
    }
    
    // MARK: - UITableViewDataSource
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return results.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]
        
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row", indexPath)
        
        let resultTableViewController = ResultTableViewController()
        resultTableViewController.selected = results[indexPath.row]
        
        self.navigationController?.pushViewController(resultTableViewController, animated: false)
    }
}
