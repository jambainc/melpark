//
//  MainTabController.swift
//  GoPark
//
//  Created by Michael Wong on 19/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get the navigation controllers of the tabcontroller and set the tab title (language).
        guard let viewControllers = self.viewControllers else{return}
        viewControllers[0].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingController_title", comment: "")
        viewControllers[1].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ListController_title", comment: "")
        viewControllers[3].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_title", comment: "")
        viewControllers[4].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingController_title", comment: "")
        
        setupCenterButton()
    }

    // MARK: - Add a round Button in the middle
    
    func setupCenterButton() {
        let centerButton = UIButton(frame: CGRect(x: 0, y: 10, width: 60, height: 60))
        
        var centerButtonFrame = centerButton.frame
        centerButtonFrame.origin.y = (view.bounds.height - centerButtonFrame.height) - 2
        centerButtonFrame.origin.x = view.bounds.width/2 - centerButtonFrame.size.width/2
        centerButton.frame = centerButtonFrame
        
        centerButton.layer.cornerRadius = 35
        view.addSubview(centerButton)
        centerButton.setBackgroundImage(UIImage(named: "scannerRound"), for: .normal)
        centerButton.addTarget(self, action: #selector(centerButtonAction(sender:)), for: .touchUpInside)
        
        view.layoutIfNeeded()
    }
    
    // MARK: - Center button Actions
    
    @objc private func centerButtonAction(sender: UIButton) {
        selectedIndex = 2
    }
}
