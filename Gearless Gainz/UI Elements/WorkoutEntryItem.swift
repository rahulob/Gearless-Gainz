//
//  WorkoutExerciseItem.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 19/08/24.
//

import SwiftUI
import SwiftData

struct WorkoutEntryItem: View {
    @Environment(\.modelContext) private var modelContext
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
                            withAnimation{
                                modelContext.delete(exerciseSet)
                                for (index, sortedSet) in sortedSets.enumerated() {
                                    if sortedSet.order != index {
                                        sortedSet.order = index
                                    }
                                }
                            }
                        }
                    )
                }
            }
            
            // Add new set to the workout entry
            Button(
                action: {
                    withAnimation{
                        var weight: Double = 0
                        var reps: Int = 0
                        if entry.sets.count == 0 {
                            // TODO: Take the value from the previous first set of same exercise
                        } else {
                            let index = entry.sets.firstIndex(where: { $0.order == entry.sets.count-1 })
                            if index != nil {
                                weight = entry.sets[index!].weight
                                reps = entry.sets[index!].reps
                            }
                        }
                        entry.sets.append(ExerciseSet(weight: weight, reps: reps, workoutEntry: entry, order: entry.sets.count))
                    }
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
    @Environment(\.modelContext) private var modelContext
    @FocusState private var focusedField: Field?
    private enum Field: Int, CaseIterable {
        case weight, reps
    }
    
    var exerciseSet: ExerciseSet
    var onDelete: ()->Void
    
    @State private var weight: Double? = nil
    @State private var reps: Int? = nil
    @State private var setType: ExerciseSetType = .working
    
    var body: some View {
        HStack{
            Group{
                Menu(content: {
                    Text("Change to")
                    Button("Warm Up Set", systemImage: ExerciseSetType.warmup.displayIcon){ exerciseSet.setType = .warmup }
                    Button("Working Set", systemImage: ExerciseSetType.working.displayIcon){ exerciseSet.setType = .working }
                    Button("Drop Set", systemImage: ExerciseSetType.dropSet.displayIcon){ exerciseSet.setType = .dropSet }
                    
                    Button("Delete Set", systemImage: "trash", role: .destructive){ modelContext.delete(exerciseSet)
                    }
                }, label: {
                    Image(systemName: exerciseSet.setType.displayIcon)
                        .frame(width: 32, height: 32)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.accentColor.opacity(0.8)))
                    
                    Text(exerciseSet.setType.displayName)
                        .fontWeight(.semibold)
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(PlainButtonStyle())
                
                VStack{
                    TextField(String(exerciseSet.weight), value: $weight, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .weight)
                        .toolbar{
                            if focusedField == .weight {
                                ToolbarItem(placement: .keyboard) {
                                    HStack{
                                        Button(action: { weight = (weight ?? 0) * -1 }, label: { Image(systemName: "plusminus") })
                                        Spacer()
                                        Button(action: { weight = (weight ?? 0) - 0.5 }, label: { Image(systemName: "minus") })
                                        Button(action: { weight = (weight ?? 0) + 0.5 }, label: { Image(systemName: "plus") })
                                        Spacer()
                                        Button(action: { focusedField = nil }, label: { Image(systemName: "keyboard.chevron.compact.down") })
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
                                        Spacer()
                                        Button(action: {
                                            if reps != 0 {
                                                reps = (reps ?? 0) - 1
                                            }
                                        }, label: { Image(systemName: "minus") })
                                        Button(action: { reps = (reps ?? 0) + 1 }, label: { Image(systemName: "plus") })
                                        Spacer()
                                        Button(action: { focusedField = nil }, label: { Image(systemName: "keyboard.chevron.compact.down") })
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
