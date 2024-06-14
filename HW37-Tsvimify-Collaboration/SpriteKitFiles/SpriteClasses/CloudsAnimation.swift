//
//  CloudsAnimation.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Temur Chitashvili on 12.06.24.
//

import SpriteKit

class CloudsAnimation: SKScene {
    //MARK: - Properties
    let anchorPointX: Int
    let anchorPointY: Int
    let sksFileName: String
    let particleColor: UIColor
    
    //MARK: - Initialization
    init(anchorPointX: Int, anchorPointY: Int, sksFileName: String, particleColor: UIColor) {
        self.anchorPointX = anchorPointX
        self.anchorPointY = anchorPointY
        self.sksFileName = sksFileName
        self.particleColor = particleColor
        super.init(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: anchorPointX, y: anchorPointY)
        backgroundColor = .clear

        if let node = SKEmitterNode(fileNamed: sksFileName) {
            node.particleColorSequence = nil
            node.particleColorBlendFactor = 1.0
            node.particleColor = particleColor
            addChild(node)
            node.particlePositionRange.dx = UIScreen.main.bounds.width
        }
    }
}
