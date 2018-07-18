//
//  ResultsTableViewController.swift
//  Rety
//
//  Created by Sergej Kunz on 11.07.18.
//  Copyright © 2018 mimacom Deutschland GmbH. All rights reserved.
//

import UIKit
import Foundation

class ResultsTableViewController: UITableViewController {

    @IBOutlet var resultsTableView: UITableView!
    var amazonResults = [[String:AnyObject]]()
    var results: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Results", results)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "resultCell")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeTapped))
    }
    
    @objc func closeTapped(sender: AnyObject) {
        print("close")
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return results.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell")

        let row = indexPath.row
        cell?.textLabel?.text = self.results[row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let containerViewController = storyboard.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
        
        containerViewController.selected = results[indexPath.row]
        self.navigationController?.pushViewController(containerViewController, animated: true)
    }
}
