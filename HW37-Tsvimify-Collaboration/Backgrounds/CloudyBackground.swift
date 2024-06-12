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
    let sksFileName: String
    let backgroundColorTop: Color
    let backgroundColorBottom: Color
    
    var body: some View {
        ZStack {
            animationViews
                .overlay {
                    moonAndSunImages
                }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.cloudyTop, .cloudyBottom]), startPoint: .top, endPoint: .bottom))
    }
    
    private var animationViews: some View {
        Group {
            cloudsLargeAnimation
            
            cloudsMiniAnimation
            
            cloudsLargeAnimation
            
        }
    }
    
    private var cloudsLargeAnimation: some View {
        SpriteView(scene: CloudsAnimation(anchorPointX: -1, anchorPointY: 0, sksFileName: "CloudsLarge.sks",particleColor: colorScheme == .light ? .white: .gray),options: [.allowsTransparency])
            .ignoresSafeArea()
    }
    
    private var cloudsMiniAnimation: some View {
        SpriteView(scene: CloudsAnimation(anchorPointX: -1, anchorPointY: 0, sksFileName: "CloudsMini.sks",particleColor: colorScheme == .light ? .white: .gray),options: [.allowsTransparency])
            .ignoresSafeArea()
    }
    
    private var moonAndSunImages: some View {
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

struct CloudyBackground_Previews: PreviewProvider {
    static var previews: some View {
        CloudyBackground(
            sksFileName: "StarsEmitter",
            backgroundColorTop: .cloudyTop,
            backgroundColorBottom: .cloudyBottom
        )
        .environment(\.colorScheme, .dark)
    }
}
