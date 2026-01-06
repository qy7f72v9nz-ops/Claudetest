//
//  WeatherData.swift
//  OvertimeTracker
//
//  Weather information for daily entries
//

import Foundation
import SwiftUI

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

    // Gradient colors for card backgrounds
    var gradientColors: [Color] {
        switch conditionId {
        case 200...232:  // Thunderstorm - Dark purple to gray
            return [
                Color(red: 0.48, green: 0.41, blue: 0.93),  // Purple
                Color(red: 0.62, green: 0.58, blue: 0.75)   // Lighter purple-gray
            ]
        case 300...321, 500...531:  // Drizzle & Rain - Cool blues
            return [
                Color(red: 0.29, green: 0.56, blue: 0.89),  // Deep blue
                Color(red: 0.53, green: 0.75, blue: 0.95)   // Light blue
            ]
        case 600...622:  // Snow - Icy white to light blue
            return [
                Color(red: 0.89, green: 0.95, blue: 0.98),  // Icy white
                Color(red: 0.71, green: 0.91, blue: 0.94)   // Soft cyan
            ]
        case 701...781:  // Fog/Mist - Neutral grays
            return [
                Color(red: 0.82, green: 0.85, blue: 0.88),  // Light gray
                Color(red: 0.92, green: 0.93, blue: 0.95)   // Very light gray
            ]
        case 800:  // Clear - Warm sunny gradient
            return [
                Color(red: 1.0, green: 0.84, blue: 0.0),    // Golden yellow
                Color(red: 1.0, green: 0.95, blue: 0.61)    // Light yellow
            ]
        case 801:  // Few clouds - Warm with hint of blue
            return [
                Color(red: 1.0, green: 0.91, blue: 0.51),   // Soft yellow
                Color(red: 0.85, green: 0.92, blue: 0.98)   // Light blue
            ]
        case 802:  // Scattered clouds - Balanced
            return [
                Color(red: 0.85, green: 0.92, blue: 0.98),  // Light blue
                Color(red: 0.92, green: 0.93, blue: 0.95)   // Light gray
            ]
        case 803...804:  // Cloudy - Cool grays
            return [
                Color(red: 0.73, green: 0.78, blue: 0.82),  // Gray-blue
                Color(red: 0.88, green: 0.90, blue: 0.92)   // Light gray
            ]
        default:
            return [
                Color(red: 0.95, green: 0.95, blue: 0.95),  // Neutral light gray
                Color(red: 1.0, green: 1.0, blue: 1.0)      // White
            ]
        }
    }

    // Accent color for temperature text
    var accentColor: Color {
        switch conditionId {
        case 200...232:  // Thunderstorm
            return Color(red: 0.48, green: 0.41, blue: 0.93)
        case 300...321, 500...531:  // Rain
            return Color(red: 0.29, green: 0.56, blue: 0.89)
        case 600...622:  // Snow
            return Color(red: 0.53, green: 0.81, blue: 0.92)
        case 701...781:  // Fog
            return Color(red: 0.62, green: 0.65, blue: 0.68)
        case 800:  // Clear/Sunny
            return Color(red: 1.0, green: 0.65, blue: 0.0)
        case 801:  // Few clouds
            return Color(red: 1.0, green: 0.75, blue: 0.0)
        case 802:  // Scattered clouds
            return Color(red: 0.29, green: 0.56, blue: 0.89)
        case 803...804:  // Cloudy
            return Color(red: 0.56, green: 0.60, blue: 0.64)
        default:
            return Color.gray
        }
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
