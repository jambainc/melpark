//
//  ListController.swift
//  GoPark
//
//  Created by Michael Wong on 23/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//  http://52.62.205.70/distance.php?lat=-37.876729&long=145.044886&duration=5&paid=1&lz=0&disabled=0

import UIKit

class ListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let dispatchGroup = DispatchGroup()
    var api3Decodables: [API3Decodable]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set navigaiton bar title (language)
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ListController_title", comment: "")
        
        //set up activity indicator
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //readDataFromFile()
        requestDataFromAPI3()
        
        dispatchGroup.notify(queue: .main){
            self.activityIndicator.stopAnimating() //stop activity Indicator
            self.tableView.reloadData() // reload tableview data after http request
        }
    }
    
    func requestDataFromAPI3(){
        //enter
        self.dispatchGroup.enter()
        
        self.activityIndicator.startAnimating() //start activity Indicator
        
        //http://52.62.205.70/distance.php?lat=-37.876729&long=145.044886&duration=5&paid=1&lz=0&disabled=0
        //https://goparkapi-prodssl.tk/distance.php?lat=-37.876729&long=145.044886&duration=5&paid=1&lz=0&disabled=0
        
        //check language to define URL
        var urlStr = ""
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en" {
            urlStr = "https://goparkapi-prodssl.tk/en/distance.php?lat=-37.876729&long=145.044886" +
                "&duration=" + UserDefaults.standard.string(forKey: "filterDuration")! +
                "&paid=" + UserDefaults.standard.string(forKey: "filterPaid")! +
                "&lz=" + UserDefaults.standard.string(forKey: "filterLoadingZone")! +
                "&disabled=" + UserDefaults.standard.string(forKey: "filterDisabled")!
        }else if LocalizationSystem.sharedInstance.getLanguage() == "zh-Hans" {
            urlStr = "https://goparkapi-prodssl.tk/cn/distance.php?lat=-37.876729&long=145.044886" +
                "&duration=" + UserDefaults.standard.string(forKey: "filterDuration")! +
                "&paid=" + UserDefaults.standard.string(forKey: "filterPaid")! +
                "&lz=" + UserDefaults.standard.string(forKey: "filterLoadingZone")! +
                "&disabled=" + UserDefaults.standard.string(forKey: "filterDisabled")!
        }
        
        print("API3: " + urlStr)
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            do{
                if data == nil {
                    return
                }
                //let jsons = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                //print(jsons)
                
                //decode the data and store in an array call users
                let api3Decodables = try JSONDecoder().decode([API3Decodable].self, from: data!)
                //print(api3Decodables)
                self.api3Decodables = api3Decodables
                //leave
                self.dispatchGroup.leave()
            }catch{
                print("Error info: \(error)")
            }
        }.resume()
    }
    
    //MARK: - Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if api3Decodables == nil{
            return 0
        }else{
            return api3Decodables.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListControllerTableViewCell", for: indexPath) as! ListControllerTableViewCell
        
        //set card view round corner and shadow
        cell.viwCard.layer.cornerRadius = 10
        cell.viwCard.layer.shadowColor = UIColor.lightGray.cgColor
        cell.viwCard.layer.shadowOpacity = 0.8
        cell.viwCard.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.viwCard.layer.shadowRadius = 2
        
        //set count label
        cell.lblCount.text = "NO. " + String(indexPath.row + 1)
        
        //set cost label
        let cost = api3Decodables[indexPath.row].cost ?? 0
        if cost == 0 {
            cell.lblCost.text = "$ 0"
        }else{
            cell.lblCost.text = "$ " + String(cost)
        }
        
        //set occRate view color
        let occRateColor = api3Decodables[indexPath.row].occRate ?? "blue"
        if occRateColor == "green" {
            cell.viwOccRate.backgroundColor = UIColor(red: 59/255, green: 209/255, blue: 137/255, alpha: 1)
        }else if occRateColor == "red" {
            cell.viwOccRate.backgroundColor = UIColor.red
        }else{
            cell.viwOccRate.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        }
        
        //set sign label
        cell.lblSign.text = api3Decodables[indexPath.row].sign ?? "Unknown"
        
        //set address label
        cell.lblAddress.text = api3Decodables[indexPath.row].address ?? "Unknown"
        
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en" {
            //set travel time label
            let travelTimeSecond = api3Decodables[indexPath.row].traveltime ?? 1
            let travelTimeMinute: Int = travelTimeSecond / 60
            let travelTime: String = String(travelTimeMinute) + " mins travel"
            cell.lblTravelTime.text = travelTime
            
            //set nextAvailable label
            let nextAvailable = api3Decodables[indexPath.row].nextAvailable ?? "Unknown"
            cell.lblNextAvailable.text = "Available: " + nextAvailable
            
        }else if LocalizationSystem.sharedInstance.getLanguage() == "zh-Hans" {
            //set travel time label
            let travelTimeSecond = api3Decodables[indexPath.row].traveltime ?? 1
            let travelTimeMinute: Int = travelTimeSecond / 60
            let travelTime: String = String(travelTimeMinute) + " 分钟车程"
            cell.lblTravelTime.text = travelTime
            
            //set nextAvailable label
            let nextAvailable = api3Decodables[indexPath.row].nextAvailable ?? "Unknown"
            if nextAvailable == "Now"{
                cell.lblNextAvailable.text = "闲置: 现在"
            }else{
                cell.lblNextAvailable.text = "闲置: " + nextAvailable
            }
            
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //remove the row selection after tapping on the cell
        let bayid = api3Decodables[indexPath.row].bayid
        let parkingController = self.tabBarController?.childViewControllers.first as! ParkingController
        parkingController.showAnnotaitonSelectedFromList(bayid: bayid!)
        self.tabBarController?.selectedIndex = 0
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
