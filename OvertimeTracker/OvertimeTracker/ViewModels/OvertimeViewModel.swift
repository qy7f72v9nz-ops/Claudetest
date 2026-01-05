//
//  OvertimeViewModel.swift
//  OvertimeTracker
//
//  ViewModel for managing overtime data and persistence
//

import Foundation
import Combine

class OvertimeViewModel: ObservableObject {
    @Published var currentWeek: WeekData

    private let userDefaults = UserDefaults.standard
    private let weekDataKey = "currentWeekData"

    init() {
        // Try to load saved data, otherwise create new week
        if let savedData = userDefaults.data(forKey: weekDataKey),
           let decodedWeek = try? JSONDecoder().decode(WeekData.self, from: savedData) {
            // Check if saved week is still current
            let savedWeekStart = Calendar.current.startOfDay(for: decodedWeek.weekStartDate)
            let currentWeekStart = Calendar.current.startOfDay(for: WeekData.getCurrentWeekStartDate())

            if savedWeekStart == currentWeekStart {
                self.currentWeek = decodedWeek
            } else {
                // New week, create fresh data
                self.currentWeek = WeekData(startDate: WeekData.getCurrentWeekStartDate())
            }
        } else {
            self.currentWeek = WeekData(startDate: WeekData.getCurrentWeekStartDate())
        }
    }

    func updateEntry(at index: Int, overtimeBefore: Double, overtimeAfter: Double) {
        guard index >= 0 && index < currentWeek.entries.count else { return }
        currentWeek.entries[index].overtimeBefore = overtimeBefore
        currentWeek.entries[index].overtimeAfter = overtimeAfter
        saveData()
    }

    func saveData() {
        if let encodedData = try? JSONEncoder().encode(currentWeek) {
            userDefaults.set(encodedData, forKey: weekDataKey)
        }
    }

    func goToPreviousWeek() {
        let calendar = Calendar.current
        if let newStartDate = calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeek.weekStartDate) {
            currentWeek = WeekData(startDate: newStartDate)
            loadWeekData()
        }
    }

    func goToNextWeek() {
        let calendar = Calendar.current
        if let newStartDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeek.weekStartDate) {
            currentWeek = WeekData(startDate: newStartDate)
            loadWeekData()
        }
    }

    func goToCurrentWeek() {
        currentWeek = WeekData(startDate: WeekData.getCurrentWeekStartDate())
        loadWeekData()
    }

    private func loadWeekData() {
        // In a production app, you'd load from a database
        // For now, only current week persists
        let currentWeekStart = Calendar.current.startOfDay(for: WeekData.getCurrentWeekStartDate())
        let selectedWeekStart = Calendar.current.startOfDay(for: currentWeek.weekStartDate)

        if currentWeekStart != selectedWeekStart {
            // Viewing a different week, no saved data
            return
        }

        // Load current week data
        if let savedData = userDefaults.data(forKey: weekDataKey),
           let decodedWeek = try? JSONDecoder().decode(WeekData.self, from: savedData) {
            currentWeek = decodedWeek
        }
    }
}
