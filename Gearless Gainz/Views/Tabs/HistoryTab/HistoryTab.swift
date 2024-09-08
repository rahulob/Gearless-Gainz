//
//  CalendarTab.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData

struct HistoryTab: View {
    @Query private var workouts: [Workout]
    @State private var selectedDate: Date = Date.now
    
    let boxSize: CGFloat = 40
    let calendar = Calendar.current
    
    private var filteredWorkouts: [Workout] {
        return workouts.filter {
            let components1 = calendar.dateComponents([.year, .month], from: $0.date)
            let components2 = calendar.dateComponents([.year, .month], from: selectedDate)
            
            // Compare the year and month components
            return components1.year == components2.year && components1.month == components2.month
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack(spacing: boxSize/2) {
                // Month picker
                MonthPicker(selectedDate: $selectedDate)
                
                // Day labels
                DayLabels(height: boxSize/1.5)
                
                // Grid of days
                CalendarGridView(selectedDate: $selectedDate, filteredWorkouts: filteredWorkouts, boxSize: boxSize)
                
                Spacer()
                // text: Workouts done in the month
                Text("\(filteredWorkouts.count)\nWorkouts done in \(getMonthYearString(selectedDate))")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                // button: to go to current month
                Button(
                    action: { selectedDate = .now },
                    label: {
                        Label("Go to current month", systemImage: "calendar")
                            .fontWeight(.bold)
                            .padding(8)
                    }
                )
                .buttonStyle(BorderedProminentButtonStyle())
                .disabled(calendar.isDate(selectedDate, equalTo: .now, toGranularity: .month))
                Spacer()
            }
            .padding()
            .navigationTitle("Workout History")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct DayLabels: View {
    let height: CGFloat
    var body: some View {
        HStack {
            ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                RoundedRectangle(cornerRadius: 4)
                    .fill(.gray.opacity(0.15))
                    .frame(height: height)
                    .overlay(
                        Text(day)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                    )
            }
        }
    }
}

#Preview {
    HistoryTab()
        .modelContainer(for: Workout.self, inMemory: true)
}
