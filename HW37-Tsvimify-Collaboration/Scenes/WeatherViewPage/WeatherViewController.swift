//
//  WeatherViewController.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by telkanishvili on 12.06.24.
//

import SwiftUI
import SwiftData

struct WeatherViewController: View {
    @StateObject var viewModel: WeatherViewModel
    @Environment(\.modelContext) private var context
    @Query private var locationsModel: [LocationsModel]
    @State var currentLocation: LocationsModel?
    
    var body: some View {
        NavigationStack {
            content
                .ignoresSafeArea()
                .background (
                    chooseBackground()
                )
        }
        .onAppear {
            getTbilisiLocation()
            fetchData()
        }
    }
    
    private var content: some View {
        VStack {
            citiesMenu
            
            currentWeatherInfoCards
                .padding(.top ,30)
            
            todaysCard
            
            Spacer()
        }
    }
    
    private var citiesMenu: some View {
        Menu {
            ForEach(locationsModel) { location in
                Button(location.name, action: {
                    currentLocation?.name = location.name
                    currentLocation?.longitude = location.longitude
                    currentLocation?.latitude = location.latitude
                })
            }
            
            NavigationLink {
                LocationAddViewController(viewModel: LocationAddViewModel())
                    .navigationBarTitle("Locations" , displayMode: .inline)
                
            } label: {
                Text("Add New Location")
                
                Image("navigate")
            }
            
        } label: {
            HStack(content: {
                Spacer()
                
                Image("map")
                
                Spacer()
                    .frame(width: 12)
                
                shadowedWhiteTitle(title: "Tbilisi")
                
                Spacer()
                    .frame(width: 12)
                
                Image("vector")
                
                Spacer()
                    .frame(width: 35)
            })
        }
    }
    
    private func shadowedWhiteTitle(title: String) -> some View {
        Text(title)
            .font(.title2)
            .foregroundStyle(.white)
            .shadow(radius: 10)
    }
    
    private func glassMorphic(height: CGFloat) -> some View {
        ZStack {
            TransparentBlurView(effect: .systemUltraThinMaterialLight) { view in
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .frame(width: 342, height: height)
        .opacity(0.8)
    }
    
    @ViewBuilder
    private var currentWeatherInfoCards: some View {
        if let weatherResponse = viewModel.weatherResponse {
            ZStack {
                glassMorphic(height: 137)
                
                weatherInfoView(weatherResponse: weatherResponse)
                    .frame(height: 135)
            }
            
            ZStack {
                glassMorphic(height: 37)
                
                introStatsView(weatherResponse: weatherResponse)
                    .frame(height: 37)
            }
        }
    }
    
    private func introStatsView(weatherResponse: WeatherResponse) -> some View {
        HStack {
            statChipView(iconName: "rainy", value: "\(weatherResponse.main.humidity)%")
            
            statChipView(iconName: "humidity", value: "\(weatherResponse.main.humidity)%")
            
            statChipView(iconName: "wind", value: "\(String(format: "%.1f", weatherResponse.wind.speed))m/s")
        }
    }
    
    private func weatherInfoView(weatherResponse: WeatherResponse) -> some View {
        VStack(spacing: -5) {
            
            Text("\(String(format: "%.1f", weatherResponse.main.temp - 273.15))°")
                .font(.system(size: 60))
                .frame(width: 150, height: 76)
                .bold()
            
            Text(weatherResponse.weather.first?.description.capitalized ?? "N/A")
                .font(.title2)
                .padding(.bottom)
            
            HStack(spacing: 3) {
                Text("Min:")
                    .font(.subheadline)
                
                Text("\(String(format: "%.1f", weatherResponse.main.tempMin - 273.15))°")
                    .bold()
                    .padding(.trailing)
                
                Text("Max:")
                    .font(.subheadline)
                
                Text("\(String(format: "%.1f", weatherResponse.main.tempMax - 273.15))°")
                    .bold()
            }
        }
        .foregroundStyle(.white)
    }
    
    private func statChipView(iconName: String, value: String) -> some View {
        HStack {
            Image(iconName)
                .resizable()
                .frame(width: 24, height: 24)
                .font(.system(size: 24))
            
            Text(value)
                .bold()
                .font(.title3)
                .minimumScaleFactor(0.4)
                .lineLimit(1)
                .frame(width: 30, height: 30)
        }
        .foregroundStyle(.white)
        .padding()
        .cornerRadius(20)
    }
    
    private var todaysCard: some View {
        glassMorphic(height: 217)
            .overlay {
                todaysCardContent
            }
            .padding(.top, 22)
    }
    
    private var todaysCardContent: some View {
        VStack {
            cardsTitleAndDateView
                .padding(.top, 12)
                .padding(.horizontal, 18)
            
            if viewModel.filterTodaysWeather?.count ?? 0 >= 4 {
                scrollableListOfWeather
            } else {
                nonScrollableListOfWeather
            }
        }
    }
    
    private var cardsTitleAndDateView: some View {
        HStack {
            Text("Today")
                .font(.system(size: 20))
                .foregroundStyle(Color.white)
                .bold()
            
            Spacer()
            
            Text((viewModel.hourlyWeatherResponse?.hourly[0].dt.getDateStringFromUTC() ?? ""))
                .font(.system(size: 18,weight: .regular))
                .foregroundStyle(Color.white)
        }
    }
    
    private var scrollableListOfWeather: some View {
        ScrollView(.horizontal) {
            LazyHStack(content: {
                ForEach(viewModel.filterTodaysWeather ?? []) { hourlyForecast in
                    TodaysRow(hourlyForecast: hourlyForecast)
                }
            })
        }
    }
    
    private var nonScrollableListOfWeather : some View {
        ForEach(viewModel.filterTodaysWeather ?? []) { hourlyForecast in
            TodaysRow(hourlyForecast: hourlyForecast)
        }
    }
    
    @ViewBuilder
    private func chooseBackground() -> some View {
        switch viewModel.weatherResponse?.weather[0].main {
        case "Rain":
            RainyAndSnowyBackground(sksFileName: "RainFall.sks", backgroundColorTop: .rainyTop, backgroundColorBottom: .rainyBottom)
        case "Snow":
            RainyAndSnowyBackground(sksFileName: "SnowFall.sks", backgroundColorTop: .snowyTop, backgroundColorBottom: .snowyBottom)
        case "Clear":
            WarmBackground(backgroundColorTop: .sunnyTop, backgroundColorBottom: .sunnyBottom)
        case "Clouds":
            CloudyBackground(backgroundColorTop: .cloudyTop, backgroundColorBottom: .cloudyBottom)
        default :
            EmptyView()
        }
    }
    
    private func getTbilisiLocation() {
        if let tbilisiLocation = locationsModel.first(where: { $0.name == "Tbilisi" }) {
            currentLocation = tbilisiLocation
        } else {
            let newTbilisi = LocationsModel(name: "Tbilisi", latitude: 41.7225, longitude: 44.7925)
            context.insert(newTbilisi)
            currentLocation = newTbilisi
        }
    }
    
    private func fetchData() {
        viewModel.fetchWeather(lat: currentLocation!.latitude, lon: currentLocation!.longitude)
        viewModel.fetchHourlyWeather(lat: currentLocation!.latitude, lon: currentLocation!.longitude)
    }
}

struct TransparentBlurView: UIViewRepresentable {
    var effect: UIBlurEffect.Style
    var onChange: (UIVisualEffectView) -> ()
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: effect))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        DispatchQueue.main.async {
            onChange(uiView)
        }
    }
}
