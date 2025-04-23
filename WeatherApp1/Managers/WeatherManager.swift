//
//  WeatherManager.swift
//  WeatherApp1
//
//  Created by Kshrugal Jain on 5/30/24.
//

import Foundation
import CoreLocation

class WeatherManager {
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url  = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\("4b08ceb025c1df02554949ea3220dd67")&units=metric") else  { fatalError("Missing URL") }
        
        
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data")}
        let DecodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
            
        return DecodedData
    }
    func getForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ForecastResponse {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\("4b08ceb025c1df02554949ea3220dd67")&units=metric") else {
            fatalError("Missing URL")
        }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse) // Use a specific error instead of fatalError
        }

        do {
            let forecastData = try JSONDecoder().decode(ForecastResponse.self, from: data)
            return forecastData
        } catch {
            print("Error decoding forecast data: \(error)") // Print error for debugging
            throw error // Rethrow the error
        }
    }



}

struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse
    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }
    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }
    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}

struct ForecastResponse: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [Forecast]
    let city: City
    
    
    struct Forecast: Decodable {
        let dt: Int
        let main: Main
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let visibility: Int
        let pop: Double
        let rain: Rain?
        let sys: Sys
        let dt_txt: String
    }
    
    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let sea_level: Int
        let grnd_level: Int
        let humidity: Int
        let temp_kf: Double
    }
    
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Clouds: Decodable {
        let all: Int
    }
    
    struct Wind: Decodable {
        let speed: Double
        let deg: Int
        let gust: Double
    }
    
    struct Rain: Decodable {
        let threeHours: Double
        
        enum CodingKeys: String, CodingKey {
            case threeHours = "3h"
        }
    }
    
    struct Sys: Decodable {
        let pod: String
    }
    
    struct City: Decodable {
        let id: Int
        let name: String
        let coord: Coord
        let country: String
        let population: Int
        let timezone: Int
        let sunrise: Int
        let sunset: Int
    }
    
    struct Coord: Decodable {
        let lat: Double
        let lon: Double
    }
}
