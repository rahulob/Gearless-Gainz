//
//  CalendarGridView.swift
//  Gearless Gainz
//
//  Created by Rahul Gupta on 29/08/24.
//

import SwiftUI

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    var filteredWorkouts: [Workout]
    var boxSize: CGFloat
    
    @State private var showWorkoutSheet: Bool = false
    @State private var selectedWorkouts: [Workout] = []
    @State private var selectedWorkoutDate: Date = .now
    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    private var monthInfo: (totalDays: Int, offset: Int, allDates: [Date]) {
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        let firstDayOfMonth = calendar.date(from: components)!
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        let numDays = range.count
        
        let offset = (weekday + 7 - calendar.firstWeekday) % 7
        
        let monthDates = (0..<numDays).compactMap { calendar.date(byAdding: .day, value: $0, to: firstDayOfMonth) }
        return (numDays, offset, monthDates)
    }
    
    var body: some View {
        
        // Grid of days
        LazyVGrid(columns: columns, spacing: boxSize/3) {
            // Empty cells before the first day of the month
            ForEach(0..<monthInfo.offset, id: \.self) { _ in
                Text("")
                    .frame(width: boxSize, height: boxSize)
                    .background(Color.clear)
            }
            ForEach(monthInfo.allDates, id: \.self) { date in
                RoundedRectangle(cornerRadius: 8)
                    .fill(colorForDate(date))
                    .frame(width: boxSize, height: boxSize)
                    .overlay(
                        Text(date.formatted(.dateTime.day()))
                            .font(calendar.isDateInToday(date) ? .body : .caption)
                            .fontWeight(.bold)
                            .foregroundStyle(calendar.isDateInToday(date) ? Color.primary : Color.secondary)
                    )
                    .onTapGesture {
                        if colorForDate(date) == .accentColor {
                            for workout in filteredWorkouts {
                                if calendar.isDate(workout.date, equalTo: date, toGranularity: .day) {
                                    selectedWorkouts.append(workout)
                                }
                            }
                            selectedWorkoutDate = date
                            showWorkoutSheet.toggle()
                        }
                    }
                    .sheet(
                        isPresented: $showWorkoutSheet,
                        onDismiss: { selectedWorkouts = [] },
                        content: {
                            ViewWorkoutSheet(workouts: $selectedWorkouts, date: $selectedWorkoutDate)
                    })
                    .onAppear { selectedWorkouts = [] }
            }
        }
    }
    
    private func colorForDate(_ date: Date) -> Color {
        for workout in filteredWorkouts {
            if calendar.isDate(workout.date, equalTo: date, toGranularity: .day) {
                return .accentColor
            }
        }
        return .gray.opacity(0.2)
    }
}
