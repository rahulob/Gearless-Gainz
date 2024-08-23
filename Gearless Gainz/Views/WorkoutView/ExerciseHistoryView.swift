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
                EntryListItem(entry: entry)
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

private struct EntryListItem: View {
    var entry: WorkoutEntry
    
    private var sortedSets: [ExerciseSet] {
        entry.sets.sorted(by: { $0.order < $1.order })
    }
    var body: some View {
        VStack(spacing: 8) {
            Text(entry.workout?.date.formatted(date: .abbreviated, time: .omitted) ?? "Date Not Found")
                .font(.title2)
            HStack {
                Group {
                    Text("Type")
                    Text("KG")
                    Text("Reps")
                }
                .font(.caption)
                .frame(maxWidth: .infinity)
            }
            ForEach(sortedSets){ exerciseSet in
                HStack {
                    HStack{
                        Image(systemName: exerciseSet.setType.displayIcon)
                            .padding(.leading, exerciseSet.setType == .dropSet ? 32 : 0)
                        
                        Text(exerciseSet.setType.displayName)
                            .fontWeight(.semibold)
                            .font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Group {
                        Text(String(format: "%.2f", exerciseSet.weight))
                        Text("\(exerciseSet.reps)")
                    }
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
    }
}
