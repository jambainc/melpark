//
//  OnboardView1Controller.swift
//  GoPark
//
//  Created by Michael Wong on 14/5/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

class OnboardView1Controller: UIViewController {

    
    @IBOutlet weak var lblMessage1: UILabel!
    @IBOutlet weak var lblMessage2: UILabel!
    @IBOutlet weak var lblMessage3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblMessage1.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "OnboardView1Controller_lblMessage1", comment: "")
        lblMessage2.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "OnboardView1Controller_lblMessage2", comment: "")
        lblMessage3.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "OnboardView1Controller_lblMessage3", comment: "")
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
