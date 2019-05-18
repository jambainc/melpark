//
//  ParkingPopupFilterController.swift
//  GoPark
//
//  Created by Michael Wong on 8/5/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

class ParkingPopupFilterController: UIViewController {

    @IBOutlet weak var viwBackground: UIView!
    @IBOutlet weak var viwPopupPanel: UIView!
    
    
    @IBOutlet weak var lblParkingTime: UILabel!
    @IBOutlet weak var lblFreeOnly: UILabel!
    @IBOutlet weak var lblLoadingZone: UILabel!
    @IBOutlet weak var lblDisabled: UILabel!
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var sliderDuration: UISlider!
    @IBOutlet weak var switchPaid: UISwitch!
    @IBOutlet weak var switchLoadingZone: UISwitch!
    @IBOutlet weak var switchDisabled: UISwitch!
    
    
    @IBAction func sliderDuration(_ sender: UISlider) {
        filterDuration = String(Int(sender.value)) //get the value of slider, parse it into Int and into String
        if LocalizationSystem.sharedInstance.getLanguage() == "en" {
            lblDuration.text = String(filterDuration) + " minutes" //and update the duration Label value immidately
        }else if LocalizationSystem.sharedInstance.getLanguage() == "zh-Hans" {
            lblDuration.text = String(filterDuration) + " 分钟" //and update the duration Label value immidately
        }
    }
    @IBAction func switchPaid(_ sender: UISwitch) {
        if sender.isOn == false {
            filterPaid = "1"
        }else{
            filterPaid = "0"
        }
    }
    @IBAction func switchLoadingZone(_ sender: UISwitch) {
        if sender.isOn == false {
            filterLoadingZone = "0"
        }else{
            filterLoadingZone = "1"
        }
    }
    @IBAction func switchDisabled(_ sender: UISwitch) {
        if sender.isOn == false {
            filterDisabled = "0"
        }else{
            filterDisabled = "1"
        }
    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        //when confirm button is clicked, update the all filter userDefault value
        UserDefaults.standard.set(filterDuration, forKey: "filterDuration")
        UserDefaults.standard.set(filterPaid, forKey: "filterPaid")
        UserDefaults.standard.set(filterLoadingZone, forKey: "filterLoadingZone")
        UserDefaults.standard.set(filterDisabled, forKey: "filterDisabled")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //store the duration slider value
    var filterDuration = ""
    var filterPaid = ""
    var filterLoadingZone = ""
    var filterDisabled = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set navigaiton bar title (language)
        self.lblParkingTime.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingPopupFilterController_lblParkingTime", comment: "")
        self.lblFreeOnly.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingPopupFilterController_lblFreeOnly", comment: "")
        self.lblLoadingZone.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingPopupFilterController_lblLoadingZone", comment: "")
        self.lblDisabled.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingPopupFilterController_lblDisabled", comment: "")
        self.btnConfirm.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingPopupFilterController_btnConfirm", comment: ""), for: .normal)
        self.btnCancel.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingPopupFilterController_btnCancel", comment: ""), for: .normal)
        
        
        // set button style
        btnConfirm.layer.cornerRadius = 5
        btnCancel.layer.cornerRadius = 5
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1).cgColor
        // set popup panel style
        viwPopupPanel.layer.cornerRadius = 10
        viwPopupPanel.layer.shadowColor = UIColor.lightGray.cgColor
        viwPopupPanel.layer.shadowOpacity = 1
        viwPopupPanel.layer.shadowOffset = CGSize.zero
        viwPopupPanel.layer.shadowRadius = 10
        
        
        let tabOnBackground = UITapGestureRecognizer(target: self, action:  #selector(self.dismissCurrentView))
        self.viwBackground.addGestureRecognizer(tabOnBackground)
        
        //duration
        filterDuration = UserDefaults.standard.string(forKey: "filterDuration") ?? "5" //get duration from userDefault
        sliderDuration.setValue(Float(filterDuration)!, animated: true) //set  value of duration slider
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en" {
            lblDuration.text = filterDuration + " minutes" //set value of duration label
        }else if LocalizationSystem.sharedInstance.getLanguage() == "zh-Hans" {
            lblDuration.text = filterDuration + " 分钟" //set value of duration label
        }
        
        
        //paid
        filterPaid = UserDefaults.standard.string(forKey: "filterPaid") ?? "0"
        if filterPaid == "1" {
            switchPaid.setOn(false, animated: true)
        }else{
            switchPaid.setOn(true, animated: true)
        }
        
        //loading zone
        filterLoadingZone = UserDefaults.standard.string(forKey: "filterLoadingZone") ?? "0"
        if filterLoadingZone == "0" {
            switchLoadingZone.setOn(false, animated: true)
        }else{
            switchLoadingZone.setOn(true, animated: true)
        }
        
        //disabled
        filterDisabled = UserDefaults.standard.string(forKey: "filterDisabled") ?? "0"
        if filterDisabled == "0" {
            switchDisabled.setOn(false, animated: true)
        }else{
            switchDisabled.setOn(true, animated: true)
        }
    }
    
    @objc func dismissCurrentView(sender : UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
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
