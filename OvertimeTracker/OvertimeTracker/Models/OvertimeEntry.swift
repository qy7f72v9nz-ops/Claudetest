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
    var overtimeBefore: Double  // Hours before contracted hours
    var overtimeAfter: Double   // Hours after contracted hours

    var totalDaily: Double {
        overtimeBefore + overtimeAfter
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

    init(id: UUID = UUID(), date: Date, overtimeBefore: Double = 0, overtimeAfter: Double = 0) {
        self.id = id
        self.date = date
        self.overtimeBefore = overtimeBefore
        self.overtimeAfter = overtimeAfter
    }
}
