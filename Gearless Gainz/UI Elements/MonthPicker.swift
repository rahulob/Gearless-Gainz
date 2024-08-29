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
                Image(systemName: "arrow.left")
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
            Text(getMonthYearString(selectedDate))
            
            Spacer()
            Button{
                selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate)!
            } label: {
                Image(systemName: "arrow.right")
            }
            .buttonStyle(PlainButtonStyle())
        }
        .fontWeight(.bold)
        .font(.title3)
        .onAppear {
            selectedDate = .now
        }
    }
}


func getMonthYearString(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM yyyy" // Format for month and year
    return dateFormatter.string(from: date)
}

#Preview {
    @State var date = Date.now
    return MonthPicker(selectedDate: $date)
}
