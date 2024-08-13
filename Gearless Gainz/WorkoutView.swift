//
//  WorkoutView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    @Bindable var workout: Workout
    @Environment(\.modelContext) var context
//    @Binding var path: NavigationPath
    
    var body: some View {
        NavigationStack(){
            NavigationLink{
                ExercisePickerView(workout: workout)
            } label: {
                Label("Add Exercise", systemImage: "plus")
            }
            .toolbar{
                ToolbarItem{
                    Menu{
                        Button("Delete workout"){
                            context.delete(workout)
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
//            .navigationDestination(for: Workout.self){ workout in
//                ExercisePickerView(workout: workout)
//            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Workout.self, configurations: config)

    let w = Workout(date: .now)
    @State var path = NavigationPath()
    return WorkoutView(workout: w)
        .modelContainer(container)
}

