//
//  SettingLanguageController.swift
//  GoPark
//
//  Created by Michael Wong on 20/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

class SettingLanguageController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //define the table view cell icon name and title
    let rowTitles = ["English", "简体中文"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigaiton bar title based on language
        self.navigationBar.topItem?.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingLanguageController_title", comment: "")
        self.btnBack.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "navigation_bar_back_button", comment: "")
    }
    
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingLanguageControllerTableViewCell", for: indexPath)
        cell.textLabel?.text = rowTitles[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //remove the row selection after tapping on the cell
        //If user current language is English and English cell is selected, show a deny alert to tell it is current language (return)
        if (LocalizationSystem.sharedInstance.getLanguage() == "en" && indexPath.row == 0) || (LocalizationSystem.sharedInstance.getLanguage() == "zh-Hans" && indexPath.row == 1){
            //showDenyAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingLanguageController_denyAlert", comment: ""))
            showToast(controller: self, message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingLanguageController_denyAlert", comment: ""), seconds: 1)
            return
        }
        // if above does not return, show an alart to confirm setting new language
        switch indexPath.row {
        case 0:
            showConfirmEnglishAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingLanguageController_confirmEnglishAlert", comment: ""))
        case 1:
            showConfirmChineseAlert(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingLanguageController_confirmChineseAlert", comment: ""))
        default:
            print("error")
        }
        
    }
    
    /**
    func showDenyAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
     **/
    
    func showToast(controller: UIViewController, message : String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .white
        alert.view.alpha = 1.0
        alert.view.layer.cornerRadius = 15
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    func showConfirmEnglishAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.default, handler: { (action) in
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            self.refreshAllPages()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showConfirmChineseAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "zh-Hans")
            self.refreshAllPages()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func refreshAllPages() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let uiTabBarController = storyboard.instantiateViewController(withIdentifier: "UITabbarIdentifier")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = uiTabBarController
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
