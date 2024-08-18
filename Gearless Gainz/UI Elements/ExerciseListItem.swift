//
//  ExerciseListItem.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 18/08/24.
//

import SwiftUI

struct ExerciseListItem: View {
    @State private var showInfoSheet = false
    @State var exercise: Exercise
    
    var body: some View {
        HStack(spacing: 16){
            ExerciseImage(photoData: exercise.photo)
            VStack(alignment: .leading){
                Text(exercise.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(2)
                
                Text(exercise.targetMuscle.displayName)
                    .font(.caption)
            }
            Spacer()
            NavigationLink(destination: EditExerciseView(exercise: $exercise, isNewExercise: false)){
                Image(systemName: "info.circle.fill")
            }
        }
    }
}
