//
//  StarsAnimation.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by Irinka Datoshvili on 12.06.24.
//

import SpriteKit

class StarsAnimation: SKScene {
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
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .clear
        
        if let node = SKEmitterNode(fileNamed: sksFileName) {
            node.particlePositionRange.dx = UIScreen.main.bounds.width
            node.particlePositionRange.dy = UIScreen.main.bounds.height
            addChild(node)
        }
    }
}
