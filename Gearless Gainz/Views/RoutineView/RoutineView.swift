//
//  RoutineView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 04/09/24.
//

import SwiftUI

struct RoutineView: View {
    var routine: Routine
    
    var body: some View {
        List {
            Section("Name and Description") {
                Text(routine.name)
                    .fontWeight(.bold)
                    .listRowSeparator(.hidden)
                
                Text(routine.note ?? "No Description Found")
                    .foregroundStyle(Color.secondary)
            }
        }
    }
}
