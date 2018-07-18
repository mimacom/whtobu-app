//
//  PageViewController.swift
//  Rety
//
//  Created by Sergej Kunz on 18.07.18.
//  Copyright © 2018 mimacom Deutschland GmbH. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var selected: String = ""
    var products: [[String:AnyObject]] = []
    var pageControl: UIPageControl!
    var activityIndicator: UIActivityIndicatorView!
    
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
        
        dataSource = self
        delegate = self
        
        AmazonService.getProductsByName(name: selected) {
            (items) in
            
            print("Products found", items)
            
            self.products = items;
            if items.count > 0 {
                if let firstViewController = self.orderedViewControllers.first {
                    self.setViewControllers([firstViewController],
                                       direction: .forward,
                                       animated: true,
                                       completion: nil)
                }
                
                self.configurePageControl()
            }
            
            self.stopSpinner()
        }
    }
    
    func configurePageControl() {
        self.pageControl.numberOfPages = self.products.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        var controllers: [UIViewController] = []
        
        for product in products {
            controllers.append(newViewController(product))
        }
        
        return controllers
    }()
    
    private func newViewController(_ product: [String:AnyObject]) -> ResultViewController {
        let controller = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        
        controller.product = product
        
        return controller
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let index = self.orderedViewControllers.index(of: pendingViewControllers[0]) {
            self.pageControl.currentPage = index
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed, let previousIndex = self.orderedViewControllers.index(of: previousViewControllers[0]) {
            self.pageControl.currentPage = previousIndex
        }
    }
}

// MARK: UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard self.orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = self.orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}
