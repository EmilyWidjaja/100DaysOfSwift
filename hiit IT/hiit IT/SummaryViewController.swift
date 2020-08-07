//
//  SummaryViewController.swift
//  hiit IT
//
//  Created by Emily Widjaja on 2/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    @IBOutlet var workoutName: UILabel!
    var selectedWorkout: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if workoutToLoad == selectedWorkout {
            workoutName.attributedText = selectedWorkout
        }

        // Do any additional setup after loading the view.
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
