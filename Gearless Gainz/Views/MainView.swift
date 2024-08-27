//
//  ContentView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            // Tab for logging the workout
            LogTab()
                .tabItem { Label("LOG", systemImage: "dumbbell") }
            
            // Tab for viewing the workout history
            HistoryTab()
                .tabItem { Label("HISTORY", systemImage: "calendar") }
            
            // Tab for viewing the workout history
            SettingsTab()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: [Workout.self], inMemory: true)
}
