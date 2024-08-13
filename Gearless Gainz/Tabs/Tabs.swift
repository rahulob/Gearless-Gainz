//
//  ContentView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI

struct Tabs: View {
    var body: some View {
        TabView {
            LogTab()
                .tabItem { Label("LOG", systemImage: "dumbbell") }
            CalendarTab()
                .tabItem { Label("HISTORY", systemImage: "calendar") }
        }
    }
}

#Preview {
    Tabs()
}
