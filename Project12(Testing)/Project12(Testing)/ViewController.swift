//
//  ViewController.swift
//  Project12(Testing)
//
//  Created by Emily Widjaja on 15/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard            //default data
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UseFaceID")
        defaults.set(CGFloat.pi, forKey: "Pi")
        defaults.set("Emily Widjaja", forKey: "Name")
        defaults.set(Date(), forKey: "LastRun")
        
        let array = ["Hello", "World"]
        defaults.set(array, forKey: "SavedArray")
        
        let dict = ["Name": "Emily", "Country": "DK"]
        defaults.set(dict, forKey: "SavedDictionary")
        
        let savedInteger = defaults.integer(forKey: "Age")  //extracts age - 25
        let savedBool = defaults.bool(forKey: "UseFaceID")
        
        //for arrays & dicts - are objects, so should use .object (or potentially .array) and then typecast
        let savedArray = defaults.object(forKey: "SavedArray") as? [String] ?? [String]()   //if it doesn't exist, then makes empty string array
        let savedDictionary = defaults.object(forKey: "SavedDictionary") as? [String: String] ?? [String: String]()
        
        let savedArray2 = defaults.array(forKey: <#T##String#>)
        
    }


}

