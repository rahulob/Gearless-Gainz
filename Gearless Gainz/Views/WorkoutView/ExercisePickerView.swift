//
//  ExercisePickerView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData

struct ExercisePickerView: View {
    @Query(sort: \Exercise.name) private var exercises: [Exercise]
    @State private var selections = [Exercise]()
    
    @State private var showSheet = false
    @State private var isNewExercise = false
    @State private var ex: Exercise = Exercise(name: "", targetMuscle: .chest)
    
    @Bindable var workout: Workout
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            List(exercises){exercise in
                HStack(spacing: 16){
                    CheckBoxImage(checked: selections.contains(exercise))
                        .onTapGesture {
                            if selections.contains(exercise){
                                let index = selections.firstIndex(of: exercise)
                                selections.remove(at: index!)
                            } else {
                                selections.append(exercise)
                            }
                        }
                    
                    VStack(alignment: .leading){
                        Text(exercise.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(2)
                        
                        Text(exercise.targetMuscle.displayName)
                            .font(.caption)
                    }
                    Spacer()
                    
                    Button{
                        isNewExercise = false
                        ex = exercise
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .opacity(0.5)
                    }
                    .buttonStyle(.plain)
                }
                .listRowBackground(selections.contains(exercise) ? Color.accentColor.opacity(0.2) : nil)
            }
            .overlay(content: {
                if exercises.isEmpty{
                    EmptyListView(createNewExercise: createNewExercise, loadDefaultExercises: loadDefaultExercises)
                }
            })
            .navigationTitle("Select exercises")
            .toolbar{
                ToolbarItem{
                    Button(action: createNewExercise) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem{
                    Button("Add"){
                        let count = workout.exercises.count
                        for (index, exercise) in selections.enumerated() {
                            workout.exercises.append(WorkoutExercise(exercise: exercise, order: count+index))
                        }
                        dismiss()
                    }
                    .disabled(selections.isEmpty)
                }
            }
            .sheet(isPresented: $showSheet, content: {
                EditExerciseView(exercise: $ex, isNewExercise: isNewExercise)
            })
            .onAppear(perform: {
                loadDefaultExercises()
            })
        }
    }
    
    func createNewExercise(){
        isNewExercise = true
        ex = Exercise(name: "", targetMuscle: .chest)
        showSheet.toggle()
    }
    func loadDefaultExercises(){
        for exercise in DefaultExercises {
            modelContext.insert(exercise)
        }
    }
}

private struct CheckBoxImage: View {
    var checked: Bool
    var body: some View {
        Image(systemName: checked ? "checkmark.square.fill" : "square")
            .font(.title)
            .foregroundStyle(checked ? Color.accentColor : .primary)
    }
}

private struct EmptyListView: View {
    var createNewExercise: ()->Void
    var loadDefaultExercises: ()->Void
    
    var body: some View {
        VStack(spacing: 16){
            Text("It seems no exercises are present in the database")
                .multilineTextAlignment(.center)
                .font(.caption)
            //Load default Exercises
            Button(action: loadDefaultExercises){
                Label("Load Default Exercises", systemImage: "arrow.2.circlepath")
                    .frame(maxWidth: .infinity)
            }.buttonStyle(.borderedProminent)
            // New Exercise Button
            Button(action: createNewExercise){
                Label("Create New Exercise", systemImage: "plus")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding(32)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Workout.self, configurations: config)

    let w = Workout(date: .now)
//    @State var path = NavigationPath()
    return ExercisePickerView(workout: w)
        .modelContainer(container)
}
