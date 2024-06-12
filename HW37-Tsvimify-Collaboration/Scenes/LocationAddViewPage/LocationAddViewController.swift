//
//  LocationAddViewController.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by telkanishvili on 12.06.24.
//

import SwiftUI
import SwiftData


struct LocationAddViewController: View {
    @StateObject var viewModel: LocationAddViewModel
    @Environment(\.modelContext) private var context //arsheexot argchirdebat
    @Query private var locations: [LocationsModel] //arsheexot argchirdebat
    
    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.locationResponse ?? []) { location in
                    Button(action: {
                        context.insert(location)
                    }) {
                        Text(location.name)
                    }
                }
                .searchable(text: $viewModel.searchText)
                .onChange(of: viewModel.searchText) { _, newValue in
                    viewModel.fetchLocations()
                }
                .onAppear {
                    viewModel.fetchLocations()
                }
                
                List(locations) { location in
                    Text(location.name)
                }
                
            }
            .navigationTitle("Locations")
        }
    }
}

//#Preview {
//    LocationAddViewController()
//}
