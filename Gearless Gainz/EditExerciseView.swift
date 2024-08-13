//
//  EditExcerciseView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData

struct EditExerciseView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var excercise: Exercise
    @Binding var path: [Exercise]//: NavigationPath

    var body: some View {
        // Form to create a new excercise
        Form {
            // TODO: Add an image for the excercise as well
            
            // Name of the excercise
            Section("Excercise Name"){
                TextField("e.g. Bench Press", text: $excercise.name, axis: .vertical)
                .fontWeight(.bold)
                .font(.title3)
            }
            
            // Description of the excercise
            Section("Description"){
                TextField("Excercise description", text: $excercise.note, axis: .vertical)
            }
            
            // Picker for selecting the target muscle
            Section("Target Muscle Group"){
                Picker("Target Muscle", selection: $excercise.targetMuscle) {
                    ForEach(TargetMuscle.allCases, id: \.self) { muscle in
                        Text(muscle.displayName)
                            .tag(muscle)
                    }
                }
            }
            
            // Reference video for the excercise
            Section("Reference Video"){
                    TextField("Youtube Video URL", value: $excercise.youtubeURL, format: .url)
                        .keyboardType(.URL)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
            }
            
            // Save excercise button
            Section{
                Button{
                    modelContext.insert(excercise)
                    _ = path.popLast()
                } label: {
                    Text("Save Exercise")
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Exercise Info")
    }
}

struct EditExerciseViewWithPreview: View {
    @State private var sampleExercise2 = Exercise(name: "", targetMuscle: .chest)
    @State private var path = [Exercise]()
    
//    @State private var path = NavigationPath()

    var body: some View {
        EditExerciseView(excercise: sampleExercise2, path: $path)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Exercise.self, configurations: config)
    
    return EditExerciseViewWithPreview()
        .modelContainer(container)
}
