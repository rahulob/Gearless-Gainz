//
//  Workout.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import Foundation
import SwiftData

// Main workout model
// Ideally one person will create one workout for each day
@Model
final class Workout: Identifiable{
    var id: UUID
    var date: Date
    var name: String?
    
    @Relationship(deleteRule: .cascade)
    var entries = [WorkoutEntry]()
    
    init(id: UUID = UUID(), date: Date, name: String? = nil) {
        self.id = id
        self.date = date
        self.name = name
    }
}

// This will be the exercise data inside each workout
@Model
final class WorkoutEntry: Identifiable {
    var id: UUID
    @Relationship(deleteRule: .cascade)
    var sets: [ExerciseSet]
    var order: Int
    var workout: Workout?
    var exercise: Exercise
    
    init(id: UUID = UUID(), exercise: Exercise, sets: [ExerciseSet]=[], order: Int, workout: Workout? = nil) {
        self.id = id
        self.exercise = exercise
        self.sets = sets
        self.order = order
        self.workout = workout
    }
}

@Model
final class ExerciseSet: Identifiable{
    var weight: Double
    var reps: Int
    var order: Int
    var setType: exerciseSetType
    var id: UUID
    var workoutEntry: WorkoutEntry?
    
    init(id: UUID = UUID(), weight: Double, reps: Int, setType: exerciseSetType = .working, workoutEntry: WorkoutEntry? = nil, order: Int) {
        self.id = id
        self.weight = weight
        self.reps = reps
        self.setType = setType
        self.order = order
        self.workoutEntry = workoutEntry
    }
}

// enum for the type of set
enum exerciseSetType: String, Codable, CaseIterable {
    case warmup
    case working
    case dropSet

    // Add more muscle groups as needed
    var displayIcon: String {
        switch self {
        case .warmup: return "flame.fill"
        case .dropSet: return "drop.fill"
        case .working: return "figure.strengthtraining.traditional"
        }
    }
    
    var displayName: String {
        switch self {
        case .warmup: return "Warm Up"
        case .dropSet: return "Drop Set"
        case .working: return "Working"
        }
    }
}
