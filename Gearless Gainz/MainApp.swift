//
//  MainApp.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            Tabs()
        }
        .modelContainer(for: [Workout.self, Exercise.self], inMemory: true)
    }
}
