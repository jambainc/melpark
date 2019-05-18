//
//  ScannerResultController.swift
//  GoPark
//
//  Created by Michael Wong on 29/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

class ScannerResultController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var lblIdentfier: UILabel!
    @IBOutlet weak var lblConfidence: UILabel!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var imgResult: UIImageView!
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var identfier = ""
    var confidence = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigaiton bar title (language)
        self.navigationBar.topItem?.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ScannerResultController_title", comment: "")
        self.btnBack.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "navigation_bar_back_button", comment: "")
        
        //self.lblIdentfier.text = identfier
        //self.lblConfidence.text = confidence
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en" {
            if identfier == "1 hour parking" {
                imgResult.image = UIImage(named: "p3en")
            } else if identfier == "No Stopping"{
                imgResult.image = UIImage(named: "s1en")
            } else if identfier == "Bus Zone"{
                imgResult.image = UIImage(named: "z4en")
            }else if identfier == "2 hour parking"{
                imgResult.image = UIImage(named: "p2en")
            }
        }else if LocalizationSystem.sharedInstance.getLanguage() == "zh-Hans" {
            if identfier == "1 hour parking" {
                imgResult.image = UIImage(named: "p1cn")
            } else if identfier == "No Stopping"{
                imgResult.image = UIImage(named: "s1cn")
            } else if identfier == "Bus Zone"{
                imgResult.image = UIImage(named: "z4cn")
            } else if identfier == "2 hour parking"{
                imgResult.image = UIImage(named: "p2cn")
            }
        }
        
        
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
