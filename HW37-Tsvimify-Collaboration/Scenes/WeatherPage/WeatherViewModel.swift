//
//  WeatherViewModel.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by telkanishvili on 12.06.24.
//

import Foundation
import NetworkPackage

class WeatherViewModel: ObservableObject {
    //MARK: - Properties
    @Published var locationResponseModel: LocationsModel?
    @Published var weatherResponse: CurrentWeatherModel?
    @Published var summarizedWeatherResponse: SummarizedWeatherModel?

    
    //MARK: - computed property
    var filterTodaysWeather: [HourlyWeatherModel]? {
        guard let hourlyWeather = summarizedWeatherResponse else {
            return nil
        }
        if let index = hourlyWeather.hourly.firstIndex(where: { $0.dt.getTimeStringFromUTC() == "23:00" }) {
            return Array(hourlyWeather.hourly.prefix(through: index))
        } else {
            return nil
        }
    }
    
    //MARK: - Functions
    func weatherInfoFetcher(lat: Double, lon: Double) {
        fetchWeather(lat: lat, lon: lon)
        fetchSummarizedWeather(lat: lat, lon: lon)
    }
    
    func getRainyPercentage() -> Int {
        Int(summarizedWeatherResponse?.daily.first?.rain?.rainPercentage ?? 0 ) * 100 > 100 ? 100 : Int(summarizedWeatherResponse?.daily.first?.rain?.rainPercentage ?? 0)
    }
    
    func getImageUrl(imageName: String) -> URL {
        URL(string: "https://openweathermap.org/img/wn/\(imageName)@2x.png")!
    }
    
    func sortedWeekData() -> [DailyWeatherModel] {
        guard let data = summarizedWeatherResponse?.daily else { return [] }
        let sortedData = data.sorted(by: { (first, second) -> Bool in
            let weekdayFirst = (Calendar.current.component(.weekday, from: Date(timeIntervalSince1970: TimeInterval(first.dt))) + 5) % 7
            let weekdaySecond = (Calendar.current.component(.weekday, from: Date(timeIntervalSince1970: TimeInterval(second.dt))) + 5) % 7
            return weekdayFirst < weekdaySecond
        })
        return sortedData
    }

    //MARK: - Fetch functions
    func fetchWeather(lat: Double, lon: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=159e264bbb707514e8ea1734c14e4169"
        
        NetworkService().requestData(urlString: urlString) { (response: CurrentWeatherModel?, error: Error?) in
            if let response = response {
                self.weatherResponse = response
            }
        }
    }
    
    private func fetchSummarizedWeather(lat: Double, lon: Double) {
        let urlString = "https://openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=439d4b804bc8187953eb36d2a8c26a02"
        
        NetworkService().requestData(urlString: urlString) { (response: SummarizedWeatherModel?, error: Error?) in
            if let response = response {
                self.summarizedWeatherResponse = response
            }
        }
    }
}
