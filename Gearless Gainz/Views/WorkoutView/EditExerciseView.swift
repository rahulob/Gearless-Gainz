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
    
    @Binding var exercise: Exercise
    @Binding var isNewExercise: Bool
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var deleteAlert = false
    @State private var showError = false
    @State private var errorMessage = ""

    let imageSize: CGFloat = 150
    var body: some View {
        // Form to create or edit the exercise
        NavigationStack{
            // Photo of the exercise
            VStack(spacing: 16){
                if let imageData = exercise.photo, let uiImage = UIImage(data: imageData){
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                else{
                    Image(systemName: "dumbbell")
                        .font(.system(size: 58))
                        .rotationEffect(.degrees(45))
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .background(Color.accentColor.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
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
                    if isNewExercise {
                        Button{
                            if exercise.name.isEmpty{
                                errorMessage = "Exercise Name can't be empty"
                                showError = true
                            } else if allExercises.contains(where: {$0.name.lowercased() == exercise.name.lowercased()}){
                                errorMessage = "Exercise already exist"
                                showError = true
                            } else {
                                dismiss()
                                modelContext.insert(exercise)
                            }
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
        EditExerciseView(exercise: $sampleExercise2, isNewExercise: $isNewExercise)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Exercise.self, configurations: config)
    
    return EditExerciseViewWithPreview()
        .modelContainer(container)
}
