//
//  OnboardSetupController.swift
//  GoPark
//
//  Created by Michael Wong on 19/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

import UIKit
import Foundation

class OnboardSetupController: UIPageViewController, UIPageViewControllerDataSource {
    
    lazy var uiTabBarController: UITabBarController = {
        let uiStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let Controller = uiStoryBoard.instantiateViewController(withIdentifier: "UITabbarIdentifier") as! UITabBarController
        return Controller
    }()
    
    lazy var viewControllerList:[UIViewController] = {
        let uiStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let firstOnboardController = uiStoryBoard.instantiateViewController(withIdentifier: "firstOnboardIdentifier")
        let secondOnboardController = uiStoryBoard.instantiateViewController(withIdentifier: "secondOnboardIdentifier")
        let thirdOnboardController = uiStoryBoard.instantiateViewController(withIdentifier: "thirdOnboardIdentifier")
        let fourthOnboardController = uiStoryBoard.instantiateViewController(withIdentifier: "fourthOnboardIdentifier")
        return [firstOnboardController, secondOnboardController, thirdOnboardController, fourthOnboardController]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        //check if it is the first launch. if no, segue to home page
        if let firstOnboardController = viewControllerList.first{
            self.setViewControllers([firstOnboardController], direction: .forward, animated: true, completion: nil)
        }
 
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllerList.index(of: viewController) else{ return nil}
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else{ return nil}
        guard viewControllerList.count > previousIndex else { return nil}
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllerList.index(of: viewController) else{ return nil}
        let nextIndex = currentIndex + 1
        guard viewControllerList.count != nextIndex else { return nil}
        guard viewControllerList.count > nextIndex else { return nil}
        return viewControllerList[nextIndex]
    }
    
}
