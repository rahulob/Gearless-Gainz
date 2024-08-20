//
//  WorkoutExerciseItem.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 19/08/24.
//

import SwiftUI
import SwiftData

struct WorkoutEntryItem: View {
    @Environment(\.modelContext) var modelContext
    @State private var showDeleteAlert: Bool = false
    
    var entry: WorkoutEntry
    
    @Query private var exerciseSets: [ExerciseSet]
    private var sortedSets: [ExerciseSet] {
        exerciseSets
            .filter { $0.workoutEntry == entry }
            .sorted(by: { $0.order < $1.order })
    }
    
    var body: some View {
        GroupBox{
            ExerciseListItem(exercise: entry.exercise)
            VStack(spacing: 16){
                HStack{
                    Group{
                        Text("Set")
                        Text("Type")
                        Label("kg", systemImage: "scalemass.fill")
                        Text("Reps")
                    }
                    .frame(maxWidth: .infinity)
                }
                .fontWeight(.bold)
                
                ForEach(sortedSets) { exerciseSet in
                    SetRow(
                        exerciseSet: exerciseSet,
                        onDelete: {
                            modelContext.delete(exerciseSet)
                            for (index, sortedSet) in sortedSets.enumerated() {
                                if sortedSet.order != index {
                                    sortedSet.order = index
                                }
                            }
                        })
                }
            }
            
            Button(
                action: {
                    entry.sets.append(ExerciseSet(weight: 0, reps: 0, workoutEntry: entry, order: entry.sets.count))
                }, label: {
                    Label("Add set", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                }
            )
            .buttonStyle(BorderedProminentButtonStyle())
        }
    }
}

private struct SetRow: View {
    @FocusState private var focusedField: Field?
    private enum Field: Int, CaseIterable {
        case weight, reps
    }
    
    var exerciseSet: ExerciseSet
    var onDelete: ()->Void
    
    @State private var weight: Double? = nil
    @State private var reps: Int? = nil
    
    var body: some View {
        HStack{
            Group{
                Menu("\(exerciseSet.order + 1)"){
                    Button(
                        exerciseSet.isWarmup ? "Mark as Working set" : "Mark as Warm Up",
                        systemImage: exerciseSet.isWarmup ? "figure.strengthtraining.traditional" : "figure.cooldown",
                        action: { exerciseSet.isWarmup.toggle() }
                    )
                    Button("Delete Set", systemImage: "xmark", action: onDelete)
                        .tint(.red)
                }
                .buttonStyle(BorderedButtonStyle())
                
                Text(exerciseSet.isWarmup ? "Warm up" : "Working")
                    .font(.caption)
                    .fontWeight(.regular)
                
                VStack{
                    TextField(String(exerciseSet.weight), value: $weight, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .weight)
                        .toolbar{
                            if focusedField == .weight {
                                ToolbarItem(placement: .keyboard) {
                                    HStack{
                                        Button(action: { focusedField = nil }, label: { Image(systemName: "keyboard.chevron.compact.down") })
                                        Spacer()
                                        Button(action: { weight = (weight ?? 0) * -1 }, label: { Image(systemName: "plusminus") })
                                        Button(action: { weight = (weight ?? 0) + 0.5 }, label: { Image(systemName: "plus") })
                                        Button(action: { weight = (weight ?? 0) - 0.5 }, label: { Image(systemName: "minus") })
                                    }
                                }
                            }
                        }
                }
                
                VStack{
                    TextField("\(exerciseSet.reps)", value: $reps, format: .number)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .reps)
                        .toolbar{
                            if focusedField == .reps {
                                ToolbarItem(placement: .keyboard) {
                                    HStack{
                                        Button(action: { focusedField = nil }, label: { Image(systemName: "keyboard.chevron.compact.down") })
                                        Spacer()
                                        Button(action: { reps = (reps ?? 0) + 1 }, label: { Image(systemName: "plus") })
                                        Button(action: {
                                            if reps != 0{
                                                reps = (reps ?? 0) - 1
                                            }
                                        }, label: { Image(systemName: "minus") })
                                    }
                                }
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .font(.title3)
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        .onChange(of: weight, {exerciseSet.weight = weight ?? 0})
        .onChange(of: reps, {exerciseSet.reps = reps ?? 0})
    }
}
