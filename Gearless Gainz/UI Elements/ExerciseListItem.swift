//
//  ExerciseListItem.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 18/08/24.
//

import SwiftUI

struct ExerciseListItem: View {
    @State var exercise: Exercise
    var showInfoButton: Bool = true
    
    var body: some View {
        HStack(spacing: 16){
            ExerciseImage(photoData: exercise.photo)
            if showInfoButton{
                ExerciseName(name: exercise.name, targetMuscle: exercise.targetMuscle.displayName)
            }
            NavigationLink(destination: EditExerciseView(exercise: $exercise, isNewExercise: false)){
                if showInfoButton{
                    Image(systemName: "info.circle.fill")
                } else {
                    ExerciseName(name: exercise.name, targetMuscle: exercise.targetMuscle.displayName)
                }
            }
        }
    }
}

private struct ExerciseName: View {
    var name: String
    var targetMuscle: String
    var body: some View {
        VStack(alignment: .leading){
            Text(name)
                .font(.title3)
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Text(targetMuscle)
                .font(.caption)
        }
        Spacer()
    }
}
