//
//  WorkoutExerciseItem.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 19/08/24.
//

import SwiftUI
import SwiftData

struct WorkoutEntryItem: View {
    @AppStorage("isWeightInKG") private var isWeightInKG = true
    @Environment(\.modelContext) private var modelContext
    @State private var showDeleteAlert: Bool = false
    @State private var showHistorySheet: Bool = false
    
    var entry: WorkoutEntry
    var onReOrderEntries: ()->Void
    
    @Query private var exerciseSets: [ExerciseSet]
    private var sortedSets: [ExerciseSet] {
        exerciseSets
            .filter { $0.workoutEntry == entry }
            .sorted(by: { $0.order < $1.order })
    }
    
    var body: some View {
        Section{
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    ExerciseListItem(exercise: entry.exercise, showInfoButton: false)
                    // History Button
                    HStack(spacing: 32){
                        Button(action: { showHistorySheet.toggle() }){
                            Image(systemName: "calendar.badge.clock")
                                .font(.title2)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .sheet(isPresented: $showHistorySheet, content: {
                            ExerciseHistoryView(exercise: entry.exercise)
                        })
                        // Menu button
                        Menu("", systemImage: "ellipsis") {
                            // Reorder workout entry button
                            Button("Reorder Exercises", systemImage: "arrow.triangle.2.circlepath"){
                                onReOrderEntries()
                            }
                            // Remove Exercise entry from workout
                            Button("Remove Exercise", systemImage: "trash", role: .destructive) {
                                modelContext.delete(entry)
                            }
                        }
                    }
                }
                HStack{
                    Group{
                        Text("Type")
                        HStack {
                            Image(systemName: "scalemass")
                            Text(isWeightInKG ? "KG" : "LB")
                        }
                        Text("Reps")
                    }
                    .frame(maxWidth: .infinity)
                }
                .font(.caption)
                .fontWeight(.bold)
            }
            .foregroundStyle(.primary)
            ForEach(sortedSets) { exerciseSet in
                SetRow(
                    exerciseSet: exerciseSet,
                    onDelete: {
                        withAnimation{
                            modelContext.delete(exerciseSet)
                        }
                    }
                )
                .padding(.top, 4)
            }
            .onDelete(perform: { indexSet in
                withAnimation{
                    for index in indexSet {
                        modelContext.delete(sortedSets[index])
                    }
                }
            })
            .onMove(perform: { indices, newOffset in
                withAnimation{
                    var exerciseSets = sortedSets
                    exerciseSets.move(fromOffsets: indices, toOffset: newOffset)
                    
                    for (index, exerciseSet) in exerciseSets.enumerated() {
                        exerciseSet.order = index
                    }
                }
            })
            .onAppear(perform: {
                for (index, sortedSet) in sortedSets.enumerated() {
                    if sortedSet.order != index {
                        sortedSet.order = index
                    }
                }
            })
            .onChange(of: sortedSets, {
                for (index, sortedSet) in sortedSets.enumerated() {
                    if sortedSet.order != index {
                        sortedSet.order = index
                    }
                }
            })
        } footer: {
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
            .foregroundStyle(Color.primary)
        }
    }
}

private struct SetRow: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("incrementWeight") var incrementWeight = 2.5
    @AppStorage("isWeightInKG") private var isWeightInKG = true
    
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
            Menu(content: {
                Text("Change to")
                Button("Warm Up Set", systemImage: ExerciseSetType.warmup.displayIcon){ exerciseSet.setType = .warmup }
                Button("Working Set", systemImage: ExerciseSetType.working.displayIcon){ exerciseSet.setType = .working }
                Button("Drop Set", systemImage: ExerciseSetType.dropSet.displayIcon){ exerciseSet.setType = .dropSet }
            }, label: {
                
                Image(systemName: exerciseSet.setType.displayIcon)
                    .frame(width: 32, height: 32)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.accentColor.opacity(0.6)))
                    .padding(.leading, exerciseSet.setType == .dropSet ? 32 : 0)
                
                Text(exerciseSet.setType.displayName)
                    .fontWeight(.semibold)
                    .font(.caption2)
                
            })
            .buttonStyle(PlainButtonStyle())
            .frame(maxWidth: .infinity)
            
            TextField("",
                      value: $weight,
                      format: .number,
                      prompt: Text(
                        String(format: "%.2f", exerciseSet.weight * (isWeightInKG ? 1 : 2.2)))
                        .foregroundStyle(Color.primary)
            )
            .keyboardType(.decimalPad)
            .focused($focusedField, equals: .weight)
            .toolbar{
                if focusedField == .weight {
                    ToolbarItem(placement: .keyboard) {
                        HStack{
                            Button(action: { exerciseSet.weight *= -1 }, label: { Image(systemName: "plusminus") })
                            Spacer()
                            Button(action: {
                                if weight == nil {
                                    exerciseSet.weight -= incrementWeight
                                } else {
                                    weight! -= incrementWeight
                                }
                            }, label: { Image(systemName: "minus") })
                            Button(action: {
                                if weight == nil {
                                exerciseSet.weight += incrementWeight
                                } else {
                                    weight! += incrementWeight
                                }
                            }, label: { Image(systemName: "plus") })
                            Spacer()
                            Button(action: { focusedField = nil }, label: { Image(systemName: "keyboard.chevron.compact.down") })
                        }.font(.body)
                    }
                }
            }
            
            TextField("",
                      value: $reps,
                      format: .number,
                      prompt: Text("\(exerciseSet.reps)").foregroundStyle(Color.primary)
            )
            .keyboardType(.numberPad)
            .focused($focusedField, equals: .reps)
            .toolbar{
                if focusedField == .reps {
                    ToolbarItem(placement: .keyboard) {
                        HStack{
                            Spacer()
                            Button(action: {
                                if exerciseSet.reps != 0 {
                                    if reps != nil {
                                        reps! -= 1
                                    } else {
                                        exerciseSet.reps -= 1
                                    }
                                }
                            }, label: { Image(systemName: "minus") })
                            Button(action: {
                                if reps == nil {
                                exerciseSet.reps += 1
                                } else {
                                    reps! += 1
                                }
                            }, label: { Image(systemName: "plus") })
                            Spacer()
                            Button(action: { focusedField = nil }, label: { Image(systemName: "keyboard.chevron.compact.down") })
                        }.font(.body)
                    }
                }
            }
        }
        .font(.title3)
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        .onChange(of: weight, {
            if weight != nil {
                exerciseSet.weight = weight! / (isWeightInKG ? 1 : 2.2)
            }
        })
        .onChange(of: reps, { if reps != nil {exerciseSet.reps = reps!} })
        .onChange(of: focusedField, {
            if focusedField == nil {
                weight = nil
                reps = nil
            }
        })
    }
}

private struct EntryListView: View {
    var body: some View {
        List{
            
        }
    }
}
