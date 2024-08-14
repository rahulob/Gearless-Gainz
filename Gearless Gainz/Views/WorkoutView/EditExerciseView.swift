//
//  EditExerciseView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData

struct EditExerciseView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Binding var exercise: Exercise
    @Binding var isNewExercise: Bool

    var body: some View {
        // Form to create or edit the exercise
        NavigationStack{
            List {
                // TODO: Add an image for the exercise as well
                
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
                if isNewExercise {
                    Section{
                        Button{
                            dismiss()
                            modelContext.insert(exercise)
                        } label: {
                            Text("Save Exercise")
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
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
        }
    }
}

struct EditExerciseViewWithPreview: View {
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
