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

    var weeklyTotal: Double {
        entries.reduce(0) { $0 + $1.totalDaily }
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
