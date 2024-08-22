//
//  ExerciseHistoryView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 21/08/24.
//

import SwiftUI

struct ExerciseHistoryView: View {
    var body: some View {
        NavigationStack{
            HStack{
                Text("Hello")
                Menu(content: {
                    Text("Change to")
                }, label: {
                    
                    Image(systemName: "flame.fill")
                        .frame(width: 32, height: 32)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.accentColor.opacity(0.6)))
                    
                    Text("Work\nset")
                        .fontWeight(.semibold)
                        .font(.caption2)
                    
                })
            }
        }
    }
}

#Preview {
    ExerciseHistoryView()
}
