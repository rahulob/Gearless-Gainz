//
//  SwiftUIView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData

struct LogTab: View {
    @State var selectedDate: Date = Date.now
    
    var body: some View {
        NavigationStack {
            // Create Workout View
            CreateWorkoutView(selectedDate: $selectedDate)
                .navigationTitle("Log Workout")
                .toolbarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LogTab()
        .modelContainer(for: Workout.self, inMemory: true)
}
