//
//  SettingWebsiteController.swift
//  GoPark
//
//  Created by Michael Wong on 12/5/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit
import WebKit

class SettingWebsiteController: UIViewController, WKNavigationDelegate {

    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set delegate
        webView.navigationDelegate = self
        
        //define url
        let url = URL(string: "https://www.melpark.ml")!
        webView.load(URLRequest(url: url))
        
        webView.allowsBackForwardNavigationGestures = true
        
        //set navigaiton bar title (language)
        self.navigationBar.topItem?.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingWebsiteController_title", comment: "")
        self.btnBack.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "navigation_bar_back_button", comment: "")
        
        //set up activity indicator
        activityIndicator.hidesWhenStopped = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
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
