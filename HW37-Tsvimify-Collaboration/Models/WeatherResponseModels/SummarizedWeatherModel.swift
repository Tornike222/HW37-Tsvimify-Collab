//
//  SummarizedWeatherModel.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by telkanishvili on 14.06.24.
//

import Foundation

struct SummarizedWeatherModel: Decodable {
    let lat: Double
    let lon: Double
    let hourly: [HourlyWeatherModel]
    let daily: [DailyWeatherModel]
}
