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

struct EmptyWorkoutView: View {
    @Binding var selectedDate: Date
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(spacing:8) {
            // TODO: workout found for today jump back in to that
            GroupBox("Quick Start"){
                VStack{
                    Button(action: createWorkout){
                        Label("Start Empty Workout", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    

                    // copy workout
                    Button {
                        
                    } label: {
                        Label("Copy Old Workout", systemImage: "doc.on.doc.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .cornerRadius(3)
            .shadow(radius: 10)
            
            GroupBox("Select from Routine"){
                VStack{
                    Button(action: createWorkout){
                        Label("Start a Routine", systemImage: "clock")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    

                    // copy workout
                    Button {
                        
                    } label: {
                        Label("Create new routine", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .cornerRadius(3)
            .shadow(radius: 10)
            
            Spacer()
        }
    }
    func createWorkout(){
        let workout = Workout(date: selectedDate)
        modelContext.insert(workout)
    }
}

#Preview {
    LogTab()
        .modelContainer(for: Workout.self, inMemory: true)
}
