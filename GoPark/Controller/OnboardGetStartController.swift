//
//  OnboardGetStartController.swift
//  GoPark
//
//  Created by Michael Wong on 19/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

class OnboardGetStartController: UIViewController {

    @IBOutlet weak var btnGetStartOutlet: UIButton!
    @IBAction func btnGetStartAction(_ sender: Any) {
        //set user default
        UserDefaults.standard.set(false, forKey: "isInitialLaunchApp")
        
        
        let uiStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let uiTabBarController = uiStoryBoard.instantiateViewController(withIdentifier: "UITabbarIdentifier") as! UITabBarController
        let window = UIApplication.shared.windows[0] as UIWindow;
        window.rootViewController = uiTabBarController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set btnGetStartOutlet content
        btnGetStartOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "OnboardGetStartController_getStart", comment: ""), for: .normal)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //make the button flash
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.8
        flash.fromValue = 1
        flash.toValue = 0.3
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 10000
        self.btnGetStartOutlet.layer.add(flash, forKey: nil)
    }

}
