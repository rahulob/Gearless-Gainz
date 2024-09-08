//
//  RoutineView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 04/09/24.
//

import SwiftUI
import SwiftData

struct RoutineListItem: View {
    @Environment(\.modelContext) private var modelContext
    var routine: Routine
    @State private var showRoutineWorkoutSheet = false
    @State private var routineWorkout = RoutineWorkout(name: "")
    @State private var showDeleteAlert = false
    @State private var showDeleteRoutineAlert = false
    @State private var showCreateWorkoutSheet = false
    @State private var showEditRoutineSheet = false
    
    @Query(sort: \RoutineWorkout.name) private var routineWorkouts: [RoutineWorkout]
    private var filteredWorkouts: [RoutineWorkout] {
            routineWorkouts.filter { $0.routine == routine }
        }
    
    var body: some View {
        Section {
            ForEach(filteredWorkouts) { workout in
                RoutineWorkoutItem(routineWorkout: workout)
                    .swipeActions(edge: .trailing) {
                        Button("Delete", systemImage: "trash") {
                            showDeleteAlert.toggle()
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Edit", systemImage: "square.and.pencil") {
                            
                        }
                    }
                    .alert("Are you sure", isPresented: $showDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            modelContext.delete(workout)
                        }
                    } message: {
                        Text("Entire workout will be deleted")
                    }
            }
        } header: {
            HStack(spacing: 16) {
                Image(systemName: "folder.fill")
                    .font(.system(size: 24))
                VStack(alignment: .leading) {
                    Text(routine.name)
                        .fontWeight(.bold)
                    Text(routine.note ?? "No Description Found")
                        .lineLimit(3)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Menu("", systemImage: "ellipsis") {
                    Button("Edit", systemImage: "square.and.pencil") { showEditRoutineSheet.toggle() }
                    Button("Delete", systemImage: "trash", role: .destructive) { showDeleteRoutineAlert.toggle() }
                }
                .alert("Are you sure", isPresented: $showDeleteRoutineAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        for workout in filteredWorkouts {
                            modelContext.delete(workout)
                        }
                        modelContext.delete(routine)
                    }
                } message: {
                    Text("Entire routine will be deleted")
                    Text("Workouts will also be deleted")
                }
            }
            .textCase(nil)
            .foregroundStyle(.primary)
            .sheet(isPresented: $showEditRoutineSheet, content: {
                CreateRoutineView(routine: routine)
            })
        } footer: {
            // Add workout to the routine
            Button("Create New Workout", systemImage: "plus") { showCreateWorkoutSheet.toggle() }
                .frame(maxWidth: .infinity)
                .sheet(isPresented: $showCreateWorkoutSheet, content: {
                    RoutineWorkoutSheet(routine: routine)
                        .interactiveDismissDisabled(true)
                })
        }
    }
}


struct RoutineWorkoutItem: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @AppStorage("copyWorkoutTitle") private var copyWorkoutTitle = true
    
    @State private var showCopiedWorkoutSheet = false
    @State private var showWorkoutSheet = false
    @State private var newWorkout = Workout(date: .now)
    
    var routineWorkout: RoutineWorkout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(routineWorkout.name)
                    .foregroundStyle(.secondary)
                Spacer()
                Button(
                    action: {
                        newWorkout = Workout(date: .now, name: routineWorkout.name)
                        modelContext.insert(newWorkout)
                        for routineEntry in routineWorkout.entries {
                            let workoutEntry = WorkoutEntry(exercise: routineEntry.exercise, order: routineEntry.order)
                            newWorkout.entries.append(workoutEntry)
                            workoutEntry.sets.append(ExerciseSet(weight: 0, reps: 0, order: 0))
                        }
                        showWorkoutSheet.toggle()
                    },
                    label: {
                        Image(systemName: "doc.on.doc.fill")
                    }
                )
                .buttonStyle(PlainButtonStyle())
            }
            Text(getCommaSeparatedValues())
                .font(.caption)
                .padding(.bottom, 8)
        }
        .fontWeight(.bold)
        .sheet(
            isPresented: $showWorkoutSheet,
            onDismiss: { dismiss() },
            content: {
                EditWorkoutView(workout: $newWorkout)
                    .interactiveDismissDisabled(true)
            }
        )
    }
    func getCommaSeparatedValues() -> String {
        let names = routineWorkout.entries.sorted(by: { $0.order < $1.order } ).map { $0.exercise?.name ?? "" }
        return names.joined(separator: ", ")
    }
}
