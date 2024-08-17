//
//  WorkoutView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var workout: Workout
    @State private var dragItem: String?
    @State private var sortedExercises: [WorkoutExercise] = []
    
    var body: some View {
        NavigationStack{
            VStack{
                // Add exercise Button
                NavigationLink{
                    ExercisePickerView(workout: workout)
                } label: {
                    Label("Add Exercise", systemImage: "plus")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                // Scroll View to view all the exercises in the workout
                List{
                    ForEach(sortedExercises){entry in
                        ExerciseItem(entry: entry, onDelete: {
                            workout.exercises.removeAll(where: {$0.order == entry.order})
                            updateSortedExercises()
                        })
                    }
                    .onMove(perform: { indices, newOffset in
                        var exercises = workout.exercises.sorted(by: { $0.order < $1.order })
                        exercises.move(fromOffsets: indices, toOffset: newOffset)
                        
                        for (index, exercise) in exercises.enumerated() {
                            exercise.order = index
                        }
                        
                        try? modelContext.save()
                    })
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .overlay{
                    if workout.exercises.isEmpty{
                        EmptyExercisesView()
                    }
                }
            }
            .toolbar{
                ToolbarItem{
                    Menu{
                        Button("Delete workout"){
                            modelContext.delete(workout)
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .onAppear(perform: updateSortedExercises)
        }
    }
    
    private func updateSortedExercises() {
        sortedExercises = workout.exercises.sorted(by: { $0.order < $1.order })
        ensureExercisesHaveOrder()
    }
    
    private func ensureExercisesHaveOrder() {
        for (index, exercise) in workout.exercises.sorted(by: {$0.order < $1.order}).enumerated() {
            if exercise.order != index {
                exercise.order = index
            }
        }
        try? modelContext.save()
    }
}

private struct EmptyExercisesView: View {
    var body: some View {
        VStack(spacing: 16){
            Spacer()
            Image(systemName: "text.badge.xmark")
            Text("No Exercises found! Add exercercises in this workout")
                .multilineTextAlignment(.center)
            Spacer()
        }
        .font(.headline)
    }
}

private struct ExerciseItem: View {
    @State private var showInfoSheet: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var infoExercise = Exercise(name: "", targetMuscle: .chest)
    @State private var newExercise = false
    
    var entry: WorkoutExercise
    var onDelete: ()->Void
    
    var body: some View {
        GroupBox(content: {
            Text("\(entry.order+1)")
        }, label: {
            HStack(spacing: 16){
                // Exercise name
                Text(entry.exercise.name)
                    .lineLimit(2)
                Spacer()
                // Delete button
                Button(action: {
                    showDeleteAlert.toggle()
                }, label: {
                    Image(systemName: "trash")
                })
                .alert(isPresented: $showDeleteAlert){
                    Alert(
                        title: Text("Are you sure?"),
                        message: Text("\"\(entry.exercise.name)\" \n will be deleted from the workout"),
                        primaryButton: .destructive(Text("Delete"),action: onDelete),
                        secondaryButton: .cancel()
                    )
                }
                
                // Info button
                Button(action: {
                    infoExercise = entry.exercise
                    showInfoSheet.toggle()
                }, label: {
                    Image(systemName: "info.circle.fill")
                })
            }
        })
        .sheet(isPresented: $showInfoSheet, content: {
            EditExerciseView(exercise: $infoExercise, isNewExercise: $newExercise)
        })
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Workout.self, configurations: config)

    let w = Workout(date: .now)
    
    return WorkoutView(workout: w)
        .modelContainer(container)
}

