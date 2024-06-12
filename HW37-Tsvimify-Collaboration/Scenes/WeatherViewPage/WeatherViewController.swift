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
            Color.blue
                .overlay {
                    VStack {
                        citiesMenu
                        
                        if let weatherResponse = viewModel.weatherResponse {
                            ZStack {
                                glassMorphic(height: 137)
                                
                                weatherInfoView(weatherResponse: weatherResponse)
                                    .frame(height: 135)
                                    .padding()
                            }
                            
                            ZStack {
                                glassMorphic(height: 37)
                                
                                introStatsView(weatherResponse: weatherResponse)
                                    .frame(height: 37)
                            }
                        }
                        Spacer()
                    }
                }
                .ignoresSafeArea()
        }
        .onAppear(perform: {
            if let tbilisiLocation = locationsModel.first(where: { $0.name == "Tbilisi" }) {
                currentLocation = tbilisiLocation
            } else {
                let newTbilisi = LocationsModel(name: "Tbilisi", latitude: 41.7225, longitude: 44.7925)
                context.insert(newTbilisi)
                currentLocation = newTbilisi
            }
            viewModel.fetchWeather(lat: currentLocation!.latitude, lon: currentLocation!.longitude)
        })
    }
    
    var citiesMenu: some View {
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
        .padding(.top, 60)

    }
    
    private func shadowedWhiteTitle(title: String) -> some View {
        Text(title)
            .font(.title2)
            .foregroundStyle(.white)
            .shadow(radius: 10)
    }
    
    func glassMorphic(height: CGFloat) -> some View {
        ZStack {
            TransparentBlurView(effect: .systemUltraThinMaterialLight) { view in
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .frame(width: 342, height: height)
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
    
    func  statChipView(iconName: String, value: String) -> some View {
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
