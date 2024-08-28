//
//  WorkoutSheet.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 27/08/24.
//

import SwiftUI

struct ViewWorkoutSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var workouts: [Workout]
    
    @State private var selectedWorkout: Workout = Workout(date: .now)
    @State private var showEditWorkoutSheet = false
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(workouts) { workout in
                    ListItem(workout: workout, onSelection: {
                        selectedWorkout = workout
                        showEditWorkoutSheet.toggle()
                    })
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                }
            }
            .sheet(
                isPresented: $showEditWorkoutSheet,
                onDismiss: {
                    dismiss()
                },
                content: {
                    WorkoutView(workout: $selectedWorkout)
                        .interactiveDismissDisabled(true)
                })
        }
    }
}

private struct ListItem: View {
    var workout: Workout
    var onSelection: ()->Void
    
    var body: some View {
        Section {
            ForEach(workout.entries.sorted(by: { $0.order < $1.order })) { entry in
                EntryItem(entry: entry, showExerciseName: true)
                    .listRowSeparator(.hidden)
                    .padding(.bottom)
            }
        } header: {
            HStack{
                VStack(alignment: .leading) {
                    Text(workout.name ?? "").font(.title)
                    Text(workout.date.formatted(date: .abbreviated, time: .shortened))
                        .font(workout.name != nil ? .caption : .title)
                }
                Spacer()
                Button("Edit", systemImage: "square.and.pencil", action: onSelection)
            }
            .fontWeight(.bold)
        }
    }
}
