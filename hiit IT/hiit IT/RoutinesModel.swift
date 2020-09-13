//
//  RoutinesModel.swift
//  hiit IT
//
//  Created by Emily Widjaja on 9/9/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import Foundation

class RoutinesModel {
    
    func generateRoutineCells() -> [Routines] {
        //generates Cells. First string is appropriate image, and second string is name of exercise. For now will not implement user interactivity.
        var routineList = [Routines]()
        
        let generatedRoutine1 = Routines()
        generatedRoutine1.routineName = "Abs HIIT"
        generatedRoutine1.exercises = 2
        generatedRoutine1.exerciseDuration = 5
        generatedRoutine1.exerciseRestDuration = 3
        generatedRoutine1.setRestDuration = 4
        generatedRoutine1.sets = 2
        
        routineList.append(generatedRoutine1)
        
        //last cell should always be add new routine
       /* let addnewRoutine = Routines()
        addnewRoutine.routineName = "Add new workout"
        routineList.append(generatedRoutine1) */
        
        return routineList
    }
}
