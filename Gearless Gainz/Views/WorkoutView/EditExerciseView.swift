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
    
    // State variables for photo
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    // State variables for textfields
    @State private var exerciseName: String = ""
    @State private var exerciseDescription: String = ""
    @State private var exerciseURL: URL?
    @State private var targetMuscle: TargetMuscle = .chest
    
    // State variables for alert and for validation of creating new exercise
    @State private var deleteAlert = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        // Form to create or edit the exercise
        NavigationStack{
            List {
                Section("Select Photo"){
                    HStack{
                        ExerciseImage(photoData: selectedPhotoData, imageSize: 100, iconSize: 50)
                        Spacer()
                        VStack(spacing: 16){
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                let label = selectedPhoto != nil ? "Change Photo" : "Select Photo"
                                Label(label, systemImage: "photo")
                                    .foregroundStyle(Color.primary)
                            }
                            if selectedPhotoData != nil {
                                Button("Remove Photo", systemImage: "trash"){
                                    selectedPhoto = nil
                                    selectedPhotoData = nil
                                }
                                .foregroundStyle(Color.red)
                            }
                        }
                        .font(.system(size: 16))
                        .padding(.trailing)
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                // Name of the exercise
                Section("Name and Description"){
                    VStack(alignment: .leading){
                        TextField("e.g. Bench Press", text: $exerciseName, axis: .vertical)
                            .fontWeight(.bold)
                            .font(.title3)
                        
                        if showError{
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(Color.red)
                        }
                    }

                    TextField("Describe exercise", text: $exerciseDescription, axis: .vertical)
                }
                
                // Picker for selecting the target muscle
                Section("Target Muscle Group"){
                    Picker("Target Muscle", selection: $targetMuscle) {
                        ForEach(TargetMuscle.allCases, id: \.self) { muscle in
                            Text(muscle.displayName)
                                .tag(muscle)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // Reference video for the exercise
                Section("Reference Video"){
                    TextField("Youtube Video URL", value: $exerciseURL, format: .url)
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
                        if exerciseName.isEmpty{
                            errorMessage = "Exercise Name can't be empty"
                            showError = true
                        } else if allExercises.contains(where: {$0.name.lowercased() == exerciseName.lowercased() && $0.id != exercise.id}){
                            errorMessage = "Exercise already exist"
                            showError = true
                        } else {
                            dismiss()
                            exercise.name = exerciseName
                            exercise.note = exerciseDescription
                            exercise.photo = selectedPhotoData
                            exercise.youtubeURL = exerciseURL
                            exercise.targetMuscle = targetMuscle
                            if isNewExercise{
                                modelContext.insert(exercise)
                            }
                        }
                    }){
                        Text("Save")
                    }
                }
            }
            .onChange(of: selectedPhoto, loadPhoto)
            .onAppear(perform: {
                exerciseName = exercise.name
                exerciseDescription = exercise.note
                selectedPhotoData = exercise.photo
                exerciseURL = exercise.youtubeURL
                targetMuscle = exercise.targetMuscle
            })
        }
    }
    func loadPhoto() {
        Task { @MainActor in
            selectedPhotoData = try await selectedPhoto?.loadTransferable(type: Data.self)
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
