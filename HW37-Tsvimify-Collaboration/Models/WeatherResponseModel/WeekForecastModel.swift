//
//  WeekForecastModel.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Irinka Datoshvili on 13.06.24.
//

import Foundation

struct WeekForecastResponse: Decodable {
    let daily: [DailyWeather]
}

struct DailyWeather: Decodable {
    let dt: Int
    let temp: Temperature
    let weather: [Weather]
}

struct Temperature: Decodable {
    let day: Double
    let night: Double

}
