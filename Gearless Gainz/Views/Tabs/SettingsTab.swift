//
//  SettingsTab.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 19/08/24.
//

import SwiftUI
import SwiftData

struct SettingsTab: View {
    @Query var exerciseSets: [ExerciseSet]
    @Query var workoutEntrys: [WorkoutEntry]
    @State var isWeightInKG = true
    var body: some View {
        NavigationStack{
            List{
                Toggle("Weight Units in Kg", isOn: $isWeightInKG)
                Text("Sets Count: \(exerciseSets.count)")
                Text("Entry Count: \(workoutEntrys.count)")
            }
            .navigationTitle("App Settings")
        }
    }
}

#Preview {
    SettingsTab()
}
