//
//  WorkoutSheet.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 27/08/24.
//

import SwiftUI

struct WorkoutSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var workout: Workout
    var body: some View {
        NavigationStack {
            List(workout.entries.sorted(by: { $0.order < $1.order })) { entry in
                EntryItem(entry: entry, showExerciseName: true)
                    .listRowSeparator(.hidden)
                    .padding(.bottom)
            }
            .navigationTitle(workout.date.formatted(date: .abbreviated, time: .omitted))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @State var workout = Workout(date: .now)
    return WorkoutSheet(workout: $workout)
}
