//
//  CurrentWeatherModel.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by telkanishvili on 12.06.24.
//

import Foundation
struct WeatherResponse: Decodable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let timezone: Int
    let name: String
}

struct Weather: Decodable {
    let main: String
    let description: String
}

struct Main: Decodable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
}

struct Wind: Decodable {
    let speed: Double
}

struct Clouds: Decodable {
    let all: Int
}
