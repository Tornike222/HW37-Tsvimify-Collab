//
//  WeatherPageView.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by telkanishvili on 12.06.24.
//

import SwiftUI
import SwiftData

struct WeatherPageView: View {
    //MARK: - Properties
    @StateObject var viewModel: WeatherViewModel
    @Environment(\.modelContext) private var context
    @Query private var locationsModel: [LocationsModel]
    @State var currentLocation: LocationsModel?
    @State private var titleWidth: CGFloat = 0
    
    //MARK: - Body View
    var body: some View {
        NavigationStack {
            VStack {
                citiesMenu
                
                ScrollView {
                    VStack {
                        if let weatherResponse = viewModel.weatherResponse {
                            
                            weatherInfo(weatherResponse: weatherResponse)
                            
                            introStats(weatherResponse: weatherResponse)
                            
                            todaysCard
                            
                            weekForecast
                        }
                    }
                    Spacer()
                }
                .scrollIndicators(.hidden)
            }
            .ignoresSafeArea()
            .background (
                chooseBackground()
            )
        }
        .onAppear(perform: {
            creteDefaultCityTbilisiIfNeeded()
        })
    }
    
    //MARK: - Computed properties and Functions as View
    private var citiesMenu: some View {
        Menu {
            citiesMenuContent
        } label: {
            menuLabelView
        }
        .ignoresSafeArea(.all)
    }
    
    @ViewBuilder
    private var citiesMenuContent: some View {
        citiesView
        
        addNewLocationView
    }
    
    private var citiesView: some View {
        ForEach(locationsModel) { location in
            Button(location.name, action: {
                viewModel.weatherInfoFetcher(lat: location.latitude, lon: location.longitude)
                currentLocation = location
            })
        }
    }
    
    private var addNewLocationView: some View {
        NavigationLink {
            LocationsPageView(locationViewModel: LocationsViewModel())
        } label: {
            Text("Add New Location")
            
            Image("navigate")
        }
    }
    
    private var menuLabelView: some View {
        currentCityBackgroundView
            .overlay {
                currentCityView
            }
    }
    
    private var currentCityBackgroundView: some View {
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
    }
    
