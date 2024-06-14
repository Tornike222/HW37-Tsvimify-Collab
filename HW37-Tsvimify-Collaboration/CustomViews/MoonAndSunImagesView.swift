//
//  MoonAndSunImagesView.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Irinka Datoshvili on 12.06.24.
//

import SwiftUI

struct MoonAndSunImagesView: View {
    //MARK: - Body View
    var body: some View {
        VStack {
            HStack {
                AdaptiveImageView(light: Image(.sun), dark: Image(.moon))
                
                Spacer()
            }
            .padding(.leading, 13)
            
            Spacer()
        }
    }
}
