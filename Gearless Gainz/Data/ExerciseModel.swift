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
