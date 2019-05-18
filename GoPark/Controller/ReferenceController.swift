//
//  ReferenceController.swift
//  GoPark
//
//  Created by Michael Wong on 20/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit


class ReferenceController: UIViewController {

    @IBOutlet weak var viwCategory1: UIImageView!
    @IBOutlet weak var viwCategory2: UIImageView!
    @IBOutlet weak var viwCategory3: UIImageView!
    @IBOutlet weak var viwCategory4: UIImageView!
    @IBOutlet weak var viwCategory5: UIImageView!
    
    @IBOutlet weak var lblCategory1Title: UILabel!
    @IBOutlet weak var lblCategory1Label1: UILabel!
    @IBOutlet weak var lblCategory1Label2: UILabel!
    @IBOutlet weak var lblCategory2Title: UILabel!
    @IBOutlet weak var lblCategory2Label1: UILabel!
    @IBOutlet weak var lblCategory2Label2: UILabel!
    @IBOutlet weak var lblCategory3Title: UILabel!
    @IBOutlet weak var lblCategory3Label1: UILabel!
    @IBOutlet weak var lblCategory3Label2: UILabel!
    @IBOutlet weak var lblCategory4Title: UILabel!
    @IBOutlet weak var lblCategory4Label1: UILabel!
    @IBOutlet weak var lblCategory4Label2: UILabel!
    @IBOutlet weak var lblCategory5Title: UILabel!
    @IBOutlet weak var lblCategory5Label1: UILabel!
    @IBOutlet weak var lblCategory5Label2: UILabel!
    
    //define a var to store which card user choose and used for navigation segue
    var referenceToDetailsSegueData = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigaiton bar title (language)
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_title", comment: "")
        
        //set the category label based on language
        self.lblCategory1Title.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_category1_title", comment: "")
        self.lblCategory1Label1.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_category1_label1", comment: "")
        self.lblCategory1Label2.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_category1_label2", comment: "")
        self.lblCategory2Title.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_category2_title", comment: "")
        self.lblCategory2Label1.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_category2_label1", comment: "")
        self.lblCategory2Label2.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_category2_label2", comment: "")
        self.lblCategory3Title.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_category3_title", comment: "")
        self.lblCategory3Label1.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_category3_label1", comment: "")
        self.lblCategory3Label2.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_category3_label2", comment: "")
        self.lblCategory4Title.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_category4_title", comment: "")
        self.lblCategory4Label1.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_category4_label1", comment: "")
        self.lblCategory4Label2.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_category4_label2", comment: "")
        self.lblCategory5Title.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_category5_title", comment: "")
        self.lblCategory5Label1.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_category5_label1", comment: "")
        self.lblCategory5Label2.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceController_category5_label2", comment: "")
        
        
        
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.performGesture1))
        self.viwCategory1.addGestureRecognizer(gesture1)
        self.viwCategory1.isUserInteractionEnabled = true
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.performGesture2))
        self.viwCategory2.addGestureRecognizer(gesture2)
        self.viwCategory2.isUserInteractionEnabled = true
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector(self.performGesture3))
        self.viwCategory3.addGestureRecognizer(gesture3)
        self.viwCategory3.isUserInteractionEnabled = true
        let gesture4 = UITapGestureRecognizer(target: self, action:  #selector(self.performGesture4))
        self.viwCategory4.addGestureRecognizer(gesture4)
        self.viwCategory4.isUserInteractionEnabled = true
        let gesture5 = UITapGestureRecognizer(target: self, action:  #selector(self.performGesture5))
        self.viwCategory5.addGestureRecognizer(gesture5)
        self.viwCategory5.isUserInteractionEnabled = true
    }
    
    //the 5 card onclick listener
    @objc func performGesture1(sender : UITapGestureRecognizer) {
        //pop up the table view of selected category
        referenceToDetailsSegueData = 0
        self.performSegue(withIdentifier: "ReferenceToDetailsSegue", sender: nil)
    }
    @objc func performGesture2(sender : UITapGestureRecognizer) {
        //pop up the table view of selected category
        referenceToDetailsSegueData = 1
        self.performSegue(withIdentifier: "ReferenceToDetailsSegue", sender: nil)
    }
    @objc func performGesture3(sender : UITapGestureRecognizer) {
        //pop up the table view of selected category
        referenceToDetailsSegueData = 2
        self.performSegue(withIdentifier: "ReferenceToDetailsSegue", sender: nil)
    }
    @objc func performGesture4(sender : UITapGestureRecognizer) {
        //pop up the table view of selected category
        referenceToDetailsSegueData = 3
        self.performSegue(withIdentifier: "ReferenceToDetailsSegue", sender: nil)
    }
    @objc func performGesture5(sender : UITapGestureRecognizer) {
        //pop up the table view of selected category
        referenceToDetailsSegueData = 4
        self.performSegue(withIdentifier: "ReferenceToDetailsSegue", sender: nil)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReferenceToDetailsSegue"
        {
            let referenceDetailsController = segue.destination as? ReferenceDetailsController
            referenceDetailsController?.categoryNum = referenceToDetailsSegueData
        }
    }
    

}
