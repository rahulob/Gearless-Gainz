//
//  CalendarTab.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 13/08/24.
//

import SwiftUI
import SwiftData

struct CalendarTab: View {
    @Query private var workouts: [Workout]
    @Query private var workoutExercises: [WorkoutExercise]
    @State private var selectedDate: Date = Date()
    
    let boxSize: CGFloat = 40
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let calendar = Calendar.current
    
    private var monthInfo: (totalDays: Int, offset: Int, allDates: [Date]) {
        let year = calendar.component(.year, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        let components = DateComponents(year: year, month: month)
        let firstDayOfMonth = calendar.date(from: components)!
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        let numDays = range.count
        
        let offset = (weekday + 7 - calendar.firstWeekday) % 7
        
        let monthDates = (0..<numDays).compactMap { calendar.date(byAdding: .day, value: $0, to: firstDayOfMonth) }
        return (numDays, offset, monthDates)
    }
    
    var body: some View {
        VStack(spacing: boxSize/2) {
            // Month picker
            HStack {
                Button {
                    selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate)!
                } label: {
                    Image(systemName: "arrowtriangle.backward.fill")
                }
                Spacer()
                DatePicker(
                    "Day",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .labelsHidden()
                
                Spacer()
                Button{
                    selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate)!
                } label: {
                    Image(systemName: "arrowtriangle.forward.fill")
                }
            }
            
            // Day labels
            DayLabels(height: boxSize/1.5)
            
            // Grid of days
            LazyVGrid(columns: columns, spacing: boxSize/3) {
                // Empty cells before the first day of the month
                ForEach(0..<monthInfo.offset, id: \.self) { _ in
                    Text("")
                        .frame(width: boxSize, height: boxSize)
                        .background(Color.clear)
                }
                ForEach(monthInfo.allDates, id: \.self) { date in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            calendar.isDate(selectedDate, equalTo: date, toGranularity: .day) ? .accentColor.opacity(0.7) : colorForDate(date)
                        )
                        .frame(width: boxSize, height: boxSize)
                        .overlay(
                            Text(date.formatted(.dateTime.day()))
                        )
                        .onTapGesture {
                            selectedDate = date
                        }
                }
            }
            
            Spacer()
            ForEach(workoutExercises){ entry in
                Text(entry.exercise!.name)
            }
        }
        .padding()
    }
    
    private func colorForDate(_ date: Date) -> Color {
        if calendar.isDate(date, equalTo: .now, toGranularity: .day) {
            return .accentColor.opacity(0.4)
        }
        return .gray.opacity(0.2)
    }
}

private struct DayLabels: View {
    let height: CGFloat
    var body: some View {
        HStack {
            ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                RoundedRectangle(cornerRadius: 4)
                    .fill(.gray.opacity(0.2))
                    .frame(height: height)
                    .overlay(
                        Text(day)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .font(.caption)
                    )
            }
        }
    }
}

#Preview {
    CalendarTab()
}
