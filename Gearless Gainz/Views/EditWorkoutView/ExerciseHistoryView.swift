//
//  ExerciseHistoryView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 21/08/24.
//

import SwiftUI
import SwiftData

struct ExerciseHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    var exercise: Exercise
    
    // Fetch exercises for all the time it's been done
    @Query(sort: \WorkoutEntry.order)
    private var sortedEntries: [WorkoutEntry]
    private var filteredEntries: [WorkoutEntry] {
            sortedEntries.filter { $0.exercise == exercise }
            .sorted(by: { $0.workout?.date ?? .now > $1.workout?.date ?? .now })
        }
    
    var body: some View {
        NavigationStack {
            List(filteredEntries){entry in
                EntryItem(entry: entry)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle(exercise.name)
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
