//
//  LocationAddViewModel.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by telkanishvili on 12.06.24.
//

import Foundation
import NetworkPackage


class LocationAddViewModel: ObservableObject {
    @Published var locationResponse: [LocationsModel]?

    @Published var searchText = "Tbilisi"
    
    func fetchLocations() {
        let urlString = "https://api.api-ninjas.com/v1/city?name=\(searchText)&limit=3"
        
        let headers = [ "accept": "application/json",
                        "X-Api-Key": "IxNpKLepyZM0CcMOh6Eseg==IIJn4CUHCitjglOf"]
        
        NetworkService().requestData(urlString: urlString, headers: headers) { (result: [LocationsModel]?, error) in
            if let result = result{
                self.locationResponse = result
            }
        }
    }

    
}
