//
//  TransparentBlurView.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by telkanishvili on 14.06.24.
//

import SwiftUI

struct TransparentBlurView: UIViewRepresentable {
    //MARK: - Properties
    var effect: UIBlurEffect.Style
    var onChange: (UIVisualEffectView) -> ()
    
    //MARK: - Functions
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: effect))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        DispatchQueue.main.async {
            onChange(uiView)
        }
    }
}
