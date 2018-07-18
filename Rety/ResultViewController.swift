//
//  ResultsTableViewController.swift
//  Rety
//
//  Created by Sergej Kunz on 11.07.18.
//  Copyright © 2018 mimacom Deutschland GmbH. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController  {
    
    var selected: String = ""
    var product: [String:AnyObject] = [:]
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var buyButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = false
        self.productName.text = ""
        
        print("Selected", selected)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeTapped))
        
        self.imageView.imageFromUrl(urlString: self.getLargeImageUrl())
        self.productName.text = self.getProductname()
        
    /*
        AmazonService.getProductsByName(name: selected) {
            (items) in
            
            self.detailInfo = items;
            if items.count > 0 {
                self.imageView.imageFromUrl(urlString: self.getLargeImageUrl())
                self.productName.text = self.getProductname()
            }
            
            self.activityIndicator.isHidden = true
        } */
    }
    
    @IBAction func didTapBuyButton(sender: AnyObject) {
        if let url = URL(string: getBuyUrl()) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc func closeTapped(sender: AnyObject) {
        print("close")
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func getProductname() -> String {
        
        print("Data:", self.product)
        
        let itemAttributes = self.product["ItemAttributes"] as! [[String: AnyObject]]
        
        for (key, value) in itemAttributes[0] {
            print("Key:", key)
            print("Value:", value)
            
            if key == "Title" {
                return (value as! [String])[0]
            }
        }
        
        return "Not Found"
    }
    
    func getBuyUrl() -> String {
        
        print("Data:", self.product)
        
        let detailPageURL = self.product["DetailPageURL"] as! [String]
        return detailPageURL[0]
    }
    
    func getLargeImageUrl() -> String {
        let smallImage = self.product["LargeImage"] as! [[String: AnyObject]]
        let urlItems = smallImage[0]
        var url: String? = nil
        
        for (key, value) in urlItems {
            print("Key:", key)
            print("Value:", value)
            
            if key == "URL" {
                url = (value as! [String])[0]
            }
        }
        
        return url!
    }
}

