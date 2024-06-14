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
    //MARK: - Properties
    @Published var locationResponseModel: LocationsModel?
    @Published var weatherResponse: CurrentWeatherModel?
    @Published var errorMessage: String?
    @Published var weekForecastResponse: WeeklyWeatherModel?
    @Published var hourlyWeatherResponse: HourlyWeatherModel?

    var filterTodaysWeather: [HourlyForecast]? {
        guard let hourlyWeather = hourlyWeatherResponse else {
            return nil
        }
        if let index = hourlyWeather.hourly.firstIndex(where: { $0.dt.getTimeStringFromUTC() == "23:00" }) {
            return Array(hourlyWeather.hourly.prefix(through: index))
        } else {
            return nil
        }
    }
    
    func weatherInfoFetcher(lat: Double, lon: Double) {
        fetchWeather(lat: lat, lon: lon)
        fetchWeekForecast(lat: lat, lon: lon)
        fetchHourlyWeather(lat: lat, lon: lon)
    }

    func fetchWeather(lat: Double, lon: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=159e264bbb707514e8ea1734c14e4169"
        
        NetworkService().requestData(urlString: urlString) { (response: CurrentWeatherModel?, error: Error?) in
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
        
        NetworkService().requestData(urlString: urlString) { (response: WeeklyWeatherModel?, error: Error?) in
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
    
    func fetchHourlyWeather(lat: Double, lon: Double) {
        let urlString = "https://openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=439d4b804bc8187953eb36d2a8c26a02"
        NetworkService().requestData(urlString: urlString) { (response: HourlyWeatherModel?, error: Error?) in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            if let response = response {
                self.hourlyWeatherResponse = response
            } else {
                self.errorMessage = "Failed to load weather data."
            }
        }
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
