//
//  ReferenceDetailsController.swift
//  GoPark
//
//  Created by Michael Wong on 20/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit


class ReferenceDetailsController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var categoryNum = -1
    
    var images = [[""]]
    
    let imageEnglish = [
        ["p1en", "p4en", "p3en", "p2en"],
        ["s1en", "s2en"],
        ["z1en", "z2en", "z3en", "z4en", "z5en", "z6en", "z7en"],
        ["d1en"],
        ["c1en", "c2en"]
    ]
    
    let imageChinese = [
        ["p3cn", "p4cn", "p1cn", "p2cn"],
        ["s1cn", "s2cn"],
        ["z1cn", "z2cn", "z3cn", "z4cn", "z5cn", "z6cn", "z7cn"],
        ["d1cn"],
        ["c1cn", "c2cn"]
    ]
    
    var detailsToImageSegueData = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigaiton bar title based on language
        self.navigationBar.topItem?.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceDetailsController_title", comment: "")
        self.btnBack.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "navigation_bar_back_button", comment: "")
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en"{
            images = imageEnglish
        }else{
            images = imageChinese
        }
    }
    

    // decide how many row in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images[categoryNum].count
    }
    
    // loop throught the cell and assign image to cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let imageName = images[categoryNum][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReferenceDetailsControllerTableViewCell") as! ReferenceDetailsControllerTableViewCell
        
        //set card view round corner and shadow
        cell.viwCard.layer.cornerRadius = 10
        cell.viwCard.layer.shadowColor = UIColor.lightGray.cgColor
        cell.viwCard.layer.shadowOpacity = 0.8
        cell.viwCard.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.viwCard.layer.shadowRadius = 5
        
        cell.imageUIView.image = UIImage(named: imageName)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailsToImageSegueData = images[categoryNum][indexPath.row]
        performSegue(withIdentifier: "DetailsToImageSegue", sender: nil)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsToImageSegue"
        {
            let referenceImageController = segue.destination as? ReferenceImageController
            referenceImageController?.selectedimage = detailsToImageSegueData
        }
    }

}


