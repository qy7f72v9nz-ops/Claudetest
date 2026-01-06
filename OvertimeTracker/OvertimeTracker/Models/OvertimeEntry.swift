//
//  OvertimeEntry.swift
//  OvertimeTracker
//
//  Model for daily overtime tracking
//

import Foundation

struct OvertimeEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    var minutesBefore: Int  // Minutes before contracted hours
    var minutesAfter: Int   // Minutes after contracted hours

    var totalMinutes: Int {
        minutesBefore + minutesAfter
    }

    var totalFormatted: String {
        formatMinutes(totalMinutes)
    }

    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }

    var shortDayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    init(id: UUID = UUID(), date: Date, minutesBefore: Int = 0, minutesAfter: Int = 0) {
        self.id = id
        self.date = date
        self.minutesBefore = minutesBefore
        self.minutesAfter = minutesAfter
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
}
