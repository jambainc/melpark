//
//  SettingQuestionController.swift
//  GoPark
//
//  Created by Michael Wong on 11/5/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

class SettingQuestionController: UIViewController {

    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set navigaiton bar title (language)
        self.navigationBar.topItem?.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingQuestionController_title", comment: "")
        self.btnBack.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "navigation_bar_back_button", comment: "")
        
        self.textView.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingQuestionController_textView", comment: "")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
