//
//  LocationsViewModel.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by telkanishvili on 12.06.24.
//

import Foundation
import NetworkPackage

class LocationsViewModel: ObservableObject {
    //MARK: - Published vars
    @Published var locationResponse: [LocationsModel]?
    @Published var weatherResponse: [CurrentWeatherModel]?
    @Published var locations: [LocationsModel]?
    @Published var searchText = ""
    
    //MARK: - Functions
    func fetchLocations() {
        let urlString = "https://api.api-ninjas.com/v1/city?name=\(searchText)&limit=3"
        
        let headers = [ "accept": "application/json",
                        "X-Api-Key": "IxNpKLepyZM0CcMOh6Eseg==IIJn4CUHCitjglOf"]
        
        NetworkService().requestData(urlString: urlString, headers: headers) { (result: [LocationsModel]?, error) in
            if let result = result{
                self.locationResponse = result
            }
        }
    }
    
    func fetchWeather(locations: [LocationsModel]) {
        for index in 0..<locations.count{
            let location = locations[index]
            let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid=159e264bbb707514e8ea1734c14e4169"
            
            NetworkService().requestData(urlString: urlString) { (result: CurrentWeatherModel?, error: Error?) in

                if let result = result {
                    self.locations?[index].weatherName = result.weather.first?.main
                    self.locations?[index].weatherCelsiusDegree = result.main.temp
                }
            }
            
        }
    }
}
