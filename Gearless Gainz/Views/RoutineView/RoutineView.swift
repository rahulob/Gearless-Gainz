//
//  RoutineView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 04/09/24.
//

import SwiftUI
import SwiftData

struct RoutineView: View {
    var routine: Routine
    @State private var showRoutineWorkoutSheet = false
    @State private var routineWorkout = RoutineWorkout(name: "")
    
    @Query(sort: \RoutineWorkout.name) private var routineWorkouts: [RoutineWorkout]
    private var filteredWorkouts: [RoutineWorkout] {
            routineWorkouts.filter { $0.routine == routine }
        }
    
    var body: some View {
        NavigationStack {
            List {
                // Routine name and description
                Section("Name and Description") {
                    Text(routine.name)
                        .fontWeight(.bold)
                        .listRowSeparator(.hidden)
                    
                    Text(routine.note ?? "No Description Found")
                        .foregroundStyle(Color.secondary)
                }
                
                // List of workouts in the Routine
                Section("Workouts") {
                    ForEach(filteredWorkouts) { workout in
                        RoutineWorkoutItem(routineWorkout: workout)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        routineWorkout = RoutineWorkout(name: "")
                        showRoutineWorkoutSheet.toggle()
                    } label: {
                        Label("Create New Routine Workout", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showRoutineWorkoutSheet, content: {
                RoutineWorkoutView(routine: routine, newRoutineWorkout: routineWorkout)
                    .interactiveDismissDisabled(true)
            })
        }
    }
}


private struct RoutineWorkoutItem: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @AppStorage("copyWorkoutTitle") private var copyWorkoutTitle = true
    
    @State private var showCopiedWorkoutSheet = false
    @State private var newWorkout = Workout(date: .now)
    
    var routineWorkout: RoutineWorkout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(routineWorkout.name)
                    .foregroundStyle(.secondary)
                Spacer()
                Button(
                    action: {
                        
                    },
                    label: {
                        Image(systemName: "doc.on.doc.fill")
                    }
                )
                .buttonStyle(PlainButtonStyle())
            }
            Text(getCommaSeparatedValues())
                .font(.caption)
        }
        .fontWeight(.bold)
        .sheet(
            isPresented: $showCopiedWorkoutSheet,
            onDismiss: { dismiss() },
            content: {
                EditWorkoutView(workout: $newWorkout)
                    .interactiveDismissDisabled(true)
            })
    }
    func getCommaSeparatedValues() -> String {
        let names = routineWorkout.entries.sorted(by: { $0.order < $1.order } ).map { $0.exercise?.name ?? "" }
        return names.joined(separator: ", ")
    }
}
