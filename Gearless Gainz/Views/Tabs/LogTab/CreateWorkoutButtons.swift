//
//  EmptyWorkoutView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 27/08/24.
//

import SwiftUI

struct CreateWorkoutButtons: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showCopyWorkoutSheet: Bool = false
    @State private var showWorkoutSheet: Bool = false
    
    @State private var newWorkout = Workout(date: .now)
    
    var body: some View {
        GroupBox("Quick Start"){
            VStack{
                Button(
                    action: {
                        newWorkout = Workout(date: .now)
                        showWorkoutSheet.toggle()
                    }) {
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
                .sheet(
                    isPresented: $showCopyWorkoutSheet,
                    content: {
                        CopyWorkoutView()
                    })
                .sheet(
                    isPresented: $showWorkoutSheet,
                    content: {
                        EditWorkoutView(workout: $newWorkout)
                            .interactiveDismissDisabled(true)
                    })
            }
            .fontWeight(.bold)
        }
        .padding()
        .cornerRadius(3)
        .shadow(radius: 10)
    }
}


#Preview {
    CreateWorkoutButtons()
}
