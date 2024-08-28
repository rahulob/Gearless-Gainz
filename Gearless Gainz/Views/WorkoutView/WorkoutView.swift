//
//  WorkoutView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var workout: Workout
    
    // Fetch exercises for current workout
    @Query(sort: \WorkoutEntry.order)
    private var sortedEntries: [WorkoutEntry]
    private var filteredExercises: [WorkoutEntry] {
            sortedEntries.filter { $0.workout == workout }
        }
    // show alert toggle for deleting the workout
    @State private var deleteAlert = false
    @State private var isReorderState: EditMode = .inactive
    @State private var workoutName = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                // Name of the workout
                TextField("Workout Name", text: $workoutName)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .onChange(of: workoutName, {
                        workout.name = workoutName
                    })
                    .onAppear {
                        workoutName = workout.name ?? ""
                    }
                
                // Add exercise Button
                NavigationLink {
                    ExercisePickerView(workout: workout)
                } label: {
                    Label("Add Exercise", systemImage: "plus")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                
                // List of all the exercises in the workout
                List {
                    if isReorderState == .active {
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
                    } else {
                        ForEach(filteredExercises) { entry in
                            WorkoutEntryItem(entry: entry, onReOrderEntries: {
                                isReorderState = .active
                            })
                        }
                        .listRowSeparator(.hidden)
                    }
                }
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
                    Menu {
                        Button("Delete workout", systemImage: "trash", role: .destructive){
                            deleteAlert.toggle()
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
                
                ToolbarItem {
                    if isReorderState == .active {
                        Button("Done") { isReorderState = .inactive }
                    } else {
                        Button("Finish") { dismiss() }
                    }
                }
            }
            .onAppear(perform: ensureExercisesHaveOrder)
            .onChange(of: filteredExercises, ensureExercisesHaveOrder)
            .alert(isPresented: $deleteAlert) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("Entire workout will be deleted"),
                    primaryButton: .destructive(Text("Delete"), action: {
                        modelContext.delete(workout)
                        dismiss()
                    }),
                    secondaryButton: .cancel()
                )
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
            Text("No Exercises found! Add exercercises in this workout")
                .multilineTextAlignment(.center)
            Spacer()
        }
        .font(.headline)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Workout.self, configurations: config)

    let w = Workout(date: .now)
    
    return WorkoutView(workout: w)
        .modelContainer(container)
}

