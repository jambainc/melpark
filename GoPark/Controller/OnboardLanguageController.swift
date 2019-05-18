//
//  OnboardLanguageController.swift
//  GoPark
//
//  Created by Michael Wong on 19/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

class OnboardLanguageController: UIViewController {

    
    @IBAction func btnSelectEnglish(_ sender: Any) {
        LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
    }
    
    @IBAction func btnSelectChinese(_ sender: Any) {
        LocalizationSystem.sharedInstance.setLanguage(languageCode: "zh-Hans")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
