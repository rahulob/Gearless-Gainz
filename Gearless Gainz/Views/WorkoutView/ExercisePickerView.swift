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
    @State private var infoExercise: Exercise = Exercise(name: "", targetMuscle: .chest)
    
    @State private var showSheet = false
    @State private var isNewExercise = true
    @State private var searchString = ""
    @State private var filterMuscle: TargetMuscle? = nil
    
    @Bindable var workout: Workout
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    private var filteredExercises: [Exercise] {
            exercises
            .filter { exercise in
                if selections.contains(exercise){
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
                    Button(action: createNewExercise){
                        Label("New", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                            .padding(8)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(action: {
                        let count = workout.exercises.count
                        for (index, exercise) in selections.enumerated() {
                            workout.exercises.append(WorkoutExercise(exercise: exercise, order: count+index))
                        }
                        dismiss()
                    }, label: {
                        Label("Add \(selections.count)", systemImage: "checkmark")
                            .frame(maxWidth: .infinity)
                            .padding(8)
                    })
                    .disabled(selections.isEmpty)
                    .buttonStyle(.borderedProminent)
                }
                .font(.system(size: 18))
                .fontWeight(.bold)
                
                // Lazy scrollview of the exercises
                ScrollView{
                    LazyVStack{
                        ForEach(filteredExercises){exercise in
                            ListItem(
                                isSelected: selections.contains(exercise),
                                exercise: exercise,
                                onInfoClick: {
                                    isNewExercise = false
                                    infoExercise = exercise
                                    showSheet.toggle()
                                }
                            )
                            .onTapGesture {
                                if selections.contains(exercise){
                                    let index = selections.firstIndex(of: exercise)
                                    selections.remove(at: index!)
                                } else {
                                    selections.append(exercise)
                                }
                            }
                        }
                    }
                }
                // Overlay to show buttons when the exercise list is empty
                .overlay(content: {
                    if exercises.isEmpty{
                        EmptyListView(createNewExercise: createNewExercise, loadDefaultExercises: loadDefaultExercises)
                    }
                })
            }
            .padding(.horizontal)
            //navigation title
            .navigationTitle("Select exercises")
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
            // Exercise Info sheet
            .sheet(isPresented: $showSheet, content: {
                EditExerciseView(exercise: $infoExercise, isNewExercise: $isNewExercise)
            })
            // TODO: Remove this in production
            .onAppear(perform: {
                loadDefaultExercises()
            })
        }
    }
    
    func createNewExercise(){
        isNewExercise = true
        infoExercise = Exercise(name: searchString, targetMuscle: filterMuscle ?? .chest)
        showSheet.toggle()
    }
    
    func loadDefaultExercises(){
        for exercise in DefaultExercises {
            modelContext.insert(exercise)
        }
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

private struct ListItem: View {
    var isSelected: Bool
    var exercise: Exercise
    var onInfoClick: ()->Void
    
    var body: some View {
        HStack(spacing: 16){
            if let imageData = exercise.photo, let uiImage = UIImage(data: imageData){
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else{
                Image(systemName: isSelected ? "dumbbell.fill" : "dumbbell")
                    .font(.title)
                    .frame(width: 48, height: 48)
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
            
            Button(action: onInfoClick, label: {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(Color.gray)
            })
        }
        .padding()
        .background(isSelected ? Color.accentColor.opacity(0.5) : .gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
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
