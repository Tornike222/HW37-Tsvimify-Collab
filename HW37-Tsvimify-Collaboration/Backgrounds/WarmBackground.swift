//
//  WarmBackground.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Irinka Datoshvili on 12.06.24.
//

import SpriteKit
import SwiftUI

struct WarmBackground: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var animateBirds = false
    let backgroundColorTop: Color
    let backgroundColorBottom: Color
    
    var body: some View {
        ZStack {
            if colorScheme == .light {
                MoonAndSunImages()
                    .overlay { animationViews }
            } else {
                animationViews
                    .overlay { MoonAndSunImages() }
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [backgroundColorTop, backgroundColorBottom]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onAppear {
            animateBirds = true
        }
    }
    
    private var animationViews: some View {
        Group {
            if colorScheme == .dark {
                starsAnimation
            } else {
                birdsFlying()
            }
        }
    }
    
    private var starsAnimation: some View {
        SpriteView(scene: StarsAnimation(sksFileName: "StarsTwinkling.sks"), options: [.allowsTransparency])
            .ignoresSafeArea()
    }
    
    private func birdsFlying() -> some View {
        let delays = [0.0, 0.4, 0.8]
        return GeometryReader { geometry in
            ZStack {
                ForEach(0..<3) { index in
                    Image("bird")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .offset(x: animateBirds ? -geometry.size.width : geometry.size.width, y: CGFloat.random(in: -50...50))
                        .animation(Animation.linear(duration: 4).repeatForever(autoreverses: false).delay(delays[index]), value: animateBirds)
                }
            }
        }
    }
}
