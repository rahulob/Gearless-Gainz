//
//  WorkoutSheet.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 27/08/24.
//

import SwiftUI

struct ViewWorkoutSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var workout: Workout
    @State private var showEditWorkoutSheet = false
    var body: some View {
        NavigationStack {
            List{
                Section {
                    ForEach(workout.entries.sorted(by: { $0.order < $1.order })) { entry in
                        
                        EntryItem(entry: entry, showExerciseName: true)
                            .listRowSeparator(.hidden)
                            .padding(.bottom)
                    }
                } header: {
                    VStack(alignment: .leading) {
                        Text(workout.name ?? "").font(.title)
                        Text(workout.date.formatted(date: .abbreviated, time: .shortened))
                            .font(workout.name != nil ? .caption : .body)
                    }
                    .fontWeight(.bold)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") { showEditWorkoutSheet.toggle() }
                }
            }
            .sheet(
                isPresented: $showEditWorkoutSheet,
                onDismiss: { dismiss() },
                content: {
                    WorkoutView(workout: workout)
                        .interactiveDismissDisabled(true)
                })
        }
    }
}

#Preview {
    @State var workout = Workout(date: .now)
    return ViewWorkoutSheet(workout: $workout)
}
