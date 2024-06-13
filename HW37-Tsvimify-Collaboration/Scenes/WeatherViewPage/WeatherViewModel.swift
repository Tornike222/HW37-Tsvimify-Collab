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
    @Published var hourlyWeatherResponse: HourlyWeatherResponse?
    @Published var errorMessage: String?

    
    // MARK: Computed Property
       var filterTodaysWeather: [HourlyForecast]? {
           guard let hourlyWeather = hourlyWeatherResponse else {
               return nil
           }
           if let index = hourlyWeather.hourly.firstIndex(where: { $0.dt.getTimeStringFromUTC() == "00:00" }) {
               return Array(hourlyWeather.hourly.prefix(through: index))
           } else {
               return nil
           }
       }
    
    //MARK: Fetch Datas
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
    
    func fetchHourlyWeather(lat: Double, lon: Double) {
        let urlString = "https://openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=439d4b804bc8187953eb36d2a8c26a02"
        NetworkService().requestData(urlString: urlString) { (response: HourlyWeatherResponse?, error: Error?) in
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
}


