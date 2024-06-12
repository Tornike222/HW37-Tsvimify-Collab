//
//  AdaptiveImage.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Temur Chitashvili on 12.06.24.
//

import SwiftUI

struct AdaptiveImage: View {
    @Environment(\.colorScheme) var colorScheme
    
    let light: Image
    let dark: Image

    @ViewBuilder var body: some View {
        if colorScheme == .light {
            light
                .resizable()
                .frame(width: 128, height: 132)
                .foregroundColor(.white)
        } else {
            dark
                .resizable()
                .frame(width: 128, height: 132)
                .foregroundColor(.white)
        }
    }
}
