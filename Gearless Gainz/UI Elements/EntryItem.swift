//
//  EntryItem.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 27/08/24.
//

import SwiftUI

struct EntryItem: View {
    @AppStorage("isWeightInKG") private var isWeightInKG = true
    var entry: WorkoutEntry
    var showExerciseName = false
    
    private var sortedSets: [ExerciseSet] {
        entry.sets.sorted(by: { $0.order < $1.order })
    }
    var body: some View {
        VStack(spacing: 8) {
            // Name of the exercise or the workout date
            if showExerciseName {
                ExerciseListItem(exercise: entry.exercise, showInfoButton: false)
            } else {
                Text(entry.workout?.date.formatted(date: .abbreviated, time: .omitted) ?? "Date Not Found")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Group {
                    Text("Type")
                    HStack{
                        Image(systemName: "scalemass")
                        Text(isWeightInKG ? "KG" : "LB")
                    }
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
                        Text(String(format: "%.2f", exerciseSet.weight * (isWeightInKG ? 1 : 2.2)))
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
