//
//  LocationsPageView.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by telkanishvili on 12.06.24.
//

import SwiftUI
import SwiftData

struct LocationsPageView: View {
    //MARK: - Properties
    @StateObject var locationViewModel: LocationsViewModel
    @Query private var locations: [LocationsModel]
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                if locationViewModel.searchText.count > 0 {
                    searchSuggestion
                } else {
                    List(locationViewModel.locations ?? locations) { location in
                        cityCell(location: location)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .searchable(text: $locationViewModel.searchText)
            .navigationBarTitle("Locations", displayMode: .large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    toolbarView
                }
            }
            .onAppear {
                locationViewModel.locations = locations
                locationViewModel.fetchWeather(locations: locations)
            }
        }
    }
    
    //MARK: - Computed properties and Functions as View
    private var searchSuggestion: some View {
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
        .onChange(of: locationViewModel.searchText) { _, _ in
            locationViewModel.fetchLocations()
        }
        .onAppear {
            locationViewModel.fetchLocations()
        }
    }
    
    private func cityCell(location: LocationsModel) -> some View {
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
        .background(LinearGradient(gradient: Gradient(colors: [Color("customBlue"), Color("customLightBlue")]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(16)
        .shadow(radius: 5)
        .listRowSeparator(.hidden)
    }
    
    private var toolbarView: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color("customBlack"))
        }
    }
}
