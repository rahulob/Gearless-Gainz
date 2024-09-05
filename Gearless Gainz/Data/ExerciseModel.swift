//
//  ExerciseModel.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 18/08/24.
//

import Foundation
import SwiftData

@Model
final class Exercise: Identifiable{
    var id: UUID
    @Attribute(.unique) var name: String
    var note: String
    var targetMuscle: TargetMuscle
    var youtubeURL: URL?
    @Attribute(.externalStorage) var photo: Data?
    
    @Relationship(deleteRule: .cascade)
    var entries = [WorkoutEntry]()
    
    @Relationship(deleteRule: .cascade)
    var routineEntries = [RoutineWorkoutEntry]()
    
    init(id: UUID = UUID(), name: String, targetMuscle: TargetMuscle, note: String = "", youtubeURL: URL? = nil) {
        self.id = id
        self.name = name
        self.targetMuscle = targetMuscle
        self.note = note
        self.youtubeURL = youtubeURL
//        self.history = history
    }
}

// enum for the target muscles of the exercises
enum TargetMuscle: String, Codable, CaseIterable {
    case back
    case biceps
    case chest
    case forearms
    case legs
    case shoulders
    case triceps
    case calves
    case core
    case other
    // Add more muscle groups as needed
    var displayName: String {
            switch self {
            default: return rawValue.capitalized
            }
        }
}
