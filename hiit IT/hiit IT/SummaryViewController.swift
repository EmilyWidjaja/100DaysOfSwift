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
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var exercisesLabel: UILabel!
    @IBOutlet weak var exerciseDurationLabel: UILabel!
    @IBOutlet weak var restDurationLabel: UILabel!
    @IBOutlet weak var setRestDurationLabel: UILabel!
    
    
    var workoutToLoad: Routines?    //refactor so selected workout uses workout To Load

    override func viewDidLoad() {
        super.viewDidLoad()
        
        workoutName.text = workoutToLoad?.routineName
        setsLabel.text = "\(workoutToLoad?.sets! ?? 0)"
        exercisesLabel.text = "\(workoutToLoad?.exercises! ?? 0)"
        exerciseDurationLabel.text = "\(workoutToLoad?.exerciseDuration! ?? 0)s"
        restDurationLabel.text =  "\(workoutToLoad?.exerciseRestDuration! ?? 0)s"
        setRestDurationLabel.text = "\(workoutToLoad?.setRestDuration! ?? 0)s"
    
    }
    

    
    @IBAction func startButton(_ sender: UIButton) {
        //insert code to instantiate next screen, dismiss both previous screens and start timer
        if let timervc = storyboard?.instantiateViewController(identifier: "Timer") as? TimerViewController {
            timervc.workoutToLoad = workoutToLoad
            present(timervc, animated: true)
        } else {
            print("error! Timer VC not instantiated.")
            return
        }
        
    }
    
}
