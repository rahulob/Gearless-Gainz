//
//  RoutinesModel.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 03/09/24.
//

import Foundation
import SwiftData

@Model
final class Routine: Identifiable {
    var id: UUID
    @Attribute(.unique) var name: String
    var note: String?
    var order: Int
    @Relationship(deleteRule: .cascade)
    var workouts = [RoutineWorkout]()
    
    init(id: UUID = UUID(), name: String, order: Int, note: String? = nil) {
        self.id = id
        self.name = name
        self.order = order
        self.note = note
    }
}

@Model
final class RoutineWorkout: Identifiable {
    var id: UUID
    var routine: Routine?
    @Relationship(deleteRule: .cascade)
    var entries = [RoutineWorkoutEntry]()
    
    init(id: UUID = UUID(), routine: Routine? = nil) {
        self.id = id
        self.routine = routine
    }
}

@Model
final class RoutineWorkoutEntry: Identifiable {
    var exercise: Exercise
    var sets: Int
    var routineWorkout: RoutineWorkout?
    
    init(exercise: Exercise, sets: Int, routineWorkout: RoutineWorkout? = nil) {
        self.exercise = exercise
        self.sets = sets
        self.routineWorkout = routineWorkout
    }
}