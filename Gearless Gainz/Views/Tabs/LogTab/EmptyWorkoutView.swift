//
//  EmptyWorkoutView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 27/08/24.
//

import SwiftUI

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
    @State var date = Date()
    return EmptyWorkoutView(selectedDate: $date)
}
