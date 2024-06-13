//
//  WeatherViewModel.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by telkanishvili on 12.06.24.
//

import Foundation
import SwiftData
import NetworkPackage

class WeatherViewModel: ObservableObject {
    @Published var locationResponseModel: LocationsModel?
    @Published var weatherResponse: WeatherResponse?
    @Published var errorMessage: String?
    @Published var weekForecastResponse: WeekForecastResponse?
    
    func fetchWeather(lat: Double, lon: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=159e264bbb707514e8ea1734c14e4169"
        
        NetworkService().requestData(urlString: urlString) { (response: WeatherResponse?, error: Error?) in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            if let response = response {
                self.weatherResponse = response
            } else {
                self.errorMessage = "Failed to load weather data."
            }
        }
    }
    
    func fetchWeekForecast(lat: Double, lon: Double) {
        let urlString = "https://openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=439d4b804bc8187953eb36d2a8c26a02"
        
        NetworkService().requestData(urlString: urlString) { (response: WeekForecastResponse?, error: Error?) in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            if let response = response {
                self.weekForecastResponse = response
            } else {
                self.errorMessage = "Failed to load forecast data."
            }
        }
    }
    
    func dayOfWeek(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    func sortedWeekData() -> [DailyWeather] {
        guard let data = weekForecastResponse?.daily else { return [] }
        let sortedData = data.sorted(by: { (first, second) -> Bool in
            let weekdayFirst = (Calendar.current.component(.weekday, from: Date(timeIntervalSince1970: TimeInterval(first.dt))) + 5) % 7
            let weekdaySecond = (Calendar.current.component(.weekday, from: Date(timeIntervalSince1970: TimeInterval(second.dt))) + 5) % 7
            return weekdayFirst < weekdaySecond
        })
        return sortedData
    }
}
