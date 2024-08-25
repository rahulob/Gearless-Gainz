//
//  CopyWorkoutView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 25/08/24.
//

import SwiftUI
import SwiftData

struct CopyWorkoutView: View {
    @Query(sort: \Workout.date) private var allWorkouts: [Workout]
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedDate: Date
    
    var body: some View {
        NavigationStack {
            List(allWorkouts){ workout in
                CopyWorkoutItem(workout: workout, selectedDate: selectedDate)
            }
            .navigationTitle("Copy Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button("Dismiss", systemImage: "xmark.circle.fill"){
                        dismiss()
                    }
                }
            }
        }
    }
}

private struct CopyWorkoutItem: View {
    @Environment(\.modelContext) private var modelConext
    var workout: Workout
    var selectedDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(workout.date.formatted(date: .abbreviated, time: .omitted))
                Spacer()
                Button("Copy", systemImage: "doc.on.doc.fill"){
                    let newWorkout = Workout(date: selectedDate)
                    for entry in workout.entries {
                        newWorkout.entries.append(WorkoutEntry(exercise: entry.exercise, order: entry.order))
                    }
                    modelConext.insert(newWorkout)
                }
            }
            Text(getCommaSeparatedValues())
                .font(.caption)
        }
    }
    
    private func getCommaSeparatedValues() -> String {
        let names = workout.entries.map { $0.exercise.name }
        return names.joined(separator: ", ")
    }
}
