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
    @Query var workouts: [Workout]
    
    private var filteredWorkouts: [Workout] {
        workouts.filter { Calendar.current.isDate($0.date, equalTo: selectedDate, toGranularity: .day)}
    }
    var body: some View {
        NavigationStack{
            // Date picker
            HStack {
                Button {
                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
                } label: {
                    Image(systemName: "arrowtriangle.backward.fill")
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
                DatePicker(
                    "Day",
                    selection: $selectedDate,
                    in: ...Date.now,
                    displayedComponents: .date
                )
                .labelsHidden()
                
                Spacer()
                Button{
                    if !Calendar.current.isDate(selectedDate, equalTo: .now, toGranularity: .day){
                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
                    }
                } label: {
                    Image(systemName: "arrowtriangle.forward.fill")
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            Group{
                if filteredWorkouts.count == 0 {
                    EmptyWorkoutView(selectedDate: $selectedDate)
                }
                ForEach(filteredWorkouts){workout in
                    WorkoutView(workout: workout)
                }
            }
            .navigationTitle("Log Workout")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LogTab()
        .modelContainer(for: Workout.self, inMemory: true)
}
