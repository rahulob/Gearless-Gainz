//
//  ContentView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI

struct Tabs: View {
    var body: some View {
        TabView {
            // Tab for logging the workout
            LogTab()
                .tabItem { Label("LOG", systemImage: "dumbbell") }
            
            // Tab for viewing the workout history
            CalendarTab()
                .tabItem { Label("HISTORY", systemImage: "calendar") }
        }
    }
}

#Preview {
    Tabs()
        .modelContainer(for: Workout.self, inMemory: true)
}
