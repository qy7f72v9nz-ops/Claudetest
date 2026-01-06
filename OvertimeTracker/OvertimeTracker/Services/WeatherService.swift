//
//  WeatherService.swift
//  OvertimeTracker
//
//  Service for fetching weather data from OpenWeatherMap
//

import Foundation
import CoreLocation

class WeatherService {
    private let apiKey = "f3974c7b04783ac4eddfbb498ea16a15"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(for location: CLLocationCoordinate2D) async throws -> WeatherData {
        // Build URL with parameters
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(location.latitude)"),
            URLQueryItem(name: "lon", value: "\(location.longitude)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "imperial")  // Fahrenheit
        ]

        guard let url = components?.url else {
            throw WeatherError.invalidURL
        }

        // Fetch data
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }

        // Decode response
        let weatherResponse = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)

        guard let weather = weatherResponse.weather.first else {
            throw WeatherError.noWeatherData
        }

        return WeatherData(
            condition: weather.main,
            temperature: weatherResponse.main.temp,
            conditionId: weather.id
        )
    }
}

enum WeatherError: Error {
    case invalidURL
    case invalidResponse
    case noWeatherData
}
