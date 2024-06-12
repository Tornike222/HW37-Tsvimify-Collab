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
}


