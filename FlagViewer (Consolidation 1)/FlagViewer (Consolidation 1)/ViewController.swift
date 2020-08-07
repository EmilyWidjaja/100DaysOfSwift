//
//  ViewController.swift
//  FlagViewer (Consolidation 1)
//
//  Created by Emily Widjaja on 7/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var flagArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        flagArray += ["uk", "spain", "russia", "poland", "nigeria", "italy", "monaco", "ireland", "germany", "france", "estonia", "us"]
        print(flagArray)
        title = "Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        cell.textLabel?.text = flagArray[indexPath.row].uppercased()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        vc?.imageToShow = flagArray[indexPath.row]
        navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
}

