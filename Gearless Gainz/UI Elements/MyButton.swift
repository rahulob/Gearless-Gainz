//
//  MyButton.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 19/08/24.
//

import SwiftUI

struct MyButton: View {
    
    var title: String
    var iconName: String
    var action = {}
    var body: some View {
        Button(action: action, label: {
            Label(title, systemImage: iconName)
                .frame(maxWidth: .infinity)
                .padding(8)
        })
        .buttonStyle(BorderedProminentButtonStyle())
    }
}
