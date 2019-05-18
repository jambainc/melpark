//
//  ParkingPopupNavigationController.swift
//  GoPark
//
//  Created by Michael Wong on 23/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//  http://52.62.205.70/en/parking.php?bayid=4212 (old)
//  http://52.62.205.70/en/bay.php?bayid=4234&lat=-37&long=143

import UIKit

class ParkingPopupNavigationController: UIViewController {
    
    @IBOutlet var viwBackground: UIView!
    @IBOutlet weak var viwPopupPanel: UIView!
    @IBOutlet weak var viwOccRate: UIView!
    @IBOutlet weak var lblTypedesc: UILabel!
    @IBOutlet weak var lblTravelTime: UILabel!
    @IBOutlet weak var lblHumanDesc: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblNextAvailable: UILabel!
    @IBOutlet weak var btnNavigate: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBAction func btnNavigate(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnConfirm(_ sender: Any) {
        
    }
    
    var selectedAnnotation: MyCustomPointAnnotation?
    let dispatchGroup = DispatchGroup()
    var api2Decodables: [API2Decodable]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //set button (language)
        self.btnConfirm.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingPopupNavigationController_btnConfirm", comment: ""), for: .normal)
        self.btnNavigate.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingPopupNavigationController_btnNavigate", comment: ""), for: .normal)
        
        // set button style
        btnConfirm.layer.cornerRadius = 5
        btnNavigate.layer.cornerRadius = 5
        btnNavigate.layer.borderWidth = 1
        btnNavigate.layer.borderColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1).cgColor
        // set popup panel style
        viwPopupPanel.layer.cornerRadius = 10
        viwPopupPanel.layer.shadowColor = UIColor.lightGray.cgColor
        viwPopupPanel.layer.shadowOpacity = 0.5
        viwPopupPanel.layer.shadowOffset = CGSize.zero
        viwPopupPanel.layer.shadowRadius = 10
        
        // set occRate view to be circel
        viwOccRate.layer.cornerRadius = 10
        
        let tabOnBackground = UITapGestureRecognizer(target: self, action:  #selector(self.dismissCurrentView))
        viwBackground.addGestureRecognizer(tabOnBackground)
        
        requestDataFromAPI2()
        dispatchGroup.notify(queue: .main){
            
            //set viwOccRate circle view color
            let occRateColor = self.api2Decodables[0].occRate ?? "blue"
            if occRateColor == "green" {
                self.viwOccRate.backgroundColor = UIColor(red: 59/255, green: 209/255, blue: 137/255, alpha: 1)
            }else if occRateColor == "red"{
                self.viwOccRate.backgroundColor = UIColor.red
            }else{
                self.viwOccRate.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
            }
            
            if LocalizationSystem.sharedInstance.getLanguage() == "en" {
                //set sign label
                self.lblTypedesc.text = self.api2Decodables[0].sign ?? "Unknown"
                //set travel time label
                let travelTimeSecond = self.api2Decodables[0].traveltime ?? 1
                let travelTimeMinute: Int = travelTimeSecond / 60
                let travelTime: String = String(travelTimeMinute) + " mins travel"
                self.lblTravelTime.text = travelTime
                //set humanDesc label
                self.lblHumanDesc.text = self.api2Decodables[0].humanDesc ?? "Human readable Unknown"
                //set cost label
                let cost = self.api2Decodables[0].cost ?? 0
                if cost == 0 {
                    self.lblCost.text = "Cost: $ 0"
                }else{
                    self.lblCost.text = "Cost: $ " + String(cost)
                }
                //set nextAvailable label
                let nextAvailable = self.api2Decodables[0].nextAvailable ?? "Unknown"
                self.lblNextAvailable.text = "Available: " + nextAvailable
                
            }else if LocalizationSystem.sharedInstance.getLanguage() == "zh-Hans" {
                //set sign label
                self.lblTypedesc.text = self.api2Decodables[0].sign ?? "Unknown"
                //set travel time label
                let travelTimeSecond = self.api2Decodables[0].traveltime ?? 1
                let travelTimeMinute: Int = travelTimeSecond / 60
                let travelTime: String = String(travelTimeMinute) + " 分钟车程"
                self.lblTravelTime.text = travelTime
                //set humanDesc label
                self.lblHumanDesc.text = self.api2Decodables[0].humanDesc ?? "未知"
                //set cost label
                let cost = self.api2Decodables[0].cost ?? 0
                if cost == 0 {
                    self.lblCost.text = "费用: $ 0"
                }else{
                    self.lblCost.text = "费用: $ " + String(cost)
                }
                //set nextAvailable label
                let nextAvailable = self.api2Decodables[0].nextAvailable ?? "Unknown"
                if nextAvailable == "Now"{
                    self.lblNextAvailable.text = "闲置: 现在"
                }else{
                    self.lblNextAvailable.text = "闲置: " + nextAvailable
                }

            }
            
        }
    }
    
    @objc func dismissCurrentView(sender : UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func requestDataFromAPI2(){
        
        //enter
        self.dispatchGroup.enter()
        
        //http://52.62.205.70/en/bay.php?bayid= old
        //http://goparkapi-prodssl.tk/en/bay.php?bayid=
        
        //check language to define URL
        var urlStr = ""
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en" {
            urlStr = "https://goparkapi-prodssl.tk/en/bay.php?bayid=" + String(selectedAnnotation!.bayid) + "&lat=-37.876729&long=145.044886"
        }else if LocalizationSystem.sharedInstance.getLanguage() == "zh-Hans" {
            urlStr = "https://goparkapi-prodssl.tk/cn/bay.php?bayid=" + String(selectedAnnotation!.bayid) + "&lat=-37.876729&long=145.044886"
        }
        
        print("API2: " + urlStr)
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            do{
                //let jsons = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                //print(jsons)
                
                //decode the data and store in an array call users
                let api2Decodables = try JSONDecoder().decode([API2Decodable].self, from: data!)
                //print(api2Decodables)
                self.api2Decodables = api2Decodables
                //leave
                self.dispatchGroup.leave()
            }catch{
                print("Error info: \(error)")
            }
            }.resume()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ParkingNavigationToConfirmSegue"
        {
            let parkingConfirmController = segue.destination as? ParkingConfirmController
            parkingConfirmController?.selectedAnnotation = selectedAnnotation
        }
    }

}
