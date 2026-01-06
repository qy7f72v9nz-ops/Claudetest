//
//  WeatherData.swift
//  OvertimeTracker
//
//  Weather information for daily entries
//

import Foundation

struct WeatherData: Codable, Equatable {
    let condition: String       // e.g., "Clear", "Rain", "Snow"
    let temperature: Double     // in Celsius
    let conditionId: Int        // OpenWeatherMap condition code

    var emoji: String {
        switch conditionId {
        case 200...232:  // Thunderstorm
            return "⛈️"
        case 300...321:  // Drizzle
            return "🌦️"
        case 500...531:  // Rain
            return "🌧️"
        case 600...622:  // Snow
            return "🌨️"
        case 701...781:  // Atmosphere (fog, mist, etc.)
            return "🌫️"
        case 800:        // Clear
            return "☀️"
        case 801:        // Few clouds
            return "🌤️"
        case 802:        // Scattered clouds
            return "⛅"
        case 803...804:  // Broken/overcast clouds
            return "☁️"
        default:
            return "🌡️"
        }
    }

    var temperatureFormatted: String {
        return "\(Int(temperature.rounded()))°C"
    }
}

// Response structures for OpenWeatherMap API
struct OpenWeatherResponse: Codable {
    let weather: [Weather]
    let main: Main

    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
    }

    struct Main: Codable {
        let temp: Double
    }
}
