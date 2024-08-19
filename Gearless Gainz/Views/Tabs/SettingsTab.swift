//
//  SettingsTab.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 19/08/24.
//

import SwiftUI
import SwiftData

struct SettingsTab: View {
    @Query var workouts: [Workout]
    @State var isWeightInKG = true
    var body: some View {
        NavigationStack{
            List{
                Toggle("Weight Units in Kg", isOn: $isWeightInKG)
            }
            .navigationTitle("App Settings")
        }
    }
}

#Preview {
    SettingsTab()
}
