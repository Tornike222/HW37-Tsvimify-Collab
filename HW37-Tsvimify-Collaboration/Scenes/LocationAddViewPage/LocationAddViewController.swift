//
//  LocationAddViewController.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by telkanishvili on 12.06.24.
//

import SwiftUI
import SwiftData

struct LocationAddViewController: View {
    @StateObject var locationViewModel: LocationAddViewModel
    @Environment(\.modelContext) private var context
    @Query private var locations: [LocationsModel]
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        NavigationStack {
            VStack {
                if locationViewModel.searchText.count > 0 {
                    List(locationViewModel.locationResponse ?? []) { location in
                        Button(action: {
                            context.insert(location)
                            locationViewModel.locations?.append(location)
                            locationViewModel.fetchWeather(locations: locations)
                            locationViewModel.searchText = ""
                        }) {
                            Text(location.name)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                    .onChange(of: locationViewModel.searchText) { _, newValue in
                        locationViewModel.fetchLocations()
                    }
                    .onAppear {
                        locationViewModel.fetchLocations()
                    }
                } else {
                    List(locationViewModel.locations ?? locations) { location in
                        HStack {
                            Spacer()
                                .frame(width: 10)
                            
                            VStack(alignment: .leading) {
                                Text(location.name)
                                    .font(.system(size: 25, weight: .bold))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                    .frame(height: 7)
                                
                                Text(location.weatherName ?? "")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            Text("\(String(format: "%.1f", (location.weatherCelsiusDegree ?? 273.15) - 273.15))°")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                            
                            Spacer()
                                .frame(width: 5)
                        }
                        .padding(20)
                        .background(LinearGradient(gradient: Gradient(colors: [Color("blue"), Color("lightBlue")]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(16)
                        .shadow(radius: 5)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                    
                }
            }
            .searchable(text: $locationViewModel.searchText)
            .navigationBarTitle("Locations", displayMode: .large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("black"))
                    }
                }
            }
            .onAppear {
                locationViewModel.locations = locations
                locationViewModel.fetchWeather(locations: locations)
            }
        }
    }
}
