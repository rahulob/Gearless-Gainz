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
    @Binding var date: Date
    
    var body: some View {
        NavigationStack {
            ViewWorkoutList(workouts: $workouts)
                .navigationTitle(getTitleFromDate(date: date))
                .toolbarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Dismiss", systemImage: "xmark.circle.fill") {
                            dismiss()
                        }
                    }
                }
        }
    }
    func getTitleFromDate(date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Today" }
        else if calendar.isDateInYesterday(date) { return "Yesterday" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
}

private struct ViewWorkoutList: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Binding var workouts: [Workout]
    
    
    @State private var selectedWorkout: Workout = Workout(date: .now)
    @State private var showEditWorkoutSheet = false
    var body: some View {
        List{
            ForEach(workouts.sorted(by: { $0.date < $1.date })) { workout in
                ViewWorkoutItem(
                    workout: workout,
                    onEditWorkout: {
                        selectedWorkout = workout
                        showEditWorkoutSheet.toggle()
                    },
                    onCopyWorkout: {
                        selectedWorkout = Workout(date: .now)
                        for entry in workout.entries {
                            let newEntry = WorkoutEntry(exercise: entry.exercise, order: entry.order)
                            for exerciseSet in entry.sets {
                                newEntry.sets.append(ExerciseSet(weight: exerciseSet.weight, reps: exerciseSet.reps, order: exerciseSet.order))
                            }
                            selectedWorkout.entries.append(newEntry)
                        }
                        modelContext.insert(selectedWorkout)
                        showEditWorkoutSheet.toggle()
                    },
                    onDeleteWorkout: {
                        modelContext.delete(workout)
                        dismiss()
                    }
                )
            }
        }
        .sheet(
            isPresented: $showEditWorkoutSheet,
            onDismiss: {
                dismiss()
            },
            content: {
                EditWorkoutView(workout: $selectedWorkout)
                    .interactiveDismissDisabled(true)
            })
    }
}
private struct ViewWorkoutItem: View {
    var workout: Workout
    var onEditWorkout: ()->Void
    var onCopyWorkout: ()->Void
    var onDeleteWorkout: ()->Void
    
    @State private var showDeleteAlert = false
    var body: some View {
        Section {
            ForEach(workout.entries.sorted(by: { $0.order < $1.order })) { entry in
                EntryItem(entry: entry, showExerciseName: true)
                    .listRowSeparator(.hidden)
                    .padding(.bottom)
            }
        } header: {
            VStack {
                Text(workout.name ?? "")
                    .font(.body)
                    .multilineTextAlignment(.center)
                HStack{
                    Text(workout.date.formatted(date: .omitted, time: .shortened))
                        .font(.body)
                    Spacer()
                    Menu("", systemImage: "ellipsis") {
                        Button("Edit", systemImage: "square.and.pencil", action: onEditWorkout )
                        Button("Copy", systemImage: "doc.on.doc", action: onCopyWorkout )
                        Button("Delete", systemImage: "trash", role: .destructive, action: { showDeleteAlert.toggle() })
                    }
                    .font(.system(size: 18))
                }
            }
            .fontWeight(.bold)
            .padding(.bottom, 8)
        }
        .alert("Entire workout will be deleted", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive, action: onDeleteWorkout)
        }
    }
}
