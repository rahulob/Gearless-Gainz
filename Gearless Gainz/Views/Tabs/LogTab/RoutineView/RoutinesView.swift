//
//  RoutinesView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 06/09/24.
//

import SwiftUI
import SwiftData

struct RoutinesView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Routine.order) private var routines: [Routine]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(routines) {routine in
                    RoutineListItem(routine: routine)
                }
            }
            .overlay {
                if routines.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "text.badge.xmark")
                        Text("No Routines found!")
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .font(.headline)
                }
            }
            .safeAreaInset(edge: .bottom, content: {
                // Create new Routine
                NavigationLink {
                    CreateRoutineView()
                } label: {
                    Label("Create New Routine", systemImage: "plus")
                        .fontWeight(.bold)
                        .padding(8)
                }
                .buttonStyle(BorderedButtonStyle())
                .padding()
            })
            .navigationTitle("Routines")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
