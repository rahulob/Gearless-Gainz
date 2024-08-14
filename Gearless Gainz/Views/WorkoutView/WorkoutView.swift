//
//  WorkoutView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    @Bindable var workout: Workout
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack{
            
            VStack{
                List{
                    ForEach(workout.exercises.sorted(by: { $0.order < $1.order })){entry in
                        Section(entry.exercise.name){
                            Text("\(entry.order+1)")
                        }
                        
                    }
                    .onDelete(perform: { indexSet in
                        let sortedExercises = workout.exercises.sorted(by: { $0.order < $1.order})
                        for index in indexSet{
                            workout.exercises.removeAll { $0.id == sortedExercises[index].id }
                        }
                        ensureExercisesHaveOrder()
                    })
                    .padding()
                }
                
                NavigationLink{
                    ExercisePickerView(workout: workout)
                } label: {
                    Label("Add Exercise", systemImage: "plus")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, maxHeight: 48)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            
            .toolbar{
                ToolbarItem{
                    Menu{
                        Button("Delete workout"){
                            modelContext.delete(workout)
                        }
                        Button("Print workout"){
                            for exercise in workout.exercises {
                                print(exercise.exercise.name)
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .onAppear {
                ensureExercisesHaveOrder()
            }
        }
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

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Workout.self, configurations: config)

    let w = Workout(date: .now)
    @State var path = NavigationPath()
    @Environment(\.modelContext) var context
    
    return WorkoutView(workout: w)
        .modelContainer(container)
}

