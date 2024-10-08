//
//  SwiftUIView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData

struct LogTab: View {
    var body: some View {
        NavigationStack {
            VStack {
                // Create Workout View
                CreateWorkoutButtons()
                    .navigationTitle("Log Workout")
                    .toolbarTitleDisplayMode(.inline)
                
                // Routines view
                RoutinesGroupBox()
                
                // Show recent Workouts
                RecentWorkoutList()
            }
        }
    }
}

private struct RecentWorkoutList: View {
    @Query(sort: \Workout.date, order: .reverse) private var allWorkouts: [Workout]
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedWorkoutDate: Date = .now
    @State private var showWorkoutSheet: Bool = false
    @State private var showCopiedWorkoutSheet: Bool = false
    @State private var selectedWorkouts: [Workout] = []
    
    @State private var deleteWorkoutAlert = false
    @State private var selectedWorkoutToDelete: Workout?
    @State private var newWorkout = Workout(date: .now)
    private var recentWorkouts: [Workout] {
        Array(allWorkouts.prefix(10))
    }
    var body: some View {
        List{
            Section("Recent workouts") {
                if recentWorkouts.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "text.badge.xmark")
                        Text("No workouts found")
                    }
                    .fontWeight(.bold)
                    .font(.caption)
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                ForEach(recentWorkouts){ workout in
                    Button(
                        action: {
                            selectedWorkouts.append(workout)
                            selectedWorkoutDate = workout.date
                            showWorkoutSheet.toggle()
                        }, label: {
                            CopyWorkoutItem(workout: workout, showCopyButton: false)
                        }
                    )
                    .foregroundStyle(.primary)
                    .swipeActions(edge: .trailing) {
                        Button("Delete", systemImage: "trash") {
                            selectedWorkoutToDelete = workout
                            deleteWorkoutAlert.toggle()
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .leading) {
                        Button("Copy", systemImage: "doc.on.doc.fill") {
                            newWorkout = copyAndGetNewWorkout(workout, modelContext: modelContext)
                            showCopiedWorkoutSheet.toggle()
                        }
                    }
                }
            }
        }
        .sheet(
            isPresented: $showWorkoutSheet,
            onDismiss: { selectedWorkouts = [] },
            content: {
                ViewWorkoutSheet(workouts: $selectedWorkouts, date: $selectedWorkoutDate)
        })
        .sheet(
            isPresented: $showCopiedWorkoutSheet,
            content: {
            EditWorkoutView(workout: $newWorkout)
                    .interactiveDismissDisabled(true)
        })
        .alert("Are you sure", isPresented: $deleteWorkoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                modelContext.delete(selectedWorkoutToDelete!)
            }
        } message: {
            Text("Entire workout will be deleted")
        }
    }
}

func copyAndGetNewWorkout(_ workout: Workout, modelContext: ModelContext) -> Workout {
    @AppStorage("copyWorkoutTitle") var copyWorkoutTitle = true
    
    let newWorkout = Workout(date: .now)
    modelContext.insert(newWorkout)
    for entry in workout.entries {
        let newEntry = WorkoutEntry(order: entry.order, workout: newWorkout)
        for exerciseSet in entry.sets {
            newEntry.sets.append(ExerciseSet(weight: exerciseSet.weight, reps: exerciseSet.reps, order: exerciseSet.order))
        }
        entry.exercise?.entries.append(newEntry)
    }
    if copyWorkoutTitle {
        newWorkout.name = workout.name
    }
    
    return newWorkout
}

#Preview {
    LogTab()
        .modelContainer(for: Workout.self, inMemory: true)
}
