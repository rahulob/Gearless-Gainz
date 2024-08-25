//
//  CopyWorkoutView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 25/08/24.
//

import SwiftUI
import SwiftData

struct CopyWorkoutView: View {
    @Query(sort: \Workout.date) private var allWorkouts: [Workout]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(allWorkouts){ workout in
                Text(workout.date.formatted(date: .abbreviated, time: .omitted))
            }
            .navigationTitle("Copy Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button("", systemImage: "xmark.circle.fill"){
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CopyWorkoutView()
}
