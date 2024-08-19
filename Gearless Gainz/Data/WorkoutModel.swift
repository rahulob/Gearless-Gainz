//
//  Workout.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import Foundation
import SwiftData

// enum for the target muscles of the exercises
enum TargetMuscle: String, Codable, CaseIterable {
    case back
    case chest
    case legs
    case shoulders
    case biceps
    case triceps
    case forearms
    case glutes
    case calves
    case core
    case fullBody
    // Add more muscle groups as needed
    var displayName: String {
            switch self {
            case .fullBody: return "Full Body"
            default: return rawValue.capitalized
            }
        }
}
// Main workout model
// Ideally one person will create one workout for each day
@Model
final class Workout: Identifiable{
    var id: UUID
    var date: Date
    
    @Relationship(deleteRule: .cascade)
    var exercises = [WorkoutExercise]()
    
    init(id: UUID = UUID(), date: Date) {
        self.id = id
        self.date = date
    }
}

// This will be the exercise data inside each workout
@Model
final class WorkoutExercise: Identifiable {
    var id: UUID
    var sets: [ExerciseSet]
    var order: Int
    var workout: Workout
    var exercise: Exercise
    
    init(id: UUID = UUID(), exercise: Exercise, sets: [ExerciseSet]=[], order: Int, workout: Workout) {
        self.id = id
        self.exercise = exercise
        self.sets = sets
        self.order = order
        self.workout = workout
    }
}

@Model
final class ExerciseSet: Identifiable{
    var weight: Float32
    var reps: Int
    var isWarmup: Bool
    var id: UUID
    
    init(id: UUID = UUID(),weight: Float32, reps: Int, isWarmup: Bool = false) {
        self.id = id
        self.weight = weight
        self.reps = reps
        self.isWarmup = isWarmup
    }
}
