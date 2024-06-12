//
//  CloudyBackground.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Irinka Datoshvili on 12.06.24.
//

import SpriteKit
import SwiftUI

struct CloudyBackground: View {
    @Environment(\.colorScheme) var colorScheme
    let backgroundColorTop: Color
    let backgroundColorBottom: Color
    
    var body: some View {
        ZStack {
            animationViews
                .overlay {
                    MoonAndSunImages()
                }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.cloudyTop, .cloudyBottom]), startPoint: .top, endPoint: .bottom))
    }
    
    private var animationViews: some View {
        Group {
            CloudAnimationView(sksFileName: "CloudsLarge.sks")
            CloudAnimationView(sksFileName: "CloudsMini.sks")
            CloudAnimationView(sksFileName: "CloudsLarge.sks")
        }
    }
}
