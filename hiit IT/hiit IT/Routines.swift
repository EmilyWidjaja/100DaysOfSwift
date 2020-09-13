//
//  Routines.swift
//  hiit IT
//
//  Created by Emily Widjaja on 9/9/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import Foundation

class Routines {
    
    var routineName = ""
    var sets:Int?
    var exercises:Int? //exercises in each set
    var exerciseDuration:Int? //number of seconds
    var exerciseRestDuration:Int?
    var setRestDuration:Int?
    
    //assumes a basic exercise, TODO: Allow for more complex variations
    
    //build a set - TODO: allow for exericise name inputs
    func buildSet() -> [String:Int] {
        var set = [String:Int]()
        
        for i in 1...exercises! {
            let exerciseName = "Exercise " + String(i)
            let restName = "Rest " + String(i)
            set[exerciseName] = exerciseDuration!
            
            if i != exercises! {
                set[restName] = exerciseRestDuration!
            }
        }
        
        return set
    }
        
    //build a routine
    func buildRoutine() -> [String:Int] {
        var routine = [String:Int]()
        
        for i in 1...sets! {
            let restName = "Rest after set " + String(i)
            let setGenerated = self.buildSet()
            routine.merge(dict: setGenerated)
            
            if i != sets! {
                routine[restName] = setRestDuration!
            }
        }
        
        return routine
    }
    


}
