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
