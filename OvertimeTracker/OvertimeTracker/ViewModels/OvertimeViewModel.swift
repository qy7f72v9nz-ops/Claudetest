//
//  OvertimeViewModel.swift
//  OvertimeTracker
//
//  ViewModel for managing overtime data and persistence
//

import Foundation
import Combine
import CoreLocation

class OvertimeViewModel: ObservableObject {
    @Published var currentWeek: WeekData

    private let userDefaults = UserDefaults.standard
    private let weekDataKey = "currentWeekData"
    private let weatherService = WeatherService()
    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()

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

        // Request location and fetch weather when location is available
        setupLocationObserver()
        locationManager.requestLocation()
    }

    private func setupLocationObserver() {
        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] location in
                Task { @MainActor in
                    await self?.fetchWeatherForCurrentWeek(location: location)
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    private func fetchWeatherForCurrentWeek(location: CLLocationCoordinate2D) async {
        // Only fetch weather for today (to save API calls)
        let today = Calendar.current.startOfDay(for: Date())

        for index in currentWeek.entries.indices {
            let entryDate = Calendar.current.startOfDay(for: currentWeek.entries[index].date)

            // Only fetch weather for today's entry
            if entryDate == today && currentWeek.entries[index].weather == nil {
                do {
                    let weather = try await weatherService.fetchWeather(for: location)
                    currentWeek.entries[index].weather = weather
                    saveData()
                } catch {
                    print("Failed to fetch weather: \(error)")
                }
                break
            }
        }
    }

    func updateEntry(at index: Int, minutesBefore: Int, minutesAfter: Int) {
        guard index >= 0 && index < currentWeek.entries.count else { return }
        currentWeek.entries[index].minutesBefore = minutesBefore
        currentWeek.entries[index].minutesAfter = minutesAfter
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
