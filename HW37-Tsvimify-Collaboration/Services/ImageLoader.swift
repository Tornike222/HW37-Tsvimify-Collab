//
//  ImageLoader.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Temur Chitashvili on 13.06.24.
//

import SwiftUI

//MARK: - ImageLoader
class ImageLoader: ObservableObject {
    //MARK: - Properties
    let url: URL?
    
    @Published var image: UIImage? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    //MARK: - Initialization
    init(url: URL?) {
        self.url = url
    }
    
    //MARK: - Fetch Function
    func fetchImage() {
        
        guard image == nil else { return }
        
        guard let url = url else {
            errorMessage = "Bad Url"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    
                    self?.errorMessage = error.localizedDescription
                    
                } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    
                    self?.errorMessage = "Bad Response"
                    print("Bad Response: \(response.statusCode)")
                    
                } else if let data = data, let image = UIImage(data: data) {
                    
                    self?.image = image
                    
                } else {
                    
                    self?.errorMessage = "Unknown"
                    
                }
            }
        }
        .resume()
    }
}
