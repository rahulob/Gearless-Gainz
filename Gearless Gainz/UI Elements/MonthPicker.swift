//
//  MonthPicker.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 27/08/24.
//

import SwiftUI

struct MonthPicker: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack {
            Button {
                selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate)!
            } label: {
                Image(systemName: "arrowtriangle.backward.fill")
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
            DatePicker(
                "Day",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .labelsHidden()
            
            Spacer()
            Button{
                selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate)!
            } label: {
                Image(systemName: "arrowtriangle.forward.fill")
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
