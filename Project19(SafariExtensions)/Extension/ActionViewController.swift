//
//  ActionViewController.swift
//  Extension
//
//  Created by Emily Widjaja on 22/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create bar button item to call done
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        //talks to extension and updates UI w/ URL & Title
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {    //pulls out first item that shared with us
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in  //loadItem - tells itemProvider to actually load the first item
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else {return} //gets code from extension?
                    
                    //update UI with values
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                    
                }
            }
        }
    }

    @IBAction func done() {
        //passes back the text user entered into text view
        //TODO: FIx code
        let item = NSExtensionItem()
        if script.text == nil {
            
            print("no text found!")
            return
        }
            let argument: NSDictionary = ["customJavaScript": script.text]
            let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
            let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
            item.attachments = [customJavaScript]
            extensionContext?.completeRequest(returningItems: [item])
        
    }

}
