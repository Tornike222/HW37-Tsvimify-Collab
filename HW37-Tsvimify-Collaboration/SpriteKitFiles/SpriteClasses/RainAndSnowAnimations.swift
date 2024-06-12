//
//  RainAnimation.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Temur Chitashvili on 12.06.24.
//

import SpriteKit

class RainAndSnowAnimations: SKScene {
    let sksFileName: String
    
    init(sksFileName: String) {
        self.sksFileName = sksFileName
        super.init(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        backgroundColor = .clear
        
        
        let node = SKEmitterNode(fileNamed: sksFileName)!
        
        addChild(node)
        
        node.particlePositionRange.dx = UIScreen.main.bounds.width
    }
}
