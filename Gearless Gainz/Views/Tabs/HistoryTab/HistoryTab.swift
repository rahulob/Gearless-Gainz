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
    @State private var selectedDate: Date = Date()
    @State private var showWorkoutSheet: Bool = false
    @State private var selectedWorkouts: [Workout] = []
    
    let boxSize: CGFloat = 40
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let calendar = Calendar.current
    
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
                LazyVGrid(columns: columns, spacing: boxSize/3) {
                    // Empty cells before the first day of the month
                    ForEach(0..<monthInfo.offset, id: \.self) { _ in
                        Text("")
                            .frame(width: boxSize, height: boxSize)
                            .background(Color.clear)
                    }
                    ForEach(monthInfo.allDates, id: \.self) { date in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(colorForDate(date))
                            .frame(width: boxSize, height: boxSize)
                            .overlay(
                                Text(date.formatted(.dateTime.day()))
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.secondary)
                            )
                            .onTapGesture {
                                if colorForDate(date) == .accentColor {
                                    for workout in filteredWorkouts {
                                        if calendar.isDate(workout.date, equalTo: date, toGranularity: .day) {
                                            selectedWorkouts.append(workout)
                                        }
                                    }
                                    showWorkoutSheet.toggle()
                                }
                            }
                            .sheet(
                                isPresented: $showWorkoutSheet,
                                onDismiss: { selectedWorkouts = [] },
                                content: {
                                ViewWorkoutSheet(workouts: $selectedWorkouts)
                            })
                            .onAppear { selectedWorkouts = [] }
                    }
                }
                
                Spacer()
                Text("\(filteredWorkouts.count)\nworkouts done this month")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding()
            .navigationTitle("Workout History")
            .navigationBarTitleDisplayMode(.inline)
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

private struct DayLabels: View {
    let height: CGFloat
    var body: some View {
        HStack {
            ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
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
