//
//  CloudsAnimationView.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Irinka Datoshvili on 12.06.24.
//

import SpriteKit
import SwiftUI

struct CloudAnimationView: View {
    @Environment(\.colorScheme) var colorScheme
    let sksFileName: String
    
    var body: some View {
        Group {
            SpriteView(scene: CloudsAnimation(anchorPointX: -1, anchorPointY: 0, sksFileName: sksFileName, particleColor: colorScheme == .light ? .white : .gray), options: [.allowsTransparency])
                .ignoresSafeArea()
        }
    }
}
