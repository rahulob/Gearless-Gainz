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
    @Binding var exercise: Exercise
    let isNewExercise: Bool
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var deleteAlert = false

    var body: some View {
        // Form to create or edit the exercise
        NavigationStack{
            List {
                // Photo of the exercise
                Section("Add Image"){
                    if let imageData = exercise.photo, let uiImage = UIImage(data: imageData){
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        let label = exercise.photo != nil ? "Change the Photo" : "Select a Photo"
                        Label(label, systemImage: "photo")
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Name of the exercise
                Section("Exercise Name"){
                    TextField("e.g. Bench Press", text: $exercise.name, axis: .vertical)
                        .fontWeight(.bold)
                        .font(.title3)
                }
                
                // Description of the exercise
                Section("Description"){
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
                    if isNewExercise {
                        Button{
                            dismiss()
                            modelContext.insert(exercise)
                        } label: {
                            Text("Save Exercise")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    else {
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
                                    dismiss()
                                    modelContext.delete(exercise)
                                }),
                                secondaryButton: .cancel()
                            )
                        }
                    }
                }
            }
            .navigationTitle(isNewExercise ? "Create New Exercise" : "Exercise Info")
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button(action: {dismiss()}, label: {
                        Image(systemName: "xmark.circle.fill")
                    })
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
