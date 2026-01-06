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

    // Gradient colors for card backgrounds - Red themed for prominence
    var gradientColors: [Color] {
        switch conditionId {
        case 200...232:  // Thunderstorm - Deep red to dark coral
            return [
                Color(red: 0.85, green: 0.15, blue: 0.25),  // Deep red
                Color(red: 0.95, green: 0.35, blue: 0.45)   // Dark coral
            ]
        case 300...321, 500...531:  // Drizzle & Rain - Red to rose
            return [
                Color(red: 0.90, green: 0.20, blue: 0.30),  // Vibrant red
                Color(red: 1.0, green: 0.50, blue: 0.60)    // Rose pink
            ]
        case 600...622:  // Snow - Cool red to pink
            return [
                Color(red: 0.95, green: 0.25, blue: 0.35),  // Bright red
                Color(red: 1.0, green: 0.60, blue: 0.70)    // Light pink
            ]
        case 701...781:  // Fog/Mist - Soft red gradient
            return [
                Color(red: 0.90, green: 0.30, blue: 0.35),  // Muted red
                Color(red: 0.98, green: 0.55, blue: 0.60)   // Soft pink
            ]
        case 800:  // Clear - Bright red to orange-red
            return [
                Color(red: 1.0, green: 0.25, blue: 0.25),   // Bright red
                Color(red: 1.0, green: 0.45, blue: 0.35)    // Red-orange
            ]
        case 801:  // Few clouds - Warm red gradient
            return [
                Color(red: 0.95, green: 0.30, blue: 0.30),  // Warm red
                Color(red: 1.0, green: 0.55, blue: 0.50)    // Coral
            ]
        case 802:  // Scattered clouds - Medium red
            return [
                Color(red: 0.90, green: 0.25, blue: 0.30),  // Medium red
                Color(red: 0.98, green: 0.50, blue: 0.55)   // Light coral
            ]
        case 803...804:  // Cloudy - Deep red to rose
            return [
                Color(red: 0.85, green: 0.20, blue: 0.28),  // Deep red
                Color(red: 0.95, green: 0.45, blue: 0.52)   // Rose
            ]
        default:
            return [
                Color(red: 0.90, green: 0.25, blue: 0.30),  // Default red
                Color(red: 1.0, green: 0.55, blue: 0.60)    // Light pink
            ]
        }
    }

    // Accent color for temperature text - Bold red
    var accentColor: Color {
        // All weather conditions use vibrant red
        return Color(red: 0.95, green: 0.15, blue: 0.25)
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
