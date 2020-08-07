//
//  webViewController.swift
//  Project16(MapKit)
//
//  Created by Emily Widjaja on 20/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit
import WebKit

class webViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var websiteToLoad: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //load view
        print(websiteToLoad!)
        guard let url = URL(string: websiteToLoad!) else {
            //could add error AC
            print("Cannot be loaded")
            return
        }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
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
