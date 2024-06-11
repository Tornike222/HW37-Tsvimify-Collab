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
    
    @Environment(\.modelContext) private var context //arsheexot argchirdebat
    @Query private var locationsModel: [LocationsModel] //arsheexot argchirdebat
    @State var currentLocation: LocationsModel? //default mnishvneloba gichiravs tavidan aq da daapdatebulic aq gamogichndebat samomavlod
    
    var body: some View {
        NavigationStack {
            Color.blue
                .overlay {
                    VStack {
                        
                        citiesMenu
                        
                        Spacer()
                        //aq shegidzliat werot kodi
                        
                        Text(currentLocation?.name ?? "")
                        
                        weekDays(day: "orshabati") //magalitistvis
                        
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
    
    //magaliti rogor unda gaitanot reusable componentebi
    private func weekDays(day: String) -> some View {
        Text(day)
            .font(.title)
            .foregroundStyle(.white)
    }
    
    private func shadowedWhiteTitle(title: String) -> some View {
        Text(title)
            .font(.title2)
            .foregroundStyle(.white)
            .shadow(radius: 10)
    }}
//
#Preview {
    WeatherViewController(viewModel: WeatherViewModel())
}
