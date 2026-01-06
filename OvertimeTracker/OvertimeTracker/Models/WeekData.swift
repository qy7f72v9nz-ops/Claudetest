//
//  WeekData.swift
//  OvertimeTracker
//
//  Model for weekly overtime data management
//

import Foundation

struct WeekData: Codable {
    var entries: [OvertimeEntry]
    let weekStartDate: Date

    var weeklyTotalMinutes: Int {
        entries.reduce(0) { $0 + $1.totalMinutes }
    }

    var weeklyTotalFormatted: String {
        formatMinutes(weeklyTotalMinutes)
    }

    var totalMinutesBefore: Int {
        entries.reduce(0) { $0 + $1.minutesBefore }
    }

    var totalMinutesAfter: Int {
        entries.reduce(0) { $0 + $1.minutesAfter }
    }

    var weekRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"

        let calendar = Calendar.current
        let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStartDate)!

        let startMonth = formatter.string(from: weekStartDate)
        let endFormatted = formatter.string(from: weekEnd)

        return "\(startMonth) - \(endFormatted)"
    }

    private func formatMinutes(_ minutes: Int) -> String {
        if minutes == 0 {
            return "0m"
        }
        let hours = minutes / 60
        let mins = minutes % 60

        if hours == 0 {
            return "\(mins)m"
        } else if mins == 0 {
            return "\(hours)h"
        } else {
            return "\(hours)h \(mins)m"
        }
    }

    init(startDate: Date) {
        self.weekStartDate = startDate
        self.entries = []

        // Create entries for all 7 days of the week
        let calendar = Calendar.current
        for dayOffset in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate) {
                entries.append(OvertimeEntry(date: date))
            }
        }
    }

    static func getCurrentWeekStartDate() -> Date {
        let calendar = Calendar.current
        let today = Date()

        // Find the most recent Monday
        var dateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        dateComponents.weekday = 2  // Monday

        return calendar.date(from: dateComponents) ?? today
    }
}
