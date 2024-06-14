//
//  HourlyWeatherModel.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Temur Chitashvili on 13.06.24.
//

import Foundation

struct HourlyWeatherModel: Decodable {
    let lat: Double
    let lon: Double
    let hourly: [HourlyForecast]
}

struct HourlyForecast: Decodable, Identifiable {
    let dt: Double
    let temp: Double
    let weather: [WeatherInformation]
    
    var id: Double {
        return dt
    }
}

struct WeatherInformation: Decodable {
    let id: Int
    let icon: String
}


