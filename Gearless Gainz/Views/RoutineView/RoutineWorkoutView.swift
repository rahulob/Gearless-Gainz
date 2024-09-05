//
//                           CreateRoutineWorkoutView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 05/09/24.
//

import SwiftUI

struct RoutineWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    var routine: Routine
    var newRoutineWorkout: RoutineWorkout
    
    @State private var workoutName = ""
    @State private var errorString: String?
    @State var selectedExercises = [Exercise]()
    
    var body: some View {
        NavigationStack {
            List {
                // Routine Workout name
                GroupBox {
                    VStack(alignment: .leading) {
                        TextField("e.g. Push Day", text: $workoutName)
                            .fontWeight(.bold)
                            .onAppear {
                                workoutName = newRoutineWorkout.name
                            }
                        if errorString != nil {
                            Text(errorString!)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                } label: {
                    Text("Workout Name")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }
                .listRowSeparator(.hidden)
                
                // Routine Workout exercises
                Section("Exercises") {
                    ForEach(selectedExercises) {exercise in
                        ExerciseListItem(exercise: exercise, showInfoButton: false)
                    }
                    .listRowSeparator(.hidden)
                }
                
            }
            .listStyle(.plain)
            .safeAreaInset(edge: .bottom, content: {
                // Add exercise Button
                NavigationLink {
                    RoutineExercisePickerView(selections: $selectedExercises)
                } label: {
                    Label("Add Exercise", systemImage: "plus")
                        .fontWeight(.bold)
                        .padding(8)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            })
            .onAppear {
                for entry in newRoutineWorkout.entries {
                    if entry.exercise != nil {
                        selectedExercises.append(entry.exercise!)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create") {
                        // TODO: validate workout name and workout entries
                        if workoutName == "" {
                            errorString = "Workout Name can't be Empty!"
                        } else {
                            newRoutineWorkout.name = workoutName
                            newRoutineWorkout.routine = routine
                            for (index, exercise) in selectedExercises.enumerated() {
                                newRoutineWorkout.entries.append(RoutineWorkoutEntry(exercise: exercise, sets: 1, order: index))
                            }
                            routine.workouts.append(newRoutineWorkout)
                            dismiss()
                        }
                    }
                    .fontWeight(.bold)
                    .buttonStyle(BorderedProminentButtonStyle())
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Discard") {
                        modelContext.delete(newRoutineWorkout)
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
                }
            }
        }
    }
}
