//
//  RoutineView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 04/09/24.
//

import SwiftUI

struct RoutineView: View {
    var routine: Routine
    @State private var showRoutineWorkoutSheet = false
    @State private var routineWorkout = RoutineWorkout(name: "")
    
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
                    ForEach(routine.workouts) { workout in
                        Button {
                            routineWorkout = workout
                            showRoutineWorkoutSheet.toggle()
                        } label: {
                            VStack {
                                Text(workout.name)
                                    .fontWeight(.bold)
                            }
                        }
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

