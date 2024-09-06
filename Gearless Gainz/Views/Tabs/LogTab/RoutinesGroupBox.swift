//
//  RoutinesView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 03/09/24.
//

import SwiftUI
import SwiftData

struct RoutinesGroupBox: View {
    var body: some View {
        GroupBox("Routines"){
            VStack{
                NavigationLink {
                    RoutinesView()
                } label: {
                    Label("Start From Routine", systemImage: "clock.arrow.2.circlepath")
                        .frame(maxWidth: .infinity)
                        .padding(8)
                }
                .buttonStyle(BorderedButtonStyle())
            }
            .fontWeight(.bold)
        }
        .padding()
        .cornerRadius(3)
        .shadow(radius: 10)
    }
}
