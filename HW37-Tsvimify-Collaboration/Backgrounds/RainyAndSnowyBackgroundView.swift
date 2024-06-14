//
//  RainyAndSnowyBackgroundView.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Temur Chitashvili on 12.06.24.
//

import SwiftUI
import SpriteKit

struct RainyAndSnowyBackgroundView: View {
    //MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    let sksFileName: String
    let backgroundColorTop: Color
    let backgroundColorBottom: Color
    
    //MARK: - Body View
    var body: some View {
        ZStack {
            animationViews
                .overlay {
                    moonAndSunImages
                }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [backgroundColorTop, backgroundColorBottom]), startPoint: .top, endPoint: .bottom))
    }
    
    //MARK: - View's as computed properties
    private var animationViews: some View {
        Group {
            rainAndSnowFall
            
            cloudsLargeAnimation
            
            cloudsMiniAnimation
        }
    }
    
    
    private var rainAndSnowFall: some View {
        SpriteView(scene: RainAndSnowAnimations(sksFileName: sksFileName),options: [.allowsTransparency])
            .ignoresSafeArea()
    }

    private var cloudsLargeAnimation: some View {
        CloudAnimationView(sksFileName: "CloudsLarge.sks")
    }
    
    private var cloudsMiniAnimation: some View {
        CloudAnimationView(sksFileName: "CloudsMini.sks")
    }
    
    private var moonAndSunImages: some View {
        MoonAndSunImagesView()
    }
}
