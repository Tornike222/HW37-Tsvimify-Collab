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
    @State private var titleWidth: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            Color.blue
                .overlay {
                    VStack {
                    citiesMenu
                    ScrollView {
                        VStack {
                            if let weatherResponse = viewModel.weatherResponse {
                                ZStack {
                                    glassMorphic(width: 342, height: 137)
                                    
                                    weatherInfoView(weatherResponse: weatherResponse)
                                        .frame(height: 135)
                                        .padding()
                                }
            
                                ZStack {
                                    glassMorphic(width: 342, height: 37)
                                    
                                    introStatsView(weatherResponse: weatherResponse)
                                        .frame(height: 37)
                                }
                                
                                ZStack {
                                    glassMorphic(width: 342, height: 380)
                                    
                                    weekForecastView
                                }
                                .padding(.top, 20)
                            }
                        }
                            Spacer()
                        }
                    }
                }
                .ignoresSafeArea()
        }
        .onAppear(perform: {
            //            for i in locationsModel {
            //                context.delete(i)
            //            }
            
            if let tbilisiLocation = locationsModel.first(where: { $0.name == "Tbilisi" }) {
                currentLocation = tbilisiLocation
            } else {
                let newTbilisi = LocationsModel(name: "Tbilisi", latitude: 41.7225, longitude: 44.7925)
                context.insert(newTbilisi)
                currentLocation = newTbilisi
            }
            viewModel.fetchWeather(lat: currentLocation!.latitude, lon: currentLocation!.longitude)
            viewModel.fetchWeekForecast(lat: currentLocation!.latitude, lon: currentLocation!.longitude)
        })
    }
    
    var citiesMenu: some View {
        Menu {
            ForEach(locationsModel) { location in
                Button(location.name, action: {
                    viewModel.fetchWeather(lat: location.latitude, lon: location.latitude)
                    viewModel.fetchWeekForecast(lat: location.latitude, lon: location.latitude)
                    currentLocation = location
                })
            }
            
            NavigationLink {
                LocationAddViewController(locationViewModel: LocationAddViewModel())
                    .navigationBarTitle("Locations" , displayMode: .inline)
                
            } label: {
                Text("Add New Location")
                
                Image("navigate")
            }
            
        } label: {
            HStack{
                Spacer()
                glassMorphic(width: titleWidth + 125, height: 36)
                                    .background(GeometryReader { geometry in
                                        Color.clear.onAppear {
                                            titleWidth = geometry.size.width
                                        }
                                    })
                                    .offset(x: 20)
            }

                        .overlay {
                            HStack{
                                Spacer()
                                
                                Image("map")
                                
                                Spacer()
                                    .frame(width: 12)
                                
                                shadowWhiteTitle(title: currentLocation?.name ?? "")
                                    .background() {
                                        GeometryReader { geometry in
                                            Path { _ in
                                                titleWidth = geometry.size.width
                                            }
                                        }
                                    }
                                Spacer()
                                    .frame(width: 12)
                                
                                Image("vector")
                                
                                Spacer()
                                    .frame(width: 35)
                            }
                        }
        }
        .ignoresSafeArea(.all)
    }
    
    private func shadowWhiteTitle(title: String) -> some View {
        Text(title)
            .font(.title2)
            .foregroundStyle(.white)
            .shadow(radius: 10)
    }
    
    func glassMorphic(width: CGFloat ,height: CGFloat) -> some View {
        ZStack {
            TransparentBlurView(effect: .systemUltraThinMaterialLight) { view in
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .frame(width: width, height: height)
        .opacity(0.8)
    }
    
    func introStatsView(weatherResponse: WeatherResponse) -> some View {
        HStack {
            statChipView(iconName: "rainy", value: "\(weatherResponse.main.humidity)%")
            statChipView(iconName: "humidity", value: "\(weatherResponse.main.humidity)%")
            statChipView(iconName: "wind", value: "\(String(format: "%.1f", weatherResponse.wind.speed))m/s")
        }
    }
    
    func weatherInfoView(weatherResponse: WeatherResponse) -> some View {
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
            Spacer()
        }
        .foregroundStyle(.white)
    }
    
    func statChipView(iconName: String, value: String) -> some View {
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
    
    // MARK: - Weekly weather forecast
    var weekForecastView: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.sortedWeekData(), id: \.dt) { day in
                HStack {
                    Text(viewModel.dayOfWeek(from: day.dt))
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    weatherIcon(image: day.weather.first?.icon)
                    
                    Spacer()
                    
                    dayAndNightTemp(tempAtDay: day.temp.day, tempAtNight: day.temp.night)
                    
                }
                .padding(.horizontal)
                .frame(height: 46)
                .cornerRadius(20)
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 16)
        .frame(height: 350)
    }
    
    private func dayAndNightTemp(tempAtDay: Double, tempAtNight: Double) -> some View {
        HStack {
            ShowTemperature(temp: tempAtDay)
                .foregroundColor(.white)
            
            ShowTemperature(temp: tempAtNight)
                .foregroundColor(.white).opacity(0.5)
        }
        .baselineOffset(8)
        .font(.system(size: 18))
    }
    
    @ViewBuilder
    private func weatherIcon(image: String?) -> some View {
        if let iconName = image {
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(iconName)@2x.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()
            }
            .foregroundColor(.white)
        }
    }
    
    private func ShowTemperature(temp: Double) -> some View {
        HStack(alignment: .top) {
            Text("\(Int(temp))")
            Image("celsius")
                .padding(EdgeInsets(.init(top: 3, leading: -4, bottom: 0, trailing: 0)))
        }
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
