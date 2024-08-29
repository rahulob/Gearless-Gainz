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
    
    @State private var showHistorySheet: Bool = false
    
    var body: some View {
        HStack(spacing: 16){
            ExerciseImage(photoData: exercise.photo)
            VStack(alignment: .leading){
                Text(exercise.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(exercise.targetMuscle.displayName)
                    .font(.caption)
            }
            Spacer()
            if showInfoButton{
                NavigationLink(destination: EditExerciseView(exercise: $exercise, isNewExercise: false)){
                    Image(systemName: "info.circle.fill")
                }
            } else {
                Button(action: { showHistorySheet.toggle() }){
                    Image(systemName: "calendar.badge.clock")
                        .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing)
                .sheet(isPresented: $showHistorySheet, content: {
                    ExerciseHistoryView(exercise: exercise)
                })
            }
        }
    }
}
