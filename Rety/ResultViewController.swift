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
    var product: [String:String] = [:]
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var buyButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = false
        self.productName.text = ""
        self.price.text = ""
        
        self.scrollView.isDirectionalLockEnabled = true
        self.scrollView.delegate = self
        self.scrollView.contentSize = self.view.frame.size 
        
        print("Selected", selected)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeTapped))
        
        self.imageView.imageFromUrl(urlString: self.product["image"]!)
        self.productName.text = self.product["name"]
        self.price.text = self.product["price"]
    }
    
    @IBAction func didTapBuyButton(sender: AnyObject) {
        if let url = URL(string: product["detailPageUrl"]!) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc func closeTapped(sender: AnyObject) {
        print("close")
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}

extension ResultViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x != 0){
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y), animated: false)
        }
    }
}
