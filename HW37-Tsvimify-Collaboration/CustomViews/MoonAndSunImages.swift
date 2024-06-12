//
//  MoonAndSunImages.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Irinka Datoshvili on 12.06.24.
//

import SwiftUI

struct MoonAndSunImages: View {
    var body: some View {
        VStack {
            HStack {
                AdaptiveImage(light: Image(.sun), dark: Image(.moon))
                
                Spacer()
            }
            .padding(.leading, 13)
            
            Spacer()
        }
    }
}
