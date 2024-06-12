//
//  CloudsAnimation.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Temur Chitashvili on 12.06.24.
//

import SpriteKit

class CloudsAnimation: SKScene {
    let anchorPointX: Int
    let anchorPointY: Int
    let sksFileName: String
    
    init(anchorPointX: Int, anchorPointY: Int, sksFileName: String) {
        self.anchorPointX = anchorPointX
        self.anchorPointY = anchorPointY
        self.sksFileName = sksFileName
        super.init(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        anchorPoint = CGPoint(x: anchorPointX, y: anchorPointY)
        
        backgroundColor = .clear
        
        let node = SKEmitterNode(fileNamed: sksFileName)!
        
        addChild(node)
        
        node.particlePositionRange.dx = UIScreen.main.bounds.width
    }
}
