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
            Text(String(Int(hourlyForecast.temp)) + "°C")
                .font(.system(size: 18,weight: .regular))
                .foregroundStyle(Color.white)
                .shadow(
                       color: Color.primary.opacity(1),
                       radius: 10,
                       x: -2,
                       y: 3
                   )
            
            WeatherImageView(url:  URL(string: "https://openweathermap.org/img/wn/\(hourlyForecast.weather[0].icon)@2x.png")!, imageSize: 43)
       
            Text(hourlyForecast.dt.getTimeStringFromUTC())
                .font(.system(size: 18,weight: .regular))
                .foregroundStyle(Color.white)
                .shadow(
                       color: Color.primary.opacity(1),
                       radius: 10,
                       x: -2,
                       y: 3
                   )
        }
        .frame(width: 70, height: 155)
        .padding(.bottom, 50)
    }
}
