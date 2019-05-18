//
//  ReferenceImageController.swift
//  GoPark
//
//  Created by Michael Wong on 28/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit

class ReferenceImageController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viwImage: UIImageView!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var selectedimage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set navigaiton bar title based on language
        self.navigationBar.topItem?.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ReferenceImageController_title", comment: "")
        self.btnBack.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "navigation_bar_back_button", comment: "")
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        viwImage.image = UIImage(named: selectedimage)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.viwImage
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
