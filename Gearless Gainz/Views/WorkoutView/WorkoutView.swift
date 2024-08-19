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
    
    // Fetch exercises for current workout
    @Query(sort: \WorkoutExercise.order)
    private var sortedExercises: [WorkoutExercise]
    private var filteredExercises: [WorkoutExercise] {
            sortedExercises.filter { $0.workout == workout }
        }
    // show alert toggle for deleting the workout
    @State private var deleteAlert = false
    
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
                .padding(.horizontal)
                
                // List of all the exercises in the workout
                List{
                    ForEach(filteredExercises){entry in
                        WorkoutExerciseItem(entry: entry)
                    }
                    .onMove(perform: { indices, newOffset in
                        var exercises = workout.exercises.sorted(by: { $0.order < $1.order })
                        exercises.move(fromOffsets: indices, toOffset: newOffset)
                        
                        for (index, exercise) in exercises.enumerated() {
                            exercise.order = index
                        }
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
                            deleteAlert.toggle()
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .onAppear(perform: ensureExercisesHaveOrder)
            .alert(isPresented: $deleteAlert){
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("Entire workout will be deleted"),
                    primaryButton: .destructive(Text("Delete"), action: {
                        modelContext.delete(workout)
                    }),
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private func ensureExercisesHaveOrder() {
        for (index, exercise) in filteredExercises.enumerated() {
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

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Workout.self, configurations: config)

    let w = Workout(date: .now)
    
    return WorkoutView(workout: w)
        .modelContainer(container)
}

