//
//  ExcercisePickerView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData

struct ExercisePickerView: View {
    @Query private var exercises: [Exercise]
    @State private var selections = Set<Exercise>()
    @State private var path = [Exercise]()
    @Bindable var workout: Workout
    
//    @Binding var path: NavigationPath
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack(path: $path){
            List(exercises){exercise in
                HStack(spacing: 16){
                    CheckBoxImage(checked: selections.contains(exercise))
                        .onTapGesture {
                            if selections.contains(exercise){
                                selections.remove(exercise)
                            } else {
                                selections.insert(exercise)
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
                        path.append(exercise)
                    } label: {
                        Image(systemName: "info.circle.fill")
                    }
                    .buttonStyle(.plain)
                }
                .listRowBackground(selections.contains(exercise) ? Color.accentColor.opacity(0.2) : nil)
            }
            .navigationTitle("Select exercises")
            .navigationDestination(for: Exercise.self){ excercise in
                EditExerciseView(excercise: excercise, path: $path)
            }
            .toolbar{
                ToolbarItem{
                    Button(action: addExercise) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Button("Done"){
                for ex in selections {
                    workout.exercises.append(WorkoutExercise(exercise: ex))
                }
                try! modelContext.save()
            }
        }
    }
    func addExercise() {
        let excercise = Exercise(name: "", targetMuscle: .chest)
        path.append(excercise)
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

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Workout.self, configurations: config)

    let w = Workout(date: .now)
//    @State var path = NavigationPath()
    return ExercisePickerView(workout: w)
        .modelContainer(container)
}
