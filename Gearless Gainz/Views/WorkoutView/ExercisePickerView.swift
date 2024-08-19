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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var workout: Workout
    
    @State private var selectedExercises = [Exercise]()
    @State private var newExercise: Exercise = Exercise(name: "", targetMuscle: .chest)
    @State private var searchString = ""
    @State private var filterMuscle: TargetMuscle? = nil
    
    private var filteredExercises: [Exercise] {
            exercises
            .filter { exercise in
                if selectedExercises.contains(exercise){
                    true
                } else{
                    (filterMuscle == nil || exercise.targetMuscle == filterMuscle)
                    &&
                    (searchString.isEmpty || exercise.name.localizedCaseInsensitiveContains(searchString))
                }
            }
        }
    
    var body: some View {
        NavigationStack{
            VStack{
                // Search bar
                HStack{
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $searchString)
                    if !searchString.isEmpty{
                        Button(action: {
                            searchString = ""
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                        })
                    }
                }
                .font(.headline)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.15)))
                
                // Create new exercise and add to workout buttons
                HStack{
                    NavigationLink(destination: EditExerciseView(exercise: $newExercise, isNewExercise: true)){
                        Label("New", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                            .padding(8)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(action: {
                        let count = workout.exercises.count
                        for (index, exercise) in selectedExercises.enumerated() {
                            let workoutExercise = WorkoutEntry(exercise: exercise, order: count+index, workout: workout)
//                            exercise.history.append(workoutExercise)
                            modelContext.insert(workoutExercise)
                        }
                        dismiss()
                    }, label: {
                        Label("Add \(selectedExercises.count)", systemImage: "checkmark")
                            .frame(maxWidth: .infinity)
                            .padding(8)
                    })
                    .disabled(selectedExercises.isEmpty)
                    .buttonStyle(.borderedProminent)
                }
                .font(.system(size: 18))
                .fontWeight(.bold)
                
                // Lazy scrollview of the exercises
                ScrollView{
                    LazyVStack{
                        ForEach(filteredExercises){exercise in
                            ExerciseListItem(exercise: exercise)
                                .padding()
                                .background(selectedExercises.contains(exercise) ? Color.accentColor.opacity(0.5) : .gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .onTapGesture {
                                    if selectedExercises.contains(exercise){
                                        let index = selectedExercises.firstIndex(of: exercise)
                                        selectedExercises.remove(at: index!)
                                    } else {
                                        selectedExercises.append(exercise)
                                    }
                                }
                        }
                        .listStyle(.plain)
                    }
                }
                // Overlay to show buttons when the exercise list is empty
                .overlay(content: {
                    if exercises.isEmpty{
                        EmptyListView(loadDefaultExercises: loadDefaultExercises)
                    }
                })
            }
            .padding(.horizontal)
            //navigation title
            .navigationTitle("Select exercises")
            .toolbarTitleDisplayMode(.inline)
            // Toolbar with buttons to create exercise and add them to workout
            .toolbar{
                ToolbarItem{
                    Menu(content: {
                        ForEach(TargetMuscle.allCases, id: \.self) { muscle in
                            Button(action: {
                                if filterMuscle == muscle{
                                    filterMuscle = nil
                                } else {
                                    filterMuscle = muscle
                                }
                            }, label: {
                                Text(muscle.displayName)
                                if filterMuscle==muscle{
                                    Image(systemName: "checkmark")
                                }
                            })
                        }
                    }, label: {
                        HStack{
                            Text("\(filterMuscle?.displayName ?? "None")")
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                        }
                    })
                }
            }
            .onChange(of: searchString, {
                newExercise.name = searchString
            })
            .onChange(of: filterMuscle, {
                newExercise.targetMuscle = filterMuscle ?? .chest
            })
        }
    }
    
    func loadDefaultExercises(){
        for exercise in DefaultExercises {
            modelContext.insert(exercise)
        }
    }
}

private struct EmptyListView: View {
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
        }
        .padding(32)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Workout.self, configurations: config)

    let w = Workout(date: .now)

    return ExercisePickerView(workout: w)
        .modelContainer(container)
}
