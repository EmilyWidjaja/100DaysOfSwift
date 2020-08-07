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

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //extensionContext controls the data from parent app. inputItems is data from parent app.
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {    //pulls out first item that shared with us
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in  //loadItem - tells itemProvider to actually load the first item
                    //handler to do stuff
                    
                }
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}