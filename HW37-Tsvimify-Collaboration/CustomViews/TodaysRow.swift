//
//  TodaysRow.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Temur Chitashvili on 13.06.24.
//

import SwiftUI

struct TodaysRow: View {
    let hourlyForecast: HourlyForecast
    
    var body: some View {
        VStack {
            configureHourlyForecastText(with: String(Int(hourlyForecast.temp)) + "°C")
            
            WeatherImageView(url:  URL(string: "https://openweathermap.org/img/wn/\(hourlyForecast.weather[0].icon)@2x.png")!, imageSize: 43)
            
            configureHourlyForecastText(with: hourlyForecast.dt.getTimeStringFromUTC()
            )
        }
        .frame(width: 70, height: 155)
    }
    
    private func configureHourlyForecastText(with text: String) -> some View {
        Text(text)
            .font(.system(size: 18,weight: .regular))
            .foregroundStyle(Color.white)
            .shadow(
                color: Color.primary.opacity(1),
                radius: 10,
                x: -2,
                y: 3
            )
    }
}

