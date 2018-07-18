//
//  ContainerViewController.swift
//  Rety
//
//  Created by Sergej Kunz on 18.07.18.
//  Copyright © 2018 mimacom Deutschland GmbH. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var selected: String = ""
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
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
        
        self.activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        startSpinner()
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        
        controller.pageControl = pageControl
        controller.activityIndicator = activityIndicator
        
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            controller.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        controller.didMove(toParent: self)
    }
}
