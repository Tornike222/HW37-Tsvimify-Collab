//
//  WeatherImageView.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Temur Chitashvili on 13.06.24.
//

import SwiftUI

struct WeatherImageView: View {
    //MARK: - Properties
    @StateObject var imageLoader: ImageLoader
    let imageSize: CGFloat
    
    //MARK: - Initialization
    init(url: URL, imageSize: CGFloat) {
        self._imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
        self.imageSize = imageSize
    }
    
    //MARK: - Body View
    var body: some View {
        Group {
            if imageLoader.image != nil {
                Image(uiImage: imageLoader.image!)
                    .resizable()
                    .cornerRadius(5)
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
                    .clipped()
            } else if imageLoader.errorMessage != nil {
                Text(imageLoader.errorMessage!)
                    .foregroundColor(.red)
                    .frame(width: imageSize, height: imageSize)
            } else {
                ProgressView()
                    .frame(width: imageSize, height: imageSize)
            }
        }
        .onAppear {
            imageLoader.fetchImage()
        }
    }
}
