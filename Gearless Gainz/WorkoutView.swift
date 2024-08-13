//
//  WorkoutView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI

struct WorkoutView: View {
    @Bindable var workout: Workout
    @Environment(\.modelContext) var context
    var body: some View {
        NavigationStack{
            Text("Workout view")
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
        }
    }
}

#Preview {
    WorkoutView(workout: Workout(date: .now))
}
