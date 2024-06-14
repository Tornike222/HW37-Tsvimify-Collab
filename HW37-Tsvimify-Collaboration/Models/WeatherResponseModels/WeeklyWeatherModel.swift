//
//  WeeklyWeatherModel.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Irinka Datoshvili on 13.06.24.
//

import Foundation

struct WeeklyWeatherModel: Decodable {
    let daily: [DailyWeather]
}

struct DailyWeather: Decodable {
    let dt: Int
    let temp: Temperature
    let weather: [WeatherInfo]
    let rain: Rain?
}

struct Temperature: Decodable {
    let day: Double
    let night: Double
}

struct Rain: Decodable {
    let rainPercentage: Double?

    enum CodingKeys: String, CodingKey {
        case rainPercentage = "1h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let rainPercentage = try? container.decode(Double.self) {
            self.rainPercentage = rainPercentage
        } else if let dictionary = try? container.decode([String: Double].self) {
            self.rainPercentage = dictionary["1h"]
        } else {
            self.rainPercentage = nil
        }
    }
}

struct WeatherInfo: Decodable {
    let id: Int
    let icon: String
}