    private var currentCityView: some View {
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
    
    private func weatherInfo(weatherResponse: CurrentWeatherModel) -> some View {
        ZStack {
            glassMorphic(width: 342, height: 137)
            
            weatherInfoView(weatherResponse: weatherResponse)
                .frame(height: 135)
                .padding()
        }
    }
    
    private func introStats(weatherResponse: CurrentWeatherModel) -> some View {
        ZStack {
            glassMorphic(width: 342, height: 37)
            
            introStatsView(weatherResponse: weatherResponse)
        }
    }
    
    private var weekForecast: some View {
        ZStack {
            glassMorphic(width: 342, height: 380)
            
            weekForecastView
        }
        .padding(.top, 20)
    }
    
    private func creteDefaultCityTbilisiIfNeeded() {
        if let tbilisiLocation = locationsModel.first(where: { $0.name == "Tbilisi" }) {
            currentLocation = tbilisiLocation
        } else {
            let newTbilisi = LocationsModel(name: "Tbilisi", latitude: 41.7225, longitude: 44.7925)
            context.insert(newTbilisi)
            currentLocation = newTbilisi
        }
        viewModel.weatherInfoFetcher(lat: currentLocation!.latitude, lon: currentLocation!.longitude)
    }
    
    private func shadowWhiteTitle(title: String) -> some View {
        Text(title)
            .font(.title2)
            .foregroundStyle(.white)
            .shadow(radius: 10)
    }
    
    private func glassMorphic(width: CGFloat ,height: CGFloat) -> some View {
        ZStack {
            TransparentBlurView(effect: .systemUltraThinMaterialLight) { view in
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .frame(width: width, height: height)
        .opacity(0.8)
    }
    
    private func introStatsView(weatherResponse: CurrentWeatherModel) -> some View {
        HStack {
            statChipView(iconName: "rainy", value: "\(viewModel.getRainyPercentage())%    ")
            
            Spacer()
                .frame(width: 35)
            
            statChipView(iconName: "humidity", value: "\(weatherResponse.main.humidity)%   ")
            
            Spacer()
                .frame(width: 35)
            
            statChipView(iconName: "wind", value: "\(String(format: "%.1f", weatherResponse.wind.speed))km/h")
        }
    }
    
    private func weatherInfoView(weatherResponse: CurrentWeatherModel) -> some View {
        VStack(spacing: -5) {
            
            Text("\(String(format: "%.1f", weatherResponse.main.temp - 273.15))°")
                .font(.system(size: 60))
                .frame(width: 200, height: 76)
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
    
    private func statChipView(iconName: String, value: String) -> some View {
        HStack(alignment: .center, spacing: 1) {
            Image(iconName)
                .resizable()
                .frame(width: 24, height: 24)
            
            Text(value)
                .bold()
                .minimumScaleFactor(0.4)
                .lineLimit(1)
                .frame(width: 50, height: 35)
        }
        .foregroundStyle(.white)
        
    }
    
    private var todaysCard: some View {
        glassMorphic(width: 342, height: 217)
            .overlay {
                todaysCardContent
            }
            .padding(.top, 22)
    }
    
    private var todaysCardContent: some View {
        VStack(alignment: .leading) {
            if viewModel.filterTodaysWeather?.count ?? 0 >= 4 {
                cardsTitleAndDateView
                    .padding(.top, 12)
                    .padding(.horizontal, 18)
                scrollableListOfWeather
            } else {
                cardsTitleAndDateView
                    .padding(.top, 50)
                    .padding(.horizontal, 18)
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
            
            Text((viewModel.summarizedWeatherResponse?.hourly[0].dt.getDateStringFromUTC() ?? ""))
                .font(.system(size: 18,weight: .regular))
                .foregroundStyle(Color.white)
        }
    }
    
    private var scrollableListOfWeather: some View {
        ScrollView(.horizontal) {
            LazyHStack(content: {
                ForEach(viewModel.filterTodaysWeather ?? []) { hourlyForecast in
                    if  hourlyForecast.id == viewModel.filterTodaysWeather?[0].id {
                        glassMorphic(width: 70, height: 155)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(Color.white)
                                TodaysRowView(hourlyForecast: hourlyForecast)
                            }
                    } else {
                        TodaysRowView(hourlyForecast: hourlyForecast)
                    }
                }
            })
        }
        .padding(.leading, 13)
        .padding(.bottom, 13)
        .scrollIndicators(.hidden)
    }
    
    private var nonScrollableListOfWeather : some View {
        HStack {
            ForEach(viewModel.filterTodaysWeather ?? []) { hourlyForecast in
                if hourlyForecast.id == viewModel.filterTodaysWeather?[0].id {
                    glassMorphic(width: 70, height: 155)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 1)
                            TodaysRowView(hourlyForecast: hourlyForecast)
                        }
                } else {
                    TodaysRowView(hourlyForecast: hourlyForecast)
                }
            }
        }
    }
    
    @ViewBuilder
    private func chooseBackground() -> some View {
        switch viewModel.weatherResponse?.weather[0].main {
        case "Rain":
            RainyAndSnowyBackgroundView(sksFileName: "RainFall.sks", backgroundColorTop: .rainyTop, backgroundColorBottom: .rainyBottom)
        case "Snow":
            RainyAndSnowyBackgroundView(sksFileName: "SnowFall.sks", backgroundColorTop: .snowyTop, backgroundColorBottom: .snowyBottom)
        case "Clear":
            WarmBackgroundView(backgroundColorTop: .sunnyTop, backgroundColorBottom: .sunnyBottom)
        case "Clouds":
            CloudyBackgroundView(backgroundColorTop: .cloudyTop, backgroundColorBottom: .cloudyBottom)
        default :
            WarmBackgroundView(backgroundColorTop: .sunnyTop, backgroundColorBottom: .sunnyBottom)        }
    }
    
    private var weekForecastView: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.sortedWeekData(), id: \.dt) { day in
                HStack {
                    Text(Double(day.dt).dayOfWeek())
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 94, alignment: .leading)
                    
                    weatherIcon(image: day.weather.first?.icon)
                        .padding(.leading, 28)
                    
                    Spacer()
                    
                    dayAndNightTemp(tempAtDay: day.temp.day, tempAtNight: day.temp.night)
                }
                .frame(width: 312, height: 46)
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
            AsyncImage(url: viewModel.getImageUrl(imageName: iconName)) { image in
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
