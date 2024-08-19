//
//  WorkoutExerciseItem.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 19/08/24.
//

import SwiftUI

struct WorkoutExerciseItem: View {
    @Environment(\.modelContext) var modelContext
    @State private var showDeleteAlert: Bool = false
    
    var entry: WorkoutExercise
    @State var showMenuSheet = false
    
    var body: some View {
        GroupBox{
            HStack(spacing: 16){
                ExerciseListItem(exercise: entry.exercise, showInfoButton: false)
                Menu("", systemImage: "ellipsis", content: {
                    Button("Reorder Exercises", systemImage: "arrow.up.arrow.down"){
                        
                    }
                    Button("Replace Exercise", systemImage: "arrow.triangle.2.circlepath"){
                        
                    }
                    Button("Remove Exercise", systemImage: "xmark"){
                        modelContext.delete(entry)
                    }
                })
                .buttonStyle(PlainButtonStyle())
            }
            Grid{
                GridRow{
                    Text("Set")
                    
                    Label("kg", systemImage: "scalemass.fill")
                        .frame(maxWidth: .infinity)
                    
                    Text("Reps")
                        .frame(maxWidth: .infinity)
                }
                .fontWeight(.bold)
                
                ForEach(Array(entry.sets.enumerated()), id: \.offset) { index, workoutSet in
                    SetRow(setNumber: index, workoutSet: workoutSet)
                }
            }
            
            Button(
                action: {
                    entry.sets.append(ExerciseSet(weight: 0, reps: 0))
                }, label: {
                    Label("Add set", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                }
            )
            .buttonStyle(BorderedButtonStyle())
        }
    }
}

private struct SetRow: View {
    var setNumber: Int
    var workoutSet: ExerciseSet
   
    var body: some View {
        GridRow{
            Text("\(setNumber)")
            
            VStack{
                Text("\(workoutSet.weight)")
            }
            
            VStack{
                Text("\(workoutSet.reps)")
            }
        }
        .multilineTextAlignment(.center)
    }
}
