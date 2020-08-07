//
//  ViewController.swift
//  hiit IT
//
//  Created by Emily Widjaja on 2/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var workoutsArray = ["Abs", "Legs", "Arms"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Routine", for: indexPath)
        cell.textLabel?.text = workoutsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "Summary") as? SummaryViewController {
            controller.selectedWorkout = workoutsArray[indexPath.row]
        }
    }


}

