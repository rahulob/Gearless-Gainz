//
//  EditExerciseView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var allExercises: [Exercise]
    @Query private var workoutExercises: [WorkoutExercise]
    
    @Binding var exercise: Exercise
    var isNewExercise: Bool
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var deleteAlert = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        // Form to create or edit the exercise
        NavigationStack{
            // Photo of the exercise
            VStack(spacing: 16){
                ExerciseImage(photoData: exercise.photo, imageSize: 150, iconSize: 75)
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    let label = exercise.photo != nil ? "Change Photo" : "Select Photo"
                    Label(label, systemImage: "photo")
                }
            }
            .padding(.top)
            
            List {
                // Name of the exercise
                Section("Name and Description"){
                    VStack(alignment: .leading){
                        TextField("e.g. Bench Press", text: $exercise.name, axis: .vertical)
                            .fontWeight(.bold)
                            .font(.title3)
                        
                        if showError{
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(Color.red)
                        }
                    }

                    TextField("Describe exercise", text: $exercise.note, axis: .vertical)
                }
                
                // Picker for selecting the target muscle
                Section("Target Muscle Group"){
                    Picker("Target Muscle", selection: $exercise.targetMuscle) {
                        ForEach(TargetMuscle.allCases, id: \.self) { muscle in
                            Text(muscle.displayName)
                                .tag(muscle)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // Reference video for the exercise
                Section("Reference Video"){
                    TextField("Youtube Video URL", value: $exercise.youtubeURL, format: .url)
                        .keyboardType(.URL)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                
                // Save exercise button
                Section{
                    if !isNewExercise {
                        Button{
                            deleteAlert.toggle()
                        } label: {
                            Label("Delete Exercise", systemImage: "trash")
                                .foregroundStyle(Color.red)
                        }
                        .frame(maxWidth: .infinity)
                        .alert(isPresented: $deleteAlert){
                            Alert(
                                title: Text("Are you sure?"),
                                message: Text("\"\(exercise.name)\" \n will be deleted from everywhere"),
                                primaryButton: .destructive(Text("Delete"),action: {
                                    modelContext.delete(exercise)
                                    for workoutExercise in workoutExercises {
                                        if workoutExercise.exercise == exercise {
                                            modelContext.delete(workoutExercise)
                                        }
                                    }
                                    dismiss()
                                }),
                                secondaryButton: .cancel()
                            )
                        }
                    }
                }
            }
            .navigationTitle(isNewExercise ? "Create New Exercise" : "Exercise Info")
            .toolbar{
                ToolbarItem{
                    Button(action: {
                        if exercise.name.isEmpty{
                            errorMessage = "Exercise Name can't be empty"
                            showError = true
                        } else if allExercises.contains(where: {$0.name.lowercased() == exercise.name.lowercased() && $0.id != exercise.id}){
                            errorMessage = "Exercise already exist"
                            showError = true
                        } else {
                            dismiss()
                            modelContext.insert(exercise)
                        }
                    }){
                        Text("Save")
                    }
                }
            }
            .onChange(of: selectedPhoto, loadPhoto)
        }
    }
    func loadPhoto() {
        Task { @MainActor in
            exercise.photo = try await selectedPhoto?.loadTransferable(type: Data.self)
        }
    }
}

private struct EditExerciseViewWithPreview: View {
    @State private var sampleExercise2 = Exercise(name: "", targetMuscle: .chest)
    @State private var isNewExercise = true
    
//    @State private var path = NavigationPath()

    var body: some View {
        EditExerciseView(exercise: $sampleExercise2, isNewExercise: isNewExercise)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Exercise.self, configurations: config)
    
    return EditExerciseViewWithPreview()
        .modelContainer(container)
}
