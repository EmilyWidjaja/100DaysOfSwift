//
//  ViewController.swift
//  hiit IT
//
//  Created by Emily Widjaja on 2/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//  Home screen

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    let routineModel = RoutinesModel()
    var workoutArray = [Routines]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100.0
        
        //generates/retrieves workouts that should be in there. TODO: Add memory function
        workoutArray = routineModel.generateRoutineCells()
    }
    
    //MARK: -Table methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Routine", for: indexPath)
        cell.textLabel?.text = workoutArray[indexPath.row].routineName
        cell.textLabel?.font = UIFont(name: "Arial", size: 20)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "Summary") as? SummaryViewController {
            
            let routineToLoad = workoutArray[indexPath.row]
            
            controller.workoutToLoad = routineToLoad
            //TODO: Implement for multiple sets and different hiit types
            
            present(controller, animated: true)
        }
    }


}

