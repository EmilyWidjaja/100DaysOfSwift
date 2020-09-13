//
//  TimerViewController.swift
//  hiit IT
//
//  Created by Emily Widjaja on 11/9/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    //The Workout Routine
    var workoutToLoad: Routines?
    var numberOfSets: Int?
    var numberOfExercises: Int?
    var exerciseDuration: Int?
    var restDuration: Int?
    var setRestDuration: Int?
    
    //Current place in Routine
    var currentSet = 1 {
        didSet {
            setLabel.text = "Set \(currentSet) of \(numberOfSets ?? 0)"
        }
    }
    var currentExercise = 1 {
        didSet {
            exerciseLabel.text = "Exercise \(currentExercise) of \(numberOfExercises ?? 0)"
        }
    }
    var timer: Timer?
    var segment = "Ex"
    
    //labels
    @IBOutlet weak var timeLeftLabel: UILabel!
    var timeLeft = 0 {
        didSet {
            timeLeftLabel.text = String(timeLeft)
        }
    }
    
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //loads data
        numberOfSets = workoutToLoad?.sets
        numberOfExercises = workoutToLoad?.exercises
        exerciseDuration = workoutToLoad?.exerciseDuration
        restDuration = workoutToLoad?.exerciseRestDuration
        setRestDuration = workoutToLoad?.setRestDuration
        
        currentExercise = 1
        currentSet = 1
        
        //start program
        setUpTimer(segment: segment) //default starts with exercise
    }
    
    //MARK: Timer Methods
    //starts timer
    func setUpTimer(segment: String) {
        print("Timer set up. for \(segment) segment.")
        switch segment {
        case "Ex":
            timeLeft = exerciseDuration!
        case "Rest":
            timeLeft = restDuration!
        case "Set Rest":
            timeLeft = setRestDuration!
        default:
            print("wrong keyword!")
        }
        print(timeLeft)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    //timer function to fire timer & decide next timer
    @objc func fireTimer() {
        timeLeft -= 1
        if timeLeft == 0 {//2nd exercise segment not activating
            timer?.invalidate()
            print("timer invalidated")
            
            //decides next step
            switch segment {
            case "Ex":
                //add check for last exercise before starting timer
                if currentExercise == numberOfExercises {
                    check()
                } else {
                    segment = "Rest"
                    setUpTimer(segment: segment)
                }
            case "Rest":
                check()
            case "Set Rest":
                segment = "Ex"
                setUpTimer(segment: segment)
            default:
                print("Error! None of the cases are found.")
            }
        }
    }
    
    func check() {
        if currentExercise >= numberOfExercises! {
            if currentSet >= numberOfSets! {
                //finished routine
                print("Routine finished")
                finish()
            } else { //routine not finished, start next set
                segment = "Set Rest"
                print("Set finished but routine not finished, next set")
                currentSet += 1
                currentExercise = 1
                setUpTimer(segment: segment)
            }
        } else {
            //set not finished, start next exercise
            currentExercise += 1
            print("start next exercise")
            segment = "Ex"
            setUpTimer(segment: segment)
        }
    }
    
    
    //MARK: Routine finished
    func finish() {
        let ac = UIAlertController(title: "Exercise Complete!", message: "Congratulations!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    

}

