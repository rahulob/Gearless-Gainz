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

struct EmptyWorkoutView: View {
    @Binding var selectedDate: Date
    @Environment(\.modelContext) private var modelContext
    @State private var showCopyWorkoutSheet: Bool = false
    
    var body: some View {
        VStack(spacing:8) {
            GroupBox("Quick Start"){
                VStack{
                    Button(action: createWorkout){
                        Label("Start Empty Workout", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                            .padding(8)
                    }
                    .buttonStyle(.borderedProminent)
                    

                    // copy workout
                    Button {
                        showCopyWorkoutSheet.toggle()
                    } label: {
                        Label("Copy Old Workout", systemImage: "doc.on.doc.fill")
                            .frame(maxWidth: .infinity)
                            .padding(8)
                    }
                    .buttonStyle(.bordered)
                    .sheet(isPresented: $showCopyWorkoutSheet, content: {
                        CopyWorkoutView(selectedDate: $selectedDate)
                    })
                }
                .fontWeight(.bold)
            }
            .padding()
            .cornerRadius(3)
            .shadow(radius: 10)
            
//            GroupBox("Select from Routine"){
//                VStack{
//                    Button(action: createWorkout){
//                        Label("Start a Routine", systemImage: "clock")
//                            .frame(maxWidth: .infinity)
//                    }
//                    .buttonStyle(.borderedProminent)
//                    
//
//                    // copy workout
//                    Button {
//                        
//                    } label: {
//                        Label("Create new routine", systemImage: "plus")
//                            .frame(maxWidth: .infinity)
//                    }
//                    .buttonStyle(.bordered)
//                }
//            }
//            .padding()
//            .cornerRadius(3)
//            .shadow(radius: 10)
            
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
