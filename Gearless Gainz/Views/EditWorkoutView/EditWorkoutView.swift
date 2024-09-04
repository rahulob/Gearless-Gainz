//
//  WorkoutView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData

struct EditWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Binding var workout: Workout
    
    // Fetch exercises for current workout
    @Query(sort: \WorkoutEntry.order)
    private var sortedEntries: [WorkoutEntry]
    private var filteredExercises: [WorkoutEntry] {
            sortedEntries.filter { $0.workout == workout }
        }
    // show alert toggle for deleting the workout
    @State private var deleteWorkoutAlert = false
    @State private var finishWorkoutAlert = false
    @State private var isReorderState: EditMode = .inactive
    @State private var workoutName = ""
    @State private var workoutDate: Date = .now
    
    var body: some View {
        NavigationStack {
            VStack {
                // Workout Header
                VStack {
                    // Date of the workout
                    DatePicker("Workout date", selection: $workoutDate)
                        .onChange(of: workoutDate, {
                            workout.date = workoutDate
                        })
                        .onAppear {
                            workoutDate = workout.date
                        }
                }
                .padding(.horizontal)
                
                // List of all the exercises in the workout
                List {
                    // Name of the workout
                    GroupBox {
                        TextField("e.g. Leg Day", text: $workoutName)
                            .fontWeight(.bold)
                            .onChange(of: workoutName, {
                                if workoutName == "" {
                                    workout.name = nil
                                } else {
                                    workout.name = workoutName
                                }
                            })
                            .onAppear {
                                workoutName = workout.name ?? ""
                            }
                    } label: {
                        Text("Workout Name")
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                    }
                    .listRowSeparator(.hidden)
                    
                    // In Reorder state
                    if isReorderState == .active {
                        Section("Press done after reordering") {
                            ForEach(filteredExercises){entry in
                                ExerciseListItem(exercise: entry.exercise, showInfoButton: false)
                            }
                            .onDelete(perform: { indexSet in
                                withAnimation {
                                    for index in indexSet{
                                        modelContext.delete(filteredExercises[index])
                                    }
                                }
                            })
                            .onMove(perform: { indices, newOffset in
                                withAnimation {
                                    var exercises = filteredExercises
                                    exercises.move(fromOffsets: indices, toOffset: newOffset)
                                    
                                    for (index, exercise) in exercises.enumerated() {
                                        exercise.order = index
                                    }
                                }
                            })
                            .listRowSeparator(.hidden)
                        }
                    } 
                    // Normal state for editting exercises
                    else {
                        ForEach(filteredExercises) { entry in
                            WorkoutEntryItem(entry: entry, onReOrderEntries: {
                                isReorderState = .active
                            })
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .safeAreaInset(edge: .bottom, content: {
                    // Add exercise Button
                    NavigationLink {
                        ExercisePickerView(workout: workout)
                    } label: {
                        Label("Add Exercise", systemImage: "plus")
                            .fontWeight(.bold)
                            .padding(8)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                })
                .environment(\.editMode, $isReorderState)
                .listStyle(.plain)
                .overlay {
                    if filteredExercises.isEmpty {
                        EmptyExercisesView()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Discard") { deleteWorkoutAlert.toggle() }
                        .tint(.red)
                        .fontWeight(.bold)
                }
                
                ToolbarItem {
                    if isReorderState == .active {
                        Button("Done") { isReorderState = .inactive }
                    } else {
                        Button("Finish") {
                            if workout.entries.count == 0 {
                                finishWorkoutAlert.toggle()
                            } else {
                                dismiss()
                            }
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                        .fontWeight(.bold)
                    }
                }
            }
            .onAppear(perform: ensureExercisesHaveOrder)
            .onChange(of: filteredExercises, ensureExercisesHaveOrder)
            .alert("Empty workout", isPresented: $finishWorkoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    modelContext.delete(workout)
                    dismiss()
                }
            } message: {
                Text("Workout will be deleted because it is empty")
            }
            .alert("Discard Workout", isPresented: $deleteWorkoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    dismiss()
                    withAnimation {
                        modelContext.delete(workout)
                    }
                }
            } message: {
                Text("Entire Workout will be deleted \n You can't undo this action")
            }
        }
    }
    
    private func ensureExercisesHaveOrder() {
        for (index, exercise) in filteredExercises.enumerated() {
            if exercise.order != index {
                exercise.order = index
            }
        }
    }
}

private struct EmptyExercisesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "text.badge.xmark")
            Text("No Exercises found! \nAdd exercercises to this workout")
                .multilineTextAlignment(.center)
            Spacer()
        }
        .font(.headline)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Workout.self, configurations: config)

    @State var w = Workout(date: .now)
    
    return EditWorkoutView(workout: $w)
        .modelContainer(container)
}

