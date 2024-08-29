//
//  CopyWorkoutView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 25/08/24.
//

import SwiftUI
import SwiftData

struct CopyWorkoutView: View {
    @Query(sort: \Workout.date, order: .reverse) private var allWorkouts: [Workout]
    @Environment(\.dismiss) private var dismiss
    
    @State private var monthPickerDate: Date = .now
    private var filteredWorkouts: [Workout] {
        allWorkouts.filter {
            let components1 = Calendar.current.dateComponents([.year, .month], from: $0.date)
            let components2 = Calendar.current.dateComponents([.year, .month], from: monthPickerDate)
            
            // Compare the year and month components
            return components1.year == components2.year && components1.month == components2.month
        }
    }
    var body: some View {
        NavigationStack {
            MonthPicker(selectedDate: $monthPickerDate)
                .padding(.horizontal)
            List(filteredWorkouts){ workout in
                CopyWorkoutItem(workout: workout)
            }
            .overlay {
                if allWorkouts.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "text.badge.xmark")
                        Text("No workouts found")
                    }
                    .fontWeight(.bold)
                }
            }
            .navigationTitle("Copy Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Button("Dismiss", systemImage: "xmark.circle.fill"){
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CopyWorkoutItem: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var showCopiedWorkoutSheet = false
    
    var workout: Workout
    var showCopyButton = true
    @State private var newWorkout = Workout(date: .now)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text(workout.name ?? "")
                    Text(getStringFromDate(date: workout.date))
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }
                
                Spacer()
                if showCopyButton {
                    Button(
                        action: {
                            newWorkout = Workout(date: .now)
                            for entry in workout.entries {
                                let newEntry = WorkoutEntry(exercise: entry.exercise, order: entry.order)
                                for exerciseSet in entry.sets {
                                    newEntry.sets.append(ExerciseSet(weight: exerciseSet.weight, reps: exerciseSet.reps, order: exerciseSet.order))
                                }
                                newWorkout.entries.append(newEntry)
                            }
                            modelContext.insert(newWorkout)
                            showCopiedWorkoutSheet.toggle()
                        },
                        label: {
                            Image(systemName: "doc.on.doc.fill")
                        }
                    )
                    .buttonStyle(PlainButtonStyle())
                }
            }
            Text(getCommaSeparatedValues())
                .font(.caption)
        }
        .fontWeight(.bold)
        .sheet(
            isPresented: $showCopiedWorkoutSheet,
            onDismiss: { dismiss() },
            content: {
            WorkoutView(workout: $newWorkout)
                    .interactiveDismissDisabled(true)
        })
    }
    
    private func getCommaSeparatedValues() -> String {
        let names = workout.entries.sorted(by: { $0.order < $1.order } ).map { $0.exercise.name }
        return names.joined(separator: ", ")
    }
    
    func getStringFromDate(date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Today at \(date.formatted(date: .omitted, time: .shortened))" }
        else if calendar.isDateInYesterday(date) { return "Yesterday at \(date.formatted(date: .omitted, time: .shortened))" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
}
