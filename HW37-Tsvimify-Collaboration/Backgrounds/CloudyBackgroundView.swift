//
//  CloudyBackgroundView.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Irinka Datoshvili on 12.06.24.
//

import SpriteKit
import SwiftUI

struct CloudyBackgroundView: View {
    //MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    let backgroundColorTop: Color
    let backgroundColorBottom: Color
    
    //MARK: - Body View
    var body: some View {
        ZStack {
            animationViews
                .overlay {
                    MoonAndSunImagesView()
                }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.cloudyTop, .cloudyBottom]), startPoint: .top, endPoint: .bottom))
    }
    
    //MARK: - View's as computed properties
    private var animationViews: some View {
        Group {
            CloudAnimationView(sksFileName: "CloudsLarge.sks")
            CloudAnimationView(sksFileName: "CloudsMini.sks")
            CloudAnimationView(sksFileName: "CloudsLarge.sks")
        }
    }
}
