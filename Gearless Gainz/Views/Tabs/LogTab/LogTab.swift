//
//  SwiftUIView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData

struct LogTab: View {
    @Query(sort: \Workout.date, order: .reverse) private var allWorkouts: [Workout]
    @State private var selectedWorkouts: [Workout] = []
    @State private var selectedWorkoutDate: Date = .now
    @State private var showWorkoutSheet: Bool = false
    private var recentWorkouts: [Workout] {
        Array(allWorkouts.prefix(5))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Create Workout View
                CreateWorkoutView()
                    .navigationTitle("Log Workout")
                    .toolbarTitleDisplayMode(.inline)
                
                // Show recent Workouts
                List{
                    Section("Recent workouts") {
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
                        }
                    }
                }
                .overlay {
                    if recentWorkouts.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "text.badge.xmark")
                            Text("No workouts found")
                        }
                        .fontWeight(.bold)
                    }
                }
                .sheet(
                    isPresented: $showWorkoutSheet,
                    onDismiss: { selectedWorkouts = [] },
                    content: {
                        ViewWorkoutSheet(workouts: $selectedWorkouts, date: $selectedWorkoutDate)
                })
            }
        }
    }
}

#Preview {
    LogTab()
        .modelContainer(for: Workout.self, inMemory: true)
}
