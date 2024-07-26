//
//  ForecastWeatehr.swift
//  Final - Weather app
//
//  Created by Luka Khokhiashvili on 14.07.24.
//

import Foundation

// MARK: - ForecastWeather
struct ForecastWeather: Codable {
    let cod: String
    let message, cnt: Int
    let list: [FList]
    let city: FCity
}

// MARK: - FCity
struct FCity: Codable {
    let id: Int
    let name: String
    let coord: FCoord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - FCoord
struct FCoord: Codable {
    let lat, lon: Double
}

// MARK: - FList
struct FList: Codable {
    let dt: Int
    let main: FMainClass
    let weather: [FWeather]
    let clouds: FClouds
    let wind: FWind
    let visibility: Int
    let pop: Double
    let sys: FSys
    let dtTxt: String
    let rain: FRain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain
    }
}

// MARK: - FClouds
struct FClouds: Codable {
    let all: Int
}

// MARK: - FMainClass
struct FMainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - FRain
struct FRain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - FSys
struct FSys: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - FWeather
struct FWeather: Codable {
    let id: Int
    let main: MainEnum
    let description: Description
    let icon: String
}

enum Description: String, Codable {
    case brokenFClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewFClouds = "few clouds"
    case lightFRain = "light rain"
    case moderateRain = "moderate rain"
    case overcastFClouds = "overcast clouds"
    case scatteredFClouds = "scattered clouds"
//    case unknown
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let description = try container.decode(String.self)
//        self = Description(rawValue: description) ?? .unknown
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encode(self.rawValue)
//    }
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - FWind
struct FWind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
